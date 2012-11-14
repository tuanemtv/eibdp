--DEFINE h_trdt = '20090625'
--DEFINE h_startdt = '20090631'
--DEFINE h_enddt = '20090530'
SELECT  LCLBRNM,  Nhom1,Nhom2,Nhom3,Nhom4,Nhom5,DU_NO,TONGNQH,NQH,NPL
    FROM
	    (
	 			SELECT LCLBRNM,SUM(bal4) Nhom1,SUM(BAL)Nhom2 ,SUM(BAL1) Nhom3 ,SUM(BAL2) Nhom4 , SUM(BAL3) Nhom5,
					SUM(BAL+BAL1+BAL2+BAL3+BAL4) DU_NO,
					SUM(BAL+BAL1+BAL2+BAL3) TONGNQH , ROUND((SUM(BAL+BAL1+BAL2+BAL3)/SUM(BAL+BAL1+BAL2+BAL3+BAL4)) *100,2) NQH,
					ROUND((SUM(BAL1+BAL2+BAL3)/SUM(BAL+BAL1+BAL2+BAL3+BAL4))*100,2) NPL
	FROM
				(
					SELECT BRCD ,
								SUM(DECODE(E.LEVEL2,'B00001',TDBAL,0)) BAL,
								SUM(DECODE(E.LEVEL2,'B00002',TDBAL,0)) BAL1,
								SUM(DECODE(E.LEVEL2,'B00003',TDBAL,0)) BAL2,
								SUM(DECODE(E.LEVEL2,'B00004',TDBAL,0)) BAL3,
								SUM(DECODE(E.LEVEL2,'B00005',tdbal,0)) BAL4
					FROM
					(
					SELECT  C.BRCD,SUM(C.TDBAL) TDBAL ,LEVEL2
					FROM
					(
						SELECT  G.TRDT,   G.BRCD BRCD,
											G.ACCTCD ACCTCD,G.CCY,
											SUM(DECODE(G.CCY, 'VND',G.TDBAL, GL1.PERIODEXCHANGE_F('1', G.BRCD, 'VND', G.CCY,  &h_enddt,  &h_enddt, G.TDBAL)
						)) TDBAL
					FROM
					(
						SELECT  A.TRDT,  A.BRCD BRCD,
										A.CCY CCY,  A.ACCTCD ACCTCD,
										SUM( A.TDBAL + A.TDACRBAL) TDBAL
						FROM 	 GL1.TBGL_MAST A, GL1.TBGL_CACODB  B
						WHERE
										A.TRDT LIKE &h_enddt
	--									AND	A.BRCD  IN  (SELECT BRCD
	--														FROM   TBCS_BRCD
	--														START WITH BRCD LIKE h_tbgl_mast_brcd
	--														CONNECT BY PRIOR BRCD = UPPERBRCD)
										AND    	B.BRCD =  A.BRCD
										AND    	B.ACCTCD =  A.ACCTCD
										AND    	B.ACCTCD LIKE  '2%'
										AND		A.TDBAL+A.TDACRBAL <> 0
										AND    	A.ONOFFTP LIKE '1'
							GROUP   BY A.TRDT, A.BRCD, A.CCY, A.ACCTCD
						 ) G
				 GROUP BY  G.TRDT, G.BRCD, G.ACCTCD,G.CCY

				) C, GL1.TBGL_RPTAC D, GL1.tbgl_sbvcd E
				WHERE
						D.BRCD ='1000'
						AND D.RPTCD= 'QH01'
						And C.acctcd=E.acctcd
						AND E.bccyfg=decode(c.ccy,'VND','1','GD1','3','GD2','3','GD3','3','GD4','3','2')
						AND E.sbvcd=d.acctfour
				GROUP BY C.BRCD,LEVEL1,LEVEL2
				ORDER BY LEVEL1,LEVEL2
				) E
			GROUP BY BRCD
		) A,CS1.TBCS_BRCD B
		WHERE A.BRCD =B.BRCD
		GROUP BY  LCLBRNM
)
	GROUP BY  LCLBRNM,  Nhom1,Nhom2,Nhom3,Nhom4,Nhom5,DU_NO,TONGNQH,NQH,NPL
