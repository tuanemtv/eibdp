--DEFINE h_trdt 		= '20120831'
		        SELECT  BRCD, TRDT, BENCUSTSEQ, NM, PAYMENT_CHANNEL,TR_CHANNEL, CCYCD, SUM(CCYAMT) CCYAMT,
		        		SUM(TRAMT) TRAMT, SUM(CNT) CNT, SUM(PHI) PHI
		        FROM
		        (

			        SELECT  BRCD, REFNO, TRDT, BENCUSTSEQ, NM, PAYMENT_CHANNEL,TR_CHANNEL, CCYCD, CCYAMT,
			        SUM(CS1.excrosscal ('1000', 'VND', TRDT, CCYCD, CCYAMT , '01', 'VND', '01')) TRAMT,
			        COUNT(BRCD) CNT,
			        SUM(VNDFEE) PHI
			        FROM
			        (
							SELECT  a.brcd||'-' ||a.trref||'-'||a.trseq refno ,A.BRCD, A.REMTDT TRDT, NVL(A.BENCUSTSEQ,'000000000') BENCUSTSEQ, decode(a.bencustseq,'000000000',A.BENCUST, B.NM) NM,
									DECODE(A.MSGKDCD,'IO','Trong He Thong','Ngoai He Thong') PAYMENT_CHANNEL,
									DECODE(A.MSGKDCD,'IO','IO', 'Khac')  TR_CHANNEL,
									A.TRACCY CCYCD, A.TRAAMT CCYAMT,
									SUM(CS1.excrosscal ('1000', 'VND', A.REMTDT, NVL(C.COMMCCYCD,'VND'), NVL(C.COMMAMT,0) , '01', 'VND', '01')) VNDFEE,
									a.remark

							from LR1.TBLR_RRMASTER A, CM1.TBCM_GENERAL B, LR1.TBLR_RRCOMM C
							WHERE 	A.REMTDT = &h_trdt
							AND 	A.CMPLFLG = 'Y'
							 AND  A.MSGKDCD in ('IB','CH','TT','VC','PC')
							AND 	A.BRCD 		 = 	B.BRCD  (+)
							AND 	NVL(A.BENCUSTSEQ,'000000000') = 	B.CUSTSEQ (+)
							AND		A.BRCD = C.BRCD(+)
							AND		A.TRREF = C.TRREF(+)
							AND 	A.TRSEQ = C.TRSEQ(+)
							AND		B.CUSTTPCD = '100'
							GROUP BY A.BRCD,A.REMTDT, B.NM, A.BENCUSTSEQ,A.BENCUST ,A.MSGKDCD, A.TRACCY, A.TRAAMT, a.brcd, a.trref, a.trseq, a.remark
				)
				GROUP BY BRCD, TRDT, BENCUSTSEQ, NM, PAYMENT_CHANNEL,TR_CHANNEL, CCYCD, CCYAMT, refno, remark
			 )
			 GROUP BY BRCD, TRDT, BENCUSTSEQ, NM, PAYMENT_CHANNEL,TR_CHANNEL, CCYCD

