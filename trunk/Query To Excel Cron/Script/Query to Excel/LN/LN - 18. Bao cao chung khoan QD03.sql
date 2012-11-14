--DEFINE h_trdt = '20111015'
--DEFINE h_startdt = '20111001'
--DEFINE h_enddt = '20111006'

SELECT
	A.ITEMCD,
	DECODE(SUBSTR(A.ITEMCD, 1, 2),
		'01', 'I. Doanh sè cho vay',
		'02', 'II. D­ nî cho vay') ITEMNM1,
	DECODE(SUBSTR(A.ITEMCD, 1, 4),
		'0101', 'Doanh sè cho vay',
		'0201', '1. Ph©n theo thêi h¹n vay',
		'0202', '2. Ph©n theo nhu cÇu vèn vay') ITEMNM2,
	DECODE(A.ITEMCD,
		'010101', '- Doanh sè cho vay',
		'020101', '- Ng¾n h¹n',
		'020102', '- Trung h¹n',
		'020103', '- Dµi h¹n',
		'020201', '- Cho vay, chiÕt khÊu giÊy tê cã gi¸ ®èi víi c«ng ty chøng kho¸n',
		'020202', '- Cho vay cÇm cè b»ng chøng kho¸n vµ/hoÆc b¶o ®¶m b»ng tµi s¶n kh¸c ®èi

víi kh¸ch hµng sö dông vèn vay ®Ó mua c¸c lo¹i chøng kho¸n',
		'020203', '- Cho vay øng tr­íc tiÒn ®èi víi kh¸ch hµng ®· b¸n chøng kho¸n vµ sö

dông vèn vay ®Ó mua chøng kho¸n',
		'020204', '- Cho vay ®èi víi kh¸ch hµng ®Ó bæ sung tiÒn thiÕu khi lÖnh mua chøng

kho¸n ®­îc khíp',
		'020205', '- Cho vay ®èi víi ng­êi lao ®éng ®Ó mua cæ phÇn ph¸t hµnh lÇn ®Çu khi

chuyÓn c«ng ty nhµ n­íc thµnh c«ng ty cæ phÇn',
		'020206', '- Cho vay ®Ó gãp vèn, mua cæ phÇn cña c«ng ty cæ phÇn, mua chøng chØ quü

cña quü ®Çu t­',
		'020207', '- ChiÕt khÊu giÊy tê cã gi¸ ®èi víi kh¸ch hµng ®Ó sö dông sè tiÒn chiÕt

khÊu mua chøng kho¸n',
		'020208', '- C¸c kho¶n cho vay vµ chiÕt khÊu giÊy tê cã gi¸ d­íi c¸c h×nh thøc kh¸c

mµ kh¸ch hµng sö dông sè tiÒn ®ã ®Ó mua chøng kho¸n') ITEMNM3,
	A.BRCD,
	A.CUSTSEQLN,
	B.NMLOC,
	A.DSBSSEQ,
	A.FNDPRPSTPCD,
	A.DSBSDT,
	A.MATDT,
	A.PLGFLG,
	SUM(A.AMT1) AMT1,
	SUM(A.AMT2) AMT2
FROM
	(
		SELECT
			'010101' ITEMCD,
			BRCD,
			CUSTSEQLN,
			DSBSSEQ,
			FNDPRPSTPCD,
			'' PLGFLG,
			DSBSDT,
			MATDT,
			CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, DSBSAMT, '01', 'VND', '01')

AMT1,
			0 AMT2
		FROM
			LN1.TBLN_DSBS
		WHERE
			BRCD LIKE  '%'
			AND DSBSDT BETWEEN &h_startdt AND &h_trdt
			AND BUSCD = 'LN'
			AND STSCD IN ('01', '05')
			AND FNDPRPSTPCD LIKE '10%'
			AND SUBSTR(NVL(FNDPRPSUNIT, '01001'), 1, 2) = '01'

		UNION ALL

		/* DOANH SO CHO VAY CK LOAI TRU */
		SELECT
			'010101' ITEMCD,
			B.BRCD,
			B.CUSTSEQLN,
			B.DSBSSEQ,
			B.FNDPRPSTPCD,
			'' PLGFLG,
			B.DSBSDT,
			B.MATDT,
			-NVL(AMT1,0) AMT1, 0 AMT2
	   	FROM
		(
			SELECT
				A.CUSTSEQLN,BRCDAPPR, APPRID, APPRSEQ,
				SUM(DECODE(A.CCYCD,'VND', A.PLGAMT, CS1.EXCROSSCAL (A.BRCD, 'VND',

&h_trdt, A.CCYCD, NVL(A.PLGAMT, 0), '01', 'VND', '01'))) PLGAMT
			FROM
				LN1.TBLN_PLG A,LN1.TBLN_CLPLG B,LN1.TBLN_CL C
			WHERE   A.BRCD		LIKE '%'
				AND A.STSCD 	IN ('01','03')
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
				BRCD, CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ, DSBSSEQ, FNDPRPSTPCD,

DSBSDT, MATDT,
				DECODE(CCYCD,'VND',DSBSAMT,CS1.EXCROSSCAL (BRCD, 'VND', &h_trdt,

CCYCD, DSBSAMT, '01', 'VND', '01')) AMT1
			FROM LN1.TBLN_DSBS
			WHERE   BRCD LIKE '%'
					AND STSCD IN ('01', '05')
					AND BUSCD	= 'LN'
					AND FNDPRPSTPCD LIKE '10%'
					AND DSBSDT BETWEEN &h_startdt AND &h_trdt
					AND SUBSTR(NVL(FNDPRPSUNIT, '01001'), 1, 2) = '01'
					AND LENGTH(FNDPRPSTPCD) = 5
		) B
		WHERE
			A.BRCDAPPR		= B.BRCDAPPR
			AND A.APPRID	= B.APPRID
			AND A.APPRSEQ	= B.APPRSEQ

		UNION ALL

		SELECT
			DECODE(B.LNTPCD,
					'100', '020101',
					'105', '020101',
					'300', '020101',
					'510', '020101',
					'110', '020102',
					'115', '020102',
					'135', '020102',
					'120', '020103',
					'165', '020103',
					'139', '020103',
				           '020104') ITEMCD,
			B.BRCD,
			B.CUSTSEQLN,
			B.DSBSSEQ,
			B.FNDPRPSTPCD,
			'' PLGFLG,
			B.DSBSDT,
			B.MATDT,
			CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCYCD, B.DSBSBAL, '01', 'VND',

'01') AMT1,
			DECODE(SUBSTR(B.LNSBTPCD, 2, 1), '1', 0, '2', 0, CS1.EXCROSSCAL(B.BRCD,

'VND', &h_trdt, B.CCYCD, B.DSBSBAL, '01', 'VND', '01')) AMT2
		FROM
			LN1.TBLN_DSBSHIST B
		WHERE
			B.BKDT = &h_trdt
			AND B.BUSCD = 'LN'
			AND B.STSCD = '01'
			AND B.FNDPRPSTPCD LIKE '10%'
			AND SUBSTR(NVL(B.FNDPRPSUNIT, '01001'), 1, 2) = '01'

		UNION ALL

		/* DU NO CHO VAY CK LOAI TRU */
		SELECT
			B.ITEMCD,
			B.BRCD,
			B.CUSTSEQLN,
			B.DSBSSEQ,
			B.FNDPRPSTPCD,
			'' PLGFLG,
			B.DSBSDT,
			B.MATDT,
  				-NVL(AMT1,0) AMT1,
  				-NVL(AMT2,0) AMT2
	   	FROM
		(
			SELECT
				A.CUSTSEQLN,BRCDAPPR, APPRID, APPRSEQ,
				SUM(DECODE(A.CCYCD,'VND', A.PLGAMT, CS1.EXCROSSCAL (A.BRCD, 'VND',

&h_trdt, A.CCYCD, NVL(A.PLGAMT, 0), '01', 'VND', '01'))) PLGAMT
			FROM
				LN1.TBLN_PLG A,LN1.TBLN_CLPLG B,LN1.TBLN_CL C
			WHERE   A.BRCD		LIKE '%'
				AND A.STSCD 	IN ('01','03')
				AND(A.RLSTRDT > &h_trdt OR (A.STSCD = '01' AND

NVL(A.RLSTRDT,'NONENONE')='NONENONE'))
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
				BRCD, CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ,
				DECODE(LNTPCD,
					'100', '020101',
					'105', '020101',
					'300', '020101',
					'510', '020101',
					'110', '020102',
					'115', '020102',
					'135', '020102',
					'120', '020103',
					'165', '020103',
					'139', '020103',
				           '020104') ITEMCD, DSBSSEQ, FNDPRPSTPCD, DSBSDT, MATDT,
				CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, DSBSBAL, '01', 'VND',

'01') AMT1,
				DECODE(LNSBTPCD, '01', 0, '22', 0, CS1.EXCROSSCAL(BRCD, 'VND',

&h_trdt, CCYCD, DSBSBAL, '01', 'VND', '01')) AMT2
			FROM LN1.TBLN_DSBSHIST
			WHERE   BRCD LIKE '%'
					AND STSCD IN ('01', '05')
					AND BUSCD	= 'LN'
					AND FNDPRPSTPCD LIKE '10%'
					AND BKDT = &h_trdt
					AND SUBSTR(NVL(FNDPRPSUNIT, '01001'), 1, 2) = '01'
					AND LENGTH(FNDPRPSTPCD) = 5
		) B
		WHERE
			A.BRCDAPPR		= B.BRCDAPPR
			AND A.APPRID	= B.APPRID
			AND A.APPRSEQ	= B.APPRSEQ

		UNION ALL

		SELECT
			'020101' ITEMCD,
			BRCD,
			CUSTSEQ,
			'000000000' DSBSSEQ,
			'00000' FNDPRPSTPCD,
			'' PLGFLG,
			'00000000' DSBSDT,
			'00000000' MATDT,
			CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCY, NVL(TDBAL,0), '01', 'VND', '01')

