SELECT	G.BRCD CHINHANH,G.CODE , G.NAME,
		DECODE(G.CODE,'A03100',SUM(DUCUOI_VND)  -
		NVL((SELECT
			SUM(GL1.PERIODEXCHANGE_F('1', '1000', 'VND', A.CCY, '20121103', '20121103', A.TDBAL + A.TDACRBAL))	DUCUOI_VND
	FROM   	GL1.TBGL_MAST A, CM1.TBCM_GENERAL B,GL1.TBGL_SBVCD C
	WHERE	A.TRDT  = '20121103'
			AND	B.BRCD= '1000'
			AND 	A.CUSTSEQ = B.CUSTSEQ
		   	AND 	B.CUSTTPCD = '600'
			AND A.ACCTCD =C.ACCTCD
			AND SUBSTR(C.SBVCD,1,2)= '43'
			AND A.BRCD =G.BRCD
			AND NVL(A.CCY, '%') LIKE DECODE(C.BCCYFG,'1','VND'
											    ,'3','GD%'
												,'2',DECODE(A.CCY,'VND','###'
												                 ,'GD1','###'
															     ,'GD2','###'
															     ,'GD3','###'
															     ,'GD4','###'
															     ,'%' ),'%')),0),SUM(DUCUOI_VND)) DUCUOI_QDVND,
		DECODE(G.CODE,'A03100',SUM(DUCUOI_USD)  -
		NVL((SELECT	SUM(DECODE(CCY, 'VND',0,DECODE(SUBSTR(CCY,1,2),'GD',0,CS1.excrosscal('1000', 'VND',  '20121103', CCY, A.TDBAL + A.TDACRBAL, '01', 'USD', '01')))) ADBAL_USD
			--SUM(DECODE(SUBSTR(CCY,1,2),'GD',A.TDBAL + A.TDACRBAL,0)) ADBAL_GD
	FROM   	GL1.TBGL_MAST A, CM1.TBCM_GENERAL B,GL1.TBGL_SBVCD C
	WHERE	A.TRDT  = '20121103'
			AND	B.BRCD= '1000'
			AND 	A.CUSTSEQ = B.CUSTSEQ
		   	AND 	B.CUSTTPCD = '600'
			AND A.ACCTCD =C.ACCTCD
			AND SUBSTR(C.SBVCD,1,2)= '43'
			AND A.BRCD =G.BRCD
			AND NVL(A.CCY, '%') LIKE DECODE(C.BCCYFG,'1','VND'
											    ,'3','GD%'
												,'2',DECODE(A.CCY,'VND','###'
												                 ,'GD1','###'
															     ,'GD2','###'
															     ,'GD3','###'
															     ,'GD4','###'
															     ,'%' ),'%')),0),SUM(DUCUOI_USD)) DUCUOI_QDUSD,
		DECODE(G.CODE,'A03100',SUM(DUCUOI_GD)  -
		NVL((SELECT	SUM(DECODE(SUBSTR(CCY,1,2),'GD',A.TDBAL + A.TDACRBAL,0)) ADBAL_GD
	FROM   	GL1.TBGL_MAST A, CM1.TBCM_GENERAL B,GL1.TBGL_SBVCD C
	WHERE	A.TRDT  = '20121103'
			AND	B.BRCD= '1000'
			AND 	A.CUSTSEQ = B.CUSTSEQ
		   	AND 	B.CUSTTPCD = '600'
			AND A.ACCTCD =C.ACCTCD
			AND SUBSTR(C.SBVCD,1,2)= '43'
			AND A.BRCD =G.BRCD
			AND NVL(A.CCY, '%') LIKE DECODE(C.BCCYFG,'1','VND'
											    ,'3','GD%'
												,'2',DECODE(A.CCY,'VND','###'
												                 ,'GD1','###'
															     ,'GD2','###'
															     ,'GD3','###'
															     ,'GD4','###'
															     ,'%' ),'%')),0),SUM(DUCUOI_GD)) DUCUOI_QDGD
