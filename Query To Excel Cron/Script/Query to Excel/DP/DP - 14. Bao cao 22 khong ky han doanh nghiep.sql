--define h_trdt = '20100705'

SELECT
						brcd, custseq, ccycd, locdpnm, dpac, sodudau, wd, dp, abs(dp - wd) chenhlech, sodudau - wd + dp soducuoi, code
FROM
(
	SELECT DISTINCT
					dmd.BRCD BRCD, dmd.CUSTSEQ, dmd.CCYCD, tpdp.dpac, trim(tpdp.locdpnm) locdpnm,
					sum(TRL.BFTRBAL)  SODUDAU,
					sum(decode(sign(bftrbal - aftrbal), 1, acctccydpamt + acctccyodamt, 0)) WD,
					sum(decode(sign(bftrbal - aftrbal), -1, acctccydpamt + acctccyodamt, 0)) DP, TRL.STSSBCD code
	FROM
	(	SELECT BRCD, DPTPCD, ACCTSEQ, CUSTSEQ, CCYCD
		FROM TBDP_DMDMST
		WHERE BRCD like '%'
		AND DPTPCD NOT IN ('101', '102', '111')
		AND CCYCD like '%'
	) dmd,
				(	SELECT BRCD, CUSTSEQ, NM, SHRTNM, NMLOC, SHRTNMLOC
					FROM CM1.TBCM_GENERAL
					WHERE BRCD like '%'
					AND CUSTTPCD = '200'
				) gen, TBDP_TRLST trl, dp1.tbdp_dptp tpdp
	WHERE
					dmd.BRCD = trl.BRCD			AND dmd.DPTPCD = trl.DPTPCD			AND dmd.ACCTSEQ = trl.ACCTSEQ
		AND 	dmd.BRCD = gen.BRCD			AND dmd.CUSTSEQ= gen.CUSTSEQ
		AND 	dmd.BRCD	 = tpdp.BRCD			AND dmd.DPTPCD = tpdp.DPTPCD		AND trl.TRDT = &h_trdt
	GROUP BY dmd.CCYCD, dmd.CUSTSEQ, TRL.BFTRBAL, dmd.BRCD, tpdp.dpac, tpdp.locdpnm, TRL.STSSBCD
)
