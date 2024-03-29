-- DEFINE h_trdt = '20101030'

SELECT
	A.BRCD, B.LCLBRNM CHI_NHANH, A.DEPTCD, C.DEPTNM PHONG_GIAO_DICH,
	DECODE(INDFLG, 'Y', 'CA_NHAN', 'DOANH_NGHIEP') KHACH_HANG,
	A.GRP NHOM_NO, A.CCYCD LOAI_TIEN, A.DSBSBAL DU_NO,
	CS1.EXCROSSCAL(A.BRCD, 'VND', A.TRDT, A.CCYCD, A.DSBSBAL, '01', 'VND', '01')  DU_NO_QUY_DOI
FROM
	(SELECT
		TRDT, BRCD, DEPTCD, INDFLG, GRP, CCYCD, SUM(DSBSBAL) DSBSBAL
	FROM
	(
		SELECT
			A.BKDT TRDT, A.BRCD, A.DEPTCD, LN1.CHK_LNCUSTTP(A.BRCD, '', '', A.CUSTSEQLN, 'IND') INDFLG,
			SUBSTR(A.LNSBTPCD, 2, 1) GRP, A.CCYCD, A.DSBSBAL
		FROM
			LN1.TBLN_DSBSHIST A
		WHERE
			A.BKDT = &h_trdt
			AND A.BRCD LIKE '%'
			AND A.BUSCD = 'LN'
			AND A.STSCD = '01'
			AND A.DEPTCD LIKE '%O'
			AND A.DEPTCD NOT IN ('MHO','T1O', 'BNO')

--		UNION ALL
--
--		SELECT
--			A.TRDT, A.BRCD,  B.DEPTCD, LN1.CHK_LNCUSTTP(A.BRCD, '', '', A.CUSTSEQ, 'IND') INDFLG,
--			SUBSTR(A.ACCTCD, 4, 1) GRP, A.CCY, LDRBAL
--		FROM
--			GL1.TBGL_BALDD A, DP1.TBDP_IDXACCT B
--		WHERE
--			A.BRCD LIKE '%'
--			AND A.TRDT = &h_trdt
--			AND A.ACCTCD LIKE '275%00'
--			AND A.BRCD = B.BRCD
--			AND A.TRREF = B.DPTPCD
--			AND A.REFNO = B.ACCTNO
--			AND B.DEPTCD LIKE '%O'
--			AND B.DEPTCD NOT IN ('MHO','T1O', 'BNO')
	)
	GROUP BY
		TRDT, BRCD, DEPTCD, INDFLG, GRP, CCYCD) A,
	CS1.TBCS_BRCD B, CS1.TBCS_DEPTCD C
WHERE
	A.BRCD = B.BRCD
	AND A.DEPTCD = C.DEPTCD
ORDER BY
	A.BRCD, A.DEPTCD, A.INDFLG, A.GRP, A.CCYCD
