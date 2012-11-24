--DEFINE h_trdt = '20120831'

SELECT BRCD, FSTTRDT, CUSTSEQ, NM, CHANNEL, TR_CHANNEL, TRACCY,
	  SUM(TRAAMT) TRAMT, SUM(VNDAMT) VNDAMT, COUNT(BRCD) CNT,
	  SUM(VNDFEE) VNDFEE
FROM
(
		SELECT 	A.BRCD, A.FSTTRDT,A.CUSTSEQ,
				decode(a.custseq,'000000000',a.ordcust,C.NM) nm,
				A.CHANNEL, A.TR_CHANNEL,
				A.TRACCY, A.TRAAMT, A.VNDAMT,
			 	SUM(CS1.excrosscal ('1000', 'VND', A.FSTTRDT, NVL(A.TRACCY,'VND'), NVL(b.AMOUNT,0) , '01', 'VND', '01')) VNDFEE
		FROM
		(
					SELECT A.BRCD, A.TRREF, A.TRSEQ, A.FSTTRDT,
															DECODE(A.CUSTNO, '000000000',
																			NVL(SUBSTR(trim(B.ORDCUSTSEQ),6,9),'000000000'),
																			 A.CUSTNO) CUSTSEQ,
						DECODE(A.MSGKDCD,'IO','TRONG HE HONG', ' NGOAI HE THONG') CHANNEL,
						DECODE(A.TRAN_KIND,	'7','Internet Banking',	'6', 'Mobile Banking','Khac' ) TR_CHANNEL,
						 A.TRACCY, A.TRAAMT, A.VNDAMT  , a.ordcust
					FROM
					(
					SELECT  BRCD, TRREF, TRSEQ, SUBSTR(TRIM(A.REFNO),1,4) BRCD1,
							SUBSTR(TRIM(A.REFNO),6,3) TRREF1, SUBSTR(TRIM(A.REFNO),10,9) TRSEQ1,
							A.FSTTRDT,A.CUSTNO, A.MSGKDCD , a.ordcust,
							A.TRAN_KIND, TRACCY, TRAAMT,
							CS1.excrosscal ('1000', 'VND', A.FSTTRDT, A.TRACCY, NVL(A.TRAAMT,0) , '01', 'VND', '01') VNDAMT

					FROM LR1.TBLR_SRMASTER A
					WHERE 	A.FSTTRDT = &h_trdt
					AND 	A.OPENFLG = '1'
					AND		A.MSGKDCD in ('IB','CH','TT','VC','PC')

					) A ,
													( 	SELECT B.BRCD, B.TRREF, B.TRSEQ, B.ORDCUSTSEQ , B.OBRCD -- nhung giao dich la chuyen tiep den phong giao dich - de lay cif
													FROM LR1.TBLR_RRMASTER B
													WHERE B.VALDATE = &h_trdt
													AND B.CMPLFLG = 'Y'
													AND B.BRCD = B.OBRCD
													AND B.MSGKDCD = 'IO'
													)  B
					WHERE A.BRCD1 =TRIM(B.BRCD(+))
					AND A.TRREF1 = TRIM(B.TRREF(+))
					AND A.TRSEQ1 = TRIM(B.TRSEQ(+))

		        ) A,
		        LR1.TBLR_SRACTDTL B,
		        CM1.TBCM_GENERAL C
		WHERE  	A.BRCD = C.BRCD  (+)
		AND 	A.CUSTSEQ = C.CUSTSEQ (+)
		AND 	C.CUSTTPCD = '100'
		AND		A.BRCD = B.BRCD(+)
		AND		A.TRREF = B.TRREF(+)
		AND 	A.TRSEQ = B.TRSEQ(+)
		AND     B.ACCTKD(+)   = '05'
		GROUP BY  A.BRCD, A.FSTTRDT,A.CUSTSEQ, C.NM, A.CHANNEL, A.TR_CHANNEL,
				A.TRACCY, A.TRAAMT, A.VNDAMT , A.BRCD, A.TRREF, A.TRSEQ, ordcust


UNION ALL


		SELECT A.BRCD, A.FSTTRDT,A.CUSTSEQ, decode(a.custseq,'000000000',a.ordcust,C.NM) nm, A.CHANNEL, A.TR_CHANNEL,
				A.TRACCY, A.TRAAMT, A.VNDAMT,
			 	SUM(CS1.excrosscal ('1000', 'VND', A.FSTTRDT, NVL(A.TRACCY,'VND'), NVL(b.AMOUNT,0) , '01', 'VND', '01')) VNDFEE
		FROM
		(
					SELECT BRCD, TRREF, TRSEQ, FSTTRDT, CUSTNO CUSTSEQ,
						DECODE(MSGKDCD,'IO','TRONG HE HONG', ' NGOAI HE THONG') CHANNEL,
						DECODE(TRAN_KIND,	'7','Internet Banking',	'6', 'Mobile Banking','Khac' ) TR_CHANNEL,
						 TRACCY, TRAAMT, VNDAMT  , ordcust
					FROM
					(
					SELECT  BRCD, TRREF, TRSEQ, SUBSTR(TRIM(A.REFNO),1,4) BRCD1,
							SUBSTR(TRIM(A.REFNO),6,3) TRREF1, SUBSTR(TRIM(A.REFNO),10,9) TRSEQ1,
							A.FSTTRDT,A.CUSTNO, A.MSGKDCD , a.ordcust,
							A.TRAN_KIND, TRACCY, TRAAMT,
							CS1.excrosscal ('1000', 'VND', A.FSTTRDT, A.TRACCY, NVL(A.TRAAMT,0) , '01', 'VND', '01') VNDAMT

					FROM LR1.TBLR_SRMASTER A
					WHERE	A.FSTTRDT = &h_trdt
					AND 	A.OPENFLG = '1'
					AND		  A.MSGKDCD = 'IO'
					AND A.BRCD <> '1000'
					and a.RCVBRCD <> '1000'
					AND (A.BRCD, A.TRREF, A.TRSEQ) NOT IN ( SELECT D.BRCD, D.TRREF, D.TRSEQ
															FROM LR1.TBLR_SRMASTER D
															WHERE A.BRCD = D.BRCD
															AND   A.TRREF = D.TRREF
															AND   A.TRSEQ = D.TRSEQ
															AND  D.MSGKDCD = 'IO'
															AND  D.BRCD = D.RCVBRCD
															AND D.FSTTRDT = &h_trdt
															AND D.OPENFLG = '1'
															)


					)
		        ) A,
		        LR1.TBLR_SRACTDTL B,
		        CM1.TBCM_GENERAL C
		WHERE  	A.BRCD = C.BRCD  (+)
		AND 	A.CUSTSEQ = C.CUSTSEQ (+)
		AND 	C.CUSTTPCD = '100'
		AND		A.BRCD = B.BRCD(+)
		AND		A.TRREF = B.TRREF(+)
		AND 	A.TRSEQ = B.TRSEQ(+)
		AND     B.ACCTKD(+)   = '05'
		GROUP BY  A.BRCD, A.FSTTRDT,A.CUSTSEQ, C.NM, A.CHANNEL, A.TR_CHANNEL,
				A.TRACCY, A.TRAAMT, A.VNDAMT , A.BRCD, A.TRREF, A.TRSEQ, ordcust
	)
GROUP BY BRCD, FSTTRDT,CUSTSEQ,NM, CHANNEL,TR_CHANNEL, TRACCY









