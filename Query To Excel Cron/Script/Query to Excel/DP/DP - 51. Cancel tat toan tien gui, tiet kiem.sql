--define h_trdt='20120912'

select sav.brcd, idx.DEPTCD, gen.custseq, gen.nmloc, sav.idxacno, idx.LOCDPNM,
		 sav.ccycd, sav.curbal,
		sav.opndt, sav.matdt, trl.TRDT NGAY_CANCEL
from tbdp_trlst trl, tbdp_savmst sav, tbcm_general gen, tbdp_idxacct idx
where trl.trdt = &h_trdt
and trcd ='W365'
and trl.brcd = sav.brcd
and trl.dptpcd = sav.dptpcd
and trl.acctseq = sav.acctseq
and sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and sav.brcd = idx.brcd
and sav.dptpcd = idx.dptpcd
and sav.acctseq = idx.acctseq
and sav.ccycd ='GD1'
and sav.clsflg ='0'
and sav.opncnclflg ='0'
