-- DEFINE h_predt = '20111001'
-- DEFINE h_trdt  = '20111003'

SELECT
	X.LCLBRNM CHI_NHANH,
	X.CUSTSEQ CIF,
	X.NMLOC KHACH_HANG,
	SUM(DECODE(Y.CCY, 'VND', Y.TDBAL,CS1.EXCROSSCAL(Y.BRCD, 'VND', Y.TRDT, Y.CCY, NVL(Y.TDBAL, 0), '01', 'VND', '01'))) DU_NO_QUY_DOI,
	X.OLDGRP NHOM_CU,
	X.NEWGRP NHOM_MOI
FROM
(
	SELECT DISTINCT C.LCLBRNM,
		A.BRCD,
		A.CUSTSEQ,
		B.NMLOC,
		SUBSTR(A.ACRPAC1,4,1) OLDGRP,
		SUBSTR(A.ACCTCD,4,1) NEWGRP
	FROM GL1.TBGL_CAPDD A,CM1.TBCM_GENERAL B,CS1.TBCS_BRCD C
	WHERE A.TRDT BETWEEN &h_trdt AND &h_trdt
		AND SUBSTR(A.ACCTCD,1,1 )='2'
		AND SUBSTR(A.ACCTCD,4,1)> SUBSTR(A.ACRPAC1,4,1)
		AND A.BRCD=B.BRCD
		AND A.CUSTSEQ=B.CUSTSEQ
		AND A.BRCD=C.BRCD
		AND  SUBSTR(A.ACCTCD,4,1) = (	SELECT MAX( SUBSTR(ACCTCD,4,1))
								FROM  GL1.TBGL_CAPDD
								WHERE TRDT BETWEEN &h_trdt AND &h_trdt
								AND SUBSTR(ACCTCD,1,1 )='2'
								AND BRCD = A.BRCD
								AND CUSTSEQ = A.CUSTSEQ)
) X,GL1.TBGL_MAST Y
WHERE Y.TRDT 		= 	&h_trdt
	AND X.BRCD=Y.BRCD
	AND X.CUSTSEQ=Y.CUSTSEQ
	AND 	Y.ACCTCD 	LIKE 	'2%'                   
	AND 	SUBSTR(Y.ACCTCD, 3, 1) 	NOT IN ('7', '9')
	AND 	Y.TDBAL 	> 	0
	AND LN1.CHKACCT20SBV(Y.ACCTCD, Y.CCY) = 'N'
GROUP BY 
	X.LCLBRNM, X.CUSTSEQ, X.NMLOC, X.OLDGRP, X.NEWGRP
ORDER BY 
	X.LCLBRNM, X.CUSTSEQ, X.NMLOC, X.OLDGRP, X.NEWGRP
