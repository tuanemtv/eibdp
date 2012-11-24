--define h_trdt = '20100602'
select custseq, nmloc, ccy, sodudau, dsrut, dsgui, abs(dsrut - dsgui) chenhlech, soducuoi
from
(select mst.custseq, gen.nmloc, mst.ccy, sum(mst.pdbal) sodudau, sum(mst.dramt) dsrut, sum(mst.cramt) dsgui, sum(mst.tdbal) soducuoi
from gl1.tbgl_mast mst, cm1.tbcm_general gen, dp1.tbdp_dptp dpt
where mst.trdt = &h_trdt
and mst.acctcd like '4%'
and mst.dramt + mst.cramt <> 0 --276046
and gen.brcd = '1000'
and mst.custseq = gen.custseq
and gen.custtpcd not in ('100', '600')
and dpt.brcd = '2000'
and mst.acctcd = dpt.dpac
group by  mst.custseq, gen.nmloc, mst.ccy)
