
--define h_trdt ='20120801'

select b.hbrcd,decode(b.fndtpcd,'601','CHUYEN KHOAN','201','CCA','198','THU PHI','CASH') SUB_TYPE,C.NMLOC COUNTERPARTY,B.TRDT DEALDATE,B.VALUEDT VALUEDATE
	   ,DECODE(SIGN(B.AFTRBAL - BFTRBAL) ,1, 'SELL','BUY') BUY_SELL, A.CCYCD DEALCCY,B.ACCTCCYDPAMT DAMOUNT,B.CCYCD COUNTERCCY, B.TRCCYAMT CAMOUNT
	  ,decode(acctaplyexrt,0,APLYEXRT,1,APLYEXRT,acctaplyexrt) RATE,B.HUSRID USERID, B.DACNO JOURSEQ,MKEXRT  CLX, D.TREXRT EXRT, B.REM REMARK ,decode(c.custtpcd,'100','Ca nhan','Doanh nghiep') CustmerType
	  ,decode(substr(NVL(E.DEPTCD, 'XXX'), 3, 1), 'O', F.DEPTNM, E.BRCD)MAPB   , B.TRDT NGAYHACHTOAN
from tbdp_dmdmst  a, tbdp_trlst b , tbcm_general C ,GL1.tbGL_CLX D  ,CS1.TBRC_USR1 E ,TBCS_DEPTCD F
where
a.brcd = b.brcd
and a.dptpcd = b.dptpcd
and a.acctseq = b.acctseq
and b.trdt =  &h_trdt
and trim(b.tgtdt) is null
and a.ccycd <> b.ccycd
and a.brcd = C.brcd
and a.custseq = C.custseq
AND TRIM(B.HBRCD) = D.DYHBR(+)
AND B.TRDT = D.TRDT(+)
AND B.HUSRID = D.CRTUSR(+)
AND B.DACNO = D.DYSEQ(+)
AND B.BRCD = D.BRCD(+)
AND B.HBRCD = E.BRCD
AND B.HUSRID = E.USRID
AND E.psblflg ='1'
AND E.DEPTCD = F.DEPTCD

union all

select b.hbrcd,decode(b.fndtpcd,'601','CHUYEN KHOAN','201','CCA','198','THU PHI','CASH') SUB_TYPE,C.NMLOC COUNTERPARTY,B.TRDT DEALDATE,B.VALUEDT VALUEDATE
	   ,DECODE(SIGN(B.AFTRBAL - BFTRBAL) ,1, 'SELL','BUY') BUY_SELL, A.CCYCD DEALCCY,B.ACCTCCYDPAMT DAMOUNT,B.CCYCD COUNTERCCY, B.TRCCYAMT CAMOUNT
	  ,decode(acctaplyexrt,0,APLYEXRT,1,APLYEXRT,acctaplyexrt) RATE,B.HUSRID USERID, B.DACNO JOURSEQ,MKEXRT  CLX, D.TREXRT EXRT, B.REM REMARK ,decode(c.custtpcd,'100','Ca nhan','Doanh nghiep') CustmerType,
	  decode(substr(NVL(E.DEPTCD, 'XXX'), 3, 1), 'O', F.DEPTNM, E.BRCD)  MAPB , B.TRDT NGAYHACHTOAN
from tbdp_savmst  a, tbdp_trlst b , tbcm_general C ,GL1.tbGL_CLX D ,CS1.TBRC_USR1 E,TBCS_DEPTCD F
where
a.brcd = b.brcd
and a.dptpcd = b.dptpcd
and a.acctseq = b.acctseq
and b.trdt =  &h_trdt
and trim(b.tgtdt) is null
and a.ccycd <> b.ccycd
and a.brcd = C.brcd
and a.custseq = C.custseq
AND TRIM(B.HBRCD) = D.DYHBR(+)
AND B.TRDT = D.TRDT(+)
AND B.HUSRID = D.CRTUSR(+)
AND B.DACNO = D.DYSEQ(+)
AND B.BRCD = D.BRCD(+)
AND B.HBRCD = E.BRCD
AND B.HUSRID = E.USRID
AND E.psblflg ='1'
AND E.DEPTCD = F.DEPTCD
order by hbrcd



