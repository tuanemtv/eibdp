--define h_trdt = '20100703'

select
			brcd, custseq, locdpnm, dpac,  ccycd, sodudau, wd, dp, abs(dp - wd) chenhlech, sodudau - wd + dp soducuoi, code
from
(
		SELECT 	BRCD, custseq, dpac, locdpnm, ccycd, sodudau, sum(DPTOTAMT_VND) dp, sum(WDTOTAMT_VND) wd, code
		FROM
		(
			SELECT 	a.BRCD,a.CUSTSEQ, a.dpac, a.locdpnm, a.ccycd,
								SUM(sodudau) sodudau, sum(a.sodu) DPTOTAMT_VND , sum(a.sodu) ,0 WDTOTAMT_VND, a.code
			FROM
			(
				SELECT 	sav.BRCD, sav.CUSTSEQ,  tpdp.dpac, trim(tpdp.locdpnm) locdpnm,
									sav.CCYCD , trl.ACCTCCYDPAMT sodu, TRL.BFTRBAL SODUDAU, TRL.STSSBCD code
				FROM dp1.TBDP_SAVMST sav, cm1.TBCM_GENERAL gen, dp1.TBDP_DPTP tpdp , dp1.TBDP_TRLST trl
				WHERE sav.BRCD like '%'					AND sav.BRCD=gen.BRCD				AND sav.CUSTSEQ=gen.CUSTSEQ
				AND sav.BRCD=trl.BRCD					AND sav.DPTPCD=trl.DPTPCD			AND sav.ACCTSEQ=trl.ACCTSEQ
				AND sav.BRCD=tpdp.BRCD				AND sav.DPTPCD = tpdp.DPTPCD	AND sav.OPNCNCLFLG='0'
				AND tpdp.CNTRMMTRM is not null	AND trl.TRCD in('W060','W160')		AND trl.TRDT  = &h_trdt
				AND tpdp.DPAC  like '431%'				AND sav.CCYCD like '%'						AND gen.CUSTTPCD = '200'
			) a
			group by a.BRCD, a.CUSTSEQ, a.CCYCD, a.dpac, a.locdpnm, a.code

			UNION ALL

			SELECT 	a.BRCD,a.CUSTSEQ, a.dpac, a.locdpnm,
								a.CCYCD, a.sodudau, 0 DPTOTAMT_VND ,  a.sodu, a.sodu WDTOTAMT_VND, a.code
			FROM
			(	SELECT BRCD, CUSTSEQ, dpac,  locdpnm, CCYCD,
								 sum(sodudau) sodudau, sum(sodu) sodu, code
				FROM
				(
					SELECT SAV.BRCD, SAV.CUSTSEQ,	TPDP.DPAC, TRIM(TPDP.LOCDPNM) LOCDPNM, SAV.CCYCD ,
									 TRL.ACCTCCYDPAMT SODU, TRL.BFTRBAL SODUDAU,  TRL.STSSBCD code
					FROM DP1.TBDP_SAVMST SAV, CM1.TBCM_GENERAL GEN, DP1.TBDP_TRLST TRL, DP1.TBDP_DPTP TPDP
					WHERE
										SAV.BRCD LIKE '%'				AND SAV.BRCD = GEN.BRCD				AND SAV.CUSTSEQ = GEN.CUSTSEQ
							AND SAV.BRCD=TRL.BRCD			AND SAV.DPTPCD=TRL.DPTPCD		AND SAV.ACCTSEQ=TRL.ACCTSEQ
							AND SAV.BRCD=TPDP.BRCD		    AND SAV.DPTPCD = TPDP.DPTPCD	AND SAV.OPNCNCLFLG='0'
							AND TRL.TRCD ='W360'				    AND TRL.TRDT= &h_trdt					AND SAV.CCYCD LIKE '%'
							AND TPDP.DPAC  LIKE '431%'		AND TPDP.CNTRMMTRM IS NOT NULL	AND GEN.CUSTTPCD = '200'
				)
				group by BRCD, CUSTSEQ,  CCYCD, dpac,  locdpnm, code
			) A
		)
		group by BRCD, CUSTSEQ, CCYCD, dpac, locdpnm, sodudau, code
)