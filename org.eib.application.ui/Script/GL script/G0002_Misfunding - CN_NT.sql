--define h_trdt='20121107'


SELECT	G.BRCD CHINHANH,G.CCY,G.CODE , G.NAME,
		DECODE(G.CODE,'A03100',SUM(G.DUCUOI)-
		NVL((SELECT	SUM(A.TDBAL + A.TDACRBAL) DUCUOI
		FROM   	GL1.TBGL_MAST A, CM1.TBCM_GENERAL B,GL1.TBGL_SBVCD C
		WHERE	A.TRDT  = &h_trdt
				AND	B.BRCD= '1000'
				AND A.CUSTSEQ = B.CUSTSEQ
			   	AND B.CUSTTPCD = '600'
				AND A.ACCTCD =C.ACCTCD
				AND SUBSTR(C.SBVCD,1,2)= '43'
				AND A.CCY =G.CCY
				AND A.BRCD =G.BRCD
				AND NVL(A.CCY, '%') LIKE DECODE(C.BCCYFG,'1','VND'
												    ,'3','GD%'
													,'2',DECODE(A.CCY,'VND','###'
													                 ,'GD1','###'
																     ,'GD2','###'
																     ,'GD3','###'
																     ,'GD4','###'
																     ,'%' ),'%')
		),0),SUM(G.DUCUOI))	DUCUOI_NT
