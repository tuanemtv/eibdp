select sav.brcd, idx.DEPTCD, sav.custseq, gen.nmloc, sav.idxacno, dptp.LOCDPNM, sav.ccycd, sav.curbal,
	sav.opndt, sav.matdt,
	DP1.ACCTBSIR (sav.brcd, sav.dptpcd, sav.acctseq, sav.opndt, 2) LS,
	--decode(rollcnt(sav.brcd, sav.dptpcd, sav.acctseq),1,'MO MOI','TAI TUC') TT,
	decode(CHKOPEN(sav.brcd, sav.dptpcd, sav.acctseq),1,'TAI TUC','MO MOI') TT2--,
	--decode(CHKOPEN2(sav.brcd, sav.dptpcd, sav.acctseq),1,'CCA','TIEN MAT') LOAI
from tbdp_savmst sav, tbdp_dptp dptp, tbdp_idxacct  idx, tbcm_general gen
where sav.brcd = dptp.brcd
and sav.dptpcd = dptp.dptpcd
and sav.ccycd ='GD1'
and dptp.dpac in ('441100','442100')
and sav.clsflg ='0'
and sav.opncnclflg ='0'
and sav.brcd = idx.brcd
and sav.dptpcd = idx.dptpcd
and sav.acctseq = idx.acctseq
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.curbal>0
--and sav.matdt between '20120807' and '20120903'
and sav.opndt between '20121026' and '20121027'
--and sav.opndt in ( select prebusday from tbcs_brcd where brcd ='1000')

