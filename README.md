# database
1/What is the difference between JOIN and UNION?

Both of them are methods for combining data in SQL. But JOIN adds new data by adding new columns, which have a logical connection. And UNION adds new rows to the columns that already exist.

2/Explain the difference between SUBQUERY AND CTE.

CTE creates a temporary table before the main query, while SUBQUERY is a query that works inside another query.

3/What is CROSS JOIN?

It`s the cartesian product of two tables without any condition.

4/Explain the purpose of the GROUP BY clause.

GROUP BY groups rows that have the same values in the specified column or columns.

5/What is the difference between HAVING and WHERE?

WHERE works before GROUP BY, while HAVING works after. HAVING can also use aggregate functions, while WHERE cannot.

6/What does a CTE (Common Table Expression) do?

CTE creates a temporary table before the main query. Table exists only inside the query

7/What is the difference between INNER JOIN, LEFT JOIN, and RIGHT JOIN?

The main difference between them is how they link tables. INNER JOIN returns rows when there is a match in both tables. LEFT JOIN returns all rows from the left table, and the matching rows from the right table. RIGHT JOIN does the opposite — it returns all rows from the right table, and the matching rows from the left table.

8/When should you use ORDER BY and what happens without it?

ORDER BY is used when you want to sort the results of a query. Without it, the results of the query will be generated in any order

9/How does LIMIT help improve query performance?

LIMIT limits the number of lines the request returns. This can significantly improve the speed of query execution, especially when working with large tables.

10/What is the difference between UNION ALL and UNION?

UNION removes all duplicate rows, while UNION ALL keeps them, which makes UNION ALL faster.

