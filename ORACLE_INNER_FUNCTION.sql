-- Oracle 내장함수
-- 문자열 함수
SELECT ASCII('A'), CHR(65), ASCIISTR('한'), UNISTR('\D55C') FROM DUAL;

SELECT LENGTH('한글'), LENGTH('AB'), LENGTHB('한글'), LENGTHB('AB') FROM DUAL;

SELECT CONCAT('이것이', 'ORACLE이다'), '이것이'||' '||'ORACLE이다' FROM DUAL;

SELECT INSTR('이것이 ORACLE이다. 이것도 오라클이다', '이것') FROM DUAL;
SELECT INSTR('이것이 ORACLE이다. 이것도 오라클이다', '이것', 2) FROM DUAL;
SELECT INSTRB('이것이 ORACLE이다. 이것도 오라클이다', '이것', 2) FROM DUAL;

SELECT LOWER('abcdEFGH'), UPPER('abcdEFGH'), INITCAP('this is oracle') FROM DUAL;

SELECT REPLACE('이것이 ORACLE이다','이것이', 'THIS IS') FROM DUAL;

SELECT TRANSLATE('이것이 ORACLE이다','이것', 'AB') FROM DUAL;

SELECT SUBSTR('대한민국만세', 3, 2) FROM DUAL;

SELECT REVERSE('Oracle') FROM DUAL;

SELECT LPAD('이것이', 10, '##') FROM DUAL; -- 한글은 2로 계산
SELECT RPAD('이것이', 10, '##') FROM DUAL;

SELECT LTRIM('    이것이'), RTRIM('이것이    ') FROM DUAL;
SELECT TRIM('    이것이    '), TRIM(BOTH 'ㅋ' FROM 'ㅋㅋㅋ재밌어요.ㅋㅋㅋ') FROM DUAL;

SELECT REGEXP_COUNT('이것이 오라클이다.', '이') FROM DUAL; -- 문자열에서 문자의 개수를 샌다.

-- 숫자 및 수학 함수
SELECT ABS(-100) FROM DUAL;

-- ACOS, ASIN, ATAN, ATAN2, SIN, COS, TAN : 삼각함수와 관련된 함수 제공

SELECT CEIL(4.7), FLOOR(4.7), ROUND(4.7) FROM DUAL; -- 올림, 내림, 반올림

-- EXP, LN, LOG : 지수, 로그와 관련된 함수 제공

SELECT MOD(157, 10) FROM DUAL; -- 157을 10으로 나눈 나머지 제공

SELECT POWER(2,3), SQRT(9) FROM DUAL; -- 제곱함수, 루트함수

SELECT SIGN(100), SIGN(0), SIGN(-1) FROM DUAL; -- 양수,음수 판단 제공 / 1,0,-1

SELECT TRUNC(12345.12345, 2), TRUNC(12345.12345, -2) FROM DUAL; -- 숫자를 소수점 기준으로 정수 위치까지 구하고 나머지는 버린다. / 12345.12, 12300

-- 날짜 및 시간 함수
SELECT ADD_MONTHS('2020-01-01', 5), ADD_MONTHS(SYSDATE, -5) FROM DUAL; -- 달 더하기, 빼기
SELECT TO_DATE('2020-01-01')+5, SYSDATE-5 FROM DUAL; -- 날짜 더하기, 빼기
SELECT CURRENT_DATE, SYSDATE, CURRENT_TIMESTAMP FROM DUAL; -- TIMESTAMP : 연/월/일 시:분:초 지역

SELECT EXTRACT(YEAR FROM DATE '2020-12-25'), EXTRACT(DAY FROM SYSDATE) FROM DUAL; -- 날짜에서 FROM앞의 날짜 형식을 추출한다.

SELECT LAST_DAY('2020-02-01') FROM DUAL; -- 날짜의 마지막 일 제공

SELECT NEXT_DAY('2020-02-01', '월요일'), NEXT_DAY(SYSDATE, '일요일') FROM DUAL; -- 주어진 날짜 다음의 해당 요일의 날짜를 구한다.

SELECT MONTHS_BETWEEN(SYSDATE, '1988-09-17') FROM DUAL; -- 날짜2에서 날짜1까지 몇개월이 지났는지 제공한다.

-- 형 변환 함수
SELECT BIN_TO_NUM(1,0), BIN_TO_NUM(1,1,1,1) FROM DUAL; -- 2진수 -> 10진수

