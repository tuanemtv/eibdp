--define h_trdt='20120531'

SELECT 	 A.brcd CN,
	 A.deptcd PGD,
	 A.custseq CIF,
	 A.regdt NG_DK,
	 A.REGDTF ng_ch,
	 A.nmloc TEN,
	 A.ccy LOAI_TIEN,
	 A.clrbal SD,
	 A.balex SD_QD
FROM
(
	SELECT	 bal.brcd,
		 idx.deptcd,
		 cmx.custseq,
		 cmx.regdt,
		 SUBSTRB(cmx.regdt,7,2)||'/'||SUBSTRB(cmx.regdt,5,2)||'/'||SUBSTRB(cmx.regdt,1,4) REGDTF,
		 cmx.nmloc,
		 bal.ccy,
		 bal.clrbal,
		 cs1.excrosscal(bal.brcd, 'VND', &h_trdt, bal.ccy, bal.clrbal, '01', 'VND', '01') balex
	FROM
	(	select distinct custseq, regdt,nmloc
		from cm1.tbcm_general gen
		where gen.brcd <> '1000'
			and gen.regdt between '20120101' and &h_trdt
			and gen.custtpcd = '100' -- ca nhan			
	) cmx, gl1.tbgl_baldd bal, dp1.tbdp_idxacct idx
	WHERE bal.trdt = &h_trdt
		and bal.custseq = cmx.custseq
		and bal.buscd = 'DP'		
		and bal.brcd = idx.brcd
		and bal.trref = idx.dptpcd
		and bal.trseq = idx.acctseq
		and bal.custseq not in (	select code custseq
									from race.t_code
									where cat_name ='PREPAIDCUST'
									and country ='VN'
								)	
	ORDER BY bal.BRCD,deptcd,cmx.custseq,clrbal
) A
