--define h_trdt='20101016'
select a.acctcd kyquy, a.brcd, a.trdt, a.custseq, b.nmloc, a.ccy, sum(a.tdbal) sodu--a.brcd, a.trdt, a.custseq, b.nmloc, a.refno, a.ccy, a.clrbal, decode(a.intrt,0,3,a.intrt) laisuat,a.opndt, a.matdt, decode(a.matdt,'00000000', 'KKH','CKH') tktype
from gl1.tbgl_mast a, cm1.tbcm_general b
where a.brcd like '%'
and a.trdt =&h_trdt
and a.acctcd like '4%'
and a.acctcd in ('466200','466400')
and a.ccy like '%'
and a.tdbal > 0
and a.custseq = b.custseq
and b.brcd ='1000'
and b.custtpcd <> '100'
and b.custtpcd in ('200','800')
group by a.acctcd, a.brcd, a.trdt, a.custseq, b.nmloc, a.ccy
order by a.brcd||a.custseq
