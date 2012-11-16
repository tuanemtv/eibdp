SELECT P.BRCD MACHINHANH, B.ENGBRSHRTNM TENCHINHANH,
	L.CUSTSEQ MAKHACHHANG, GEN.NM TENKHACHHANG,
	P.PYCCYCD NGUYENTE, SUM(P.PYAMT) DOANHSO,
	SUM(CS1.EXCROSSCAL(P.BRCD,'VND',&h_trdt, P.PYCCYCD, P.PYAMT,'01','VND','01')) DOANHSOQUYDOIVND
FROM
	TF1.TBTF_EXPYMNT P, TF1.TBTF_TRLOG L,
	CS1.TBCS_BRCD B, CM1.TBCM_GENERAL GEN
WHERE
	P.BRCD LIKE '%'
	AND P.NEGOTRREF IN ('ESP','EUP','EDP','EDA','TTR','TTA')
	AND P.PYDT = &h_trdt
	AND NVL(TRIM(P.CNCLFLG),' ') <> 'Y'
	AND NVL(TRIM(P.DELFLG),' ') <> 'Y'
	AND P.BRCD = L.BRCD
	AND P.NEGOTRREF = L.TRREF
	AND P.NEGOTRSEQ = L.TRSEQ
	AND P.PYSEQ = L.TRSUBSEQ
	AND L.TRCD IN ('W501','W521')
	AND TRIM(L.DELUSRID) IS NULL
	AND TRIM(L.VRFCTNTRFLG) = 'Y'
	AND TRIM(L.VRFCNTUSRID) IS NOT NULL
	AND P.BRCD = B.BRCD
	AND L.BRCD = GEN.BRCD
	AND L.CUSTSEQ = GEN.CUSTSEQ
GROUP BY P.BRCD, B.ENGBRSHRTNM, L.CUSTSEQ, GEN.NM, P.PYCCYCD
ORDER BY P.BRCD, L.CUSTSEQ