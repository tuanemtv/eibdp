--define h_trdt = '20120824'

SELECT
	a.KIND, a.TRDT, a.DYHBR, a.CRTUSR, a.DYSEQ
	, DECODE(SUBSTR(e.DEPTCD,3,1),'O','PGD','CHI NHANH') INFO, e.DEPTCD, e.DEPTNM
	, DECODE(b.CUSTTPCD,'100','CA NHAN','DOANH NGHIEP') CUSTTP, a.CUSTNO, a.CUSTNM
	, a.CCY, a.AMT, a.CPCCY, a.CPAMT, a.EXRT, d.MKEXRT CLX, a.REMARK
FROM (
	--// BAN NGOAI TE CHO KH
	SELECT
		'SELL' KIND
		, b.TRADATE TRDT, b.HANDBR DYHBR, b.OPUSER CRTUSR, b.DASEQ DYSEQ
		, a.CUSTNO, a.ORDCUST CUSTNM
		, b.TRACCY CCY, b.TRAAMT AMT, 'VND' CPCCY, (b.TRAAMT*b.TRAEXRT) CPAMT
		, b.TRAEXRT EXRT, b.REMARK
	FROM FX1.TBFX_ORMASTER a, FX1.TBFX_ORDETAIL b
	WHERE
		a.BRCD = b.BRCD AND a.TRREF = b.TRREF AND a.TRSEQ = b.TRSEQ
		AND b.TRCD IN('W011', 'W017')
		AND b.OPENFLG = '1'
		AND b.TRADATE = &h_trdt
		AND EXISTS (
			SELECT 1
			FROM FX1.TBFX_ORCNPDTL d
			WHERE
				d.BRCD = b.BRCD AND d.TRREF = b.TRREF AND d.TRSEQ = b.TRSEQ AND d.DTSEQ = b.DTSEQ
				AND d.CPCCY <> b.TRACCY
				AND d.CPSEQ <> (  --// khong lay phan thu phi
					SELECT NVL(MAX(u.CPSEQ),0)  --// dong cuoi la phan thu phi
					FROM FX1.TBFX_ORCNPDTL u
					WHERE
						u.BRCD = d.BRCD AND u.TRREF = d.TRREF AND u.TRSEQ = d.TRSEQ AND u.DTSEQ = d.DTSEQ
						AND EXISTS (
							SELECT 1
							FROM FX1.TBFX_ORACTDTL v
							WHERE
								v.BRCD = u.BRCD AND v.TRREF = u.TRREF AND v.TRSEQ = u.TRSEQ AND v.DTSEQ = u.DTSEQ
								AND v.COMMCD IS NOT NULL  --// co thu phi
						)
				)
		)
	UNION ALL
	--// BAN USD MAT CHO KH
	SELECT
		'SELL' KIND
		, b.TRADATE TRDT, b.HANDBR DYHBR, b.OPUSER CRTUSR, b.DASEQ DYSEQ
		, a.CUSTNO, a.CUSTNM
		, b.TRACCY CCY, b.TRAAMT AMT, 'VND' CPCCY, (b.TRAAMT*b.REGEXRT) CPAMT
		, b.REGEXRT EXRT, b.REMARK
	FROM FX1.TBFX_OTMASTER a, FX1.TBFX_OTDETAIL b
	WHERE
		a.BRCD = b.BRCD AND a.TRREF = b.TRREF AND a.TRSEQ = b.TRSEQ
		AND b.TRREF = 'FCS'  --// ban ngoai te cho KH
		AND b.DTSEQ = 1
		AND b.OPENFLG = '1'
		AND b.TRADATE = &h_trdt
		AND b.TRACCY NOT IN('GD1', 'GD2', 'GD3', 'GD4')  --// khong lay ban vang mat
		AND b.TRACCY <> 'VND'  --// khong lay ban vang tu CCA cua TTV
	UNION ALL
	--// MUA NGOAI TE CUA KH
	SELECT
		'BUY' KIND
		, b.TRADATE TRDT, b.HANDBR DYHBR, b.OPUSER CRTUSR, b.DASEQ DYSEQ
		, a.CUSTNO, a.BENCUST CUSTNM
		, b.TRACCY CCY, b.TRAAMT AMT, 'VND' CPCCY, (b.TRAAMT*b.TRAEXRT) CPAMT
		, b.TRAEXRT EXRT, b.REMARK
	FROM FX1.TBFX_IRMASTER a, FX1.TBFX_IRDETAIL b
	WHERE
		a.BRCD = b.BRCD AND a.TRREF = b.TRREF AND a.TRSEQ = b.TRSEQ
		AND b.TRCD IN('B012', 'W011', 'W021')
		AND b.OPENFLG = '1'
		AND b.TRADATE = &h_trdt
		AND EXISTS (
			SELECT 1
			FROM FX1.TBFX_IRCNPDTL d
			WHERE
				d.BRCD = b.BRCD AND d.TRREF = b.TRREF AND d.TRSEQ = b.TRSEQ AND d.DTSEQ = b.DTSEQ
				AND d.CPCCY <> b.TRACCY
		)
	UNION ALL
	--// MUA USD MAT CUA KH
	SELECT
		'BUY' KIND
		, b.TRADATE TRDT, b.HANDBR DYHBR, b.OPUSER CRTUSR, b.DASEQ DYSEQ
		, a.CUSTNO, a.CUSTNM
		, c.CCYCD CCY, c.AMOUNT AMT, 'VND' CPCCY, (c.AMOUNT*c.TRAEXRT) CPAMT
		, c.TRAEXRT EXRT, b.REMARK
	FROM FX1.TBFX_OTMASTER a, FX1.TBFX_OTDETAIL b, FX1.TBFX_OTACTDTL c
	WHERE
		a.BRCD = b.BRCD AND a.TRREF = b.TRREF AND a.TRSEQ = b.TRSEQ
		AND b.BRCD = c.BRCD AND b.TRREF = c.TRREF AND b.TRSEQ = c.TRSEQ AND b.DTSEQ = c.DTSEQ
		AND b.TRREF = 'FCB'  --// mua ngoai te cua khach hang
		AND b.DTSEQ = 1
		AND b.OPENFLG = '1'
		AND b.TRADATE = &h_trdt
		AND c.CCYCD NOT IN('GD1', 'GD2', 'GD3', 'GD4')  --// khong lay nhung giao dich mua vang mat
		AND c.DRCR = 'D'
		AND c.ACCTCD = a.TRAACCD  --// '103101'
	UNION ALL
	--// MUA NGOAI TE CUA KH
	SELECT
		'BUY' KIND
		, b.TRADATE TRDT, b.HANDBR DYHBR, b.OPUSER CRTUSR, b.DASEQ DYSEQ
		, a.CUSTNO, a.CUSTNM
		, b.TRACCY CCY, b.TRAAMT AMT, 'VND' CPCCY, (b.TRAAMT*b.TRAEXRT) CPAMT
		, b.TRAEXRT EXRT, b.REMARK
	FROM FX1.TBFX_TCMASTER a, FX1.TBFX_TCDETAIL b
	WHERE
		a.BRCD = b.BRCD AND a.TRREF = b.TRREF AND a.TRSEQ = b.TRSEQ
		AND b.OPENFLG = '1'
		AND b.TRADATE = &h_trdt
		AND EXISTS (
			SELECT 1
			FROM FX1.TBFX_TCCNPDTL d
			WHERE
				d.BRCD = b.BRCD AND d.TRREF = b.TRREF AND d.TRSEQ = b.TRSEQ AND d.DTSEQ = b.DTSEQ
				AND d.CPCCY <> b.TRACCY
				AND d.CPSEQ <> (  --// khong lay phan thu phi
					SELECT NVL(MAX(u.CPSEQ),0)  --// dong cuoi la phan thu phi
					FROM FX1.TBFX_ORCNPDTL u
					WHERE
						u.BRCD = d.BRCD AND u.TRREF = d.TRREF AND u.TRSEQ = d.TRSEQ AND u.DTSEQ = d.DTSEQ
						AND EXISTS (
							SELECT 1
							FROM FX1.TBFX_ORACTDTL v
							WHERE
								v.BRCD = u.BRCD AND v.TRREF = u.TRREF AND v.TRSEQ = u.TRSEQ AND v.DTSEQ = u.DTSEQ
								AND v.COMMCD IS NOT NULL  --// co thu phi
						)
				)
		)
) a, CM1.TBCM_GENERAL b, GL1.TBGL_JNLMST c, GL1.TBGL_CLX d, CS1.TBCS_DEPTCD e
WHERE
	a.CUSTNO = b.CUSTSEQ
	AND a.TRDT = c.TRDT AND a.DYHBR = c.DYHBR AND a.CRTUSR = c.CRTUSR AND a.DYSEQ = c.DYSEQ
	AND c.TRDT = d.TRDT(+) AND c.DYHBR = d.DYHBR(+) AND c.CRTUSR = d.CRTUSR(+) AND c.DYSEQ = d.DYSEQ(+)
	AND c.DEPTCD = e.DEPTCD
	AND b.BRCD = '1000'  --// luon lay Hoi So
ORDER BY a.KIND, a.TRDT, a.DYHBR, a.CRTUSR, a.DYSEQ ;