--DEFINE h_trdt = '20100104'

SELECT
   FNDPRBRLEVCD CODE_CAP_1,
   FNDPRBRLEV MUC_DICH_VAY_CAP_1,
   FNDPRPSTPCD CODE_CAP_2,
   FNDPRPSTP  MUC_DICH_VAY_CAP_2,
   SUM(LDRBAL_VND_FR) DU_NO_NGAY_TRUOC,
   SUM(LDRBAL_VND_TO) DU_NO
FROM
(
	SELECT
	    DECODE(LENGTH(B.FNDPRPSTPCD), 5, SUBSTR(B.FNDPRPSTPCD, 1, 2), 'XX') FNDPRBRLEVCD,
	    B.FNDPRPSTPCD,
	    DECODE(LENGTH(B.FNDPRPSTPCD), 5,LN1.GET_TCODE('LNFNDPRBRLEV1', 'CC', SUBSTR(B.FNDPRPSTPCD, 1, 2), 'DECODE')) FNDPRBRLEV,
		DECODE(B.FNDPRPSTPCD, '10004',
		DECODE(B.FNDPRPSUNIT, '01001', LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE') ||', kh�ch h�ng s� d�ng v�n vay kinh doanh ch�ng kho�n',
		'02001', LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE') ||', kh�ch h�ng kh�ng s� d�ng v�n vay kinh doanh ch�ng kho�n', LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE')),LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE')) FNDPRPSTP,
	    A.BRCD,
	    A.CUSTSEQ,
	    CS1.EXCROSSCAL(A.BRCD, 'VND', LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1'), A.CCY, NVL(A.LDRBAL, 0), '01', 'VND', '01') LDRBAL_VND_FR,
	    0 LDRBAL_VND_TO,
	    SUBSTR(A.ACCTCD, 4, 1) GRP
	FROM
	    TBGL_BALDD A, TBLN_DSBS B
	WHERE
	    A.TRDT = LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1')
	    AND A.BUSCD = 'LN'
	    AND A.LDRBAL > 0
	    AND A.TRREF = B.DSBSID
	    AND B.BRCD = A.BRCD
	    AND A.TRSEQ = B.DSBSSEQ
	AND B.STSCD IN ('01','05')

	UNION ALL

	SELECT
	    '99' FNDPRBRLEVCD,
	    '99999' FNDPRPSTPCD,
	    'Kh�c' FNDPRBRLEV,
	    'Kh�c' FNDPRPSTP,
	    DECODE(SUBSTR(A.ACCTCD, 1, 3), '282', A.BRCD, '289', A.BRCD, LN1.BRCDCONVERT(A.BRCD,'0')) BRCD,
	    A.CUSTSEQ,
	    CS1.EXCROSSCAL(A.BRCD, 'VND', LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1'), A.CCY, NVL(A.TDBAL, 0), '01', 'VND', '01') LDRBAL_VND_FR,
	    0 LDRBAL_VND_TO,
	    SUBSTR(A.ACCTCD, 4, 1) GRP
	FROM
	    TBGL_MAST A
	WHERE
	    A.TRDT = LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1')
	    AND A.ACCTCD LIKE '2%'
	    AND SUBSTR(A.ACCTCD, 1, 3) NOT IN ('211', '212', '213', '217', '222', '223', '241', '271')
	    AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
	    AND A.TDBAL > 0
	    AND LN1.CHKACCT20SBV(A.ACCTCD, A.CCY) = 'N'

	UNION ALL

	SELECT
	    DECODE(LENGTH(B.FNDPRPSTPCD), 5, SUBSTR(B.FNDPRPSTPCD, 1, 2), 'XX') FNDPRBRLEVCD,
	    B.FNDPRPSTPCD,
	    DECODE(LENGTH(B.FNDPRPSTPCD), 5, LN1.GET_TCODE('LNFNDPRBRLEV1', 'CC', SUBSTR(B.FNDPRPSTPCD, 1, 2), 'DECODE')) FNDPRBRLEV,

		DECODE(B.FNDPRPSTPCD, '10004',
		DECODE(B.FNDPRPSUNIT, '01001', LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE') ||', kh�ch h�ng s� d�ng v�n vay kinh doanh ch�ng kho�n',
		'02001', LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE') ||', kh�ch h�ng kh�ng s� d�ng v�n vay kinh doanh ch�ng kho�n', LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE')),LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE')) FNDPRPSTP,
	    A.BRCD,
	    A.CUSTSEQ,
	    0 LDRBAL_VND_FR,
	    CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, NVL(A.LDRBAL, 0), '01', 'VND', '01') LDRBAL_VND_TO,
	    SUBSTR(A.ACCTCD, 4, 1) GRP
	FROM
	    TBGL_BALDD A, TBLN_DSBS B
	WHERE
		A.TRDT = &h_trdt
	    AND A.BUSCD = 'LN'
	    AND A.LDRBAL > 0
	    AND A.TRREF = B.DSBSID
	    AND B.BRCD = A.BRCD
	    AND A.TRSEQ = B.DSBSSEQ
	AND B.STSCD IN ('01','05')

	UNION ALL

	SELECT
	    '99' FNDPRBRLEVCD,
	    '99999' FNDPRPSTPCD,
	    'Kh�c' FNDPRBRLEV,
	    'Kh�c' FNDPRPSTP,
	    DECODE(SUBSTR(A.ACCTCD, 1, 3), '282', A.BRCD, '289', A.BRCD, LN1.BRCDCONVERT(A.BRCD,'0')) BRCD,
	    A.CUSTSEQ,
	    0 LDRBAL_VND_FR,
	    CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, NVL(A.TDBAL, 0), '01', 'VND', '01') LDRBAL_VND_TO,
	    SUBSTR(A.ACCTCD, 4, 1) GRP
	FROM
	    TBGL_MAST A
	WHERE
		A.TRDT = &h_trdt
	    AND A.ACCTCD LIKE '2%'
	    AND SUBSTR(A.ACCTCD, 1, 3) NOT IN ('211', '212', '213', '217', '222', '223', '241', '271')
	    AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
	    AND A.TDBAL > 0
	    AND LN1.CHKACCT20SBV(A.ACCTCD, A.CCY) = 'N'
) A
GROUP BY
   FNDPRBRLEVCD, FNDPRBRLEV, FNDPRPSTPCD, FNDPRPSTP
