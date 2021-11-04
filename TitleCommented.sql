ALTER TABLE movies                                                                          
ADD COLUMN IF NOT EXISTS lexemesTitle tsvector;-- Adding a column if it does not yet exist
UPDATE movies
SET lexemesTitle = to_tsvector(Title);-- Making the column that was just added a column for the text processing lexemes function
ALTER TABLE movies                                                                 
ADD COLUMN IF NOT EXISTS rank3 float4;-- Adding the rank column if it does not yet exist
UPDATE movies                                          
SET rank3 = ts_rank(lexemesTitle,plainto_tsquery((
SELECT Title FROM movies WHERE url='interstellar')
));-- Making the rank column base its ranking off the text processing results from the earlier column
CREATE TABLE IF NOT EXISTS recommendationsBasedOnTitleField AS
SELECT url, rank3 FROM movies WHERE rank3 > 0.0000001 ORDER BY rank3 DESC LIMIT 50;-- Making a table with the top 50 results based on the ranking
\copy (SELECT * FROM recommendationsBasedOnTitleField) to '/home/pi/RSL/top50title.csv' WITH csv;-- Printing the results to a csv file

