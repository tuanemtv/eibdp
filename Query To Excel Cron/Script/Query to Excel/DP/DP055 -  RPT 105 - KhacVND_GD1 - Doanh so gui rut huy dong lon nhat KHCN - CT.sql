--define h_trdt ='20121002'


select detail.BRCD, detail.CUSTSEQ, detail.NM, detail.IDXACNO,
		ccycd,
		detail.GUI,
		cs1.excrosscal('1000', 'VND', &h_trdt, CCYCD, nvl(detail.GUI,0), '01', 'VND', '01') QD_GUI,
		detail.RUT,
		cs1.excrosscal('1000', 'VND', &h_trdt, CCYCD, nvl(detail.RUT,0), '01', 'VND', '01') QD_RUT,
		detail.CHENHLECH,
		cs1.excrosscal('1000', 'VND', &h_trdt, CCYCD, nvl(detail.CHENHLECH,0), '01', 'VND', '01') QD_CHENHLECH,
		detail.HBRCD, detail.HUSRID,	detail.DEPTNMLOC, detail.REM,	 detail.OPNDT, detail.LOCDPNM,	detail.LS, com.chenhlech_th,
		matdt, loai,
		clsdt, opndt,
		decode(substr(detail.IDXACNO,5,1),'6',
		DECODE(opndt, clsdt,'DUNG HAN',decode(TRIM(clsdt),'','','TRUOC HAN')),'') TT
