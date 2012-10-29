--define  h_trdt ='20121029'
--define  h_ccycd ='USD'
select  decode(custtpcd,'100','Ca nhan','Doanh ngiep') loaiKH, sum(GUITM) GUITM, sum(RUT_TM) RUT_TM,   sum(giaingan) giaingan,sum(Thuno) Thuno, sum(CK_DEN_TN) CK_DEN_TN , sum(CK_DI_TN) CK_DI_TN, sum(CK_DEN_NN) CK_DEN_NN , sum(CK_DI_NN) CK_DI_NN
		,  sum(DL_MUA) DL_MUA, sum(DL_BAN) DL_BAN ,   sum(GHICO_KHAC)  GHICO_KHAC , sum(GHINO_KHAC)  GHINO_KHAC
from (
	select gen.custtpcd , decode(substr(a.fndtpcd,1,1),'1',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) GUITM,decode(substr(a.fndtpcd,1,1),'1',(decode(sign(a.aftrbal-a.bftrbal),1, 0, a.bftrbal-a.aftrbal)),0) RUT_TM
		,decode(a.tobuscd,'LN',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) giaingan,decode(a.tobuscd,'LN',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) Thuno
		,decode(a.tobuscd,'LR',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) CK_DEN_TN,decode(a.tobuscd,'LR',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) CK_DI_TN
		,decode(a.tobuscd,'FX',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) CK_DEN_NN,decode(a.tobuscd,'FX',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) CK_DI_NN
		,decode(a.tobuscd,'DL',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) DL_MUA,decode(a.tobuscd,'DL',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) DL_BAN
		,decode(substr(a.fndtpcd,1,1),'1', 0, decode(a.tobuscd,'LN',0,'LR',0,'FX',0,'DL',0,decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 ))) GHICO_KHAC
		,decode(substr(a.fndtpcd,1,1),'1', 0, decode(a.tobuscd,'LN',0,'LR',0,'FX',0,'DL',0,decode(sign(a.aftrbal-a.bftrbal),1, 0, a.bftrbal-a.aftrbal))) GHINO_KHAC
	--select sav.brcd, sav.acctno, a.trdt,a.bftrbal ,a.acctccydpamt, a.trccyamt, a.aftrbal , a.dacno , a.husrid , a.rem
	from tbdp_trlst a, tbcm_general gen, tbdp_idxacct sav
	where a.trdt in (select curbusday from tbcs_brcd where brcd ='1000')
	--and a.fndtpcd like '1%'
	and sav.brcd = gen.brcd
	and sav.custseq = gen.custseq
	and sav.brcd = a.brcd
	and sav.dptpcd = a.dptpcd
	and sav.acctseq = a.acctseq
	and ( gen.custtpcd in ('100','200','800') or a.trcustseq ='108685831' )
	and sav.ccycd = 'USD'
	--and a.aftrbal < bftrbal
)
group by decode(custtpcd,'100','Ca nhan','Doanh ngiep')

