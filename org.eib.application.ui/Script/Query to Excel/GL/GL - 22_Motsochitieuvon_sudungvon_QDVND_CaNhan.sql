--define h_trdt = '20110725'


SELECT 	LCLBRNM,
		SUM(TDBAL) DUNO,         			-- Du no	(lay tu LN)
		SUM(TDBAL) - SUM(TDBAL1) DNQH,		-- Du no trong han	(lay tu LN)
		SUM(TDBAL2) PHATHANHGIAYTOCOGIA,    -- PH CTCG
		SUM(TDBAL3) TGTT,        			-- TG thanh toan
		SUM(TDBAL4) TGTK,        			-- TG tiet kiem
		SUM(TDBAL5) LOINHUAN,				-- Loi nhuan
		SUM(TDBAL6) VANGGIUHO				-- Vang giu ho
FROM
	(	SELECT  BRCD, BAL TDBAL, BAL1 TDBAL1, BAL2 TDBAL2, BAL3 TDBAL3, BAL4 TDBAL4, 0 TDBAL5, BAL6 TDBAL6
		FROM
			(	SELECT  BRCD,
						CODE ,
        				0 BAL,
				        0 BAL1,
				        SUM(DECODE(CODE,'A02000' , -TDBAL ,0))  BAL2,
				        SUM(DECODE(CODE,'A01000' , -TDBAL ,0))  BAL3,
				        SUM(DECODE(CODE,'A05000' , -TDBAL ,0))  BAL4,
				        0 BAL6
				FROM
					(	SELECT	BRCD, F.CODE CODE, E.TDBAL TDBAL
				        FROM
				        	(	SELECT  C.BRCD,SUM(DECODE('100','100',TDBAL100
														   ,'200',TDBAL200,TDBAL100+TDBAL200))TDBAL ,LEVEL1,LEVEL2
								FROM
									(	SELECT	G.TRDT,   G.BRCD BRCD,
												G.ACCTCD ACCTCD,
												SUM ( decode ( G.CUSTTPCD,'100', decode(G.CCY, 'VND',G.TDBAL, CS1.excrosscal('1000', 'VND',  &h_trdt, G.CCY, G.TDBAL, '01', 'VND', '01'))
														       	,0)) TDBAL100,
													SUM(decode(G.CUSTTPCD,'100',0,decode(G.CCY, 'VND',G.TDBAL, CS1.excrosscal('1000', 'VND',  &h_trdt, G.CCY, G.TDBAL, '01', 'VND', '01'))
														       )) TDBAL200
			      							FROM	(	SELECT  	A.TRDT,  A.BRCD BRCD,
														  	A.CCY CCY,  A.ACCTCD ACCTCD,
														  	C.CUSTTPCD,
															SUM(DECODE(B.ACBLDRCR,'C', -A.TDBAL - A.TDACRBAL, A.TDBAL + A.TDACRBAL)) TDBAL
													FROM	 	TBGL_MAST A, TBGL_CACODB  B,TBCM_GENERAL C
													WHERE	A.TRDT LIKE &h_trdt
														AND	A.BRCD  like  '%'
														AND  B.BRCD =  A.BRCD
														AND  B.ACCTCD =  A.ACCTCD
														AND 	A.BRCD=C.BRCD(+)
														AND	A.CUSTSEQ=C.CUSTSEQ(+)
														AND  B.ACCTKD IN ('2','3')
														AND	A.TDBAL+A.TDACRBAL <> 0
														AND 	A.ONOFFTP LIKE '1'
													GROUP   BY A.TRDT, A.BRCD, A.CCY, A.ACCTCD,C.CUSTTPCD
								        			) G
											GROUP BY  G.TRDT, G.BRCD, G.ACCTCD
										) C, GL1.TBGL_RPTAC_NEW D
									WHERE   D.BRCD ='1000'
									      AND D.RPTCD= 'FU01'
									      AND D.FLG= '4'
									      AND SUBSTR(C.ACCTCD,1,6)=D.ACCTFOUR
									GROUP BY C.BRCD,LEVEL1,LEVEL2
									ORDER BY LEVEL1,LEVEL2
								) E, RACE.T_CODE F
							WHERE 	F.CAT_NAME='GLMISRPT'|| 'FU01' AND F.COUNTRY='VN'
								AND (	F.CODE=E.LEVEL1 OR
			 							F.CODE=E.LEVEL2
									)
								AND  F.CODE IN('A01000','A05000','A02000')
						)
					GROUP BY BRCD,CODE
				)

			-- Ket cau ben LN
			UNION ALL

			SELECT	BRCD, SUM(A.TDBAL_VND) BAL, SUM(A.DNTH_VND) BAL1, 0 BAL2, 0  BAL3, 0  BAL4, 0  BAL5, 0  BAL6
			FROM   (	SELECT	A.BRCD,
							SUM(DECODE(A.CCY, 'VND', A.LDRBAL,
										CS1.EXCROSSCAL ('1000', 'VND', &h_trdt, A.CCY, NVL(A.LDRBAL,0), '01', 'VND', '01'))) TDBAL_VND,
							SUM(DECODE(A.CCY, 'VND', DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', NVL(A.LDRBAL,0), 0),
										CS1.EXCROSSCAL ('1000', 'VND', &h_trdt, A.CCY, DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', NVL(A.LDRBAL,0), 0), '01', 'VND', '01'))) DNTH_VND
					FROM		TBGL_BALDD A, TBCM_GENERAL C, TBLN_DSBS D
					WHERE	A.TRDT 	= 	&h_trdt
						AND A.BRCD LIKE  '%'
						AND A.ACCTCD LIKE '2%'
						AND SUBSTR(A.ACCTCD, 3, 1) <> '9'
						AND SUBSTR(A.ACCTCD, 1, 3) <> '217'
						AND SUBSTR(A.ACCTCD, 1, 3) <> '221'
						AND SUBSTR(A.ACCTCD, 1, 3) <> '275'
						AND A.BUSCD 	= 	'LN'
						AND A.LDRBAL 	> 	0
						AND A.BRCD 	= 	C.BRCD(+)
						AND A.CUSTSEQ 	= 	C.CUSTSEQ(+)
						AND A.BRCD 	= 	D.BRCD
						AND A.TRREF 	= 	D.DSBSID
						AND A.TRSEQ 	= 	D.DSBSSEQ
						AND D.STSCD IN ('01', '05')
						AND LN1.CHK_LNCUSTTP(D.BRCD, D.DSBSID, D.DSBSSEQ, '', decode('100' , '300', 'all'
																				, '100', 'ind'
																				, '200', 'cmp')) = 'Y'
					GROUP BY	A.BRCD, A.CUSTSEQ, C.NMLOC, A.CCY

					UNION ALL

					SELECT	E.BRCD,
							SUM(DECODE(A.CCY, 'VND', A.LDRBAL,
									CS1.EXCROSSCAL ('1000', 'VND', &h_trdt, A.CCY, NVL(A.LDRBAL,0), '01', 'VND', '01'))) TDBAL_VND,
							SUM(DECODE(A.CCY, 'VND', DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', NVL(A.LDRBAL,0), 0),
									CS1.EXCROSSCAL ('1000', 'VND', &h_trdt, A.CCY, DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', NVL(A.LDRBAL,0), 0), '01', 'VND', '01'))) DNTH_VND
					FROM		TBGL_BALDD A, TBCM_GENERAL C, TBLN_DSBS D, LN1.TBLN_LNIDSEQ E
					WHERE   A.TRDT = &h_trdt
						AND E.BRCD LIKE  '%'
						AND A.ACCTCD LIKE '2%'
						AND SUBSTR(A.ACCTCD, 3, 1) <> '9'
						AND SUBSTR(A.ACCTCD, 1, 3) <> '217'
						AND SUBSTR(A.ACCTCD, 1, 3) <> '221'
						AND SUBSTR(A.ACCTCD, 1, 3) <> '275'
						AND A.BUSCD 	= 	'LN'
						AND A.LDRBAL 	> 	0
						AND A.BRCD 	= 	C.BRCD(+)
						AND A.CUSTSEQ 	= 	C.CUSTSEQ(+)
						AND A.BRCD 	= 	E.BRCDOLD
						AND A.TRREF 	= 	E.ID
						AND A.TRSEQ 	= 	E.SEQOLD
						AND A.BRCD 	= 	D.BRCD
						AND E.BRCD 	= 	D.BRCD
						AND E.ID 		= 	D.DSBSID
						AND E.SEQ 	= 	D.DSBSSEQ
						AND D.STSCD IN ('01', '05')
						AND LN1.CHK_LNCUSTTP(D.BRCD, D.DSBSID, D.DSBSSEQ, '', decode('100' , '300', 'all'
																				, '100', 'ind'
																				, '200', 'cmp')) = 'Y'
					GROUP BY	E.BRCD, A.CUSTSEQ, C.NMLOC, A.CCY

					UNION ALL

					SELECT	A.BRCD,
							SUM(DECODE(A.CCY, 'VND', A.TDBAL,
									CS1.EXCROSSCAL ('1000', 'VND', &h_trdt, A.CCY, NVL(A.TDBAL,0), '01', 'VND', '01'))) TDBAL_VND,
							SUM(DECODE(A.CCY, 'VND', DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', NVL(A.TDBAL,0), 0),
									CS1.EXCROSSCAL ('1000', 'VND', &h_trdt, A.CCY, DECODE(SUBSTR(A.ACCTCD, 4, 1), '1', NVL(A.TDBAL,0), 0), '01', 'VND', '01'))) DNTH_VND
					FROM		TBGL_MAST A, TBCM_GENERAL C
					WHERE	A.TRDT = &h_trdt
						AND A.BRCD LIKE  '%'
						AND A.ACCTCD LIKE '2%'
						AND SUBSTR(A.ACCTCD, 1, 3)  NOT IN ('211', '212', '213', '217', '222', '223', '241', '271')
						AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
						AND LN1.CHKACCT20SBV(A.ACCTCD, A.CCY) = 'N'
						AND A.TDBAL 	> 	0
						AND A.BRCD 	= 	C.BRCD
						AND A.CUSTSEQ 	= 	C.CUSTSEQ
						AND LN1.CHK_LNCUSTTP(C.BRCD, '', '', C.CUSTSEQ, decode('100' , '300', 'all'
																			, '100', 'ind'
																			, '200', 'cmp')) = 'Y'
					GROUP BY	A.ACCTCD, A.BRCD, A.CUSTSEQ, C.NMLOC, A.CCY
				) A
			GROUP BY BRCD
			-- END Ket cau ben LN

			UNION ALL	-- Vang giu ho

			SELECT 	A.BRCD, 0 BAL, 0 BAL1, 0 BAL2, 0 BAL3, 0 BAL4, 0 BAL5,
					SUM(DECODE(A.CCY, 'VND', A.TDBAL,
									CS1.EXCROSSCAL ('1000', 'VND', &h_trdt, A.CCY, NVL(A.TDBAL,0), '01', 'VND', '01'))) BAL6
			FROM 	TBGL_MAST A, TBCM_GENERAL B
			WHERE 	A.TRDT 		= &h_trdt
				AND A.ACCTCD 	= '462102'
				AND A.CCY 		= 'GD1'
				AND	A.CUSTSEQ 	= B.CUSTSEQ
				AND	A.BRCD 		= B.BRCD
				AND	B.CUSTTPCD 	= DECODE('100', '200', '000', '100') 		-- Chi co ca nhan moi co vang giu ho
			GROUP BY A.TRDT, A.BRCD, A.CCY

			UNION ALL -- CHI TINH LOI NHUAN CHO ALL

			SELECT	BRCD, 0 BAL, 0 BAL1, 0 BAL2 , 0 BAL3, 0 BAL4, DECODE('100','300',ACRTDBAL,0) BAL5, 0 BAL6
			FROM		GL1.TBGL_BSPLVN
			WHERE   	TRDT LIKE &h_trdt
				AND	BRCD  like  '%'
				AND 	ACCTCD ='M00000'
		) A,CS1.TBCS_BRCD B
	WHERE 	A.BRCD = B.BRCD
	GROUP  BY LCLBRNM;
