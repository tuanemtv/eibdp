--DEFINE h_trdt = '20120428'

SELECT
	BRCD,
	DECODE(SUBSTR(ITEMCD, 1, 1),
		'1', '1. Phi s¶n xuÊt',
		'2', '2. S¶n xuÊt, kinh doanh') GRP,
	DECODE(ITEMCD,
		'1.a.', '1.a. §Çu t­, kinh doanh bÊt ®éng s¶n',
		'1.b.', '1.b. Kinh doanh chøng kho¸n',
		'1.c.', '1.c. Tiªu dïng (c¸ nh©n)',
		'2.a.', '2.a. NhËp khÈu',
		'2.b.', '2.b. XuÊt khÈu',
		'2.c.', '2.c. S¶n xuÊt, kinh doanh trong n­íc',
		'2.d.', '2.d. Cho vay b¶o ®¶m b»ng TGTK, ký quü, tiÒn, vµng gi÷ hé, GTCG do EIB ph¸t hµnh',
		'2.e.', '2.e. C¸c nhu cÇu vèn ®­îc lo¹i trõ') ITEM,
	ITEMCD,
	ROUND(SUM(FRBAL), 2) FRBAL,
	ROUND(SUM(FRPLG), 2) FRPLG,
	ROUND(SUM(TOBAL), 2) TOBAL,
	ROUND(SUM(TOPLG), 2) TOPLG
