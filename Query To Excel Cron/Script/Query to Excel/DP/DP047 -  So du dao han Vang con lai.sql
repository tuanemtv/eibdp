
--define h_brcd =''
--define h_brcd_ex ='1000'
--define h_trdt='20120616'
--define h_custtpcd ='1'
--define h_ccycd ='GD1'
--define h_deptcd =''
--define h_vip ='0'

SELECT brcd,
	ccy,
	MA1,
	TK,
	DECODE(TYPE,'C1','C',TYPE) TYPE,
	KYHAN,
	SUM(clrbal) CLRBAL,cs1.excrosscal( '1000', 'VND', &h_trdt, ccy, SUM(clrbal), '01', 'VND', '01') quydoi,
	SUM(intamt) intamt , deptcd, matdt
FROM
(	SELECT brcd,  custseq, ccy, TK, TYPE, MA1,
			DECODE(TIMEDPTP,'002', KYHAN, '003', KYHAN, '000', KYHAN, DECODE(CNTRMMTRM,'364',KYHAN, '001', 'TK qua dem', '002', 'TK Call 48h', 'Ky han '||round(nvl(CNTRMMTRM,'000')/7)||' tuan')) KYHAN,
			clrbal, intamt, TIMEDPTP, CNTRMMTRM, deptcd, matdt --npa mod 01-08-2011
	FROM
	(	SELECT brcd, custseq, MA1, ccy,
			  DECODE(kind,'TIEN GUI',DECODE(loai, 'KKH',DECODE(type,'D','3.1','1.1'),DECODE(type,'D','3.2','1.2')),
			  'KY PHIEU','4.2','GIU HO VANG', '9.0',DECODE(loai, 'KKH','2.1','2.2')) TK,
			  type, kyhan, clrbal, intamt, TIMEDPTP, CNTRMMTRM, deptcd, matdt --npa mod 01-08-2011
		FROM
		(	SELECT  brcd,  custseq, MA1, DECODE(timedptp, '000', 'KKH', 'CKH') loai, DECODE(type, 'A', 'To chuc kinh te', 'D', 'To chuc tin dung', 'Ca nhan') kh,
					--DECODE(type, 'C1', 'Khong ky han', DECODE(timedptp, '000', 'Khong ky han', 'Ky han ' || TO_CHAR(to_number(cntrmmtrm)) || DECODE(timedptp, '001', ' ngay', ' thang'))) kyhan,
					DECODE(TYPE, 'C1', 'KHONG KY HAN', DECODE(TIMEDPTP, '000', 'KHONG KY HAN',
					decode(erclint,'017','KY HAN 36 THG LAI ', 'AAA', 'TG NDLSLH 12 THG LAI ', 'BBB', 'TG NDLSLH 18 THG LAI ','CCC', 'KY HAN 60 TUAN LAI ', 'KY HAN ') || TO_CHAR(TO_NUMBER(CNTRMMTRM)) || DECODE(TIMEDPTP, '001', ' NGAY', '002',' THANG', ' TUAN'))) KYHAN,
					ccy, timedptp, cntrmmtrm, clrbal, intamt, kind, type, deptcd, matdt --npa mod 01-08-2011
			FROM
			(	--SELECT brcd, MA1, ccy, timedptp, cntrmmtrm, SUM(DECODE(ccy, 'VND', round(clrbal, 0), round(clrbal, 2))) clrbal, SUM(DECODE(ccy, 'VND', round(intamt, 0), round(intamt, 3))) intamt, kind, type, erclint, custtpcd --tuanem add  custtpcd
				SELECT brcd,  custseq, MA1, ccy, timedptp, cntrmmtrm, SUM(DECODE(ccy, 'VND', round(clrbal, 0), round(clrbal, 2))) clrbal, SUM(DECODE(ccy, 'VND', round(intamt, 0), round(intamt, 3))) intamt, kind, type, erclint, custtpcd, deptcd, matdt --npa mod 01-08-2011
				FROM
				(	--union o day
					SELECT brcd,  custseq,MA1, bsir, ccy, custtpcd, timedptp, cntrmmtrm, SUM(clrbal) clrbal, SUM(intamt) intamt, kind, type, erclint, deptcd, matdt --npa mod 01-08-2011
					FROM
					(	SELECT brcd,  custseq,MA1, bsir, acctcd, ccy, custtpcd, dpintac, timedptp, cntrmmtrm, clrbal, intamt, kind,
								DECODE(dpintac, '801001', 'D', DECODE(kind, 'TIET KIEM', 'C', 'TIET KIEM HH', 'C1', DECODE(custtpcd, '100', 'B', 'A'))) type, erclint, deptcd, matdt --npa mod 01-08-2011
						FROM
						(	SELECT brcd,  custseq, MA1, bsir, acctcd, ccy, custtpcd, dpintac, timedptp, cntrmmtrm, clrbal, intamt,
--									DECODE(acctcd, '433100', 'TIET KIEM HH',DECODE(SUBSTR(acctcd, 1,2),'44','KY PHIEU',DECODE(SUBSTR(acctcd, 1,3), '433', 'TIET KIEM', 'TIEN GUI'))) kind, erclint
							DECODE(acctcd, '433100', 'TIET KIEM HH', '462102', 'GIU HO VANG', DECODE(SUBSTR(acctcd, 1,2),'44','KY PHIEU',DECODE(SUBSTR(acctcd, 1,3), '433', 'TIET KIEM', 'TIEN GUI'))) kind, erclint, deptcd, matdt --npa mod 01-08-2011
							FROM
							(	SELECT brcd, custseq, MA1, bsir,  acctcd, custtpcd, ccy, timedptp, cntrmmtrm, dpintac, clrbal, intamt intamt, erclint, deptcd, matdt--npa mod 01-08-2011
								FROM
								(	SELECT 	brcd, custseq,
											ROUND(DECODE( acctcd, '433100', '0',
													DECODE( TIMEDPTP,'000','0','003',DECODE(TO_CHAR(to_number(nvl(CNTRMMTRM,'000'))),'1','0.25','2','0.5','3','0.75','000'),'002',
														DECODE( CNTRMMTRM,'000','12',TO_CHAR(to_number(nvl(CNTRMMTRM,'000')))),
															DECODE( CNTRMMTRM,'364','12', '365','12','007','0.25','011','0.5','014','0.5','021','0.75','29','1',TO_CHAR(to_number(CNTRMMTRM)/30)))),4) MA1,
											bsir,  acctcd, custtpcd, ccy, timedptp, cntrmmtrm, dpintac, SUM(clrbal) clrbal, SUM(round(clrbal*bsir/1200,3)) intamt, erclint, deptcd, matdt--npa mod 01-08-2011
									FROM
									(
										select a.brcd, b.custseq, a.locdpnm,a.dptpcd,a.bsir,  b.acctcd, a.custtpcd, b.ccy, a.timedptp, a.cntrmmtrm, a.dpintac, sum(b.clrbal) clrbal, a.erclint, a.deptcd, b.matdt--npa mod 01-08-2011--, b.matdt
										from
											(	select sav.brcd, sav.dptpcd, sav.acctseq, dptp.locdpnm, dptp.dpac, sav.ccycd,  dptp.dpintac,
														DECODE(dptp.dpac, '466301', '002', nvl(TRIM(dptp.timedptp), '000')) timedptp,
														--DECODE(dptp.dpac, '466301', '012', nvl(TRIM(dptp.cntrmmtrm), '000')) cntrmmtrm,
														DECODE(dptp.dpac, '466301', '012', decode(sav.erclint, '017', DECODE(dptp.DPCAPFRQTP,	'002100000000', '001',
																										'002200000000', '002',
																										'002300000000', '003',
																										'002600000000', '006',
																										'003200000000', '012',
																										'000000110000', '001',
																										'000000120000', '002',
																										'000000130000', '003',
																										nvl(TRIM(dptp.cntrmmtrm), '000')),nvl(TRIM(dptp.cntrmmtrm), '000'))) cntrmmtrm,
														DECODE(SUBSTR(sav.dptpcd, 1, 1), '6', DECODE(sav.dptpcd,'69R',DECODE(SIGN((bsr.bsir-0.017)-cbl.acmtmdpfrt),1,(bsr.bsir-0.017), cbl.acmtmdpfrt)
																														 ,'69S',DECODE(SIGN((bsr.bsir-0.017)-cbl.acmtmdpfrt),1,(bsr.bsir-0.017), cbl.acmtmdpfrt)
																														 ,'69T',DECODE(SIGN((bsr.bsir-0.017)-cbl.acmtmdpfrt),1,(bsr.bsir-0.017), cbl.acmtmdpfrt),
																											cbl.acmtmdpfrt),
															bsr.bsir) bsir, --tinh lai suat tien gui theo thoi gian thuc gui. LS nao lon hon thi lay LS do
													bsr.bsrtcd, DECODE(gen.custtpcd, '100', gen.custtpcd, '200') custtpcd,
													decode(sav.erclint,'017', decode(nvl(TRIM(dptp.cntrmmtrm),'000'),'012','AAA','018','BBB','060','CCC',sav.erclint),sav.erclint) erclint, --tuanem add
													idx.deptcd --npa mod 01-08-2011
												from  dp1.tbdp_dptp dptp, dp1.tbdp_ccyspec spc, tbdp_savmst sav,
												(select brcd, dptpcd, acctseq, deptcd from dp1.tbdp_idxacct where brcd LIKE '%'       --npa mod 01-08-2011
																					and deptcd like  '%') idx  , --npa mod 01-08-2011
												(	select brcd, dptpcd, acctseq,clrdt, clrbal, acmtmdpfrt
													from dp1.tbdp_sclrbal
													where brcd||dptpcd||acctseq||clrdt in
													(
														select brcd||dptpcd||acctseq||max(clrdt)
														from dp1.tbdp_sclrbal where clrdt <= &h_trdt
														group by brcd, dptpcd, acctseq
													)
												) cbl,
												(	SELECT brcd, bsrtcd, ccycd, bsir
													FROM cs1.tbcs_bsircd
													WHERE appldt <= &h_trdt
													AND nxtappldt > &h_trdt
												) bsr,cm1.tbcm_general gen
												where sav.brcd like '%'
												and dptp.dpac like '4%'
--												and dptp.dpac <> '462102'		----tvkhanh add 20110530 ---------------------npa mod 01-08-2011 rem lai
											   --	and substr(dptp.dpac,1,3)  in ('431','435','466','433','441','442')
												and sav.brcd = dptp.brcd
												and sav.dptpcd = dptp.dptpcd
												and sav.brcd = spc.brcd
												and sav.dptpcd = spc.dptpcd
												and sav.ccycd = spc.ccycd
												and sav.brcd = cbl.brcd
												and sav.dptpcd = cbl.dptpcd
												and sav.acctseq = cbl.acctseq
												and sav.brcd = gen.brcd
												and sav.custseq = gen.custseq
												 and sav.dptpcd not in ('6D1', '6D2', '6D3', '6D4')
												 and sav.ccycd ='GD1'
												AND spc.brcd = bsr.brcd(+)
												AND spc.ccycd = bsr.ccycd(+)
												AND spc.bsrtcd = bsr.bsrtcd(+)
												and sav.brcd	= idx.brcd     (+)   --npa mod 01-08-2011
												and sav.dptpcd 	= idx.dptpcd  (+)
												and sav.acctseq 	= idx.acctseq	 (+)	 --npa mod 01-08-2011
												AND GEN.CUSTTPCD LIKE DECODE( '1','1','100','%')
												AND GEN.CUSTTPCD NOT LIKE DECODE( '1','1','999','2','100','999')
										union all
										select sav.brcd, sav.dptpcd, sav.acctseq, dptp.locdpnm, dptp.dpac, sav.ccycd,  dptp.dpintac,
														DECODE(dptp.dpac, '466301', '002', nvl(TRIM(sav.timedptp), '000')) timedptp,
														--DECODE(dptp.dpac, '466301', '012', nvl(TRIM(sav.cntrmmtrm), '000')) cntrmmtrm,
														DECODE(dptp.dpac, '466301', '012', decode(sav.erclint, '017', DECODE(dptp.DPCAPFRQTP,	'002100000000', '001',
																										'002200000000', '002',
																										'002300000000', '003',
																										'002600000000', '006',
																										'003200000000', '012',
																										'000000110000', '001',
																										'000000120000', '002',
																										'000000130000', '003',
																										nvl(TRIM(sav.cntrmmtrm), '000')),nvl(TRIM(sav.cntrmmtrm), '000'))) cntrmmtrm,
														DECODE(SUBSTR(sav.dptpcd, 1, 1), '6', DECODE(sav.dptpcd,'69R',DECODE(SIGN((bsr.bsir-0.017)-cbl.acmtmdpfrt),1,(bsr.bsir-0.017), cbl.acmtmdpfrt)
																														 ,'69S',DECODE(SIGN((bsr.bsir-0.017)-cbl.acmtmdpfrt),1,(bsr.bsir-0.017), cbl.acmtmdpfrt)
																														 ,'69T',DECODE(SIGN((bsr.bsir-0.017)-cbl.acmtmdpfrt),1,(bsr.bsir-0.017), cbl.acmtmdpfrt),
																											cbl.acmtmdpfrt),
															bsr.bsir) bsir, --tinh lai suat tien gui theo thoi gian thuc gui. LS nao lon hon thi lay LS do
													bsr.bsrtcd, DECODE(gen.custtpcd, '100', gen.custtpcd, '200') custtpcd,
													decode(sav.erclint,'017', decode(nvl(TRIM(sav.cntrmmtrm),'000'),'012','AAA','018','BBB','060','CCC',sav.erclint),sav.erclint) erclint, --tuanem add
													idx.deptcd --npa mod 01-08-2011
												from  dp1.tbdp_dptp dptp, dp1.tbdp_ccyspec spc, tbdp_savmst sav,
												(select brcd, dptpcd, acctseq, deptcd from dp1.tbdp_idxacct where brcd LIKE '%'       --npa mod 01-08-2011
																					and deptcd like  '%') idx  , --npa mod 01-08-2011
												(	select brcd, dptpcd, acctseq,clrdt, clrbal, acmtmdpfrt
													from dp1.tbdp_sclrbal
													where brcd||dptpcd||acctseq||clrdt in
													(
														select brcd||dptpcd||acctseq||max(clrdt)
														from dp1.tbdp_sclrbal where clrdt <= &h_trdt
														group by brcd, dptpcd, acctseq
													)
												) cbl,
												(	SELECT brcd, bsrtcd, ccycd, bsir
													FROM cs1.tbcs_bsircd
													WHERE appldt <= &h_trdt
													AND nxtappldt > &h_trdt
												) bsr,cm1.tbcm_general gen
												where sav.brcd like '%'
												and dptp.dpac like '4%'
												and sav.brcd = dptp.brcd
												and sav.dptpcd = dptp.dptpcd
												and sav.brcd = spc.brcd
												and sav.dptpcd = spc.dptpcd
												and sav.ccycd = spc.ccycd
												and sav.brcd = cbl.brcd
												and sav.dptpcd = cbl.dptpcd
												and sav.acctseq = cbl.acctseq
												and sav.brcd = gen.brcd
												and sav.custseq = gen.custseq
												 and sav.dptpcd in ('6D1', '6D2', '6D3', '6D4')--NH 20110804
												 and sav.ccycd ='GD1'
												AND spc.brcd = bsr.brcd(+)
												AND spc.ccycd = bsr.ccycd(+)
												AND spc.bsrtcd = bsr.bsrtcd(+)
												and sav.brcd	= idx.brcd     (+)   --npa mod 01-08-2011
												and sav.dptpcd 	= idx.dptpcd  (+)
												and sav.acctseq 	= idx.acctseq	 (+)	 --npa mod 01-08-2011
												AND GEN.CUSTTPCD LIKE DECODE( '1','1','100','%')
												AND GEN.CUSTTPCD NOT LIKE DECODE( '1','1','999','2','100','999')
										--NH 20110804 end
										union all
											select sav.brcd, sav.dptpcd, sav.acctseq, dptp.locdpnm, dptp.dpac, sav.ccycd,  dptp.dpintac,
											DECODE(dptp.dpac, '466301', '002', nvl(TRIM(dptp.timedptp), '000')) timedptp,
											DECODE(dptp.dpac, '466301', '012', nvl(TRIM(dptp.cntrmmtrm), '000')) cntrmmtrm,   	bsr.bsir,

											bsr.bsrtcd, DECODE(gen.custtpcd, '100', gen.custtpcd, '200') custtpcd, '000' erclint, idx.deptcd --npa mod 01-08-2011
											from  dp1.tbdp_dptp dptp, dp1.tbdp_ccyspec spc, tbdp_dmdmst sav,
											(select brcd, dptpcd, acctseq, deptcd from dp1.tbdp_idxacct where brcd LIKE '%'--npa mod 01-08-2011
																										and deptcd like  '%') idx,     --npa mod 01-08-2011
											(	select brcd, bsrtcd, ccycd, bsir
												from cs1.tbcs_bsircd
												where appldt <= &h_trdt and nxtappldt > &h_trdt
											) bsr,
											cm1.tbcm_general gen
											where sav.brcd like '%'
											and dptp.dpac like '4%'
											and dptp.dptpcd <> '218'     ----tvkhanh add 20110530
											and sav.brcd = dptp.brcd
											and sav.dptpcd = dptp.dptpcd
											and sav.brcd = spc.brcd
											and sav.dptpcd = spc.dptpcd
											and sav.ccycd = spc.ccycd
											and spc.brcd = bsr.brcd
											and spc.ccycd = bsr.ccycd
											and spc.bsrtcd = bsr.bsrtcd
											and sav.brcd = gen.brcd
											and sav.custseq = gen.custseq
											and sav.ccycd ='GD1'
											AND GEN.CUSTTPCD LIKE DECODE( '1','1','100','%')
											AND GEN.CUSTTPCD NOT LIKE DECODE( '1','1','999','2','100','999')
											and sav.brcd	= idx.brcd     (+)               --npa mod 01-08-2011
											and sav.dptpcd 	= idx.dptpcd  (+)
											and sav.acctseq 	= idx.acctseq	 (+)      --npa mod 01-08-2011
											)      a, tbgl_baldd b  , CM1.TBCM_INTERESTH itr
										where a.brcd =b.brcd
										and a.dptpcd =b.trref
										and a.acctseq =b.trseq
										and b.trdt = &h_trdt
										and b.trref <> 'GEO'
										and b.clrbal > 0
										and b.ccy = 'GD1'
										and b.brcd <>'1000' --them vao
										and b.acctcd  not in ('466400', '466200') --them vao
										and b.brcd = itr.brcd (+)
										and b.custseq = itr.custseq (+)
										and &h_trdt between to_char(itr.regdt(+), 'YYYYMMDD') and gradeupdt(+)
										and gradecd(+) not in ('10', '20')
										--and ((:h_vip = '1' and itr.custseq is not null) or (:h_vip = '0'))
										group by a.brcd, b.custseq,  a.locdpnm,a.dptpcd,a.bsir,  b.acctcd, a.custtpcd, b.ccy, a.timedptp, a.cntrmmtrm, a.dpintac,  a.erclint, a.deptcd, b.matdt--npa mod 01-08-2011--,  b.matdt
									)
									GROUP BY brcd, custseq, ROUND(DECODE( acctcd, '433100', '0',
													DECODE( TIMEDPTP,'000','0','003',DECODE(TO_CHAR(to_number(nvl(CNTRMMTRM,'000'))),'001','0.25','002','0.5','003','0.75','000'),'002',
														DECODE( CNTRMMTRM,'000','12',TO_CHAR(to_number(nvl(CNTRMMTRM,'000')))),
															DECODE( CNTRMMTRM,'364','12', '365','12','007','0.25','011','0.5','014','0.5','021','0.75','29','1',TO_CHAR(to_number(CNTRMMTRM)/30)))),4),
											 bsir, acctcd, custtpcd, ccy, timedptp, cntrmmtrm, dpintac,  erclint, deptcd, matdt --npa mod 01-08-2011
								)
							)
						)
					)
					GROUP BY brcd, custseq, MA1,  bsir, ccy, custtpcd, timedptp, cntrmmtrm, kind, type, erclint, deptcd, matdt --npa mod 01-08-2011


				)
				GROUP BY brcd,  custseq, MA1, ccy, timedptp, cntrmmtrm, kind, type, erclint, custtpcd, deptcd, matdt--npa mod 01-08-2011
			)
			ORDER BY brcd, custseq, type, ccy, kind, timedptp, cntrmmtrm, deptcd, matdt--npa mod 01-08-2011
		)
	)
)
GROUP BY brcd, ccy, TK, MA1, TYPE, KYHAN, deptcd, matdt
