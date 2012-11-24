--define h_trdt = '20120409'

select gen.nmloc,a.locdpnm,f.*
from gl1.tbgl_ftpdd f, tbcm_general gen, tbdp_dptp a
where f.brcd = gen.brcd
	and f.custseq = gen.custseq
	and f.trref = a.dptpcd
	and f.brcd = a.brcd
	and f.brcd like '%'
	and gen.custtpcd = '100'
	and f.trdt = &h_trdt
	and f.ccy = 'GD1'
