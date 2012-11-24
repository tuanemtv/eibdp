--define h_trdt = '20121112'

SELECT
	BRCD,
	LCLBRNM CHI_NHANH,
	CUSTSEQLN,
	NMLOC KHACH_HANG,
	APPRSEQ HOP_DONG,
	CRDTLINETPCD LOAI_HOP_DONG,
	PLGAMT_VND TSDB,
	DSBSSEQ KHE_UOC,
	LOANTYPE THOI_HAN_VAY,
	MAT THOI_GIAN_VAY,
	FNDPRPS1 MUC_DICH_VAY_CAP_1,
	FNDPRPS2 MUC_DICH_VAY_CAP_2,
	FNDPRPS3 MUC_DICH_VAY_CAP_3,
	FNDPRPS4 MUC_DICH_VAY_CAP_4,
	OTHRTP LOAI_SP,
	CCYCD LOAI_TIEN,
	DSBSAMT SO_TIEN_GIAI_NGAN,
	DSBSBAL DU_NO,
	DSBSBAL_VND DU_NO_QUY_DOI,
	DSBSDT NGAY_GIAI_NGAN,
	MATDT NGAY_DAO_HAN,
	GRCPRD AN_HAN,
	BSRTCD CODE_LAI_SUAT,
	BASERATE,
	SPRD BIEN_DO,
	TOTALRATE LAI_SUAT,
	LOAI_LS,
	GROUPBAL NHOM_NO,
	AVLRTREF CHUONG_TRINH_HTLS,
	FNDPRPSAVLRT NGANH_HTLS,
	VDB,
	INSFLG BAO_HIEM_CN,
	INSREFRNO HOP_DONG_BH,
	INSRTNM LOAI_BH,
	DEPTNM PHONG_GIAO_DICH,
	RPMTPROGCD TRA_GOC,
	SCHDPRCPMM KY_TRA_GOC,
	NXTINTSCHDDT NGAY_THU_LAI,
	NXTRPMTSCHDDT NGAY_THU_GOC,
	CASHFLG GN_TIEN_MAT_TREN_1TYDONG,
	REM REMARK,
	DSBSCLFLG TSDB_KW,
	DSBSCLAMT TSDB_GIATRI,
	DSBSCLAMT_VND TSDB_GIATRI_QD,
	CCYCDAPPR LOAI_TIEN_HOP_DONG,
	APPRAMT HAN_MUC,
	LUMPARTPCD TRA_LAI,
	INTPYMNTINTVMM KY_TRA_LAI,
	LN1.GET_TCODE('LNFNDPRPSSBTPCD', 'CC', FNDPRPSSBTPCD, 'DECODE') FNDPRPSSBNM,
	APPRDT NGAY_MO_HD,
	DSBSTRMLMT THOI_HAN_RUT_VON,
        FTP_BSRTCD,
	FTP_BASERATE,
	FTP_DEAL_RATE   ,INTMTHDTPCD
