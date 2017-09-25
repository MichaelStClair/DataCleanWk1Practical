# Install Swirl
install.packages("swirl")

# Make sure version is 2.2.21 or higher
packageVersion("swirl")

# Load the package
library(swirl)

# Get the interactive course
install_from_swirl("Getting and Cleaning Data")

# Begin (ESC key when you want to exit)
swirl()

#| -- Typing skip() allows you to skip the current question.
#| -- Typing play() lets you experiment with R on your own; swirl will ignore what you do...
#| -- UNTIL you type nxt() which will regain swirl's attention.
#| -- Typing bye() causes swirl to exit. Your progress will be saved.
#| -- Typing main() returns you to swirl's main menu.
#| -- Typing info() displays these options again.

# I've created a variable called path2csv, which contains the full file path to the dataset. Call read.csv() with two
# arguments, path2csv and stringsAsFactors = FALSE, and save the result in a new variable called mydf. Check ?read.csv
# if you need help.

mydf <- read.csv(path2csv, stringsAsFactors = FALSE)

# Use dim() to look at the dimensions of mydf

dim(mydf)

# Now use head() to preview the data

head(mydf)

# The dplyr package was automatically installed (if necessary) and loaded at the beginning of this lesson. Normally,
# this is something you would have to do on your own. Just to build the habit, type library(dplyr) now to load the
# package again.

library(dplyr)

# It's important that you have dplyr version 0.4.0 or later. To confirm this, type packageVersion("dplyr").

# The first step of working with data in dplyr is to load the data into what the package authors call a 'data frame tbl'
# or 'tbl_df'. Use the following code to create a new tbl_df called cran: cran <- tbl_df(mydf).

cran <- tbl_df(mydf)

# To avoid confusion and keep things running smoothly, let's remove the original data frame from your workspace with
# rm("mydf").

rm("mydf")

# From ?tbl_df, "The main advantage to using a tbl_df over a regular data frame is the printing." Let's see what is
# meant by this. Type cran to print our tbl_df to the console.

# Mike: A pretty formatted table appeared

# According to the "Introduction to dplyr" vignette written by the package authors, "The dplyr philosophy is to have
# small functions that each do one thing well." Specifically, dplyr supplies five 'verbs' that cover most fundamental
# data manipulation tasks: select(), filter(), arrange(), mutate(), and summarize().

# As may often be the case, particularly with larger datasets, we are only interested in some of the variables. 
# Use select(cran, ip_id, package, country) to select only the ip_id, package, and country variables 
# from the cran dataset.

# The first thing to notice is that we don't have to type cran$ip_id, cran$package, and cran$country, as we normally
# would when referring to columns of a data frame. The select() function knows we are referring to columns of the cran
# dataset.

# Recall that in R, the `:` operator provides a compact notation for creating a sequence of numbers. 
# For example, try 5:20.

5:20
# [1]  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20

# Normally, this notation is reserved for numbers, but select() allows you to specify a sequence of columns this way,
# which can save a bunch of typing. Use select(cran, r_arch:country) to select all columns starting from r_arch and
# ending with country.

# Mike:  This selected those two columns and all the columns in between from the original order
# Mike:  This also works in the reverse and the column order is reversed

# Instead of specifying the columns we want to keep, we can also specify the columns we want to throw away. To see how
# this works, do select(cran, -time) to omit the time column.

select (cran, -time)

# Mike: that worked nicely.

# Use this knowledge to omit all columns X:size using select()
select(cran, -(X:size))

# Use filter(cran, package == "swirl") to select all rows for which the package variable is equal to "swirl". 
# Be sure to use two equals signs side-by-side!

filter(cran, package == "swirl")

# Edit your previous call to filter() to instead return rows corresponding to users in "IN" (India) running an R version
# that is less than or equal to "3.0.2". The up arrow on your keyboard may come in handy here. Don't forget your double
# quotes!

filter(cran, r_version <= "3.0.2", country == "IN")

# Our last two calls to filter() requested all rows for which some condition AND another condition were TRUE. We can
# also request rows for which EITHER one condition OR another condition are TRUE. 
# For example, filter(cran, country == "US" | country == "IN") will gives us all rows 
# for which the country variable equals either "US" or "IN". Give it | go.

