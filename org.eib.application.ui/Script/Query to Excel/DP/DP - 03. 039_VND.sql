--DEFINE h_trdt = '20100923'
--DEFINE h_startdt = '20090631'
--DEFINE h_enddt = '20090530'
SELECT TK, TYPE, KYHAN, sum(clrbal), sum(intamt), ROUND(SUM(intamt)/SUM(clrbal)*100, 4) LSBQ
FROM
	(	SELECT TK, TYPE,DECODE(TIMEDPTP,'002', KYHAN, '000', KYHAN,DECODE(CNTRMMTRM,'364',KYHAN, '001', 'TK qua dem', '002', 'TK Call 48h', 'Ky han '||round(nvl(CNTRMMTRM,'000')/7)||' tuan'))KYHAN,clrbal, intamt, lsbq, TIMEDPTP, CNTRMMTRM			/* Tach KH < 1 thang thanh 1 tuan, 2 tuan, 3 tuan ... Quang Tu 2008.06.09  */
		FROM
		(	select decode(kind,'TIEN GUI',decode(loai, 'KKH',DECODE(type,'D','3.1','1.1'),DECODE(type,'D','3.2','1.2')),'KY PHIEU','4',decode(loai, 'KKH','2.1','2.2')) TK, type, kyhan, clrbal, intamt, lsbq, TIMEDPTP, CNTRMMTRM
			from
  			(	select decode(timedptp, '000', 'KKH', 'CKH') loai, decode(type, 'A', 'To chuc kinh te', 'D', 'To chuc tin dung', 'Ca nhan') kh, decode(type, 'C1', 'Khong ky han', decode(timedptp, '000', 'Khong ky han', 'Ky han ' || to_char(to_number(cntrmmtrm)) || decode(timedptp, '001', ' ngay', ' thang'))) kyhan, ccy, timedptp, cntrmmtrm, clrbal, intamt, kind, type, round(intamt/clrbal*100, 4) lsbq
				from
				(	select ccy, timedptp, cntrmmtrm, sum(decode(ccy, 'VND', round(clrbal, 0), round(clrbal, 2))) clrbal, sum(decode(ccy, 'VND', round(intamt, 0), round(intamt, 2))) intamt, kind, type
					from
					(	select bsir, ccy, custtpcd, timedptp, cntrmmtrm, sum(clrbal) clrbal, sum(intamt) intamt, kind, type
						from
						(	select bsir, acctcd, ccy, custtpcd, dpintac, timedptp, cntrmmtrm, clrbal, intamt, kind, 	decode(dpintac, '801001', 'D', decode(kind, 'TIET KIEM', 'C', 'TIET KIEM HH', 'C1', decode(custtpcd, '100', 'B', 'A'))) type
							from
							(	select bsir, acctcd, ccy, custtpcd, dpintac, timedptp, cntrmmtrm, clrbal, intamt, decode(acctcd, '433100', 'TIET KIEM HH', decode(substr(acctcd, 1,2),'44','KY PHIEU',decode(substr(acctcd, 1,3), '433', 'TIET KIEM', 'TIEN GUI'))) kind
								from
								(	select bsir,  acctcd, custtpcd, ccy, timedptp, cntrmmtrm, dpintac, sum(clrbal) clrbal, sum(round(clrbal*bsir/100/decode(ccy, 'VND', 1, 12), 2)) intamt
									from
									(
										select a.bsir,  a.acctcd, a.custtpcd, a.ccy, a.timedptp, a.cntrmmtrm, a.dpintac, (b.clrbal) clrbal
										from
											(	select distinct sav.brcd, sav.dptpcd,sav.acctseq, dptp.locdpnm, dptp.dpac acctcd , sav.ccycd ccy,
												dptp.dpintac,
												decode(dptp.dpac, '466301', '002', nvl(trim(sav.timedptp), '000')) timedptp,
												decode(dptp.dpac, '466301', '012', nvl(trim(sav.cntrmmtrm), '000')) cntrmmtrm,
												decode(substr(sav.dptpcd, 1, 1), '6', cbl.acmtmdpfrt) bsir,-- bsr.bsrtcd,
												decode(gen.custtpcd, '100', gen.custtpcd, '200') custtpcd
												from  dp1.tbdp_dptp dptp, dp1.tbdp_ccyspec spc, tbdp_savmst sav,
												(	select brcd, dptpcd, acctseq,clrdt, clrbal, acmtmdpfrt
													from dp1.tbdp_sclrbal
													where brcd||dptpcd||acctseq||clrdt in
													(	select bal1.brcd||bal1.dptpcd||bal1.acctseq||max(bal1.clrdt)
														from dp1.tbdp_sclrbal bal1, gl1.tbgl_baldd bad
														where bal1.clrdt <= &h_trdt
															and bal1.brcd = bad.brcd
															and bal1.dptpcd = bad.trref
															and bal1.acctseq = bad.trseq
															and bad.trdt = &h_trdt
														group by bal1.brcd, bal1.dptpcd, bal1.acctseq
													)
												) cbl,
												cm1.tbcm_general gen
												where sav.brcd like '%'
												and dptp.dpac like '4%'
												and substr(dptp.dpac,1,3)  in ('431','435','466','433','441','442')
												and sav.brcd = dptp.brcd
												and sav.dptpcd = dptp.dptpcd
												and sav.brcd = spc.brcd
												and sav.dptpcd = spc.dptpcd
												and sav.ccycd = spc.ccycd
												and sav.brcd = cbl.brcd--(+)
												and sav.dptpcd = cbl.dptpcd--(+)
												and sav.acctseq = cbl.acctseq--(+)
												and sav.brcd = gen.brcd
												and sav.custseq = gen.custseq
											   --	and sav.ccycd ='VND'
												group by sav.brcd, sav.dptpcd, sav.acctseq,dptp.locdpnm, dptp.dpac, gen.custtpcd, sav.ccycd, dptp.dpintac,
														decode(dptp.dpac, '466301', '002', nvl(trim(sav.timedptp), '000')),
														decode(dptp.dpac, '466301', '012', nvl(trim(sav.cntrmmtrm), '000')),
														decode(substr(sav.dptpcd, 1, 1), '6', cbl.acmtmdpfrt)--, bsr.bsrtcd
											union all

	   										select sav.brcd, sav.dptpcd,sav.acctseq,dptp.locdpnm, dptp.dpac acctcd , sav.ccycd ccy,
											dptp.dpintac,
											decode(dptp.dpac, '466301', '002', nvl(trim(dptp.timedptp), '000')) timedptp,
											decode(dptp.dpac, '466301', '012', nvl(trim(dptp.cntrmmtrm), '000')) cntrmmtrm,
											bsr.bsir bsir,-- bsr.bsrtcd,
											decode(gen.custtpcd, '100', gen.custtpcd, '200') custtpcd
											from  dp1.tbdp_dptp dptp, dp1.tbdp_ccyspec spc, tbdp_dmdmst sav,
											(	select brcd, bsrtcd, ccycd, bsir
												from cs1.tbcs_bsircd
												where appldt <= &h_trdt and nxtappldt > &h_trdt
											) bsr,
											cm1.tbcm_general gen
											where sav.brcd like '%'
											and dptp.dpac like '4%'
											and substr(dptp.dpac,1,3)  in ('431','435','466','433','441','442')
											and sav.brcd = dptp.brcd
											and sav.dptpcd = dptp.dptpcd
											and sav.brcd = spc.brcd
											and sav.dptpcd = spc.dptpcd
											and sav.ccycd = spc.ccycd
											and spc.brcd = bsr.brcd--(+)
											and spc.ccycd = bsr.ccycd--(+)
											and spc.bsrtcd = bsr.bsrtcd--(+)
											and sav.brcd = gen.brcd
											and sav.custseq = gen.custseq
										  --	and sav.ccycd ='VND'
											group by  sav.brcd, sav.dptpcd,sav.acctseq, dptp.locdpnm, dptp.dpac, gen.custtpcd, sav.ccycd, dptp.dpintac,
													decode(dptp.dpac, '466301', '002', nvl(trim(dptp.timedptp), '000')),
													decode(dptp.dpac, '466301', '012', nvl(trim(dptp.cntrmmtrm), '000')),
													bsr.bsir--, bsr.bsrtcd

											)      a, tbgl_baldd b
									where a.brcd =b.brcd
									and a.dptpcd =b.trref
									and a.acctseq =b.trseq
									and b.trdt = &h_trdt
									and b.trref <> 'GEO'
									and b.clrbal > 0
									and b.brcd <>'1000' --them vao
									and b.acctcd  not in ('466400', '466200') --them vao
 								)
									group by bsir, acctcd, custtpcd, ccy, timedptp, cntrmmtrm, dpintac
								)
								where ccy = 'VND'
							)
						)
						group by bsir, ccy, custtpcd, timedptp, cntrmmtrm, kind, type

						union all

						select intrt bsir, ccy, '800' custtpcd, trim(timedptp), trim(cntrmmtrm), sum(clrbal) clrbal, sum(round(clrbal*intrt/100/12, 2)) intamt, 'TIEN GUI' kind, 'D' type
						from
						(	select brcd, substr(trref, 1, 1) dltpcd, substr(trref, 2, 2) sbtpcd, trseq, ccy, clrbal
							from gl1.tbgl_baldd
							where trdt = &h_trdt
							and brcd like '%'
							and brcd <> decode(sign(&h_trdt - '20070806'), -1, '2000', ' ')
							and onofftp = '1'
							and ccy = 'VND'
							and (acctcd like '41%' or acctcd like '421%')
							and buscd = 'DL'
							and clrbal > 0
						) bal,
						(	select brcd, dltpcd, sbtpcd, dlseqno, decode(sign(daycnt - 30), 1, to_char(daycnt/30, '000'), to_char(daycnt, '000')) cntrmmtrm, intrt, decode(sign(daycnt - 30), 1, '002', '001') timedptp
							from dl1.tbdl_mm
							where brcd like '%'
							group by brcd, dltpcd, sbtpcd, dlseqno, daycnt, intrt
						) dlm
						where bal.dltpcd = dlm.dltpcd
						and bal.sbtpcd = dlm.sbtpcd
						and bal.trseq = dlm.dlseqno
						and bal.brcd=dlm.brcd
						group by intrt, ccy, timedptp, cntrmmtrm

						union all

						select bsir, bal.ccy, custtpcd, '000' timedptp, '000' cntrmmtrm, sum(clrbal) clrbal, sum(clrbal*bsir/100/decode(ccy, 'VND', 1, 12)) intamt, 'TIEN GUI' kind, decode(custtpcd, '100', 'B', 'A') type
						from
						(	select  brcd, custseq, ccy, tdbal clrbal
							from gl1.tbgl_mast
							where trdt = &h_trdt
							and brcd like '%'
							and brcd <> decode(sign(&h_trdt - '20070806'), -1, '2000', ' ')
							and onofftp = '1'
							and acctcd in ('466200', '466400')
							and tdbal > 0
						) bal,
						(	select brcd, ccycd, bsir
							from cs1.tbcs_bsircd
							where brcd like '%'
							and brcd <> decode(sign(&h_trdt - '20070806'), -1, '2000', ' ')
							and bsrtcd = 'A0'
							and ccycd = 'VND'
							and appldt <= &h_trdt
							and nxtappldt > &h_trdt
						) bsr, cm1.tbcm_general gen
						where bal.brcd = bsr.brcd
						and bal.ccy = bsr.ccycd
						and bal.brcd = gen.brcd
						and bal.custseq = gen.custseq
						group by bsir, bal.ccy, custtpcd, decode(custtpcd, '100', 'B', 'A')
					)
					group by ccy, timedptp, cntrmmtrm, kind, type
				)
				order by type, ccy, kind, timedptp, cntrmmtrm
			)
		)
	)
	GROUP BY TK, TYPE, KYHAN
	ORDER BY  TK, TYPE, length(KYHAN),KYHAN
