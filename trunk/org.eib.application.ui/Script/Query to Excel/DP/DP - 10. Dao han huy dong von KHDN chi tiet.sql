--define h_trdt ='20100601'

select idxacno, brcd, custseq, nm, ccycd, matdt, sodu, opndt, locdpnm, laisuat, lai
from
(
select a.idxacno, a.brcd,b.custseq, b.nm, a.ccycd, a.matdt matdt, (a.curbal)sodu, a.opndt, c.locdpnm, d.acmtmdpfrt laisuat,
round(to_char(to_date(a.matdt,'YYYYMMDD')-to_date(a.opndt,'YYYYMMDD'))*a.curbal* d.acmtmdpfrt/100/decode(a.ccycd,'VND',360,360),decode(a.ccycd,'VND',0,2))lai
from tbdp_savmst a, tbcm_general b , tbdp_dptp c , tbdp_sclrbal d
where a.brcd like '%' and a.clsflg ='0' and a.opncnclflg ='0'
and (a.matdt between &h_trdt and '99991231')
and a.brcd =b.brcd and a.curbal >0
and a.custseq =b.custseq
and a.brcd =c.brcd
and a.dptpcd =c.dptpcd
and a.brcd =d.brcd
and a.dptpcd =d.dptpcd
and a.acctseq =d.acctseq
and a.opndt =d.clrdt
and b.custtpcd not like '1%')
