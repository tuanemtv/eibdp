--DEFINE h_trdt = '20110726'

SELECT
	A.CUSTDTLTPCD KHACH_HANG,
	SUM(A.TDBAL_FRDT) DU_NO_NGAY_TRUOC,
	SUM(A.TDBAL_QH_FRDT) DU_NO_QH_NGAY_TRUOC,
	SUM(A.CNT_FRDT) SO_KHACH_HANG_NGAY_TRUOC,
	SUM(A.CNT_QH_FRDT) SO_KHACH_HANG_QH_NGAY_TRUOC,
	SUM(A.TDBAL_TODT) DU_NO,
	SUM(A.TDBAL_QH_TODT) DU_NO_QH,
	SUM(A.CNT_TODT) SO_KHACH_HANG,
	SUM(A.CNT_QH_TODT) SO_KHACH_HANG_QH
FROM
(
	SELECT
		BRCD, CUSTDTLTPCD, CUSTSEQ,
		TDBAL TDBAL_FRDT, TDBAL_QH TDBAL_QH_FRDT,
		COUNT(CUSTSEQ) CNT_FRDT,
		DECODE(TDBAL_QH, 0, 0, COUNT(CUSTSEQ)) CNT_QH_FRDT,
		0 TDBAL_TODT, 0 TDBAL_QH_TODT,
		0 CNT_TODT, 0 CNT_QH_TODT
	FROM
	(
		SELECT
			A.BRCD, A.CUSTDTLTPCD, A.CUSTSEQ,
			SUM(DECODE(A.CCY, 'VND', A.TDBAL,
				CS1.EXCROSSCAL(A.BRCD, 'VND', LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1'), A.CCY, NVL(A.TDBAL,0), '01', 'VND', '01'))) TDBAL,
			SUM(DECODE(A.CCY, 'VND', A.TDBAL_QH,
				CS1.EXCROSSCAL(A.BRCD, 'VND', LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1'), A.CCY, NVL(A.TDBAL_QH,0), '01', 'VND', '01'))) TDBAL_QH
	FROM
		(SELECT
			A.BRCD,
			A.CUSTSEQ, A.CCY,
			SUM(A.LDRBAL) TDBAL,
			SUM(DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', 0, A.LDRBAL)) TDBAL_QH,
			DECODE(C.CUSTTPCD, '100', DECODE(D.LNTPCD, '105', '07. CA NHAN-KD VANG', '115', '07. CA NHAN-KD VANG',
												DECODE(D.FNDPRPSTPCD, '09002', '08. CA NHAN-DUHOC', '09007', '08. CA NHAN-DUHOC', 'BK004', DECODE(FNDPRPSUNIT, '01001', '08. CA NHAN-DUHOC', '06. CA NHAN'), '06. CA NHAN')),
							'600', '05. TCTD',
							DECODE(C.CUSTDTLTPCD,'200', '01. NHA NUOC',
										'201', '01. NHA NUOC',
										'203', '02. CTY CP, CTY TNHH',
										'212', '02. CTY CP, CTY TNHH',
										'204', '02. CTY CP, CTY TNHH',
										'211', '02. CTY CP, CTY TNHH',
										'209', '03. DNTN',
										'213', '03. DNTN', '04. TCNN VA LD')) CUSTDTLTPCD
		FROM
			TBGL_BALDD A, TBCM_GENERAL C, TBLN_DSBS D
		WHERE
			A.TRDT 		= 	LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1')
			AND A.ACCTCD 	LIKE 	'2%'
			AND A.BUSCD 	=  'LN'
			AND A.LDRBAL 	> 	0
			AND A.BRCD 		= 	C.BRCD
			AND A.CUSTSEQ 	= 	C.CUSTSEQ
			AND D.BRCD		=   A.BRCD
			AND A.TRREF 	= 	D.DSBSID
			AND A.TRSEQ 	= 	D.DSBSSEQ
			AND	D.STSCD IN ('01', '05')
		GROUP BY
			A.BRCD, A.CCY, A.CUSTSEQ, C.CUSTDTLTPCD, C.CUSTTPCD, D.LNTPCD, D.FNDPRPSTPCD, D.FNDPRPSUNIT, A.ACCTCD


		UNION ALL

		SELECT
			DECODE(SUBSTR(A.ACCTCD, 1, 3), '282', A.BRCD, '289', A.BRCD, LN1.BRCDCONVERT(A.BRCD, '0')) BRCD,
			A.CUSTSEQ, A.CCY,
			SUM(A.TDBAL) TDBAL,
			SUM(DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', 0, A.TDBAL)) TDBAL_QH,
			DECODE(C.CUSTTPCD, '100', DECODE(SUBSTR(A.ACCTCD, 1, 3), '275', DECODE(SUBSTR(A.ACCTCD, 6, 1), 0, '09. CA NHAN-THAU CHI', 1, '11. CA NHAN-THE TIN DUNG', '12. CA NHAN 275'), '221', '10. CA NHAN-CHIET KHAU', '06. CA NHAN'),
				'600', '05. TCTD',
							DECODE(C.CUSTDTLTPCD,'200', '01. NHA NUOC',
										'201', '01. NHA NUOC',
										'203', '02. CTY CP, CTY TNHH',
										'212', '02. CTY CP, CTY TNHH',
										'204', '02. CTY CP, CTY TNHH',
										'211', '02. CTY CP, CTY TNHH',
										'209', '03. DNTN',
											'213', '03. DNTN', '04. TCNN VA LD')) CUSTDTLTPCD
		FROM
			TBGL_MAST A, TBCM_GENERAL C
		WHERE
			A.TRDT 		= 	LN1.GET_BUSDAYCAL('%', &h_trdt, -1, '1')
			AND A.ACCTCD LIKE '2%'
			AND SUBSTR(A.ACCTCD, 1, 3) NOT IN('211', '212', '213', '217', '222', '223', '241', '271')
			AND SUBSTR(A.ACCTCD, 3, 1) 	NOT IN ('7', '9')
			AND A.TDBAL 	> 	0
			AND A.BRCD 		= 	C.BRCD
			AND A.CUSTSEQ 	= 	C.CUSTSEQ
			AND LN1.CHKACCT20SBV(A.ACCTCD, A.CCY) = 'N'
		GROUP BY A.BRCD, A.CCY, A.CUSTSEQ, C.CUSTDTLTPCD, C.CUSTTPCD, A.ACCTCD
		) A
	GROUP BY
		A.BRCD, A.CUSTSEQ, A.CUSTDTLTPCD
	)
GROUP BY
	BRCD,CUSTDTLTPCD,CUSTSEQ,TDBAL,TDBAL_QH

UNION ALL

SELECT
	BRCD, CUSTDTLTPCD,
	CUSTSEQ,
	0 TDBAL_FRDT, 0 TDBAL_QH_FRDT,
	0 CNT_FRDT, 0 CNT_QH_FRDT,
	TDBAL TDBAL_TODT, TDBAL_QH TDBAL_QH_TODT,
	COUNT(CUSTSEQ) CNT_TODT,
	DECODE(TDBAL_QH, 0, 0, COUNT(CUSTSEQ)) CNT_QH_TODT
FROM
	(SELECT
		A.BRCD, A.CUSTDTLTPCD, A.CUSTSEQ,
		SUM(DECODE(A.CCY, 'VND', A.TDBAL,
			CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, NVL(A.TDBAL,0), '01', 'VND', '01'))) TDBAL,
		SUM(DECODE(A.CCY, 'VND', A.TDBAL_QH,
			CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, NVL(A.TDBAL_QH,0), '01', 'VND', '01'))) TDBAL_QH
	FROM
		(SELECT
			LN1.BRCDCONVERT(A.BRCD, '0') BRCD,
			A.CUSTSEQ, A.CCY,
			SUM(A.LDRBAL) TDBAL,
			SUM(DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', 0, A.LDRBAL)) TDBAL_QH,
			DECODE(C.CUSTTPCD, '100', DECODE(D.LNTPCD, '105', '07. CA NHAN-KD VANG', '115', '07. CA NHAN-KD VANG',
												DECODE(D.FNDPRPSTPCD, '09002', '08. CA NHAN-DUHOC', '09007', '08. CA NHAN-DUHOC', 'BK004', DECODE(FNDPRPSUNIT, '01001', '08. CA NHAN-DUHOC', '06. CA NHAN'), '06. CA NHAN')),
							'600', '05. TCTD',
							DECODE(C.CUSTDTLTPCD,'200', '01. NHA NUOC',
										'201', '01. NHA NUOC',
										'203', '02. CTY CP, CTY TNHH',
										'212', '02. CTY CP, CTY TNHH',
										'204', '02. CTY CP, CTY TNHH',
										'211', '02. CTY CP, CTY TNHH',
										'209', '03. DNTN',
											'213', '03. DNTN', '04. TCNN VA LD')) CUSTDTLTPCD
		FROM
			TBGL_BALDD A, TBCM_GENERAL C, TBLN_DSBS D
		WHERE
			A.TRDT 		= 	&h_trdt
			AND A.ACCTCD 	LIKE 	'2%'
			AND A.BUSCD 		=  'LN'
			AND A.LDRBAL 	> 	0
			AND A.BRCD 		= 	C.BRCD
			AND A.CUSTSEQ 	= 	C.CUSTSEQ
			AND D.BRCD	    =   A.BRCD
			AND A.TRREF 	= 	D.DSBSID
			AND A.TRSEQ 	= 	D.DSBSSEQ
			AND	D.STSCD IN ('01', '05')
		GROUP BY
			A.BRCD, A.CCY, A.CUSTSEQ, C.CUSTDTLTPCD, C.CUSTTPCD, D.LNTPCD, D.FNDPRPSTPCD, D.FNDPRPSUNIT, A.ACCTCD

		UNION ALL

		SELECT
			DECODE(SUBSTR(A.ACCTCD, 1, 3), '282', A.BRCD, '289', A.BRCD, LN1.BRCDCONVERT(A.BRCD, '0')) BRCD,
			A.CUSTSEQ, A.CCY,
			SUM(A.TDBAL) TDBAL,
			SUM(DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', 0, A.TDBAL)) TDBAL_QH,
			DECODE(C.CUSTTPCD, '100', DECODE(SUBSTR(A.ACCTCD, 1, 3), '275', DECODE(SUBSTR(A.ACCTCD, 6, 1), 0, '09. CA NHAN-THAU CHI', 1, '11. CA NHAN-THE TIN DUNG', '12. CA NHAN 275'), '221', '10. CA NHAN-CHIET KHAU', '06. CA NHAN'),
				'600', '05. TCTD',
							DECODE(C.CUSTDTLTPCD,'200', '01. NHA NUOC',
										'201', '01. NHA NUOC',
										'203', '02. CTY CP, CTY TNHH',
										'212', '02. CTY CP, CTY TNHH',
										'204', '02. CTY CP, CTY TNHH',
										'211', '02. CTY CP, CTY TNHH',
										'209', '03. DNTN',
											'213', '03. DNTN', '04. TCNN VA LD')) CUSTDTLTPCD
		FROM
			GL1.TBGL_MAST A, CM1.TBCM_GENERAL C
		WHERE
			A.TRDT 		= 	&h_trdt
			AND A.ACCTCD LIKE '2%'
			AND SUBSTR(A.ACCTCD, 1, 3) NOT IN('211', '212', '213', '217', '222', '223', '241', '271')
			AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
			AND A.TDBAL 	> 	0
			AND A.BRCD 		= 	C.BRCD
			AND A.CUSTSEQ 	= 	C.CUSTSEQ
			AND LN1.CHKACCT20SBV(A.ACCTCD, A.CCY) = 'N'
		GROUP BY A.BRCD, A.CCY, A.CUSTSEQ, C.CUSTDTLTPCD, C.CUSTTPCD, A.ACCTCD
		) A
	GROUP BY A.BRCD, A.CUSTSEQ, A.CUSTDTLTPCD
	)
GROUP BY BRCD,CUSTDTLTPCD,CUSTSEQ,TDBAL,TDBAL_QH
) A
GROUP BY
A.CUSTDTLTPCD
