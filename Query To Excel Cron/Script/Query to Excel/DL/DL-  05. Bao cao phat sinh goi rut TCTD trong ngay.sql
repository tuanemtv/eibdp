
select trdt, round(sum(decode(ccy, 'VND', TOTINAMT / 1000000000, 0)), 2) INAMT_VND,
	             round(sum(decode(ccy, 'USD', totinamt / 1000000, 0)), 2) inamt_usd,
	             round(sum(decode(substr(ccy, 1, 2), 'GD', totinamt / 10, 0)), 2) inamt_gold,
	             round(sum(decode(ccy, 'VND', 0, decode(ccy, 'USD', 0, decode(substr(ccy, 1, 2), 'GD', 0, cs1.excrosscal('1000', 'VND', &h_trdt, ccy, totinamt, '01', 'VND', '01') / 1000000000)))), 2) inamt_ccy,
		         round(sum(cs1.excrosscal('1000', 'VND', &h_trdt, ccy, totinamt, '01', 'VND', '01')  / 1000000000), 2) totinamt_vnd,
		         round(sum(decode(ccy, 'VND', totoutamt / 1000000000, 0)), 2) outAMT_VND,
	             round(sum(decode(ccy, 'USD', totoutamt / 1000000, 0)), 2) outamt_usd,
	             round(sum(decode(substr(ccy, 1, 2), 'GD', totoutamt / 10, 0)), 2) outamt_gold,
	             round(sum(decode(ccy, 'VND', 0, decode(ccy, 'USD', 0, decode(substr(ccy, 1, 2), 'GD', 0, cs1.excrosscal('1000', 'VND', &h_trdt, ccy, totoutamt, '01', 'VND', '01') / 1000000000)))), 2) outamt_ccy,
		         round(sum(cs1.excrosscal('1000', 'VND', &h_trdt, ccy, totoutamt, '01', 'VND', '01')  / 1000000000), 2) totoutamt_vnd,
		         round(sum(cs1.excrosscal('1000', 'VND', &h_trdt, ccy, totinamt, '01', 'VND', '01')  / 1000000000) -
		               sum(cs1.excrosscal('1000', 'VND', &h_trdt, ccy, totoutamt, '01', 'VND', '01')  / 1000000000), 2) minusamt_vnd
	from
	(
	select trdt, ccy, sum(nvl(inamt, 0)) totinamt, sum(nvl(outamt, 0)) totoutamt
	from
	(
	select trdt, ccy, cramt inamt, 0 outamt
	from gl1.tbgl_mast
	where acctcd in ('411202', '411300', '422101', '414801') and
	      trdt = &h_trdt and
	      onofftp = '1'
	union all
	select trdt, ccy, cramt, 0
	from gl1.tbgl_mast
	where acctcd in ('131200', '122200', '201100') and
	      trdt = &h_trdt and
	      onofftp = '1'
	union all
	select trdt, ccy, 0, dramt
	from gl1.tbgl_mast
	where acctcd in ('411202', '411300', '422101', '414801') and
	      trdt = &h_trdt and
	      onofftp = '1'
	union all
	select trdt, ccy, 0, dramt
	from gl1.tbgl_mast
	where acctcd in ('131200', '122200', '201100') and
	      trdt = &h_trdt and
	      onofftp = '1'
	)
	group by trdt, ccy
	)
	group by trdt
	order by trdt;
