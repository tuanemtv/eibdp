--define h_trdt = '20110601'

select a.brcd, b.trdt, a.custseq, gen.nmloc,
			idx.acctno, a.acrbamt, a.ccy,
			DECODE(dpt.DPCAPFRQTP,'002100000000','36 THANG LAI HANG THANG', '002200000000', '36 THANG LAI HANG 2 THANG', '002300000000','36 THANG LAI HANG 3 THANG', '002600000000','36 THANG LAI HANG 6 THANG', '003200000000', '36 THANG LAI HANG 12 THANG', dpt.CNTRMMTRM || 'THANG') KY_HAN,
			a.bsrt, a.sprdrt, a.intrt, deal.matdt , b.dealno, deal.dllaststscd
from gl1.tbgl_ftpdd a, dp1.tbdp_negorateftp b , cm1.tbcm_general gen , DL1.TBDL_DEAL deal , dp1.tbdp_dptp dpt , dp1.tbdp_idxacct idx
where a.brcd like '%'
		and a.trdt =&h_trdt
		and ccy = 'USD'
		and acrbamt > 0
		and buscd = 'DP'
		and a.brcd = b.brcd and a.trref = b.dptpcd and a.trseq = b.acctseq
		and a.brcd = gen.brcd
		and a.custseq = gen.custseq
		and gen.custtpcd = '100'
		AND deal.BRCD = b.BRCD
		AND deal.DLTPCD = SUBSTR(b.DEALNO, 5, 1)
		AND deal.SBTPCD = SUBSTR(b.DEALNO, 6, 2)
		AND deal.DLSEQNO = SUBSTR(b.DEALNO, 8, 8)
		and deal.matdt >&h_trdt
		and b.vrfflg = '1'
		and a.brcd = dpt.brcd
		and a.trref = dpt.dptpcd
		and a.brcd = idx.brcd
		and a.trref = idx.dptpcd
		and a.trseq = idx.acctseq
order by a.brcd, b.trdt
