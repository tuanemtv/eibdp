--DEFINE h_trdt = '20100104'

SELECT
   A.BRCD MA_CHI_NHANH,
   D.LCLBRNM CHI_NHANH,
   ROUND(SUM(LDRBAL_VND1)/ 1000000, 2) CHUNG_KHOAN_NGAY_T ,
   ROUND(SUM(LDRBAL_VND2)/ 1000000, 2) CHUNG_KHOAN_KHAC ,
   ROUND(SUM(DECODE(A.GRP, '1', 0, LDRBAL_VND1 + LDRBAL_VND2))/ 1000000, 2) QUA_HAN,
   ROUND(SUM(DECODE(A.GRP, '1', 0, '2', 0, LDRBAL_VND1 + LDRBAL_VND2))/ 1000000, 2) NO_XAU
FROM
(
	SELECT
		B.BRCD,
		B.CUSTSEQLN,
		CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCYCD, NVL(B.DSBSBAL, 0), '01', 'VND', '01') LDRBAL_VND1,
		0 LDRBAL_VND2,
		SUBSTR(B.LNSBTPCD, 2, 1) GRP
	FROM
		LN1.TBLN_DSBSHIST B
	WHERE
		B.BKDT = &h_trdt
		AND B.BUSCD = 'LN'
		AND B.STSCD = '01'
		AND B.DSBSBAL > 0
		AND TRIM(B.FNDPRPSTPCD) = '10004'
		AND TRIM(B.FNDPRPSUNIT) <> '02001'

	UNION ALL

	SELECT
	    B.BRCD,
	    B.CUSTSEQLN,
	    0 LDRBAL_VND1,
	    CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCYCD, NVL(B.DSBSBAL, 0), '01', 'VND', '01') LDRBAL_VND2,
	    SUBSTR(B.LNSBTPCD, 2, 1) GRP
	FROM
	    LN1.TBLN_DSBSHIST B
	WHERE
	    B.BKDT = &h_trdt
	    AND B.BUSCD = 'LN'
		AND B.STSCD = '01'
		AND B.DSBSBAL > 0
	    AND SUBSTR(B.FNDPRPSTPCD,1,2) = '10'
	    AND LENGTH(B.FNDPRPSTPCD) = 5
	    AND B.FNDPRPSTPCD <> '10004'

	UNION ALL

	/* DU NO THAU CHI 2 CTY CK RONG VIET VA KIMENG */
	SELECT
		BRCD,
		CUSTSEQ,
		0 LDRBAL_VND1,
		CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCY, NVL(TDBAL,0), '01', 'VND', '01') LDRBAL_VND2,		
		SUBSTR(ACCTCD, 4,1) GRP
	FROM
		GL1.TBGL_MAST
	WHERE TRDT = &h_trdt
		AND ACCTCD LIKE '275%00'
		AND CUSTSEQ IN ('101888290', '102458781')
		AND TDBAL <> 0

	UNION ALL

	/*Du no cho vay CK ngay T (loai tru)*/
	SELECT
			B.BRCD,
			B.CUSTSEQLN,
			-LDRBAL_VND1,
			0 LDRBAL_VND2,
			B.GRP
   	FROM
	(
		SELECT
			A.CUSTSEQLN,BRCDAPPR, APPRID, APPRSEQ,
			SUM(DECODE(A.CCYCD,'VND', A.PLGAMT, CS1.EXCROSSCAL (A.BRCD, 'VND', &h_trdt, A.CCYCD, NVL(A.PLGAMT, 0), '01', 'VND', '01'))) PLGAMT
		FROM
			LN1.TBLN_PLG A,LN1.TBLN_CLPLG B,LN1.TBLN_CL C
		WHERE
			A.STSCD 	IN ('01','03')
			AND(A.RLSTRDT > &h_trdt OR (A.STSCD = '01' AND NVL(A.RLSTRDT,'NONENONE')='NONENONE'))
			AND C.STSCD 	= '01'
			AND A.PLGAMT 	<> 0
			AND A.BUSCD	= 'LN'
			AND A.BRCD	= B.BRCD
			AND A.PLGID	= B.PLGID
			AND A.PLGSEQ	= B.PLGSEQ
			AND B.BRCDCL	= C.BRCD
			AND B.CLID	= C.CLID
			AND B.CLSEQ	= C.CLSEQ
			AND (C.CLDTLTPCD IN ('601','607','620') AND C.CRDTOFC = 'EIB')
		GROUP BY
			CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ
	)A,
	(
		SELECT
			BRCD,
			BRCDAPPR,
			APPRID,
			APPRSEQ,
			CUSTSEQLN,
			CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, NVL(DSBSBAL, 0), '01', 'VND', '01') LDRBAL_VND1,
			SUBSTR(LNSBTPCD, 2, 1) GRP
		FROM LN1.TBLN_DSBSHIST
		WHERE
				STSCD IN ('01', '05')
				AND BUSCD	= 'LN'
				AND BKDT = &h_trdt
				AND TRIM(FNDPRPSTPCD) = '10004'
				AND TRIM(FNDPRPSUNIT) <> '02001'
	) B
	WHERE
		A.BRCDAPPR		= B.BRCDAPPR
		AND A.APPRID	= B.APPRID
		AND A.APPRSEQ	= B.APPRSEQ

	UNION ALL

	/*Du no cho vay CK khac (loai tru)*/
	SELECT
			B.BRCD,
			B.CUSTSEQLN,
			0 LDRBAL_VND1,
			-LDRBAL_VND2,
			B.GRP
   	FROM
	(
		SELECT
			A.CUSTSEQLN,BRCDAPPR, APPRID, APPRSEQ,
			SUM(DECODE(A.CCYCD,'VND', A.PLGAMT, CS1.EXCROSSCAL (A.BRCD, 'VND', &h_trdt, A.CCYCD, NVL(A.PLGAMT, 0), '01', 'VND', '01'))) PLGAMT
		FROM
			LN1.TBLN_PLG A,LN1.TBLN_CLPLG B,LN1.TBLN_CL C
		WHERE
			A.STSCD 	IN ('01','03')
			AND(A.RLSTRDT > &h_trdt OR (A.STSCD = '01' AND NVL(A.RLSTRDT,'NONENONE')='NONENONE'))
			AND C.STSCD 	= '01'
			AND A.PLGAMT 	<> 0
			AND A.BUSCD	= 'LN'
			AND A.BRCD	= B.BRCD
			AND A.PLGID	= B.PLGID
			AND A.PLGSEQ	= B.PLGSEQ
			AND B.BRCDCL	= C.BRCD
			AND B.CLID	= C.CLID
			AND B.CLSEQ	= C.CLSEQ
			AND (C.CLDTLTPCD IN ('601','607','620') AND C.CRDTOFC = 'EIB')
		GROUP BY
			CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ
	)A,
	(
		SELECT
			BRCD,
			BRCDAPPR,
			APPRID,
			APPRSEQ,
			CUSTSEQLN,
			CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, NVL(DSBSBAL, 0), '01', 'VND', '01') LDRBAL_VND2,
			SUBSTR(LNSBTPCD, 2, 1) GRP
		FROM LN1.TBLN_DSBSHIST
		WHERE
				STSCD IN ('01', '05')
				AND BUSCD	= 'LN'
				AND BKDT = &h_trdt
				AND SUBSTR(FNDPRPSTPCD,1,2) = '10'
			    AND LENGTH(FNDPRPSTPCD) = 5
			    AND FNDPRPSTPCD <> '10004'
	) B
	WHERE
		A.BRCDAPPR		= B.BRCDAPPR
		AND A.APPRID	= B.APPRID
		AND A.APPRSEQ	= B.APPRSEQ
) A, TBCS_BRCD D
WHERE
	A.BRCD = D.BRCD
GROUP BY
	A.BRCD, D.LCLBRNM