SELECT NUMTODSINTERVAL(48, 'HOUR'), NUMTODSINTERVAL(360000, 'SECOND') FROM DUAL; -- 앞의 숫자가 뒤의 형식일 때, 몇일인지 계산한다.

SELECT NUMTOYMINTERVAL(37, 'MONTH'), NUMTOYMINTERVAL(1.5, 'YEAR') FROM DUAL;

-- 기타 변환 함수
-- 순위 함수
-- <순위함수이름>() OVER([PARTITION_BY<partition_by_list>]) ORDER BY <order_by_list>
SELECT ROW_NUMBER() OVER(ORDER BY HEIGHT DESC) AS "키큰순위", USERNAME, ADDR, HEIGHT FROM USERTBL; -- ROW_NUMBER() : 같은 수도 랭크 매김
SELECT ROW_NUMBER() OVER(ORDER BY HEIGHT DESC, USERNAME ASC) AS "키큰순위", USERNAME, ADDR, HEIGHT FROM USERTBL;
SELECT ADDR, ROW_NUMBER() OVER(PARTITION BY ADDR ORDER BY HEIGHT DESC, USERNAME ASC) AS "지역별키큰순위", USERNAME, HEIGHT FROM USERTBL;

SELECT DENSE_RANK() OVER(ORDER BY HEIGHT DESC) AS "키큰순위", USERNAME, ADDR, HEIGHT FROM USERTBL; -- DENSE_RANK() : 같은 수는 같은 랭크 매김

SELECT RANK() OVER(ORDER BY HEIGHT DESC) AS "키큰순위", USERNAME, ADDR, HEIGHT FROM USERTBL; -- 1,2,2,4등

SELECT NTILE(2) OVER(ORDER BY HEIGHT DESC) AS "반번호", USERNAME, ADDR, HEIGHT FROM USERTBL; -- NTILE : 나눌 그룹 개수로 나누기
SELECT NTILE(4) OVER(ORDER BY HEIGHT DESC) AS "반번호", USERNAME, ADDR, HEIGHT FROM USERTBL;

-- 분석 함수
SELECT USERNAME, ADDR, HEIGHT AS "키", HEIGHT - (LEAD(HEIGHT,1,0) OVER (ORDER BY HEIGHT DESC)) AS "다음 사람과 키 차이" FROM USERTBL; -- LEAD(기준열, 대상ROW더하기, 다음대상없을때 값)
SELECT USERNAME, ADDR, HEIGHT AS "키", HEIGHT - (LAG(HEIGHT,1,0) OVER (ORDER BY HEIGHT DESC)) AS "이전 사람과 키 차이" FROM USERTBL; -- LAG(기준열, 대상ROW빼기, 이전대상없을때 값)

SELECT ADDR, USERNAME, HEIGHT AS "키", HEIGHT - (FIRST_VALUE(HEIGHT) OVER (PARTITION BY ADDR ORDER BY HEIGHT DESC)) AS "지역별 최대키와 차이" FROM USERTBL;

SELECT ADDR, USERNAME, HEIGHT AS "키", (CUME_DIST() OVER (PARTITION BY ADDR ORDER BY HEIGHT DESC)) * 100 AS "누적인원백분율%" FROM USERTBL;

SELECT DISTINCT ADDR, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY HEIGHT) OVER (PARTITION BY ADDR) FROM USERTBL; -- 각 지역별로 키의 중앙값 계산

-- 피벗
CREATE TABLE PIVOTTEST(
    UNAME NCHAR(3),
    SEASON NCHAR(2),
    AMOUNT NUMBER(3)
);
INSERT INTO PIVOTTEST VALUES('김범수', '겨울', 10);
INSERT INTO PIVOTTEST VALUES('윤종신', '여름', 15);
INSERT INTO PIVOTTEST VALUES('김범수', '가을', 25);
INSERT INTO PIVOTTEST VALUES('김범수', '봄', 3);
INSERT INTO PIVOTTEST VALUES('김범수', '봄', 37);
INSERT INTO PIVOTTEST VALUES('윤종신', '겨울', 40);
INSERT INTO PIVOTTEST VALUES('김범수', '여름', 14);
INSERT INTO PIVOTTEST VALUES('김범수', '겨울', 22);
INSERT INTO PIVOTTEST VALUES('윤종신', '여름', 64);
SELECT * FROM PIVOTTEST;
-- SELECT * FROM PIVOTTEST 
--     PIVOT(SUM(AMOUNT) 
--         FOR SEASON 
--         IN('봄', '여름', '가을', '겨울'));

        






