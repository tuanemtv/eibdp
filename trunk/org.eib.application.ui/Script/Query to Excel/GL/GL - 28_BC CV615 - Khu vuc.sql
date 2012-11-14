-- 3 phut
--define	h_trdt = '20110831'

SELECT	TRDT,
		DECODE,
		LOCCD,
		'05' RPTKND,
		'VND' CCY,
		MACT,
		SUM(CURBAL) CURBAL,
		'PLD' DEPTCD,
		'NHTHANH' CRTUSR,
		'GL' BUSCD
FROM
	(
		SELECT	TRDT,
				BRCD,
				'05' RPTKND,
				'VND' CCY,
				MACT,
				round(CURBAL / 1000000000, 2) CURBAL,
				'PLD' DEPTCD,
				'NHTHANH' CRTUSR,
				'GL' BUSCD
		FROM
			(
				-- Lay DN - DC (1413, 153, 163)
				SELECT 	A.BRCD,
						A.TRDT,
						'D00' MACT,
						SUM(CS1.EXCROSSCAL('1000', 'VND', &h_trdt, A.CCY, A.TDBAL + A.TDACRBAL, '01', 'VND', '01')) CURBAL
				FROM 	GL1.TBGL_MAST A, GL1.TBGL_SBVCD B
				WHERE 	A.BRCD like '%'
					AND	A.TRDT = &h_trdt
					AND	( 	 SUBSTR(B.SBVCD, 1, 3) IN ('153', '163')          -- Toan TK DN
						  OR  SUBSTR(B.SBVCD, 1, 4) IN ('1413')
						)
					AND DECODE(A.CCY, 'VND', '1', 'GD1', '3', 'GD2', '3', 'GD3', '3', 'GD4', '3', '2')	=	B.BCCYFG
					AND A.ACCTCD	= B.ACCTCD
					AND	A.TDBAL <> 0
				GROUP BY A.BRCD, A.TRDT

				UNION ALL

				-- Lay DN (241, 242)
				SELECT 	A.BRCD,
						A.TRDT,
						'E01' MACT,
						SUM(CS1.EXCROSSCAL('1000', 'VND', &h_trdt, A.CCY, A.TDBAL + A.TDACRBAL, '01', 'VND', '01')) CURBAL
				FROM 	GL1.TBGL_MAST A, GL1.TBGL_SBVCD B
				WHERE 	A.BRCD like '%'
					AND	A.TRDT = &h_trdt
					AND	SUBSTR(B.SBVCD, 1, 3) IN ('241', '242')          -- Toan TK DN
					AND DECODE(A.CCY, 'VND', '1', 'GD1', '3', 'GD2', '3', 'GD3', '3', 'GD4', '3', '2')	=	B.BCCYFG
					AND A.ACCTCD	= B.ACCTCD
					AND	A.TDBAL > 0
				GROUP BY A.BRCD, A.TRDT

				UNION ALL

				SELECT 	BRCD, &h_trdt TRDT, 'E01' MACT, 0 CURBAL
				FROM 	CS1.TBCS_BRCD

				UNION ALL

				-- Lay DC (921) - TK NO - CO
				SELECT 	A.BRCD,
						A.TRDT,
						'E02' MACT,
						SUM(CS1.EXCROSSCAL('1000', 'VND', &h_trdt, A.CCY,
								DECODE(B.ACBLDRCR, 'D', DECODE( SIGN(A.TDBAL + A.TDACRBAL), -1, ABS(A.TDBAL + A.TDACRBAL), 0)	-- Neu loai NO ma AM => la CO => lay, (DUONG : ko lay)
												 , 'C', DECODE( SIGN(A.TDBAL + A.TDACRBAL), -1, 0, A.TDBAL + A.TDACRBAL)	-- Neu loai CO ma AM => la NO => ko lay, (DUONG : lay)
									   			 , 0		-- TK nay ko co loai B nen ko xet
								       ), '01', 'VND', '01')) CURBAL
		     	FROM 	GL1.TBGL_MAST A,
						(	SELECT DISTINCT B.SBVCD, A.ACBLDRCR, A.ACCTCD, B.BCCYFG
							FROM TBGL_CACODB A, GL1.TBGL_SBVCD B
							WHERE A.BRCD = '1000'
								AND A.ACCTCD = B.ACCTCD
								AND SUBSTR(SBVCD, 1, 3) IN  ('921')		-- Vua TK DN, DC
						) B
				WHERE 	A.BRCD like '%'
					AND	A.TRDT = &h_trdt
					AND A.ACCTCD = B.ACCTCD
					AND DECODE(A.CCY, 'VND', '1', 'GD1', '3', 'GD2', '3', 'GD3', '3', 'GD4', '3', '2')	=	B.BCCYFG
					AND	A.TDBAL <> 0
				GROUP BY A.BRCD, A.TRDT

				UNION ALL

				SELECT 	BRCD, &h_trdt TRDT, 'E02' MACT, 0 CURBAL
				FROM 	CS1.TBCS_BRCD

				UNION ALL

				SELECT 	BRCD,
						TRDT,
						'E00' MACT,
						SUM(CURBAL) CURBAL
				FROM
					(	SELECT 	A.BRCD,
								A.TRDT,
								'E01' MACT,
								SUM(CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, A.TDBAL + A.TDACRBAL, '01', 'VND', '01')) CURBAL
						FROM 	GL1.TBGL_MAST A, GL1.TBGL_SBVCD B
						WHERE 	A.BRCD like '%'
							AND	A.TRDT = &h_trdt
							AND	SUBSTR(B.SBVCD, 1, 3) IN ('241', '242')          -- Toan TK DN
							AND DECODE(A.CCY, 'VND', '1', 'GD1', '3', 'GD2', '3', 'GD3', '3', 'GD4', '3', '2')	=	B.BCCYFG
							AND A.ACCTCD	= B.ACCTCD
							AND	A.TDBAL > 0
						GROUP BY A.BRCD, A.TRDT

						UNION ALL

						SELECT 	A.BRCD,
								A.TRDT,
								'E02' MACT,
								SUM(CS1.EXCROSSCAL('1000', 'VND', &h_trdt, A.CCY,
										DECODE(B.ACBLDRCR, 'D', DECODE( SIGN(A.TDBAL + A.TDACRBAL), -1, ABS(A.TDBAL + A.TDACRBAL), 0)	-- Neu loai NO ma AM => la CO => lay, (DUONG : ko lay)
														 , 'C', DECODE( SIGN(A.TDBAL + A.TDACRBAL), -1, 0, A.TDBAL + A.TDACRBAL)	-- Neu loai CO ma AM => la NO => ko lay, (DUONG : lay)
											   			 , 0		-- TK nay ko co loai B nen ko xet
										       ), '01', 'VND', '01')) CURBAL
				     	FROM 	GL1.TBGL_MAST A,
								(	SELECT DISTINCT B.SBVCD, A.ACBLDRCR, A.ACCTCD, B.BCCYFG
									FROM TBGL_CACODB A, GL1.TBGL_SBVCD B
									WHERE A.BRCD = '1000'
										AND A.ACCTCD = B.ACCTCD
										AND SUBSTR(SBVCD, 1, 3) IN  ('921')		-- Vua TK DN, DC
								) B
						WHERE 	A.BRCD like '%'
							AND	A.TRDT = &h_trdt
							AND A.ACCTCD = B.ACCTCD
							AND DECODE(A.CCY, 'VND', '1', 'GD1', '3', 'GD2', '3', 'GD3', '3', 'GD4', '3', '2')	=	B.BCCYFG
							AND	A.TDBAL <> 0
						GROUP BY A.BRCD, A.TRDT
					)
				GROUP BY	BRCD, TRDT

				UNION ALL

				SELECT 	BRCD, &h_trdt TRDT, 'E00' MACT, 0 CURBAL
				FROM 	CS1.TBCS_BRCD

				UNION ALL

				SELECT  BRCD,
						PLNYR TRDT,
						'B01' MACT,
						GL1.PERIODEXCHANGE_F('1', '1000', 'VND', 'USD', &h_trdt, &h_trdt, PLNAMT) CURBAL		-- Quy doi tu USD ve VND
				FROM 	RT1.TBRT_PLAN
				WHERE 	BRCD like '%'
					AND	BRCD <> '9999'
					AND  RPTCD = 'FU25'
					AND  PLNYR = &h_trdt
					AND  SEQ = 2				-- Tat ca cac ngoai te quy doi ve USD
					AND  CCY = 'USD'
					AND	 CODE = 'A17001'		-- Nguon von huy dong (bang ngoai te)

				UNION ALL

				SELECT	BRCD,
						PLNYR TRDT,
						'B02' MACT,
						GL1.PERIODEXCHANGE_F('1', '1000', 'VND', 'GD1', &h_trdt, &h_trdt, SUM(PLNAMT)) CURBAL		-- Quy doi tu GD1 ve VND
				FROM
					(
						SELECT	BRCD, PLNYR, CODE, SUM( DECODE(CODE, 'A17001', PLNAMT, -PLNAMT)) PLNAMT
						FROM 	RT1.TBRT_PLAN
						WHERE 	BRCD like '%'
							AND	BRCD <> '9999'
							AND RPTCD = 'FU25'
							AND PLNYR = &h_trdt
							AND SEQ = 3
							AND CCY = 'GD'							-- Tat ca vang quy doi ve GD1
							AND	CODE in ('A17001', 'A03200')		-- Nguon von huy dong (bang vang)
						GROUP BY BRCD, PLNYR, CODE
					)
				GROUP BY BRCD, PLNYR

				UNION ALL

				SELECT	BRCD,
						PLNYR TRDT,
						'C00' MACT,
						PLNAMT CURBAL
				FROM 	RT1.TBRT_PLAN
				WHERE 	BRCD like '%'
					AND	BRCD <> '9999'
					AND RPTCD = 'FU25'
					AND PLNYR = &h_trdt
					AND SEQ = 1             -- Quy doi VND
					AND CCY = 'VND'
					AND	CODE = 'B05014'		-- Tong no xau

				UNION ALL

				SELECT  BRCD,
						PLNYR TRDT,
						'A04' MACT,
						GL1.PERIODEXCHANGE_F('1', '1000', 'VND', 'USD', &h_trdt, &h_trdt, PLNAMT) CURBAL		-- Quy doi tu USD ve VND
				FROM 	RT1.TBRT_PLAN
				WHERE 	BRCD like '%'
					AND	BRCD <> '9999'
					AND  RPTCD = 'FU25'
					AND  PLNYR = &h_trdt
					AND  SEQ = 2				-- Tat ca cac ngoai te quy doi ve USD
					AND  CCY = 'USD'
					AND	 CODE = 'B05001'		-- Du no cho vay

				UNION ALL

				SELECT	BRCD,
						PLNYR TRDT,
						'A05' MACT,
						GL1.PERIODEXCHANGE_F('1', '1000', 'VND', 'GD1', &h_trdt, &h_trdt, PLNAMT) CURBAL		-- Quy doi tu GD1 ve VND
				FROM 	RT1.TBRT_PLAN
				WHERE 	BRCD like '%'
					AND	BRCD <> '9999'
					AND RPTCD = 'FU25'
					AND PLNYR = &h_trdt
					AND SEQ = 3
					AND CCY = 'GD'			-- Tat ca vang quy doi ve GD1
					AND	CODE = 'B05001'		-- Du no cho vay

				UNION ALL

		  		 SELECT	BRCD,
		  		 		TRDT,
				        'B00' MACT,
				        SUM(CURBAL) CURBAL
				FROM
					(
						SELECT  BRCD,
								PLNYR TRDT,
								PLNAMT CURBAL
						FROM 	RT1.TBRT_PLAN
						WHERE 	BRCD like '%'
							AND	BRCD <> '9999'
							AND  RPTCD = 'FU25'
							AND  PLNYR = &h_trdt
							AND  SEQ = 1				-- Quy doi VND
							AND  CCY = 'VND'
							AND	 CODE = 'A17001'		-- Nguon von huy dong (bang ngoai te)

						UNION ALL

						SELECT  BRCD,
								PLNYR TRDT,
								-PLNAMT CURBAL
						FROM 	RT1.TBRT_PLAN
						WHERE 	BRCD like '%'
							AND	BRCD <> '9999'
							AND  RPTCD = 'FU25'
							AND  PLNYR = &h_trdt
							AND  SEQ = 1				-- Quy doi VND
							AND  CCY = 'VND'
							AND	 CODE = 'A03200'		-- Nguon von huy dong (bang ngoai te)

						UNION ALL

						SELECT 	A.BRCD,
								A.TRDT,
								SUM(CS1.EXCROSSCAL('1000', 'VND', &h_trdt, A.CCY, A.TDBAL + A.TDACRBAL, '01', 'VND', '01')) CURBAL
						FROM 	GL1.TBGL_MAST A, GL1.TBGL_SBVCD B
						WHERE 	A.BRCD = '1000'			-- Chi lay HOI SO thoi
							AND	A.TRDT = &h_trdt
							AND A.ACCTCD BETWEEN '441200' AND '442100'
							AND DECODE(A.CCY, 'VND', '1', 'GD1', '3', 'GD2', '3', 'GD3', '3', 'GD4', '3', '2')	=	B.BCCYFG
							AND A.ACCTCD	= B.ACCTCD
							AND	A.TDBAL > 0
						GROUP BY A.BRCD, A.TRDT
					)
				GROUP BY TRDT, BRCD
			)

		UNION ALL

		SELECT
			&h_trdt TRDT,
			BRCD,
			'05' RPTKND,
			'VND' CCY,
			MACT,
			sum(round(CURBAL / 1000000000, 2)) CURBAL,
			'PLD' DEPTCD,
			'TTHQUYEN' CRTUSR,
			'LN' BUSCD
		FROM
			(
				SELECT  BRCD,
						MACT,
						CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, BAL, '01', 'VND', '01') CURBAL
				FROM
				(
					/* 1A0 - TONG DU NO TIN DUNG */
					SELECT '1A0' MACT, A.BRCD, A.CCY CCYCD, SUM(A.TDBAL) BAL
					FROM
					    GL1.TBGL_MAST A
					WHERE
						A.BRCD LIKE '%'
						AND A.TRDT = &h_trdt
					    AND A.ACCTCD LIKE '2%'
					    AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
					    AND A.TDBAL > 0
					GROUP BY A.BRCD, A.CCY

						UNION ALL

					/* 1A0 - TONG CAM KET NGOAI BANG */
					SELECT '1A0' MACT, BRCD, CCY CCYCD, SUM(NVL(A.TDBAL, 0)) BAL
					 FROM
					 		GL1.TBGL_MAST A
					 WHERE
							A.BRCD LIKE '%'
							AND A.TRDT = &h_trdt
							AND A.TDBAL <> 0
							AND ACCTCD BETWEEN  '921101' AND  '928506'
							AND SUBSTR(ACCTCD,6,1) IN ('1','3','5','7','9')
							AND SUBSTR(ACCTCD,1,3) NOT IN  ('923', '934')
					GROUP BY BRCD, CCY

					UNION ALL

					/* A00 - TONG DU NO CHO VAY */
					SELECT 'A00' MACT, A.BRCD, A.CCY CCYCD, SUM(A.TDBAL) BAL
					FROM
					    GL1.TBGL_MAST A
					WHERE
						A.BRCD LIKE '%'
						AND A.TRDT = &h_trdt
					    AND A.ACCTCD LIKE '2%'
					    AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
					    AND A.TDBAL > 0
					GROUP BY A.BRCD, A.CCY

					UNION ALL

					/* A01 - DU NO CHO VAY BAT DONG SAN */
					SELECT
						'A01' MACT, A.BRCD, CCYCD, SUM(DSBSBAL) BAL
					FROM
						LN1.TBLN_DSBSHIST A
					WHERE
						BRCD LIKE '%'
						AND BKDT = &h_trdt
						AND DSBSBAL > 0
						AND BUSCD = 'LN'
						AND STSCD = '01'
						AND (FNDPRPSTPCD LIKE 'BI%'
							OR
							( FNDPRPSTPCD = '09001'
							  AND NVL(OTHRTPCD,'000') LIKE 'L0%'
							  AND LN1.CHK_LNCUSTTP(BRCD, DSBSID, DSBSSEQ, CUSTSEQLN, 'IND') = 'Y'
							))
					GROUP BY A.BRCD, A.CCYCD

					UNION ALL

					/* A02 - DU NO CHO VAY CHUNG KHOAN */
					SELECT
						'A02' MACT, BRCD, CCYCD, SUM(DSBSBAL) BAL
					FROM
						LN1.TBLN_DSBSHIST B
					WHERE
						B.BRCD LIKE '%'
						AND B.BKDT = &h_trdt
						AND B.DSBSBAL > 0
						AND B.BUSCD = 'LN'
						AND B.STSCD = '01'
						AND B.FNDPRPSTPCD LIKE '10%'
						AND LENGTH(B.FNDPRPSTPCD) = 5
						AND SUBSTR(NVL(B.FNDPRPSUNIT, '01001'), 1, 2) = '01'
					GROUP BY BRCD, CCYCD

					UNION ALL

					/* A02 - Cho vay chung khoan - Du no duoc loai tru */
					SELECT
						'A02' MACT, A.BRCDAPPR BRCD, CCYCD, -SUM(BAL)
					FROM
					(
						SELECT
							A.CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ
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
							CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ, CCYCD, DSBSBAL BAL
						FROM LN1.TBLN_DSBSHIST
						WHERE   BRCD LIKE '%'
								AND STSCD IN ('01', '05')
								AND BUSCD	= 'LN'
								AND FNDPRPSTPCD LIKE '10%'
								AND BKDT = &h_trdt
								AND SUBSTR(NVL(FNDPRPSUNIT, '01001'), 1, 2) = '01'
								AND LENGTH(FNDPRPSTPCD) = 5
					) B
					WHERE
						A.BRCDAPPR		= B.BRCDAPPR
						AND A.APPRID	= B.APPRID
						AND A.APPRSEQ	= B.APPRSEQ
					GROUP BY A.BRCDAPPR, CCYCD

					UNION ALL

					/* A02 - Cho vay chung khoan - Du no 2 cty CK Rong Viet va KimEng */
					SELECT
						'A02' MACT, BRCD, CCY CCYCD, SUM(TDBAL) BAL
					FROM
						GL1.TBGL_MAST
					WHERE TRDT = &h_trdt
						AND BRCD LIKE '%'
						AND ACCTCD LIKE '275%00'
						AND CUSTSEQ IN ('101888290', '102458781')
					GROUP BY BRCD, CCY

					UNION ALL

					/* A03 - DU NO CHO VAY TIEU DUNG */
					SELECT
						'A03' MACT, BRCD, CCYCD, SUM(DSBSBAL) BAL
					FROM
						LN1.TBLN_DSBSHIST
					WHERE
						BRCD LIKE '%'
						AND BKDT = &h_trdt
						AND DSBSBAL > 0
						AND BUSCD = 'LN'
						AND FNDPRPSTPCD LIKE '09%'
						AND
						(
							FNDPRPSTPCD <> '09001'
							OR (FNDPRPSTPCD = '09001' AND NVL(OTHRTPCD,'000') LIKE 'L1%')
						)
						AND LN1.CHK_LNCUSTTP(BRCD, DSBSID, DSBSSEQ, CUSTSEQLN, 'IND') = 'Y'
					GROUP BY BRCD, CCYCD

					UNION ALL

					/* A03 - Thau chi + The tin dung */
					SELECT
						'A03' MACT, BRCD, CCY CCYCD, SUM(TDBAL) BAL
					FROM GL1.TBGL_MAST
					WHERE
						BRCD LIKE '%'
						AND TRDT = &h_trdt
						AND TDBAL > 0
						AND (ACCTCD LIKE '275_01'
							OR (ACCTCD LIKE '275_00'
									AND LN1.CHK_LNCUSTTP(BRCD, '', '', CUSTSEQ, 'IND') = 'Y'))
					GROUP BY BRCD, CCY

					UNION ALL

					/* A06 - DU NO CHO VAY XUAT KHAU */
					SELECT 'A06' MACT, BRCD, CCYCD, SUM(DSBSBAL) BAL
					FROM LN1.TBLN_DSBSHIST A
					WHERE
						A.BRCD LIKE '%'
						AND A.BKDT = &h_trdt
						AND A.BUSCD = 'LN'
						AND A.DSBSBAL > 0
						AND SUBSTR(A.FNDPRPSUNIT, 1, 2) = '01'
						AND SUBSTR(A.FNDPRPSTPCD, 1, 2) > '11'
						AND A.STSCD = '01'
					GROUP BY BRCD, CCYCD

					UNION ALL

					/* A07 - DU NO CHO VAY DOANH NGHIEP VUA VA NHO */
					SELECT
						'A07' MACT, A.BRCD, CCYCD, SUM(DSBSBAL) BAL
					FROM
						LN1.TBLN_DSBSHIST A, CM1.TBCM_GENERAL B, CM1.TBCM_CORP C
					WHERE
						A.BRCD LIKE '%'
						AND A.BKDT = &h_trdt
						AND A.BUSCD = 'LN'
						AND A.DSBSBAL > 0
						AND B.STSCD = '01'
						AND A.BRCDLN = B.BRCD
						AND A.CUSTSEQLN = B.CUSTSEQ
						AND B.BRCD = C.BRCD
						AND B.CUSTSEQ = C.CUSTSEQ
						AND
						(
							(C.ECNMINDUSTRCD1 IN ('01', '03', '04', '05', '06', '21') AND C.ASSTTOT <= 100000000000)
							OR (C.ECNMINDUSTRCD1 NOT IN ('01', '03', '04', '05', '06', '21') AND C.ASSTTOT <= 50000000000)
						)
					GROUP BY A.BRCD, CCYCD
				)
			)
		GROUP BY 	BRCD, MACT
	) A,
	(	SELECT 	B.DECODE, A.LOCCD, A.BRCD--, LCLBRNM
		FROM 	CS1.TBCS_BRCD A, RACE.T_CODE B
		WHERE	B.CAT_NAME = 'DPLOCCD'
			AND A.LOCCD = B.CODE
	) B
WHERE	A.BRCD = B.BRCD
GROUP BY TRDT, DECODE, LOCCD, MACT
ORDER BY	LOCCD, MACT;
