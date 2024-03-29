--a.brcd, gen.obrcd
select a.trdt, sav.brcd, sav.custseq, gen.nmloc, sav.ccycd,
		sum(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )) Tonggui,
		sum(decode(sign(a.bftrbal-a.aftrbal),1, a.bftrbal-a.aftrbal , 0 ))Tongrut
		--cs1.excrosscal('1000', 'VND', a.trdt, a.ccycd, sum(decode(sign(a.aftrbal-a.bftrbal),1,a.trccyamt + a.acctccyodamt, 0 )), '01', 'VND', '01') Tonggui_QD,
		--cs1.excrosscal('1000', 'VND', a.trdt, a.ccycd, sum(decode(sign(a.bftrbal-a.aftrbal),1, a.trccyamt + a.acctccyodamt , 0 )), '01', 'VND', '01') Tongrut_QD
from tbdp_trlst a, tbcm_general gen, tbdp_idxacct sav, tbdp_dptp dptp
where a.trdt in (select prebusday from tbcs_brcd where brcd ='1000')
--and sav.brcd ='2000'
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.brcd = a.brcd
and sav.dptpcd = a.dptpcd
and sav.acctseq = a.acctseq
and gen.custtpcd ='100'
and sav.ccycd in ('GD1')
and a.brcd = dptp.brcd
and a.dptpcd = dptp.dptpcd
and dptp.DPAC <> '462102'
group by a.trdt, sav.brcd, sav.custseq, gen.nmloc, sav.ccycd
