-- Use the AP database
USE ap; 

-- Question 1: Total number of invoices
-- This query counts all invoices in the invoices table.
SELECT COUNT(*) AS total_invoices
FROM invoices;

-- Question 2: Total amount of all invoices
-- This query sums up all the invoice totals to get the total invoice amount.
SELECT SUM(invoice_total) AS total_invoice_amount
FROM invoices;

-- Question 3: Average invoice total
-- This query calculates the average invoice total across all invoices.
SELECT AVG(invoice_total) AS average_invoice_total
FROM invoices;

-- Question 4: Highest and lowest invoice totals
-- This query finds the highest and lowest invoice amounts from the invoices table.
SELECT 
    MAX(invoice_total) AS highest_invoice_total,
    MIN(invoice_total) AS lowest_invoice_total
FROM invoices;

-- Question 5: Total amount paid by each vendor
-- This query groups invoices by vendor_id and sums up the payment_total.
-- The result shows how much each vendor has been paid.
SELECT 
    vendor_id, 
    SUM(payment_total) AS total_amount_paid
FROM invoices
GROUP BY vendor_id
ORDER BY total_amount_paid DESC;  -- Sorting from highest to lowest total paid.

-- Question 6: Number of invoicesand total invoice amount per vendor
-- This query counts the number of invoices for each vendor and sums up their invoice totals.
SELECT 
    vendor_id, 
    COUNT(*) AS invoice_count,  -- Count of invoices per vendor
    SUM(invoice_total) AS total_invoice_amount
FROM invoices
GROUP BY vendor_id
ORDER BY total_invoice_amount DESC;  -- Sorting by highest invoice amount.

-- Question 7: Total line item amount per general ledger account
-- This query groups all invoice line items by account_number and sums up the amounts.
SELECT 
    account_number, 
    SUM(line_item_amount) AS total_line_item_amount
FROM invoice_line_items
GROUP BY account_number
ORDER BY total_line_item_amount DESC;  -- Sorting from highest to lowest.

-- Question 8: Total invoice amount per vendor with grand total (ROLLUP)
-- This query calculates the total invoice amount per vendor.
-- The WITH ROLLUP feature adds a grand total row at the end.
SELECT 
    COALESCE(vendor_id, 'Grand Total') AS vendor_id,  -- Replacing NULL with 'Grand Total'
    SUM(invoice_total) AS total_invoice_amount
FROM invoices
GROUP BY vendor_id WITH ROLLUP
ORDER BY vendor_id ASC;  -- Sorting vendors in ascending order.


