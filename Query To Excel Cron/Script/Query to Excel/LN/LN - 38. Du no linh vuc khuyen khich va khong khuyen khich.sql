--define h_trdt = '20120428'

SELECT
	ITEMCD ITEM1,
	DECODE(SUBSTR(ITEMCD, 1, 1),
		'A', 'Kh«ng khuyÕn khÝch',
		'B', 'S¶n xuÊt, kinh doanh') ITEM2,
	DECODE(ITEMCD,
		'A01', 'Kinh doanh chøng kho¸n',
		'A02', '§Çu t­, kinh doanh B§S',
		'A03', 'Cho vay tiªu dïng',
		'B01', 'NhËp khÈu',
		'B02', 'XuÊt khÈu',
		'B03', 'S¶n xuÊt, kinh doanh trong n­íc',
		'B04', 'Cho vay b¶o ®¶m b»ng TGTK, ký quü, GTCG do EIB ph¸t hµnh',
		'B05', 'C¸c nhu cÇu vèn ®­îc lo¹i trõ') ITEM3,
	SUM(FRBAL) FRBAL,
	SUM(TOBAL) TOBAL
FROM
(

	SELECT
		ITEMCD,
		SUM(FRBAL) FRBAL,
		SUM(TOBAL) TOBAL
	FROM
	(
		SELECT
			BRCD,
			GRP,
			DECODE(FNDPRPSTPCD,
				'03005', 'B02',
				'09006', 'B05',
				'09001', DECODE(SUBSTR(NVL(OTHRTPCD, 'L0'), 1, 2),
							'L1',  DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', 'B05', 'B03'),
							DECODE(SUBSTR(NVL(OTHRTPCD, 'L00'), 1, 3), 'L00', 'A02',
							 	DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y',
									DECODE(SUBSTR(FNDPRPSUNIT,1,2), '01', 'B05', '03', 'B05', '04', 'B05', 'A02'),'B03'))),
				DECODE(SUBSTR(FNDPRPSTPCD, 1, 2),
					'BK', DECODE(FNDPRPSTPCD, 'BK004', 'B04', DECODE(SUBSTR(FNDPRPSUNIT, 1, 2), '01', 'B02', '02', 'B01', 'B04')),
					'BI', DECODE(FNDPRPSTPCD, 'BI001',
							DECODE(FNDPRPSUNIT, '05006', 'A02', '05007', 'A02', '05008', 'A02', 'B05'),
							DECODE(FNDPRPSUNIT, '05006', 'B05', '05007', 'B05', '05008', 'B05', 'A02')),
					'09', DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y',
							DECODE(FNDPRPSTPCD, '09003', 'B05', '09004', 'B05', '09018', 'B05','A03'),'B03'),
					'10', DECODE(SUBSTR(NVL(FNDPRPSUNIT, '01'), 1, 2),
							'01', 'A01',
							DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', 'A03', 'B03')),
					'20', DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', 'A03', 'B03'),
					'22', DECODE(SUBSTR(FNDPRPSTPCD, 1, 3),
							'221', DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', 'A03', 'B03'),
							DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', 'A03', 'B03')),
					'27', DECODE(SUBSTR(FNDPRPSTPCD, 1, 3),
							'275', DECODE(SUBSTR(FNDPRPSTPCD, 5, 2),
										'00', DECODE(CUSTODSECFLG,
												'Y', 'A01',
												DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', 'A03', 'B03')),
										'01', 'A03'),
							DECODE(LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND'), 'Y', 'A03', 'B03')),
					DECODE(SUBSTR(FNDPRPSUNIT, 1, 2), '01', 'B02', '02', 'B01', 'B03'))) ITEMCD,
			CCYCD,
			CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, FRBAL, '01', 'VND', '01') FRBAL,
			CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, TOBAL, '01', 'VND', '01') TOBAL
		FROM
		(
			SELECT
				BRCD,
				SUBSTR(LNSBTPCD, 2, 1) GRP,
				CUSTSEQLN CUSTSEQ,
				FNDPRPSTPCD,
				FNDPRPSUNIT,
				OTHRTPCD,
				CCYCD CCYCD,
				DECODE(BKDT, LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), DSBSBAL) FRBAL,
				DECODE(BKDT, &h_trdt, DSBSBAL) TOBAL,
				'' CUSTODSECFLG
			FROM
				LN1.TBLN_DSBSHIST
			WHERE
				BKDT 		IN	(LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), &h_trdt)
				AND BRCD	LIKE '%'
				AND BUSCD 	= 'LN'
				AND STSCD	= '01'
				AND DSBSBAL > 0

			UNION ALL

			/* A01 - Cho vay chung khoan - Du no duoc loai tru */
			SELECT
				BRCD,
				SUBSTR(LNSBTPCD, 2, 1) GRP,
				B.CUSTSEQLN CUSTSEQ,
				'10' FNDPRPSTPCD,
				'01' FNDPRPSUNIT,
				'' OTHRTPCD,
				CCYCD CCYCD,
				-FRBAL,
				-TOBAL,
				'' CUSTODSECFLG
		   	FROM
			(
				SELECT
					A.CUSTSEQLN,BRCDAPPR, APPRID, APPRSEQ
				FROM
					LN1.TBLN_PLG A,LN1.TBLN_CLPLG B,LN1.TBLN_CL C
				WHERE   A.BRCD		LIKE '%'
					AND A.STSCD 	IN ('01','03')
					AND(A.RLSTRDT > &h_trdt OR (A.STSCD = '01' AND NVL(A.RLSTRDT,'NONENONE')='NONENONE'))
					AND C.STSCD 	= '01'
					AND A.PLGAMT 	<> 0
					AND A.BUSCD	= 'LN'
					AND A.BRCD	= B.BRCD
					AND A.PLGID	= B.PLGID
					AND A.PLGSEQ	= B.PLGSEQ
					AND B.BRCDCL	= C.BRCD
					AND B.CLID	= C.CLID
					AND B.CLSEQ	= C.CLSEQ
					AND (C.CLDTLTPCD IN ('601','607','620') AND C.CRDTOFC = 'EIB')
				GROUP BY
					CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ
			)A,
			(
				SELECT
					BRCD, LNSBTPCD, CCYCD, CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ,
					DECODE(BKDT, LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), DSBSBAL) FRBAL,
					DECODE(BKDT, &h_trdt, DSBSBAL) TOBAL
				FROM
					LN1.TBLN_DSBSHIST
				WHERE   BRCD LIKE '%'
						AND STSCD IN ('01', '05')
						AND BUSCD	= 'LN'
						AND FNDPRPSTPCD LIKE '10%'
						AND BKDT IN	(LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), &h_trdt)
						AND SUBSTR(NVL(FNDPRPSUNIT, '01001'), 1, 2) = '01'
						AND LENGTH(FNDPRPSTPCD) = 5
			) B
			WHERE
				A.BRCDAPPR		= B.BRCDAPPR
				AND A.APPRID	= B.APPRID
				AND A.APPRSEQ	= B.APPRSEQ


			UNION ALL

			/* A01 - Cho vay chung khoan - Du no duoc loai tru */
			SELECT
				BRCD,
				SUBSTR(LNSBTPCD, 2, 1) GRP,
				B.CUSTSEQLN CUSTSEQ,
				'BK' FNDPRPSTPCD,
				'00' FNDPRPSUNIT,
				'' OTHRTPCD,
				CCYCD CCYCD,
				FRBAL,
				TOBAL,
				'' CUSTODSECFLG
		   	FROM
			(
				SELECT
					A.CUSTSEQLN,BRCDAPPR, APPRID, APPRSEQ
				FROM
					LN1.TBLN_PLG A,LN1.TBLN_CLPLG B,LN1.TBLN_CL C
				WHERE   A.BRCD		LIKE '%'
					AND A.STSCD 	IN ('01','03')
					AND(A.RLSTRDT > &h_trdt OR (A.STSCD = '01' AND NVL(A.RLSTRDT,'NONENONE')='NONENONE'))
					AND C.STSCD 	= '01'
					AND A.PLGAMT 	<> 0
					AND A.BUSCD	= 'LN'
					AND A.BRCD	= B.BRCD
					AND A.PLGID	= B.PLGID
					AND A.PLGSEQ	= B.PLGSEQ
					AND B.BRCDCL	= C.BRCD
					AND B.CLID	= C.CLID
					AND B.CLSEQ	= C.CLSEQ
					AND (C.CLDTLTPCD IN ('601','607','620') AND C.CRDTOFC = 'EIB')
				GROUP BY
					CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ
			)A,
			(
				SELECT
					BRCD, LNSBTPCD, CCYCD, CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ,
					 DECODE(BKDT, LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), DSBSBAL) FRBAL,
					DECODE(BKDT, &h_trdt, DSBSBAL) TOBAL
				FROM LN1.TBLN_DSBSHIST
				WHERE   BRCD LIKE '%'
						AND STSCD IN ('01', '05')
						AND BUSCD	= 'LN'
						AND FNDPRPSTPCD LIKE '10%'
						AND BKDT IN	(LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), &h_trdt)
						AND SUBSTR(NVL(FNDPRPSUNIT, '01001'), 1, 2) = '01'
						AND LENGTH(FNDPRPSTPCD) = 5
			) B
			WHERE
				A.BRCDAPPR		= B.BRCDAPPR
				AND A.APPRID	= B.APPRID
				AND A.APPRSEQ	= B.APPRSEQ

			-- ================================
			-- All Account
			-- ================================

			UNION ALL

			SELECT
				A.BRCD,
				SUBSTR(ACCTCD, 4, 1) GRP,
				A.CUSTSEQ,
				A.ACCTCD FNDPRPSTPCD,
				'' FNDPRPSUNIT,
				'' OTHRTPCD,
				A.CCY,
				DECODE(A.TRDT, LN1.GET_BUSDAYCAL('%', &h_trdt, -1, 1), A.TDBAL) FRBAL,
				DECODE(A.TRDT, &h_trdt, A.TDBAL) TOBAL,
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
		))
		GROUP BY ITEMCD
)
GROUP BY
	ITEMCD
ORDER BY
	ITEMCD
		;
