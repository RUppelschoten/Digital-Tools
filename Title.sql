ALTER TABLE movies                                                                          
ADD lexemesTitle tsvector;
UPDATE movies
SET lexemesTitle = to_tsvector(Title);
ALTER TABLE movies                                                                 
ADD rank3 float4;
UPDATE movies                                          
SET rank3 = ts_rank(lexemesTitle,plainto_tsquery((
SELECT Title FROM movies WHERE url='interstellar')
));
CREATE TABLE recommendationsBasedOnTitleField AS
SELECT url, rank3 FROM movies WHERE rank3 > 0.0000001 ORDER BY rank3 DESC LIMIT 50;
\copy (SELECT * FROM recommendationsBasedOnTitleField) to '/home/pi/RSL/top50title.csv' WITH csv;

