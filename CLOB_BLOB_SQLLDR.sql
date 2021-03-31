-- CLOB, BLOB 대용량 데이터
CREATE TABLE MOVIETBL(
    MOVIE_ID        NUMBER(4),
    MOVIE_TITLE     NVARCHAR2(30),
    MOVIE_DIRECTOR  NVARCHAR2(20),
    MOVIE_STAR      NVARCHAR2(20),
    MOVIE_SCRIPT    CLOB,
    MOVIE_FILM      BLOB
);
-- movieRecords.txt
--0001,쉰들러리스트,스필버그,리암 니슨,0001.txt,0001.mp4
--0002,쇼생크탈출,프랭크다라본트,팀 로빈스,0002.txt,0002.mp4
--0003,라스트모히칸,마이클 만,다니엘 데이 루이스,0003.txt,0003.mp4

-- movieLoader.txt
--LOAD DATA
--INFILE 'movieRecords.txt'
--  INTO TABLE movieTBL
--  FIELDS TERMINATED BY ','
--  (  movie_id        CHAR(4),
--     movie_title      CHAR(30),
--     movie_director CHAR(20),
--     movie_star      CHAR(20),
--     scriptFname    FILLER CHAR(80),
--     filmFname      FILLER CHAR(80),
--     movie_script   LOBFILE(scriptFname) TERMINATED BY EOF,
--     movie_film     LOBFILE(filmFname) TERMINATED BY EOF
--)

-- CMD
-- SQLLDR chan/gurcks258 control=movieLoader.txt

SELECT * FROM MOVIETBL;
