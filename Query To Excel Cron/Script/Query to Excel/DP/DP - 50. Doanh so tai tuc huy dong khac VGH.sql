--define h_trdt ='20120821'

--Tai tuc binh thuong
select a.trdt, decode(gen.custtpcd,'100','Ca nhan','Doanh nghiep') Loai,
		sav.brcd, sav.custseq, gen.nmloc, sav.ccycd,
		sum(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )) Tonggui,
		sum(decode(sign(a.bftrbal-a.aftrbal),1, a.bftrbal-a.aftrbal , 0 ))Tongrut
from tbdp_trlst a, tbcm_general gen, tbdp_idxacct sav, tbdp_dptp dptp
where a.trdt = &h_trdt
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.brcd = a.brcd
and sav.dptpcd = a.dptpcd
and sav.acctseq = a.acctseq
and sav.ccycd in ('GD1')
and a.brcd = dptp.brcd
and a.dptpcd = dptp.dptpcd
and dptp.DPAC <> '462102'
and (sav.brcd, sav.dptpcd, sav.acctseq) in
	( select scl.brcd, scl.dptpcd, scl.acctseq
		from tbdp_sclrbal scl
		where sav.brcd = scl.brcd
		and sav.dptpcd = scl.dptpcd
		and sav.acctseq = scl.acctseq
		group by scl.brcd, scl.dptpcd, scl.acctseq
		having count(*)> 1
	)
group by a.trdt, sav.brcd, sav.custseq, gen.nmloc, sav.ccycd, gen.custtpcd

union all
--mo moi do he thong mo duoc xem la tai tuc
select a.trdt, decode(gen.custtpcd,'100','Ca nhan','Doanh nghiep') Loai,
		sav.brcd, sav.custseq, gen.nmloc, sav.ccycd,
		sum(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )) Tonggui,
		sum(decode(sign(a.bftrbal-a.aftrbal),1, a.bftrbal-a.aftrbal , 0 ))Tongrut
from tbdp_trlst a, tbcm_general gen, tbdp_idxacct sav, tbdp_dptp dptp
where a.trdt = &h_trdt
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.brcd = a.brcd
and sav.dptpcd = a.dptpcd
and sav.acctseq = a.acctseq
and sav.ccycd in ('GD1')
and a.brcd = dptp.brcd
and a.dptpcd = dptp.dptpcd
and dptp.DPAC <> '462102'
and a.husrid = a.brcd || 'DP'
and a.trcd ='W060'
group by a.trdt, sav.brcd, sav.custseq, gen.nmloc, sav.ccycd, gen.custtpcd
