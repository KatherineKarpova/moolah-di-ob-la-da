
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

CREATE TABLE annual_spending(
    year INTEGER NOT NULL,
    monthly_total MONEY NOT NULL,

)
-- view to compare how much was actually spent in each category in comparison to the budgeted amount
-- intent is to query this view based on dates in transactions
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
    categories.id, date;

-- example of future query:
SELECT * AS January
FROM differences 
WHERE date ="2025-01%"
;

-- set capability to add an event based on a condition
SET GLOBAL event_scheduler = ON;

CREATE EVENT insert_monthly_spending
ON SCHEDULE EVERY 1 MONTH
STARTS (CURRENT_DATE + INTERVAL 1 DAY - INTERVAL DAY(CURRENT_DATE) DAY)
DO
BEGIN
    INSERT INTO yearly_spending (category_id, year, month, total_spent)
    SELECT 
        c.id AS category_id,
        YEAR(CURRENT_DATE) AS year,
        0 AS total_spent,
    FROM 
        categories c
    LEFT JOIN 
        monthly_budgets mb ON c.id = mb.category_id
    GROUP BY 
        c.id;
END;