SELECT BRCD, ITDNM TENNGUOIGIOITHIEU, ITDIDNO, ITDIDDT, ITDIDPLACE, ITDCUSTSEQ, ITDREFNO,
	PSTDTNM TENNGUOIDUOCGIOITHIEU, PSTDTIDNO, PSTDTIDDT, PSTDTIDPLACE, PSTDTCUSTSEQ, STUDENTNAME,
	STUDENTID, PASSPORT, PPDT, PPPLACE, REFNO, DISAMT, OPRDT, DEPTCD, USRID, OPRFLG,
	TRACCY, SUM(TRAAMT) DOANHSONGUOIGIOITHIEU, SUM(USDAMT) QUIDOIUSD,
	SUM(AMT) DOANHSONGUOIDUOCGIOITHIEU, SUM(USD_AMT) QUYDOIUSD
FROM
(
SELECT A.* , B.TRACCY, B.TRAAMT, B.USDAMT, 0 AMT, 0 USD_AMT
FROM EI1.TBEI_STUDENT_SALES A, FX1.TBFX_ORMASTER B
WHERE
	A.ITDREFNO = B.BRCD||B.TRREF||B.TRSEQ
	AND A.OPRFLG <> 'D'
UNION ALL
SELECT A.* , B.TRACCY, 0 TRAAMT, 0 USDAMT, B.TRAAMT AMT, B.USDAMT USD_AMT
FROM EI1.TBEI_STUDENT_SALES A, FX1.TBFX_ORMASTER B
WHERE
	A.REFNO = B.BRCD||B.TRREF||B.TRSEQ
	AND A.OPRFLG <> 'D'
)
GROUP BY BRCD, ITDNM, ITDIDNO, ITDIDDT, ITDIDPLACE, ITDCUSTSEQ, ITDREFNO,
	PSTDTNM, PSTDTIDNO, PSTDTIDDT, PSTDTIDPLACE, PSTDTCUSTSEQ, STUDENTNAME,
	STUDENTID, PASSPORT, PPDT, PPPLACE, REFNO, DISAMT, OPRDT, DEPTCD, USRID, OPRFLG, TRACCY

