/* =====================================================================
   PL/SQL Unit 1 - Practical Exercise Bank - RUCHI SUTHAR
   Roll No: 51
   PERSONAL DETAILS USED:
   Name: Ruchi Suthar
   Roll No: 51
   DOB: 07-MAR-2007
   Home City used for city-based examples: Ahmedabad
   Marks used where the reference requires marks: 420/500
   Run SET SERVEROUTPUT ON before every block.
   ===================================================================== */

SET SERVEROUTPUT ON;

-- =====================================================================
-- P1.1  My First PL/SQL Block
-- lucky number = 51 MOD 7 + 1 = 3
-- =====================================================================
DECLARE
    v_name     VARCHAR2(50) := 'Ruchi Suthar';
    v_roll_no  NUMBER := 51;
    v_message  VARCHAR2(100);
    v_lucky    NUMBER;
BEGIN
    v_message := 'Welcome to PL/SQL!';
    v_lucky    := MOD(v_roll_no, 7) + 1;

    DBMS_OUTPUT.PUT_LINE('Name       : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Roll No    : ' || v_roll_no);
    DBMS_OUTPUT.PUT_LINE(v_message);
    DBMS_OUTPUT.PUT_LINE('Lucky Number: ' || v_lucky);
END;
/


-- =====================================================================
-- P1.2  Variables and Data Types
-- >>> FILL IN your own marks (out of 500) <<<
-- =====================================================================
DECLARE
    v_name       VARCHAR2(50) := 'Ruchi Suthar';  
    v_marks      NUMBER(5,2)  := 420;               
    v_percentage NUMBER(5,2);
    v_dob        DATE         := TO_DATE('07-MAR-2007','DD-MON-YYYY');
    v_passed     BOOLEAN;
BEGIN
    v_percentage := ROUND((v_marks/500)*100, 2);
    v_passed     := v_percentage >= 40;

    DBMS_OUTPUT.PUT_LINE('Name       : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Marks      : ' || v_marks);
    DBMS_OUTPUT.PUT_LINE('Percentage : ' || v_percentage || '%');
    DBMS_OUTPUT.PUT_LINE('Today''s Date: ' || TO_CHAR(SYSDATE,'DD-MON-YYYY'));

    IF v_passed THEN
        DBMS_OUTPUT.PUT_LINE('Result     : PASS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Result     : FAIL');
    END IF;
END;
/


-- =====================================================================
-- P1.3  Constants, NULL and NVL
-- base_price = 51*500 + 1000 = 26500
-- =====================================================================
DECLARE
    c_gst_rate  CONSTANT NUMBER := 18;
    v_base_price NUMBER := 26500;
    v_cgst      NUMBER;
    v_sgst      NUMBER;
    v_total     NUMBER;

    v_city      VARCHAR2(50) := NULL;
BEGIN
    -- Part A: GST breakdown
    v_cgst  := v_base_price * 9/100;
    v_sgst  := v_base_price * 9/100;
    v_total := v_base_price + v_cgst + v_sgst;

    DBMS_OUTPUT.PUT_LINE('---- GST Breakdown ----');
    DBMS_OUTPUT.PUT_LINE('Base Price : ' || v_base_price);
    DBMS_OUTPUT.PUT_LINE('CGST (9%)  : ' || v_cgst);
    DBMS_OUTPUT.PUT_LINE('SGST (9%)  : ' || v_sgst);
    DBMS_OUTPUT.PUT_LINE('Total      : ' || v_total);

    -- Part B: NVL vs NVL2
    DBMS_OUTPUT.PUT_LINE('---- NVL Demo ----');
    DBMS_OUTPUT.PUT_LINE('City (NVL) : ' || NVL(v_city, 'Ahmedabad'));

    DBMS_OUTPUT.PUT_LINE('---- NVL2 Demo ----');
    DBMS_OUTPUT.PUT_LINE(
        NVL2(v_city, 'City Known: ' || v_city, 'City Unknown')
    );
    -- Difference: NVL only substitutes when NULL and returns same type value.
    -- NVL2 lets you choose DIFFERENT expressions for "not null" vs "null" cases.
END;
/


-- =====================================================================
-- P1.4  SELECT INTO - Employee Data Fetcher
-- employee_id = 100 + (51 MOD 7) = 102   (valid test)
-- second test with employee_id = 51 (likely not found)
-- =====================================================================
DECLARE
    v_fname employees.first_name%TYPE;
    v_sal   employees.salary%TYPE;
    v_id    NUMBER := 102;   -- valid test: 100 + (51 MOD 7)
