--define h_trdt='20101016'
select a.brcd, a.trdt, a.custseq, b.nmloc, a.refno acctno, a.ccy, a.clrbal sodu, decode(a.intrt,0,decode(a.ccy,'VND',3,a.intrt),a.intrt) laisuat,a.opndt, a.matdt, decode(a.matdt,'00000000', 'KKH','CKH') dptype
from gl1.tbgl_baldd a, cm1.tbcm_general b
where a.brcd like '%'
and a.brcd <> '1000'
and a.trdt =&h_trdt
and a.buscd ='DP'
and a.acctcd like '4%'
and a.acctcd not in ('466200','466400')
and a.ccy like '%'
and a.ldrbal > 0
and a.custseq = b.custseq
and b.brcd ='1000'
and b.custtpcd <> '100'
and b.custtpcd in ('200','800')
order by brcd||custseq

