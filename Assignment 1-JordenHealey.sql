-- MySQL Assignment: Fetching Data from Single and Multiple Tables
-- Schema: ap and ex databases
-- Instructions: Test all queries in your MySQL environment before submission.

-- Fetching Data from a Single Table --

-- 1. Basic SELECT Statement
-- Fetch all columns from the vendors table, ordered by vendor_id.
USE ap;  -- Specify the ap database
SELECT * 
FROM vendors 
ORDER BY vendor_id;  -- Order the results by vendor_id in ascending order

-- 2. WHERE Clause
-- Fetch vendor_name, vendor_phone, and vendor_city for vendors located in the state of 'CA', ordered by vendor_name.
SELECT vendor_name, vendor_phone, vendor_city
FROM vendors
WHERE vendor_state = 'CA'  -- Filter vendors in California (CA)
ORDER BY vendor_name;  -- Order the results alphabetically by vendor_name

-- 3. Sorting Results
-- Fetch invoice_id, invoice_total, and invoice_date from the invoices table, sorted by invoice_total in descending order.
SELECT invoice_id, invoice_total, invoice_date
FROM invoices
ORDER BY invoice_total DESC;  -- Sort the results by invoice_total in descending order

-- 4. Limiting Results
-- Fetch the invoices with the 3rd to 9th lowest invoice_total, ordered by invoice_total.
SELECT invoice_id, invoice_total
FROM invoices
ORDER BY invoice_total ASC  -- Sort by invoice_total in ascending order
LIMIT 6 OFFSET 2;  -- Skip the first 2 rows and return the next 6 rows (3rd to 9th)

-- 5. Using Arithmetic
-- Fetch invoice_id, invoice_total, and the remaining balance (calculated as invoice_total - payment_total), ordered by invoice_id.
SELECT invoice_id, invoice_total, 
       (invoice_total - payment_total) AS Remaining_Balance  -- Calculate the remaining balance
FROM invoices
ORDER BY invoice_id;  -- Order the results by invoice_id

-- Fetching Data from Multiple Tables --

-- 6. Inner Join
-- Fetch invoice_id, invoice_total, vendor_name, and vendor_phone using an inner join between invoices and vendors tables, ordered by invoice_id.
SELECT invoices.invoice_id, invoices.invoice_total, vendors.vendor_name, vendors.vendor_phone
FROM invoices
INNER JOIN vendors ON invoices.vendor_id = vendors.vendor_id  -- Join invoices and vendors on vendor_id
ORDER BY invoices.invoice_id;  -- Order by invoice_id in ascending order

-- 7. Outer Join
-- Fetch all vendor_name values along with the invoice_id, including vendors who do not have any invoices.
SELECT vendors.vendor_name, invoices.invoice_id
FROM vendors
LEFT JOIN invoices ON vendors.vendor_id = invoices.vendor_id  -- Left join to include vendors without invoices
ORDER BY vendors.vendor_name;  -- Order by vendor_name

-- 8. Outer Join 2 (ex database)
-- Fetch all department_name values along with employee_last_name, including employees without a matching department.
USE ex;  -- Switch to ex database
SELECT departments.department_name, employees.last_name AS employee_last_name
FROM departments
LEFT JOIN employees ON departments.department_number = employees.department_number  -- Left join to include employees without a department
ORDER BY departments.department_number;  -- Order by department_number

-- 9. Using CONCAT
-- I chose to use tables from employees because I couldn't find the vendor_contacts table
SELECT 
  CONCAT(e.first_name, ' ', e.last_name) AS Combined_Contact_Name,  -- Concatenate first_name and last_name
  d.department_name
FROM 
  employees e
JOIN 
  departments d ON e.department_number = d.department_number  -- Join employees and departments on department_number
ORDER BY 
  Combined_Contact_Name;  -- Order by the concatenated name

-- 10. Union (ex database)
-- Fetch all unique first_name values from employees and sales_reps tables.
SELECT first_name FROM employees  -- Select first_name from employees table
UNION  -- Combine unique values from both tables
SELECT rep_first_name AS first_name FROM sales_reps  -- Select first_name from sales_reps table, aliased to match the column name
ORDER BY first_name;  -- Order the results alphabetically by first_name

-- 11. Complex Query with Multiple Joins
-- Fetch invoice_id, invoice_total, vendor_name, and terms_description using joins between invoices, vendors, and terms tables, ordered by invoice_id.
USE ap;  -- Switch to ap database
SELECT invoices.invoice_id, invoices.invoice_total, vendors.vendor_name, terms.terms_description
FROM invoices
INNER JOIN vendors ON invoices.vendor_id = vendors.vendor_id  -- Join invoices and vendors on vendor_id
INNER JOIN terms ON invoices.terms_id = terms.terms_id  -- Join invoices and terms on terms_id
ORDER BY invoices.invoice_id;  -- Order by invoice_id in ascending order

-- End of Assignment --

