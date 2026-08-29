SET SERVEROUTPUT ON;

-- ================================================================
-- PL/SQL UNIT 2 - CONTROL STRUCTURES
-- Name    : Ruchi Suthar
-- Roll No.: 51
-- DOB     : 07-MAR-2007
-- ================================================================


-- ================================================================
-- P2.1 COMPLETE GRADE CARD SYSTEM
-- Using roll number 51 to create subject marks:
-- 51 MOD 20 + 60 = 71
-- ================================================================
DECLARE
    v_name VARCHAR2(50) := 'Ruchi Suthar';
    v_roll NUMBER := 51;

    v_m1 NUMBER := 71;
    v_m2 NUMBER := 71;
    v_m3 NUMBER := 71;
    v_m4 NUMBER := 71;
    v_m5 NUMBER := 71;

    v_total NUMBER;
    v_percentage NUMBER;
    v_grade VARCHAR2(5);
    v_result VARCHAR2(30);
BEGIN
    v_total := v_m1 + v_m2 + v_m3 + v_m4 + v_m5;
    v_percentage := ROUND(v_total / 500 * 100, 2);

    IF v_m1 < 35 OR v_m2 < 35 OR v_m3 < 35 OR v_m4 < 35 OR v_m5 < 35 THEN
        v_result := 'DETAINED';

        IF v_m1 < 35 THEN
            DBMS_OUTPUT.PUT_LINE('Failed Subject: Subject 1');
        END IF;
        IF v_m2 < 35 THEN
            DBMS_OUTPUT.PUT_LINE('Failed Subject: Subject 2');
        END IF;
        IF v_m3 < 35 THEN
            DBMS_OUTPUT.PUT_LINE('Failed Subject: Subject 3');
        END IF;
        IF v_m4 < 35 THEN
            DBMS_OUTPUT.PUT_LINE('Failed Subject: Subject 4');
        END IF;
        IF v_m5 < 35 THEN
            DBMS_OUTPUT.PUT_LINE('Failed Subject: Subject 5');
        END IF;
    ELSE
        IF v_percentage >= 75 THEN
            v_result := 'DISTINCTION';
        ELSIF v_percentage >= 60 THEN
            v_result := 'FIRST CLASS';
        ELSIF v_percentage >= 50 THEN
            v_result := 'SECOND CLASS';
        ELSE
            v_result := 'PASS';
        END IF;
    END IF;

    IF v_percentage >= 90 THEN
        v_grade := 'A+';
    ELSIF v_percentage >= 80 THEN
        v_grade := 'A';
    ELSIF v_percentage >= 70 THEN
        v_grade := 'B';
    ELSIF v_percentage >= 60 THEN
        v_grade := 'C';
    ELSIF v_percentage >= 50 THEN
        v_grade := 'D';
    ELSE
        v_grade := 'FAIL';
    END IF;

    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE('          REPORT CARD');
    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE('Name       : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Roll No    : ' || v_roll);
    DBMS_OUTPUT.PUT_LINE('Subject 1  : ' || v_m1);
    DBMS_OUTPUT.PUT_LINE('Subject 2  : ' || v_m2);
    DBMS_OUTPUT.PUT_LINE('Subject 3  : ' || v_m3);
    DBMS_OUTPUT.PUT_LINE('Subject 4  : ' || v_m4);
    DBMS_OUTPUT.PUT_LINE('Subject 5  : ' || v_m5);
    DBMS_OUTPUT.PUT_LINE('Total      : ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Percentage : ' || v_percentage || '%');
    DBMS_OUTPUT.PUT_LINE('Grade      : ' || v_grade);
    DBMS_OUTPUT.PUT_LINE('Result     : ' || v_result);
END;
/


-- ================================================================
-- P2.2 INDIAN INCOME TAX CALCULATOR 2024-25
-- Seed/roll based gross salary:
-- 51 * 5000 = Rs.255000
-- Standard deduction = Rs.75000
-- ================================================================
DECLARE
    v_gross_salary NUMBER := 255000;
    v_standard_deduction NUMBER := 75000;
    v_taxable_income NUMBER;
    v_tax NUMBER := 0;
    v_tds NUMBER;
    v_monthly_salary NUMBER;
