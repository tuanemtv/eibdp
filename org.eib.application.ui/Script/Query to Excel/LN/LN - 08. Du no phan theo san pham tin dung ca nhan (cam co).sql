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
			'201100', 'a. Ng�n h�n', '201200', 'a. Ng�n h�n', '201300', 'a. Ng�n h�n', '201400', 'a. Ng�n h�n', '201500', 'a. Ng�n h�n',
			'205101', 'a. Ng�n h�n', '205201', 'a. Ng�n h�n', '205301', 'a. Ng�n h�n', '205801', 'a. Ng�n h�n',
			'211100', 'a. Ng�n h�n', '211101', 'a. Ng�n h�n', '211200', 'a. Ng�n h�n', '211201', 'a. Ng�n h�n',
			'211300', 'a. Ng�n h�n', '211301', 'a. Ng�n h�n', '211400', 'a. Ng�n h�n', '211401', 'a. Ng�n h�n',
			'211500', 'a. Ng�n h�n', '211501', 'a. Ng�n h�n',
			'211800', 'a. Ng�n h�n', '221100', 'a. Ng�n h�n', '221101', 'a. Ng�n h�n', '221200', 'a. Ng�n h�n', '221201', 'a. Ng�n h�n',
			'221300', 'a. Ng�n h�n', '221301', 'a. Ng�n h�n', '221400', 'a. Ng�n h�n', '221401', 'a. Ng�n h�n', '221500', 'a. Ng�n h�n', '221501', 'a. Ng�n h�n',
			'222100', 'a. Ng�n h�n', '222200', 'a. Ng�n h�n', '222300', 'a. Ng�n h�n', '222400', 'a. Ng�n h�n',
			'222801', 'a. Ng�n h�n', '222802', 'a. Ng�n h�n', '222803', 'a. Ng�n h�n',
			'241100', 'a. Ng�n h�n', '241200', 'a. Ng�n h�n', '241300', 'a. Ng�n h�n', '241400', 'a. Ng�n h�n', '241500', 'a. Ng�n h�n', '241800', 'a. Ng�n h�n',
			'251100', 'a. Ng�n h�n', '251101', 'a. Ng�n h�n', '251200', 'a. Ng�n h�n', '251201', 'a. Ng�n h�n', '251300', 'a. Ng�n h�n', '251301', 'a. Ng�n h�n', '251400', 'a. Ng�n h�n',
			'251500', 'a. Ng�n h�n', '251801', 'a. Ng�n h�n',
			'252100', 'a. Ng�n h�n', '252101', 'a. Ng�n h�n', '252200', 'a. Ng�n h�n', '252201', 'a. Ng�n h�n', '252300', 'a. Ng�n h�n', '252301', 'a. Ng�n h�n','252400', 'a. Ng�n h�n','252500', 'a. Ng�n h�n','252801', 'a. Ng�n h�n',
			'253100', 'a. Ng�n h�n', '253101', 'a. Ng�n h�n', '253200', 'a. Ng�n h�n', '253201', 'a. Ng�n h�n', '253300', 'a. Ng�n h�n', '253301', 'a. Ng�n h�n',
			'253400', 'a. Ng�n h�n', '253500', 'a. Ng�n h�n', '253801', 'a. Ng�n h�n',
			'275100', 'a. Ng�n h�n', '275101', 'a. Ng�n h�n', '275200', 'a. Ng�n h�n', '275201', 'a. Ng�n h�n', '275300', 'a. Ng�n h�n', '275301', 'a. Ng�n h�n','275400', 'a. Ng�n h�n','275500', 'a. Ng�n h�n',
			'275801', 'a. Ng�n h�n',
			'281000', 'a. Ng�n h�n', '282000', 'a. Ng�n h�n', '283000', 'a. Ng�n h�n', '284000', 'a. Ng�n h�n', '285000', 'a. Ng�n h�n',
			'291000', 'a. Ng�n h�n', '292000', 'a. Ng�n h�n', '293000', 'a. Ng�n h�n',
			DECODE(ACCTCD,
			'203102', 'b. Trung h�n',
			'204102', 'b. Trung h�n', '204202', 'b. Trung h�n', '204302', 'b. Trung h�n', '204802', 'b. Trung h�n',
			'205102', 'b. Trung h�n', '205202', 'b. Trung h�n', '205302', 'b. Trung h�n', '205802', 'b. Trung h�n',
			'212100', 'b. Trung h�n', '212200', 'b. Trung h�n', '212300', 'b. Trung h�n', '212400', 'b. Trung h�n', '212500', 'b. Trung h�n',
			'212800', 'b. Trung h�n',
			'231100', 'b. Trung h�n', '231200', 'b. Trung h�n', '231300', 'b. Trung h�n', '231400', 'b. Trung h�n', '231500', 'b. Trung h�n',
			'231800', 'b. Trung h�n', '251102', 'b. Trung h�n', '251202', 'b. Trung h�n', '251302', 'b. Trung h�n', '251802', 'b. Trung h�n',
			'252102', 'b. Trung h�n', '252202', 'b. Trung h�n', '252302', 'b. Trung h�n', '252802', 'b. Trung h�n',
			'253102', 'b. Trung h�n', '253202', 'b. Trung h�n', '253302', 'b. Trung h�n', '253802', 'b. Trung h�n',
			'271102', 'b. Trung h�n', '271105', 'b. Trung h�n', '271108', 'b. Trung h�n', '271111', 'b. Trung h�n', '271198', 'b. Trung h�n',
			'271202', 'b. Trung h�n', '271205', 'b. Trung h�n', '271208', 'b. Trung h�n', '271211', 'b. Trung h�n', '271298', 'b. Trung h�n',
			'271302', 'b. Trung h�n', '271305', 'b. Trung h�n', '271308', 'b. Trung h�n', '271311', 'b. Trung h�n', '271398', 'b. Trung h�n',
			'271802', 'b. Trung h�n', '271805', 'b. Trung h�n', '271808', 'b. Trung h�n', '271811', 'b. Trung h�n', '271898', 'b. Trung h�n',
			'272102', 'b. Trung h�n', '272202', 'b. Trung h�n', '272302', 'b. Trung h�n', '272802', 'b. Trung h�n',
			'273102', 'b. Trung h�n', '273202', 'b. Trung h�n', '273302', 'b. Trung h�n', '273802', 'b. Trung h�n',
			'274102', 'b. Trung h�n', '274202', 'b. Trung h�n', '274302', 'b. Trung h�n', '274802', 'b. Trung h�n',
			'275102', 'b. Trung h�n', '275202', 'b. Trung h�n', '275302', 'b. Trung h�n', '275802', 'b. Trung h�n',
			'223100', 'b. Trung h�n', '223200', 'b. Trung h�n', '223300', 'b. Trung h�n', '223400', 'b. Trung h�n',
			DECODE(ACCTCD,
			'203103', 'c. D�i h�n',
			'204103', 'c. D�i h�n', '204203', 'c. D�i h�n', '204303', 'c. D�i h�n', '204803', 'c. D�i h�n',
			'205103', 'c. D�i h�n', '205203', 'c. D�i h�n', '205303', 'c. D�i h�n', '205803', 'c. D�i h�n',
			'213100', 'c. D�i h�n', '213200', 'c. D�i h�n', '213300', 'c. D�i h�n', '213400', 'c. D�i h�n', '213500', 'c. D�i h�n', '213800', 'c. D�i h�n',
			'251103', 'c. D�i h�n', '251203', 'c. D�i h�n', '251303', 'c. D�i h�n', '251803', 'c. D�i h�n',
			'252103', 'c. D�i h�n', '252203', 'c. D�i h�n', '252303', 'c. D�i h�n', '252803', 'c. D�i h�n',
			'253103', 'c. D�i h�n', '253203', 'c. D�i h�n', '253303', 'c. D�i h�n', '253803', 'c. D�i h�n',
			'271103', 'c. D�i h�n', '271106', 'c. D�i h�n', '271109', 'c. D�i h�n', '271112', 'c. D�i h�n', '271199', 'c. D�i h�n',
			'271203', 'c. D�i h�n', '271206', 'c. D�i h�n', '271209', 'c. D�i h�n', '271212', 'c. D�i h�n', '271299', 'c. D�i h�n',
			'271303', 'c. D�i h�n', '271306', 'c. D�i h�n', '271309', 'c. D�i h�n', '271312', 'c. D�i h�n', '271399', 'c. D�i h�n',
			'271803', 'c. D�i h�n', '271806', 'c. D�i h�n', '271809', 'c. D�i h�n', '271812', 'c. D�i h�n', '271899', 'c. D�i h�n',
			'272103', 'c. D�i h�n', '272203', 'c. D�i h�n', '272303', 'c. D�i h�n', '272803', 'c. D�i h�n',
			'273103', 'c. D�i h�n', '273203', 'c. D�i h�n', '273303', 'c. D�i h�n', '273803', 'c. D�i h�n',
			'274103', 'c. D�i h�n', '274203', 'c. D�i h�n', '274303', 'c. D�i h�n', '274803', 'c. D�i h�n',
			'275103', 'c. D�i h�n', '275203', 'c. D�i h�n', '275303', 'c. D�i h�n', '275803', 'c. D�i h�n', ACCTCD
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
			DECODE(A.FNDPRPSTPCD, '09001', '01. b�t ��ng s�n',
								  '09011', '03. th�u chi',
								  '09012', '03. th�u chi',
								  '09013', '03. th�u chi',
								  '09014', '03. th�u chi',
								  '09004', '04. mua ph��ng ti�n v�n t�i',
								  '09002', '05. du h�c',
								  '09003', '05. du h�c',
								  '09007', '05. du h�c',
								  '09016', '05. du h�c',
								  'BK004', '05. du h�c',
								  '09005', '06. c�n b�, c�ng nh�n vi�n',
								  '09006', '06. c�n b�, c�ng nh�n vi�n',
								  '09008', '06. c�n b�, c�ng nh�n vi�n',
								  '10001', '07. kinh doanh ch�ng kho�n',
								  '10002', '07. kinh doanh ch�ng kho�n',
								  '10003', '07. kinh doanh ch�ng kho�n',
								  '10004', '07. kinh doanh ch�ng kho�n',
								  '10005', '07. kinh doanh ch�ng kho�n',
								  '10006', '07. kinh doanh ch�ng kho�n',
								  '10007', '07. kinh doanh ch�ng kho�n',
								  '10999', '07. kinh doanh ch�ng kho�n',
								  '09009', '08. ti�u d�ng sinh ho�t kh�c',
								  '09015', '08. ti�u d�ng sinh ho�t kh�c',
								  '09999', '08. ti�u d�ng sinh ho�t kh�c',
								  '09. kh�c') GRP,
			DECODE(A.FNDPRPSTPCD, '09001', DECODE(TRIM(SUBSTR(A.FNDPRPSUNIT, 1, 2)), '', '00. Kh�c',  SUBSTR(A.FNDPRPSUNIT, 1, 2) || '. ' || F.FNDPRPSGRP3),
								  '09011', '01. ' || E.FNDPRPSGRP2,
								  '09012', '02. ' || E.FNDPRPSGRP2,
								  '09013', '03. ' || E.FNDPRPSGRP2,
								  '09014', '04. ' || E.FNDPRPSGRP2,
								  '09004', '01. Mua ph��ng ti�n v�n t�i',
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
								  '10001', '05. Kinh doanh ch�ng kho�n kh�c',
								  '10002', '05. Kinh doanh ch�ng kho�n kh�c',
								  '10006', '05. Kinh doanh ch�ng kho�n kh�c',
								  '10999', '05. Kinh doanh ch�ng kho�n kh�c',
								  '09009', '01. ' || E.FNDPRPSGRP2,
								  '09015', '03. ' || E.FNDPRPSGRP2,
								  '09999', DECODE(SUBSTR(A.FNDPRPSUNIT, 1, 2), '01', '02. ' || F.FNDPRPSGRP3, '99. ' || E.FNDPRPSGRP2),
								  '09. Kh�c') ITEM,
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
			'02. Kh�c vay ti�u d�ng, k.doanh ch�ng kho�n' GRP,
			DECODE(E.CRDTLINETPCD, '01',
				DECODE(A.FNDPRPSTPCD, '04007',
					'1a. C� h�n m�c (Kinh doanh v�ng)',
					'1b. C� h�n m�c (Kh�c kinh doanh v�ng)'),
				DECODE(A.FNDPRPSTPCD, '04007',
					'2a. Kh�ng c� h�n m�c (Kinh doanh v�ng)',
					'2b. Kh�ng c� h�n m�c (Kh�c kinh doanh v�ng)')) ITEM,
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
			'99. kh�c' GRP,
			DECODE(SUBSTR(A.ACCTCD, 1, 3), '275', DECODE(SUBSTR(A.ACCTCD, 6, 1), '1', '01. Th� t�n d�ng', '99. Kh�c'), '99. Kh�c') ITEM,
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
			'99. kh�c' GRP,
			'03. Th�u chi c� nh�n' ITEM,
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
			'99. kh�c' GRP,
			'04. Th�u chi kh�c' ITEM,
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
