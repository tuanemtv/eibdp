--define h_trdt = '20120204' --20120206

SELECT
				MA_CN, 				deptcd,
				TEN_CN,
				CIF_GIAODICH,
				CIF_SL,
				HUY_DONG,
				CHO_VAY,
				THE1,
				TTQT
FROM
(
		SELECT
						A.BRCD				MA_CN,
----							A.LCLBRNM    TEN_CN,
						A.CIF_GIAODICH,
						B.CIF_SL,
						C.HUY_DONG,
							D.CHO_VAY,
							T.THE1,
							X.TTQT,
							Y.LCLBRNM TEN_CN, Y.DEPTCD
			FROM
			(
				SELECT BRCD, DEPTCD, BRNM LCLBRNM, --CUSTSEQ CIF_GIAODICH --
								  COUNT(CUSTSEQ) CIF_GIAODICH
				FROM
				(
					select
								GEN.BRCD, gen.DEPTCD, dep.DEPTNMLOC brnm ,	gen.CUSTSEQ
					from
								CM1.TBCM_GENERAL GEN,  TBCS_DEPTCD dep, --CS1.TBCS_BRCD C,
								 (	SELECT  BRCD, DPTPCD, ACCTSEQ, custseq, ACCTNO,
												DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
															'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
															'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
															'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
															'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
																	DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
										FROM TBDP_IDXACCT
										WHERE BRCD LIKE ''||'%'
									) idx
					where
											GEN.BRCD like ''||'%'
								and 		GEN.brcd <>'1000'
								AND 	GEN.STSCD ='01'
								AND 	GEN.regdt <=&h_trdt
								AND 	GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
								AND 	GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
				--				AND	GEN.BRCD = C.BRCD
								and 		gen.brcd = idx.brcd and gen.custseq  = idx.custseq          and gen.deptcd = idx.deptcd
								AND idx.DEPTCD like '' || '%'
								AND idx.DEPTCD = dep.DEPTCD
								AND DECODE(dep.BRCD,'','1000','1000','1000',dep.BRCD) <>'1000'
--							    AND gen.custseq =:cif
					union all
					select
								GEN.BRCD ,          ' '   deptcd,  C.LCLBRNM			brnm,	gen.CUSTSEQ	 --, idx.deptcd
					from
								CM1.TBCM_GENERAL GEN, CS1.TBCS_BRCD C --, dp1.TBDP_IDXACCT idx
					where
											GEN.BRCD like ''||'%'
								and 		GEN.brcd <>'1000'
								AND 	GEN.STSCD ='01'
								AND 	GEN.regdt <=&h_trdt
								AND 	GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
								AND 	GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
								AND	GEN.BRCD = C.BRCD
	--							and gen.brcd = idx.brcd and gen.custseq  = idx.custseq
	--				GROUP BY 	GEN.brcd, C.LCLBRNM--, idx.deptcd
					)
					GROUP BY BRCD, DEPTCD,	 BRNM
			)A	, --CIF_GIAODICH
			(
				SELECT 	BRCD, deptcd, LCLBRNM,	--CIF_SL --
									SUM(CIF_SL) CIF_SL
				FROM
				(
					SELECT
							A.BRCD, a.deptcd, a.brnm LCLBRNM, A.CUSTTPCD,
							DECODE(A.CUSTTYPE, 1, 'Khach hang vay', 2, 'Khach hang gui', 3, 'Khach hang vua vay, vua gui', 'Hong biet'), --A.CUSTTYPE,
				--			C.LCLBRNM,
							COUNT(A.CUSTTPCD) CIF_SL
--							CUSTSEQ CIF_SL
					from
					(
							SELECT
								BRCD, deptcd,brnm, 	CUSTSEQ,	CUSTTPCD,	SUM(CUSTTYPE) CUSTTYPE
							FROM
							(
									SELECT
											DISTINCT BRCD, DEPTCD, BRNM,CUSTSEQ,
											DECODE(SUBSTR(SHRTNM, 1, 3), 'CS ', 'CA NHAN',
											DECODE(SUBSTR(SHRTNM, 1, 5), 'COSO ', 'CA NHAN',
											DECODE(SUBSTR(SHRTNM, 1, 6), 'CO SO ', 'CA NHAN', DECODE(CUSTTPCD, '100', 'CA NHAN', 'DOANH NGHIEP')))) CUSTTPCD,
											1 CUSTTYPE
									FROM
									(
										SELECT MAS.BRCD, IDX.DEPTCD, dep.DEPTNMLOC brnm , MAS.CUSTSEQ, GEN.CUSTTPCD, GEN.SHRTNM
										FROM
													 GL1.TBGL_MAST MAS, CM1.TBCM_GENERAL GEN      , TBCS_DEPTCD dep,
													 (	SELECT  BRCD, DPTPCD, ACCTSEQ, CUSTSEQ, ACCTNO,
																	DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
																								'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
																								'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
																								'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
																								'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
																								DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
															FROM TBDP_IDXACCT
															WHERE BRCD LIKE ''||'%'
														) idx
										WHERE
													  MAS.TRDT = &h_trdt
											AND MAS.BRCD LIKE ''||'%'
											AND MAS.BRCD = GEN.BRCD
											AND MAS.CUSTSEQ = GEN.CUSTSEQ
											AND MAS.ACCTCD LIKE '2%'
											AND SUBSTR(MAS.ACCTCD, 3, 1) NOT IN ('7', '9')
					--//									AND MAS.TDBAL >= 0//nttquyen 20090721 npa rem 05-01-2012 chi lay so du>0
											AND MAS.TDBAL > 0
											AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
											AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
											and   mas.brcd = idx.brcd and mas.custseq = idx.custseq  --  and gen.deptcd = idx.deptcd
											AND idx.DEPTCD like '' || '%'
											AND idx.DEPTCD = dep.DEPTCD
											AND DECODE(dep.BRCD,'','1000','1000','1000',dep.BRCD) <>'1000'
										UNION ALL
				--						SELECT MAS.BRCD,  ' ' DEPTCD, br.LCLBRNM brnm, MAS.CUSTSEQ,  GEN.CUSTTPCD, GEN.SHRTNM
				--						FROM
				--									 GL1.TBGL_MAST MAS, CM1.TBCM_GENERAL GEN      , TBCS_DEPTCD dep,    TBCS_BRCD br,
				--									(	SELECT  BRCD, DPTPCD, ACCTSEQ, CUSTSEQ, ACCTNO,
				--															DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','ACC',TRIM(DEPTCD)),
				--															'2102', DECODE(TRIM(DEPTCD),'T1O','ACC',TRIM(DEPTCD)),
				--															'1403', DECODE(TRIM(DEPTCD),'MHO','ACC',TRIM(DEPTCD)),
				--															'1004', DECODE(TRIM(DEPTCD),'VHO','ACC',TRIM(DEPTCD)),
				--															'1400', DECODE(TRIM(DEPTCD),'LNO','ACC','TDO','ACC','VVO','ACC',TRIM(DEPTCD)),
				--															DECODE(TRIM(DEPTCD),'','ACC',TRIM(DEPTCD))) DEPTCD
				--										FROM TBDP_IDXACCT
				--										WHERE BRCD LIKE ''||'%'
				--										AND   DEPTCD like '' || '%'
				--									) idx
				--						WHERE
				--									  MAS.TRDT = &h_trdt
				--							AND MAS.BRCD LIKE ''||'%'
				--							AND MAS.BRCD = GEN.BRCD
				--							AND MAS.CUSTSEQ = GEN.CUSTSEQ
				--							AND MAS.ACCTCD LIKE '2%'
				--							AND SUBSTR(MAS.ACCTCD, 3, 1) NOT IN ('7', '9')
				--	--//									AND MAS.TDBAL >= 0//nttquyen 20090721 npa rem 05-01-2012 chi lay so du>0
				--							AND MAS.TDBAL > 0
				--							AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
				--							AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
				--							and   mas.brcd = idx.brcd and mas.custseq = idx.custseq  --  and gen.deptcd = idx.deptcd
				--							AND MAS.BRCD = br.BRCD
				--							AND idx.DEPTCD like '' || '%'
				--							AND idx.DEPTCD = dep.DEPTCD(+)
				--							AND DECODE(dep.BRCD,'','1000','1000','1000')='1000'
										SELECT MAS.BRCD,  ' ' DEPTCD, br.LCLBRNM brnm, MAS.CUSTSEQ,  GEN.CUSTTPCD, GEN.SHRTNM
										FROM  GL1.TBGL_MAST MAS, CM1.TBCM_GENERAL GEN ,  TBCS_BRCD br
										WHERE
													  MAS.TRDT = &h_trdt
											AND MAS.BRCD LIKE ''||'%'
											AND MAS.BRCD = GEN.BRCD
											AND MAS.CUSTSEQ = GEN.CUSTSEQ
											AND MAS.ACCTCD LIKE '2%'
											AND SUBSTR(MAS.ACCTCD, 3, 1) NOT IN ('7', '9')
				----									AND MAS.TDBAL >= 0--nttquyen 20090721 npa rem 05-01-2012 chi lay so du>0
											AND MAS.TDBAL > 0
											AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
											AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
											AND MAS.BRCD = br.BRCD
									)

									UNION ALL

									SELECT
										DISTINCT
											DECODE(SIGN(TO_DATE(&h_trdt, 'YYYYMMDD') - TO_DATE('20070806', 'YYYYMMDD')), 1, BRCD, DECODE(BRCD, '2000', '1000', BRCD)) BRCD,
											deptcd, brnm, CUSTSEQ,
											DECODE(SUBSTR(SHRTNM, 1, 3), 'CS ', 'CA NHAN',
											DECODE(SUBSTR(SHRTNM, 1, 5), 'COSO ', 'CA NHAN',
											DECODE(SUBSTR(SHRTNM, 1, 6), 'CO SO ', 'CA NHAN', DECODE(CUSTTPCD, '100', 'CA NHAN', 'DOANH NGHIEP')))) CUSTTPCD,
											2 CUSTTYPE
									FROM
									(
										--*********************** DMDMST***********************
										select brcd, deptcd, brnm, custseq, custtpcd, SHRTNM
										from
										(
											SELECT
													MST.BRCD, idx.DEPTCD, dep.DEPTNMLOC brnm , MST.CUSTSEQ, GEN.CUSTTPCD, GEN.SHRTNM
											FROM DP1.TBDP_DMDMST MST, CM1.TBCM_GENERAL GEN,  TBCS_DEPTCD dep,
																		(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
																					DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
																								'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
																								'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
																								'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
																								'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
																										DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
																			FROM TBDP_IDXACCT
																			WHERE BRCD LIKE ''||'%'
																		) idx
											WHERE
													  MST.BRCD LIKE ''||'%'
											AND MST.BRCD = GEN.BRCD
											AND MST.CUSTSEQ = GEN.CUSTSEQ
											AND MST.OPNCNCLFLG = '0'
											AND MST.OPNDT <= &h_trdt
											and nvl(trim(MST.clsdt),'99999999')>&h_trdt
											AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
											AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
											AND idx.DEPTCD like '' || '%'
											AND idx.DEPTCD = dep.DEPTCD
											AND DECODE(dep.BRCD,'','1000','1000','1000',dep.BRCD) <>'1000'
											AND mst.BRCD = idx.BRCD
											AND mst.dptpcd = idx.DPTPCD
											AND mst.acctseQ = idx.ACCTSEQ
											union all
				--							SELECT
				--									MST.BRCD, ' ' DEPTCD, br.LCLBRNM brnm, MST.CUSTSEQ,
				--									GEN.CUSTTPCD, GEN.SHRTNM
				--							FROM DP1.TBDP_DMDMST MST, CM1.TBCM_GENERAL GEN,  TBCS_DEPTCD dep, TBCS_BRCD br,
				--														(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
				--																				DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','ACC',TRIM(DEPTCD)),
				--																				'2102', DECODE(TRIM(DEPTCD),'T1O','ACC',TRIM(DEPTCD)),
				--																				'1403', DECODE(TRIM(DEPTCD),'MHO','ACC',TRIM(DEPTCD)),
				--																				'1004', DECODE(TRIM(DEPTCD),'VHO','ACC',TRIM(DEPTCD)),
				--																				'1400', DECODE(TRIM(DEPTCD),'LNO','ACC','TDO','ACC','VVO','ACC',TRIM(DEPTCD)),
				--																				DECODE(TRIM(DEPTCD),'','ACC',TRIM(DEPTCD))) DEPTCD
				--															FROM TBDP_IDXACCT
				--															WHERE BRCD LIKE ''||'%'
				--															AND   DEPTCD like '' || '%'
				--														) idx
				--							WHERE
				--									  MST.BRCD LIKE ''||'%'
				--							AND MST.BRCD = GEN.BRCD
				--							AND MST.CUSTSEQ = GEN.CUSTSEQ
				--							AND MST.OPNCNCLFLG = '0'
				--							AND MST.OPNDT <= &h_trdt
				--							and nvl(trim(MST.clsdt),'99999999')>&h_trdt
				--							AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
				--							AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
				--							AND mst.BRCD = br.BRCD
				--							AND idx.DEPTCD like '' || '%'
				--							AND idx.DEPTCD = dep.DEPTCD(+)
				--							AND DECODE(dep.BRCD,'','1000','1000','1000')='1000'
				--							AND mst.BRCD = idx.BRCD
				--							AND mst.dptpcd = idx.DPTPCD
				--							AND mst.acctseQ = idx.ACCTSEQ
											SELECT
													MST.BRCD, ' ' DEPTCD, br.LCLBRNM brnm, MST.CUSTSEQ,
													GEN.CUSTTPCD, GEN.SHRTNM
											FROM DP1.TBDP_DMDMST MST, CM1.TBCM_GENERAL GEN, TBCS_BRCD br
											WHERE
														  MST.BRCD LIKE ''||'%'
												AND MST.BRCD = GEN.BRCD
												AND MST.CUSTSEQ = GEN.CUSTSEQ
												AND MST.OPNCNCLFLG = '0'
												AND MST.OPNDT <= &h_trdt
												----AND ((MST.CLSFLG = '0') OR ((MST.CLSFLG = '1')AND(MST.CLSDT > &h_trdt)))
												and nvl(trim(MST.clsdt),'99999999')>&h_trdt
												AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
												AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
												AND mst.BRCD = br.BRCD
										)
										union all
										--*********************** SAVMST***********************
										select brcd, deptcd, brnm, custseq, custtpcd, SHRTNM
										from
										(
											SELECT --//+ INDEX (MST IXDP_SAVMST_T02)
														 MST.BRCD,  idx.DEPTCD, dep.DEPTNMLOC brnm , MST.CUSTSEQ,	 GEN.CUSTTPCD, GEN.SHRTNM
											FROM DP1.TBDP_SAVMST MST, CM1.TBCM_GENERAL GEN, TBCS_DEPTCD dep,
																		(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
																					DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
																								'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
																								'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
																								'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
																								'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
																										DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
																			FROM TBDP_IDXACCT
																			WHERE BRCD LIKE ''||'%'
																		) idx,
																		(
																			SELECT --//+ INDEX (TBDP_SCLRBAL PKDP_SCLRBAL)
																						BRCD, DPTPCD, ACCTSEQ, MIN(CLRDT) CLRDT
																			FROM DP1.TBDP_SCLRBAL
																			WHERE BRCD LIKE ''||'%'
																			GROUP BY BRCD, DPTPCD, ACCTSEQ
																		) BAL
											WHERE
													  MST.BRCD LIKE ''||'%'
											AND MST.BRCD = GEN.BRCD
											AND MST.CUSTSEQ = GEN.CUSTSEQ
											AND MST.OPNCNCLFLG = '0'
											AND MST.BRCD = BAL.BRCD
											AND MST.DPTPCD = BAL.DPTPCD
											AND MST.ACCTSEQ = BAL.ACCTSEQ
											AND BAL.CLRDT <= &h_trdt
											and nvl(trim(MST.clsdt),'99999999')>&h_trdt
											AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
											AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
											AND idx.DEPTCD like '' || '%'
											AND idx.DEPTCD = dep.DEPTCD
											AND DECODE(dep.BRCD,'','1000','1000','1000',dep.BRCD) <>'1000'
											AND mst.BRCD = idx.BRCD
											AND mst.dptpcd = idx.DPTPCD
											AND mst.acctseQ = idx.ACCTSEQ
											union all
				--							SELECT --//+ INDEX (MST IXDP_SAVMST_T02)
				--										 MST.BRCD,  ' ' DEPTCD, br.LCLBRNM brnm , MST.CUSTSEQ,	 GEN.CUSTTPCD, GEN.SHRTNM
				--							FROM DP1.TBDP_SAVMST MST, CM1.TBCM_GENERAL GEN, TBCS_DEPTCD dep, TBCS_BRCD br,
				--														(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
				--																	DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
				--																				'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
				--																				'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
				--																				'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
				--																				'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
				--																						DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
				--															FROM TBDP_IDXACCT
				--															WHERE BRCD LIKE ''||'%'
				--														) idx,
				--														(
				--															SELECT --//+ INDEX (TBDP_SCLRBAL PKDP_SCLRBAL)
				--																		BRCD, DPTPCD, ACCTSEQ, MIN(CLRDT) CLRDT
				--															FROM DP1.TBDP_SCLRBAL
				--															WHERE BRCD LIKE ''||'%'
				--															GROUP BY BRCD, DPTPCD, ACCTSEQ
				--														) BAL
				--							WHERE
				--									  MST.BRCD LIKE ''||'%'
				--							AND MST.BRCD = GEN.BRCD
				--							AND MST.CUSTSEQ = GEN.CUSTSEQ
				--							AND MST.OPNCNCLFLG = '0'
				--							AND MST.BRCD = BAL.BRCD
				--							AND MST.DPTPCD = BAL.DPTPCD
				--							AND MST.ACCTSEQ = BAL.ACCTSEQ
				--							AND BAL.CLRDT <= &h_trdt
				--							and nvl(trim(MST.clsdt),'99999999')>&h_trdt
				--							AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
				--							AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
				--							AND mst.BRCD = br.BRCD
				--							AND idx.DEPTCD like '' || '%'
				--							AND idx.DEPTCD = dep.DEPTCD(+)
				--							AND DECODE(dep.BRCD,'','1000','1000','1000')='1000'
				--							AND mst.BRCD = idx.BRCD
				--							AND mst.dptpcd = idx.DPTPCD
				--							AND mst.acctseQ = idx.ACCTSEQ
											SELECT --//+ INDEX (MST IXDP_SAVMST_T02)
														 MST.BRCD,  ' ' DEPTCD, br.LCLBRNM brnm , MST.CUSTSEQ,	 GEN.CUSTTPCD, GEN.SHRTNM
											FROM DP1.TBDP_SAVMST MST, CM1.TBCM_GENERAL GEN, TBCS_BRCD br,
																		 (SELECT ----+ INDEX (TBDP_SCLRBAL PKDP_SCLRBAL)
																					BRCD, DPTPCD,
																					ACCTSEQ, MIN(CLRDT) CLRDT
																		FROM DP1.TBDP_SCLRBAL
																		WHERE BRCD LIKE ''||'%'
																		GROUP BY BRCD, DPTPCD, ACCTSEQ
																		) BAL
											WHERE
														  MST.BRCD LIKE ''||'%'
												AND MST.BRCD = GEN.BRCD
												AND MST.CUSTSEQ = GEN.CUSTSEQ
												AND MST.OPNCNCLFLG = '0'
												AND MST.BRCD = BAL.BRCD
												AND MST.DPTPCD = BAL.DPTPCD
												AND MST.ACCTSEQ = BAL.ACCTSEQ
												AND BAL.CLRDT <= &h_trdt
												and nvl(trim(MST.clsdt),'99999999')>&h_trdt
												--AND ((MST.CLSFLG = '0') OR ((MST.CLSFLG = '1')AND(MST.CLSDT > &h_trdt)))
												AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
												AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
												and mst.brcd = br.brcd
										)
									)
							)
							GROUP BY	BRCD, deptcd, brnm, CUSTTPCD, CUSTSEQ
					)A
					--WHERE			A.BRCD <> '1000'
					GROUP BY	A.BRCD, deptcd, brnm, A.CUSTTPCD, A.CUSTTYPE
				)
				GROUP BY BRCD, deptcd, LCLBRNM
			)B, --CIF_SL
			(
				SELECT
					BRCD, deptcd, LCLBRNM,	--HUY_DONG --
					SUM(HUY_DONG) HUY_DONG
				FROM
				(
					SELECT
							A.BRCD, a.deptcd, a.brnm LCLBRNM, A.CUSTTPCD,
							DECODE(A.CUSTTYPE, 1, 'Khach hang vay', 2, 'Khach hang gui', 3, 'Khach hang vua vay, vua gui', 'Hong biet'), --A.CUSTTYPE,
				--			C.LCLBRNM,
							COUNT(A.CUSTTPCD) HUY_DONG
--							CUSTSEQ HUY_DONG
					from
					(
							SELECT
								BRCD, deptcd,brnm, 	CUSTSEQ,	CUSTTPCD,	SUM(CUSTTYPE) CUSTTYPE
							FROM
							(
								SELECT
								DISTINCT
										DECODE(SIGN(TO_DATE(&h_trdt, 'YYYYMMDD') - TO_DATE('20070806', 'YYYYMMDD')), 1, BRCD, DECODE(BRCD, '2000', '1000', BRCD)) BRCD,
										deptcd, brnm, CUSTSEQ,
										DECODE(SUBSTR(SHRTNM, 1, 3), 'CS ', 'CA NHAN',
										DECODE(SUBSTR(SHRTNM, 1, 5), 'COSO ', 'CA NHAN',
										DECODE(SUBSTR(SHRTNM, 1, 6), 'CO SO ', 'CA NHAN', DECODE(CUSTTPCD, '100', 'CA NHAN', 'DOANH NGHIEP')))) CUSTTPCD,
										2 CUSTTYPE
								FROM
								(
									--*********************** DMDMST***********************
									select brcd, deptcd, brnm, custseq, custtpcd, SHRTNM
									from
									(
										SELECT
												MST.BRCD, idx.DEPTCD, dep.DEPTNMLOC brnm , MST.CUSTSEQ, GEN.CUSTTPCD, GEN.SHRTNM
										FROM DP1.TBDP_DMDMST MST, CM1.TBCM_GENERAL GEN,  TBCS_DEPTCD dep,
																	(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
																				DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
																							'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
																							'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
																							'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
																							'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
																									DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
																		FROM TBDP_IDXACCT
																		WHERE BRCD LIKE ''||'%'
																	) idx
										WHERE
												  MST.BRCD LIKE ''||'%'
										AND MST.BRCD = GEN.BRCD
										AND MST.CUSTSEQ = GEN.CUSTSEQ
										AND MST.OPNCNCLFLG = '0'
										AND MST.OPNDT <= &h_trdt
										and nvl(trim(MST.clsdt),'99999999')>&h_trdt
										AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
										AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
										AND idx.DEPTCD like '' || '%'
										AND idx.DEPTCD = dep.DEPTCD
										AND DECODE(dep.BRCD,'','1000','1000','1000',dep.BRCD) <>'1000'
										AND mst.BRCD = idx.BRCD
										AND mst.dptpcd = idx.DPTPCD
										AND mst.acctseQ = idx.ACCTSEQ
										union all
				--						SELECT
				--								MST.BRCD, ' ' DEPTCD, br.LCLBRNM brnm, MST.CUSTSEQ,
				--								GEN.CUSTTPCD, GEN.SHRTNM
				--						FROM DP1.TBDP_DMDMST MST, CM1.TBCM_GENERAL GEN,  TBCS_DEPTCD dep, TBCS_BRCD br,
				--													(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
				--																			DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','ACC',TRIM(DEPTCD)),
				--																			'2102', DECODE(TRIM(DEPTCD),'T1O','ACC',TRIM(DEPTCD)),
				--																			'1403', DECODE(TRIM(DEPTCD),'MHO','ACC',TRIM(DEPTCD)),
				--																			'1004', DECODE(TRIM(DEPTCD),'VHO','ACC',TRIM(DEPTCD)),
				--																			'1400', DECODE(TRIM(DEPTCD),'LNO','ACC','TDO','ACC','VVO','ACC',TRIM(DEPTCD)),
				--																			DECODE(TRIM(DEPTCD),'','ACC',TRIM(DEPTCD))) DEPTCD
				--														FROM TBDP_IDXACCT
				--														WHERE BRCD LIKE ''||'%'
				--														AND   DEPTCD like '' || '%'
				--													) idx
				--						WHERE
				--								  MST.BRCD LIKE ''||'%'
				--						AND MST.BRCD = GEN.BRCD
				--						AND MST.CUSTSEQ = GEN.CUSTSEQ
				--						AND MST.OPNCNCLFLG = '0'
				--						AND MST.OPNDT <= &h_trdt
				--						and nvl(trim(MST.clsdt),'99999999')>&h_trdt
				--						AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
				--						AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
				--						AND mst.BRCD = br.BRCD
				--						AND idx.DEPTCD like '' || '%'
				--						AND idx.DEPTCD = dep.DEPTCD(+)
				--						AND DECODE(dep.BRCD,'','1000','1000','1000')='1000'
				--						AND mst.BRCD = idx.BRCD
				--						AND mst.dptpcd = idx.DPTPCD
				--						AND mst.acctseQ = idx.ACCTSEQ
										SELECT
												MST.BRCD, ' ' DEPTCD, br.LCLBRNM brnm, MST.CUSTSEQ,GEN.CUSTTPCD, GEN.SHRTNM
										FROM DP1.TBDP_DMDMST MST, CM1.TBCM_GENERAL GEN,  TBCS_DEPTCD dep, TBCS_BRCD br
										WHERE
													  MST.BRCD LIKE ''||'%'
											AND MST.BRCD = GEN.BRCD
											AND MST.CUSTSEQ = GEN.CUSTSEQ
											AND MST.OPNCNCLFLG = '0'
											AND MST.OPNDT <= &h_trdt
											----AND ((MST.CLSFLG = '0') OR ((MST.CLSFLG = '1')AND(MST.CLSDT > &h_trdt)))
											and nvl(trim(MST.clsdt),'99999999')>&h_trdt
											AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
											AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
											and mst.brcd = br.brcd
									)
									union all
									--*********************** SAVMST***********************
									select brcd, deptcd, brnm, custseq, custtpcd, SHRTNM
									from
									(
										SELECT --//+ INDEX (MST IXDP_SAVMST_T02)
													 MST.BRCD,  idx.DEPTCD, dep.DEPTNMLOC brnm , MST.CUSTSEQ,	 GEN.CUSTTPCD, GEN.SHRTNM
										FROM DP1.TBDP_SAVMST MST, CM1.TBCM_GENERAL GEN, TBCS_DEPTCD dep,
																	(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
																				DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
																							'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
																							'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
																							'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
																							'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
																									DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
																		FROM TBDP_IDXACCT
																		WHERE BRCD LIKE ''||'%'
																	) idx,
																	(
																		SELECT --//+ INDEX (TBDP_SCLRBAL PKDP_SCLRBAL)
																					BRCD, DPTPCD, ACCTSEQ, MIN(CLRDT) CLRDT
																		FROM DP1.TBDP_SCLRBAL
																		WHERE BRCD LIKE ''||'%'
																		GROUP BY BRCD, DPTPCD, ACCTSEQ
																	) BAL
										WHERE
												  MST.BRCD LIKE ''||'%'
										AND MST.BRCD = GEN.BRCD
										AND MST.CUSTSEQ = GEN.CUSTSEQ
										AND MST.OPNCNCLFLG = '0'
										AND MST.BRCD = BAL.BRCD
										AND MST.DPTPCD = BAL.DPTPCD
										AND MST.ACCTSEQ = BAL.ACCTSEQ
										AND BAL.CLRDT <= &h_trdt
										and nvl(trim(MST.clsdt),'99999999')>&h_trdt
										AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
										AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
										AND idx.DEPTCD like '' || '%'
										AND idx.DEPTCD = dep.DEPTCD
										AND DECODE(dep.BRCD,'','1000','1000','1000',dep.BRCD) <>'1000'
										AND mst.BRCD = idx.BRCD
										AND mst.dptpcd = idx.DPTPCD
										AND mst.acctseQ = idx.ACCTSEQ
										union all
				--						SELECT --//+ INDEX (MST IXDP_SAVMST_T02)
				--									 MST.BRCD,  ' ' DEPTCD, br.LCLBRNM brnm , MST.CUSTSEQ,	 GEN.CUSTTPCD, GEN.SHRTNM
				--						FROM DP1.TBDP_SAVMST MST, CM1.TBCM_GENERAL GEN, TBCS_DEPTCD dep, TBCS_BRCD br,
				--													(	SELECT  BRCD, DPTPCD, ACCTSEQ, ACCTNO,
				--																DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
				--																			'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
				--																			'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
				--																			'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
				--																			'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
				--																					DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
				--														FROM TBDP_IDXACCT
				--														WHERE BRCD LIKE ''||'%'
				--													) idx,
				--													(
				--														SELECT --//+ INDEX (TBDP_SCLRBAL PKDP_SCLRBAL)
				--																	BRCD, DPTPCD, ACCTSEQ, MIN(CLRDT) CLRDT
				--														FROM DP1.TBDP_SCLRBAL
				--														WHERE BRCD LIKE ''||'%'
				--														GROUP BY BRCD, DPTPCD, ACCTSEQ
				--													) BAL
				--						WHERE
				--								  MST.BRCD LIKE ''||'%'
				--						AND MST.BRCD = GEN.BRCD
				--						AND MST.CUSTSEQ = GEN.CUSTSEQ
				--						AND MST.OPNCNCLFLG = '0'
				--						AND MST.BRCD = BAL.BRCD
				--						AND MST.DPTPCD = BAL.DPTPCD
				--						AND MST.ACCTSEQ = BAL.ACCTSEQ
				--						AND BAL.CLRDT <= &h_trdt
				--						and nvl(trim(MST.clsdt),'99999999')>&h_trdt
				--						AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
				--						AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
				--						AND mst.BRCD = br.BRCD
				--						AND idx.DEPTCD like '' || '%'
				--						AND idx.DEPTCD = dep.DEPTCD(+)
				--						AND DECODE(dep.BRCD,'','1000','1000','1000')='1000'
				--						AND mst.BRCD = idx.BRCD
				--						AND mst.dptpcd = idx.DPTPCD
				--						AND mst.acctseQ = idx.ACCTSEQ
										SELECT --//+ INDEX (MST IXDP_SAVMST_T02)
													 MST.BRCD,  ' ' DEPTCD, br.LCLBRNM brnm , MST.CUSTSEQ,	 GEN.CUSTTPCD, GEN.SHRTNM
										FROM DP1.TBDP_SAVMST MST, CM1.TBCM_GENERAL GEN, TBCS_DEPTCD dep, TBCS_BRCD br,
																		(
																			SELECT --//+ INDEX (TBDP_SCLRBAL PKDP_SCLRBAL)
																						BRCD, DPTPCD, ACCTSEQ, MIN(CLRDT) CLRDT
																			FROM DP1.TBDP_SCLRBAL
																			WHERE BRCD LIKE ''||'%'
																			GROUP BY BRCD, DPTPCD, ACCTSEQ
																		) BAL
										  WHERE
													  MST.BRCD LIKE ''||'%'
											AND MST.BRCD = GEN.BRCD
											AND MST.CUSTSEQ = GEN.CUSTSEQ
											AND MST.OPNCNCLFLG = '0'
											AND MST.BRCD = BAL.BRCD
											AND MST.DPTPCD = BAL.DPTPCD
											AND MST.ACCTSEQ = BAL.ACCTSEQ
											AND BAL.CLRDT <= &h_trdt
											and nvl(trim(MST.clsdt),'99999999')>&h_trdt
											--AND ((MST.CLSFLG = '0') OR ((MST.CLSFLG = '1')AND(MST.CLSDT > &h_trdt)))
											AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
											AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
											and mst.brcd = br.brcd
									)
								)
							)
							GROUP BY	BRCD, deptcd, brnm, CUSTTPCD, CUSTSEQ
					)A
					--WHERE			A.BRCD <> '1000'
				GROUP BY	A.BRCD, deptcd, brnm, A.CUSTTPCD, A.CUSTTYPE
				)
				GROUP BY BRCD, deptcd, LCLBRNM
			)C, --HUY_DONG
			(
--				select
--								BRCD,
--								LCLBRNM,
--								COUNT(DISTINCT CUSTSEQ) CHO_VAY
--				from
--				(
--					SELECT
--						DISTINCT  MAST.BRCD	BRCD,
--											 C.LCLBRNM		LCLBRNM,
--											 MAST.CUSTSEQ	CUSTSEQ
--					FROM
--									GL1.TBGL_MAST MAST, CM1.TBCM_GENERAL GEN, CS1.TBCS_BRCD C
--					WHERE
--											MAST.TRDT = &h_trdt
--								AND MAST.BRCD LIKE ''||'%'
--								AND MAST.BRCD = GEN.BRCD
--								AND MAST.CUSTSEQ = GEN.CUSTSEQ
--								AND MAST.ACCTCD LIKE '2%'
--								AND SUBSTR(MAST.ACCTCD, 3, 1) NOT IN ('7', '9')
--								AND MAST.TDBAL > 0
--								AND GEN.BRCD <> '1000'
--								AND MAST.BRCD = C.BRCD
----								//AND LN1.CHKLNCUSTTYPE(MAST.BRCD, MAST.CUSTSEQ, DECODE('1', '1', 'ind', '2', 'cmp', '1', 'all')) = 'Y'
--								AND LN1.CHK_LNCUSTTP(MAST.BRCD,'','', MAST.CUSTSEQ, DECODE('1', '1', 'ind', '2', 'cmp', '1', 'all')) = 'Y'
--				)
--				group by BRCD, LCLBRNM

			SELECT
--				BRCD, deptcd,brnm, 	CUSTSEQ,	CUSTTPCD,	SUM(CUSTTYPE) CUSTTYPE
								BRCD,		DEPTCD, BRNM LCLBRNM,	--	CUSTSEQ CHO_VAY,
								COUNT(DISTINCT CUSTSEQ) CHO_VAY
			FROM
			(
					--PGD
					SELECT
							BRCD, DEPTCD, BRNM,CUSTSEQ,
							DECODE(SUBSTR(SHRTNM, 1, 3), 'CS ', 'CA NHAN',
							DECODE(SUBSTR(SHRTNM, 1, 5), 'COSO ', 'CA NHAN',
							DECODE(SUBSTR(SHRTNM, 1, 6), 'CO SO ', 'CA NHAN', DECODE(CUSTTPCD, '100', 'CA NHAN', 'DOANH NGHIEP')))) CUSTTPCD,
							1 CUSTTYPE
					FROM
					(
						SELECT
							MAS.BRCD, MAS.DEPTCD, dep.DEPTNMLOC brnm , MAS.CUSTSEQLN CUSTSEQ, GEN.CUSTTPCD, GEN.SHRTNM
						FROM
							 LN1.TBLN_DSBSHIST MAS, CM1.TBCM_GENERAL GEN, TBCS_DEPTCD DEP--,
--							 (	SELECT  BRCD, DPTPCD, ACCTSEQ, CUSTSEQ, ACCTNO,
--											DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
--																		'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
--																		'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
--																		'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
--																		'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
--																		DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
--									FROM TBDP_IDXACCT
--									WHERE BRCD LIKE ''||'%'
--								) IDX
						WHERE
							MAS.BKDT = &h_trdt
							AND MAS.BRCD LIKE ''||'%'
							AND MAS.DEPTCD LIKE '%O'
							AND MAS.BRCD = GEN.BRCD
							AND MAS.CUSTSEQLN = GEN.CUSTSEQ
							AND MAS.BUSCD = 'LN'
							AND MAS.STSCD = '01'
							AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
							AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
							AND MAS.DEPTCD like '' || '%'
							AND MAS.DEPTCD = DEP.DEPTCD
							AND DECODE(DEP.BRCD,'','1000','1000','1000',DEP.BRCD) <>'1000'
--							AND MAS.BRCD = IDX.BRCD 
--							AND MAS.CUSTSEQLN = IDX.CUSTSEQ
						UNION ALL

--						SELECT
--							MAS.BRCD,  ' ' DEPTCD, BR.LCLBRNM BRNM, MAS.CUSTSEQLN,  GEN.CUSTTPCD,
--							GEN.SHRTNM
--						FROM
--							LN1.TBLN_DSBSHIST MAS, CM1.TBCM_GENERAL GEN,  TBCS_BRCD BR
--						WHERE
--							MAS.BKDT = &h_trdt
--							AND MAS.BRCD LIKE ''||'%'
--							AND MAS.BRCD = GEN.BRCD
--							AND MAS.CUSTSEQLN = GEN.CUSTSEQ
--							AND MAS.BUSCD = 'LN'
--							AND MAS.STSCD = '01'
--							AND GEN.CUSTTPCD LIKE DECODE('1','1','100','%')
--							AND GEN.CUSTTPCD NOT LIKE DECODE('1','1','999','2','100','999')
--							AND MAS.BRCD = BR.BRCD
						SELECT
								MAS.BRCD,  ' ' DEPTCD, C.LCLBRNM BRNM, MAS.CUSTSEQ,  GEN.CUSTTPCD,		GEN.SHRTNM
							FROM
											GL1.TBGL_MAST MAS, CM1.TBCM_GENERAL GEN, CS1.TBCS_BRCD C
							WHERE
											MAS.TRDT = &h_trdt
								AND MAS.BRCD LIKE ''||'%'
								AND MAS.BRCD = GEN.BRCD
								AND MAS.CUSTSEQ = GEN.CUSTSEQ
								AND MAS.ACCTCD LIKE '2%'
								AND SUBSTR(MAS.ACCTCD, 3, 1) NOT IN ('7', '9')
								AND MAS.TDBAL > 0
								AND GEN.BRCD <> '1000'
								AND MAS.BRCD = C.BRCD
								--AND LN1.CHKLNCUSTTYPE(MAST.BRCD, MAST.CUSTSEQ, DECODE('1', '1', 'ind', '2', 'cmp', '1', 'all')) = 'Y'
								AND LN1.CHK_LNCUSTTP(MAS.BRCD,'','', MAS.CUSTSEQ, DECODE('1', '1', 'ind', '2', 'cmp', '1', 'all')) = 'Y'
					)
			)
			GROUP BY	BRCD, deptcd, brnm--, CUSTTPCD, CUSTSEQ
			)D, --CHO_VAY
			(
				SELECT BRCD, LCLBRNM, deptcd, COUNT       THE1
				FROM
				(
					select brcd, LCLBRNM , deptcd, sum(count)   count
					from
					(
					--		--PGD
						SELECT D.BRCD, D.DEPTNM LCLBRNM, --D.LOCNM LCLBRNM ,
										D.DEPTCD, D.SOLUONGTHE count  --,		DECODE(D.DEPTNM,'',D.LOCNM,D.DEPTNM) DEPTNM
						FROM
						(
							SELECT C.BRCD BRCD, --B.LCLBRNM LOCNM,
											C.KH_EIB AS SOLUONGTHE,
											C.CARDTYPE , C.DEPTCD , A.DEPTNMLOC DEPTNM
							FROM 		--CS1.TBCS_BRCD B ,
												CS1.TBCS_DEPTCD A ,
							(
								SELECT B.BRCD, --B.CUSTSEQ KH_EIB,
														COUNT(*) KH_EIB, 'THEEIB' CARDTYPE ,
													 B.DEPTCD
								FROM
								(
									SELECT SUBSTR(A.ACCTNO,1,4) BRCD, A.CUSTSEQ , A.DEPTCD
									FROM
									(
										SELECT A.ACCTNO, A.CARDNBR, B.CUSTSEQ, B.DEPTCD --, NVL(TRIM(B.DEPTCD),'CAD') DEPTCD
										FROM EI1.TBEI_ACCTCARD A , DP1.TBDP_IDXACCT B
										WHERE A.MM = SUBSTR(&h_trdt,5,2) AND A.YY = SUBSTR(&h_trdt,1,4)
											AND	SUBSTR(A.ACCTNO,1,4) <> '1000'
											AND	SUBSTR(A.ACCTNO,1,4) = B.BRCD          and b.deptcd like '%O'
											AND	A.ACCTNO = B.ACCTNO
									) A
									GROUP BY SUBSTR(A.ACCTNO,1,4), A.CUSTSEQ , A.DEPTCD
								) B
								GROUP BY BRCD , DEPTCD
							) C
							WHERE C.BRCD LIKE ''||'%' AND C.DEPTCD LIKE ''||'%' --					AND C.BRCD = B.BRCD
									AND C.DEPTCD = A.DEPTCD(+) AND C.BRCD = A.BRCD (+)
							GROUP BY 	C.BRCD, --B.LCLBRNM,
													C.KH_EIB, C.CARDTYPE, C.DEPTCD, A.DEPTNMLOC
							ORDER BY C.BRCD
						) D
						WHERE D.CARDTYPE = DECODE('1', '1','THEEIB', '1','THEEIB')

						union all
						 --chi nhanh
						SELECT D.BRCD, D.LOCNM	LCLBRNM , ' ' deptcd,  D.SOLUONGTHE	count
						FROM
						(
								SELECT A.BRCD BRCD, B.LCLBRNM LOCNM, C.KH_EIB AS SOLUONGTHE, C.CARDTYPE
								FROM
												EI1.TBEI_RPTMONTHLY A , CS1.TBCS_BRCD B ,
																																	(SELECT B.BRCD, COUNT(*) KH_EIB, 'THEEIB' CARDTYPE
																																	FROM
																																		(
																																		SELECT SUBSTR(A.ACCTNO,1,4) BRCD, A.CUSTSEQ
																																		FROM
																																			(
																																			SELECT A.ACCTNO, A.CARDNBR, B.CUSTSEQ
																																			FROM
																																							EI1.TBEI_ACCTCARD A , DP1.TBDP_IDXACCT B
																																			WHERE
																																								A.MM = SUBSTR(&h_trdt,5,2) AND
																																								A.YY = SUBSTR(&h_trdt,1,4) AND
																																								SUBSTR(A.ACCTNO,1,4) <> '1000' AND
																																								SUBSTR(A.ACCTNO,1,4) = B.BRCD AND
																																								A.ACCTNO = B.ACCTNO
																																			) A
																																		GROUP BY SUBSTR(A.ACCTNO,1,4), A.CUSTSEQ
																																		) B
																																	GROUP BY BRCD
																																	) C
																																	WHERE
																																					 A.BRCD LIKE ''||'%'
																																			AND A.BRCD = B.BRCD
																																			AND C.BRCD = A.BRCD
																																			AND A.MM = SUBSTR(&h_trdt,5,2)
																																			AND A.YY = SUBSTR(&h_trdt,1,4)
																																	GROUP BY A.AREA,A.BRCD, B.LCLBRNM,C.KH_EIB, C.CARDTYPE
																																	ORDER BY A.BRCD
						) D
						WHERE D.CARDTYPE = DECODE('1', '1','THEEIB', '1','THEEIB')
					)
					group by brcd, LCLBRNM, deptcd

					UNION ALL

					select  brcd, LOCNM LCLBRNM, deptcd, sum(COUNT)    count
					from
					(  --PGD
						SELECT C.BRCD, C.DEPTNM LOCNM, C.DEPTCD, C.COUNT--C.custseq,
				--							C.COUNT,	C.DEPTCD, DECODE(C.DEPTNM,'',C.LOCNM,C.LOCNM) DEPTNM
							FROM
							(
								SELECT 	A.BRCD , A.LOCNM, --A.CUSTSEQ, --
													COUNT(*) COUNT,	CARDTYPE , A.DEPTCD , B.DEPTNMLOC DEPTNM
								FROM
								(
									SELECT A.BRCD BRCD, B.LCLBRNM LOCNM, C.CUSTSEQ, 'BUSINESS' CARDTYPE, C.DEPTCD
									FROM EI1.TBEI_CIF A, CS1.TBCS_BRCD B , DP1.TBDP_IDXACCT C
									WHERE A.BRCD = B.BRCD
									AND A.GE_ACCTCD = C.ACCTNO AND C.BRCD LIKE ''||'%' AND C.DEPTCD LIKE ''||'%'
									GROUP BY A.BRCD, B.LCLBRNM, C.CUSTSEQ, C.DEPTCD
								) A , CS1.TBCS_DEPTCD B
								WHERE A.DEPTCD = B.DEPTCD(+) AND A.BRCD = B.BRCD (+)
								GROUP BY A.BRCD, A.LOCNM, A.DEPTCD, CARDTYPE ,B.DEPTNMLOC
								ORDER BY A.BRCD
							) C
							WHERE C.CARDTYPE = DECODE('1', '2','BUSINESS')


						union all
						SELECT C.BRCD, C.LOCNM, ' ' deptcd ,  C.COUNT
						FROM
						(
							SELECT A.BRCD BRCD, B.LCLBRNM LOCNM, COUNT(*) COUNT, 'BUSINESS' CARDTYPE
							FROM
											EI1.TBEI_CIF A, CS1.TBCS_BRCD B
							WHERE
													A.BRCD = B.BRCD
							GROUP BY A.BRCD, B.LCLBRNM
							ORDER BY A.BRCD
						) C
						WHERE C.CARDTYPE = DECODE('1', '2','BUSINESS')
					)
					group by brcd, LOCNM   , deptcd
				)
			)T, -- THE
			(
				SELECT
						A.BRCD , B.LCLBRNM , ' ' deptcd,  --custseq TTQT --
						COUNT(DISTINCT A.CUSTSEQ) TTQT
				FROM
				(
				--TF
						select
									brcd,
									custseq
						from
						(
							SELECT
											BRCD, CUSTSEQ, NM,
											 SUM(DECODE(CAT,'LC',USDAMT,0)) LCAMT,
											 SUM(DECODE(CAT,'NLC',USDAMT,0)) NLCAMT,
											 SUM(DECODE(CAT,'TT',USDAMT,0)) TTRAMT
							FROM
							(
										SELECT CAT, BRCD, CUSTSEQ, NM, SUM(USDAMT) USDAMT
										FROM
										(
													SELECT
																DECODE(STL.TRREF,'IDA','NLC','IDP','NLC','IDM','NLC','ILS','LC','ILU','LC','ISB','LC') CAT,
																STL.BRCD, STL.TRREF,STL.IMPRTTRSEQ,GM.CUSTSEQ,GM.NM,STL.STLCCYCD,
																SUM(STL.SETLAMT),
																SUM(CS1.EXCROSSCAL(STL.BRCD,'VND',&h_trdt, NVL(STL.STLCCYCD,'USD'),STL.SETLAMT,'01','USD','01')) USDAMT
													FROM
													(
																SELECT
																				 MS.BRCD BRCD ,MS.TRREF TRREF ,MS.IMPRTTRSEQ IMPRTTRSEQ,
																				 MS.APLCUSTSEQ CUSTSEQ, GN.SHRTNM NM
																FROM
																				CM1.TBCM_GENERAL GN,	TF1.TBTF_IMTRMST MS
																WHERE
																		  GN.BRCD = MS.BRCD
																AND GN.CUSTSEQ = MS.APLCUSTSEQ
													)GM ,
													(
													SELECT BRCD,TRREF,IMPRTTRSEQ ,STLCCYCD ,SETLAMT
													FROM TF1.TBTF_IMSTL
													WHERE
																			BRCD LIKE '' || '%'
																AND ((VRFCTNFLG = 'Y' AND TRIM(VRFCTNDT) IS NOT NULL) OR (VRFCTNFLG = 'N'))
																AND TRIM(CNCLDT) IS NULL AND SETLAMT > 0
																AND OPRDT >= substr(&h_trdt,1,4)||'0101' AND OPRDT <= &h_trdt
													)STL
													WHERE
															  STL.BRCD =GM.BRCD AND STL.TRREF =GM.TRREF
														AND STL.IMPRTTRSEQ =GM.IMPRTTRSEQ
													GROUP BY DECODE(STL.TRREF,'IDA','NLC','IDP','NLC','IDM','NLC','ILS','LC','ILU','LC','ISB','LC'),
													STL.BRCD, STL.TRREF,STL.IMPRTTRSEQ,STL.STLCCYCD,GM.CUSTSEQ,GM.NM
										)
										GROUP BY CAT, BRCD, CUSTSEQ, NM
							)
							GROUP BY BRCD, CUSTSEQ, NM

							UNION ALL

							SELECT
								BRCD, CUSTSEQ, CUSTINFO, SUM(DECODE(NEGOCAT,'L/C',CRDAMT,0)) TTLC,
								SUM(DECODE(NEGOCAT,'NON-L/C',CRDAMT,0)) TTNLC,
								SUM(DECODE(NEGOCAT,'TT',CRDAMT,0)) TTTTR
							FROM
							(
								SELECT
									NEGO.BRCD BRCD,
									NEGO.NEGOCAT NEGOCAT,
									NEGO.CUSTSEQ CUSTSEQ,
									NEGO.CUSTINFO CUSTINFO,
									SUM(NEGO.CRDAMT) CRDAMT
								FROM
								(
									SELECT
											NG.BRCD, 'L/C' NEGOCAT,NG.CUSTSEQ CUSTSEQ,NG.CUSTINFO CUSTINFO,
											NG.BRCD||NG.NEGOTRREF||NG.NEGOTRSEQ NEGOSEQ,
											NVL(TRIM(NG.MCHDSCD),19) MCHDSCD,CRD.OPTDT OPTDT, CRD.STLBKCD STLBKCD,
											CRD.STLDT STLDT,
											DECODE(NG.NEGOTRREF,'ESC',NG.NEGOAMT,'EUC',NG.NEGOAMT,'RSC',NG.NEGOAMT,'RUC',NG.NEGOAMT,NG.DOCAMT) DOCAMT,
											CS1.EXCROSSCAL(NG.BRCD,'VND',&h_trdt, NVL(CRD.STLCCYCD,'USD'),CRD.CRDAMT,'01','USD','01') CRDAMT
									FROM TF1.TBTF_EXNCO NG,
														(
															SELECT BRCD,
																	NEGOTRREF,
																	NEGOTRSEQ,
																	STLBKCD,
																	STLCCYCD,
																	OPTDT,STLDT,
																	DECODE(NEGOTRREF,'ESC',TOTALAMT,'EUC',TOTALAMT,'RSC',TOTALAMT,'RUC',TOTALAMT,NETAMT) CRDAMT
															FROM TF1.TBTF_EXCRD
															WHERE
																(
																	  (DELFLG = 'N' OR DELFLG IS NULL)
																AND (CNCLFLG = 'N' OR CNCLFLG IS NULL)
																)
															AND (STLDT >= substr(&h_trdt,1,4)||'0101') AND(STLDT <= &h_trdt)
															AND NEGOTRREF IN ('ESC','EUC','RSC','RUC','ESP','EUP','RSP','RUP')
														)CRD
									WHERE
											  NG.BRCD LIKE ''||'%'
										AND (NG.BRCD=CRD.BRCD
										AND NG.NEGOTRREF =CRD.NEGOTRREF
										AND NG.NEGOTRSEQ = CRD.NEGOTRSEQ)
										AND (NG.DELFLG = 'N' OR NG.DELFLG IS NULL)
										AND (NG.CNCLFLG = 'N' OR NG.CNCLFLG IS NULL)
										AND (NG.VAFFLG ='Y')
									UNION  ALL
									SELECT
											NG.BRCD, 'NON-L/C' NEGOCAT ,NG.CUSTSEQ, NG.CUSTINFO,
											NG.BRCD||NG.NEGOTRREF||NG.NEGOTRSEQ NEGOSEQ,
											NVL(TRIM(NG.MCHDSCD),19) MCHDSCD,CRD.OPTDT OPTDT,CRD.STLBKCD STLBKCD,
											CRD.STLDT STLDT,
											DECODE(NG.NEGOTRREF,'EAC',NG.NEGOAMT,'EPC',NG.NEGOAMT,'RAC',NG.NEGOAMT,'RPC',NG.NEGOAMT,NG.DOCAMT) DOCAMT,
											CS1.EXCROSSCAL(NG.BRCD,'VND',&h_trdt, NVL(CRD.STLCCYCD,'USD'),CRD.CRDAMT,'01','USD','01') CRDAMT
									FROM
											TF1.TBTF_EXNCO NG,
															(
																SELECT
																		BRCD,
																		NEGOTRREF,
																		NEGOTRSEQ,
																		STLBKCD,
																		STLCCYCD,
																		OPTDT,
																		STLDT,
																		DECODE(NEGOTRREF,'EAC',TOTALAMT,'EPC',TOTALAMT,'RAC',TOTALAMT,'RUP',TOTALAMT,NETAMT) CRDAMT
																FROM
																		TF1.TBTF_EXCRD
																WHERE
																(
																		  (DELFLG = 'N' OR DELFLG IS NULL)
																	AND (CNCLFLG = 'N' OR CNCLFLG IS NULL)
																)
																AND (STLDT >= substr(&h_trdt,1,4)||'0101')
																AND (STLDT <= &h_trdt)
																AND NEGOTRREF IN ('EAC','EPC','RAC','RPC','EDA','EDP','RAP','RDP')
															)CRD
									 WHERE
											NG.BRCD LIKE ''||'%'
										AND (NG.BRCD=CRD.BRCD AND NG.NEGOTRREF =CRD.NEGOTRREF AND NG.NEGOTRSEQ = CRD.NEGOTRSEQ)
										AND (NG.DELFLG = 'N' OR NG.DELFLG IS NULL)
										AND (NG.CNCLFLG = 'N' OR NG.CNCLFLG IS NULL)
										AND (NG.VAFFLG ='Y')
								) NEGO,	RACE.T_CODE TC
								WHERE
										  TC.CAT_NAME = 'TFMCHDSEX'
									AND NEGO.MCHDSCD =TC.CODE(+)
								GROUP BY NEGO.BRCD, NEGO.NEGOCAT, NEGO.CUSTSEQ, NEGO.CUSTINFO
							)
							GROUP BY BRCD, CUSTINFO, CUSTSEQ
						)
						--FX
						UNION ALL
						SELECT
									a.BRCD ,
						--				c.LCLBRNM ,
									DECODE(a.CUSTNO, '000000000', a.CUSTNO || a.ORDCUST, a.CUSTNO) CUSTSEQ
						FROM
									FX1.TBFX_ORMASTER a, FX1.TBFX_CCOMMSTR b, --CS1.TBCS_BRCD c,
									CM1.TBCM_GENERAL d
						WHERE
									  a.BRCD = b.BRCD
							AND a.TRREF = b.TRREF
							AND a.TRSEQ = b.TRSEQ
						--		AND b.BRCD = c.BRCD
							AND a.CUSTNO = d.CUSTSEQ
							AND a.TRREF IN ('ODD', 'OTT') AND a.OPENFLG = '1'
							AND (
										(a.BOPID = 'DP' AND a.BOPCD LIKE 'HN%')
										OR (a.BOPID = 'DP' AND a.BOPCD LIKE 'DVX%')
										OR (a.BOPID = '10' AND a.BOPCD LIKE 'TTHN')
										OR (a.BOPID = 'DH')
										OR (a.BOPID = 'DP' AND a.BOPCD IN ('NV01', 'NV02', 'RV01', 'RV02', 'TTKN'))
										OR (a.BOPID = '01' AND a.BOPCD = '9999')
										OR (a.BOPID = '02' AND a.BOPCD = '0223')
										OR (a.BOPID = '03' AND a.BOPCD = '0259')
										OR (a.BOPID = '04' AND a.BOPCD = '275')
										OR (a.BOPID = '11' AND a.BOPCD = 'TTKN')
										OR (a.BOPID = '14' AND a.BOPCD = 'DH')
										OR a.BOPCD LIKE 'LD%'
									 )
							AND b.SCONF = 'Y' AND b.SUBTP IN ('103', '110', '202')
							AND b.EDITDT BETWEEN substr(&h_trdt,1,4)||'0101' AND &h_trdt
							AND d.BRCD = '1000'
							AND d.CUSTTPCD LIKE DECODE('1', '1', '100', '%')
							AND d.CUSTTPCD NOT LIKE DECODE('1', '2', '100', '999')
						UNION ALL

						SELECT a.BRCD ,  DECODE(a.CUSTNO, '000000000', a.CUSTNO || a.BENCUST, a.CUSTNO) CUSTSEQ
						FROM FX1.TBFX_IRMASTER a,  CM1.TBCM_GENERAL c
						WHERE
									  a.CUSTNO = c.CUSTSEQ
							AND a.OPENFLG = '1'
							AND (
										a.BOPID = 'IR'
										OR (a.BOPID = '07' AND a.BOPCD = 'LD4')
									)
							AND a.FSTTRDT BETWEEN substr(&h_trdt,1,4)||'0101' AND &h_trdt
							AND c.BRCD = '1000'
							AND c.CUSTTPCD LIKE DECODE('1', '1', '100', '%')
							AND c.CUSTTPCD NOT LIKE DECODE('1', '2', '100', '999')
				)A, CS1.TBCS_BRCD B
				WHERE
						A.BRCD = B.BRCD
				GROUP BY					A.BRCD, B.LCLBRNM
			)X, --TTQT
			(
				select brcd, deptcd, brnm LCLBRNM, --cif --
							count(cif)
				from
				(
				--*********************** PGD***********************
					SELECT idx.BRCD, idx.DEPTCD, dept.DEPTNMLOC brnm, (idx.CUSTSEQ) cif
					FROM TBCS_DEPTCD dept,
								(	SELECT  BRCD, CUSTSEQ,
											DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','',TRIM(DEPTCD)),
														'1004', DECODE(TRIM(DEPTCD),'VHO','',TRIM(DEPTCD)),
														'2102', DECODE(TRIM(DEPTCD),'T1O','',TRIM(DEPTCD)),
														'1403', DECODE(TRIM(DEPTCD),'MHO','',TRIM(DEPTCD)),
														'1400', DECODE(TRIM(DEPTCD),'LNO','','TDO','','VVO','',TRIM(DEPTCD)),
																DECODE(TRIM(DEPTCD),'','',TRIM(DEPTCD))) DEPTCD
									FROM TBDP_IDXACCT
									WHERE BRCD LIKE ''||'%'
								) idx
					where idx.deptcd = dept.deptcd AND DECODE(dept.BRCD,'','1000','1000','1000',dept.BRCD) <>'1000'
					union all
					--*********************** CHI NHANH***********************
					SELECT idx.BRCD, ' '  DEPTCD, b.LCLBRNM brnm, (idx.CUSTSEQ) cif
					FROM TBCS_DEPTCD dept,
											(	SELECT  BRCD, custseq,
														DECODE(BRCD,'2103', DECODE(TRIM(DEPTCD),'BNO','ACC',TRIM(DEPTCD)),
																	'2102', DECODE(TRIM(DEPTCD),'T1O','ACC',TRIM(DEPTCD)),
																	'1403', DECODE(TRIM(DEPTCD),'MHO','ACC',TRIM(DEPTCD)),
																	'1004', DECODE(TRIM(DEPTCD),'VHO','ACC',TRIM(DEPTCD)),
																	'1400', DECODE(TRIM(DEPTCD),'LNO','ACC','TDO','ACC','VVO','ACC',TRIM(DEPTCD)),
																			DECODE(TRIM(DEPTCD),'','ACC',TRIM(DEPTCD))) DEPTCD
												FROM TBDP_IDXACCT
												WHERE BRCD LIKE ''||'%'
												AND   DEPTCD like '' || '%'
											) idx, CS1.TBCS_BRCD B
					where 	  idx.brcd = b.brcd AND idx.DEPTCD = dept.DEPTCD(+)		AND DECODE(dept.BRCD,'','1000','1000','1000')='1000'
				)
				group by brcd, deptcd, brnm
				order by brcd, deptcd
			)Y --PGD
			WHERE
							A.BRCD = B.BRCD (+)
				AND	A.BRCD = C.BRCD (+)
				AND	A.BRCD = D.BRCD (+)
				AND	A.BRCD = T.BRCD (+)
				AND	A.BRCD = X.BRCD (+)
				AND	A.BRCD = Y.BRCD (+)
----				and 		a.deptcd = B.deptcd
----				and 		a.deptcd = c.deptcd
----				 and 	a.deptcd = y.deptcd
				AND   A.LCLBRNM = B.LCLBRNM (+)
				AND 	A.LCLBRNM = C.LCLBRNM (+)
				AND   A.LCLBRNM = D.LCLBRNM (+)
				AND	A.LCLBRNM = T.LCLBRNM (+)
				AND 	A.LCLBRNM = X.LCLBRNM (+)
				AND 	A.LCLBRNM = Y.LCLBRNM (+)
)
ORDER BY MA_CN--, DEPTCD
