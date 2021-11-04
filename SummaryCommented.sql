ALTER TABLE movies                                                                         
ADD COLUMN IF NOT EXISTS lexemesSummary tsvector; -- Adding a column if it does not yet exist
UPDATE movies
SET lexemesSummary = to_tsvector(Summary); -- Making the column that was just added a column for the text processing lexemes function
ALTER TABLE movies                                                                 
ADD COLUMN IF NOT EXISTS rank float4; -- Adding the rank column if it does not yet exist
UPDATE movies                                          
SET rank = ts_rank(lexemesSummary,plainto_tsquery((
SELECT Summary FROM movies WHERE url='interstellar')
)); -- Making the rank column base its ranking off the text processing results from the earlier column
CREATE TABLE IF NOT EXISTS recommendationsBasedOnSummaryField5 AS
SELECT url, rank FROM movies WHERE rank > 0.90 ORDER BY rank DESC LIMIT 50; -- Making a table with the top 50 results based on the ranking
\copy (SELECT * FROM recommendationsBasedOnSummaryField5) to '/home/pi/RSL/top50recommendations5.csv' WITH csv; -- Printing the results to a csv file

