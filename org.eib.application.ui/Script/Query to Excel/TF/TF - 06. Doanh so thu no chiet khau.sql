SELECT A.BRCD MACHINHANH, B.ENGBRSHRTNM TENCHINHANH,
	A.CUSTSEQ MAKHACHHANG, GEN.NM TENKHACHHANG,
	A.CCY NGUYENTE, SUM(A.AMT) DOANHSO,
	SUM(CS1.EXCROSSCAL(A.BRCD,'VND',&h_trdt, A.CCY, A.AMT,'01','VND','01')) DOANHSOQUYDOIVND
FROM
(
	SELECT P.BRCD, P.NEGOTRREF, P.NEGOTRSEQ, L.CUSTSEQ, P.CRDCCYCD CCY, P.TOTALAMT AMT
	FROM
		TF1.TBTF_EXCRD P, TF1.TBTF_TRLOG L
	WHERE
		P.BRCD LIKE '%'
		AND P.NEGOTRREF IN ('ESP','EUP','EDP','EDA','TTR','TTA')
		AND P.STLDT = &h_trdt
		AND NVL(TRIM(P.CNCLFLG),' ') <> 'Y'
		AND NVL(TRIM(P.DELFLG),' ') <> 'Y'
		AND P.BRCD = L.BRCD
		AND P.NEGOTRREF = L.TRREF
		AND P.NEGOTRSEQ = L.TRSEQ
		AND P.PARTSEQ = L.TRSUBSEQ
		AND L.TRCD IN ('W711')
		AND TRIM(L.DELUSRID) IS NULL
		AND TRIM(L.VRFCTNTRFLG) = 'Y'
		AND TRIM(L.VRFCNTUSRID) IS NOT NULL
	UNION ALL
	SELECT P.BRCD, P.NEGOTRREF, P.NEGOTRSEQ, L.CUSTSEQ, P.RFCCYCD CCY, P.DSHNRRFAMT AMT
	FROM
		TF1.TBTF_EXDSH P, TF1.TBTF_TRLOG L
	WHERE
		P.BRCD LIKE '%'
		AND P.NEGOTRREF IN ('ESP','EUP','EDP','EDA','TTR','TTA')
		AND P.DHRRFFLG = 'Y'
		AND P.OPTDT = &h_trdt
		AND NVL(TRIM(P.CNCLFLG),' ') <> 'Y'
		AND NVL(TRIM(P.DELFLG),' ') <> 'Y'
		AND P.BRCD = L.BRCD
		AND P.NEGOTRREF = L.TRREF
		AND P.NEGOTRSEQ = L.TRSEQ
		AND P.DSHNRSEQ = L.TRSUBSEQ
		AND L.TRCD IN ('W551')
		AND TRIM(L.DELUSRID) IS NULL
)A, CS1.TBCS_BRCD B, CM1.TBCM_GENERAL GEN
WHERE
	A.BRCD = B.BRCD
	AND A.BRCD = GEN.BRCD
	AND A.CUSTSEQ = GEN.CUSTSEQ
GROUP BY A.BRCD, B.ENGBRSHRTNM, A.CUSTSEQ, GEN.NM, A.CCY
ORDER BY A.BRCD, A.CUSTSEQ