from
(
	select 	ccycd,brcd, custseq, nm, DPTOTAMT_VND, WDTOTAMT_VND, chenhlech chenhlech_th
	from
	(
		select 	ccycd,brcd, nm, custseq, sum(DPTOTAMT_VND) DPTOTAMT_VND,sum(WDTOTAMT_VND) WDTOTAMT_VND,
				decode(sign(SUM(DPTOTAMT_VND)-SUM(WDTOTAMT_VND)),1,(SUM(DPTOTAMT_VND)-SUM(WDTOTAMT_VND)),(SUM(WDTOTAMT_VND)-	SUM(DPTOTAMT_VND))) chenhlech
		from
		(	select a.brcd,a.custseq, a.nm, sum(a.sodu) DPTOTAMT_VND , a.ccycd, sum(a.sodu) ,0 WDTOTAMT_VND
			from
			(	select a.brcd,a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu , a.ccycd , a.clsflg , a.opndt
				from tbdp_savmst a, tbcm_general b, tbdp_dptp c , tbdp_trlst d, tbdp_idxacct idx
				where a.brcd like '%'
				and a.brcd=b.brcd
				and a.custseq=b.custseq
				and a.opncnclflg='0'
				and d.cncltrflg='0'
				and d.tgtflg='0'
				and a.brcd=c.brcd
				and a.dptpcd = c.dptpcd
				and a.brcd=idx.brcd
				and a.dptpcd=idx.dptpcd
				and a.acctseq=idx.acctseq
				and idx.deptcd like '%'
				and a.ccycd not IN ('VND','GD1')
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%') or (c.dpac like '462%') )
				and c.dpac not in ('466101','466102','466201','466202')
				and a.brcd=d.brcd
				and a.dptpcd=d.dptpcd
				and a.acctseq=d.acctseq
				and b.custtpcd like '1%'
				and d.trcd in('W060','W160')
				and d.trdt  = &h_trdt

				union all
				select a.brcd,a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu , a.ccycd , a.clsflg , a.opndt
				from tbdp_dmdmst a, tbcm_general b    , tbdp_dptp c , tbdp_trlst d, tbdp_idxacct idx
				where a.brcd like '%'
				and a.brcd=b.brcd
				and a.custseq=b.custseq
					and a.brcd=idx.brcd
					and a.dptpcd=idx.dptpcd
					and a.acctseq=idx.acctseq
					and idx.deptcd like '%'
				and a.opncnclflg='0'
				and d.cncltrflg='0'
				and d.tgtflg='0'
				and a.brcd=c.brcd
				and a.dptpcd = c.dptpcd
				and a.ccycd not in ('GD1','VND')
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%') or (c.dpac like '462%'))
				and c.dpac not in ('466101','466102','466201','466202')
				and b.custtpcd like '1%'
				and a.brcd=d.brcd
				and a.dptpcd=d.dptpcd
				and a.acctseq=d.acctseq
				and d.bftrbal<=d.aftrbal
				and d.trdt  = &h_trdt
			) a
			group by    brcd, custseq, nm, idxacno,  ccycd

			UNION ALL
			select a.brcd,a.custseq, a.nm,0 DPTOTAMT_VND , a.ccycd, a.sodu,a.sodu WDTOTAMT_VND
			from
			(	select brcd, custseq, nm, idxacno, sum(sodu) sodu, ccycd
				from
				(	select a.brcd,a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu , a.ccycd , a.clsflg , a.opndt
					from tbdp_savmst a, tbcm_general b, tbdp_trlst d   , tbdp_dptp c, tbdp_idxacct idx
					where a.brcd like '%'
					and a.brcd=b.brcd
					and a.custseq=b.custseq
					and a.opncnclflg='0'
					and d.cncltrflg='0'
					and d.tgtflg='0'
					and a.brcd=d.brcd
					and a.dptpcd=d.dptpcd
					and a.acctseq=d.acctseq
						and a.brcd=idx.brcd
					and a.dptpcd=idx.dptpcd
					and a.acctseq=idx.acctseq
					and idx.deptcd like  '%'
					and d.trcd ='W360'
					and a.brcd=c.brcd
					and a.dptpcd = c.dptpcd
					and a.ccycd not IN ('GD1','VND')
					and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%') or (c.dpac like '462%'))
					and c.dpac not in ('466101','466102','466201','466202')
					and b.custtpcd like '1%'
					and d.trdt  = &h_trdt

					union all
					select a.brcd,a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu , a.ccycd , a.clsflg , a.opndt
					from tbdp_dmdmst a, tbcm_general b, tbdp_trlst d   , tbdp_dptp c, tbdp_idxacct idx
					where a.brcd like '%'
					and a.brcd=b.brcd
					and a.custseq=b.custseq
					and a.opncnclflg='0'
					and d.cncltrflg='0'
					and d.tgtflg='0'
					and a.brcd=d.brcd
					and a.dptpcd=d.dptpcd
					and a.acctseq=d.acctseq
						and a.brcd=idx.brcd
					and a.dptpcd=idx.dptpcd
					and a.acctseq=idx.acctseq
					and idx.deptcd like '%'
					and a.brcd=c.brcd
					and a.dptpcd = c.dptpcd
					and a.ccycd not in ('VND','GD1')
					and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%') or (c.dpac like '462%'))
					and c.dpac not in ('466101','466102','466201','466202')
					and b.custtpcd like '1%'
					and d.bftrbal>d.aftrbal
					and d.trdt  = &h_trdt
				)
				group by    brcd, custseq, nm, idxacno,  ccycd
			) A
		)
		group by brcd, custseq, nm,ccycd
		ORDER BY chenhlech   desc
	)
)com,
(
	select 	result1.brcd, nm, custseq, idxacno,  gui, rut, chenhlech,	hbrcd, husrid, deptnmloc, rem, clsdt, locdpnm, ls, matdt, loai,  opndt
	from
	(
		select 	brcd, nm, custseq, idxacno, sum(DPTOTAMT_VND) gui,sum(WDTOTAMT_VND) rut,
				decode(sign(SUM(DPTOTAMT_VND)-SUM(WDTOTAMT_VND)),1,(SUM(DPTOTAMT_VND)-SUM(WDTOTAMT_VND)),(SUM(WDTOTAMT_VND)-	SUM(DPTOTAMT_VND))) chenhlech,
				hbrcd, husrid, rem, locdpnm, clsdt, ls, matdt, loai,  opndt
		from
		(
			select a.brcd,a.custseq, a.nm,a.idxacno, sum(a.sodu) DPTOTAMT_VND, a.ccycd, sum(a.sodu) ,0 WDTOTAMT_VND, hbrcd, husrid, rem, locdpnm,  ls, matdt,
					decode (substr(dpac,1,3),'433','TIET KIEM','TIEN GUI') LOAI, clsdt, opndt
			from
			(
				select b.brcd, a.custseq, b.nm, a.idxacno, d.ACCTCCYDPAMT sodu, a.ccycd, a.clsflg, d.hbrcd, d.husrid, d.rem, c.locdpnm, scl.acmtmdpfrt ls,
						decode(c.erclint,'017',NXTDPCAPDT,a.matdt) matdt, c.dpac,
						a.clsdt, decode(c.erclint,'017',decode(trim(a.PREDPCAPDT),'',a.OPNDT,a.PREDPCAPDT),a.OPNDT) OPNDT
				from tbdp_savmst a, tbcm_general b, tbdp_dptp c , tbdp_trlst d, tbdp_sclrbal scl, tbdp_idxacct idx
				where a.brcd like '%'
				and a.brcd=b.brcd
				and a.custseq=b.custseq
				and a.opncnclflg='0'
				and d.cncltrflg='0'
				and d.tgtflg='0'
				and a.brcd=c.brcd
				and a.dptpcd = c.dptpcd
				and a.brcd=idx.brcd
				and a.dptpcd=idx.dptpcd
				and a.acctseq=idx.acctseq
				and idx.deptcd like  '%'
				and a.ccycd not IN ('GD1','VND')
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%') or (c.dpac like '462%') )
				and c.dpac not in ('466101','466102','466201','466202')
				and b.custtpcd like '1%'
				and a.brcd=d.brcd
				and a.dptpcd=d.dptpcd
				and a.acctseq=d.acctseq
				and d.trcd in('W060','W160')
				and d.trdt  = &h_trdt
				and d.brcd=scl.brcd
				and d.dptpcd=scl.dptpcd
				and d.acctseq=scl.acctseq
				and scl.clrdt=
				(	SELECT MAX(D.CLRDT)
					FROM TBDP_SCLRBAL D
					WHERE D.BRCD = scl.BRCD
					AND D.DPTPCD = scl.DPTPCD
					AND D.ACCTSEQ = scl.ACCTSEQ
					AND D.CLRDT <= &h_trdt
				)

				union all
				select  dmd.brcd,
							dmd.custseq,
							gen.nm,
							dmd.idxacno,
							trl.ACCTCCYDPAMT sodu ,
							dmd.ccycd ,
							dmd.clsflg ,
							trl.hbrcd,
							trl.husrid,
							trl.rem,
							dptp.locdpnm,
							bsi.bsir ls,
							'99991231' matdt,
							dptp.dpac,
							dmd.clsdt,
							dmd.opndt
				from tbdp_dmdmst dmd, tbcm_general gen, tbdp_dptp dptp, tbdp_trlst trl, tbcs_bsircd bsi, tbdp_ccyspec spc, tbdp_idxacct idx
				where dmd.brcd=gen.brcd -- TBDP_DMDMST<->TBCM_GENERAL
				and dmd.custseq=gen.custseq
				and dmd.brcd=dptp.brcd -- TBDP_DMDMST<->TBDP_DPTP
				and dmd.dptpcd = dptp.dptpcd
				and dmd.brcd=trl.brcd   --TBDP_DMDMST<->TBDP_TRLST
				and dmd.dptpcd=trl.dptpcd
				and dmd.acctseq=trl.acctseq
				and dmd.brcd = spc.brcd  --TBDP_DMDMST<->TBDP_CCYSPEC
				and dmd.dptpcd = spc.dptpcd
				and dmd.ccycd = spc.ccycd
				and dmd.brcd = bsi.brcd    --TBDP_DMDMST<-> TBCS_BSIRCD
				and dmd.ccycd = bsi.ccycd
				and bsi.brcd = spc.brcd     --TBCS_BSIRCD<-> TBDP_CCYSPEC
				and bsi.ccycd =spc.ccycd
				and bsi.bsrtcd = spc.bsrtcd
				and dmd.brcd=idx.brcd
				and dmd.dptpcd=idx.dptpcd
				and dmd.acctseq=idx.acctseq
				and idx.deptcd like '%'
				and dmd.brcd like '%'
				and dmd.opncnclflg='0'
				and trl.cncltrflg='0'
				and trl.tgtflg='0'
				and dmd.ccycd not in ('GD1','VND')
				and ((dptp.dpac  like '431100') or (dptp.dpac like '433100') or  (dptp.dpac like '435100') or (dptp.dpac like '466%') or (dptp.dpac like '462%'))
				and dptp.dpac not in ('466101','466102','466201','466202','466901','466301')
				and gen.custtpcd like '1%'
				and bsi.nxtappldt = '99991231'
				and trl.bftrbal<=trl.aftrbal
				and trl.trdt  = &h_trdt
			) a
			group by    brcd, custseq, nm, idxacno,  ccycd,  hbrcd, husrid, rem, opndt, locdpnm, clsdt, ls, matdt, dpac

			UNION ALL
			select a.brcd,a.custseq, a.nm,a.idxacno, 0 DPTOTAMT_VND , a.ccycd, sum(a.sodu),sum(a.sodu) WDTOTAMT_VND, hbrcd, husrid, rem, locdpnm,  ls,
				   matdt, decode (substr(dpac,1,3),'433','TIET KIEM','TIEN GUI') LOAI, clsdt, opndt
			from
			(
				select b.brcd, a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu, a.ccycd, a.clsflg, d.hbrcd, d.husrid, d.rem, c.locdpnm,  scl.acmtmdpfrt ls,
						decode(c.erclint,'017',NXTDPCAPDT,a.matdt) matdt, c.dpac,
						a.clsdt clsdt, decode(c.erclint,'017',decode(trim(a.PREDPCAPDT),'',a.OPNDT,a.PREDPCAPDT),a.OPNDT) OPNDT
				from tbdp_savmst a, tbcm_general b, tbdp_dptp c , tbdp_trlst d, tbdp_sclrbal scl, tbdp_idxacct idx
				where a.brcd like '%'
				and a.brcd=b.brcd
				and a.custseq=b.custseq
				and a.opncnclflg='0'
				and d.cncltrflg='0'
				and d.tgtflg='0'
				and a.brcd=c.brcd
				and a.dptpcd = c.dptpcd
				and a.ccycd not in ('GD1','VND')
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%') or (c.dpac like '462%'))
				and c.dpac not in ('466101','466102','466201','466202')
				and b.custtpcd like '1%'
				and a.brcd=d.brcd
				and a.dptpcd=d.dptpcd
				and a.acctseq=d.acctseq
				and d.trcd ='W360'
				and d.trdt  = &h_trdt
				and d.brcd=scl.brcd
				and d.dptpcd=scl.dptpcd
				and d.acctseq=scl.acctseq
				and a.brcd=idx.brcd
					and a.dptpcd=idx.dptpcd
					and a.acctseq=idx.acctseq
					and idx.deptcd like '%'
				and scl.clrdt=
				(	SELECT MAX(D.CLRDT)
					FROM TBDP_SCLRBAL D
					WHERE D.BRCD = scl.BRCD
					AND D.DPTPCD = scl.DPTPCD
					AND D.ACCTSEQ = scl.ACCTSEQ
					AND D.CLRDT <= &h_trdt
				)

				union all
				select a.brcd,a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu , a.ccycd , a.clsflg , d.hbrcd, d.husrid, d.rem, c.locdpnm, bsi.bsir ls,
					'99991231' matdt,
					c.dpac,
					a.clsdt,
					a.opndt
				 from tbdp_dmdmst a, tbcm_general b, tbdp_trlst d   , tbdp_dptp c, tbcs_bsircd bsi, tbdp_ccyspec spc, tbdp_idxacct idx
				 where a.brcd like '%'
				 and a.brcd=b.brcd
				 and a.custseq=b.custseq
				 and a.opncnclflg='0'
				 and d.cncltrflg='0'
				 and d.tgtflg='0'
				 and a.brcd=c.brcd
				 and a.dptpcd = c.dptpcd
				 and a.ccycd not in ('GD1','VND')
				 and ((c.dpac  like '431100') or (c.dpac like '433100') or  (c.dpac like '435100') or (c.dpac like '466%') or (c.dpac like '462%'))
				 and c.dpac not in ('466101','466102','466201','466202','466901','466301')
				 and b.custtpcd like '1%'
				 and d.bftrbal>d.aftrbal
				 and a.brcd=d.brcd
				 and a.dptpcd=d.dptpcd
				 and a.acctseq=d.acctseq
				 and d.trdt  = &h_trdt
				 and a.brcd = bsi.brcd
				 and a.ccycd = bsi.ccycd
				 and a.brcd = spc.brcd
				 and a.dptpcd = spc.dptpcd
				 and a.ccycd = spc.ccycd
				 and bsi.brcd =spc.brcd
				 and bsi.ccycd =spc.ccycd
				 and bsi.bsrtcd = spc.bsrtcd
				 and a.brcd=idx.brcd
				and a.dptpcd=idx.dptpcd
				and a.acctseq=idx.acctseq
				and idx.deptcd like '%'
				 and bsi.nxtappldt = '99991231'
			) a
			group by brcd, custseq, nm, idxacno,  ccycd,  hbrcd, husrid, rem, locdpnm, clsdt, ls, matdt, dpac,  opndt
		)
		group by brcd, custseq, nm, idxacno,  ccycd,  hbrcd, husrid, rem,  locdpnm, clsdt, ls, matdt, loai,  opndt
		ORDER BY custseq || (SUM(WDTOTAMT_VND)-	SUM(DPTOTAMT_VND))  desc
	) result1,
	(	select usr.BRCD, USRID,  BUSCD, DEPTNM, DEPTNMLOC
		from TBRC_USR1 usr, TBCS_DEPTCD dep
		where usr.DEPTCD=dep.DEPTCD
	) usr
	where result1.hbrcd=usr.brcd
	and result1.husrid=usr.usrid
)detail
WHERE  com.CUSTSEQ(+)=detail.CUSTSEQ
AND com.BRCD=detail.BRCD
ORDER BY com.chenhlech_th DESC, detail.BRCD, detail.NM, detail.CUSTSEQ, detail.CHENHLECH ASC

