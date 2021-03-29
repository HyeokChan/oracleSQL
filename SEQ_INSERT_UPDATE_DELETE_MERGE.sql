CREATE TABLE testTBL2(
    id NUMBER(4),
    userName NCHAR(3),
    age NUMBER(2),
    nation NCHAR(4) DEFAULT '대한민국'
);

-- 자동으로 증가하는 시퀀스
-- 시퀀스 생성
CREATE SEQUENCE idSEQ2 START WITH 1 INCREMENT BY 1;
INSERT INTO testTBL2 VALUES (idSEQ2.NEXTVAL, '유나', 25, DEFAULT);
INSERT INTO testTBL2 VALUES (idSEQ2.NEXTVAL, '혜정', 24, '영국');
SELECT * FROM testTBL2;
-- 시퀀스 상태 확인
-- DUAL TABLE : Oracle에 내장된 가상의 테이블, SELECT문의 형식상 FROM이 있어야 하므로 가상으로 붙여주는 테이블
SELECT idSEQ2.CURRVAL FROM DUAL;
SELECT 100*100 FROM DUAL;

-- 특정 범위의 값이 반복적으로 입력되도록 설정
CREATE TABLE testTBL3(id NUMBER(3));
CREATE SEQUENCE cycleSEQ
    START WITH 100
    INCREMENT BY 100
    MINVALUE 100
    MAXVALUE 300
    CYCLE
    NOCACHE;
INSERT INTO testTBL3 VALUES(cycleSEQ.NEXTVAL);
INSERT INTO testTBL3 VALUES(cycleSEQ.NEXTVAL);
INSERT INTO testTBL3 VALUES(cycleSEQ.NEXTVAL);
INSERT INTO testTBL3 VALUES(cycleSEQ.NEXTVAL);
SELECT * FROM testTBL3;

-- INSERT INTO SELECT : 대량의 샘플 데이터 생성
CREATE TABLE testTBL4(
    empID NUMBER(6),
    FirstName VARCHAR2(20),
    LastName VARCHAR2(25),
    Phone VARCHAR2(20)
);
INSERT INTO testTBL4
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER FROM HR.employees;
COMMIT;

-- UPDATE
UPDATE testTBL4 SET Phone='없음' WHERE FirstName='David';
SELECT * FROM testTBL4 WHERE FirstName='David';
ROLLBACK;
UPDATE buyTBL SET price=price*1.5;

-- DELETE FROM
DELETE FROM testTBL4 WHERE FirstName='Peter';
ROLLBACK;
DELETE FROM testTBL4 WHERE FirstName='Peter' AND ROWNUM<=2;

-- 대용량 테이블의 삭제와 효율성
CREATE TABLE bigTBL1 AS
    SELECT level AS bigID,
        ROUND(DBMS_RANDOM.VALUE(1,500000),0) AS numData
    FROM DUAL
    CONNECT BY level <= 500000;
    
CREATE TABLE bigTBL2 AS (SELECT bigID, numData FROM bigTBL1);
CREATE TABLE bigTBL3 AS (SELECT bigID, numData FROM bigTBL1);
-- 1.DELETE문 삭제 : 3.789s, 테이블 데이터만 삭제, 트랜잭션 로그 기록
DELETE FROM bigTBL1;
COMMIT;
-- 2.DROP문 삭제 : 0.119s, 테이블 자체 삭제
DROP TABLE bigTBL2;
-- 3.TRUNCATE문 삭제 : 0.065s, 테이블 데이터만 삭제, 로그기록안함
TRUNCATE TABLE bigTBL3;

-- MERGE:조건부 데이터 변경
CREATE TABLE memberTBL AS (SELECT userId, userName, addr FROM userTBL);

CREATE TABLE changeTBL(
    userId CHAR(8),
    userName NVARCHAR2(10),
    addr NCHAR(2),
    changeType NCHAR(4) -- 변경사유
);

INSERT INTO changeTBL VALUES('TKV', '태권브이', '한국', '신규가입');
INSERT INTO changeTBL VALUES('LSG', 'null', '제주', '주소변경');
INSERT INTO changeTBL VALUES('LJB', 'null', '영국', '주소변경');
INSERT INTO changeTBL VALUES('BBK', 'null', '탈퇴', '회원탈퇴');
INSERT INTO changeTBL VALUES('SSK', 'null', '탈퇴', '회원탈퇴');

MERGE INTO memberTBL M -- 변경될 테이블(target 테이블)
    -- 변경할 기준이 되는 테이블(source 테이블)
    USING (SELECT changeType, userId, userName, addr FROM changeTBL) C
    ON (M.userId = C.userId) -- userId를 기준으로 두 테이블을 비교한다.
    -- target 테이블에 source 테이블의 행이 있으면 주소를 변경한다.
    WHEN MATCHED THEN
        UPDATE SET M.addr = C.addr
        -- target 테이블에 source 테이블의 행이 있고, 사유가 회원탈퇴라면 해당 행을 삭제한다.
        DELETE WHERE C.changeType = '회원탈퇴'
    -- target 테이블에 source 테이블의 행이 없으면 새로운 행을 추가한다.
    WHEN NOT MATCHED THEN
        INSERT (userId, userName, addr) VALUES(C.userId, C.userName, C.addr);

COMMIT;
