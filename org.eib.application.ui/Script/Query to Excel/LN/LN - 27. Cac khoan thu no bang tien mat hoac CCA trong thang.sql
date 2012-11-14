--define h_trdt = '20110221'

SELECT A.BRCD CHI_NHANH,
	D.LCLBRNM TEN_CN,
	A.CUSTSEQLN CIF,
	E.SHRTNM TEN_KH,
	A.DSBSSEQ SO_KHE_UOC,
	A.DSBSDT NGAY_GIAI_NGAN,
	A.MATDT NGAY_DAO_HAN,
	SUBSTR(A.LNSBTPCD,2,1) NHOM_NO,
	LN1.GET_TCODE('LNLNTPCD', 'CC', A.LNTPCD, 'DECODE') THOI_HAN_VAY,
	DECODE(LENGTH(A.FNDPRPSTPCD), 5, LN1.GET_TCODE('LNFNDPRBRLEV1', 'CC', SUBSTR(A.FNDPRPSTPCD, 1, 2), 'DECODE')) MUC_DICH_VAY_CAP_1,
	LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', A.FNDPRPSTPCD, 'DECODE') MUC_DICH_VAY_CAP_2,
	LN1.GET_TCODE('LNFNDPRPSUNIT', 'CC', A.FNDPRPSTPCD||SUBSTR(A.FNDPRPSUNIT, 1, 2), 'DECODE') MUC_DICH_VAY_CAP_3,
	LN1.GET_TCODE('LNFNDPRPSUNIT', 'CC', A.FNDPRPSTPCD||A.FNDPRPSUNIT, 'DECODE') MUC_DICH_VAY_CAP_4,
	B.TRDT NGAY_THU_NO,
	B.RPMTSEQ SO_THU_NO,
	A.CCYCD LOAI_TIEN,
	NVL(B.RPMTAMT,0) SO_TIEN_THU_NO_GOC,
	NVL(B.INTAMT,0) SO_TIEN_THU_NO_LAI,
	CCYCDSTL LOAI_TIEN_THANH_TOAN,
	STLAMT SO_TIEN_THANH_TOAN,
	CS1.EXCROSSCAL(C.BRCD, 'VND', &h_trdt, C.CCYCDSTL, NVL(C.STLAMT,0), '01', 'VND', '01')  SO_TIEN_TT_VND,
	DECODE(CNTRPARTTPCD, '01', 'CASH', '02', 'CCA') PHUONG_THUC_THU
FROM LN1.TBLN_DSBS A, LN1.TBLN_RPMT B, LN1.TBLN_STL C, CS1.TBCS_BRCD D, CM1.TBCM_GENERAL E
WHERE A.BUSCD = 'LN'
	AND A.STSCD IN ('01', '05')
	AND A.BRCD = B.BRCDDSBS
	AND A.DSBSID = B.DSBSID
	AND A.DSBSSEQ = B.DSBSSEQ

	AND B.STSCD = '01'
	AND B.TRDT BETWEEN SUBSTR(&h_trdt, 1,6)||'01' AND &h_trdt
	AND B.BRCD = C.BRCDAPL
	AND B.RPMTID = C.APLID
	AND B.RPMTSEQ = C.APLSEQ
	AND C.STSCD = '01'
	AND C.CNTRPARTTPCD IN ('01', '02')

	AND A.BRCD = D.BRCD
	AND A.BRCDLN = E.BRCD
	AND A.CUSTSEQLN = E.CUSTSEQ
