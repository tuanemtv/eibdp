SELECT A.BRCD, B.ENGBRSHRTNM, SUM(LC_USD) TRIGIACK_LC_USD,
	SUM(NTDP_USD) TRIGIACK_NTDP_USD,
	SUM(NTDA_USD) TRIGIACK_NTDA_USD,
	SUM(NTTTR_USD) TRIGIACK_NTTTR_USD,
	SUM(LC_VND) TRIGIACK_LC_VND,
	SUM(NTDP_VND) TRIGIACK_NTDP_VND,
	SUM(NTDA_VND) TRIGIACK_NTDA_VND,
	SUM(NTTTR_VND) TRIGIACK_NTTTR_VND,
	SUM(LC_USD1) DUNOCK_LC_USD1,
	SUM(NTDP_USD1) DUNOCK_NTDP_USD1,
	SUM(NTDA_USD1) DUNOCK_NTDA_USD1,
	SUM(NTTTR_USD1) DUNOCK_NTTTR_USD1,
	SUM(LC_VND1) DUNOCK_LC_VND1,
	SUM(NTDP_VND1) DUNOCK_NTDP_VND1,
	SUM(NTDA_VND1) DUNOCK_NTDA_VND1,
	SUM(NTTTR_VND1) DUNOCK_NTTTR_VND1
