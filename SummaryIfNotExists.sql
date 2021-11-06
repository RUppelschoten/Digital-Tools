ALTER TABLE movies                                                                          
ADD COLUMN IF NOT EXISTS lexemesSummary tsvector;
UPDATE movies
SET lexemesSummary = to_tsvector(Summary);
ALTER TABLE movies                                                                 
ADD COLUMN IF NOT EXISTS rank float4;
UPDATE movies                                          
SET rank = ts_rank(lexemesSummary,plainto_tsquery((
SELECT Summary FROM movies WHERE url='interstellar')
));
CREATE TABLE IF NOT EXISTS recommendationsBasedOnSummaryField5 AS
SELECT url, rank FROM movies WHERE rank > 0.90 ORDER BY rank DESC LIMIT 50;
\copy (SELECT * FROM recommendationsBasedOnSummaryField5) to '/home/pi/RSL/top50recommendations5.csv' WITH csv;

