--define h_trdt ='20121002'



		select a.trdt,  a.brcd,a.buscd,a.UNTBUSCD ,b.LCLBRNM, idx.deptcd, a.ccy, c.LOCDPNM KYHAN1,
					decode(gen.custtpcd,'100','CN','200','DN','Khac') CN_DN,
					gen.NMLOC TEN_KH,
					gen.CUSTSEQ,
					a.refno TK,
					sum(a.acrbamt) SD,
					cs1.excrosscal( '1000', 'VND', a.trdt, ccy, SUM(a.acrbamt), '01', 'VND', '01') SD_QD,
					a.acramt LAIFTP,
					a.BCEQA LAIFTP_QD,
					a.PYARINT LAIKH,
					BSRT LS_KH,
					INTRT LS_FTP,
					INTRT - BSRT CLLS,
					a.OPNDT, a.MATDT,
					DECODE(c.dpac, '466301', '012', decode(c.erclint, '017', DECODE(c.DPCAPFRQTP,	'002100000000', '001',
																												'002200000000', '002',
																												'002300000000', '003',
																												'002600000000', '006',
																												'003200000000', '012',
																												'000000110000', '001',
																												'000000120000', '002',
																												'000000130000', '003',
																												nvl(TRIM(c.cntrmmtrm), '000')),nvl(TRIM(c.cntrmmtrm), '000'))) || DECODE(TIMEDPTP, '001', ' NGAY', '002',' THANG', ' TUAN') KYHAN

		from gl1.tbgl_ftpdd a, tbdp_dptp c, tbcs_brcd b, tbcm_general gen, tbdp_idxacct idx
		where a.brcd = '1015'
		and a.trdt = &h_trdt
		and a.acrbamt >0
		and a.brcd =c.brcd
		and a.trref =c.dptpcd
		and a.brcd = b.brcd
		and a.brcd = gen.brcd
		and a.custseq = gen.custseq
		and a.brcd = idx.brcd
		and a.trref = idx.dptpcd
		and a.trseq = idx.acctseq
		group by a.trdt, a.refno, a.brcd, gen.NMLOC, gen.CUSTSEQ, b.LCLBRNM,  idx.deptcd, a.ccy, BKRT , INTRT , a.OPNDT, a.MATDT, c.locdpnm, gen.CUSTTPCD, c.erclint, c.CNTRMMTRM, c.TIMEDPTP, c.dpac, c.DPCAPFRQTP, BSRT,a.acramt,	a.PYARINT,a.BCEQA,a.buscd,a.UNTBUSCD
		order by a.brcd


