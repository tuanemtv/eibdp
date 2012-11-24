--DEFINE h_trdt = '20120417'

SELECT BRCD MACD,
	CHINHANH,
	DEPTCD MAPGD,
	PHONGGIAODICH,
	SUM(TK) TGTK,
	SUM(TT) TGTT,
	SUM(GT) GTCG,
	SUM(VGH) VANGGH,
	SUM(TT)+SUM(TK)+SUM(GT)+SUM(VGH) TONG
FROM
(
	SELECT BRCD,CHINHANH, DEPTCD, PHONGGIAODICH, SODU TT, 0 TK, 0 GT, 0 VGH
	FROM
	(
		select a.brcd BRCD,	brcd.lclbrnm CHINHANH,
			nvl(trim(offi.deptnmloc), brcd.LCLBRNM) PHONGGIAODICH,
			a.dptpcd TYPECODE, b.acctcd ACCTCD, b.ccy CCY,
			cs1.excrosscal('1000', 'VND', &h_trdt, NVL(b.ccy, 'VND'), NVL(b.ldrbal, 0), '01', 'VND', '01') SODU,
			idx.deptcd DEPTCD
		from dp1.tbdp_dptp a, gl1.tbgl_baldd b ,
			cm1.tbcm_general c, DP1.TBDP_IDXACCT idx,
			cs1.tbcs_brcd brcd, cs1.tbcs_deptcd offi, gl1.tbgl_sbvcd s
		where a.brcd LIKE '%'
			and a.brcd = b.brcd
			and b.trdt = &h_trdt
			and a.dptpcd(+) =b.trref
			and b.ccy like '%'
			and b.acctcd like '4%'
			and b.acctcd not like '433%'
			and b.trref <> 'GEO'
			and b.acctcd not in ('466200','466400')
			and b.buscd ='DP'
			and b.acctcd = s.acctcd
			and s.bccyfg = decode(b.ccy,'VND','1',decode(b.ccy,'GD1','3','2'))
			and substr(s.sbvcd,1,3) in ('421','422','425','426','427','428')
			and c.brcd ='1000'
			and b.custseq =c.custseq
			and c.custtpcd like decode( '', '1', '100', '%')
			and c.custtpcd not like decode( '','1','999','2','100','999')
			and b.ldrbal > 0
			and b.brcd = idx.brcd
			and b.trref = idx.dptpcd
			and b.trseq = idx.acctseq
			and b.custseq = idx.custseq
			and b.ccy = idx.ccycd
			and idx.brcd = offi.brcd(+)
			and idx.deptcd = offi.deptcd(+)
			and brcd.brcd = idx.brcd

		union all

		select  b.brcd BRCD, brcd.LCLBRNM CHINHANH, brcd.LCLBRNM PHONGGIAODICH,
				'000' TYPECODE, b.acctcd ACCTCD, b.ccy CCY,
				cs1.excrosscal( '1000', 'VND', &h_trdt, NVL(b.ccy, 'VND'), NVL(b.tdbal, 0), '01', 'VND', '01') SODU,
				'' DEPTCD
		from    gl1.tbgl_mast b, cm1.tbcm_general c, cs1.tbcs_brcd brcd
		where b.brcd like '%'
			and b.trdt = &h_trdt
			and b.ccy like '%'
			and b.acctcd in ('466400','466200')
			and b.tdbal > 0
			and c.brcd ='1000'
			and b.custseq = c.custseq
			and c.custtpcd like decode( '', '1', '100', '%')
			and c.custtpcd not like decode( '','1','999','2','100','999')
			and b.brcd = brcd.brcd
	)

UNION ALL

	SELECT BRCD,CHINHANH, DEPTCD, PHONGGIAODICH, 0 TT, SODU TK, 0 GT, 0 VGH
	FROM
	(
		select a.brcd BRCD,	brcd.lclbrnm CHINHANH,
			nvl(trim(offi.deptnmloc), brcd.LCLBRNM) PHONGGIAODICH,
			a.dptpcd TYPECODE, b.acctcd ACCTCD, b.ccy CCY,
			cs1.excrosscal( '1000', 'VND', &h_trdt, NVL(b.ccy, 'VND'), NVL(b.ldrbal, 0), '01', 'VND', '01') SODU,
			idx.deptcd DEPTCD
		from dp1.tbdp_dptp a, gl1.tbgl_baldd b ,
			cm1.tbcm_general c, DP1.TBDP_IDXACCT idx,
			cs1.tbcs_brcd brcd, cs1.tbcs_deptcd offi, gl1.tbgl_sbvcd sbv
		where a.brcd like '%'
			and a.brcd = b.brcd
			and b.trdt = &h_trdt
			and a.dptpcd(+) =b.trref
			and b.ccy like '%'
			and b.acctcd like '4%'
			and b.acctcd = sbv.acctcd
			and sbv.bccyfg = decode(b.ccy,'VND','1',decode(b.ccy,'GD1','3','2'))
			and substr(sbv.sbvcd,1,3) in ('423','424')
			and b.buscd ='DP'
			and c.brcd ='1000'
			and b.custseq =c.custseq
			and c.custtpcd like decode( '', '1', '100', '%')
			and c.custtpcd not like decode( '','1','999','2','100','999')
			and b.ldrbal > 0
			and b.brcd = idx.brcd
			and b.trref = idx.dptpcd
			and b.trseq = idx.acctseq
			and b.custseq = idx.custseq
			and b.ccy = idx.ccycd
			and idx.brcd = offi.brcd(+)
			and idx.deptcd = offi.deptcd(+)
			and brcd.brcd = idx.brcd
		order by b.custseq, b.acctcd, b.ccy
	)

UNION ALL

	SELECT BRCD,CHINHANH, DEPTCD, PHONGGIAODICH, 0 TT, 0 TK, SODU GT, 0 VGH
	FROM
	(
		SELECT E.LCLBRNM CHINHANH, NVL(TRIM(D.DEPTNMLOC), E.LCLBRNM) PHONGGIAODICH ,SUM(CS1.EXCROSSCAL( '1000', 'VND', &h_trdt, NVL(B.CCY, 'VND'), NVL(B.LDRBAL, 0), '01', 'VND', '01')) SODU, I.deptcd DEPTCD, B.BRCD
		FROM GL1.TBGL_BALDD B, GL1.TBGL_SBVCD S, CM1.TBCM_GENERAL C , CS1.TBCS_BRCD E, CS1.TBCS_DEPTCD D, DP1.TBDP_IDXACCT I
		WHERE B.BRCD LIKE '%'
			AND B.TRDT = &h_trdt
			AND B.CCY LIKE '%'
			AND B.LDRBAL > 0
			AND B.BUSCD ='DP'
			AND B.ACCTCD = S.ACCTCD
			AND S.BCCYFG = DECODE(B.CCY,'VND','1',DECODE(B.CCY, 'GD1','3','2'))
			AND SUBSTR(S.SBVCD,1,2) IN ('44','43')
			AND C.BRCD ='1000'
			AND B.CUSTSEQ = C.CUSTSEQ
			AND C.CUSTTPCD LIKE DECODE ( '', '1', '100', '%')
			AND C.CUSTTPCD NOT LIKE DECODE( '','1','999','2','100','999')
			AND I.BRCD = B.BRCD
			AND I.DPTPCD = B.TRREF
			AND I.ACCTSEQ = B.TRSEQ
			AND I.DEPTCD = D.DEPTCD(+)
			AND I.BRCD = D.BRCD (+)
			AND E.BRCD = I.BRCD
		GROUP BY E.LCLBRNM,D.DEPTNMLOC,B.BRCD,I.DEPTCD
	)
UNION ALL

	SELECT BRCD,CHINHANH, DEPTCD, PHONGGIAODICH, 0 TT, 0 TK, 0 GT, SODU VGH
	FROM
	(
		SELECT E.LCLBRNM CHINHANH, NVL(TRIM(D.DEPTNMLOC), E.LCLBRNM) PHONGGIAODICH ,SUM(CS1.EXCROSSCAL( '1000', 'VND', &h_trdt, NVL(B.CCY, 'VND'), NVL(B.LDRBAL, 0), '01', 'VND', '01')) SODU, I.deptcd DEPTCD, B.BRCD
		FROM GL1.TBGL_BALDD B, GL1.TBGL_SBVCD S, CM1.TBCM_GENERAL C , CS1.TBCS_BRCD E, CS1.TBCS_DEPTCD D, DP1.TBDP_IDXACCT I
		WHERE B.BRCD LIKE '%'
			AND B.TRDT = &h_trdt
			AND B.CCY LIKE '%'
			AND B.LDRBAL > 0
			AND B.BUSCD ='DP'
			AND B.ACCTCD = S.ACCTCD
			AND S.BCCYFG = DECODE(B.CCY,'VND','1',DECODE(B.CCY, 'GD1','3','2'))
			AND S.SBVCD = '4521'
			AND C.BRCD ='1000'
			AND B.CUSTSEQ = C.CUSTSEQ
			AND C.CUSTTPCD LIKE DECODE( '', '1', '100', '%')
			AND C.CUSTTPCD NOT LIKE DECODE( '','1','999','2','100','999')
			AND I.BRCD = B.BRCD
			AND I.DPTPCD = B.TRREF
			AND I.ACCTSEQ = B.TRSEQ
			AND I.DEPTCD = D.DEPTCD(+)
			AND I.BRCD = D.BRCD (+)
			AND E.BRCD = I.BRCD
		GROUP BY E.LCLBRNM,D.DEPTNMLOC,B.BRCD,I.DEPTCD
	)
)
GROUP BY BRCD, CHINHANH, DEPTCD,PHONGGIAODICH
ORDER BY BRCD
