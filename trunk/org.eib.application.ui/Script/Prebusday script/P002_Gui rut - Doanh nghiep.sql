
select a.trdt, sav.brcd, sav.custseq, gen.nmloc, sav.LOCDPNM, sav.ccycd,
		sum(decode(sign(a.aftrbal-a.bftrbal),1,a.aftrbal-a.bftrbal, 0 )) Tonggui,
		sum(decode(sign(a.bftrbal-a.aftrbal),1, a.aftrbal-a.bftrbal , 0 ))Tongrut
from tbdp_trlst a, tbcm_general gen, tbdp_idxacct sav
where a.trdt in (select prebusday from tbcs_brcd where brcd ='1000')
--and a.brcd ='1403'
--and gen.custseq ='103708420'
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.brcd = a.brcd
and sav.dptpcd = a.dptpcd
and sav.acctseq = a.acctseq
and gen.custtpcd not in ('100','600')
group by a.trdt, sav.brcd, sav.custseq, gen.nmloc, sav.LOCDPNM, sav.ccycd
