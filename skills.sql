-- Note: Please consult the directions for this assignment 
-- for the most explanatory version of each question.

-- 1. Select all columns for all brands in the Brands table.
sqlite> SELECT *
   ...> FROM Brands;


-- 2. Select all columns for all car models made by Pontiac in the Models table.
sqlite> SELECT *
   ...> From Models
   ...> WHERE brand_name = 'Pontiac';


-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table
sqlite> SELECT brand_name, name
   ...> FROM Models
   ...> WHERE year = 1964;


-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.
sqlite> SELECT m.name, m.brand_name, b.headquarters
   ...> FROM Models AS m
   ...> JOIN Brands as b ON (m.brand_name = b.name)
   ...> WHERE
   ...>     m.name = 'Mustang'
   ...>     AND
   ...>     m.brand_name = 'Ford';



-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).

sqlite> SELECT *
   ...> FROM Brands
   ...> ORDER BY founded
   ...> LIMIT 3;


-- 6. Count the Ford models in the database (output should be a number).
sqlite> SELECT COUNT(name)
   ...> FROM Models
   ...> WHERE brand_name = 'Ford';


-- 7. Select the name of any and all car brands that are not discontinued.
sqlite> SELECT name
   ...> FROM Brands
   ...> WHERE discontinued IS NULL;


-- 8. Select rows 15-25 of the DB in alphabetical order by model name.
sqlite> SELECT *
   ...> FROM Models
   ...> ORDER BY name
   ...> LIMIT 10
   ...> OFFSET 14;


-- 9. Select the brand, name, and year the model's brand was 
--    founded for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be NULL if 
--    the brand is not in the Brands table.)
sqlite> SELECT m.brand_name, m.name, b.founded
   ...> FROM Models as m
   ...> LEFT JOIN Brands as b ON (m.brand_name = b.name)
   ...> WHERE m.year = 1960;



-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all brands that are not discontinued
-- regardless of whether they have any models in the models table.
-- before:
    -- SELECT b.name,
    --        b.founded,
    --        m.name
    -- FROM Model AS m
    --   LEFT JOIN brands AS b
    --     ON b.name = m.brand_name
    -- WHERE b.discontinued IS NULL;

-- 2. Modify this left join so it only selects models that have brands in the Brands table.
-- before: 
    -- SELECT m.name,
    --        m.brand_name,
    --        b.founded
    -- FROM Models AS m
    --   LEFT JOIN Brands AS b
    --     ON b.name = m.brand_name;
    sqlite> SELECT b.name, b.founded, m.name
   ...> FROM Brands as b
   ...> LEFT JOIN Models as m ON (b.name = m.brand_name)
   ...> WHERE b.discontinued IS NULL;


-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.

-- ANSWER:
-- Inner joins show the intersection between two tables. In other words, they
-- will show data for items that exist in both tables. Say you have two tables,
-- one table with vendors and another table with products that have associated
-- vendor IDs. If you add a new vendor to the vendor table but have not
-- added any associated products in the proucts table, an inner join between
-- these two tables will not show the new vendor.

-- Left joins show all data for one table despite nonexistence in a second table.
-- Going back to the vendors and products table, if you left join the products
-- table to the vendor table, you will now get a result showing the new vendor
-- with all assoicated attributes as NULL.

-- 3. Modify the query so that it only selects brands that don't have any models in the models table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    -- SELECT name,
    --        founded
    -- FROM Brands
    --   LEFT JOIN Models
    --     ON brands.name = Models.brand_name
    -- WHERE Models.year > 1940;

    sqlite> SELECT b.name, b.founded
   ...> FROM Brands as b
   ...> LEFT JOIN Models as m ON (b.name = m.brand_name)
   ...> WHERE m.name IS NULL;


-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model until the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    -- SELECT b.name,
    --        m.name,
    --        m.year,
    --        b.discontinued
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued NOT NULL;

sqlite> SELECT b.name, b.founded
   ...> FROM Brands as b
   ...> LEFT JOIN Models as m ON (b.name = m.brand_name)
   ...> WHERE
   ...> m.name IS NULL;



-- Part 3: Further Study

-- 1. Select the name of any brand with more than 5 models in the database.
sqlite> SELECT brand_name, COUNT(name)
   ...> FROM Models
   ...> GROUP BY brand_name
   ...> HAVING COUNT(name) > 5;



-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback

sqlite> INSERT INTO Models (year, name, brand_name)
   ...> VALUES (2015, 'Malibu', 'Chevrolet');
sqlite> INSERT INTO Models (year, name, brand_name)
   ...> VALUES (2015, 'Outback', 'Subaru');


-- 3. Write a SQL statement to crate a table called `Awards`
--    with columns `name`, `year`, and `winner`. Choose
--    an appropriate datatype and nullability for each column
--   (no need to do subqueries here).

sqlite> CREATE TABLE Awards(
   ...> name VARCHAR(40) NOT NULL,
   ...> year INT NOT NULL,
   ...> winner VARCHAR(40)
   ...> );


-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      the id for the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      the id for the 2015 Subaru Outback
sqlite> INSERT INTO Awards (name, year, winner_model_id)
   ...> VALUES ('IIHS Safety Award', 2015,
   ...> (SELECT id
   ...> FROM Models
   ...> WHERE name = 'Malibu' AND brand_name = 'Chevrolet' AND year = 2015));

   sqlite> INSERT INTO Awards (name, year, winner_model_id)
   ...> VALUES ('IIHS Safety Award', 2015,
   ...> (SELECT id
   ...> FROM Models
   ...> WHERE name = 'Outback' AND brand_name = 'Subaru' AND year = 2015));




-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.
sqlite> SELECT m.name
   ...> FROM Models as m
   ...> JOIN Brands as b
   ...> ON (m.brand_name = b.name)
   ...> WHERE m.year = b.founded;





