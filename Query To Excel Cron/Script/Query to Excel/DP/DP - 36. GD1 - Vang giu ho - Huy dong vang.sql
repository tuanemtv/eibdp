--define h_trdt = '20111005'

select  bal.brcd, bal.custseq, gen.nmloc, decode(gen.CUSTTPCD, '100', 'CN','DN') LOAI_HINH,
		bal.acctcd, decode(bal.acctcd, '462102', 'VANG GIU HO', 'VANG HUY DONG') LOAI,
		bal.refno TAI_KHOAN, bal.ccy, bal.clrbal SD, bal.opndt NG_MO, bal.matdt NG_DH
from gl1.tbgl_baldd bal, tbcm_general gen
where bal.trdt = &h_trdt
and bal.acctcd like '4%'
and bal.ccy = 'GD1'
and bal.buscd = 'DP'
and bal.brcd = gen.brcd
and bal.custseq = gen.custseq
and bal.clrbal > 0
