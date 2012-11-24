--define h_trdt ='20111004'

select detail.BRCD, detail.CUSTSEQ, detail.NM, detail.IDXACNO,	detail.GUI, detail.RUT,	 detail.CHENHLECH,	 detail.HBRCD, detail.HUSRID,	detail.DEPTNMLOC, detail.REM,	 detail.OPNDT,	detail.clsdt,	detail.LOCDPNM,	detail.LS, com.chenhlech_th					
from
(
	select 	brcd, custseq, nm, DPTOTAMT_VND, WDTOTAMT_VND, chenhlech chenhlech_th
	from
	(
		select 	brcd, nm, custseq, sum(DPTOTAMT_VND) DPTOTAMT_VND,sum(WDTOTAMT_VND) WDTOTAMT_VND,
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
				and a.ccycd = 'USD'				
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%'))
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
				and a.ccycd = 'USD'
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%'))
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
					and a.ccycd = 'USD'
					and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%'))
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
					and a.ccycd = 'USD'					
					and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%'))
					and c.dpac not in ('466101','466102','466201','466202')
					and b.custtpcd like '1%'
					and d.bftrbal>d.aftrbal
					and d.trdt  = &h_trdt
				)
				group by    brcd, custseq, nm, idxacno,  ccycd
			) A
		)
		group by brcd, custseq, nm
		ORDER BY chenhlech   desc
	)
	where ROWNUM<= 5000
)com,
(
	select 	result1.brcd, nm, custseq, idxacno,  gui, rut, chenhlech,	hbrcd, husrid, deptnmloc, rem, opndt, clsdt, locdpnm, ls
	from
	(
		select 	brcd, nm, custseq, idxacno, sum(DPTOTAMT_VND) gui,sum(WDTOTAMT_VND) rut,
				decode(sign(SUM(DPTOTAMT_VND)-SUM(WDTOTAMT_VND)),1,(SUM(DPTOTAMT_VND)-SUM(WDTOTAMT_VND)),(SUM(WDTOTAMT_VND)-	SUM(DPTOTAMT_VND))) chenhlech,
				hbrcd, husrid, rem, opndt, locdpnm, clsdt, ls
		from
		(
			select a.brcd,a.custseq, a.nm,a.idxacno, sum(a.sodu) DPTOTAMT_VND, a.ccycd, sum(a.sodu) ,0 WDTOTAMT_VND, hbrcd, husrid, rem, opndt, locdpnm, clsdt, ls
			from
			(
				select b.brcd, a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu, a.ccycd, a.clsflg, d.hbrcd, d.husrid, d.rem, a.opndt, c.locdpnm, a.clsdt clsdt, scl.acmtmdpfrt ls
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
				and a.ccycd = 'USD'				
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%'))
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
							dmd.opndt,
							dptp.locdpnm,
							dmd.clsdt,
							bsi.bsir ls
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
				and dmd.ccycd = 'USD'
				and ((dptp.dpac  like '431100') or (dptp.dpac like '433100') or  (dptp.dpac like '435100') or (dptp.dpac like '466%'))
				and dptp.dpac not in ('466101','466102','466201','466202','466901','466301')
				and gen.custtpcd like '1%'
				and bsi.nxtappldt = '99991231'
				and trl.bftrbal<=trl.aftrbal
				and trl.trdt  = &h_trdt
			) a
			group by    brcd, custseq, nm, idxacno,  ccycd,  hbrcd, husrid, rem, opndt, locdpnm, clsdt, ls

			UNION ALL
			select a.brcd,a.custseq, a.nm,a.idxacno, 0 DPTOTAMT_VND , a.ccycd, sum(a.sodu),sum(a.sodu) WDTOTAMT_VND, hbrcd, husrid, rem, opndt, locdpnm, clsdt, ls
			from
			(
				select b.brcd, a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu, a.ccycd, a.clsflg, d.hbrcd, d.husrid, d.rem, a.opndt, c.locdpnm, a.clsdt clsdt, scl.acmtmdpfrt ls
				from tbdp_savmst a, tbcm_general b, tbdp_dptp c , tbdp_trlst d, tbdp_sclrbal scl, tbdp_idxacct idx
				where a.brcd like '%'
				and a.brcd=b.brcd
				and a.custseq=b.custseq
				and a.opncnclflg='0'
				and d.cncltrflg='0'
				and d.tgtflg='0'
				and a.brcd=c.brcd
				and a.dptpcd = c.dptpcd		
				and a.ccycd = 'USD'
				and ((c.dpac like '431%') or (c.dpac like '433%') or (c.dpac like '435%') or (c.dpac like '441%') or (c.dpac like '466%'))
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
				select a.brcd,a.custseq, b.nm,a.idxacno, d.ACCTCCYDPAMT sodu , a.ccycd , a.clsflg , d.hbrcd, d.husrid, d.rem, a.opndt, c.locdpnm, a.clsdt, bsi.bsir ls
				 from tbdp_dmdmst a, tbcm_general b, tbdp_trlst d   , tbdp_dptp c, tbcs_bsircd bsi, tbdp_ccyspec spc, tbdp_idxacct idx
				 where a.brcd like '%'
				 and a.brcd=b.brcd
				 and a.custseq=b.custseq
				 and a.opncnclflg='0'
				 and d.cncltrflg='0'
				 and d.tgtflg='0'
				 and a.brcd=c.brcd
				 and a.dptpcd = c.dptpcd
				 and a.ccycd = 'USD'
				 and ((c.dpac  like '431100') or (c.dpac like '433100') or  (c.dpac like '435100') or (c.dpac like '466%'))
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
			group by    brcd, custseq, nm, idxacno,  ccycd,  hbrcd, husrid, rem, opndt, locdpnm, clsdt, ls
		)
		group by brcd, custseq, nm, idxacno,  ccycd,  hbrcd, husrid, rem, opndt, locdpnm, clsdt, ls
		--ORDER BY custseq||chenhlech   desc
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