FROM
(
	SELECT	B.BRCD,C.CODE , C.NAME,B.DUCUOI_VND,B.DUCUOI_USD,B.DUCUOI_GD
	FROM
	(
			SELECT	A.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,
					DECODE(A.CONDITION,	'DN'	, A.DCN_VND,
								    	'DC'	, A.DCC_VND,
									    '-DC'	, -A.DCC_VND,
										'CLDC'	, DECODE(SIGN(A.DCC_VND-A.DCN_VND),-1,0,A.DCC_VND-A.DCN_VND)) DUCUOI_VND,
					DECODE(A.CONDITION,	'DN'	, A.DCN_USD,
								    	'DC'	, A.DCC_USD,
									    '-DC'	, -A.DCC_USD,
										'CLDC'	, DECODE(SIGN(A.DCC_USD-A.DCN_USD),-1,0,A.DCC_USD-A.DCN_USD)) DUCUOI_USD,
					DECODE(A.CONDITION,	'DN'	, A.DCN_GD,
								    	'DC'	, A.DCC_GD,
									    '-DC'	, -A.DCC_GD,
										'CLDC'	, DECODE(SIGN(A.DCC_GD-A.DCN_GD),-1,0,A.DCC_GD-A.DCN_GD)) DUCUOI_GD
			FROM
			(
					SELECT	B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4, A.CONDITION, A.EXCEPT,
						 	SUM(B.DCN_VND) DCN_VND, SUM(B.DCC_VND) DCC_VND,
							SUM(B.DCN_USD) DCN_USD, SUM(B.DCC_USD) DCC_USD,
							SUM(B.DCN_GD) DCN_GD, SUM(B.DCC_GD) DCC_GD
					FROM gl1.TBGL_RPTAC_NEW A,
					(
							SELECT              A.BRCD,
												A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,CCY,
												ROUND(ADBAL_VND_DR,0) DCN_VND,
												ROUND(ADBAL_VND_CR,0) DCC_VND,
												ROUND(ADBAL_USD_DR,0) DCN_USD,
												ROUND(ADBAL_USD_CR,0) DCC_USD,
												ROUND(ADBAL_GD_DR,0) DCN_GD,
												ROUND(ADBAL_GD_CR,0) DCC_GD
							FROM
							(
									SELECT	MAX(BRCD) AS BRCD,
											MAX(ACCTCD) AS ACCTCD,
											DECODE(LENGTH(MAX(ACCTCD)), 6, MAX(CCY), '') AS CCY,
											SUM(ADBAL_VND_DR) AS ADBAL_VND_DR,
											SUM(ADBAL_VND_CR) AS ADBAL_VND_CR,
											SUM(ADBAL_USD_DR) AS ADBAL_USD_DR,
											SUM(ADBAL_USD_CR) AS ADBAL_USD_CR,
											SUM(ADBAL_GD_DR) AS ADBAL_GD_DR,
											SUM(ADBAL_GD_CR) AS ADBAL_GD_CR
									FROM
									(
											SELECT	A.BRCD,
													DECODE(LENGTH(B.ACCTCD), 6, A.BRCD||B.ACCTCD||A.CCY, B.ACCTCD) AS GROUP_COL,
													B.ACCTCD AS ACCTCD,
													A.CCY AS CCY,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_VND), -1, -A.ADBAL_VND, 0),
																					DECODE(SIGN(A.ADBAL_VND), -1, 0, A.ADBAL_VND)
																					)
																) AS ADBAL_VND_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_VND), -1, 0, A.ADBAL_VND),
																					DECODE(SIGN(A.ADBAL_VND), -1, -A.ADBAL_VND, 0)
																					)
																) AS ADBAL_VND_CR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_USD), -1, -A.ADBAL_USD, 0),
																					DECODE(SIGN(A.ADBAL_USD), -1, 0, A.ADBAL_USD)
																					)
																) AS ADBAL_USD_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_USD), -1, 0, A.ADBAL_USD),
																					DECODE(SIGN(A.ADBAL_USD), -1, -A.ADBAL_USD, 0)
																					)
																) AS ADBAL_USD_CR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_GD), -1, -A.ADBAL_GD, 0),
																					DECODE(SIGN(A.ADBAL_GD), -1, 0, A.ADBAL_GD)
																					)
																) AS ADBAL_GD_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_GD), -1, 0, A.ADBAL_GD),
																					DECODE(SIGN(A.ADBAL_GD), -1, -A.ADBAL_GD, 0)
																					)
																) AS ADBAL_GD_CR
											   FROM
											   (
											   		SELECT	BRCD,ACCODE, CCY,
															GL1.PERIODEXCHANGE_F('1', '1000', 'VND', CCY, '20121103', '20121103', ADBAL) ADBAL_VND,
															DECODE(CCY, 'VND',0,DECODE(SUBSTR(CCY,1,2),'GD',0,CS1.excrosscal('1000', 'VND',  '20121103', CCY, ADBAL, '01', 'USD', '01'))) ADBAL_USD,
															DECODE(SUBSTR(CCY,1,2),'GD',ADBAL,0) ADBAL_GD

													FROM
													(
															SELECT BRCD,ACCODE, CCY, SUM(ADBAL) ADBAL
															FROM
															(

																	SELECT	BRCD,ACCTCD ACCODE, CCY,
																			SUM(TDBAL + TDACRBAL)ADBAL
																	FROM  TBGL_MAST
																	WHERE TRDT  = '20121103'
																	AND   ONOFFTP = '1'
																	AND   CUSTSEQ     LIKE '%'
																	AND  ACCTCD > '000000'
																	AND	ACCTCD < '999999'
																	AND    (ACCTCD <> '691000'
																	AND ACCTCD  NOT IN ( SELECT DISTINCT ACCTCD
																						FROM GL1.TBGL_SBVCD
																						WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																						)
																			)
												   					GROUP BY  BRCD,ACCTCD, CCY
															)
											   				GROUP BY  BRCD,ACCODE, CCY
											   				UNION ALL
															SELECT	BRCD,ACCTCD ACCODE, CCY,
																	(TDBAL + TDACRBAL) ADBAL
															FROM  TBGL_MAST
															WHERE TRDT  = '20121103'
															AND   ONOFFTP = '1'
															AND   CUSTSEQ     LIKE '%'
															AND   ACCTCD > '000000'
															AND	 ACCTCD < '999999'
															AND   ACCTCD   IN ( SELECT DISTINCT ACCTCD
																				FROM GL1.TBGL_SBVCD
																				WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																				)
													)
								   			) A,
											TBGL_CACODB B
											WHERE   B.BRCD  = '1000'
											AND     B.ACCTCD =  A.ACCODE
											GROUP BY A.BRCD,B.ACCTCD, A.CCY
									)
									GROUP BY GROUP_COL

							) A, GL1.TBGL_SBVCD D

							WHERE A.ACCTCD     = D.ACCTCD (+)
							AND NVL(A.CCY, '%') LIKE DECODE(D.BCCYFG,'1','VND'
																						,'3','GD%'
																						,'2',DECODE(A.CCY,'VND','###'
																						,'GD1','###'
																						,'GD2','###'
																						,'GD3','###'
																						,'GD4','###'
																						,'%' )
																						,'%')
					) B
		   		WHERE
				A.RPTCD= 'FU27'
				AND A.FLG='2'
				AND A.LEVEL2 IN ('A03000','A03100','B01000','B02000')
			 	AND TRIM(A.ACCTFOUR) = DECODE(SIGN(LENGTH(TRIM(A.ACCTFOUR))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR)))) --THAO 20091210
				AND NVL(TRIM(A.EXCEPT),'0') <> DECODE(NVL(TRIM(A.EXCEPT),'0'),'0','1',DECODE(SIGN(LENGTH(TRIM(A.EXCEPT))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.EXCEPT))))) --THAO 20080527
				GROUP BY B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
				ORDER BY B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
	   		) A
	   		UNION ALL
	   		SELECT	A.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,
					DECODE(A.CONDITION,	'DN'	, A.DCN_VND,
								    	'DC'	, A.DCC_VND,
									    '-DC'	, -A.DCC_VND,
										'CLDC'	, DECODE(SIGN(A.DCC_VND-A.DCN_VND),-1,0,A.DCC_VND-A.DCN_VND)) DUCUOI_VND,
					DECODE(A.CONDITION,	'DN'	, A.DCN_USD,
								    	'DC'	, A.DCC_USD,
									    '-DC'	, -A.DCC_USD,
										'CLDC'	, DECODE(SIGN(A.DCC_USD-A.DCN_USD),-1,0,A.DCC_USD-A.DCN_USD)) DUCUOI_USD,
					DECODE(A.CONDITION,	'DN'	, A.DCN_GD,
								    	'DC'	, A.DCC_GD,
									    '-DC'	, -A.DCC_GD,
										'CLDC'	, DECODE(SIGN(A.DCC_GD-A.DCN_GD),-1,0,A.DCC_GD-A.DCN_GD)) DUCUOI_GD
			FROM
			(
					SELECT	B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4, A.CONDITION, A.EXCEPT,
						 	SUM(B.DCN_VND) DCN_VND, SUM(B.DCC_VND) DCC_VND,
							 SUM(B.DCN_USD) DCN_USD, SUM(B.DCC_USD) DCC_USD,
							 SUM(B.DCN_GD) DCN_GD, SUM(B.DCC_GD) DCC_GD
					FROM	GL1.TBGL_RPTAC_NEW A,
					(
							SELECT              A.BRCD,
												A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,CCY,
												ROUND(ADBAL_VND_DR,0) DCN_VND,
												ROUND(ADBAL_VND_CR,0) DCC_VND,
												ROUND(ADBAL_USD_DR,0) DCN_USD,
												ROUND(ADBAL_USD_CR,0) DCC_USD,
												ROUND(ADBAL_GD_DR,0) DCN_GD,
												ROUND(ADBAL_GD_CR,0) DCC_GD
							FROM
							(
									SELECT  MAX(BRCD) AS BRCD,
											MAX(ACCTCD) AS ACCTCD,
											DECODE(LENGTH(MAX(ACCTCD)), 6, MAX(CCY), '') AS CCY,
											SUM(ADBAL_VND_DR) AS ADBAL_VND_DR,
											SUM(ADBAL_VND_CR) AS ADBAL_VND_CR,
											SUM(ADBAL_USD_DR) AS ADBAL_USD_DR,
											SUM(ADBAL_USD_CR) AS ADBAL_USD_CR,
											SUM(ADBAL_GD_DR) AS ADBAL_GD_DR,
											SUM(ADBAL_GD_CR) AS ADBAL_GD_CR
									FROM
									(
											SELECT  A.BRCD,
													DECODE(LENGTH(B.ACCTCD), 6, A.BRCD||B.ACCTCD||A.CCY, B.ACCTCD) AS GROUP_COL,
													B.ACCTCD AS ACCTCD,
													A.CCY AS CCY,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_VND), -1, -A.ADBAL_VND, 0),
																					DECODE(SIGN(A.ADBAL_VND), -1, 0, A.ADBAL_VND)
																					)
																) AS ADBAL_VND_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_VND), -1, 0, A.ADBAL_VND),
																					DECODE(SIGN(A.ADBAL_VND), -1, -A.ADBAL_VND, 0)
																					)
																) AS ADBAL_VND_CR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_USD), -1, -A.ADBAL_USD, 0),
																					DECODE(SIGN(A.ADBAL_USD), -1, 0, A.ADBAL_USD)
																					)
																) AS ADBAL_USD_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_USD), -1, 0, A.ADBAL_USD),
																					DECODE(SIGN(A.ADBAL_USD), -1, -A.ADBAL_USD, 0)
																					)
																) AS ADBAL_USD_CR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_GD), -1, -A.ADBAL_GD, 0),
																					DECODE(SIGN(A.ADBAL_GD), -1, 0, A.ADBAL_GD)
																					)
																) AS ADBAL_GD_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_GD), -1, 0, A.ADBAL_GD),
																					DECODE(SIGN(A.ADBAL_GD), -1, -A.ADBAL_GD, 0)
																					)
																) AS ADBAL_GD_CR
											   FROM
											   (
											   		SELECT	BRCD,ACCODE, CCY,
															GL1.PERIODEXCHANGE_F('1', '1000', 'VND', CCY, '20121103', '20121103', ADBAL) ADBAL_VND,
															DECODE(CCY, 'VND',0,DECODE(SUBSTR(CCY,1,2),'GD',0,CS1.excrosscal('1000', 'VND',  '20121103', CCY, ADBAL, '01', 'USD', '01'))) ADBAL_USD,
															DECODE(SUBSTR(CCY,1,2),'GD',ADBAL,0) ADBAL_GD
													FROM
													(
															SELECT BRCD,ACCODE, CCY, SUM(ADBAL) AS ADBAL
															FROM
															(

																	SELECT	BRCD,ACCTCD ACCODE, CCY,
																			SUM(TDBAL + TDACRBAL) ADBAL
																	FROM  TBGL_MAST
																	WHERE TRDT  = '20121103'
																	AND   ONOFFTP = '1'
																	AND   CUSTSEQ     LIKE '%'
																	AND  ACCTCD > '000000'
																	AND	ACCTCD < '999999'
																	AND    (ACCTCD <> '691000'
																	AND ACCTCD  NOT IN ( SELECT DISTINCT ACCTCD
																						FROM GL1.TBGL_SBVCD
																						WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																						)
																			)
																	AND CUSTSEQ IN (SELECT CUSTSEQ
																							FROM CM1.TBCM_GENERAL
																							WHERE CUSTTPCD <> '100')
												   					GROUP BY  BRCD,ACCTCD, CCY
															)
											   				GROUP BY  BRCD,ACCODE, CCY
											   				UNION ALL
															SELECT	BRCD,ACCTCD ACCODE, CCY,
																	(TDBAL + TDACRBAL) ADBAL
															FROM  TBGL_MAST
															WHERE TRDT  = '20121103'
															AND   ONOFFTP = '1'
															AND   CUSTSEQ     LIKE '%'
															AND   ACCTCD   IN ( SELECT DISTINCT ACCTCD
																				FROM GL1.TBGL_SBVCD
																				WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																				)
															AND CUSTSEQ IN (SELECT CUSTSEQ
																							FROM CM1.TBCM_GENERAL
																							WHERE CUSTTPCD <> '100')
													)
								   			) A,
											TBGL_CACODB B
											WHERE   B.BRCD  =  '1000'
											AND     B.ACCTCD =  A.ACCODE
											GROUP BY A.BRCD,b.acctcd, A.CCY
									)
									GROUP BY GROUP_COL

							) A, GL1.TBGL_SBVCD D

							WHERE A.ACCTCD     = D.ACCTCD (+)
							AND NVL(A.CCY, '%') LIKE DECODE(D.BCCYFG,'1','VND'
																						,'3','GD%'
																						,'2',DECODE(A.CCY,'VND','###'
																						,'GD1','###'
																						,'GD2','###'
																						,'GD3','###'
																						,'GD4','###'
																						,'%' )
																						,'%')
					) B
		   		WHERE	A.RPTCD= 'FU25'
						AND A.FLG='2'
						AND A.LEVEL2 = 'A01000'
						AND A.LEVEL3 IS NULL
			    		AND TRIM(A.ACCTFOUR) = DECODE(SIGN(LENGTH(TRIM(A.ACCTFOUR))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR)))) --TTDTRAM 20110105
						AND NVL(TRIM(A.EXCEPT),'0') <> DECODE(NVL(TRIM(A.EXCEPT),'0'),'0','1',DECODE(SIGN(LENGTH(TRIM(A.EXCEPT))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.EXCEPT))))) --THAO 20080527
				GROUP BY B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
				ORDER BY A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
	   		) A
	   		UNION ALL
	   		SELECT	A.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,
					DECODE(A.CONDITION,	'DN'	, A.DCN_VND,
								    	'DC'	, A.DCC_VND,
									    '-DC'	, -A.DCC_VND,
										'CLDC'	, DECODE(SIGN(A.DCC_VND-A.DCN_VND),-1,0,A.DCC_VND-A.DCN_VND)) DUCUOI_VND,
					DECODE(A.CONDITION,	'DN'	, A.DCN_USD,
								    	'DC'	, A.DCC_USD,
									    '-DC'	, -A.DCC_USD,
										'CLDC'	, DECODE(SIGN(A.DCC_USD-A.DCN_USD),-1,0,A.DCC_USD-A.DCN_USD)) DUCUOI_USD,
					DECODE(A.CONDITION,	'DN'	, A.DCN_GD,
								    	'DC'	, A.DCC_GD,
									    '-DC'	, -A.DCC_GD,
										'CLDC'	, DECODE(SIGN(A.DCC_GD-A.DCN_GD),-1,0,A.DCC_GD-A.DCN_GD)) DUCUOI_GD


			FROM
			(
					SELECT 	B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4, A.CONDITION, A.EXCEPT,
						 SUM(B.DCN_VND) DCN_VND, SUM(B.DCC_VND) DCC_VND,
						 SUM(B.DCN_USD) DCN_USD, SUM(B.DCC_USD) DCC_USD,
						 SUM(B.DCN_GD) DCN_GD, SUM(B.DCC_GD) DCC_GD

					FROM gl1.TBGL_RPTAC_NEW A,
					(
							SELECT              A.BRCD,
												A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,CCY,
												ROUND(ADBAL_VND_DR,0) DCN_VND,
												ROUND(ADBAL_VND_CR,0) DCC_VND,
												ROUND(ADBAL_USD_DR,0) DCN_USD,
												ROUND(ADBAL_USD_CR,0) DCC_USD,
												ROUND(ADBAL_GD_DR,0) DCN_GD,
												ROUND(ADBAL_GD_CR,0) DCC_GD
							FROM
							(
									SELECT	MAX(BRCD) AS BRCD,
											MAX(ACCTCD) AS ACCTCD,
											DECODE(LENGTH(MAX(ACCTCD)), 6, MAX(CCY), '') AS CCY,
											SUM(ADBAL_VND_DR) AS ADBAL_VND_DR,
											SUM(ADBAL_VND_CR) AS ADBAL_VND_CR,
											SUM(ADBAL_USD_DR) AS ADBAL_USD_DR,
											SUM(ADBAL_USD_CR) AS ADBAL_USD_CR,
											SUM(ADBAL_GD_DR) AS ADBAL_GD_DR,
											SUM(ADBAL_GD_CR) AS ADBAL_GD_CR
									FROM
									(
											SELECT  A.BRCD,
													DECODE(LENGTH(B.ACCTCD), 6, A.BRCD||B.ACCTCD||A.CCY, B.ACCTCD) AS GROUP_COL,
													B.ACCTCD AS ACCTCD,
													A.CCY AS CCY,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_VND), -1, -A.ADBAL_VND, 0),
																					DECODE(SIGN(A.ADBAL_VND), -1, 0, A.ADBAL_VND)
																					)
																) AS ADBAL_VND_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_VND), -1, 0, A.ADBAL_VND),
																					DECODE(SIGN(A.ADBAL_VND), -1, -A.ADBAL_VND, 0)
																					)
																) AS ADBAL_VND_CR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_USD), -1, -A.ADBAL_USD, 0),
																					DECODE(SIGN(A.ADBAL_USD), -1, 0, A.ADBAL_USD)
																					)
																) AS ADBAL_USD_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_USD), -1, 0, A.ADBAL_USD),
																					DECODE(SIGN(A.ADBAL_USD), -1, -A.ADBAL_USD, 0)
																					)
																) AS ADBAL_USD_CR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_GD), -1, -A.ADBAL_GD, 0),
																					DECODE(SIGN(A.ADBAL_GD), -1, 0, A.ADBAL_GD)
																					)
																) AS ADBAL_GD_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL_GD), -1, 0, A.ADBAL_GD),
																					DECODE(SIGN(A.ADBAL_GD), -1, -A.ADBAL_GD, 0)
																					)
																) AS ADBAL_GD_CR
											   FROM
											   (
											   		SELECT	BRCD,ACCODE, CCY,
															GL1.PERIODEXCHANGE_F('1', '1000', 'VND', CCY, '20121103', '20121103', ADBAL) ADBAL_VND,
															DECODE(CCY, 'VND',0,DECODE(SUBSTR(CCY,1,2),'GD',0,CS1.excrosscal('1000', 'VND',  '20121103', CCY, ADBAL, '01', 'USD', '01'))) ADBAL_USD,
															DECODE(SUBSTR(CCY,1,2),'GD',ADBAL,0) ADBAL_GD

													FROM
													(
															SELECT BRCD,ACCODE, CCY, SUM(ADBAL) AS ADBAL
															FROM
															(

																	SELECT	BRCD,ACCTCD ACCODE, CCY,
																			SUM(TDBAL + TDACRBAL) ADBAL
																	FROM  TBGL_MAST
																	WHERE TRDT  = '20121103'
																	AND   ONOFFTP = '1'
																	AND   CUSTSEQ     LIKE '%'
																	AND    (ACCTCD <> '691000'
																	AND ACCTCD  NOT IN ( SELECT DISTINCT ACCTCD
																						FROM GL1.TBGL_SBVCD
																						WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																						)
																			)
																	AND CUSTSEQ IN (SELECT CUSTSEQ
																							FROM CM1.TBCM_GENERAL
																							WHERE CUSTTPCD = '100')
												   					GROUP BY  BRCD,ACCTCD, CCY
															)
											   				GROUP BY  BRCD,ACCODE, CCY
											   				UNION ALL
															SELECT	BRCD,ACCTCD ACCODE, CCY,
																	(TDBAL + TDACRBAL) ADBAL
															FROM  TBGL_MAST
															WHERE TRDT  = '20121103'
															AND   ONOFFTP = '1'
															AND   CUSTSEQ     LIKE '%'
															AND   ACCTCD   IN ( SELECT DISTINCT ACCTCD
																				FROM GL1.TBGL_SBVCD
																				WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																				)
															AND CUSTSEQ IN (SELECT CUSTSEQ
																							FROM CM1.TBCM_GENERAL
																							WHERE CUSTTPCD = '100')
													)
								   			) A,
											TBGL_CACODB B
											WHERE   B.BRCD  =  '1000'
											AND     B.ACCTCD =  A.ACCODE
											GROUP BY A.BRCD,B.ACCTCD, A.CCY
									)
									GROUP BY GROUP_COL

							) A, GL1.TBGL_SBVCD D

							WHERE A.ACCTCD     = D.ACCTCD (+)
							AND NVL(A.CCY, '%') LIKE DECODE(D.BCCYFG,'1','VND'
																						,'3','GD%'
																						,'2',DECODE(A.CCY,'VND','###'
																						,'GD1','###'
																						,'GD2','###'
																						,'GD3','###'
																						,'GD4','###'
																						,'%' )
																						,'%')
					) B
		   		WHERE
				A.RPTCD= 'FU26'
				AND A.FLG='2'
				AND A.LEVEL2 = 'A02000'
				AND A.LEVEL3 IS NULL
		    	AND TRIM(A.ACCTFOUR) = DECODE(SIGN(LENGTH(TRIM(A.ACCTFOUR))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR)))) --TTDTRAM 20110105
				AND NVL(TRIM(A.EXCEPT),'0') <> DECODE(NVL(TRIM(A.EXCEPT),'0'),'0','1',DECODE(SIGN(LENGTH(TRIM(A.EXCEPT))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.EXCEPT))))) --THAO 20080527
				GROUP BY A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,B.BRCD
				ORDER BY A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
	   		) A
		) B, (Select Code code, decode name ,CAT_NAME ,COUNTRY
	        	from RACE.T_CODE
	        	) C
	WHERE	CAT_NAME='GLMISRPTFU35' AND COUNTRY='VN'
			AND (DECODE(NVL(B.LEVEL3,'0'),'0',B.LEVEL2,B.LEVEL3) = C.CODE OR B.LEVEL4 = C.CODE)
	UNION ALL
	SELECT 	A.BRCD,'A03200','1.5 Vµng gi÷ hé' NAME,
			SUM(GL1.PERIODEXCHANGE_F('1', '1000', 'VND', A.CCY, '20121103', '20121103', A.TDBAL + A.TDACRBAL)) DUCUOI,
			SUM(DECODE(CCY, 'VND',0,DECODE(SUBSTR(CCY,1,2),'GD',0,CS1.excrosscal('1000', 'VND',  '20121103', CCY, A.TDBAL + A.TDACRBAL, '01', 'USD', '01')))) ADBAL_USD,
			SUM(DECODE(SUBSTR(CCY,1,2),'GD',A.TDBAL + A.TDACRBAL,0)) ADBAL_GD
	FROM	GL1.TBGL_MAST A, CM1.TBCM_GENERAL B
	WHERE	B.BRCD = '1000'
			AND A.CUSTSEQ =B.CUSTSEQ
			AND B.CUSTTPCD= '100'
			AND A.TRDT  = '20121103'
			AND	A.ACCTCD IN ('462102')
			AND  A.CCY LIKE 'GD%'
	GROUP BY A.BRCD
)G
GROUP BY G.BRCD,G.CODE, G.NAME
ORDER BY G.BRCD,G.CODE, G.NAME