BEGIN
    SELECT first_name, salary
      INTO v_fname, v_sal
      FROM employees
     WHERE employee_id = v_id;

    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_fname || ' earns Rs.' || v_sal || ' per month.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found - check the ID.');
END;
/

-- second run with a non-existent id (roll number itself)
DECLARE
    v_fname employees.first_name%TYPE;
    v_sal   employees.salary%TYPE;
    v_id    NUMBER := 51;    -- roll_no, likely not found
BEGIN
    SELECT first_name, salary
      INTO v_fname, v_sal
      FROM employees
     WHERE employee_id = v_id;

    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_fname || ' earns Rs.' || v_sal || ' per month.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found - check the ID.');
END;
/


-- =====================================================================
-- P1.5  %ROWTYPE - Employee Profile Card
-- employee_id = 100 + (51 MOD 9) + 1 = 107
-- =====================================================================
DECLARE
    v_emp employees%ROWTYPE;
    v_id  NUMBER := 107;
    v_yrs NUMBER;
BEGIN
    SELECT * INTO v_emp
      FROM employees
     WHERE employee_id = v_id;

    v_yrs := TRUNC(MONTHS_BETWEEN(SYSDATE, v_emp.hire_date)/12);

    DBMS_OUTPUT.PUT_LINE('======= EMPLOYEE PROFILE CARD =======');
    DBMS_OUTPUT.PUT_LINE('Name        : ' || v_emp.first_name || ' ' || v_emp.last_name);
    DBMS_OUTPUT.PUT_LINE('Job ID      : ' || v_emp.job_id);
    DBMS_OUTPUT.PUT_LINE('Dept ID     : ' || v_emp.department_id);
    DBMS_OUTPUT.PUT_LINE('Salary      : ' || TO_CHAR(v_emp.salary, 'Rs.99,999'));
    DBMS_OUTPUT.PUT_LINE('Hire Date   : ' || TO_CHAR(v_emp.hire_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Experience  : ' || v_yrs || ' years');

    IF v_yrs > 10 THEN
        DBMS_OUTPUT.PUT_LINE('Status      : Senior Employee');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
END;
/


-- =====================================================================
-- P1.6  Bank Interest Calculator - SI and CI
-- principal = 51*1000 = 51000, rate = birth_month*0.5+4, years = 3
-- >>> FILL IN your birth month <<<
-- =====================================================================
DECLARE
    v_p NUMBER := 51000;
    v_birth_month NUMBER := 3;      -- >>> FILL THIS IN (1-12) <<<
    v_r NUMBER;
    v_t NUMBER := 3;
    v_si NUMBER;
    v_ci NUMBER;
    v_amt_si NUMBER;
    v_amt_ci NUMBER;
    v_diff_pct NUMBER;
BEGIN
    v_r := v_birth_month * 0.5 + 4;

    v_si := v_p * v_r * v_t / 100;
    v_ci := v_p * (POWER(1 + v_r/100, v_t)) - v_p;

    v_amt_si := v_p + v_si;
    v_amt_ci := v_p + v_ci;

    v_diff_pct := (v_ci - v_si) / v_si * 100;

    DBMS_OUTPUT.PUT_LINE('Principal        : Rs.' || TO_CHAR(v_p, '99,99,999'));
    DBMS_OUTPUT.PUT_LINE('Rate             : ' || v_r || '%');
    DBMS_OUTPUT.PUT_LINE('Years            : ' || v_t);
    DBMS_OUTPUT.PUT_LINE('Simple Interest  : Rs.' || TO_CHAR(v_si, '99,99,999.99'));
    DBMS_OUTPUT.PUT_LINE('Final (SI)       : Rs.' || TO_CHAR(v_amt_si, '99,99,999.99'));
    DBMS_OUTPUT.PUT_LINE('Compound Interest: Rs.' || TO_CHAR(v_ci, '99,99,999.99'));
    DBMS_OUTPUT.PUT_LINE('Final (CI)       : Rs.' || TO_CHAR(v_amt_ci, '99,99,999.99'));
    DBMS_OUTPUT.PUT_LINE('CI - SI Diff %   : ' || ROUND(v_diff_pct,2) || '%');

    IF v_diff_pct > 10 THEN
        DBMS_OUTPUT.PUT_LINE('Tip: FD is better than savings account for this amount.');
    END IF;
END;
/


-- =====================================================================
-- P1.7  Nested Blocks - Scope Explorer
-- >>> FILL IN your home city/district <<<
-- =====================================================================
<<outer>>
DECLARE
    v_city VARCHAR2(30) := 'Ahmedabad'; 
    v_num  NUMBER := 100;
BEGIN
    <<middle>>
    DECLARE
        v_city VARCHAR2(30) := 'Ahmedabad';
        v_num  NUMBER := 200;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Middle Level v_city : ' || v_city);
        DBMS_OUTPUT.PUT_LINE('Middle Level v_num  : ' || v_num);
        DBMS_OUTPUT.PUT_LINE('Outer v_city (via label): ' || outer.v_city);

        <<inner>>
        DECLARE
            v_num NUMBER := 300;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Inner Level v_city (from middle): ' || middle.v_city);
            DBMS_OUTPUT.PUT_LINE('Inner Level v_num   : ' || v_num);
            DBMS_OUTPUT.PUT_LINE('Outer v_city (from inner): ' || outer.v_city);
        END inner;

        DBMS_OUTPUT.PUT_LINE('Back in Middle, v_num: ' || v_num);
    END middle;

    DBMS_OUTPUT.PUT_LINE('Outer Level v_city  : ' || v_city);  -- proves it's still original
    DBMS_OUTPUT.PUT_LINE('Outer Level v_num   : ' || v_num);
END outer;
/


-- =====================================================================
-- P1.8  Student ID Card Generator - String Functions
-- roll_no = 51 ; >>> FILL IN full name & DOB <<<
-- =====================================================================
DECLARE
    v_name  VARCHAR2(50) := 'Ruchi Suthar';  
    v_roll  NUMBER := 51;
    v_dob   DATE   := TO_DATE('07-MAR-2007','DD-MON-YYYY');
    v_upper VARCHAR2(50);
    v_first VARCHAR2(50);
    v_last  VARCHAR2(50);
    v_id    VARCHAR2(20);
    v_age   NUMBER;
BEGIN
    v_upper := UPPER(v_name);
    v_first := SUBSTR(v_name, 1, INSTR(v_name, ' ') - 1);
    v_last  := SUBSTR(v_name, INSTR(v_name, ' ') + 1);

    v_id  := 'LJICA' || TO_CHAR(v_dob, 'YYYY') || LPAD(v_roll, 3, '0');
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_dob)/12);

    IF LENGTH(v_name) > 20 THEN
        v_last := SUBSTR(v_last, 1, 1) || '.';
    END IF;

    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('NAME:', 12) || v_upper);
    DBMS_OUTPUT.PUT_LINE(RPAD('ID NO:', 12) || v_id);
    DBMS_OUTPUT.PUT_LINE(RPAD('AGE:', 12) || v_age);
    DBMS_OUTPUT.PUT_LINE(RPAD('FIRST NAME:', 12) || v_first);
    DBMS_OUTPUT.PUT_LINE('======================================');