BEGIN
    v_taxable_income := GREATEST(v_gross_salary - v_standard_deduction, 0);

    -- Searched CASE statement for tax slabs
    v_tax := CASE
        WHEN v_taxable_income <= 300000 THEN 0
        WHEN v_taxable_income <= 700000 THEN
            (v_taxable_income - 300000) * 0.05
        WHEN v_taxable_income <= 1000000 THEN
            400000 * 0.05 +
            (v_taxable_income - 700000) * 0.10
        WHEN v_taxable_income <= 1200000 THEN
            400000 * 0.05 +
            300000 * 0.10 +
            (v_taxable_income - 1000000) * 0.15
        WHEN v_taxable_income <= 1500000 THEN
            400000 * 0.05 +
            300000 * 0.10 +
            200000 * 0.15 +
            (v_taxable_income - 1200000) * 0.20
        ELSE
            400000 * 0.05 +
            300000 * 0.10 +
            200000 * 0.15 +
            300000 * 0.20 +
            (v_taxable_income - 1500000) * 0.30
    END;

    v_tds := ROUND(v_tax / 12, 2);
    v_monthly_salary := ROUND(v_gross_salary / 12, 2);

    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE('       INCOME TAX CALCULATOR');
    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE('Gross Salary      : Rs.' || v_gross_salary);
    DBMS_OUTPUT.PUT_LINE('Standard Deduction: Rs.' || v_standard_deduction);
    DBMS_OUTPUT.PUT_LINE('Taxable Income    : Rs.' || v_taxable_income);
    DBMS_OUTPUT.PUT_LINE('Total Tax         : Rs.' || v_tax);
    DBMS_OUTPUT.PUT_LINE('Monthly TDS       : Rs.' || v_tds);
    DBMS_OUTPUT.PUT_LINE('Monthly Salary    : Rs.' || v_monthly_salary);
    DBMS_OUTPUT.PUT_LINE('Take Home/Month   : Rs.' ||
                         ROUND(v_monthly_salary - v_tds, 2));

    IF v_tax = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No tax this year - save more with PPF/ELSS!');
    END IF;
END;
/


-- ================================================================
-- P2.3 ATM MACHINE SIMULATION
-- Initial balance = 51*500 + 5000 = Rs.30500
-- At least 4 loop iterations are performed.
-- ================================================================
DECLARE
    v_balance NUMBER := 30500;
    v_choice NUMBER;
    v_amount NUMBER;

    v_txns NUMBER := 0;
    v_total_withdrawn NUMBER := 0;
    v_iteration NUMBER := 0;
BEGIN
    LOOP
        v_iteration := v_iteration + 1;

        -- Simulated menu:
        -- 1 = Withdraw
        -- 3 = Exit
        IF v_iteration = 1 THEN
            v_choice := 1;
            v_amount := 500;
        ELSIF v_iteration = 2 THEN
            v_choice := 1;
            v_amount := 1000;
        ELSIF v_iteration = 3 THEN
            v_choice := 1;
            v_amount := 1500;
        ELSIF v_iteration = 4 THEN
            v_choice := 1;
            v_amount := 2000;
        ELSE
            v_choice := 3;
        END IF;

        IF v_choice = 3 THEN
            DBMS_OUTPUT.PUT_LINE('ATM Exit selected.');
            EXIT;
        ELSIF v_choice = 1 THEN

            IF v_amount <= 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: Withdrawal must be greater than 0.');
            ELSIF MOD(v_amount, 100) <> 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: Withdrawal must be a multiple of 100.');
            ELSIF v_amount > 10000 THEN
                DBMS_OUTPUT.PUT_LINE('Error: Maximum Rs.10000 allowed per transaction.');
            ELSIF v_amount > v_balance THEN
                DBMS_OUTPUT.PUT_LINE('Error: Insufficient balance.');
            ELSE
                v_balance := v_balance - v_amount;
                v_txns := v_txns + 1;
                v_total_withdrawn := v_total_withdrawn + v_amount;

                DBMS_OUTPUT.PUT_LINE('------------------------------');
                DBMS_OUTPUT.PUT_LINE('Transaction Successful');
                DBMS_OUTPUT.PUT_LINE('Withdrawn : Rs.' || v_amount);
                DBMS_OUTPUT.PUT_LINE('Balance   : Rs.' || v_balance);
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error: Invalid choice.');
        END IF;

        IF v_balance = 0 THEN
            EXIT;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE('          ATM SUMMARY');
    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE('Transactions Done : ' || v_txns);
    DBMS_OUTPUT.PUT_LINE('Total Withdrawn   : Rs.' || v_total_withdrawn);
    DBMS_OUTPUT.PUT_LINE('Closing Balance   : Rs.' || v_balance);
