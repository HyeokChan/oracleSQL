-- GROUP BY
SELECT userId AS "사용자 아이디", SUM(amount) AS "총 구매 개수" FROM buyTBL GROUP BY userId;
SELECT userId AS "사용자 아이디", SUM(amount * price) AS "총 구매액" FROM buyTBL GROUP BY userId;
-- CAST(숫자 AS 변환할 형식)
SELECT CAST(AVG(amount) AS NUMBER(5,3)) AS "평균 구매 개수" FROM buyTBL;
-- 사용자 별 한 번 구매 시 물건 평균 구매 개수 구하는 쿼리
SELECT userId AS "사용자 아이디", CAST(AVG(amount) AS NUMBER(5,3)) AS "평균 구매 개수" FROM buyTBL GROUP BY userId;
-- 가장 큰 키와 가장 작은 키의 회원이름과 키를 출력하는 쿼리
SELECT userName, height FROM userTBL 
WHERE height = (SELECT MIN(height) FROM userTBL) OR height = (SELECT MAX(height) FROM userTBL);

SELECT COUNT(*) FROM userTBL WHERE mobile1 IS NOT NULL;
SELECT COUNT(mobile1) AS "휴대폰이 있는 사용자" FROM userTBL;

-- GROUP BY .. HAVING
SELECT userId AS "사용자", SUM(amount*price) FROM buyTBL GROUP BY userId HAVING SUM(amount*price) > 1000 ORDER BY SUM(price*amount);

-- ROLLUP(), GROUPING_ID(), CUBE()
-- (groupName, idNum)로 그룹화하여 중간집계와 총집계를 구한다
SELECT idNum, groupName, SUM(amount*price) AS "비용" FROM buyTBL GROUP BY ROLLUP(groupName, idNum); 
-- groupName로 그룹화하여 중간집계와 총집계를 구한다
SELECT groupName, SUM(amount*price) AS "비용" FROM buyTBL GROUP BY ROLLUP(groupName);

-- groupName로 그룹화하여 중간집계와 총집계를 구하고 GROUPING_ID로 집계여부를 확인한다
SELECT groupName, SUM(amount*price) AS "비용", GROUPING_ID(groupName) AS "추가행여부" FROM buyTBL GROUP BY ROLLUP(groupName);

-- CUBE():각각으로 집계하여 표시 (prodName, color)
SELECT prodName, color, SUM(amount) AS "수량합계"
FROM cubeTBL GROUP BY CUBE(prodName, color) ORDER BY prodName, color;

-- WITH, CTE
SELECT userId AS "사용자", SUM(amount*price) AS "총구매액" FROM buyTBL GROUP BY userId ORDER BY SUM(amount*price) DESC;

WITH abc(userID, total) AS ( SELECT userID, SUM(price*amount) FROM buyTBL GROUP BY userID)
SELECT * FROM abc ORDER BY total DESC;

-- 비재귀적 CTE
-- 각 지역별로 가장 키 큰 사람들의 평균 userTBL
SELECT addr, MAX(height) FROM userTBL GROUP BY addr;
WITH temp(addr, height) AS (SELECT addr, MAX(height) FROM userTBL GROUP BY addr)
SELECT AVG(height) FROM temp;

-- 재귀적 CTE
WITH empCTE(empName, mgrName, dept, empLevel)
AS
(
    ( SELECT emp, manager, department, 0 FROM empTBL WHERE manager='없음')
    UNION ALL
    ( SELECT empTBL.emp, empTBL.maneger, empTBL.department, empCTE.empLevel+1
        FROM empTBL INNER JOIN empCTE ON empTBL.manager = empCTE.empName)
)
SELECT * FROM empCTE ORDER BY dept, empLevel
