--define  h_trdt = '20121029'
select decode(substr(a.fndtpcd,1,1),'1','Vang mat','khac') Type,sum(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )) Tonggui,
sum(decode(sign(a.bftrbal-a.aftrbal),1, a.bftrbal-a.aftrbal , 0 ))Tongrut
from tbdp_trlst a, tbcm_general gen, tbdp_savmst sav
where a.trdt  in (select prebusday from tbcs_brcd where brcd ='1000')
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.brcd = a.brcd
and sav.dptpcd = a.dptpcd
and sav.acctseq = a.acctseq
and gen.custtpcd in ('100','200','800')
and sav.ccycd ='GD1'
group by decode(substr(a.fndtpcd,1,1),'1','Vang mat','khac')