END;
/


-- ================================================================
-- P2.4 LOOPS AND PATTERNS
-- Part A: Table = 51 MOD 9 + 2 = 8
-- Part C: Height = 5 + 51 MOD 5 = 6
-- ================================================================
DECLARE
    v_num NUMBER := MOD(51, 9) + 2;
    v_height NUMBER := 5 + MOD(51, 5);
BEGIN
    DBMS_OUTPUT.PUT_LINE('========== PART A: TABLE OF ' || v_num || ' ==========');

    FOR i IN 1 .. 20 LOOP
        DBMS_OUTPUT.PUT_LINE(v_num || ' x ' || i || ' = ' || v_num * i);
    END LOOP;


    DBMS_OUTPUT.PUT_LINE('========== PART B: TABLES 2 TO 5 ==========');

    FOR n IN 2 .. 5 LOOP
        FOR i IN 1 .. 10 LOOP
            DBMS_OUTPUT.PUT_LINE(LPAD(n || ' x ' || i || ' = ' || n*i, 15));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('----------------');
    END LOOP;


    DBMS_OUTPUT.PUT_LINE('========== PART C: STAR TRIANGLE ==========');

    FOR i IN 1 .. v_height LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD('*', i, '*'));
    END LOOP;


    DBMS_OUTPUT.PUT_LINE('========== PART D: NUMBER PYRAMID ==========');

    FOR i IN 1 .. 6 LOOP
        FOR j IN 1 .. i LOOP
            DBMS_OUTPUT.PUT(j);
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;


    DBMS_OUTPUT.PUT_LINE('========== PART E: REVERSE TRIANGLE ==========');

    FOR i IN REVERSE 1 .. v_height LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD('*', i, '*'));
    END LOOP;
END;
/


