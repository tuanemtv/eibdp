--define h_trdt ='20121113'

select brcd, nmloc, custseq, acctno, GUI, RUT,
		decode(sign(GUI-RUT),1,(GUI-RUT),(RUT- GUI)) Chenhlech,
		hbrcd, husrid, deptnmloc, remark, opndt, clsdt, matdt, locdpnm, ls, LOAI,
		CL chenhlech_th, 
		decode(substr(acctno,5,1),'6',
			  DECODE(opndt, clsdt,'DUNG HAN',decode(TRIM(clsdt),'','','TRUOC HAN')),'') TT
from
(
	--khong ky han
	select rank, brcd, nmloc, custseq, acctno, sum(GUI) GUI, sum(RUT) RUT,
		CL, hbrcd, husrid, deptnmloc, remark, opndt, clsdt, matdt, locdpnm, ls, LOAI
	from
	(
		select rank, com.brcd, gen.nmloc, com.custseq,  idx.acctno,
		        decode(sign(trl.aftrbal - trl.bftrbal),1, trl.ACCTCCYDPAMT, 0 ) GUI,
		        decode(sign(trl.bftrbal - trl.aftrbal),1, trl.ACCTCCYDPAMT, 0 ) RUT,
				com.TONG_GUI, com.TONG_RUT, com.CL,
				trl.HBRCD,
				trl.HUSRID,
				deptnmloc,
				trl.REM remark,
				dmd.opndt,
				dmd.clsdt,
				'99991231' matdt,
				idx.locdpnm,
				bsi.bsir ls,
				decode (substr(dptp.dpac,1,3),'433','TIET KIEM','TIEN GUI') LOAI
		from
		(
			select rownum rank, brcd, custseq,  TONG_GUI, TONG_RUT, CL
			from
			(
				select brcd, custseq,  sum(Tonggui) TONG_GUI, sum(Tongrut) TONG_RUT,
					decode(sign(SUM(Tonggui)-SUM(Tongrut)),1,(SUM(Tonggui)-SUM(Tongrut)),(SUM(Tongrut)- SUM(Tonggui))) CL
				from
				(
				    select a.brcd,a.custseq,
					sum(decode(sign(d.aftrbal-d.bftrbal),1, d.ACCTCCYDPAMT, 0 )) Tonggui,
					sum(decode(sign(d.bftrbal-d.aftrbal),1, d.ACCTCCYDPAMT, 0 ))Tongrut
					from tbdp_idxacct a, tbdp_trlst d
					where d.cncltrflg='0'
					and d.tgtflg='0'
					and a.ccycd = 'VND'
					and a.brcd=d.brcd
					and a.dptpcd=d.dptpcd
					and a.acctseq=d.acctseq
					and d.trdt  = &h_trdt
					and decode(substr(d.dptpcd,1,1),'6',decode(d.trcd,'W060','1','W160','1','W360','1','0'),'1') = '1'
					group by a.brcd,a.custseq
				)
				group by  brcd, custseq
				order by  CL desc
			)
		) com, tbcm_general gen, tbdp_idxacct idx, tbdp_trlst trl,
		(	select usr.BRCD, USRID,  BUSCD, DEPTNM, DEPTNMLOC
			from TBRC_USR1 usr, TBCS_DEPTCD dep
			where usr.DEPTCD=dep.DEPTCD
		) usr, tbdp_dmdmst dmd,  tbcs_bsircd bsi, tbdp_ccyspec spc, tbdp_dptp dptp
		where com.brcd = gen.brcd
		and com.custseq = gen.custseq
		and com.brcd = dmd.brcd
		and com.custseq = dmd.custseq
		and dmd.brcd = idx.brcd
		and dmd.dptpcd = idx.dptpcd
		and dmd.acctseq = idx.acctseq
		and dmd.opncnclflg='0'
		and trl.cncltrflg='0'
		and trl.tgtflg='0'
		and dmd.ccycd ='VND'
		and trl.trdt = &h_trdt
		and idx.brcd = trl.brcd
		and idx.dptpcd = trl.dptpcd
		and idx.acctseq = trl.acctseq
		and gen.custtpcd ='100'
		and trl.hbrcd=usr.brcd
		and trl.husrid=usr.usrid
		and dmd.brcd = bsi.brcd
		and dmd.ccycd = bsi.ccycd
		and dmd.brcd = spc.brcd
		and dmd.dptpcd = spc.dptpcd
		and dmd.ccycd = spc.ccycd
		and bsi.brcd =spc.brcd
		and bsi.ccycd =spc.ccycd
		and bsi.bsrtcd = spc.bsrtcd
		and bsi.nxtappldt = '99991231'
		and dmd.brcd=dptp.brcd
		and dmd.dptpcd = dptp.dptpcd
	)
	group by rank, brcd, nmloc, custseq, acctno, CL, hbrcd, husrid, deptnmloc, remark, opndt, clsdt, matdt, locdpnm, ls, LOAI


	union all
	--ckh
	select rank, brcd, nmloc, custseq, acctno, sum(GUI) GUI, sum(RUT) RUT,
		CL, hbrcd, husrid, deptnmloc, remark, opndt, clsdt, matdt, locdpnm, ls, LOAI
	from
	(
		select rank, com.brcd, gen.nmloc, com.custseq,  idx.acctno,
		        decode(sign(trl.aftrbal - trl.bftrbal),1, trl.ACCTCCYDPAMT, 0 ) GUI,
		        decode(sign(trl.bftrbal - trl.aftrbal),1, trl.ACCTCCYDPAMT, 0 ) RUT,
				com.TONG_GUI, com.TONG_RUT, com.CL,
				trl.HBRCD,
				trl.HUSRID,
				deptnmloc,
				trl.REM remark,
				decode(sav.erclint,'017',decode(trim(sav.PREDPCAPDT),'',sav.OPNDT,sav.PREDPCAPDT),sav.OPNDT) OPNDT,
				sav.clsdt,
				decode(sav.erclint,'017',NXTDPCAPDT,sav.matdt) matdt,
				idx.locdpnm,
				scl.acmtmdpfrt ls,
				decode (substr(dptp.dpac,1,3),'433','TIET KIEM','TIEN GUI') LOAI
		from
		(
			select rownum rank, brcd, custseq,  TONG_GUI, TONG_RUT, CL
			from
			(
				select brcd, custseq,  sum(Tonggui) TONG_GUI, sum(Tongrut) TONG_RUT,
					decode(sign(SUM(Tonggui)-SUM(Tongrut)),1,(SUM(Tonggui)-SUM(Tongrut)),(SUM(Tongrut)- SUM(Tonggui))) CL
				from
				(
					--KKH
				    select a.brcd,a.custseq,
					sum(decode(sign(d.aftrbal-d.bftrbal),1, d.ACCTCCYDPAMT, 0 )) Tonggui,
					sum(decode(sign(d.bftrbal-d.aftrbal),1, d.ACCTCCYDPAMT, 0 ))Tongrut
					from tbdp_idxacct a, tbdp_trlst d
					where d.cncltrflg='0'
					and d.tgtflg='0'
					and a.ccycd = 'VND'
					and a.brcd=d.brcd
					and a.dptpcd=d.dptpcd
					and a.acctseq=d.acctseq
					and d.trdt  = &h_trdt
					and decode(substr(d.dptpcd,1,1),'6',decode(d.trcd,'W060','1','W160','1','W360','1','0'),'1') = '1'
					group by a.brcd,a.custseq
				)
				group by  brcd, custseq
				order by  CL desc
			)
		) com, tbcm_general gen, tbdp_idxacct idx, tbdp_trlst trl,
		(	select usr.BRCD, USRID,  BUSCD, DEPTNM, DEPTNMLOC
			from TBRC_USR1 usr, TBCS_DEPTCD dep
			where usr.DEPTCD=dep.DEPTCD
		) usr, tbdp_savmst sav, tbdp_sclrbal scl, tbdp_dptp dptp
		where com.brcd = gen.brcd
		and com.custseq = gen.custseq
		and com.brcd = sav.brcd
		and com.custseq = sav.custseq
		and sav.brcd = idx.brcd
		and sav.dptpcd = idx.dptpcd
		and sav.acctseq = idx.acctseq
		and sav.opncnclflg='0'
		and trl.cncltrflg='0'
		and trl.tgtflg='0'
		and sav.ccycd ='VND'
		and trl.trdt = &h_trdt
		and idx.brcd = trl.brcd
		and idx.dptpcd = trl.dptpcd
		and idx.acctseq = trl.acctseq
		and gen.custtpcd ='100'
		and trl.hbrcd=usr.brcd
		and trl.husrid=usr.usrid
		and trl.trcd in ('W060','W160','W360')
		and sav.brcd=scl.brcd
		and sav.dptpcd=scl.dptpcd
		and sav.acctseq=scl.acctseq
		and scl.clrdt=
		(	SELECT MAX(D.CLRDT)
			FROM TBDP_SCLRBAL D
			WHERE D.BRCD = scl.BRCD
			AND D.DPTPCD = scl.DPTPCD
			AND D.ACCTSEQ = scl.ACCTSEQ
			AND D.CLRDT <= &h_trdt
		)
		and sav.brcd=dptp.brcd
		and sav.dptpcd = dptp.dptpcd
	)
	group by rank, brcd, nmloc, custseq, acctno, CL, hbrcd, husrid, deptnmloc, remark, opndt, clsdt, matdt, locdpnm, ls, LOAI
)
order by rank

