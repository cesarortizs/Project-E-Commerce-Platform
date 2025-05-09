**Documentation**

Retrieving the list of products of a specific category is easy, we just have to filter the results by a specific category name or id, the process is similar for retreiving the user details by a specific user_id and the order history for a specific user by again using his user_id.

We start implementing joins for queries like retreiving the products of an order, this is because of the data we need to obtain like Price is not readily available in just one table, we also start using functions to calculate the average and the sum of different columns for the rest of the simple queries

For the complex queries like obtaining the top selling products we have to use joins and also start ordering the results, for obtaining user that have exceed a certain amount in an order we also have to filter the results and finally for getting the average rating of a product we again have to use functions.

The stored procedures were the hardest as we have to define one that implements conditionals and also accepts parameters, but nevertheless they weren’t too difficult, as they were very similar to the queries we have already implemented.
