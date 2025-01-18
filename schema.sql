
-- for each spending category 
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- amount budgeted for each category per month
CREATE TABLE monthly_budgets(
    category_id INTEGER UNIQUE,
    amount MONEY,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- log each purchase and connect it to the category id
-- this approach is much simpler than have a different table for each category
CREATE TABLE transactions(
    id SERIAL PRIMARY KEY,
    category_id INTEGER,
    amount MONEY NOT NULL,
    date DATE DEFAULT CURRENT_DATE NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- view to compare how much was actually spent in each category in comparison to the budgeted amount
CREATE VIEW differences AS
SELECT 
    categories.name AS category, 
    monthly_budgets.amount AS budgeted_amount, 
    SUM(transactions.amount) AS total_spent
FROM 
    categories
JOIN 
    monthly_budgets ON categories.id = monthly_budgets.category_id
JOIN 
    transactions ON categories.id = transactions.category_id
GROUP BY 
    categories.id;
