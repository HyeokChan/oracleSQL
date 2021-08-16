-- ������������
CREATE TABLE TB_NAT_ACB(
    NAT_KEY VARCHAR(10),    
    ROAD_NM_ADDR VARCHAR(300),    
    LOTNO_ADDR VARCHAR(300),
    TRG_NM VARCHAR(300),
    CONSTRAINT PK_TB_NAT PRIMARY KEY(NAT_KEY)
);
SELECT * FROM TB_NAT_ACB;
ALTER TABLE TB_NAT RENAME TO TB_NAT_ACB;
COMMIT;
INSERT INTO TB_NAT_ACB VALUES('2021000001', 'ROAD 3�� 1111-18', 'LOTNO �Ϲݹ��� 154-12');
INSERT INTO TB_NAT_ACB VALUES('2021000002', 'ROAD 88�� 101-21', 'LOTNO ��ȹ���� 112-65');

-- �Ӵ�ắ��ݴ���
CREATE TABLE TB_RCHG_ACB(
    RCHG_KEY VARCHAR(10),
    CTRT_YMD VARCHAR(8),
    NAT_RT NUMBER(3),
    SD_RT NUMBER(3),
    SGG_RT NUMBER(3),
    CONSTRAINT PK_TB_RCHG_ACB PRIMARY KEY(RCHG_KEY)
);
SELECT * FROM TB_RCHG_ACB;
INSERT INTO TB_RCHG_ACB VALUES('1111000001', '20210816', 50, 0, 50);
COMMIT;

-- �Ӵ�ắ��ݹ��ǳ���
CREATE TABLE TB_RCHG_THG(
    NAT_KEY VARCHAR(10),
    RCHG_KEY VARCHAR(10),
    RCHG_SNO VARCHAR(3),
    GL_MNG_NO VARCHAR(10),
    CONSTRAINT PK_TB_RCHG_THG PRIMARY KEY(NAT_KEY, RCHG_KEY, RCHG_SNO),
    CONSTRAINT FK_TB_RCHG_THG FOREIGN KEY(NAT_KEY) REFERENCES TB_NAT_ACB(NAT_KEY),
    CONSTRAINT FK_TB_RCHG_THG2 FOREIGN KEY(RCHG_KEY) REFERENCES TB_RCHG_ACB(RCHG_KEY)    
);
SELECT * FROM TB_RCHG_THG;
INSERT INTO TB_RCHG_THG VALUES('2021000001', '1111000001', '001', '0001000001');
INSERT INTO TB_RCHG_THG VALUES('2021000002', '1111000001', '002', '0001000002');
COMMIT;

-- ����������
CREATE TABLE TB_THG(
    GL_MNG_NO VARCHAR(10),
    GL_NM VARCHAR(300),
    CONSTRAINT PK_TB_THG PRIMARY KEY(GL_MNG_NO)
);
SELECT * FROM TB_THG;
INSERT INTO TB_THG VALUES('0001000001', '�ΰ����1');
INSERT INTO TB_THG VALUES('0001000002', '�ΰ����2');

--������ �ּ�����
CREATE TABLE TB_THG_ADDR(
    GL_MNG_NO VARCHAR(10),
    ROAD_NM_ADDR VARCHAR(300),    
    LOTNO_ADDR VARCHAR(300),
    CONSTRAINT PK_TB_THG_ADDR PRIMARY KEY(GL_MNG_NO),
    CONSTRAINT FK_TB_THG_ADDR FOREIGN KEY(GL_MNG_NO) REFERENCES TB_THG(GL_MNG_NO)
);
SELECT * FROM TB_THG_ADDR;
INSERT INTO TB_THG_ADDR VALUES('0001000001', 'ROAD 3�� 1111-18', 'LOTNO �Ϲݹ��� 154-12');
INSERT INTO TB_THG_ADDR VALUES('0001000002', 'ROAD 88�� 101-21', 'LOTNO ��ȹ���� 112-65');
COMMIT;

-- �Ӵ�ắ��ݴ��峳���ڳ���
CREATE TABLE TB_PYR(
    RCHG_KEY VARCHAR(10),
    PYR_SNO VARCHAR(3),
    PYR_MNG_NO VARCHAR(10),
    CONSTRAINT PK_TB_PYR PRIMARY KEY(RCHG_KEY, PYR_SNO),
    CONSTRAINT FK_TB_PYR FOREIGN KEY(RCHG_KEY) REFERENCES TB_RCHG_ACB(RCHG_KEY)
);
SELECT * FROM TB_PYR;
INSERT INTO TB_PYR VALUES('1111000001', '001', '333300001');
COMMIT;

-- �Ӵ�ắ��ݴ�����⳻��
CREATE TABLE TB_RCHG_CPTN(
    RCHG_KEY VARCHAR(10),
    CPTN_SNO VARCHAR(3),    
    CPTN_SE_CD VARCHAR(2),
    CONSTRAINT PK_TB_RCHG_CPTN PRIMARY KEY(RCHG_KEY, CPTN_SNO),
    CONSTRAINT FK_TB_RCHG_CPTN FOREIGN KEY(RCHG_KEY) REFERENCES TB_RCHG_ACB(RCHG_KEY)
);

-- �Ӵ�ắ��ݴ��� �ٰ���ȸ
SELECT A.RCHG_KEY
     , B.GL_MNG_NO
     , C.PYR_MNG_NO
     , D.CPTN_SNO
  FROM TB_RCHG_ACB A
     , TB_RCHG_THG B
     , TB_PYR C
     , TB_RCHG_CPTN D
 WHERE A.RCHG_KEY = B.RCHG_KEY
   AND A.RCHG_KEY = C.RCHG_KEY
   AND A.RCHG_KEY = D.RCHG_KEY(+);
   
     
     
-- �Ӵ�ắ��ݴ��� �ٰ���ȸ
SELECT A.RCHG_KEY
     , B.GL_MNG_NO
     , C.PYR_MNG_NO
     , D.CPTN_SNO
  FROM TB_RCHG_ACB A
  LEFT OUTER JOIN TB_RCHG_CPTN D
    ON A.RCHG_KEY = D.RCHG_KEY
     , TB_RCHG_THG B
     , TB_PYR C     
 WHERE A.RCHG_KEY = B.RCHG_KEY
   AND A.RCHG_KEY = C.RCHG_KEY
   
     ;
     
     
     
     
     





