/* h_trdt = Ngay hom truoc
*/

--define h_trdt ='20120207'

select a.trdt,  b.LCLBRNM, a.ccy,
			decode(gen.custtpcd,'100','CN','200','DN','600','TCTD','Khac') CN_DN,
			sum(a.acrbamt) SD,
			BKRT LS_HD,
			INTRT LS_FTP,
			DECODE( NVL(TIMEDPTP,'000'), '000', 'KKH', DECODE(c.dpac, '466301', '012', decode(c.erclint, '017', DECODE(c.DPCAPFRQTP,	'002100000000', '001',
																							'002200000000', '002',
																							'002300000000', '003',
																							'002600000000', '006',
																							'003200000000', '012',
																							'000000110000', '001',
																							'000000120000', '002',
																							'000000130000', '003',
																							nvl(TRIM(c.cntrmmtrm), '000')),nvl(TRIM(c.cntrmmtrm), '000'))
				)) || DECODE(NVL(TIMEDPTP,'000'), '001', ' NGAY', '002',' THANG', '003', ' TUAN','') KYHAN
from gl1.tbgl_ftpdd a, tbdp_dptp c, tbcs_brcd b, tbcm_general gen
where a.trdt = &h_trdt
and a.acrbamt >0
and a.brcd =c.brcd
and a.trref =c.dptpcd
and a.brcd = b.brcd
and a.brcd = gen.brcd
and a.custseq = gen.custseq
and a.acctcd = '711003'
group by a.trdt, a.brcd, b.LCLBRNM, a.ccy, BKRT , INTRT ,  c.locdpnm, gen.CUSTTPCD, c.erclint, c.CNTRMMTRM, c.TIMEDPTP, c.dpac, c.DPCAPFRQTP
order by a.brcd
