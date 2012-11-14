SELECT BRCD,
	ROUND(SUM(TBLCP_AMT)/1000) TBLCP_AMT,
	ROUND(SUM(TTLCP_AMT)/1000) TTLCP_AMT,
	ROUND(SUM(GNTP_AMT)/1000) GNTP_AMT,
	ROUND(SUM(TTNTP_AMT)/1000) TTNTP_AMT,
	ROUND(SUM(CKCTP_AMT)/1000) CKCTP_AMT,
	ROUND(SUM(TBLCC_AMT)/1000) TBLCC_AMT,
	ROUND(SUM(TTLCC_AMT)/1000) TTLCC_AMT,
	ROUND(SUM(GNTC_AMT)/1000) GNTC_AMT,
	ROUND(SUM(TTNTC_AMT)/1000) TTNTC_AMT,
	ROUND(SUM(CKCTC_AMT)/1000) CKCTC_AMT
	FROM
	(
	SELECT S.BRCD,
	SUM( CS1.excrosscal( S.BRCD,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),S.CCYCD,S.TBLCP_AMT,'01','USD','01')) TBLCP_AMT,
	SUM( CS1.excrosscal(S.BRCD,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),S.CCYCD,S.TTLCP_AMT,'01','USD','01')) TTLCP_AMT,
	SUM( CS1.excrosscal(S.BRCD,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),S.CCYCD,S.GNTP_AMT,'01','USD','01')) GNTP_AMT,
	SUM( CS1.excrosscal(S.BRCD,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),S.CCYCD,S.TTNTP_AMT,'01','USD','01')) TTNTP_AMT,
	SUM( CS1.excrosscal(S.BRCD,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),S.CCYCD,S.CKCTP_AMT,'01','USD','01')) CKCTP_AMT,
	0 TBLCC_AMT,
	0 TTLCC_AMT,
	0 GNTC_AMT,
	0 TTNTC_AMT,
	0 CKCTC_AMT
	FROM
	    (
	SELECT	BRCD, '1.TBL/C' BUS, CCYCD,
	Sum(Decode(sign(to_number(MSGRCPTDT)- to_number(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))),1,0,CRDTAMT)) TBLCP_AMT,
	0 TTLCP_AMT,
	0 GNTP_AMT,
	0 TTNTP_AMT,
	0 CKCTP_AMT
	FROM	TBTF_EXOPN
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	((ADVFLG Is Null) OR (ADVFLG = '1')) AND
	((MSGRCPTDT >= &h_startdt) AND (MSGRCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt)))
	GROUP BY 	BRCD,CCYCD
	union
	SELECT	BRCD,'2.TTL/C' BUS, STLCCYCD,
	0 TBLCP_AMT,
	Sum(DECODE(NEGOTRREF,'ESC',TOTALAMT,'EUC',TOTALAMT,NETAMT))  TTLCP_AMT,
	0 GNTP_AMT,
	0 TTNTP_AMT,
	0 CKCTP_AMT
	FROM	TBTF_EXCRD
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('ESP','EUP','ESC','EUC')) AND
	((STLDT >= &h_startdt) AND (STLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt)))
	GROUP BY	BRCD,STLCCYCD
	union
	SELECT	BRCD,'3.GNT' BUS, CCYCD,
	0 TBLCP_AMT,
	0 TTLCP_AMT,
	Sum(Decode(sign(to_number(NEGODT) - to_number(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))),1,0, DECODE(NEGOTRREF,'EAC',NEGOAMT,'EPC',NEGOAMT,DOCAMT))) GNTP_AMT,
	0 TTNTP_AMT,
	0 CKCTP_AMT
	FROM	TBTF_EXNCO
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('EDP','EDA','EPC','EAC')) AND
	((NEGODT >= &h_startdt) AND (NEGODT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt)))
	GROUP BY	BRCD,CCYCD
	union
	SELECT	BRCD,'4.TTNT' BUS, STLCCYCD,
	0 TBLCP_AMT,
	0 TTLCP_AMT,
	0 GNTP_AMT,
	Sum(Decode(sign(to_number(STLDT) - to_number(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))),1,0, DECODE(NEGOTRREF,'EPC',TOTALAMT,'EAC',TOTALAMT,NETAMT))) TTNTP_AMT,
	0 CKCTP_AMT
	FROM	TBTF_EXCRD
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('EDP','EDA','EPC','EAC')) AND
	((STLDT >= &h_startdt) AND (STLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt)))
	GROUP BY	BRCD,STLCCYCD
	union
	SELECT	BRCD,'5.CKCT' BUS, CCYCD,
	0 TBLCP_AMT,
	0 TTLCP_AMT,
	0 GNTP_AMT,
	0 TTNTP_AMT,
	Sum(Decode(sign(to_number(NEGODT) - to_number(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))),1,0, CS1.excrosscal(BRCD,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), CCYCD, NEGOAMT,'01','USD','01'))) CKCTP_AMT
	FROM	TBTF_EXNCO
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('ESP','EUP','EDP','EDA')) AND
	((NEGODT >= &h_startdt) AND (NEGODT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt)))
	GROUP BY BRCD,CCYCD
	)S
	GROUP BY	S.BRCD
	UNION ALL
	SELECT Q.BRCD,
	0 TBLCP_AMT,
	0 TTLCP_AMT,
	0 GNTP_AMT,
	0 TTNTP_AMT,
	0 CKCTP_AMT,
	SUM( CS1.excrosscal( Q.BRCD,'VND',&h_trdt,Q.CCYCD,Q.TBLCC_AMT,'01','USD','01')) TBLCC_AMT,
	SUM( CS1.excrosscal( Q.BRCD,'VND',&h_trdt,Q.CCYCD,Q.TTLCC_AMT,'01','USD','01')) TTLCC_AMT,
	SUM( CS1.excrosscal( Q.BRCD,'VND',&h_trdt,Q.CCYCD,Q.GNTC_AMT,'01','USD','01')) GNTC_AMT,
	SUM( CS1.excrosscal( Q.BRCD,'VND',&h_trdt,Q.CCYCD,Q.TTNTC_AMT,'01','USD','01')) TTNTC_AMT,
	SUM( CS1.excrosscal( Q.BRCD,'VND',&h_trdt,Q.CCYCD,Q.CKCTC_AMT,'01','USD','01')) CKCTC_AMT
	FROM
	    (
	SELECT	BRCD, '1.TBL/C' BUS, CCYCD,
	Sum(Decode(sign(to_number(MSGRCPTDT)- to_number(&h_predt)),1,CRDTAMT,0)) TBLCC_AMT,
	0 TTLCC_AMT,
	0 GNTC_AMT,
	0 TTNTC_AMT,
	0 CKCTC_AMT
	FROM	TBTF_EXOPN
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	((ADVFLG Is Null) OR (ADVFLG = '1')) AND
	((MSGRCPTDT >= &h_trdt) AND (MSGRCPTDT <= &h_trdt))
	GROUP BY 	BRCD,CCYCD
	union
	SELECT	BRCD,'2.TTL/C' BUS, STLCCYCD,
	0 TBLCC_AMT,
	Sum(DECODE(NEGOTRREF,'ESC',TOTALAMT,'EUC',TOTALAMT,NETAMT))  TTLCC_AMT,
	0 GNTC_AMT,
	0 TTNTC_AMT,
	0 CKCTC_AMT
	FROM	TBTF_EXCRD
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('ESP','EUP','ESC','EUC')) AND
	((STLDT >= &h_trdt) AND (STLDT <= &h_trdt))
	GROUP BY	BRCD,STLCCYCD
	union
	SELECT	BRCD,'3.GNT' BUS, CCYCD,
	0 TBLCC_AMT,
	0 TTLCC_AMT,
	Sum(Decode(sign(to_number(NEGODT) - to_number(&h_predt)),1,DECODE(NEGOTRREF,'EAC',NEGOAMT,'EPC',NEGOAMT,DOCAMT), 0)) GNTC_AMT,
	0 TTNTC_AMT,
	0 CKCTC_AMT
	FROM	TBTF_EXNCO
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('EDP','EDA','EPC','EAC')) AND
	((NEGODT >= &h_trdt) AND (NEGODT <= &h_trdt))
	GROUP BY	BRCD,CCYCD
	union
	SELECT	BRCD,'4.TTNT' BUS, STLCCYCD,
	0 TBLCC_AMT,
	0 TTLCC_AMT,
	0 GNTC_AMT,
	Sum(Decode(sign(to_number(STLDT) - to_number(&h_predt)),1,DECODE(NEGOTRREF,'EPC',TOTALAMT,'EAC',TOTALAMT,NETAMT), 0)) TTNTC_AMT,
	0 CKCTC_AMT
	FROM	TBTF_EXCRD
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('EDP','EDA','EPC','EAC')) AND
	((STLDT >= &h_trdt) AND (STLDT <= &h_trdt))
	GROUP BY	BRCD,STLCCYCD
	union
	SELECT	BRCD,'5.CKCT' BUS, CCYCD,
	0 TBLCC_AMT,
	0 TTLCC_AMT,
	0 GNTC_AMT,
	0 TTNTC_AMT,
	Sum(Decode(sign(to_number(NEGODT) - to_number(&h_predt)),1,CS1.excrosscal(BRCD,'VND',&h_trdt, CCYCD, NEGOAMT,'01','USD','01'), 0)) CKCTC_AMT
	FROM	TBTF_EXNCO
	WHERE	(BRCD like '%') AND
	(DELFLG = 'N' OR DELFLG IS NULL) AND
	(CNCLFLG= 'N' OR CNCLFLG IS NULL) AND
	(NEGOTRREF in ('ESP','EUP','EDP','EDA')) AND
	((NEGODT >= &h_trdt) AND (NEGODT <= &h_trdt))
	GROUP BY BRCD,CCYCD
	)Q
	GROUP BY	Q.BRCD
	)
	GROUP BY	BRCD