FROM
(
	SELECT
		DECODE('%', '%', DECODE('%', 'Y', BRCD, '9999'), BRCD) BRCD,
		DECODE(FLAG, '1', ITEMCD, DECODE(ITEMCD, '1.b.', '2.d.', ITEMCD)) ITEMCD,
		DECODE(FLAG, '1', DECODE(ITEMCD, '1.b.', FRBAL - FRPLG,	FRBAL),  DECODE(ITEMCD, '1.b.', FRPLG,	0)) FRBAL,
		DECODE(FLAG, '1', DECODE(ITEMCD, '1.b.', 0,	FRPLG),  DECODE(ITEMCD, '1.b.', 0,	FRPLG)) FRPLG,
		DECODE(FLAG, '1', DECODE(ITEMCD, '1.b.', TOBAL - TOPLG,	TOBAL),  DECODE(ITEMCD, '1.b.', TOPLG,	0)) TOBAL,
		DECODE(FLAG, '1', DECODE(ITEMCD, '1.b.', 0,	TOPLG),  DECODE(ITEMCD, '1.b.', 0,	TOPLG)) TOPLG
	FROM
	(
		SELECT
			BRCD,
			ITEMCD,
			ROUND(SUM(CS1.EXCROSSCAL(BRCD, 'VND', LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), CCYCD, FRBAL, '01', 'VND', '01'))/1, 2) FRBAL,
			ROUND(SUM(CS1.EXCROSSCAL(BRCD, 'VND', LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), CCYCD, FRPLG, '01', 'VND', '01'))/1, 2) FRPLG,
			ROUND(SUM(CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, TOBAL, '01', 'VND', '01'))/1, 2) TOBAL,
			ROUND(SUM(CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, TOPLG, '01', 'VND', '01'))/1, 2) TOPLG
		FROM
		(
			SELECT
				BRCD,
				ITEMCD,
				CCYCD,
				SUM(FRBAL) FRBAL,
				SUM(FRPLG) FRPLG,
				SUM(TOBAL) TOBAL,
				SUM(TOPLG) TOPLG
			FROM
			(
				SELECT
					BRCD,
					DECODE(FNDPRPSTPCD,
						'03005', '1.a.',
						'09006', '2.e.',
						'09001', DECODE(SUBSTR(NVL(OTHRTPCD, 'L0'), 1, 2),
									'L0', '1.a.',
									DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '2.e.', '2.c.')),
						DECODE(SUBSTR(FNDPRPSTPCD, 1, 2),
							'BK', DECODE(FNDPRPSTPCD, 'BK004', '2.d.', DECODE(SUBSTR(FNDPRPSUNIT, 1, 2), '01', '2.b.', '02', '2.c.', '2.d.')),
							'BI', DECODE(FNDPRPSUNIT, '05006', '2.e.', '05007', '2.e.', '05008', '2.e.', '1.a.'),
							'09', DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '1.c.', '2.c.'),
							'10', DECODE(SUBSTR(NVL(FNDPRPSUNIT, '01'), 1, 2),
									'01', '1.b.',
									DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '1.c.', '2.c.')),
							'20', DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '1.c.', '2.c.'),
							'22', DECODE(SUBSTR(FNDPRPSTPCD, 1, 3),
									'221', DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '1.c.', '2.c.'),
									DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '1.c.', '2.c.')),
							'27', DECODE(SUBSTR(FNDPRPSTPCD, 1, 3),
									'275', DECODE(SUBSTR(FNDPRPSTPCD, 5, 2),
												'00', DECODE(CUSTODSECFLG,
														'Y', '1.b.',
														DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '1.c.', '2.c.')),
												'01', '1.c.'),
									DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', '1.c.', '2.c.')),
							DECODE(SUBSTR(FNDPRPSUNIT, 1, 2), '01', '2.b.', '02', '2.a.', '2.c.'))) ITEMCD,
					CCYCD,
					FRBAL, FRPLG,
					TOBAL, TOPLG
				FROM
				(
					SELECT
						BRCD,
						CUSTSEQLN CUSTSEQ,
						FNDPRPSTPCD,
						FNDPRPSUNIT,
						OTHRTPCD,
						CCYCD CCYCD,
						DECODE(BKDT, LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), DSBSBAL) FRBAL,
						0 FRPLG,
						DECODE(BKDT, &h_trdt, DSBSBAL) TOBAL,
						0 TOPLG,
						'' CUSTODSECFLG
					FROM
						LN1.TBLN_DSBSHIST
					WHERE
						BKDT 		IN	(LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), &h_trdt)
						AND BRCD	LIKE '%'
						AND BUSCD 	= 'LN'
						AND STSCD	= '01'
						AND DSBSBAL > 0

					-- ================================
					-- All Account
					-- ================================

					UNION ALL

					SELECT
						A.BRCD,
						A.CUSTSEQ,
						A.ACCTCD FNDPRPSTPCD,
						'' FNDPRPSUNIT,
						'' OTHRTPCD,
						A.CCY,
						DECODE(A.TRDT, LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), A.TDBAL) FRBAL,
						0 FRPLG,
						DECODE(A.TRDT, &h_trdt, A.TDBAL) TOBAL,
						0 TOPLG,
						B.FLG CUSTODSECFLG
					FROM
						GL1.TBGL_MAST A,
						(	SELECT
								CODE CUSTSEQ, 'Y' FLG
							FROM
								LN1.TBLN_CRPARM
							WHERE
								GRP = 'CUSTODSEC'
								AND ITEM = 'VN') B
					WHERE
						A.TRDT			IN		(LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), &h_trdt)
						AND A.BRCD		LIKE '%'
						AND A.ACCTCD LIKE '2%'
						AND SUBSTR(A.ACCTCD, 1, 3) NOT IN ('211', '212', '213', '222', '223', '241')
						AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
						AND A.TDBAL 		> 	0
						AND LN1.CHKACCT20SBV(A.ACCTCD, A.CCY) = 'N'
						AND A.CUSTSEQ		= B.CUSTSEQ (+)

					UNION ALL

					SELECT
						A.BRCD,
						A.CUSTSEQLN CUSTSEQ,
						A.FNDPRPSTPCD,
						DECODE(A.FNDPRPSUNIT, '00000', NULL, A.FNDPRPSUNIT) FNDPRPSUNIT,
						B.OTHRTPCD,
						A.CCYCD CCYCD,
						0 FRBAL,
						DECODE(A.TRDT, LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), A.DSBSBAL) FRPLG,
						0 TOBAL,
						DECODE(A.TRDT, &h_trdt, A.DSBSBAL) TOPLG,
						'' CUSTODSECFLG
					FROM
						LN1.TBLN_CLBAL A, LN1.TBLN_DSBSHIST B, LN1.TBLN_CL C
					WHERE
						A.TRDT				IN (LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), &h_trdt)
						AND B.BKDT			IN (LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), &h_trdt)
						AND A.BRCD			LIKE '%'
						AND A.CLDTLTPCD		IN ('601','607','620', '608','609')
						AND A.TRDT			= B.BKDT
						AND A.BRCD			= B.BRCD
						AND A.DSBSID		= B.DSBSID
						AND A.DSBSSEQ		= B.DSBSSEQ
						AND A.BRCD			= C.BRCD  (+)
						AND A.CLID			= C.CLID  (+)
						AND A.CLSEQ			= C.CLSEQ (+)
						AND C.CRDTOFC (+)	= 'EIB'
				)
			)
			GROUP BY
				BRCD, ITEMCD, CCYCD
		)
		GROUP BY
			BRCD, ITEMCD
	) A,
	(
		SELECT
			'1' FLAG
		FROM
			DUAL

		UNION ALL

		SELECT
			'2' FLAG
		FROM
			DUAL
	) B
)
GROUP BY
	BRCD, ITEMCD
ORDER BY
	BRCD, ITEMCD
