select a.trdt, sav.brcd, lclbrnm TEN_CN, sav.deptcd, dep.deptnmloc TEN_PGD,
		sav.custseq, gen.nmloc,
		sav.acctno, sav.locdpnm TEN_KH, sav.ccycd,
		decode(trim(dptp.cntrmmtrm),'','KKH',decode(substr(dptp.dpac,1,3),'433','TIET KIEM','TIEN GUI')) LOAI_KH,
		sum(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )) Tonggui,
		sum(decode(sign(a.bftrbal-a.aftrbal),1, a.bftrbal-a.aftrbal , 0 ))Tongrut
from tbdp_trlst a, tbcm_general gen, tbdp_idxacct sav, tbdp_dptp dptp, tbcs_deptcd dep, tbcs_Brcd brc
where a.trdt in (select curbusday from tbcs_brcd where brcd ='1000')
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.brcd = a.brcd
and sav.dptpcd = a.dptpcd
and sav.acctseq = a.acctseq
and sav.brcd = dptp.brcd
and sav.dptpcd = dptp.dptpcd
and sav.deptcd = dep.deptcd
and sav.brcd = brc.brcd
group by a.trdt, lclbrnm, sav.deptcd, dep.deptnmloc, sav.brcd, sav.acctno, sav.locdpnm, sav.custseq, gen.nmloc, sav.ccycd, dptp.cntrmmtrm, dptp.dpac
order by a.trdt, sav.brcd, lclbrnm, sav.deptcd, dep.deptnmloc, sav.acctno
