--DEFINE h_trdt = '20120726'

	SELECT  A.DLNO, A.CPTYSEQNO, A.NMLOC,A.CUST_KIND, A.DLDT, A.VALDT, A.BUYSELLFLG, A.DLCCYCD, A.DLAMT, A.CNTRCCYCD,
	A.CNTRAMT,A.RATE, A.CRTUSR, C.DEPTNMLOC, A.DLDTJNL, A.DLJNLSEQ, A.CLX, A.EXRT, A.RMRK

	FROM
	(
				SELECT B.BRCD,B.BRCD || B.DLTPCD || B.SBTPCD || B.DLSEQNO DLNO, A.CPTYSEQNO, D.NMLOC,
				       B.DLDT, B.VALDT, C.BUYSELLFLG, C.DLCCYCD, C.DLAMT, C.CNTRCCYCD, C.CNTRAMT,
				       DECODE(B.SBTPCD, 'CS', C.SPOTRT, 'CF', C.FRWDRT, 'W', DECODE(SUBSTR(A.DLSEQNO,8,1),'0',C.SPOTRT,C.FRWDRT)) rate,
				       B.CONFUSR CRTUSR, C.DLJNLSEQ, NVL(E.CLX, 0) CLX, F.NM EXRT,
				       B.RMRK, C.DLDTJNL, DECODE(D.CUSTTPCD,'100','CA NHAN',' DOANH NGHIEP') CUST_KIND
				FROM   DL1.TBDL_HISTORY A, DL1.TBDL_DEAL B, DL1.TBDL_FX C, CM1.TBCM_GENERAL D, DL1.TBDL_FXCLX E,
						(
						  	 SELECT TRIM(CODE) CODE, DECODE NM
							FROM RACE.T_CODE
							WHERE CAT_NAME = 'DLEXRTINSUR'
						) F
				WHERE  A.DLTPCD = 'X' AND
				       A.SBTPCD IN ('CS', 'CW', 'CF') AND
				       A.DLSEQNO LIKE SUBSTR(&h_trdt, 3, 2) || '%' AND
				       A.SEQNO = 1 AND
				   B.DLDT = &h_trdt and
			       B.BRCD = A.BRCD AND
			       B.DLTPCD = A.DLTPCD AND
			       B.SBTPCD = A.SBTPCD AND
			       B.DLSEQNO = A.DLSEQNO AND
			       B.AUTHFLG = 'Y' AND
			       C.BRCD = A.BRCD AND C.DLTPCD = A.DLTPCD AND C.SBTPCD = A.SBTPCD AND C.DLSEQNO = A.DLSEQNO AND
			       D.BRCD (+) = A.BRCD AND D.CUSTSEQ (+) = A.CPTYSEQNO
			       AND E.BRCD (+) = A.BRCD AND
			       E.DLTPCD (+) = A.DLTPCD AND E.SBTPCD (+) = A.SBTPCD AND E.DLSEQNO (+) = A.DLSEQNO
			       AND B.BOPID = F.CODE(+)
	)A, CS1.TBRC_USR1 B, CS1.TBCS_DEPTCD C
    WHERE A.BRCD = B.BRCD(+)
    AND A.CRTUSR = B.USRID(+)
    AND B.DEPTCD = C.DEPTCD(+)
ORDER BY DLNO
