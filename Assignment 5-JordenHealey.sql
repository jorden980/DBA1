-- PROCEDURE 1: get_vendor_invoices
-- Purpose: Returns invoice details for a given vendor

DELIMITER //

DROP PROCEDURE IF EXISTS get_vendor_invoices;

CREATE PROCEDURE get_vendor_invoices(IN in_vendor_id INT)
BEGIN
    -- Select invoice details for the given vendor
    SELECT 
        invoice_id,
        invoice_number,
        invoice_date,
        invoice_total,
        payment_total
    FROM invoices
    WHERE vendor_id = in_vendor_id;
END //

DELIMITER ;

-- PROCEDURE 2: apply_payment
-- Purpose: Applies a payment to a specific invoice
-- Ensures that the total payment does not exceed invoice total

DELIMITER //

DROP PROCEDURE IF EXISTS apply_payment;

CREATE PROCEDURE apply_payment(IN in_invoice_id INT, IN in_amount DECIMAL(10,2))
BEGIN
    -- Declare variables to store totals
    DECLARE invoiceTotal DECIMAL(10,2);
    DECLARE currentPayment DECIMAL(10,2);
    DECLARE newPaymentTotal DECIMAL(10,2);

    -- Fetch current invoice total and payment total
    SELECT invoice_total, payment_total
    INTO invoiceTotal, currentPayment
    FROM invoices
    WHERE invoice_id = in_invoice_id;

    -- Calculate new payment total
    SET newPaymentTotal = currentPayment + in_amount;

    -- Check if payment is within allowed range
    IF newPaymentTotal <= invoiceTotal THEN
        -- Update the invoice's payment_total
        UPDATE invoices
        SET payment_total = newPaymentTotal
        WHERE invoice_id = in_invoice_id;

        -- Return success message
        SELECT CONCAT('Payment of $', in_amount, ' applied successfully to invoice ID ', in_invoice_id) AS message;
    ELSE
        -- Return error message if overpayment attempted
        SELECT CONCAT('Error: Payment exceeds invoice balance. Remaining balance is $', invoiceTotal - currentPayment) AS message;
    END IF;
END //

DELIMITER ;

-- PROCEDURE 3: insert_new_invoice
-- Purpose: Inserts a new invoice for a vendor
-- Sets payment_total and credit_total to 0 by default

DELIMITER //

DROP PROCEDURE IF EXISTS insert_new_invoice;

CREATE PROCEDURE insert_new_invoice(
    IN in_vendor_id INT,
    IN in_invoice_number VARCHAR(50),
    IN in_invoice_date DATE,
    IN in_invoice_total DECIMAL(10,2),
    IN in_terms_id INT
)
BEGIN
    -- Insert a new invoice record
    INSERT INTO invoices (
        vendor_id,
        invoice_number,
        invoice_date,
        invoice_total,
        payment_total,
        credit_total,
        terms_id
    ) VALUES (
        in_vendor_id,
        in_invoice_number,
        in_invoice_date,
        in_invoice_total,
        0.00, -- initial payment_total
        0.00, -- initial credit_total
        in_terms_id
    );

    -- Return the new invoice ID
    SELECT LAST_INSERT_ID() AS new_invoice_id;
END //

DELIMITER ;