FROM
(
	SELECT
		B.BRCD,
		G.LCLBRNM,
		B.CUSTSEQLN,
		D.NMLOC,
		B.APPRSEQ,
		LN1.GET_TCODE('LNCRDTLINETPCD', 'CC', A.CRDTLINETPCD, 'DECODE') CRDTLINETPCD,
		E.PLGAMT_VND,
		B.DSBSSEQ,
		LN1.GET_TCODE('LNLNTPCD', 'CC', B.LNTPCD, 'DECODE') LOANTYPE,
		ROUND(MONTHS_BETWEEN(TO_DATE(B.MATDT,'YYYYMMDD'), TO_DATE(B.DSBSDT,'YYYYMMDD')),0) MAT,
		DECODE(LENGTH(B.FNDPRPSTPCD), 5, LN1.GET_TCODE('LNFNDPRBRLEV1', 'CC', SUBSTR(B.FNDPRPSTPCD, 1, 2), 'DECODE')) FNDPRPS1,
		LN1.GET_TCODE('LNFNDPRPSTPCD', 'CC', B.FNDPRPSTPCD, 'DECODE') FNDPRPS2,
		LN1.GET_TCODE('LNFNDPRPSUNIT', 'CC', B.FNDPRPSTPCD||SUBSTR(B.FNDPRPSUNIT, 1, 2), 'DECODE') FNDPRPS3,
		LN1.GET_TCODE('LNFNDPRPSUNIT', 'CC', B.FNDPRPSTPCD||B.FNDPRPSUNIT, 'DECODE') FNDPRPS4,
		LN1.GET_TCODE('LNOTHRTPCD', 'VN', B.FNDPRPSTPCD||NVL(B.FNDPRPSUNIT,'00000')||B.OTHRTPCD, 'DECODE') OTHRTP,
		B.CCYCD,
		B.DSBSAMT,
		B.DSBSBAL,
		DECODE(B.CCYCD, 'VND', B.DSBSBAL, CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCYCD, NVL(B.DSBSBAL,0), '01', 'VND', '01')) DSBSBAL_VND,
		B.DSBSDT,
		B.MATDT,
		B.GRCPRDYY * 12 + B.GRCPRDMM GRCPRD,
		B.BSRTCD,
		B.BASERATE,
		DECODE(B.INTRTTPCD, '01', B.TOTALRATE - B.BASERATE, '02' , B.SPRD) SPRD,
		DECODE(B.INTRTTPCD, '01', B.TOTALRATE, '02' , B.SPRD + B.BASERATE) TOTALRATE,
		LN1.GET_INTRTTP(B.BRCD, B.DSBSID, B.DSBSSEQ) LOAI_LS,
		SUBSTR(B.LNSBTPCD, 2, 1) GROUPBAL,
		B.AVLRTFLG,
		LN1.GET_TCODE('LNAVLRTREF', 'VN', NVL(B.AVLRTREF, '00'), 'DECODE') AVLRTREF,
		LN1.GET_TCODE(
			DECODE(NVL(B.AVLRTREF,''),'', 'LNFNDPRPSAVLRT', DECODE(B.AVLRTREF, '01','LNECNMINDUSTCD','02','LNECNMINDUSTCD','04','LNECNMINDUSTCD','LNECNMPRODUCTCD')),
			'CC',
			DECODE(NVL(B.AVLRTREF,''),'', B.FNDPRPSAVLRT, DECODE(B.AVLRTREF, '01', SUBSTR(B.ECNMINDUSTRCD,1,1),'02',SUBSTR(B.ECNMINDUSTRCD,1,1),'04',SUBSTR(B.ECNMINDUSTRCD,1,1),B.ECNMPRDTCD)),
			'DECODE') FNDPRPSAVLRT,
		P.GNTEFLG VDB,
		M.INSFLG,
		M.INSREFRNO,
		M.INSRTNM,
		B.DEPTCD||' - '||(SELECT DEPTNM FROM CS1.TBCS_DEPTCD WHERE DEPTCD = B.DEPTCD) DEPTNM,
		B.REM,
		LN1.GET_TCODE('LNRPMTPROGCD', 'CC', B.RPMTPROGCD, 'DECODE') RPMTPROGCD,
		DECODE(B.RPMTPROGCD, '02', DECODE(C.PARRPMTMTHDCD, '01', C.INSTINTVMM, '03', C.INSTINTVMM)) SCHDPRCPMM,
		B.NXTINTSCHDDT,
		B.NXTRPMTSCHDDT,
		NVL(CASHFLG,'N') CASHFLG,
		B.DSBSCLFLG,
		DECODE(NVL(B.DSBSCLFLG, 'N'), 'Y', DSBSCLAMT) DSBSCLAMT,
		DECODE(NVL(B.DSBSCLFLG, 'N'), 'Y', CS1.EXCROSSCAL(B.BRCD, 'VND', &h_trdt, B.CCYCD, NVL(B.DSBSBAL,0), '01', 'VND', '01')) DSBSCLAMT_VND,
		A.CCYCD CCYCDAPPR,
		A.APPRAMT,
		LN1.GET_TCODE('LNLUMPARTPCD', 'CC', B.LUMPARTPCD, 'DECODE') LUMPARTPCD,
		B.INTPYMNTINTVMM,
		B.FNDPRPSSBTPCD,
		LN1.GET_APPRDT(A.BRCD,'LAV',A.APPRSEQ) APPRDT,
		A.DSBSTRMLMT,
		B.HOBSRTCD FTP_BSRTCD,
		NVL(B.HOBASERATE, 0) FTP_BASERATE,
		DECODE(DLFTPREGFLG, 'Y',
			DECODE(DLFTPCFMFLG, 'Y',
				DECODE(DLFTPVRFFLG, 'Y', NVL(B.DLFTPSPRD, 0), 0),
				0),
			0) FTP_DEAL_RATE    ,INTMTHDTPCD
	FROM
		LN1.TBLN_APPR A, LN1.TBLN_DSBSHIST B, LN1.TBLN_SCHDMAS C,
		CM1.TBCM_GENERAL D, CS1.TBCS_BRCD G,
		(SELECT
			BRCDAPPR, APPRID, APPRSEQ,
			SUM(DECODE(CCYCD, 'VND', PLGAMT, CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCD, NVL(PLGAMT,0),'01','VND','01'))) PLGAMT_VND
		FROM
			LN1.TBLN_PLG
		WHERE
			BUSCD = 'LN'
			AND(RLSTRDT>&h_trdt OR (STSCD = '01' AND NVL(RLSTRDT,'NONENONE')='NONENONE'))
			AND NVL(PLGTRDT, PLGDT) <= &h_trdt
			AND STSCD IN('01','03')
			AND REGSTPCD 	= '02'
		GROUP BY BRCDAPPR, APPRID, APPRSEQ) E,

		(SELECT DISTINCT
			BRCDAPPR, APPRID, APPRSEQ, 'VDB' GNTEFLG
		FROM
			LN1.TBLN_GNTE
		WHERE
			STSCD IN('01','03')
			AND(RLSTRDT>&h_trdt OR (STSCD = '01' AND NVL(RLSTRDT,'NONENONE')='NONENONE'))
			AND NVL(PROGCD, '00') = '01'
			AND NVL(APLTRDT, APLDT)<= &h_trdt) P,

		(SELECT
			X.BRCD, X.DSBSID, X.DSBSSEQ, X.REFRNO INSREFRNO, Y.INSRTNM, 'Y' INSFLG
		FROM
			LN1.TBLN_DSBSINSRT X, LN1.TBLN_INSRTCD Y
		WHERE
			X.STSCD = '01'
			AND X.BRCD = Y.BRCD
			AND X.INSRTCD = Y.INSRTCD
			AND Y.MONTHS = 0
			AND Y.STSCD = '01'
			AND X.INSRTCD <> '00') M,

		(SELECT BRCDAPL, APLSEQ, 'Y' CASHFLG
			FROM LN1.TBLN_STL
			WHERE STSCD = '01'
				AND CNTRPARTTPCD = '01'
				AND APLID = 'LDS'
				AND DECODE(CCYCDSTL, 'VND', STLAMT, CS1.EXCROSSCAL(BRCD, 'VND', &h_trdt, CCYCDSTL, NVL(STLAMT,0), '01', 'VND', '01')) >= 1000000000) Q

	WHERE
		B.BKDT = &h_trdt
		AND B.BUSCD = 'LN'

		AND A.BRCD = B.BRCDAPPR
		AND A.APPRID = B.APPRID
		AND A.APPRSEQ = B.APPRSEQ

		AND B.BRCD = C.BRCD
		AND B.DSBSID = C.DSBSID
		AND B.DSBSSEQ = C.DSBSSEQ
		AND C.STSCD = '01'

		AND B.BRCD = G.BRCD
		AND B.STSCD = '01'

		AND B.BRCD = D.BRCD
		AND B.CUSTSEQLN = D.CUSTSEQ

		AND B.BRCD = M.BRCD (+)
		AND B.DSBSID = M.DSBSID (+)
		AND B.DSBSSEQ = M.DSBSSEQ (+)

		AND B.BRCD = Q.BRCDAPL(+)
		AND B.DSBSSEQ = Q.APLSEQ(+)

		AND B.BRCDAPPR = E.BRCDAPPR (+)
		AND B.APPRID = E.APPRID (+)
		AND B.APPRSEQ = E.APPRSEQ (+)
		AND B.BRCDAPPR 	= P.BRCDAPPR (+)
		AND B.APPRID 	= P.APPRID (+)
		AND B.APPRSEQ 	= P.APPRSEQ (+)
		AND LN1.CHK_LNCUSTTP(B.BRCD, B.DSBSID, B.DSBSSEQ, B.CUSTSEQLN, 'CMP') = 'Y'
)
ORDER BY BRCD, CUSTSEQLN, APPRSEQ, DSBSSEQ
