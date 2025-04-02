USE ap;

-- Task 1: Creating Views
-- View: vendor_invoice_summary
-- Purpose: Summarizes invoice data per vendor.
-- Usage: Useful for vendor-level reporting and analytics.

CREATE OR REPLACE VIEW vendor_invoice_summary AS
SELECT 
    v.vendor_id,
    v.vendor_name,
    COUNT(i.invoice_id) AS total_number_invoices,
    SUM(i.invoice_total) AS total_invoice_amount,
    SUM(i.payment_total) AS total_payments,
    SUM(i.credit_total) AS total_credits
FROM vendors v
LEFT JOIN invoices i ON v.vendor_id = i.vendor_id
GROUP BY v.vendor_id, v.vendor_name;

-- View: unpaid_invoices
-- Purpose: Lists invoices that have an outstanding balance.
-- Usage: Useful for tracking unpaid or overdue invoices.

CREATE OR REPLACE VIEW unpaid_invoices AS
SELECT 
    i.invoice_id,
    i.invoice_number,
    v.vendor_name,
    i.invoice_date,
    i.invoice_due_date,
    (i.invoice_total - i.payment_total - i.credit_total) AS outstanding_balance
FROM invoices i
JOIN vendors v ON i.vendor_id = v.vendor_id
WHERE (i.invoice_total - i.payment_total - i.credit_total) > 0;

-- View: account_expenses_summary
-- Purpose: Shows total charges by general ledger account.
-- Usage: Helps with analyzing expenses per account category.

CREATE OR REPLACE VIEW account_expenses_summary AS
SELECT 
    gla.account_number,
    gla.account_description,
    SUM(ili.line_item_amount) AS total_charged
FROM general_ledger_accounts gla
JOIN invoice_line_items ili ON gla.account_number = ili.account_number
GROUP BY gla.account_number, gla.account_description;

-- Task 2: Creating User-Defined Functions (UDFs)
-- Function: calculate_outstanding_balance(invoice_id)
-- Purpose: Returns the remaining balance for a given invoice.
-- Usage: Useful for dynamic calculations in reports or queries.

DROP FUNCTION IF EXISTS calculate_outstanding_balance;

DELIMITER //

CREATE FUNCTION calculate_outstanding_balance(in_invoice_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE paid DECIMAL(10,2);
    DECLARE credit DECIMAL(10,2);

    SELECT invoice_total, payment_total, credit_total
    INTO total, paid, credit
    FROM invoices
    WHERE invoice_id = in_invoice_id;

    RETURN total - paid - credit;
END //

DELIMITER ;

-- Function: days_until_due(invoice_id)
-- Purpose: Returns number of days remaining until the due date.
-- Usage: Positive = days remaining, Negative = overdue.

DROP FUNCTION IF EXISTS days_until_due;

DELIMITER //

CREATE FUNCTION days_until_due(in_invoice_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE due_date DATE;

    SELECT invoice_due_date
    INTO due_date
    FROM invoices
    WHERE invoice_id = in_invoice_id;

    RETURN DATEDIFF(due_date, CURDATE());
END //

DELIMITER ;

-- Function: format_vendor_address(vendor_id)
-- Purpose: Returns a vendor's full address in one formatted string.
-- Usage: Helpful for reports, labels, or exporting vendor info.

DROP FUNCTION IF EXISTS format_vendor_address;

DELIMITER //

CREATE FUNCTION format_vendor_address(in_vendor_id INT)
RETURNS VARCHAR(255)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE addr1 VARCHAR(50);
    DECLARE addr2 VARCHAR(50);
    DECLARE city VARCHAR(50);
    DECLARE state CHAR(2);
    DECLARE zip VARCHAR(20);

    SELECT vendor_address1, vendor_address2, vendor_city, vendor_state, vendor_zip_code
    INTO addr1, addr2, city, state, zip
    FROM vendors
    WHERE vendor_id = in_vendor_id;

    RETURN CONCAT_WS(', ',
        addr1,
        IF(addr2 IS NULL OR addr2 = '', NULL, addr2),
        city,
        state,
        zip
    );
END //

DELIMITER ;

