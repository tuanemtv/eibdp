--DEFINE h_trdt = '20120901'

SELECT
	XX.BRCD MA_CHI_NHANH,
	NVL(YY.LCLBRNM, 'EIB he thong') CHI_NHANH,
	XX.DEPTCD MA_PGD,
	ZZ.DEPTNMLOC PGD,
	GRP CHI_TIEU_CAP_1,
	ITEM CHI_TIEU_CAP_2,
	LNTPNM THOI_HAN,
	CCY,
	COUNT(DSBSSEQ) SO_KHE_UOC,
	COUNT(DISTINCT CUSTSEQ) SO_KHACH_HANG,
	SUM(LDRBAL) DU_NO,
	SUM(LDRBAL_VND) DU_NO_QUY_DOI
FROM
(
	SELECT
		BRCD,
		DEPTCD,
		GRP,
		ITEM,
		DSBSSEQ,
		CUSTSEQ,
		DECODE (ACCTCD,
			'201100', 'a. Ngæn hπn', '201200', 'a. Ngæn hπn', '201300', 'a. Ngæn hπn', '201400', 'a. Ngæn hπn', '201500', 'a. Ngæn hπn',
			'205101', 'a. Ngæn hπn', '205201', 'a. Ngæn hπn', '205301', 'a. Ngæn hπn', '205801', 'a. Ngæn hπn',
			'211100', 'a. Ngæn hπn', '211101', 'a. Ngæn hπn', '211200', 'a. Ngæn hπn', '211201', 'a. Ngæn hπn',
			'211300', 'a. Ngæn hπn', '211301', 'a. Ngæn hπn', '211400', 'a. Ngæn hπn', '211401', 'a. Ngæn hπn',
			'211500', 'a. Ngæn hπn', '211501', 'a. Ngæn hπn',
			'211800', 'a. Ngæn hπn', '221100', 'a. Ngæn hπn', '221101', 'a. Ngæn hπn', '221200', 'a. Ngæn hπn', '221201', 'a. Ngæn hπn',
			'221300', 'a. Ngæn hπn', '221301', 'a. Ngæn hπn', '221400', 'a. Ngæn hπn', '221401', 'a. Ngæn hπn', '221500', 'a. Ngæn hπn', '221501', 'a. Ngæn hπn',
			'222100', 'a. Ngæn hπn', '222200', 'a. Ngæn hπn', '222300', 'a. Ngæn hπn', '222400', 'a. Ngæn hπn',
			'222801', 'a. Ngæn hπn', '222802', 'a. Ngæn hπn', '222803', 'a. Ngæn hπn',
			'241100', 'a. Ngæn hπn', '241200', 'a. Ngæn hπn', '241300', 'a. Ngæn hπn', '241400', 'a. Ngæn hπn', '241500', 'a. Ngæn hπn', '241800', 'a. Ngæn hπn',
			'251100', 'a. Ngæn hπn', '251101', 'a. Ngæn hπn', '251200', 'a. Ngæn hπn', '251201', 'a. Ngæn hπn', '251300', 'a. Ngæn hπn', '251301', 'a. Ngæn hπn', '251400', 'a. Ngæn hπn',
			'251500', 'a. Ngæn hπn', '251801', 'a. Ngæn hπn',
			'252100', 'a. Ngæn hπn', '252101', 'a. Ngæn hπn', '252200', 'a. Ngæn hπn', '252201', 'a. Ngæn hπn', '252300', 'a. Ngæn hπn', '252301', 'a. Ngæn hπn','252400', 'a. Ngæn hπn','252500', 'a. Ngæn hπn','252801', 'a. Ngæn hπn',
			'253100', 'a. Ngæn hπn', '253101', 'a. Ngæn hπn', '253200', 'a. Ngæn hπn', '253201', 'a. Ngæn hπn', '253300', 'a. Ngæn hπn', '253301', 'a. Ngæn hπn',
			'253400', 'a. Ngæn hπn', '253500', 'a. Ngæn hπn', '253801', 'a. Ngæn hπn',
			'275100', 'a. Ngæn hπn', '275101', 'a. Ngæn hπn', '275200', 'a. Ngæn hπn', '275201', 'a. Ngæn hπn', '275300', 'a. Ngæn hπn', '275301', 'a. Ngæn hπn','275400', 'a. Ngæn hπn','275500', 'a. Ngæn hπn',
			'275801', 'a. Ngæn hπn',
			'281000', 'a. Ngæn hπn', '282000', 'a. Ngæn hπn', '283000', 'a. Ngæn hπn', '284000', 'a. Ngæn hπn', '285000', 'a. Ngæn hπn',
			'291000', 'a. Ngæn hπn', '292000', 'a. Ngæn hπn', '293000', 'a. Ngæn hπn',
			DECODE(ACCTCD,
			'203102', 'b. Trung hπn',
			'204102', 'b. Trung hπn', '204202', 'b. Trung hπn', '204302', 'b. Trung hπn', '204802', 'b. Trung hπn',
			'205102', 'b. Trung hπn', '205202', 'b. Trung hπn', '205302', 'b. Trung hπn', '205802', 'b. Trung hπn',
			'212100', 'b. Trung hπn', '212200', 'b. Trung hπn', '212300', 'b. Trung hπn', '212400', 'b. Trung hπn', '212500', 'b. Trung hπn',
			'212800', 'b. Trung hπn',
			'231100', 'b. Trung hπn', '231200', 'b. Trung hπn', '231300', 'b. Trung hπn', '231400', 'b. Trung hπn', '231500', 'b. Trung hπn',
			'231800', 'b. Trung hπn', '251102', 'b. Trung hπn', '251202', 'b. Trung hπn', '251302', 'b. Trung hπn', '251802', 'b. Trung hπn',
			'252102', 'b. Trung hπn', '252202', 'b. Trung hπn', '252302', 'b. Trung hπn', '252802', 'b. Trung hπn',
			'253102', 'b. Trung hπn', '253202', 'b. Trung hπn', '253302', 'b. Trung hπn', '253802', 'b. Trung hπn',
			'271102', 'b. Trung hπn', '271105', 'b. Trung hπn', '271108', 'b. Trung hπn', '271111', 'b. Trung hπn', '271198', 'b. Trung hπn',
			'271202', 'b. Trung hπn', '271205', 'b. Trung hπn', '271208', 'b. Trung hπn', '271211', 'b. Trung hπn', '271298', 'b. Trung hπn',
			'271302', 'b. Trung hπn', '271305', 'b. Trung hπn', '271308', 'b. Trung hπn', '271311', 'b. Trung hπn', '271398', 'b. Trung hπn',
			'271802', 'b. Trung hπn', '271805', 'b. Trung hπn', '271808', 'b. Trung hπn', '271811', 'b. Trung hπn', '271898', 'b. Trung hπn',
			'272102', 'b. Trung hπn', '272202', 'b. Trung hπn', '272302', 'b. Trung hπn', '272802', 'b. Trung hπn',
			'273102', 'b. Trung hπn', '273202', 'b. Trung hπn', '273302', 'b. Trung hπn', '273802', 'b. Trung hπn',
			'274102', 'b. Trung hπn', '274202', 'b. Trung hπn', '274302', 'b. Trung hπn', '274802', 'b. Trung hπn',
			'275102', 'b. Trung hπn', '275202', 'b. Trung hπn', '275302', 'b. Trung hπn', '275802', 'b. Trung hπn',
			'223100', 'b. Trung hπn', '223200', 'b. Trung hπn', '223300', 'b. Trung hπn', '223400', 'b. Trung hπn',
			DECODE(ACCTCD,
			'203103', 'c. Dµi hπn',
			'204103', 'c. Dµi hπn', '204203', 'c. Dµi hπn', '204303', 'c. Dµi hπn', '204803', 'c. Dµi hπn',
			'205103', 'c. Dµi hπn', '205203', 'c. Dµi hπn', '205303', 'c. Dµi hπn', '205803', 'c. Dµi hπn',
			'213100', 'c. Dµi hπn', '213200', 'c. Dµi hπn', '213300', 'c. Dµi hπn', '213400', 'c. Dµi hπn', '213500', 'c. Dµi hπn', '213800', 'c. Dµi hπn',
			'251103', 'c. Dµi hπn', '251203', 'c. Dµi hπn', '251303', 'c. Dµi hπn', '251803', 'c. Dµi hπn',
			'252103', 'c. Dµi hπn', '252203', 'c. Dµi hπn', '252303', 'c. Dµi hπn', '252803', 'c. Dµi hπn',
			'253103', 'c. Dµi hπn', '253203', 'c. Dµi hπn', '253303', 'c. Dµi hπn', '253803', 'c. Dµi hπn',
			'271103', 'c. Dµi hπn', '271106', 'c. Dµi hπn', '271109', 'c. Dµi hπn', '271112', 'c. Dµi hπn', '271199', 'c. Dµi hπn',
			'271203', 'c. Dµi hπn', '271206', 'c. Dµi hπn', '271209', 'c. Dµi hπn', '271212', 'c. Dµi hπn', '271299', 'c. Dµi hπn',
			'271303', 'c. Dµi hπn', '271306', 'c. Dµi hπn', '271309', 'c. Dµi hπn', '271312', 'c. Dµi hπn', '271399', 'c. Dµi hπn',
			'271803', 'c. Dµi hπn', '271806', 'c. Dµi hπn', '271809', 'c. Dµi hπn', '271812', 'c. Dµi hπn', '271899', 'c. Dµi hπn',
			'272103', 'c. Dµi hπn', '272203', 'c. Dµi hπn', '272303', 'c. Dµi hπn', '272803', 'c. Dµi hπn',
			'273103', 'c. Dµi hπn', '273203', 'c. Dµi hπn', '273303', 'c. Dµi hπn', '273803', 'c. Dµi hπn',
			'274103', 'c. Dµi hπn', '274203', 'c. Dµi hπn', '274303', 'c. Dµi hπn', '274803', 'c. Dµi hπn',
			'275103', 'c. Dµi hπn', '275203', 'c. Dµi hπn', '275303', 'c. Dµi hπn', '275803', 'c. Dµi hπn', ACCTCD
			))) LNTPNM,
		PDGRP,
		CCY,
		LDRBAL,
		LDRBAL_VND
	FROM
	(
		SELECT
			A.BRCD,
			DECODE(SUBSTR(A.DEPTCD, 3, 1), 'O', A.DEPTCD) DEPTCD,
			DECODE(A.FNDPRPSTPCD, '09001', '01. b t ÆÈng s∂n',
								  '09011', '03. th u chi',
								  '09012', '03. th u chi',
								  '09013', '03. th u chi',
								  '09014', '03. th u chi',
								  '09004', '04. mua ph≠¨ng ti÷n vÀn t∂i',
								  '09002', '05. du h‰c',
								  '09003', '05. du h‰c',
								  '09007', '05. du h‰c',
								  '09016', '05. du h‰c',
								  'BK004', '05. du h‰c',
								  '09005', '06. c∏n bÈ, c´ng nh©n vi™n',
								  '09006', '06. c∏n bÈ, c´ng nh©n vi™n',
								  '09008', '06. c∏n bÈ, c´ng nh©n vi™n',
								  '10001', '07. kinh doanh ch¯ng kho∏n',
								  '10002', '07. kinh doanh ch¯ng kho∏n',
								  '10003', '07. kinh doanh ch¯ng kho∏n',
								  '10004', '07. kinh doanh ch¯ng kho∏n',
								  '10005', '07. kinh doanh ch¯ng kho∏n',
								  '10006', '07. kinh doanh ch¯ng kho∏n',
								  '10007', '07. kinh doanh ch¯ng kho∏n',
								  '10999', '07. kinh doanh ch¯ng kho∏n',
								  '09009', '08. ti™u dÔng sinh hoπt kh∏c',
								  '09015', '08. ti™u dÔng sinh hoπt kh∏c',
								  '09999', '08. ti™u dÔng sinh hoπt kh∏c',
								  '09. kh∏c') GRP,
			DECODE(A.FNDPRPSTPCD, '09001', DECODE(TRIM(SUBSTR(A.FNDPRPSUNIT, 1, 2)), '', '00. Kh∏c',  SUBSTR(A.FNDPRPSUNIT, 1, 2) || '. ' || F.FNDPRPSGRP3),
								  '09011', '01. ' || E.FNDPRPSGRP2,
								  '09012', '02. ' || E.FNDPRPSGRP2,
								  '09013', '03. ' || E.FNDPRPSGRP2,
								  '09014', '04. ' || E.FNDPRPSGRP2,
								  '09004', '01. Mua ph≠¨ng ti÷n vÀn t∂i',
								  '09002', '01. ' || E.FNDPRPSGRP2,
								  '09003', '02. ' || E.FNDPRPSGRP2,
								  '09007', '03. ' || E.FNDPRPSGRP2,
								  '09016', '03. ' || E.FNDPRPSGRP2,
								  'BK004', '02. ' || E.FNDPRPSGRP2,
								  '09005', '01. ' || E.FNDPRPSGRP2,
								  '09006', '02. ' || E.FNDPRPSGRP2,
								  '09008', '03. ' || E.FNDPRPSGRP2,
								  '10003', '01. ' || E.FNDPRPSGRP2,
								  '10005', '02. ' || E.FNDPRPSGRP2,
								  '10004', '03. ' || E.FNDPRPSGRP2,
								  '10007', '04. ' || E.FNDPRPSGRP2,
								  '10001', '05. Kinh doanh ch¯ng kho∏n kh∏c',
								  '10002', '05. Kinh doanh ch¯ng kho∏n kh∏c',
								  '10006', '05. Kinh doanh ch¯ng kho∏n kh∏c',
								  '10999', '05. Kinh doanh ch¯ng kho∏n kh∏c',
								  '09009', '01. ' || E.FNDPRPSGRP2,
								  '09015', '03. ' || E.FNDPRPSGRP2,
								  '09999', DECODE(SUBSTR(A.FNDPRPSUNIT, 1, 2), '01', '02. ' || F.FNDPRPSGRP3, '99. ' || E.FNDPRPSGRP2),
								  '09. Kh∏c') ITEM,
			A.BRCD || '-' || A.DSBSID || '-' || A.DSBSSEQ DSBSSEQ,
			A.CUSTSEQLN AS CUSTSEQ,
			(SELECT 
				DRAC1
			FROM   
				GL1.TBGL_ACKEYDD
			WHERE  
				BRCD = A.BRCD
				AND APPLTP = 'L'
				AND TRREF = A.LNTPCD
				AND SUBTP = A.LNSBTPCD
				AND EVENTTP = 'DS'
				AND AMTTP = 'N') AS ACCTCD,
			SUBSTR(A.ACCTKEY, 6, 1) PDGRP,
			A.CCYCD AS CCY,
			A.DSBSBAL AS LDRBAL,
			CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCYCD, A.DSBSBAL, '01', 'VND', '01') LDRBAL_VND
		FROM
			LN1.TBLN_DSBSHIST A,
			(SELECT CODE, DECODE FNDPRPSGRP2
			FROM RACE.T_CODE
			WHERE CAT_NAME = 'LNFNDPRPSTPCD') E,
			(SELECT CODE, DECODE FNDPRPSGRP3
			FROM RACE.T_CODE
			WHERE CAT_NAME = 'LNFNDPRPSUNIT'
			AND LENGTH(CODE) = 7) F,
			(SELECT CODE, DECODE FNDPRPSGRP4
			FROM RACE.T_CODE
			WHERE CAT_NAME = 'LNFNDPRPSUNIT') G
		WHERE
			A.BRCD LIKE '%'
			AND A.BKDT = &h_trdt
			AND A.BUSCD = 'LN'
			AND A.STSCD IN ('01', '05')

			AND A.FNDPRPSTPCD = E.CODE (+)
			AND A.FNDPRPSTPCD||SUBSTR(A.FNDPRPSUNIT, 1, 2) = F.CODE (+)
			AND A.FNDPRPSTPCD||A.FNDPRPSUNIT = G.CODE (+)

			AND A.DSBSBAL > 0
			AND LN1.CHK_LNCUSTTP(A.BRCD, A.DSBSID, A.DSBSSEQ, '', 'MORT') = 'Y'
			AND (SUBSTR(A.FNDPRPSTPCD, 1, 2) IN ('09', '10') OR A.FNDPRPSTPCD = 'BK004')
		
		UNION ALL

		SELECT
			DECODE('%', '%', DECODE('Y', 'N', '9999', A.BRCD), A.BRCD) BRCD,
			DECODE(SUBSTR(A.DEPTCD, 3, 1), 'O', A.DEPTCD) DEPTCD,
			'02. Kh∏c vay ti™u dÔng, k.doanh ch¯ng kho∏n' GRP,
			DECODE(E.CRDTLINETPCD, '01',
				DECODE(A.FNDPRPSTPCD, '04007',
					'1a. C„ hπn m¯c (Kinh doanh vµng)',
					'1b. C„ hπn m¯c (Kh∏c kinh doanh vµng)'),
				DECODE(A.FNDPRPSTPCD, '04007',
					'2a. Kh´ng c„ hπn m¯c (Kinh doanh vµng)',
					'2b. Kh´ng c„ hπn m¯c (Kh∏c kinh doanh vµng)')) ITEM,
			A.BRCD || '-' || A.DSBSID || '-' || A.DSBSSEQ DSBSSEQ,
			A.CUSTSEQLN AS CUSTSEQ,
			(SELECT 
				DRAC1
			FROM   
				GL1.TBGL_ACKEYDD
			WHERE  
				BRCD = A.BRCD
				AND APPLTP = 'L'
				AND TRREF = A.LNTPCD
				AND SUBTP = A.LNSBTPCD
				AND EVENTTP = 'DS'
				AND AMTTP = 'N') AS ACCTCD,
			SUBSTR(A.ACCTKEY, 6, 1) PDGRP,
			A.CCYCD AS CCY,
			A.DSBSBAL AS LDRBAL,
			CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCYCD, A.DSBSBAL, '01', 'VND', '01') LDRBAL_VND
		FROM
			LN1.TBLN_DSBSHIST A, 
			LN1.TBLN_APPR E
		WHERE
			A.BRCD LIKE '%'
			AND A.BKDT = &h_trdt
			AND A.BUSCD = 'LN'
			AND A.STSCD IN ('01', '05')

			AND A.DSBSBAL > 0

			AND SUBSTR(A.FNDPRPSTPCD, 1, 2) NOT IN ('09', '10')
			AND A.FNDPRPSTPCD <> 'BK004'

			AND A.BRCDAPPR = E.BRCD
			AND A.APPRID = E.APPRID
			AND A.APPRSEQ = E.APPRSEQ

			AND LN1.CHK_LNCUSTTP(A.BRCD, A.DSBSID, A.DSBSSEQ, '', 'MORT') = 'Y'

		UNION ALL

		SELECT
			DECODE('%', '%', DECODE('Y', 'N', '9999', A.BRCD), A.BRCD) BRCD,
			'' DEPTCD,
			'99. kh∏c' GRP,
			DECODE(SUBSTR(A.ACCTCD, 1, 3), '275', DECODE(SUBSTR(A.ACCTCD, 6, 1), '1', '01. ThŒ t›n dÙng', '99. Kh∏c'), '99. Kh∏c') ITEM,
			A.BRCD || '-' || A.CUSTSEQ DSBSSEQ,
			A.CUSTSEQ,
			A.ACCTCD,
			DECODE(SUBSTR(A.ACCTCD, 4, 1), '0', '5', SUBSTR(A.ACCTCD, 4, 1)) PDGRP,
			A.CCY,
			A.TDBAL,
			CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, A.TDBAL, '01', 'VND', '01') LDRBAL_VND
		FROM
			GL1.TBGL_MAST A
		WHERE
			LN1.CHK_BRHLDY('%', &h_trdt) = 'N'
			AND A.BRCD LIKE '%'
			AND A.TRDT = &h_trdt
			AND A.ACCTCD LIKE '2%'
			AND A.ACCTCD NOT LIKE '275_00'
			AND SUBSTR(A.ACCTCD, 1, 3) NOT IN ('211', '212', '213', '222', '223', '241', '271')
			AND SUBSTR(A.ACCTCD, 3, 1) NOT IN ('7', '9')
			AND A.TDBAL > 0

			AND LN1.CHK_LNCUSTTP(A.BRCD, '', '', A.CUSTSEQ, 'MORT') = 'Y'
			AND LN1.CHKACCT20SBV(A.ACCTCD, A.CCY) = 'N'

		UNION ALL

		SELECT
			BRCD,
			'' DEPTCD,
			'99. kh∏c' GRP,
			'03. Th u chi c∏ nh©n' ITEM,
			DSBSSEQ,
			CUSTSEQ,
			ACCTCD,
			PDGRP,
			CCY,
			LDRBAL,
			LDRBAL_VND
		FROM
		(
			SELECT DISTINCT
				DECODE('%', '%', DECODE('Y', 'N', '9999', A.BRCD), A.BRCD) BRCD,
				A.BRCD || '-' || A.CUSTSEQ DSBSSEQ,
				B.CUSTSEQ,
				C.ACCTCD,
				DECODE(SUBSTR(C.ACCTCD, 4, 1), '0', '5', SUBSTR(C.ACCTCD, 4, 1)) PDGRP,
				B.CCY,
				DECODE(SIGN(0 + B.CLRBAL), -1, -B.CLRBAL, 0) LDRBAL,
				DECODE(SIGN(0 + B.CLRBAL), -1, CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCY, -B.CLRBAL, '01', 'VND', '01'), 0) LDRBAL_VND
			FROM
				DP1.TBDP_ODLMT A, GL1.TBGL_BALDD B, GL1.TBGL_MAST C
			WHERE
				B.BRCD LIKE '%'
				AND B.TRDT = &h_trdt
				AND A.BRCD = B.BRCD
				AND A.DPTPCD = B.TRREF
				AND A.ACCTSEQ = B.TRSEQ
				AND A.DPTPCD <>'103'
				AND A.BRCD = C.BRCD
				AND A.CUSTSEQ = C.CUSTSEQ
				AND B.TRDT = C.TRDT
				AND B.CLRBAL = - C.TDBAL
				AND B.ACCTCD LIKE '275%'
				AND C.ACCTCD LIKE '275%'
				AND B.CCY = 'VND'
				AND LN1.CHK_LNCUSTTP(B.BRCD, '', '', B.CUSTSEQ, 'MORT') = 'Y'
		)
		WHERE
			LDRBAL > 0

		UNION ALL

		SELECT
			BRCD,
			'' DEPTCD,
			'99. kh∏c' GRP,
			'04. Th u chi kh∏c' ITEM,
			BRCD || '-' || CUSTSEQ DSBSSEQ,
			CUSTSEQ,
			ACCTCD,
			PDGRP,
			CCY,
			LDRBAL,
			LDRBAL_VND
		FROM
		(
			SELECT
				BRCD,
				CCY,
				CUSTSEQ,
				ACCTCD,
				PDGRP,
				SUM(LDRBAL) LDRBAL,
				SUM(LDRBAL_VND) LDRBAL_VND
			FROM
			(
				SELECT
					DECODE('%', '%', DECODE('Y', 'N', '9999', A.BRCD), A.BRCD) BRCD,
					A.CUSTSEQ,
					A.ACCTCD,
					DECODE(SUBSTR(A.ACCTCD, 4, 1), '0', '5', SUBSTR(A.ACCTCD, 4, 1)) PDGRP,
					A.CCY,
					A.TDBAL LDRBAL,
					CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, A.TDBAL, '01', 'VND', '01') LDRBAL_VND
				FROM
					GL1.TBGL_MAST A
				WHERE
					LN1.CHK_BRHLDY('%', &h_trdt) = 'N'

					AND A.BRCD LIKE '%'
					AND A.TRDT = &h_trdt

					AND A.ACCTCD LIKE '275_00'
					AND A.TDBAL > 0

					AND LN1.CHK_LNCUSTTP(A.BRCD, '', '', A.CUSTSEQ, 'MORT') = 'Y'


				UNION ALL

				SELECT
					DECODE('%', '%', DECODE('Y', 'N', '9999', A.BRCD), A.BRCD) BRCD,
					CUSTSEQ,
					A.ACCTCD,
					DECODE(SUBSTR(A.ACCTCD, 4, 1), '0', '5', SUBSTR(A.ACCTCD, 4, 1)) PDGRP,
					CCY,
					- DECODE(SIGN(A.CLRBAL), -1, -A.CLRBAL, 0) LDRBAL,
					- DECODE(SIGN(A.CLRBAL), -1, CS1.EXCROSSCAL(A.BRCD, 'VND', &h_trdt, A.CCY, -A.CLRBAL, '01', 'VND', '01'), 0) LDRBAL_VND
				FROM
					GL1.TBGL_BALDD A
				WHERE
					A.BRCD LIKE '%'
					AND A.TRDT = &h_trdt
					AND A.ONOFFTP = '1'
					AND A.BUSCD = DECODE(A.TRREF,'GLX','GL','DP')
					AND SUBSTR(A.ACCTCD, 1, 1) IN ('4','2')
					AND A.ACCTCD IN ('431100','462102','411100','275100')
					AND A.TRREF IN ('118','119','120','121','123','124','GLX')
					AND A.CLRBAL <> 0
					AND LN1.CHK_LNCUSTTP(A.BRCD, '', '', A.CUSTSEQ, 'MORT') = 'Y'


				UNION ALL

				SELECT DISTINCT
					DECODE('%', '%', DECODE('Y', 'N', '9999', A.BRCD), A.BRCD) BRCD,
					B.CUSTSEQ,
					C.ACCTCD,
					DECODE(SUBSTR(C.ACCTCD, 4, 1), '0', '5', SUBSTR(C.ACCTCD, 4, 1)) PDGRP,
					B.CCY,
					- DECODE(SIGN(0 + B.CLRBAL), -1, -B.CLRBAL, 0) CLRBAL,
					- DECODE(SIGN(0 + B.CLRBAL), -1, CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCY, -B.CLRBAL, '01', 'VND', '01'), 0) CLRBAL
				FROM
					DP1.TBDP_ODLMT A, GL1.TBGL_BALDD B, GL1.TBGL_MAST C
				WHERE
					B.BRCD LIKE '%'

					AND B.TRDT = &h_trdt
					AND A.BRCD = B.BRCD
					AND A.DPTPCD = B.TRREF
					AND A.ACCTSEQ = B.TRSEQ
					AND A.DPTPCD <>'103'
					AND A.BRCD = C.BRCD
					AND A.CUSTSEQ = C.CUSTSEQ
					AND B.TRDT = C.TRDT
					AND B.CLRBAL = - C.TDBAL
					AND B.ACCTCD LIKE '275%'
					AND C.ACCTCD LIKE '275%'
					AND B.CCY = 'VND'
					AND LN1.CHK_LNCUSTTP(B.BRCD, '', '', B.CUSTSEQ, 'MORT') = 'Y'

			)
			GROUP BY
				BRCD, CCY, CUSTSEQ, ACCTCD, PDGRP
		)
		WHERE
			LDRBAL > 0
	)
) XX, TBCS_BRCD YY, TBCS_DEPTCD ZZ
WHERE
	XX.BRCD = YY.BRCD (+)
	AND XX.DEPTCD = ZZ.DEPTCD (+)
GROUP BY
	XX.BRCD, NVL(YY.LCLBRNM, 'EIB he thong'), XX.DEPTCD, ZZ.DEPTNMLOC, XX.GRP, XX.ITEM, XX.LNTPNM, XX.CCY
