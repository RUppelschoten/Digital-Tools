ALTER TABLE movies                                                                          
ADD COLUMN IF NOT EXISTS lexemesStarring tsvector;-- Adding a column if it does not yet exist
UPDATE movies
SET lexemesStarring = to_tsvector(Starring);-- Making the column that was just added a column for the text processing lexemes function
ALTER TABLE movies                                                                 
ADD COLUMN IF NOT EXISTS rank2 float4;-- Adding the rank column if it does not yet exist
UPDATE movies                                          
SET rank = ts_rank(lexemesStarring,plainto_tsquery((
SELECT Starring FROM movies WHERE url='interstellar')
));-- Making the rank column base its ranking off the text processing results from the earlier column
CREATE TABLE IF NOT EXISTS recommendationsBasedOnStarringField2 AS
SELECT url, rank2 FROM movies WHERE rank2 > 0.005 ORDER BY rank2 DESC LIMIT 50;-- Making a table with the top 50 results based on the ranking
\copy (SELECT * FROM recommendationsBasedOnStarringField2) to '/home/pi/RSL/top50starring.csv' WITH csv;-- Printing the results to a csv file