-- ================================================================
-- P2.5 FIBONACCI, PRIMES AND GCD - WHILE LOOP
-- N = 5 + 51 MOD 8 = 8
-- ================================================================
DECLARE
    v_n NUMBER := 5 + MOD(51, 8);

    a NUMBER := 0;
    b NUMBER := 1;
    c NUMBER;
    i NUMBER := 1;
    v_nth NUMBER := 0;

    v_prime BOOLEAN := TRUE;
    d NUMBER := 2;

    p NUMBER;
    q NUMBER;
    r NUMBER;

    v_num NUMBER := 28;
    divisor NUMBER := 1;
    divisor_sum NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========== PART A: FIBONACCI ==========');

    WHILE i <= v_n LOOP
        DBMS_OUTPUT.PUT_LINE('Fibonacci ' || i || ' = ' || a);
        v_nth := a;

        c := a + b;
        a := b;
        b := c;
        i := i + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Nth Fibonacci Number: ' || v_nth);


    DBMS_OUTPUT.PUT_LINE('========== PART B: PRIME CHECK ==========');

    IF v_nth < 2 THEN
        v_prime := FALSE;
    ELSE
        d := 2;
        WHILE d <= TRUNC(SQRT(v_nth)) LOOP
            IF MOD(v_nth, d) = 0 THEN
                v_prime := FALSE;
                EXIT;
            END IF;
            d := d + 1;
        END LOOP;
    END IF;

    IF v_prime THEN
        DBMS_OUTPUT.PUT_LINE(v_nth || ' is PRIME.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_nth || ' is NOT PRIME.');
    END IF;


    DBMS_OUTPUT.PUT_LINE('========== PART C: PRIMES 1 TO 100 ==========');

    p := 2;
    WHILE p <= 100 LOOP
        d := 2;
        v_prime := TRUE;

        WHILE d <= TRUNC(SQRT(p)) LOOP
            IF MOD(p, d) = 0 THEN
                v_prime := FALSE;
                EXIT;
            END IF;
            d := d + 1;
        END LOOP;

        IF v_prime THEN
            DBMS_OUTPUT.PUT(p || ' ');
        END IF;

        p := p + 1;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;


    DBMS_OUTPUT.PUT_LINE('========== PART D: GCD ==========');

    p := 51;
    q := 34;

    WHILE q <> 0 LOOP
        r := MOD(p, q);
        p := q;
        q := r;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('GCD = ' || p);


    DBMS_OUTPUT.PUT_LINE('========== PART E: PERFECT NUMBER ==========');

    divisor := 1;
    divisor_sum := 0;

    WHILE divisor <= TRUNC(v_num / 2) LOOP
        IF MOD(v_num, divisor) = 0 THEN
            divisor_sum := divisor_sum + divisor;
        END IF;
        divisor := divisor + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Number = ' || v_num);
    DBMS_OUTPUT.PUT_LINE('Sum of Divisors = ' || divisor_sum);

    IF divisor_sum = v_num THEN
        DBMS_OUTPUT.PUT_LINE('It is a PERFECT NUMBER.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('It is NOT a perfect number.');
    END IF;
END;
/


-- ================================================================
-- P2.6 ZOMATO DELIVERY PRICE ENGINE
-- Roll-based food value = 51*10 = Rs.510
-- Distance = 51 MOD 20 + 1 = 12 km
-- ================================================================
DECLARE
    v_food_total NUMBER := 510;
    v_distance NUMBER := 12;

    v_rain CHAR(1) := 'Y';
    v_late_night CHAR(1) := 'N';
    v_festival CHAR(1) := 'N';
    v_peak CHAR(1) := 'Y';
    v_first_order CHAR(1) := 'Y';

    v_base NUMBER;
    v_delivery NUMBER;
    v_rain_charge NUMBER := 0;
    v_late_charge NUMBER := 0;
    v_festival_charge NUMBER := 0;
    v_peak_charge NUMBER := 0;
    v_discount NUMBER := 0;
    v_final_delivery NUMBER;
    v_grand_total NUMBER;
BEGIN
    v_base := CASE
        WHEN v_distance < 3 THEN 0
        WHEN v_distance <= 8 THEN 29
        WHEN v_distance <= 15 THEN 49
        ELSE 79
    END;

    v_delivery := v_base;

    IF v_food_total > 499 THEN
        v_final_delivery := 0;
    ELSE
        v_rain_charge := CASE WHEN v_rain = 'Y' THEN v_delivery * 0.20 ELSE 0 END;
        v_late_charge := CASE WHEN v_late_night = 'Y' THEN v_delivery * 0.15 ELSE 0 END;
        v_festival_charge := CASE WHEN v_festival = 'Y' THEN v_delivery * 0.10 ELSE 0 END;
        v_peak_charge := CASE WHEN v_peak = 'Y' THEN v_delivery * 0.10 ELSE 0 END;

        v_delivery := v_delivery + v_rain_charge +
                      v_late_charge + v_festival_charge + v_peak_charge;

        IF v_first_order = 'Y' THEN
            v_discount := v_delivery * 0.50;
        END IF;

        v_final_delivery := v_delivery - v_discount;
    END IF;

    v_final_delivery := ROUND(v_final_delivery);
    v_grand_total := v_food_total + v_final_delivery;

    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE('       ZOMATO DELIVERY RECEIPT');
    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE('Food Total       : Rs.' || v_food_total);
    DBMS_OUTPUT.PUT_LINE('Distance         : ' || v_distance || ' km');
    DBMS_OUTPUT.PUT_LINE('Base Delivery    : Rs.' || v_base);
    DBMS_OUTPUT.PUT_LINE('Rain Surcharge   : Rs.' || ROUND(v_rain_charge));
    DBMS_OUTPUT.PUT_LINE('Late Night       : Rs.' || ROUND(v_late_charge));
    DBMS_OUTPUT.PUT_LINE('Festival         : Rs.' || ROUND(v_festival_charge));
    DBMS_OUTPUT.PUT_LINE('Peak Hour        : Rs.' || ROUND(v_peak_charge));
    DBMS_OUTPUT.PUT_LINE('Discount         : Rs.' || ROUND(v_discount));
    DBMS_OUTPUT.PUT_LINE('Final Delivery   : Rs.' || v_final_delivery);
    DBMS_OUTPUT.PUT_LINE('Grand Total      : Rs.' || v_grand_total);
END;
/


-- ================================================================
-- P2.7 STUDENT RESULT + ATTENDANCE SYSTEM
-- Personal roll-based values:
-- Attendance = 51%, Theory = 31, Practical = 13, Assignment = 8
-- ================================================================
DECLARE
    v_name VARCHAR2(50) := 'Ruchi Suthar';
    v_roll NUMBER := 51;

    v_attendance NUMBER := 51;
    v_theory NUMBER := 31;
    v_practical NUMBER := 13;
    v_assignment NUMBER := 8;

    v_counted_assignment NUMBER;
    v_total NUMBER := 0;
    v_percentage NUMBER := 0;
    v_grade VARCHAR2(5);
    v_result VARCHAR2(30);
    v_remark VARCHAR2(100);
BEGIN
    v_counted_assignment := LEAST(v_assignment, 10);

    IF v_attendance < 40 THEN
        v_result := 'DETAINED';
        v_remark := 'Attendance below minimum requirement.';
    ELSIF v_theory < 28 THEN
        v_result := 'FAIL IN THEORY';
        v_remark := 'Theory marks below passing marks.';
    ELSIF v_practical < 12 THEN
        v_result := 'FAIL IN PRACTICAL';
        v_remark := 'Practical marks below passing marks.';
    ELSE
        v_total := v_theory + v_practical + v_counted_assignment;
        v_percentage := ROUND(v_total / 120 * 100, 2);

        v_grade := CASE
            WHEN v_percentage >= 90 THEN 'A+'
            WHEN v_percentage >= 80 THEN 'A'
            WHEN v_percentage >= 70 THEN 'B'
            WHEN v_percentage >= 60 THEN 'C'
            WHEN v_percentage >= 50 THEN 'D'
            ELSE 'F'
        END;

        IF v_percentage >= 75 THEN
            v_result := 'DISTINCTION';
            v_remark := 'Excellent performance.';
        ELSIF v_percentage >= 60 THEN
            v_result := 'PASS';
            v_remark := 'First class performance.';
        ELSIF v_percentage >= 50 THEN
            v_result := 'PASS';
            v_remark := 'Second class performance.';
        ELSE
            v_result := 'PASS';
            v_remark := 'Pass class.';
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('====================================');
    DBMS_OUTPUT.PUT_LINE('       LJICA SEMESTER RESULT');
    DBMS_OUTPUT.PUT_LINE('====================================');
    DBMS_OUTPUT.PUT_LINE('Name             : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Roll No          : ' || v_roll);
    DBMS_OUTPUT.PUT_LINE('Attendance       : ' || v_attendance || '%');
    DBMS_OUTPUT.PUT_LINE('Theory           : ' || v_theory || '/70');
    DBMS_OUTPUT.PUT_LINE('Practical        : ' || v_practical || '/30');
    DBMS_OUTPUT.PUT_LINE('Assignment Count : ' || v_counted_assignment || '/10');
    DBMS_OUTPUT.PUT_LINE('Total            : ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Percentage       : ' || v_percentage || '%');
    DBMS_OUTPUT.PUT_LINE('Grade            : ' || NVL(v_grade, 'N/A'));
    DBMS_OUTPUT.PUT_LINE('Result           : ' || v_result);
    DBMS_OUTPUT.PUT_LINE('Remark           : ' || v_remark);
END;
/


-- ================================================================
-- P2.8 LOAN EMI AFFORDABILITY CHECKER
-- Roll-based salary = 51*1000 = Rs.51000
-- Existing EMI = 5000
-- Loan Amount = 1000000
-- Annual Rate = 9%
-- Tenure = 60 months
-- ================================================================
DECLARE
    v_monthly_salary NUMBER := 51000;
    v_existing_emi NUMBER := 5000;
    v_loan_amount NUMBER := 1000000;
    v_annual_rate NUMBER := 9;
    v_tenure_months NUMBER := 60;

    v_monthly_rate NUMBER;
    v_emi NUMBER;
    v_foir_limit NUMBER;
    v_max_total_emi NUMBER;
    v_approved_amount NUMBER;
    v_decision VARCHAR2(30);

    v_test_loan NUMBER;
    v_test_emi NUMBER;
BEGIN
    v_monthly_rate := v_annual_rate / 12 / 100;
    v_foir_limit := v_monthly_salary * 0.40;
    v_max_total_emi := v_foir_limit;

    v_emi := ROUND(
        v_loan_amount * v_monthly_rate *
        POWER(1 + v_monthly_rate, v_tenure_months) /
        (POWER(1 + v_monthly_rate, v_tenure_months) - 1),
        2
    );

    IF v_monthly_salary < 25000 THEN
        v_decision := 'REJECTED';
        v_approved_amount := 0;
    ELSIF v_loan_amount > 60 * v_monthly_salary THEN
        v_decision := 'REJECTED';
        v_approved_amount := 0;
    ELSIF v_existing_emi + v_emi <= v_foir_limit THEN
        v_decision := 'APPROVED';
        v_approved_amount := v_loan_amount;
    ELSE
        v_decision := 'CONDITIONAL';
        v_test_loan := v_loan_amount;

        WHILE v_test_loan > 0 LOOP
            v_test_emi := ROUND(
                v_test_loan * v_monthly_rate *
                POWER(1 + v_monthly_rate, v_tenure_months) /
                (POWER(1 + v_monthly_rate, v_tenure_months) - 1),
                2
            );

            EXIT WHEN v_existing_emi + v_test_emi <= v_foir_limit;

            v_test_loan := v_test_loan - 10000;
        END LOOP;

        IF v_test_loan < 0 THEN
            v_test_loan := 0;
        END IF;

        v_approved_amount := v_test_loan;
    END IF;

    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE('       LOAN AFFORDABILITY CHECK');
    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE('Monthly Salary : Rs.' || v_monthly_salary);
    DBMS_OUTPUT.PUT_LINE('Existing EMI   : Rs.' || v_existing_emi);
    DBMS_OUTPUT.PUT_LINE('Loan Amount    : Rs.' || v_loan_amount);
    DBMS_OUTPUT.PUT_LINE('Annual Rate    : ' || v_annual_rate || '%');
    DBMS_OUTPUT.PUT_LINE('Tenure         : ' || v_tenure_months || ' months');
    DBMS_OUTPUT.PUT_LINE('Calculated EMI : Rs.' || v_emi);
    DBMS_OUTPUT.PUT_LINE('FOIR Limit     : Rs.' || v_foir_limit);
    DBMS_OUTPUT.PUT_LINE('Approved Amount: Rs.' || v_approved_amount);
    DBMS_OUTPUT.PUT_LINE('Decision       : ' ||
        CASE
            WHEN v_decision = 'APPROVED' THEN 'APPROVED'
            WHEN v_decision = 'CONDITIONAL' THEN 'CONDITIONAL'
            ELSE 'REJECTED'
        END);
    DBMS_OUTPUT.PUT_LINE('Monthly Cost   : Rs.' ||
                         ROUND(v_existing_emi + v_emi, 2));
END;
/
