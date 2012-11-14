	SELECT BRCD, ROUND(SUM(ILCB_ILS)/1000) ILCB_ILS, ROUND(SUM(ILCB_ILU)/1000) ILCB_ILU, ROUND(SUM(STLB_ILS)/1000) STLB_ILS, ROUND(SUM(STLB_ILU)/1000) STLB_ILU, ROUND(SUM(DOCB_IDP)/1000) DOCB_IDP, ROUND(SUM(DOCB_IDA)/1000) DOCB_IDA, ROUND(SUM(STLB_IDP)/1000) STLB_IDP, ROUND(SUM(STLB_IDA)/1000) STLB_IDA,
		ROUND(SUM(ILCA_ILS)/1000) ILCA_ILS, ROUND(SUM(ILCA_ILU)/1000) ILCA_ILU, ROUND(SUM(STLA_ILS)/1000) STLA_ILS, ROUND(SUM(STLA_ILU)/1000) STLA_ILU, ROUND(SUM(DOCA_IDP)/1000) DOCA_IDP, ROUND(SUM(DOCA_IDA)/1000) DOCA_IDA, ROUND(SUM(STLA_IDP)/1000) STLA_IDP, ROUND(SUM(STLA_IDA)/1000) STLA_IDA
	FROM (
		SELECT BRCD, SUM(ILCB_ILS) ILCB_ILS, SUM(ILCB_ILU) ILCB_ILU, SUM(STLB_ILS) STLB_ILS, SUM(STLB_ILU) STLB_ILU, SUM(DOCB_IDP) DOCB_IDP, SUM(DOCB_IDA) DOCB_IDA, SUM(STLB_IDP) STLB_IDP, SUM(STLB_IDA) STLB_IDA,
		0 ILCA_ILS, 0 ILCA_ILU, 0 STLA_ILS, 0 STLA_ILU, 0 DOCA_IDP, 0 DOCA_IDA, 0 STLA_IDP, 0 STLA_IDA
		FROM
		(
		SELECT BRCD, SUM(AMT) ILCB_ILS, 0 ILCB_ILU, 0 STLB_ILS, 0 STLB_ILU, 0 DOCB_IDP, 0 DOCB_IDA, 0 STLB_IDP, 0 STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'LCI' AND TRREF = 'ILS'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCB_ILS, SUM(AMT) ILCB_ILU, 0 STLB_ILS, 0 STLB_ILU, 0 DOCB_IDP, 0 DOCB_IDA, 0 STLB_IDP, 0 STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'LCI' AND TRREF = 'ILU'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCB_ILS, 0 ILCB_ILU, SUM(AMT) STLB_ILS, 0 STLB_ILU, 0 DOCB_IDP, 0 DOCB_IDA, 0 STLB_IDP, 0 STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'STL' AND TRREF = 'ILS'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCB_ILS, 0 ILCB_ILU, 0 STLB_ILS, SUM(AMT) STLB_ILU, 0 DOCB_IDP, 0 DOCB_IDA, 0 STLB_IDP, 0 STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 	AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  		OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'STL' AND TRREF = 'ILU'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCB_ILS, 0 ILCB_ILU, 0 STLB_ILS, 0 STLB_ILU, SUM(AMT) DOCB_IDP, 0 DOCB_IDA, 0 STLB_IDP, 0 STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'DOC' AND TRREF = 'IDP'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCB_ILS, 0 ILCB_ILU, 0 STLB_ILS, 0 STLB_ILU, 0 DOCB_IDP, SUM(AMT) DOCB_IDA, 0 STLB_IDP, 0 STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'DOC' AND TRREF = 'IDA'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCB_ILS, 0 ILCB_ILU, 0 STLB_ILS, 0 STLB_ILU, 0 DOCB_IDP, 0 DOCB_IDA, SUM(AMT) STLB_IDP, 0 STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 	AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 	OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'STL' AND TRREF = 'IDP'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCB_ILS, 0 ILCB_ILU, 0 STLB_ILS, 0 STLB_ILU, 0 DOCB_IDP, 0 DOCB_IDA, 0 STLB_IDP, SUM(AMT) STLB_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 	AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 	OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt), nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'BEFOR' AND CAT = 'STL' AND TRREF = 'IDA'
		GROUP BY BRCD
		)
		GROUP BY BRCD
		UNION ALL
		SELECT BRCD,0 ILCB_ILS, 0 ILCB_ILU, 0 STLB_ILS, 0 STLB_ILU, 0 DOCB_IDP, 0 DOCB_IDA, 0 STLB_IDP, 0 STLB_IDA,
		SUM(ILCA_ILS) ILCA_ILS, SUM(ILCA_ILU) ILCA_ILU, SUM(STLA_ILS) STLA_ILS, SUM(STLA_ILU) STLA_ILU, SUM(DOCA_IDP) DOCA_IDP, SUM(DOCA_IDA) DOCA_IDA, SUM(STLA_IDP) STLA_IDP, SUM(STLA_IDA) STLA_IDA
		FROM
		(
		SELECT BRCD, SUM(AMT) ILCA_ILS, 0 ILCA_ILU, 0 STLA_ILS, 0 STLA_ILU, 0 DOCA_IDP, 0 DOCA_IDA, 0 STLA_IDP, 0 STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'LCI' AND TRREF = 'ILS'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCA_ILS, SUM(AMT) ILCA_ILU, 0 STLA_ILS, 0 STLA_ILU, 0 DOCA_IDP, 0 DOCA_IDA, 0 STLA_IDP, 0 STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'LCI' AND TRREF = 'ILU'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCA_ILS, 0 ILCA_ILU, SUM(AMT) STLA_ILS, 0 STLA_ILU, 0 DOCA_IDP, 0 DOCA_IDA, 0 STLA_IDP, 0 STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 	AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 	OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'STL' AND TRREF = 'ILS'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCA_ILS, 0 ILCA_ILU, 0 STLA_ILS, SUM(AMT) STLA_ILU, 0 DOCA_IDP, 0 DOCA_IDA, 0 STLA_IDP, 0 STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 	AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 	OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'STL' AND TRREF = 'ILU'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCA_ILS, 0 ILCA_ILU, 0 STLA_ILS, 0 STLA_ILU, SUM(AMT) DOCA_IDP, 0 DOCA_IDA, 0 STLA_IDP, 0 STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'DOC' AND TRREF = 'IDP'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCA_ILS, 0 ILCA_ILU, 0 STLA_ILS, 0 STLA_ILU, 0 DOCA_IDP, SUM(AMT) DOCA_IDA, 0 STLA_IDP, 0 STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
			  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
			  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((SETLDT >=  &h_startdt AND SETLDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (SETLDT >= &h_trdt AND SETLDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'DOC' AND TRREF = 'IDA'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCA_ILS, 0 ILCA_ILU, 0 STLA_ILS, 0 STLA_ILU, 0 DOCA_IDP, 0 DOCA_IDA, SUM(AMT) STLA_IDP, 0 STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 	AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 	OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'STL' AND TRREF = 'IDP'
		GROUP BY BRCD

		UNION ALL

		SELECT BRCD, 0 ILCA_ILS, 0 ILCA_ILU, 0 STLA_ILS, 0 STLA_ILU, 0 DOCA_IDP, 0 DOCA_IDA, 0 STLA_IDP, SUM(AMT) STLA_IDA
		FROM (
		SELECT LC.BRCD, 'LCI' CAT,DECODE(LC.TRREF,'ISB','ILS',LC.TRREF) TRREF,LC.IMPRTTRSEQ TRSEQ,
			 		DECODE(SIGN(TO_DATE(LC.ISUDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
					cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(LC.LCCCYCD,'USD'),LC.LCNEWAMT,'01','USD','01') AMT
					FROM TBTF_IMLC LC ,TBTF_TRLOG LOG
					WHERE LC.BRCD like '%'
					  	AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					  	AND ((LC.ISUDT >=  &h_startdt AND LC.ISUDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR  (LC.ISUDT >= &h_trdt AND LC.ISUDT <= &h_trdt))
					  	AND LC.BRCD =LOG.BRCD AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
						AND LOG.UNTBUSCD ='IM' AND (LOG.OPRFLG = 'N' OR  LOG.OPRFLG = 'U') AND LOG.TRCD ='W001'
						AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
		UNION
		SELECT  LC.BRCD, 'LCI' CAT, DECODE(AJ.TRREF,'ISB','ILS',AJ.TRREF)TRREF,AJ.IMPRTTRSEQ TRSEQ,
				 DECODE(SIGN(TO_DATE(AJ.ADJDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(LC.BRCD ,'VND',&h_trdt, nvl(AJ.ADJCCYCD,'USD'),AJ.ADJAMT,'01','USD','01') AMT
				FROM   TBTF_IMLC LC, TBTF_TRLOG LOG ,TBTF_IMOBADJ AJ
				WHERE LC.BRCD like '%' AND (TRIM(LC.VRFCTNDT) IS NOT NULL)
					AND ((AJ.ADJDT >=  &h_startdt AND AJ.ADJDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))OR (AJ.ADJDT >= &h_trdt AND AJ.ADJDT <= &h_trdt))
					AND LC.BRCD =LOG.BRCD 	AND LC.TRREF=LOG.TRREF AND LC.IMPRTTRSEQ= LOG.TRSEQ
					AND LOG.UNTBUSCD ='IM' 	AND (LOG.OPRFLG = 'N' OR LOG.OPRFLG = 'U')AND LOG.TRCD ='W001'
					AND ((TRIM(LOG.DELDT) IS NULL) AND (TRIM(LOG.DELUSRID) IS NULL))
					AND LC.BRCD =AJ.BRCD AND LC.TRREF = AJ.TRREF AND LC.IMPRTTRSEQ = AJ.IMPRTTRSEQ
					AND AJ.BALADJTP ='I' AND LC.RVVLCFLG ='Y'
					AND ((TRIM(AJ.CNCLDT) IS NULL) AND (TRIM(CNCLUSRID) IS NULL))

		UNION
		SELECT  BRCD, 'DOC' CAT, TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),RCPTPRCPAMT,'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF IN('IDP','IDA')
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDP' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DPAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		union
		SELECT  BRCD, 'DOC' CAT,'IDA' TRREF,IMPRTTRSEQ TRSEQ,
				DECODE(SIGN(TO_DATE(RCPTDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
				cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(RCPTCCYCD,'USD'),NVL(DAAMT,0),'01','USD','01') AMT
				FROM TBTF_IMDOC
				WHERE BRCD like '%'
				       AND TRREF ='IDM'
				       AND ((RCPTDT >=  &h_startdt AND RCPTDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
				       OR  (RCPTDT >= &h_trdt AND RCPTDT <= &h_trdt))
				       AND (TRIM(CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(TRREF,'ISB','ILS',TRREF), STLSEQ TRSEQ,
		   	DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
			  	 AND TRREF IN('ILS', 'ILU','ISB','IDP', 'IDA')
		  	 	AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 	OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
				 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
				 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		UNION
		SELECT BRCD, 'STL' CAT ,DECODE(DPDAFLG,'1','IDP','IDA'), STLSEQ TRSEQ,
			  DECODE(SIGN(TO_DATE(OPRDT,'YYYYMMDD')-TO_DATE(DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt),'YYYYMMDD')),0,'BEFOR',-1,'BEFOR',1,'AFTER') TIME,
		   	cs1.excrosscal(BRCD ,'VND',&h_trdt, nvl(STLCCYCD,'USD'),STLPRCPAMT,'01','USD','01') AMT
		FROM   TBTF_IMSTL
		WHERE  BRCD like '%'
		  	 AND TRREF ='IDM'
		  	 AND ((OPRDT >=  &h_startdt AND OPRDT <= DECODE(&h_trdt, &h_startdt, &h_trdt, &h_predt))
		  	 OR  (OPRDT >= &h_trdt AND OPRDT <= &h_trdt))
			 AND ((VRFCTNFLG = 'Y' AND (VRFCTNDT <> '' OR VRFCTNDT IS NOT NULL)) OR (VRFCTNFLG = 'N'))
			 AND (TRIM(TBTF_IMSTL.CNCLDT) IS NULL)
		)
		WHERE TIME = 'AFTER' AND CAT = 'STL' AND TRREF = 'IDA'
		GROUP BY BRCD
		)
		GROUP BY BRCD
		)
		GROUP BY BRCD;
