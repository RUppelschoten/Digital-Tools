ALTER TABLE movies                                                                          
ADD lexemesStarring tsvector;
UPDATE movies
SET lexemesStarring = to_tsvector(Starring);
ALTER TABLE movies                                                                 
ADD rank2 float4;
UPDATE movies                                          
SET rank = ts_rank(lexemesStarring,plainto_tsquery((
SELECT Starring FROM movies WHERE url='interstellar')
));
CREATE TABLE recommendationsBasedOnStarringField2 AS
SELECT url, rank2 FROM movies WHERE rank2 > 0.005 ORDER BY rank2 DESC LIMIT 50;
\copy (SELECT * FROM recommendationsBasedOnStarringField2) to '/home/pi/RSL/top50starring.csv' WITH csv;