FROM
(
	SELECT BRCD, SUM(LC_USD) LC_USD, SUM(NTDP_USD) NTDP_USD,
			SUM(NTDA_USD) NTDA_USD, SUM(NTTTR_USD) NTTTR_USD, SUM(LC_VND) LC_VND,
			SUM(NTDP_VND) NTDP_VND, SUM(NTDA_VND) NTDA_VND, SUM(NTTTR_VND) NTTTR_VND,
			0 LC_USD1, 0 NTDP_USD1, 0 NTDA_USD1, 0 NTTTR_USD1,
			0 LC_VND1, 0 NTDP_VND1, 0 NTDA_VND1, 0 NTTTR_VND1
	FROM
	(
		SELECT BRCD, STLCCYCD,
			SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, STLCCYCD, STLAMT,'01','USD','01')) LC_USD,
			0 NTDP_USD, 0 NTDA_USD, 0 NTTTR_USD, 0 LC_VND, 0 NTDP_VND, 0 NTDA_VND, 0 NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRCD IN ('W501')
			AND STLCCYCD <> 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
		UNION ALL
		SELECT BRCD, STLCCYCD, 0 LC_USD,
		SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, STLCCYCD, STLAMT,'01','USD','01'))	 NTDP_USD,
		0 NTDP_USD, 0 NTTTR_USD, 0 LC_VND, 0 NTDP_VND, 0 NTDA_VND, 0 NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRREF = 'EDP'
			AND TRCD IN ('W521')
			AND STLCCYCD <> 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
		UNION ALL
		SELECT BRCD, STLCCYCD, 0 LC_USD, 0 NTDP_USD,
		SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, STLCCYCD, STLAMT,'01','USD','01'))	 NTDA_USD,
		0 NTTTR_USD, 0 LC_VND, 0 NTDP_VND, 0 NTDA_VND, 0 NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRREF = 'EDA'
			AND TRCD IN ('W521')
			AND STLCCYCD <> 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
		UNION ALL
		SELECT BRCD, STLCCYCD, 0 LC_USD, 0 NTDP_USD, 0 NTDA_USD,
		SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, STLCCYCD, STLAMT,'01','USD','01'))	 NTTTR_USD,
		0 LC_VND, 0 NTDP_VND, 0 NTDA_VND, 0 NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRREF = 'TTR'
			AND TRCD IN ('W521')
			AND STLCCYCD <> 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
		UNION ALL
		SELECT BRCD, STLCCYCD, 0 LC_USD, 0 NTDP_USD, 0 NTDA_USD, 0 NTTTR_USD,
			SUM(STLAMT) LC_VND, 0 NTDP_VND, 0 NTDA_VND, 0 NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRCD IN ('W501')
			AND STLCCYCD = 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
		UNION ALL
		SELECT BRCD, STLCCYCD, 0 LC_USD, 0 NTDP_USD, 0 NTDA_USD, 0 NTTTR_USD,
			0 LC_VND, SUM(STLAMT) NTDP_VND, 0 NTDA_VND, 0 NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRREF = 'EDP'
			AND TRCD IN ('W521')
			AND STLCCYCD = 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
		UNION ALL
		SELECT BRCD, STLCCYCD, 0 LC_USD, 0 NTDP_USD, 0 NTDA_USD, 0 NTTTR_USD,
			0 LC_VND, 0 NTDP_VND, SUM(STLAMT) NTDA_VND, 0 NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRREF = 'EDA'
			AND TRCD IN ('W521')
			AND STLCCYCD = 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
		UNION ALL
		SELECT BRCD, STLCCYCD, 0 LC_USD, 0 NTDP_USD, 0 NTDA_USD, 0 NTTTR_USD,
			0 LC_VND, 0 NTDP_VND, 0 NTDA_VND, SUM(STLAMT) NTTTR_VND
		FROM TBTF_STLINFO
		WHERE
			BRCD  LIKE '%'
			AND (STLDT >= substr(&h_trdt,1,4)||'0101' AND STLDT <= &h_trdt)
			AND TRREF = 'TTR'
			AND TRCD IN ('W521')
			AND STLCCYCD = 'VND'
			AND (CNCLDT = ' ' OR CNCLDT IS NULL)
		GROUP BY BRCD, STLCCYCD
	)
	GROUP BY BRCD
	UNION ALL

	SELECT BRCD, 0 LC_USD, 0 NTDP_USD, 0 NTDA_USD, 0 NTTTR_USD,
		0 LC_VND, 0 NTDP_VND, 0 NTDA_VND, 0 NTTTR_VND,
		SUM(AMTLC_USD) LC_USD1, SUM(AMTNTDP_USD) NTDP_USD1,
		SUM(AMTNTDA_USD) NTDA_USD1, SUM(AMTNTTTR_USD) NTTTR_USD1,
		SUM(AMTLC_VND) LC_VND1, SUM(AMTNTDP_VND) NTDP_VND1,
		SUM(AMTNTDA_VND) NTDA_VND1, SUM(AMTNTTTR_VND) NTTTR_VND1
	FROM
	(
		SELECT BRCD, SUM(AMTLC_USD) AMTLC_USD, SUM(AMTLC_VND) AMTLC_VND,
			0 AMTNTDP_USD, 0 AMTNTDP_VND, 0 AMTNTDA_USD, 0 AMTNTDA_VND,
			0 AMTNTTTR_USD, 0 AMTNTTTR_VND
		FROM
		(
			SELECT BRCD,  TRSEQ,
				DECODE(TRCCYCD, STLCCYCD, SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, CCY, LDRBAL,'01','USD','01')),0) AMTLC_USD,
				DECODE(TRCCYCD, STLCCYCD, 0, LDRBAL * TYGIA) AMTLC_VND
			FROM
			(
				SELECT BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD,
					SUM(STL.BCEQAMT)/SUM(STL.TRCCYEQAMT) TYGIA
				FROM TBGL_BALDD BAL, TBTF_STLINFO STL
				WHERE
					BAL.BRCD LIKE '%'
					AND BAL.TRDT = &h_trdt
					AND BAL.BUSCD = 'TF'
					AND BAL.UNTBUSCD = 'EX'
					AND BAL.ACCTCD IN ('221100','221200','221300','221400','221500')
					AND BAL.TRREF IN ('ESP','EUP')
					AND BAL.BRCD = STL.BRCD
					AND BAL.TRREF = STL.TRREF
					AND BAL.TRSEQ = STL.TRSEQ
					AND	BAL.UNTBUSCD = STL.UNTBUSCD
					AND STL.TRCD IN ('W501','W521')
					AND (STL.CNCLDT = ' ' OR STL.CNCLDT IS NULL)
					AND (STL.CNCLUSRID = ' ' OR STL.CNCLUSRID IS NULL)
				GROUP BY BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD
			)
			GROUP BY BRCD, TRSEQ, LDRBAL, TRCCYCD, STLCCYCD, TYGIA
		)
		GROUP BY BRCD
		UNION ALL
		SELECT BRCD, 0 AMTLC_USD, 0 AMTLC_VND,
			SUM(AMTNTDP_USD) AMTNTDP_USD, SUM(AMTNTDP_VND) AMTNTDP_VND,
			SUM(AMTNTDA_USD) AMTNTDA_USD, SUM(AMTNTDA_VND) AMTNTDA_VND,
			SUM(AMTNTTTR_USD) AMTNTTTR_USD, SUM(AMTNTTTR_VND) AMTNTTTR_VND
		FROM
		(
			SELECT BRCD,  TRSEQ,
				DECODE(TRCCYCD, STLCCYCD, SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, CCY, LDRBAL,'01','USD','01')),0) AMTNTDP_USD,
				DECODE(TRCCYCD, STLCCYCD, 0, LDRBAL * TYGIA) AMTNTDP_VND,
				0 AMTNTDA_USD, 0 AMTNTDA_VND, 0 AMTNTTTR_USD, 0 AMTNTTTR_VND
			FROM
			(
				SELECT BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD,
					SUM(STL.BCEQAMT)/SUM(STL.TRCCYEQAMT) TYGIA
				FROM TBGL_BALDD BAL, TBTF_STLINFO STL
				WHERE
					BAL.BRCD LIKE '%'
					AND BAL.TRDT = &h_trdt
					AND BAL.BUSCD = 'TF'
					AND BAL.UNTBUSCD = 'EX'
					AND BAL.ACCTCD IN ('221100','221200','221300','221400','221500')
					AND BAL.TRREF IN ('EDP')
					AND BAL.BRCD = STL.BRCD
					AND BAL.TRREF = STL.TRREF
					AND BAL.TRSEQ = STL.TRSEQ
					AND	BAL.UNTBUSCD = STL.UNTBUSCD
					AND STL.TRCD IN ('W501','W521')
					AND (STL.CNCLDT = ' ' OR STL.CNCLDT IS NULL)
					AND (STL.CNCLUSRID = ' ' OR STL.CNCLUSRID IS NULL)
				GROUP BY BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD
			)
			GROUP BY BRCD, TRSEQ, LDRBAL, TRCCYCD, STLCCYCD, TYGIA

			UNION ALL

			SELECT BRCD,  TRSEQ, 0 AMTNTDP_USD, 0 AMTNTDP_VND,
				DECODE(TRCCYCD, STLCCYCD, SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, CCY, LDRBAL,'01','USD','01')),0) AMTNTDA_USD,
				DECODE(TRCCYCD, STLCCYCD, 0, LDRBAL * TYGIA) AMTNTDA_VND,
				0 AMTNTTTR_USD, 0 AMTNTTTR_VND
			FROM
			(
				SELECT BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD,
					SUM(STL.BCEQAMT)/SUM(STL.TRCCYEQAMT) TYGIA
				FROM TBGL_BALDD BAL, TBTF_STLINFO STL
				WHERE
					BAL.BRCD LIKE '%'
					AND BAL.TRDT = &h_trdt
					AND BAL.BUSCD = 'TF'
					AND BAL.UNTBUSCD = 'EX'
					AND BAL.ACCTCD IN ('221100','221200','221300','221400','221500')
					AND BAL.TRREF IN ('EDA')
					AND BAL.BRCD = STL.BRCD
					AND BAL.TRREF = STL.TRREF
					AND BAL.TRSEQ = STL.TRSEQ
					AND	BAL.UNTBUSCD = STL.UNTBUSCD
					AND STL.TRCD IN ('W501','W521')
					AND (STL.CNCLDT = ' ' OR STL.CNCLDT IS NULL)
					AND (STL.CNCLUSRID = ' ' OR STL.CNCLUSRID IS NULL)
				GROUP BY BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD
			)
			GROUP BY BRCD, TRSEQ, LDRBAL, TRCCYCD, STLCCYCD, TYGIA

			UNION ALL

			SELECT BRCD,  TRSEQ, 0 AMTNTDP_USD, 0 AMTNTDP_VND, 0 AMTNTDA_USD, 0 AMTNTDA_VND,
				DECODE(TRCCYCD, STLCCYCD, SUM(CS1.excrosscal(BRCD,'VND',&h_trdt, CCY, LDRBAL,'01','USD','01')),0) AMTNTTTR_USD,
				DECODE(TRCCYCD, STLCCYCD, 0, LDRBAL * TYGIA) AMTNTTTR_VND
			FROM
			(
				SELECT BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD,
					SUM(STL.BCEQAMT)/SUM(STL.TRCCYEQAMT) TYGIA
				FROM TBGL_BALDD BAL, TBTF_STLINFO STL
				WHERE
					BAL.BRCD LIKE '%'
					AND BAL.TRDT = &h_trdt
					AND BAL.BUSCD = 'TF'
					AND BAL.UNTBUSCD = 'EX'
					AND BAL.ACCTCD IN ('221100','221200','221300','221400','221500')
					AND BAL.TRREF IN ('TTR')
					AND BAL.BRCD = STL.BRCD
					AND BAL.TRREF = STL.TRREF
					AND BAL.TRSEQ = STL.TRSEQ
					AND	BAL.UNTBUSCD = STL.UNTBUSCD
					AND STL.TRCD IN ('W501','W521')
					AND (STL.CNCLDT = ' ' OR STL.CNCLDT IS NULL)
					AND (STL.CNCLUSRID = ' ' OR STL.CNCLUSRID IS NULL)
				GROUP BY BAL.BRCD, BAL.TRSEQ, BAL.CCY, BAL.LDRBAL, STL.TRCCYCD, STL.STLCCYCD
			)
			GROUP BY BRCD, TRSEQ, LDRBAL, TRCCYCD, STLCCYCD, TYGIA
		)
		GROUP BY BRCD
	)
	GROUP BY BRCD
)A, TBCS_BRCD B
WHERE A.BRCD = B.BRCD
GROUP BY A.BRCD, B.ENGBRSHRTNM