END;
/


-- =====================================================================
-- P1.9  Torrent Power Electricity Bill
-- units = 51*10 + 50 = 560
-- =====================================================================
DECLARE
    v_consumer   VARCHAR2(50) := 'Ruchi Suthar';
    v_units      NUMBER := 560;
    c_rate       CONSTANT NUMBER := 5;
    c_fixed      CONSTANT NUMBER := 70;
    v_energy     NUMBER;
    v_total      NUMBER;
BEGIN
    v_energy := v_units * c_rate;
    v_total  := v_energy + c_fixed;

    DBMS_OUTPUT.PUT_LINE('------ TORRENT POWER BILL ------');
    DBMS_OUTPUT.PUT_LINE('Consumer Name : ' || v_consumer);
    DBMS_OUTPUT.PUT_LINE('Units Consumed: ' || v_units);
    DBMS_OUTPUT.PUT_LINE('Energy Charge : Rs.' || v_energy);
    DBMS_OUTPUT.PUT_LINE('Fixed Charge  : Rs.' || c_fixed);
    DBMS_OUTPUT.PUT_LINE('Total         : Rs.' || v_total);
END;
/


-- =====================================================================
-- P1.10  Temperature Converter
-- celsius = 51 MOD 20 + 25 = 36
-- =====================================================================
DECLARE
    v_c  NUMBER := 36;
    v_f  NUMBER;
    v_k  NUMBER;
    v_f2 NUMBER := 98.6;
    v_c2 NUMBER;
