--define  h_trdt ='20121029'
--define  h_ccycd ='VND'


select  a.trdt, decode(custtpcd,'100','Ca nhan','Doanh ngiep') loaiKH
		,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, GUITM, '01', 'USD', '01')) GUITM ,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, RUT_TM, '01', 'USD', '01')) RUT_TM
		,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, giaingan, '01', 'USD', '01')) giaingan ,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, Thuno, '01', 'USD', '01')) Thuno
		,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, CK_DEN_TN, '01', 'USD', '01')) CK_DEN_TN ,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, CK_DI_TN, '01', 'USD', '01')) CK_DI_TN
		,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, CK_DEN_NN, '01', 'USD', '01')) CK_DEN_TN ,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, CK_DI_NN, '01', 'USD', '01')) CK_DI_TN
		,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, DL_MUA, '01', 'USD', '01')) DL_MUA ,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, DL_BAN, '01', 'USD', '01')) DL_BAN
		,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, GHICO_KHAC, '01', 'USD', '01')) GHICO_KHAC ,sum(cs1.excrosscal('1000', 'VND', a.trdt, ccycd, GHINO_KHAC, '01', 'USD', '01')) GHINO_KHAC

from (
	select a.trdt, gen.custtpcd , sav.ccycd,decode(substr(a.fndtpcd,1,1),'1',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) GUITM,decode(substr(a.fndtpcd,1,1),'1',(decode(sign(a.aftrbal-a.bftrbal),1, 0, a.bftrbal-a.aftrbal)),0) RUT_TM
		,decode(a.tobuscd,'LN',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) giaingan,decode(a.tobuscd,'LN',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) Thuno
		,decode(a.tobuscd,'LR',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) CK_DEN_TN,decode(a.tobuscd,'LR',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) CK_DI_TN
		,decode(a.tobuscd,'FX',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) CK_DEN_NN,decode(a.tobuscd,'FX',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) CK_DI_NN
		,decode(a.tobuscd,'DL',(decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 )),0) DL_MUA,decode(a.tobuscd,'DL',(decode(sign(a.aftrbal-a.bftrbal),1,0, a.bftrbal-a.aftrbal)),0) DL_BAN
		,decode(substr(a.fndtpcd,1,1),'1', 0, decode(a.tobuscd,'LN',0,'LR',0,'FX',0,'DL',0,decode(sign(a.aftrbal-a.bftrbal),1, a.aftrbal-a.bftrbal, 0 ))) GHICO_KHAC
		,decode(substr(a.fndtpcd,1,1),'1', 0, decode(a.tobuscd,'LN',0,'LR',0,'FX',0,'DL',0,decode(sign(a.aftrbal-a.bftrbal),1, 0, a.bftrbal-a.aftrbal))) GHINO_KHAC
	--select sav.brcd, sav.acctno, a.trdt,a.bftrbal ,a.acctccydpamt, a.trccyamt, a.aftrbal , a.dacno , a.husrid , a.rem
	from tbdp_trlst a, tbcm_general gen, tbdp_idxacct sav
	where a.trdt in (select curbusday from tbcs_brcd where brcd ='1000')
	and sav.brcd = gen.brcd
	and sav.custseq = gen.custseq
	and sav.brcd = a.brcd
	and sav.dptpcd = a.dptpcd
	and sav.acctseq = a.acctseq
	and ( gen.custtpcd in ('100','200','800') or a.trcustseq ='108685831' )
	and sav.ccycd not in ('VND','GD1')
) a
group by a.trdt, decode(custtpcd,'100','Ca nhan','Doanh ngiep')


