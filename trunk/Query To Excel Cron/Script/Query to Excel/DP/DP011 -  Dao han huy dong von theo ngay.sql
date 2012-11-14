--define h_trdt = '20100617'

select ccycd, matdt, sum(curbal), sum(intamt)
from
(
	select  a.ccycd, a.matdt matdt, (a.curbal) curbal,
				(round(to_char(to_date(a.matdt,'YYYYMMDD')-to_date(a.opndt,'YYYYMMDD'))*a.curbal* d.acmtmdpfrt/100/decode(a.ccycd,'VND',360,360),
				decode(a.ccycd,'VND',0,2))) intamt
	from tbdp_savmst a, tbcm_general b  , tbdp_dptp c , tbdp_sclrbal d, tbdp_idxacct e
	where
				a.brcd like '' || '%'	and a.clsflg ='0'	--and a.matdt between :h_frdt 	and :h_todt
		and a.matdt between  &h_trdt  and TO_CHAR(ADD_MONTHS((TO_DATE(&h_trdt,'YYYYMMDD')),12),'YYYYMMDD')
		and a.brcd =b.brcd
		and a.curbal >0				
		and a.ccycd like '' || '%'   
		and a.custseq =b.custseq	
		and a.custseq like '' || '%'
		and a.brcd =c.brcd			
		and a.dptpcd =c.dptpcd			
		and a.brcd =d.brcd				
		and a.dptpcd =d.dptpcd				
		and a.acctseq =d.acctseq
		and a.opndt =d.clrdt		
		and a.brcd =e.brcd							
		and a.dptpcd =e.dptpcd		
		and a.acctseq =e.acctseq			
		and e.deptcd like '' || '%'
)
group by ccycd, matdt