BEGIN
    v_f := ROUND(v_c * 9/5 + 32, 1);
    v_k := v_c + 273.15;

    DBMS_OUTPUT.PUT_LINE('Celsius    : ' || v_c);
    DBMS_OUTPUT.PUT_LINE('Fahrenheit : ' || v_f);
    DBMS_OUTPUT.PUT_LINE('Kelvin     : ' || v_k);

    v_c2 := (v_f2 - 32) * 5/9;
    DBMS_OUTPUT.PUT_LINE('Reverse Check: ' || v_f2 || ' F = ' || ROUND(v_c2,0) || ' C');

    -- Observation: C*9/5+32 and C*(9/5)+32 give the SAME result here because
    -- * and / have equal precedence and are evaluated left-to-right,
    -- so C*9/5 = (C*9)/5 either way. Brackets only matter if precedence
    -- would otherwise change (e.g. 9/5+32 done before multiplying by C).
END;
/


-- =====================================================================
-- P1.11  Date Function Playground
-- N (months) = 51 MOD 12 + 1 = 4
-- =====================================================================
DECLARE
    v_n NUMBER := 4;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Today            : ' || TO_CHAR(SYSDATE, 'Day, DD "th" Month YYYY'));
    DBMS_OUTPUT.PUT_LINE('After ' || v_n || ' months  : ' || TO_CHAR(ADD_MONTHS(SYSDATE, v_n), 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Last day of month: ' || TO_CHAR(LAST_DAY(SYSDATE), 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Next Monday      : ' || TO_CHAR(NEXT_DAY(SYSDATE, 'MONDAY'), 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Days left in month: ' || TRUNC(LAST_DAY(SYSDATE) - SYSDATE));
END;
/


-- =====================================================================
-- P1.12  Result Card with BOOLEAN and NVL
-- each mark = 51 MOD 30 + 60 = 81  (v_m5 stays NULL)
-- =====================================================================
DECLARE
    v_m1 NUMBER := 81;
    v_m2 NUMBER := 81;
    v_m3 NUMBER := 81;
    v_m4 NUMBER := 81;
    v_m5 NUMBER := NULL;   -- absent
    v_total NUMBER;
    v_pct   NUMBER;
    v_passed BOOLEAN;
BEGIN
    v_total := v_m1 + v_m2 + v_m3 + v_m4 + NVL(v_m5, 0);
    v_pct   := ROUND(v_total/500*100, 2);
    v_passed := (v_pct >= 40);

    DBMS_OUTPUT.PUT_LINE('Total     : ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Percentage: ' || v_pct || '%');

    -- Note: BOOLEAN v_passed cannot be printed directly via DBMS_OUTPUT.PUT_LINE;
    -- it must first be converted to text using CASE/IF.
    DBMS_OUTPUT.PUT_LINE('Result    : ' || CASE WHEN v_passed THEN 'PASS' ELSE 'FAIL' END);
END;
/


-- =====================================================================
-- P1.13  ATM Note Splitter
-- amount = 51*137 + 1000 = 7987
-- =====================================================================
DECLARE
    v_amt  NUMBER := 7987;
    v_n500 NUMBER;
    v_n200 NUMBER;
    v_n100 NUMBER;
    v_rem  NUMBER;
BEGIN
    v_n500 := TRUNC(v_amt/500);
    v_rem  := MOD(v_amt,500);

    v_n200 := TRUNC(v_rem/200);
    v_rem  := MOD(v_rem,200);

    v_n100 := TRUNC(v_rem/100);
    v_rem  := MOD(v_rem,100);

    DBMS_OUTPUT.PUT_LINE('Amount           : ' || v_amt);
    DBMS_OUTPUT.PUT_LINE('Notes of Rs.500  : ' || v_n500);
    DBMS_OUTPUT.PUT_LINE('Notes of Rs.200  : ' || v_n200);
    DBMS_OUTPUT.PUT_LINE('Notes of Rs.100  : ' || v_n100);
    DBMS_OUTPUT.PUT_LINE('Undispensed rem. : ' || v_rem);
END;
/


-- =====================================================================
-- P1.14  Mobile Recharge Receipt
-- plan index = 51 MOD 4 + 1 = 4  => plans (199,299,399,599) -> 599
-- =====================================================================
DECLARE
    TYPE plan_array IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_plans plan_array;
    v_idx   NUMBER := 4;
    c_gst   CONSTANT NUMBER := 18;
    v_plan  NUMBER;
    v_gst   NUMBER;
    v_total NUMBER;
    v_validity DATE;
BEGIN
    v_plans(1) := 199; v_plans(2) := 299; v_plans(3) := 399; v_plans(4) := 599;
    v_plan := v_plans(v_idx);

    v_gst   := v_plan * c_gst/100;
    v_total := v_plan + v_gst;
    v_validity := SYSDATE + 28;

    DBMS_OUTPUT.PUT_LINE('---------- RECHARGE RECEIPT ----------');
    DBMS_OUTPUT.PUT_LINE(RPAD('Plan:',15) || TO_CHAR(v_plan,'99,999.99'));
    DBMS_OUTPUT.PUT_LINE(RPAD('GST @18%:',15) || TO_CHAR(v_gst,'99,999.99'));
    DBMS_OUTPUT.PUT_LINE(RPAD('Total:',15) || TO_CHAR(v_total,'99,999.99'));
    DBMS_OUTPUT.PUT_LINE(RPAD('Valid Till:',15) || TO_CHAR(v_validity,'DD-MON-YYYY'));
END;
/


-- =====================================================================
-- P1.15  Department Statistics with SELECT INTO
-- department_id = (51 MOD 6 + 1) * 10 = 40
-- =====================================================================
DECLARE
    v_dept NUMBER := 40;
    v_cnt  NUMBER;
    v_avg  NUMBER;
    v_max  NUMBER;
BEGIN
    SELECT COUNT(*), ROUND(AVG(salary),2), MAX(salary)
      INTO v_cnt, v_avg, v_max
      FROM employees
     WHERE department_id = v_dept;

    DBMS_OUTPUT.PUT_LINE('Dept ID      : ' || v_dept);
    DBMS_OUTPUT.PUT_LINE('Employees    : ' || v_cnt);
    DBMS_OUTPUT.PUT_LINE('Avg Salary   : ' || v_avg);
    DBMS_OUTPUT.PUT_LINE('Max Salary   : ' || v_max);

    -- COUNT(*) is an aggregate: it always returns exactly ONE row
    -- (even 0 when no matching employees), so SELECT INTO always has
    -- a row to fetch and NO_DATA_FOUND is never raised.
END;
/


-- =====================================================================
-- P1.16  Department Lookup with %TYPE
-- department_id = ((51+2) MOD 11 + 1) * 10 = 100
-- =====================================================================
DECLARE
    v_dname departments.department_name%TYPE;
    v_loc   departments.location_id%TYPE;
    v_id    NUMBER := 100;
BEGIN
    SELECT department_name, location_id
      INTO v_dname, v_loc
      FROM departments
     WHERE department_id = v_id;

    DBMS_OUTPUT.PUT_LINE('Dept ' || v_id || ': ' || v_dname || ' at location ' || v_loc);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Department not found.');
END;
/
-- Because v_dname is anchored with %TYPE to departments.department_name,
-- it automatically inherits whatever data type/size the column has.
-- If the DBA widens department_name to VARCHAR2(60), the anchor
-- picks that up automatically at compile time -- no code change needed.


-- =====================================================================
-- P1.17  Home Loan EMI Calculator
-- principal = 51*10000 + 50000 = 560000
-- =====================================================================
DECLARE
    v_p    NUMBER := 560000;
    v_rate NUMBER := 9;
    v_yrs  NUMBER := 5;
    v_r    NUMBER;
    v_n    NUMBER;
    v_emi  NUMBER;
    v_total_payment NUMBER;
    v_total_interest NUMBER;
    v_interest_pct NUMBER;
BEGIN
    v_r := v_rate/12/100;
    v_n := v_yrs*12;

    v_emi := ROUND(v_p * v_r * POWER(1+v_r, v_n) / (POWER(1+v_r, v_n) - 1), 2);
    v_total_payment  := ROUND(v_emi * v_n, 2);
    v_total_interest := ROUND(v_total_payment - v_p, 2);
    v_interest_pct   := ROUND(v_total_interest/v_total_payment*100, 2);

    DBMS_OUTPUT.PUT_LINE('Principal       : Rs.' || TO_CHAR(v_p, '99,99,999'));
    DBMS_OUTPUT.PUT_LINE('EMI             : Rs.' || TO_CHAR(v_emi, '99,999.99'));
    DBMS_OUTPUT.PUT_LINE('Total Payment   : Rs.' || TO_CHAR(v_total_payment, '99,99,999.99'));
    DBMS_OUTPUT.PUT_LINE('Total Interest  : Rs.' || TO_CHAR(v_total_interest, '99,99,999.99'));
    DBMS_OUTPUT.PUT_LINE('Interest % of Payment: ' || v_interest_pct || '%');
END;
/


-- =====================================================================
-- P1.18  Messy Name Cleaner
-- >>> FILL IN your own name, typed messily <<<
-- =====================================================================
DECLARE
    v_raw   VARCHAR2(100) := '  your   NAME  ';  -- >>> FILL THIS IN (messy) <<<
    v_clean VARCHAR2(100);
    v_first VARCHAR2(50);
    v_last  VARCHAR2(50);
    v_email VARCHAR2(100);
BEGIN
    -- one REPLACE pass may leave triple/odd spacing collapsed to double;
    -- applying it twice guarantees full collapse to single spaces
    v_clean := INITCAP(REPLACE(REPLACE(TRIM(v_raw), '  ', ' '), '  ', ' '));

    v_first := SUBSTR(v_clean, 1, INSTR(v_clean, ' ') - 1);
    v_last  := SUBSTR(v_clean, INSTR(v_clean, ' ') + 1);
    v_email := LOWER(v_first || '.' || v_last || '@ljku.edu.in');

    DBMS_OUTPUT.PUT_LINE('Raw Name      : "' || v_raw || '" (Length=' || LENGTH(v_raw) || ')');
    DBMS_OUTPUT.PUT_LINE('Cleaned Name  : "' || v_clean || '" (Length=' || LENGTH(v_clean) || ')');
    DBMS_OUTPUT.PUT_LINE('First Name    : ' || v_first);
    DBMS_OUTPUT.PUT_LINE('Last Name     : ' || v_last);
    DBMS_OUTPUT.PUT_LINE('Email         : ' || v_email);
END;
/


-- =====================================================================
-- P1.19  Bank Branch Hierarchy - Nested Scope
-- deposit = 51*1000 = 51000 ; >>> FILL IN your home city <<<
-- =====================================================================
<<bank>>
DECLARE
    v_bank  VARCHAR2(30) := 'LJ Bank';
    v_total_deposit NUMBER := 0;
BEGIN
    <<branch>>
    DECLARE
        v_branch VARCHAR2(30) := 'Ahmedabad';
        v_dep    NUMBER := 51000;
    BEGIN
        bank.v_total_deposit := bank.v_total_deposit + v_dep;

        <<counter>>
        DECLARE
            v_token NUMBER := 1;
        BEGIN
            DBMS_OUTPUT.PUT_LINE(bank.v_bank || ' | ' || branch.v_branch || ' | Token ' || v_token);
        END counter;

        -- The line below, if uncommented, raises PLS-00201: identifier
        -- 'V_TOKEN' must be declared -- because v_token only exists
        -- inside the <<counter>> block and is out of scope here.
        -- DBMS_OUTPUT.PUT_LINE('Token was: ' || v_token);

    END branch;

    DBMS_OUTPUT.PUT_LINE('Total Deposit at Bank Level: ' || bank.v_total_deposit);
END bank;
/


-- =====================================================================
-- P1.20  Railway PNR and Ticket Generator
-- roll=51 ; base fare = 51*50+200 = 2750 ; journey = SYSDATE + (51 MOD 30 + 1) = +22 days
-- >>> FILL IN your name & DOB <<<
-- =====================================================================
DECLARE
    v_name  VARCHAR2(50) := 'Ruchi Suthar'; 
    v_roll  NUMBER := 51;
    v_dob   DATE   := TO_DATE('07-MAR-2007','DD-MON-YYYY');
    v_pnr   VARCHAR2(20);
    v_jdate DATE;
    v_fare  NUMBER;
    v_age   NUMBER;
    v_final_fare NUMBER;
BEGIN
    v_pnr   := 'GJ' || TO_CHAR(SYSDATE, 'YYMM') || LPAD(v_roll, 4, '0');
    v_jdate := SYSDATE + (MOD(v_roll, 30) + 1);
    v_fare  := v_roll * 50 + 200;
    v_age   := TRUNC(MONTHS_BETWEEN(SYSDATE, v_dob)/12);

    IF v_age >= 60 THEN
        v_final_fare := v_fare * 0.6; -- 40% concession
    ELSE
        v_final_fare := v_fare;
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD('=',40,'='));
    DBMS_OUTPUT.PUT_LINE(RPAD('PASSENGER:',15) || v_name);
    DBMS_OUTPUT.PUT_LINE(RPAD('PNR:',15) || v_pnr);
    DBMS_OUTPUT.PUT_LINE(RPAD('JOURNEY DATE:',15) || TO_CHAR(v_jdate,'Day, DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE(RPAD('AGE:',15) || v_age);
    DBMS_OUTPUT.PUT_LINE(RPAD('BASE FARE:',15) || v_fare);
    DBMS_OUTPUT.PUT_LINE(RPAD('FINAL FARE:',15) || v_final_fare);
    DBMS_OUTPUT.PUT_LINE(RPAD('=',40,'='));
END;
/


-- =====================================================================
-- P1.21  Salary Slip Generator with %ROWTYPE
-- employee_id = 100 + (51 MOD 20) = 111
-- =====================================================================
DECLARE
    v_emp employees%ROWTYPE;
    v_id  NUMBER := 111;
    v_da  NUMBER;
    v_hra NUMBER;
    v_pf  NUMBER;
    v_net NUMBER;
BEGIN
    SELECT * INTO v_emp FROM employees WHERE employee_id = v_id;

    v_da  := v_emp.salary * 0.40;
    v_hra := v_emp.salary * 0.20;
    v_pf  := v_emp.salary * 0.12;
    v_net := v_emp.salary + v_da + v_hra - v_pf;

    DBMS_OUTPUT.PUT_LINE(RPAD('=',45,'='));
    DBMS_OUTPUT.PUT_LINE('        LJ COMPANY - SALARY SLIP');
    DBMS_OUTPUT.PUT_LINE('        ' || TO_CHAR(SYSDATE,'Month YYYY'));
    DBMS_OUTPUT.PUT_LINE(RPAD('=',45,'='));
    DBMS_OUTPUT.PUT_LINE('Employee : ' || v_emp.first_name || ' ' || v_emp.last_name);
    DBMS_OUTPUT.PUT_LINE('Emp ID   : ' || v_emp.employee_id);
    DBMS_OUTPUT.PUT_LINE('Job      : ' || v_emp.job_id);
    DBMS_OUTPUT.PUT_LINE(RPAD('-',45,'-'));
    DBMS_OUTPUT.PUT_LINE(RPAD('Basic Salary',20) || LPAD(TO_CHAR(v_emp.salary,'99,99,999.99'),20));
    DBMS_OUTPUT.PUT_LINE(RPAD('DA (40%)',20)      || LPAD(TO_CHAR(v_da,'99,99,999.99'),20));
    DBMS_OUTPUT.PUT_LINE(RPAD('HRA (20%)',20)     || LPAD(TO_CHAR(v_hra,'99,99,999.99'),20));
    DBMS_OUTPUT.PUT_LINE(RPAD('PF Deduction (12%)',20) || LPAD(TO_CHAR(-v_pf,'99,99,999.99'),20));
    DBMS_OUTPUT.PUT_LINE(RPAD('-',45,'-'));
    DBMS_OUTPUT.PUT_LINE(RPAD('NET PAY',20) || LPAD(TO_CHAR(v_net,'99,99,999.99'),20));
    DBMS_OUTPUT.PUT_LINE(RPAD('=',45,'='));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
END;
/


-- =====================================================================
-- P1.22  Kirana Store Bill with NULL Coupon
-- qty = 51 MOD 5 + 2 = 3 ; price = 51*100 + 400 = 5500
-- Run twice: coupon NULL, then coupon = 10
-- =====================================================================
DECLARE
    v_qty NUMBER := 3;
    v_price NUMBER := 5500;
    v_coupon NUMBER := NULL;   -- first run: no coupon
    v_gross NUMBER;
    v_disc  NUMBER;
    v_taxable NUMBER;
    v_cgst NUMBER;
    v_sgst NUMBER;
    v_total NUMBER;
BEGIN
    v_gross   := v_qty * v_price;
    v_disc    := v_gross * NVL(v_coupon,0)/100;
    v_taxable := v_gross - v_disc;
    v_cgst    := v_taxable * 9/100;
    v_sgst    := v_taxable * 9/100;
    v_total   := ROUND(v_taxable + v_cgst + v_sgst);

    DBMS_OUTPUT.PUT_LINE('--------- KIRANA BILL (No Coupon) ---------');
    DBMS_OUTPUT.PUT_LINE('Qty x Price : ' || v_qty || ' x ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Gross       : ' || v_gross);
    DBMS_OUTPUT.PUT_LINE(NVL2(v_coupon, 'Coupon applied: '||v_coupon||'%', 'No coupon'));
    DBMS_OUTPUT.PUT_LINE('Discount    : ' || v_disc);
    DBMS_OUTPUT.PUT_LINE('Taxable     : ' || v_taxable);
    DBMS_OUTPUT.PUT_LINE('CGST+SGST   : ' || (v_cgst+v_sgst));
    DBMS_OUTPUT.PUT_LINE('Final Total : Rs.' || v_total);
END;
/

DECLARE
    v_qty NUMBER := 3;
    v_price NUMBER := 5500;
    v_coupon NUMBER := 10;    -- second run: 10% coupon
    v_gross NUMBER;
    v_disc  NUMBER;
    v_taxable NUMBER;
    v_cgst NUMBER;
    v_sgst NUMBER;
    v_total NUMBER;
BEGIN
    v_gross   := v_qty * v_price;
    v_disc    := v_gross * NVL(v_coupon,0)/100;
    v_taxable := v_gross - v_disc;
    v_cgst    := v_taxable * 9/100;
    v_sgst    := v_taxable * 9/100;
    v_total   := ROUND(v_taxable + v_cgst + v_sgst);

    DBMS_OUTPUT.PUT_LINE('--------- KIRANA BILL (10% Coupon) ---------');
    DBMS_OUTPUT.PUT_LINE('Qty x Price : ' || v_qty || ' x ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Gross       : ' || v_gross);
    DBMS_OUTPUT.PUT_LINE(NVL2(v_coupon, 'Coupon applied: '||v_coupon||'%', 'No coupon'));
    DBMS_OUTPUT.PUT_LINE('Discount    : ' || v_disc);
    DBMS_OUTPUT.PUT_LINE('Taxable     : ' || v_taxable);
    DBMS_OUTPUT.PUT_LINE('CGST+SGST   : ' || (v_cgst+v_sgst));
    DBMS_OUTPUT.PUT_LINE('Final Total : Rs.' || v_total);
END;
/


-- =====================================================================
-- P1.23  Debug Challenge - Fix the Broken Block
-- v_sal = 51*1000 + 20000 = 71000 ; >>> FILL IN your name <<<
-- =====================================================================
DECLARE
    v_name       VARCHAR2(50) := 'Ruchi Suthar'; -- BUG 2 FIX: VARCHAR2(5) was too small for a name
    c_bonus_rate CONSTANT NUMBER := 0.1;            -- BUG 3 FIX: CONSTANT must be assigned a value at declaration
    v_bonus      NUMBER;
    v_sal        NUMBER := 71000;                   -- BUG 4 FIX: added missing semicolon after declaration
    v_fname      employees.first_name%TYPE;
BEGIN
    v_bonus := v_sal * c_bonus_rate;                -- BUG 1 FIX: used := instead of =

    SELECT first_name INTO v_fname                  -- BUG 5 FIX: added INTO clause (SELECT needs INTO in PL/SQL)
      FROM employees
     WHERE employee_id = 100;

    DBMS_OUTPUT.PUT_LINE('Bonus: ' || v_bonus);      -- BUG (missing semicolon after PUT_LINE) FIX: added ;
END;
/
-- Bugs fixed:
-- 1) v_bonus = v_sal*0.1        -> should be :=  (assignment, not comparison)
-- 2) v_name VARCHAR2(5)         -> too small to hold a full name, widened to VARCHAR2(50)
-- 3) v_bonus CONSTANT NUMBER;   -> CONSTANT must have a value at declaration, made it c_bonus_rate := 0.1
-- 4) v_sal NUMBER := 25000 BEGIN -> missing semicolon after the declaration, added ;
-- 5) SELECT first_name FROM employees WHERE employee_id = 100;  -> missing INTO clause, added INTO v_fname
