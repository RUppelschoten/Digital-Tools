#importing a library used for opening the csv file and one for counting the number of occurances in a dictionary
import csv
from collections import Counter

#opening the csv file
with open('userReviews.csv', newline='') as reviews:
    reader = csv.reader(reviews, delimiter=';')
    data = list(reader)

#looking into the data structure of the file, this shows the first row and as a test I printed the first movie name
print(data[0])
print(data[1][0])

#getting started on X, which will be author names
X = list ()

for i in data:
    X.append(i[2])

#i decided to change a lot of the print functions to len so they take up less space after first checking if they work
print(len(X))

#changing the nested list to a dictionary to do step Y and Z
d1={x[2]:{'movieName': x[0], 'rating': x[1]} for x in data}

#checking if it correctly changed
print(d1)

#for Y i decided to print multiple results, a general result of all people that reviewed my favorite movie interstellar + their rating, just the names. Names + rating for those who rated it a 10, just the names.
Y = []
Ynames = []
Ypositive = []
Yposnames = []

#the actual code for doing Y, this was a lot of trial and error but what it does now is look if the moviename is interstellar, if yes it prints the name of the reviewer, movie name (interstellar), movie rating. Then the info gets added to Y and Ynames. Then with an extra if statement only the 10 ratings remain and those are added to Ypositive and Yposnames
for i, info in d1.items():
    if info['movieName'] == 'interstellar':
        print("\nName:", i)
        
        for key in info:
            print(key + ':', info[key])
        Y.append(i + " " + info[key])
        Ynames.append(i)
        if info['rating'] == '10':
            Ypositive.append(i + " " + info[key])
            Yposnames.append(i)
print(Y)

print(Ynames)

print(Ypositive)

print(Yposnames)

#getting started with Z
Z = []

#if authorname is in the list of people who rated interstellar a 10 AND the moviename is NOT interstellar add the moviename to Z.
for i in data:
    if i[2] in Yposnames:
       if i[0] != 'interstellar':
            Z.append(i[0])

print(Z)

#merging duplicate values from the list together by turning it into a dictionary and adding a count to the number of times they were in Z
Z2 = dict(Counter(Z))
print(Z2)

#the final step is sorting the values in Z2 so it ends up being a list of the amount of times people that rated interstellar a 10 rated another movie.
Z3 = sorted(Z2.items(), key=lambda x: x[1], reverse=True)
print(Z3)

f = open('output.txt', 'w')
print(Z3, file=f)