filter(cran, country == "US" | country == "IN")
# Mike: Yep, that worked.

# Now, use filter() to fetch all rows for which size is strictly greater than (>) 100500 (no quotes, since size is
# numeric) AND r_os equals "linux-gnu". Hint: You are passing three arguments to filter(): the name of the dataset, the
# first condition, and the second condition

filter(cran, size > 100500, r_os == "linux-gnu")

# Okay, ready to put all of this together? Use filter() to return all rows of cran for which r_version is NOT NA. 
# Hint: You will need to use !is.na() as part of your second argument to filter().

filter(cran, !is.na(r_version))

# To see how arrange() works, let's first take a subset of cran. select() all columns from size through ip_id 
# and store the result in cran2.

cran2 <- select(cran, size:ip_id)

# Now, to order the ROWS of cran2 so that ip_id is in ascending order (from small to large), 
# type arrange(cran2, ip_id).
# You may want to make your console wide enough so that you can see ip_id, which is the last column.

arrange(cran2, ip_id)

# To do the same, but in descending order, change the second argument to desc(ip_id), where desc() stands for
# 'descending'. Go ahead.

arrange(cran2, desc(ip_id))

# We can also arrange the data according to the values of multiple variables. For example, arrange(cran2, package,
# ip_id) will first arrange by package names (ascending alphabetically), then by ip_id. This means that if there are
# multiple rows with the same value for package, they will be sorted by ip_id (ascending numerically). Try
# arrange(cran2, package, ip_id) now.

arrange(cran2, package, ip_id)

# Arrange cran2 by the following three variables, in this order: country (ascending), r_version (descending), 
# and ip_id (ascending).

arrange(cran2, country, desc(r_version), ip_id)

# To illustrate the next major function in dplyr, let's take another subset of our original data. 
# Use select() to grab 3 columns from cran -- ip_id, package, and size (in that order)
# and store the result in a new variable called cran3.

cran3 <- select(cran, ip_id, package, size)

# It's common to create a new variable based on the value of one or more variables already in a dataset. The mutate()
# function does exactly this.

# The size variable represents the download size in bytes, which are units of computer memory. 
# These days, megabytes (MB) are a more common unit of measurement. One megabyte is equal to 2^20 bytes. 
# That's 2 to the power of 20, which is approximately one million bytes!

# We want to add a column called size_mb that contains the download size in megabytes. Here's the code to do it:
# mutate(cran3, size_mb = size / 2^20)

mutate(cran3, size_mb = size / 2^20)

# An even larger unit of memory is a gigabyte (GB), which equals 2^10 megabytes. 
# We might as well add another column for download size in gigabytes!

# One very nice feature of mutate() is that you can use the value computed for your second column (size_mb) 
# to create a third column, all in the same line of code. To see this in action, repeat the exact same command 
# as above, except add a third argument creating a column that is named size_gb and equal to size_mb / 2^10.

mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)

# Let's try one more for practice. Pretend we discovered a glitch in the system that provided the original values 
# for the size variable. All of the values in cran3 are 1000 bytes less than they should be. Using cran3, create 
# just one new column called correct_size that contains the correct size.

mutate(cran3, correct_size = size + 1000)

# The last of the five core dplyr verbs, summarize(), collapses the dataset to a single row. Let's say we're interested
# in knowing the average download size. summarize(cran, avg_bytes = mean(size)) will yield the mean value of the size
# variable. Here we've chosen to label the result 'avg_bytes', but we could have named it anything. Give it a try.

summarize(cran, avg_bytes = mean(size))

# That's not particularly interesting. summarize() is most useful when working with data that has been 
# grouped by the values of a particular variable.

# We'll look at grouped data in the next lesson, but the idea is that summarize() can give you 
# the requested value FOR EACH group in your dataset.

# In this lesson, you learned how to manipulate data using dplyr's five main functions. In the next lesson, we'll look
# at how to take advantage of some other useful features of dplyr to make your life as a data analyst much easier.






















































































