FROM
(
	SELECT B.BRCD,B.CCY,C.CODE , C.NAME, B.DUCUOI
	FROM
	(
			SELECT	A.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,A.CCY,
					DECODE(A.CONDITION,	'DN'	, A.DCN,
										'DC'	, A.DCC,
										'-DC'	, -A.DCC,
										'CLDC'	, DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN)) DUCUOI

			FROM
			(
					SELECT	B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4, A.CONDITION, A.EXCEPT,B.CCY,
						 	SUM(B.DCN) DCN, SUM(B.DCC) DCC
					FROM gl1.TBGL_RPTAC_NEW A,
					(
							SELECT
												A.BRCD,A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,CCY,
												ROUND(ADBAL_DR,0) DCN,
												ROUND(ADBAL_CR,0) DCC
							FROM
							(
									SELECT	MAX(BRCD) AS BRCD,
											MAX(ACCTCD) AS ACCTCD,
											DECODE(LENGTH(MAX(ACCTCD)), 6, MAX(CCY), '') AS CCY,

											SUM(ADBAL_DR) AS ADBAL_DR,
											SUM(ADBAL_CR) AS ADBAL_CR
									FROM
									(
											SELECT	A.BRCD,
													DECODE(LENGTH(B.ACCTCD), 6, A.BRCD||B.ACCTCD||A.CCY, B.ACCTCD) AS GROUP_COL,
													B.ACCTCD AS ACCTCD,
													A.CCY AS CCY,

													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL), -1, -A.ADBAL, 0),
																					DECODE(SIGN(A.ADBAL), -1, 0, A.ADBAL)
																					)
																) AS ADBAL_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL), -1, 0, A.ADBAL),
																					DECODE(SIGN(A.ADBAL), -1, -A.ADBAL, 0)
																					)
																) AS ADBAL_CR
											   FROM
											   (
											   		SELECT	BRCD,ACCODE, CCY,ADBAL

													FROM
													(
															SELECT BRCD,ACCODE, CCY, SUM(ADBAL) ADBAL
															FROM
															(

																	SELECT	BRCD,ACCTCD ACCODE, CCY,
																			SUM(TDBAL + TDACRBAL)ADBAL
																	FROM  TBGL_MAST
																	WHERE TRDT  = &h_trdt
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
															WHERE TRDT  = &h_trdt
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
				GROUP BY B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,B.CCY
				ORDER BY A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
	   		) A
	   		UNION ALL
	   		SELECT	A.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,A.CCY,
					DECODE(A.CONDITION,	'DN'	, A.DCN,
										'DC'	, A.DCC,
										'-DC'	, -A.DCC,
										'CLDC'	, DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN)) DUCUOI
			FROM
			(
					SELECT	B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4, A.CONDITION, A.EXCEPT,B.CCY,
						 	SUM(B.DCN) DCN, SUM(B.DCC) DCC
					FROM	GL1.TBGL_RPTAC_NEW A,
					(
							SELECT
												A.BRCD,A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,CCY,
												ROUND(ADBAL_DR,0) DCN,
												ROUND(ADBAL_CR,0) DCC
							FROM
							(
									SELECT	MAX(BRCD) AS BRCD,
											MAX(ACCTCD) AS ACCTCD,
											DECODE(LENGTH(MAX(ACCTCD)), 6, MAX(CCY), '') AS CCY,

											SUM(ADBAL_DR) AS ADBAL_DR,
											SUM(ADBAL_CR) AS ADBAL_CR
									FROM
									(
											SELECT  A.BRCD,
													DECODE(LENGTH(B.ACCTCD), 6, A.BRCD||B.ACCTCD||A.CCY, B.ACCTCD) AS GROUP_COL,
													B.ACCTCD AS ACCTCD,
													A.CCY AS CCY,

													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL), -1, -A.ADBAL, 0),
																					DECODE(SIGN(A.ADBAL), -1, 0, A.ADBAL)
																					)
																) AS ADBAL_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL), -1, 0, A.ADBAL),
																					DECODE(SIGN(A.ADBAL), -1, -A.ADBAL, 0)
																					)
																) AS ADBAL_CR
											   FROM
											   (
											   		SELECT	BRCD,ACCODE, CCY,ADBAL
													FROM
													(
															SELECT BRCD,ACCODE, CCY, SUM(ADBAL) AS ADBAL
															FROM
															(

																	SELECT	BRCD,ACCTCD ACCODE, CCY,
																			SUM(TDBAL + TDACRBAL) ADBAL
																	FROM  TBGL_MAST
																	WHERE TRDT  = &h_trdt
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
															WHERE TRDT  = &h_trdt
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
				GROUP BY B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,B.CCY
				ORDER BY A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
	   		) A
	   		UNION ALL
	   		SELECT	A.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,A.CCY,
					DECODE(A.CONDITION,	'DN'	, A.DCN,
								    	'DC'	, A.DCC,
									    '-DC'	, -A.DCC,
										'CLDC'	, DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN)) DUCUOI


			FROM
			(
					SELECT 	B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4, A.CONDITION, A.EXCEPT,B.CCY,
						 SUM(B.DCN) DCN, SUM(B.DCC) DCC

					FROM gl1.TBGL_RPTAC_NEW A,
					(
							SELECT
												A.BRCD,A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,CCY,
												ROUND(ADBAL_DR,0) DCN,
												ROUND(ADBAL_CR,0) DCC
							FROM
							(
									SELECT  MAX(BRCD) AS BRCD,
											MAX(ACCTCD) AS ACCTCD,
											DECODE(LENGTH(MAX(ACCTCD)), 6, MAX(CCY), '') AS CCY,
											SUM(ADBAL_DR) AS ADBAL_DR,
											SUM(ADBAL_CR) AS ADBAL_CR
									FROM
									(
											SELECT  A.BRCD,
													DECODE(LENGTH(B.ACCTCD), 6, A.BRCD||B.ACCTCD||A.CCY, B.ACCTCD) AS GROUP_COL,
													B.ACCTCD AS ACCTCD,
													A.CCY AS CCY,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL), -1, -A.ADBAL, 0),
																					DECODE(SIGN(A.ADBAL), -1, 0, A.ADBAL)
																					)
																) AS ADBAL_DR,
													SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.ADBAL), -1, 0, A.ADBAL),
																					DECODE(SIGN(A.ADBAL), -1, -A.ADBAL, 0)
																					)
																) AS ADBAL_CR
											   FROM
											   (
											   		SELECT	BRCD,ACCODE, CCY,ADBAL

													FROM
													(
															SELECT BRCD,ACCODE, CCY, SUM(ADBAL) AS ADBAL
															FROM
															(

																	SELECT	BRCD,ACCTCD ACCODE, CCY,
																			SUM(TDBAL + TDACRBAL) ADBAL
																	FROM  TBGL_MAST
																	WHERE TRDT  = &h_trdt
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
															WHERE TRDT  = &h_trdt
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
				GROUP BY B.BRCD,A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT,B.CCY
				ORDER BY A.ACCTFOUR, A.LEVEL1, A.LEVEL2, A.LEVEL3,A.LEVEL4,A.CONDITION, A.EXCEPT
	   		) A
		) B, (Select Code code, decode name ,CAT_NAME ,COUNTRY
	        	from RACE.T_CODE
	        	) C
	WHERE	CAT_NAME='GLMISRPTFU35' AND COUNTRY='VN'
			AND (DECODE(NVL(B.LEVEL3,'0'),'0',B.LEVEL2,B.LEVEL3) = C.CODE OR B.LEVEL4 = C.CODE)
	UNION ALL
	SELECT	A.BRCD,CCY,'A03200','1.5 Vµng gi÷ hé' NAME,
			SUM(A.TDBAL + A.TDACRBAL) DUCUOI
	FROM	GL1.TBGL_MAST A, CM1.TBCM_GENERAL B
	WHERE	B.BRCD = '1000'
			AND A.CUSTSEQ =B.CUSTSEQ
			AND B.CUSTTPCD= '100'
			AND A.TRDT  = &h_trdt
			AND	A.ACCTCD IN ('462102')
			AND  A.CCY LIKE 'GD%'
	GROUP BY A.BRCD,CCY
)G
WHERE G.CCY IN ('VND','USD','GD1','GD','AUD','EUR')
GROUP BY G.BRCD,G.CCY,G.CODE, G.NAME
ORDER BY G.BRCD,G.CCY,G.CODE, G.NAME
