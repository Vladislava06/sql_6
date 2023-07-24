DROP DATABASE IF EXISTS hw_6;
CREATE DATABASE IF NOT EXISTS hw_6;
USE hw_6;

CREATE TABLE users_old AS SELECT * FROM users WHERE 1=0;

CREATE OR REPLACE PROCEDURE move_users_to_old (p_user_id INT) AS

BEGIN

SAVEPOINT sp;

DECLARE
v_firstname users.firstname%TYPE;

v_lastname users.lastname%TYPE;

v_email users.email%TYPE;

BEGIN

SELECT firstname, lastname, email INTO v_firstname, v_lastname, v_email

FROM users

WHERE id = p_user_id

FOR UPDATE

INSERT INTO users_old (id, firstname, lastname, email)

VALUES ( p_user_id, v_firstname, v_lastname, v_email)

DELETE FROM users WHERE id = p_user_id;

COMMIT;

EXCEPTION 
    WHEN OTHERS THEN 
        ROLLBACK TO sp;
        RAISE;
    END;
END;