AMT1,
			DECODE(SUBSTR(ACCTCD,4,1), '1', 0, '2', 0, CS1.EXCROSSCAL(BRCD, 'VND',

&h_trdt, CCY, NVL(TDBAL,0), '01', 'VND', '01')) AMT2
		FROM
			GL1.TBGL_MAST
		WHERE TRDT = &h_trdt
			AND ACCTCD LIKE '275%00'
			AND CUSTSEQ IN ('101888290', '102458781')
			AND TDBAL <> 0

		UNION ALL

		SELECT
			DECODE(B.FNDPRPSTPCD,
				'10002', '020201',
				'10006', '020204',
				'10005', '020205',
				'10007', '020206',
				'10001', DECODE(NVL(C.FLG, 'N'), 'Y', '020202', '020208'),
				'10003', '020206',
				'10009', DECODE(NVL(C.FLG, 'N'), 'Y', '020202', '020208'),
				'10004', DECODE(B.FNDPRPSUNIT, '01001', '020203', '020208'),
				'020208') ITEMCD,
			B.BRCD,
			B.CUSTSEQLN,
			B.DSBSSEQ,
			B.FNDPRPSTPCD,
			NVL(C.FLG, 'N') PLGFLG,
			B.DSBSDT,
			B.MATDT,
			CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCYCD, B.DSBSBAL, '01', 'VND',

