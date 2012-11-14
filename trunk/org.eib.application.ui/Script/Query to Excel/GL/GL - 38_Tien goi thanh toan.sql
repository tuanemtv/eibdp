--define	h_trdt = '20120709'

select	a.plnyr, a.brcd, b.lclbrnm, a.ccy,
		sum(decode(a.code, 'A01000', a.plnamt, 0)) TG_To_chuc_kinh_te,
		sum(decode(a.code, 'A02000', a.plnamt, 0)) TG_Ca_Nhan,
		sum(decode(a.code, 'B02000', a.plnamt, 0)) Tien_Mat_Tai_NHNN,
		sum(decode(a.code, 'B01000', a.plnamt, 0)) Tien_Mat_Tai_Quy
from	rt1.tbrt_plan a, cs1.tbcs_brcd b,
		( 	select	code, decode
			from	race.t_code
			where	cat_name = 'GLMISRPTFU35'
		) c
where	a.rptcd = 'FU25'
	and a.plnyr = &h_trdt
	and a.seq = '4'
	and a.ccy in ('VND', 'USD', 'GD1')
	and a.code in	(	'A01000',		--TIEN GOI CUA CA NHAN
						'A02000',		--TIEN GOI CUA CAC TCKT
						'B02000',		--TIEN GOI TAI NHNN
						'B01000'		--TIEN MAT TAI QUY
					)
	and a.brcd = b.brcd
	and a.code = c.code
group by a.plnyr, a.brcd, b.lclbrnm, a.ccy
order by a.plnyr, a.brcd, a.ccy;
