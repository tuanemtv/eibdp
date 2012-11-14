select a.TRDT NGAY, c.LCLBRNM CN, a.CCY LTIEN, sum(a.ACRBAMT) SODU, a.BSRT LS_KHACHHANG, a.INTRT GIAFTP, TO_char(to_date(a.OPNDT,'YYYYMMDD'),'dd MON, yyyy') NGAYGIAINGAN, TO_char(to_date(a.MATDT,'YYYYMMDD'),'dd MON, yyyy') NGAYDAOHAN, '0M' CKYDOILS
from
(
select f.TRDT, f.BRCD, f.CUSTSEQ, f.CCY CCY, f.TRREF, f.TRSEQ, f.ACRBAMT, f.BSRT, f.INTRT, f.REFNO, b.ccy bCCY, b.trref, b.trseq, b.LDRBAL, b.OPNDT, b.MATDT
from GL1.TBGL_FTPDD f, GL1.TBGL_BALDD b
where f.TRDT = &h_trdt
and f.BRCD like '%'
and f.BUSCD = 'TF'
and f.ACRFMDT = f.TRDT
and f.REFNO not in ('02','04')
and f.TRDT = b.TRDT
and f.BRCD = b.BRCD
and f.BUSCD = b.BUSCD
and b.ACCTCD  like '2%'
and f.BRCD = b.BRCD
and f.TRREF = b.TRREF
and f.TRSEQ = b.TRSEQ
order by f.BRCD, f.TRREF, f.TRSEQ
) a, tbcs_brcd c
where a.brcd = c.brcd
group by a.TRDT, c.LCLBRNM, a.CCY, a.BSRT, a.INTRT, a.OPNDT, a.MATDT
order by a.TRDT, c.LCLBRNM, a.CCY, a.BSRT, a.INTRT, a.OPNDT, a.MATDT