'01') AMT1,
			DECODE(SUBSTR(B.LNSBTPCD, 2, 1), '1', 0, '2', 0, CS1.EXCROSSCAL(B.BRCD,

'VND', &h_trdt, B.CCYCD, B.DSBSBAL, '01', 'VND', '01')) AMT2
		FROM
			LN1.TBLN_DSBSHIST B,
			(SELECT DISTINCT BRCDAPPR, APPRID, APPRSEQ, 'Y' FLG
			FROM LN1.TBLN_PLG
			WHERE (RLSTRDT>&h_trdt OR (STSCD = '01' AND

NVL(RLSTRDT,'NONENONE')='NONENONE'))
				AND NVL(PLGTRDT, PLGDT) <= &h_trdt
				AND BUSCD = 'LN'
				AND STSCD IN('01','03')) C
		WHERE
			B.BKDT = &h_trdt
			AND B.BUSCD = 'LN'
			AND B.STSCD = '01'
			AND B.FNDPRPSTPCD LIKE '10%'
			AND SUBSTR(NVL(B.FNDPRPSUNIT, '01001'), 1, 2) = '01'
			AND LENGTH(B.FNDPRPSTPCD) = 5
			AND B.BRCDAPPR = C.BRCDAPPR (+)
			AND B.APPRID = C.APPRID (+)
			AND B.APPRSEQ = C.APPRSEQ (+)

		UNION ALL

		/* DU NO CHO VAY CK LOAI TRU */
		SELECT
			ITEMCD,
			B.BRCD,
			B.CUSTSEQLN,
			B.DSBSSEQ,
			B.FNDPRPSTPCD,
			'Y' PLGFLG,
			B.DSBSDT,
			B.MATDT,
	 				-NVL(AMT1,0) AMT1,
	 				-NVL(AMT2,0) AMT2
	   	FROM
		(
			SELECT
				A.CUSTSEQLN,BRCDAPPR, APPRID, APPRSEQ,
				SUM(DECODE(A.CCYCD,'VND', A.PLGAMT, CS1.EXCROSSCAL (A.BRCD, 'VND',

&h_trdt, A.CCYCD, NVL(A.PLGAMT, 0), '01', 'VND', '01'))) PLGAMT
			FROM
				LN1.TBLN_PLG A,LN1.TBLN_CLPLG B,LN1.TBLN_CL C
			WHERE   A.BRCD		LIKE '%'
				AND A.STSCD 	IN ('01','03')
				AND(A.RLSTRDT > &h_trdt OR (A.STSCD = '01' AND

NVL(A.RLSTRDT,'NONENONE')='NONENONE'))
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
				BRCD, CUSTSEQLN, BRCDAPPR, APPRID, APPRSEQ,
				DECODE(FNDPRPSTPCD,
				'10002', '020201',
				'10006', '020204',
				'10005', '020205',
				'10007', '020206',
				'10001', '020202',
				'10003', '020206',
				'10009', '020202',
				'10004', DECODE(FNDPRPSUNIT, '01001', '020203', '020208'),
				'020208') ITEMCD, DSBSSEQ, FNDPRPSTPCD, DSBSDT, MATDT,
				CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, DSBSBAL, '01', 'VND',

'01') AMT1,
				DECODE(LNSBTPCD, '01', 0, '22', 0, CS1.EXCROSSCAL(BRCD, 'VND',

&h_trdt, CCYCD, DSBSBAL, '01', 'VND', '01')) AMT2
			FROM LN1.TBLN_DSBSHIST
			WHERE   BRCD LIKE '%'
					AND STSCD IN ('01', '05')
					AND BUSCD	= 'LN'
					AND FNDPRPSTPCD LIKE '10%'
					AND BKDT = &h_trdt
					AND SUBSTR(NVL(FNDPRPSUNIT, '01001'), 1, 2) = '01'
					AND LENGTH(FNDPRPSTPCD) = 5
		) B
		WHERE
			A.BRCDAPPR		= B.BRCDAPPR
			AND A.APPRID	= B.APPRID
			AND A.APPRSEQ	= B.APPRSEQ

		UNION ALL

		/* DU NO THAU CHI CUA CTY CK KIMENG VA RONG VIET (CV CK GTCG DOI VOI CTY CK)

2010.07.13*/
		SELECT
			'020201' ITEMCD,
			BRCD,
			CUSTSEQ,
			'000000000' DSBSSEQ,
			'00000' FNDPRPSTPCD,
			'' PLGFLG,
			'00000000' DSBSDT,
			'00000000' MATDT,
			CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCY, NVL(TDBAL,0), '01', 'VND', '01')

AMT1,
			DECODE(SUBSTR(ACCTCD,4,1), '1', 0, '2', 0, CS1.EXCROSSCAL(BRCD, 'VND',

&h_trdt, CCY, NVL(TDBAL,0), '01', 'VND', '01')) AMT2
		FROM
			GL1.TBGL_MAST
		WHERE TRDT = &h_trdt
			AND BRCD LIKE '%'
			AND ACCTCD LIKE '275%00'
			AND CUSTSEQ IN ('101888290', '102458781')
	) A, CM1.TBCM_GENERAL B
WHERE
	A.BRCD = B.BRCD
	AND A.CUSTSEQLN = B.CUSTSEQ
GROUP BY ITEMCD, A.BRCD, CUSTSEQLN, NMLOC, DSBSSEQ, FNDPRPSTPCD, DSBSDT, MATDT, PLGFLG
HAVING SUM(A.AMT1) > 0 OR SUM(A.AMT2) > 0
ORDER BY
	A.ITEMCD, A.BRCD, A.CUSTSEQLN, A.DSBSSEQ

