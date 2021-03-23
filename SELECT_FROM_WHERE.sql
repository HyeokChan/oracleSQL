SELECT * FROM userTBL;

-- 기본적인 WHERE절
SELECT * FROM userTBL WHERE userName = '김경호';

-- 관계연산자 사용
SELECT userId, userName FROM userTBL WHERE birthYear >= 1970 OR height >=182;
SELECT userId, userName FROM userTBL WHERE birthYear >= 1970 AND height >=182;

-- BETWEEN, IN, LIKE
SELECT userName, height FROM userTBL WHERE height >= 180 AND height <=183;
SELECT userName, height FROM userTBL WHERE height BETWEEN 180 AND 183;

SELECT userName, addr FROM userTBL WHERE addr='경남' OR addr='전남' OR addr='경북';
SELECT userName, addr FROM userTBL WHERE addr IN ('경남', '전남', '경북');

SELECT userName, height FROM userTBL WHERE userName LIKE '김%';
SELECT userName, height FROM userTBL WHERE userName LIKE '_종신';

-- 서브쿼리
SELECT userName, height FROM userTBL
WHERE height > (SELECT height FROM userTBL WHERE userName = '김경호');

-- ANY : 서브쿼리의 반환값이 1개 초과일 때, OR 작용
--SELECT userName, height FROM userTBL
--WHERE height >= (SELECT height FROM userTBL WHERE addr = '경남');
SELECT userName, height FROM userTBL
WHERE height >= ANY(SELECT height FROM userTBL WHERE addr = '경남');
SELECT userName, height FROM userTBL
WHERE height = ANY(SELECT height FROM userTBL WHERE addr = '경남');
SELECT userName, height FROM userTBL
WHERE height IN (SELECT height FROM userTBL WHERE addr = '경남');

-- ALL : 서브쿼리의 반환값이 1개 초과일 때, AND 작용
SELECT userName, height FROM userTBL
WHERE height >= ALL(SELECT height FROM userTBL WHERE addr = '경남');

-- ORDER BY
SELECT userName, mDate FROM userTBL ORDER BY mDate;
SELECT userName, mDate FROM userTBL ORDER BY mDate DESC;
SELECT userName, height FROM userTBL ORDER BY height DESC, userName ASC;

-- DISTINCT
SELECT addr FROM userTBL;
SELECT addr FROM userTBL ORDER BY addr;
SELECT DISTINCT addr FROM userTBL;

-- ROWNUM
SELECT userName, mDate FROM userTBL ORDER BY mDate;
SELECT * FROM (SELECT userName, mDate FROM userTBL ORDER BY mDate) -- 모든데이터를 조회하여 정렬한 후 5건만 가져오는것
WHERE ROWNUM <=5;

-- SAMPLE(퍼센트) : 임의의 데이터 추출
SELECT userId, userName FROM userTBL SAMPLE(50);

-- CREATE TABLE .. AS SELECT : 테이블 복사, PK/FK와 같은 제약조건은 복사되지않음
CREATE TABLE userTempTBL AS
(SELECT * FROM userTBL);
SELECT * FROM userTempTBL;

