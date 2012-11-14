--define h_trdt ='20110908'				
				
select brcd, custseq, nm, DPTOTAMT_VND, WDTOTAMT_VND, chenhlech					
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
			from tbdp_dmdmst a, tbcm_general b, tbdp_dptp c , tbdp_trlst d, tbdp_idxacct idx
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
			and b.custtpcd like '1%'
			and a.brcd=d.brcd
			and a.dptpcd=d.dptpcd
			and a.acctseq=d.acctseq
			and d.bftrbal<=d.aftrbal
			and d.trdt  = &h_trdt
		) a
		group by brcd, custseq, nm, idxacno,  ccycd

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
				and d.trcd ='W360'
				and a.brcd=c.brcd
				and a.dptpcd = c.dptpcd
				and a.brcd=idx.brcd
			and a.dptpcd=idx.dptpcd
			and a.acctseq=idx.acctseq
			and idx.deptcd like '%'
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
				and d.bftrbal>d.aftrbal
				and d.trdt  = &h_trdt
			)
			group by    brcd, custseq, nm, idxacno,  ccycd
		) A
	)
	group by brcd, custseq, nm
	ORDER BY chenhlech   desc
)
where ROWNUM <= 5000