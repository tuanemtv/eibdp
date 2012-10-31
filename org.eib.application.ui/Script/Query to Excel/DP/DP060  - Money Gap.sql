
select 'So tien rut dung han( không tính món rol)' cat_name1, cat_name,	ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt  , cat_name
	from
	(
		select a.trdt, sum(a.trccyamt) tramt, a.ccycd , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
		from tbdp_trlst a, tbcm_general b , tbdp_savmst c
		where a.brcd =b.brcd
		and a.trcustseq =b.custseq
		and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
		and a.trcd in('W360')
		and a.brcd like ''||'%'
		and a.brcd =c.brcd
		and a.dptpcd =c.dptpcd
		and a.acctseq =c.acctseq
		and c.opndt =c.clsdt
		and nvl(trim(c.clsdt),'99999999')=a.trdt
		and 2 = ( select count(*) from
					tbdp_sclrbal
					where brcd =a.brcd
					and dptpcd =a.dptpcd
					and acctseq =a.acctseq
				)
	   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
		order by a.trdt, a.ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd  , cat_name

union all

select 	'So tien gui moi'cat_name1, cat_name,ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,   a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt, cat_name
	from
	(
			select trdt, sum(tramt)tramt, ccycd, cat_name
			from
			(
				    select a.trdt, sum(a.trccyamt) tramt, a.ccycd   , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
					from tbdp_trlst a, tbcm_general b , tbdp_savmst c
					where a.brcd =b.brcd
					and a.trcustseq =b.custseq
					and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
					and a.trcd in('W160')
					and a.brcd like ''||'%'
					and a.brcd =c.brcd
					and a.dptpcd =c.dptpcd
					and a.acctseq =c.acctseq
					and nvl(trim(c.clsdt),'99999999')>a.trdt
				   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
				   --	order by a.trdt, a.ccycd
			        union all
					select a.trdt, sum(a.trccyamt) tramt, a.ccycd   , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
					from tbdp_trlst a, tbcm_general b , tbdp_savmst c
					where a.brcd =b.brcd
					and a.trcustseq =b.custseq
					and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
					and a.trcd in('W060')
					and a.brcd like ''||'%'
					and a.brcd =c.brcd
					and a.dptpcd =c.dptpcd
					and a.acctseq =c.acctseq
					and decode(c.erclint,'017',nvl(trim(c.predpcapdt),c.opndt),c.opndt)=a.trdt
					and 1 = ( select count(*) from
								tbdp_sclrbal
								where brcd =a.brcd
								and dptpcd =a.dptpcd
								and acctseq =a.acctseq
							)
				  group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
				   --	order by a.trdt, a.ccycd
			)
			 group by  trdt, ccycd, cat_name
			 	order by trdt, ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd  , cat_name

union all

select 'So tien tu dong tai tuc' cat_name1, cat_name, 	ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,  a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt   , cat_name
	from
	(
		select a.trdt, sum(a.aftrbal) tramt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
		from tbdp_trlst a, tbcm_general b , tbdp_savmst c
		where a.brcd =b.brcd
		and a.trcustseq =b.custseq
		and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
		and a.trcd in('C561')
		and a.brcd like ''||'%'
		and a.brcd =c.brcd
		and a.dptpcd =c.dptpcd
		and a.acctseq =c.acctseq
		and nvl(trim(c.clsdt),'99999999')>a.trdt
	   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
		order by a.trdt, a.ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd    , cat_name

union all

select 'So tien rut truoc han cua cac mon gui moi' cat_name1, cat_name, 	ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,  a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt   , cat_name
	from
	(
		select a.trdt, sum(a.trccyamt) tramt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
		from tbdp_trlst a, tbcm_general b , tbdp_savmst c
		where a.brcd =b.brcd
		and a.trcustseq =b.custseq
		and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
		and a.trcd in('W360')
		and a.brcd like ''||'%'
		and a.brcd =c.brcd
		and a.dptpcd =c.dptpcd
		and a.acctseq =c.acctseq
		and 1 = ( select count(*) from
					tbdp_sclrbal
					where brcd =a.brcd
					and dptpcd =a.dptpcd
					and acctseq =a.acctseq
				)
		and nvl(trim(c.clsdt),'99999999')>a.trdt
	   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
		order by a.trdt, a.ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd    , cat_name
union all

select 'So tien rut truoc han cua cac mon tai tuc' cat_name1, cat_name, 	ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,  a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt   , cat_name
	from
	(
		select a.trdt, sum(a.trccyamt) tramt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
		from tbdp_trlst a, tbcm_general b , tbdp_savmst c
		where a.brcd =b.brcd
		and a.trcustseq =b.custseq
		and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
		and a.trcd in('W360')
		and a.brcd like ''||'%'
		and a.brcd =c.brcd
		and a.dptpcd =c.dptpcd
		and a.acctseq =c.acctseq
		and 2 <= ( select count(*) from
					tbdp_sclrbal
					where brcd =a.brcd
					and dptpcd =a.dptpcd
					and acctseq =a.acctseq
				)
		and nvl(trim(c.clsdt),'99999999')>a.trdt
		and c.opndt <> a.trdt
	   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
		order by a.trdt, a.ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd    , cat_name
union all
select 'So tien rut dung han( cua cac món rol)' cat_name1, cat_name,	ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt  , cat_name
	from
	(
		select a.trdt, sum(a.trccyamt) tramt, a.ccycd , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
		from tbdp_trlst a, tbcm_general b , tbdp_savmst c
		where a.brcd =b.brcd
		and a.trcustseq =b.custseq
		and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
		and a.trcd in('W360')
		and a.brcd like ''||'%'
		and a.brcd =c.brcd
		and a.dptpcd =c.dptpcd
		and a.acctseq =c.acctseq
		and c.opndt =c.clsdt
		and nvl(trim(c.clsdt),'99999999')=a.trdt
		and 2 <= ( select count(*) from
					tbdp_sclrbal
					where brcd =a.brcd
					and dptpcd =a.dptpcd
					and acctseq =a.acctseq
				)
	   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
		order by a.trdt, a.ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd  , cat_name

union all
select 'So tien rut ra cua TK KKH' cat_name1, cat_name, 	ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,  a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt   , cat_name
	from
	(
 		select a.trdt, sum(a.trccyamt) tramt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
		from tbdp_trlst a, tbcm_general b
		where a.brcd =b.brcd
		and a.trcustseq =b.custseq
		and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
		and a.aftrbal <a.bftrbal
		and a.dptpcd like '1%'
		and (a.fndtpcd like '1%' or trim(a.tomgntno)like '%STT%')
	   --	and a.trcd in('W360')
		and a.brcd like ''||'%'

	   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
		order by a.trdt, a.ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd    , cat_name

union all

select 'So tien gui vao cua TK KKH' cat_name1, cat_name, 	ccycd,  sum(ngay1),
				sum(ngay2),
				sum(ngay3),
				sum(ngay4),
				sum(ngay5),
				sum(ngay6),
				sum(ngay7),
				sum(ngay8),
				sum(ngay9),
				sum(ngay10),
				sum(ngay11),
				sum(ngay12),
				sum(ngay13),
				sum(ngay14),
				sum(ngay15),
				sum(ngay16),
				sum(ngay17),
				sum(ngay18),
				sum(ngay19),
				sum(ngay20),
				sum(ngay21),
				sum(ngay22),
				sum(ngay23),
				sum(ngay24),
				sum(ngay25),
				sum(ngay26),
				sum(ngay27),
				sum(ngay28),
				sum(ngay29),
				sum(ngay30)
from
(
select a.trdt, a.ccycd, a.tramt,  a.cat_name,
	decode(b.date1, a.trdt, a.tramt, 0)ngay1,
	decode(b.date2, a.trdt, a.tramt, 0)ngay2,
	decode(b.date3, a.trdt, a.tramt, 0)ngay3,-- b.date1, b.date2, b.date3
	decode(b.date4, a.trdt, a.tramt, 0)ngay4,
	decode(b.date5, a.trdt, a.tramt, 0)ngay5,
	decode(b.date6, a.trdt, a.tramt, 0)ngay6,
	decode(b.date7, a.trdt, a.tramt, 0)ngay7,
	decode(b.date8, a.trdt, a.tramt, 0)ngay8,
	decode(b.date9, a.trdt, a.tramt, 0)ngay9,
	decode(b.date10, a.trdt, a.tramt, 0)ngay10,
	decode(b.date11, a.trdt, a.tramt, 0)ngay11,
	decode(b.date12, a.trdt, a.tramt, 0)ngay12,
	decode(b.date13, a.trdt, a.tramt, 0)ngay13,
	decode(b.date14, a.trdt, a.tramt, 0)ngay14,
	decode(b.date15, a.trdt, a.tramt, 0)ngay15,
	decode(b.date16, a.trdt, a.tramt, 0)ngay16,
	decode(b.date17, a.trdt, a.tramt, 0)ngay17,
	decode(b.date18, a.trdt, a.tramt, 0)ngay18,
	decode(b.date19, a.trdt, a.tramt, 0)ngay19,
	decode(b.date20, a.trdt, a.tramt, 0)ngay20,
	decode(b.date21, a.trdt, a.tramt, 0)ngay21,
	decode(b.date22, a.trdt, a.tramt, 0)ngay22,
	decode(b.date23, a.trdt, a.tramt, 0)ngay23,
	decode(b.date24, a.trdt, a.tramt, 0)ngay24,
	decode(b.date25, a.trdt, a.tramt, 0)ngay25,
	decode(b.date26, a.trdt, a.tramt, 0)ngay26,
	decode(b.date27, a.trdt, a.tramt, 0)ngay27,
	decode(b.date28, a.trdt, a.tramt, 0)ngay28,
	decode(b.date29, a.trdt, a.tramt, 0)ngay29,
	decode(b.date30, a.trdt, a.tramt, 0)ngay30
	from
	(select trdt, ccycd, tramt   , cat_name
	from
	(
		select a.trdt, sum(a.trccyamt) tramt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')cat_name
		from tbdp_trlst a, tbcm_general b
		where a.brcd =b.brcd
		and a.trcustseq =b.custseq
		and a.trdt between to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') and &h_trdt
		and a.aftrbal >a.bftrbal
		and (a.fndtpcd like '1%' or trim(a.tomgntno)like '%RTT%' or trim(a.tomgntno)like '%RTL%')
	   --	and a.trcd in('W360')
		and a.brcd like ''||'%'
		and a.dptpcd like '1%'
	   	group by a.trdt, a.ccycd  , decode(b.custtpcd,'100','Ca nhan','Doanh nghiep')
		order by a.trdt, a.ccycd
		)
	) a,
	(select to_char(to_date(&h_trdt,'YYYYMMDD')-30, 'YYYYMMDD') date1,
	to_char(to_date(&h_trdt,'YYYYMMDD')-29, 'YYYYMMDD') date2,
	to_char(to_date(&h_trdt,'YYYYMMDD')-28, 'YYYYMMDD') date3,
	to_char(to_date(&h_trdt,'YYYYMMDD')-27, 'YYYYMMDD') date4,
	to_char(to_date(&h_trdt,'YYYYMMDD')-26, 'YYYYMMDD') date5,
	to_char(to_date(&h_trdt,'YYYYMMDD')-25, 'YYYYMMDD') date6,
	to_char(to_date(&h_trdt,'YYYYMMDD')-24, 'YYYYMMDD') date7,
	to_char(to_date(&h_trdt,'YYYYMMDD')-23, 'YYYYMMDD') date8,
	to_char(to_date(&h_trdt,'YYYYMMDD')-22, 'YYYYMMDD') date9,
	to_char(to_date(&h_trdt,'YYYYMMDD')-21, 'YYYYMMDD') date10,
	to_char(to_date(&h_trdt,'YYYYMMDD')-20, 'YYYYMMDD') date11,
	to_char(to_date(&h_trdt,'YYYYMMDD')-19, 'YYYYMMDD') date12,
	to_char(to_date(&h_trdt,'YYYYMMDD')-18, 'YYYYMMDD') date13,
	to_char(to_date(&h_trdt,'YYYYMMDD')-17, 'YYYYMMDD') date14,
	to_char(to_date(&h_trdt,'YYYYMMDD')-16, 'YYYYMMDD') date15,
	to_char(to_date(&h_trdt,'YYYYMMDD')-15, 'YYYYMMDD') date16,
	to_char(to_date(&h_trdt,'YYYYMMDD')-14, 'YYYYMMDD') date17,
	to_char(to_date(&h_trdt,'YYYYMMDD')-13, 'YYYYMMDD') date18,
	to_char(to_date(&h_trdt,'YYYYMMDD')-12, 'YYYYMMDD') date19,
	to_char(to_date(&h_trdt,'YYYYMMDD')-11, 'YYYYMMDD') date20,
	to_char(to_date(&h_trdt,'YYYYMMDD')-10, 'YYYYMMDD') date21,
	to_char(to_date(&h_trdt,'YYYYMMDD')-9, 'YYYYMMDD') date22,
	to_char(to_date(&h_trdt,'YYYYMMDD')-8, 'YYYYMMDD') date23,
	to_char(to_date(&h_trdt,'YYYYMMDD')-7, 'YYYYMMDD') date24,
	to_char(to_date(&h_trdt,'YYYYMMDD')-6, 'YYYYMMDD') date25,
	to_char(to_date(&h_trdt,'YYYYMMDD')-5, 'YYYYMMDD') date26,
	to_char(to_date(&h_trdt,'YYYYMMDD')-4, 'YYYYMMDD') date27,
	to_char(to_date(&h_trdt,'YYYYMMDD')-3, 'YYYYMMDD') date28,
	to_char(to_date(&h_trdt,'YYYYMMDD')-2, 'YYYYMMDD') date29,
	to_char(to_date(&h_trdt,'YYYYMMDD')-1, 'YYYYMMDD') date30
	from dual) b
)
group by ccycd    , cat_name
