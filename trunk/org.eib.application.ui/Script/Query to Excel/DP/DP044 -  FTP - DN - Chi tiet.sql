--define h_trdt ='20120416'


select 	ftp.trdt, 
		ftp.brcd,
		b.LCLBRNM, idx.deptcd,
		decode(gen.custtpcd,'100','CN','200','DN','600','TCTD','Khac') CN_DN,
		gen.CUSTSEQ,
		gen.NMLOC TEN_KH,
		ftp.refno TK,
		c.locdpnm KY_HAN,
		ftp.ccy,
		sum(ftp.acrbamt) SO_DU,
		cs1.excrosscal( '1000', 'VND', ftp.trdt, ccy, SUM(ftp.acrbamt), '01', 'VND', '01') SD_QD,
		sum(ftp.acramt) LAI_FTP,
		BKRT LS_HE_THONG,
		BSRT LS_KH,
		SPRDRT LS_TL,
		INTRT LS_FTP,
		ftp.OPNDT,
		ftp.MATDT
from gl1.tbgl_ftpdd ftp, tbdp_dptp c, tbcs_brcd b, tbcm_general gen, tbdp_idxacct idx
where ftp.trdt = &h_trdt
and ftp.brcd =c.brcd
and ftp.trref =c.dptpcd
and ftp.brcd = b.brcd
and ftp.brcd = gen.brcd
and ftp.custseq = gen.custseq
and ftp.brcd = idx.brcd
and ftp.trref = idx.dptpcd
and ftp.trseq = idx.acctseq
and gen.custtpcd not in ('600','100')
and ftp.buscd ='DP'
and ftp.acctcd ='711003'
group by ftp.trdt, ftp.trref, ftp.trseq, ftp.refno, ftp.brcd, gen.NMLOC, gen.CUSTSEQ, c.locdpnm,b.LCLBRNM, idx.deptcd, ftp.ccy, SPRDRT, BSRT , INTRT , ftp.OPNDT, ftp.MATDT, c.locdpnm, gen.CUSTTPCD, BKRT
order by ftp.brcd
