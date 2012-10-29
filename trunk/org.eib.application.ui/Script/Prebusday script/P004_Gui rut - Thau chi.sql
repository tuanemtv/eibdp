
select 'Ca nhan' kind, sav.brcd, sav.dptpcd,
	sav.acctseq, sav.custseq, gen.nmloc, dmd.idxacno, sav.LOCDPNM, sav.ccycd, dmd.curbal
from tbcm_general gen, tbdp_idxacct sav, tbdp_dmdmst dmd
--and a.brcd ='2000'
where sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and gen.custtpcd in ('100')
AND (dmd.BRCD, dmd.DPTPCD, dmd.ACCTSEQ)
	 in ( SELECT ovr.ovrBRCD, ovr.ovrDPTPCD, ovr.ovrACCTSEQ
						FROM DP1.tbdp_ovrbook ovr
						WHERE dmd.BRCD = ovr.ovrBRCD
						AND dmd.DPTPCD = ovr.ovrDPTPCD
						AND dmd.ACCTSEQ = ovr.ovrACCTSEQ
						--and prvexprdt >='20120830'
						)
and sav.brcd = dmd.brcd
and sav.dptpcd = dmd.dptpcd
and sav.acctseq = dmd.acctseq
and dmd.odlmtflg ='1'
--and curbal>0
--group by sav.brcd, sav.custseq, gen.nmloc, dmd.idxacno, sav.LOCDPNM, sav.ccycd, dmd.curbal

union all

select 'Doanh nghiep' kind, sav.brcd, sav.dptpcd,
	sav.acctseq, sav.custseq, gen.nmloc, dmd.idxacno, sav.LOCDPNM, sav.ccycd, dmd.curbal
from tbcm_general gen, tbdp_idxacct sav, tbdp_dmdmst dmd
--and a.brcd ='2000'
where sav.brcd = gen.brcd
and sav.custseq = gen.custseq
and gen.custtpcd not in ('100','600')
AND (dmd.BRCD, dmd.DPTPCD, dmd.ACCTSEQ)
	 in ( SELECT ovr.BRCD, ovr.DPTPCD, ovr.ACCTSEQ
						FROM DP1.TBDP_ODLMT ovr
						WHERE dmd.BRCD = ovr.BRCD
						AND dmd.DPTPCD = ovr.DPTPCD
						AND dmd.ACCTSEQ = ovr.ACCTSEQ
						--and prvexprdt >='20120830'
						)
and sav.brcd = dmd.brcd
and sav.dptpcd = dmd.dptpcd
and sav.acctseq = dmd.acctseq
and dmd.odlmtflg ='1'



