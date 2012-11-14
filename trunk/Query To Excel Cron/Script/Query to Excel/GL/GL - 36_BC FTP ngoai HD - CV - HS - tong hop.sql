--define	h_predt = '20120709'
--define	h_trdt  = '20120710'
--define	h_brcd  = '1000'

SELECT CCY,ACCTCD,TRSEQ,TRDRCR,ACRFMDT,ACRTODT,ACRAMT,BCEQA,ACRBAMT,BSRTCD,BSRT,INTRT,REMARK,ACRKD
FROM
      (
       SELECT A.CCY,
			DECODE(BSIRKND,'A','801004','711003') ACCTCD,
			FTPCD TRSEQ,
			DECODE(BSIRKND,'A','D','C') TRDRCR,
			HLDY ACRFMDT,
			HLDY ACRTODT,
			LAI ACRAMT,
			LAIQUIDOI BCEQA,
			DUCUOI ACRBAMT,
			BSRTCD,
			LAISUAT BSRT,
			LAISUAT INTRT,
	        	TENMUC REMARK,
	        	DECODE(BSIRKND,'A','1','3') ACRKD
	FROM
	(
		--START TTDTRAM ADD 20120210
		SELECT	BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD,SUM(DUCUOI) DUCUOI,SUM(LAISUAT) LAISUAT,
				SUM(LAI) LAI, SUM(LAIQUIDOI) LAIQUIDOI
		FROM
		(
		--END TTDTRAM ADD 20120210
			SELECT BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD,DUCUOI,LAISUAT,DECODE(CCY,'JPY',round(LAI,0),'VND',round(LAI,0),round(LAI,2)) LAI,
					CS1.excrosscal(BRCD, 'VND',  TRDT, CCY, DECODE(CCY,'JPY',round(LAI,0),'VND',round(LAI,0),round(LAI,2)), '01', 'VND', '01') LAIQUIDOI
			FROM
			(
				SELECT BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD,
					--DUCUOI,
					ABS(DECODE(FTPCD,'A01800',DECODE(SIGN(DUCUOI),-1,DUCUOI,0),
									'B00900',DECODE(SIGN(DUCUOI),1,DUCUOI,0),
									--'A00250',DECODE(SIGN(DUCUOI),1,DUCUOI,0),
									'A00220',DECODE(SIGN(DUCUOI - DUCUOI1),1,DUCUOI1,DUCUOI),
									'A00250',DECODE(SIGN(DUCUOI - DUCUOI1),1,DUCUOI - DUCUOI1,0),
									'A00100',DECODE(SIGN(DUCUOI - DUCUOI1),1,DUCUOI,DUCUOI1),
									DUCUOI)) DUCUOI,
					--CS1.getftpbsir('1000',BSRTCD,CCY,TRDT,BSIRKND,'100') LAISUAT, --thao rem 20120103
					CS1.getglftpbsir('1000',BSRTCD,CCY,HLDY,BSIRKND,DECODE(FTPCD,'B00302','200','100'),FTPCD) LAISUAT, --thao 20120103
					--DUCUOI*CS1.getftpbsir('1000',BSRTCD,CCY,TRDT,BSIRKND,'100')/(100*360) AS LAI
					--ABS(DECODE(FTPCD,'A01800',DECODE(SIGN(DUCUOI),-1,DUCUOI,0),'B00900',DECODE(SIGN(DUCUOI),1,DUCUOI,0),DUCUOI))*CS1.getftpbsir('1000',BSRTCD,CCY,TRDT,BSIRKND,'100')/(100*360) AS LAI--thao rem 20120103
					ABS(DECODE(FTPCD,'A01800',DECODE(SIGN(DUCUOI),-1,DUCUOI,0),
									'B00900',DECODE(SIGN(DUCUOI),1,DUCUOI,0),
									--'A00250',DECODE(SIGN(DUCUOI),1,DUCUOI,0),
									'A00220',DECODE(SIGN(DUCUOI - DUCUOI1),1,DUCUOI1,DUCUOI),
									'A00250',DECODE(SIGN(DUCUOI - DUCUOI1),1,DUCUOI - DUCUOI1,0),
									'A00100',DECODE(SIGN(DUCUOI - DUCUOI1),1,DUCUOI,DUCUOI1),
									DUCUOI))*CS1.getglftpbsir('1000',BSRTCD,CCY,HLDY,BSIRKND,DECODE(FTPCD,'B00302','200','100'),FTPCD)/(100*360) AS LAI--thao 20120103
				FROM
				(
					SELECT BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD,SUM(DUCUOI) DUCUOI
								,SUM(DUCUOI1) DUCUOI1 --THAO THEM 20120420
					FROM
					(
						SELECT A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD,
									--A.ACCTFOUR, A.LEVEL2 FPTCD, A.EXCEPT,
									SUM(DECODE(A.CONDITION,	'DN'	, A.DCN,
														'-DN'	, -A.DCN,
														'DC'	, A.DCC,
														'-DC'	, -A.DCC,
														'DN-DC' , A.DCN-A.DCC,
														'DC-DN'	, A.DCC-A.DCN,
														'CLDN'	, DECODE(SIGN(A.DCN-A.DCC),-1,0,A.DCN-A.DCC),
														'-CLDN'	, -DECODE(SIGN(A.DCN-A.DCC),-1,0,A.DCN-A.DCC),
														'CLDC'	, DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN),
														'-CLDC'	, -DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN))) AS DUCUOI
                                      , 0 DUCUOI1 --THAO THEM 20120420
						FROM
						(
							SELECT 	B.BRCD,B.TRDT,B.HLDY,B.CCY,
								A.ACCTFOUR,
								A.LEVEL2, A.CONDITION, A.EXCEPT,
								C.FTPCD,
								C.BSIRKND, C.BSRTCD,
								C.TENMUC,
							 	SUM(B.DCN) DCN, SUM(B.DCC) DCC
							FROM GL1.TBGL_RPTAC_NEW A,
							(
								SELECT CODE FTPCD, STATCODE BSIRKND, STATDECODE BSRTCD, DECODE TENMUC
								FROM RACE.T_CODE
								WHERE CAT_NAME = 'GLFTP0'
								AND CODE NOT IN ('B00300','B00301','B00302')
							) C,
							(
								SELECT A.BRCD,A.TRDT,A.CCY,A.HLDY,
										A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,
										DRBAL DCN,
										CRBAL DCC
								FROM
								(
									SELECT A.BRCD,A.TRDT,A.HLDY,
											B.ACCTCD AS ACCTCD,
											A.CCY AS CCY,
						            		SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, -A.BAL, 0),
																				DECODE(SIGN(A.BAL), -1, 0, A.BAL))) AS DRBAL,
											SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, 0, A.BAL),
																					DECODE(SIGN(A.BAL), -1, -A.BAL, 0))) AS CRBAL
									FROM
									(
									   	SELECT BRCD,TRDT,HLDY,CUSTSEQ, ACCTCD,CCY,SUM(BAL) BAL
									   	FROM
									   	(
									   		SELECT  A.BRCD,A.TRDT,B.HLDY,'000000000' CUSTSEQ,
														A.ACCTCD , A.CCY,
														SUM(A.TDBAL + A.TDACRBAL) AS BAL
											FROM  GL1.TBGL_MAST A,
											(
												SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
												FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
												WHERE A.BRCD = '1000'
												AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
												AND A.BRCD=B.BRCD
												AND B.TRDT <A.HLDY
												AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
												GROUP BY A.BRCD, A.HLDY
												UNION ALL
												SELECT A.BRCD, A.TRDT HLDY,A.TRDT
												FROM GL1.TBGL_STATUS A
												WHERE A.BRCD = '1000'
												AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
											) B
											WHERE A.BRCD=B.BRCD
											AND A.TRDT=B.TRDT
									   		AND (A.BRCD<>'1201' OR A.ACCTCD<>'375000' OR A.CUSTSEQ<>'104196569')
											AND ACCTCD  NOT IN ( SELECT DISTINCT ACCTCD
																			FROM GL1.TBGL_SBVCD
																			WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																			)
						   					GROUP BY  A.BRCD,A.TRDT,B.HLDY,
													A.ACCTCD , A.CCY
											UNION ALL
											SELECT  A.BRCD,A.TRDT,B.HLDY,A.CUSTSEQ,
														A.ACCTCD , A.CCY,
														A.TDBAL + A.TDACRBAL AS BAL
											FROM  GL1.TBGL_MAST A,
											(
												SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
												FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
												WHERE A.BRCD = '1000'
												AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
												AND A.BRCD=B.BRCD
												AND B.TRDT <A.HLDY
												AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
												GROUP BY A.BRCD, A.HLDY
												UNION ALL
												SELECT A.BRCD, A.TRDT HLDY,A.TRDT
												FROM GL1.TBGL_STATUS A
												WHERE A.BRCD = '1000'
												AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
											) B
											WHERE A.BRCD=B.BRCD
											AND A.TRDT=B.TRDT
											AND ACCTCD  IN ( SELECT DISTINCT ACCTCD
																			FROM GL1.TBGL_SBVCD
																			WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																			)
		--									--loai tru so lieu cua DP Thao them ngay 20110307
											union ALL
											SELECT A.BRCD,A.TRDT,B.HLDY,'000000000' CUSTSEQ,
												TBDP_DPTP.DPAC ACCTCD , TBDP_DMDMST.CCYCD CCY,
												--- SUM(clRBAL) BAL --test so ngay cu thi lay dong nay
												- SUM(CURBAL) BAL --dong tam vi truy van ngay cu  , chya live dong nay
											FROM 	DP1.TBDP_DMDMST , DP1.TBDP_DPTP , DP1.TBDP_IDXACCT , GL1.tbgl_baldd a,
											(
												SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
												FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
												WHERE A.BRCD = '1000'
												AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
												AND A.BRCD=B.BRCD
												AND B.TRDT <A.HLDY
												AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
												GROUP BY A.BRCD, A.HLDY
												UNION ALL
												SELECT A.BRCD, A.TRDT HLDY,A.TRDT
												FROM GL1.TBGL_STATUS A
												WHERE A.BRCD = '1000'
												AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
											) B
											WHERE TBDP_DMDMST.BRCD = '1000'
											AND TBDP_DMDMST.OPNCNCLFLG = '0'
											AND ((TBDP_DMDMST.CLSFLG = '0'and TBDP_DMDMST.curbal > 0 ))
											--AND TBDP_DMDMST.INATVFLG = '0' --TUAN EM REM NGAY 20111109
											--AND TBDP_DMDMST.ABNDFLG = '0'  --TUAN EM REM NGAY 20111109
											AND TBDP_DMDMST.BRCD =TBDP_DPTP.BRCD
											AND TBDP_DMDMST.DPTPcd =TBDP_DPTP.DPTPCD
											AND TBDP_DMDMST.BRCD =TBDP_IDXACCT.BRCD
											AND TBDP_DMDMST.DPTPcd =TBDP_IDXACCT.DPTPCD
											AND TBDP_DMDMST.ACCTSEQ =TBDP_IDXACCT.ACCTSEQ
											AND TBDP_DMDMST.BRCD =a.BRCD
											AND TBDP_DMDMST.DPTPcd =a.trref
											AND TBDP_DMDMST.ACCTSEQ =a.trseq
											and TBDP_DPTP.dpac <>'469902'
											--and a.trdt> &h_predt and a.trdt<=&h_trdt
											AND A.BRCD=B.BRCD
											AND A.TRDT=B.TRDT

											GROUP BY A.BRCD,A.TRDT,B.HLDY,
												TBDP_DPTP.DPAC , TBDP_DMDMST.CCYCD
										)
										GROUP BY BRCD,TRDT,HLDY,CUSTSEQ, ACCTCD,CCY

									) A, GL1.TBGL_CACODB B
									WHERE A.BRCD=B.BRCD
									AND A.ACCTCD=B.ACCTCD
									GROUP BY A.BRCD,A.TRDT,B.ACCTCD,A.CCY,A.HLDY

								) A, GL1.TBGL_SBVCD D
								WHERE A.ACCTCD     = D.ACCTCD
								AND DECODE(A.CCY,'VND','1','GD1','3','GD2','3','GD3','3','GD4','3','2') = D.BCCYFG
								UNION ALL
								--DC 519200 CIF ADO CN-HO
								SELECT BRCD,TRDT,CCY, HLDY, 'DC5192' ACCTCD1,'DC5192' AS ACCTCD,DRBAL DCN,
										CRBAL DCC
								FROM
								(
									SELECT A.BRCD,A.TRDT,A.HLDY,
																			B.ACCTCD AS ACCTCD,
																			A.CCY AS CCY,
														            		SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, -A.BAL, 0),
																												DECODE(SIGN(A.BAL), -1, 0, A.BAL))) AS DRBAL,
																			SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, 0, A.BAL),
																												DECODE(SIGN(A.BAL), -1, -A.BAL, 0))) AS CRBAL
									FROM
									(
										SELECT A.BRCD,A.TRDT,B.HLDY,
													A.ACCTCD , A.CCY, (A.TDBAL + A.TDACRBAL) AS BAL
										FROM 	GL1.TBGL_MAST A,
										(
											SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
											FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
											WHERE A.BRCD = '1000'
											AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
											AND A.BRCD=B.BRCD
											AND B.TRDT <A.HLDY
											AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
											GROUP BY A.BRCD, A.HLDY
											UNION ALL
											SELECT A.BRCD, A.TRDT HLDY,A.TRDT
											FROM GL1.TBGL_STATUS A
											WHERE A.BRCD = '1000'
											AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
										) B,TBGL_IBKMST C
										WHERE A.ACCTCD='519200'
										AND A.BRCD=B.BRCD
										AND A.TRDT=B.TRDT
										AND A.BRCD=C.BRCD
										AND A.CCY=C.CCY
										AND A.CUSTSEQ=C.CUSTSEQ
										AND C.TRREF='ADO'
									) A, GL1.TBGL_CACODB B
									WHERE A.BRCD=B.BRCD
									AND A.ACCTCD=B.ACCTCD
									GROUP BY A.BRCD,A.TRDT,B.ACCTCD,A.CCY,A.HLDY
								)
--									--THAO THEM 20120420 DU TRU BAT BUOC
--									UNION ALL
--									SELECT A.BRCD,B.TRDT,A.CCYCD,b.HLDY,--A.FRDT,A.TODT,
--												'TKDTBB' ACCTCD1,'TKDTBB' ACCTCD,
--												A.OBLRESAMT DCN--DTBB
--												,0 DCC
--									FROM
--									(
--										SELECT A.BRCD,A.CCYCD,
--												DECODE(SIGN(A.APPLDT-&h_predt),-1,&h_predt,A.APPLDT) FRDT,
--												NVL(B.APPLDT-1,&h_trdt) TODT,
--												A.OBLRESAMT
--										FROM
--										(
--											SELECT ROWNUM+1 STT, A.BRCD,A.CCYCD,A.APPLDT, A.OBLRESAMT
--											FROM
--											(
--												SELECT A.BRCD,A.CCYCD,
--														A.APPLDT,
--														A.OBLRESAMT
--												FROM CS1.TBCS_OBLRESLMT A,
--												(
--													SELECT B.BRCD,B.CCYCD,MAX(B.APPLDT) APPLDT
--													FROM CS1.TBCS_OBLRESLMT B
--													WHERE B.APPLDT <= &h_predt
--													AND B.BRCD='1000'
--													GROUP BY B.BRCD,B.CCYCD
--												) B
--												WHERE A.BRCD=B.BRCD
--												AND A.CCYCD=B.CCYCD
--												AND A.APPLDT BETWEEN B.APPLDT AND &h_trdt
--									            ORDER BY A.BRCD,A.CCYCD,A.APPLDT
--									        )  A
--									   ) A,
--									   (
--									        SELECT ROWNUM STT, A.BRCD,A.CCYCD,A.APPLDT, A.OBLRESAMT
--											FROM
--											(
--												SELECT A.BRCD,A.CCYCD,
--														A.APPLDT,
--														A.OBLRESAMT
--												FROM CS1.TBCS_OBLRESLMT A,
--												(
--													SELECT B.BRCD,B.CCYCD,MAX(B.APPLDT) APPLDT
--													FROM CS1.TBCS_OBLRESLMT B
--													WHERE B.APPLDT <= &h_predt
--													AND B.BRCD='1000'
--													GROUP BY B.BRCD,B.CCYCD
--												) B
--												WHERE A.BRCD=B.BRCD
--												AND A.CCYCD=B.CCYCD
--												AND A.APPLDT BETWEEN B.APPLDT AND &h_trdt
--									            ORDER BY A.BRCD,A.CCYCD,A.APPLDT
--									        ) A
--									   ) B
--									   WHERE A.BRCD=B.BRCD(+)
--									   AND A.CCYCD=B.CCYCD(+)
--									   AND A.STT=B.STT(+)
--									) A,
--									(
--									 	SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
--										FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
--										WHERE A.BRCD = '1000'
--										AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
--										AND A.BRCD=B.BRCD
--										AND B.TRDT <A.HLDY
--										AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
--										GROUP BY A.BRCD, A.HLDY
--										UNION ALL
--										SELECT A.BRCD, A.TRDT HLDY,A.TRDT
--										FROM GL1.TBGL_STATUS A
--										WHERE A.BRCD = '1000'
--										AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
--									) B
--									WHERE A.BRCD = B.BRCD
--									AND B.TRDT BETWEEN A.FRDT AND A.TODT
--									--AND A.CCYCD='USD'
--									--ORDER BY A.BRCD,A.CCYCD,B.TRDT
							) B
							WHERE
							trim(A.RPTCD)= 'FTP0'
							AND A.FLG='2'
							--AND TRIM(A.ACCTFOUR) = SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR)))
							AND TRIM(A.ACCTFOUR) = DECODE(SIGN(4-LENGTH(TRIM(A.ACCTFOUR))),-1,SUBSTR(B.ACCTCD1,1,LENGTH(TRIM(A.ACCTFOUR))),SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR))))
							AND NVL(TRIM(A.EXCEPT),'0') <> DECODE(NVL(TRIM(A.EXCEPT),'0'),'0','1',DECODE(SIGN(LENGTH(TRIM(A.EXCEPT))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.EXCEPT)))))
							AND trim(A.LEVEL2) = trim(C.FTPCD)
							GROUP BY B.BRCD,B.TRDT,B.HLDY,B.CCY,A.CONDITION,C.TENMUC,
								A.ACCTFOUR, A.LEVEL2,A.CONDITION, A.EXCEPT,
								C.FTPCD,C.BSIRKND, C.BSRTCD
	--						ORDER BY B.BRCD,B.TRDT,B.HLDY,B.CCY,A.CONDITION,C.TENMUC,
	--							A.ACCTFOUR, A.LEVEL2,A.CONDITION, A.EXCEPT,
	--							C.FTPCD,C.BSIRKND, C.BSRTCD
						) A
						WHERE DCN<>0 OR DCC<>0
						GROUP BY A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD
						--TRU DU NO CHO VAY THE
						UNION ALL
						SELECT A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD,
									--A.ACCTFOUR, A.LEVEL2 FPTCD, A.EXCEPT,
									--0 DUCUOI
									-SUM(A.DUNO) AS DUCUOI
									, 0 DUCUOI1 --THAO THEM 20120420
						FROM
						--THAO DIEU CHINH 20111227
						(
							SELECT 	B.BRCD, A.TRDT,A.HLDY,B.CCY,
								C.FTPCD,
								C.BSIRKND, C.BSRTCD,
								C.TENMUC,
							 	SUM(B.AMT) DUNO
							FROM
							(
								SELECT CODE FTPCD, STATCODE BSIRKND, STATDECODE BSRTCD, DECODE TENMUC
								FROM RACE.T_CODE
								WHERE CAT_NAME = 'GLFTP0'
								AND CODE='A00700'
							) C,
							(
								SELECT ACRFMDT HLDY, BRCD, CCY, SUM(ACRBAMT) AMT
								FROM GL1.TBGL_FTPDD
								WHERE BRCD = '1000'
								AND ACRFMDT> &h_predt AND ACRFMDT<=&h_trdt
								AND BUSCD='EI'
								AND trim(TRSEQ)='A00700'
								GROUP BY ACRFMDT, BRCD, CCY
							) B,
							(
								SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
								FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
								WHERE A.BRCD = '1000'
								AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
								AND A.BRCD=B.BRCD
								AND B.TRDT <A.HLDY
								AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
								GROUP BY A.BRCD, A.HLDY
								UNION ALL
								SELECT A.BRCD, A.TRDT HLDY,A.TRDT
								FROM GL1.TBGL_STATUS A
								WHERE A.BRCD = '1000'
								AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
							) A
							WHERE A.BRCD=B.BRCD
							AND A.HLDY=B.HLDY
							GROUP BY B.BRCD, A.TRDT,A.HLDY,B.CCY,
								C.FTPCD,
								C.BSIRKND, C.BSRTCD,
								C.TENMUC
						) A

						GROUP BY A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD
						--CA NHAN DOANH NGHIEP
						union ALL
						SELECT A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD,--A.CUSTTP,
									--A.ACCTFOUR, A.LEVEL2 FPTCD, A.EXCEPT,
									SUM(DECODE(A.CONDITION,	'DN'	, A.DCN,
														'-DN'	, -A.DCN,
														'DC'	, A.DCC,
														'-DC'	, -A.DCC,
														'DN-DC' , A.DCN-A.DCC,
														'DC-DN'	, A.DCC-A.DCN,
														'CLDN'	, DECODE(SIGN(A.DCN-A.DCC),-1,0,A.DCN-A.DCC),
														'-CLDN'	, -DECODE(SIGN(A.DCN-A.DCC),-1,0,A.DCN-A.DCC),
														'CLDC'	, DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN),
														'-CLDC'	, -DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN))) AS DUCUOI
                                     , 0 DUCUOI1 --THAO THEM 20120420
						FROM
						(
							SELECT 	B.BRCD,B.TRDT,B.HLDY,B.CCY,
								A.ACCTFOUR,
								A.LEVEL2, A.CONDITION, A.EXCEPT,
								C.FTPCD,
								C.BSIRKND, C.BSRTCD,
								C.TENMUC,B.CUSTTP,
							 	SUM(B.DCN) DCN, SUM(B.DCC) DCC
							FROM GL1.TBGL_RPTAC_NEW A,
							(
								SELECT CODE FTPCD, STATCODE BSIRKND, STATDECODE BSRTCD, DECODE TENMUC
								FROM RACE.T_CODE
								WHERE CAT_NAME = 'GLFTP0'
								AND CODE IN ('B00301','B00302')
							) C,
							(
								SELECT A.BRCD,A.TRDT,A.CCY,A.HLDY,
										A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,
										CUSTTP,
										DRBAL DCN,
										CRBAL DCC
								FROM
								(
									SELECT A.BRCD,A.TRDT,A.HLDY,
											B.ACCTCD AS ACCTCD,
											A.CCY AS CCY,
											A.CUSTTP,
						            		SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, -A.BAL, 0),
																				DECODE(SIGN(A.BAL), -1, 0, A.BAL))) AS DRBAL,
											SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, 0, A.BAL),
																					DECODE(SIGN(A.BAL), -1, -A.BAL, 0))) AS CRBAL
									FROM
									(
									   	SELECT BRCD,TRDT,HLDY,CUSTSEQ, ACCTCD,CCY,CUSTTP, SUM(BAL) BAL
									   	FROM
									   	(
									   		SELECT  A.BRCD,A.TRDT,B.HLDY,'000000000' CUSTSEQ,
														A.ACCTCD , A.CCY,
														DECODE(C.CUSTTPCD,'100','CANHAN','DNGHIEP') CUSTTP,
														SUM(A.TDBAL + A.TDACRBAL) AS BAL
											FROM  GL1.TBGL_MAST A,
											(
												SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
												FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
												WHERE A.BRCD = '1000'
												AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
												AND A.BRCD=B.BRCD
												AND B.TRDT <A.HLDY
												AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
												GROUP BY A.BRCD, A.HLDY
												UNION ALL
												SELECT A.BRCD, A.TRDT HLDY,A.TRDT
												FROM GL1.TBGL_STATUS A
												WHERE A.BRCD = '1000'
												AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
											) B , CM1.TBCM_GENERAL C
											WHERE A.BRCD=B.BRCD
											AND A.TRDT=B.TRDT
											AND ACCTCD  NOT IN ( SELECT DISTINCT ACCTCD
																			FROM GL1.TBGL_SBVCD
																			WHERE SUBSTR(SBVCD,1,2) IN ('47','48','50','51','56')
																			)
											-- thao them 20111116
											AND ACCTCD  IN ( SELECT DISTINCT ACCTCD
																			FROM GL1.TBGL_SBVCD
																			WHERE SUBSTR(SBVCD,1,2) IN ('42')
																			)
											-- end

											AND A.CUSTSEQ =C.CUSTSEQ
											AND C.BRCD='1000'
											--AND C.CUSTTPCD='100'
						   					GROUP BY  A.BRCD,A.TRDT,B.HLDY,
													A.ACCTCD , A.CCY,DECODE(C.CUSTTPCD,'100','CANHAN','DNGHIEP')
											-- THAO REM 20111116 VI KO CAN CAC TK NAY KHI NAO CO THI THEM VAO

											-- END THAO REM 20111116 VI KO CAN CAC TK NAY KHI NAO CO THI THEM VAO
		--									--loai tru so lieu cua DP Thao them ngay 20110307
											union ALL
											SELECT A.BRCD,A.TRDT,B.HLDY,'000000000' CUSTSEQ,
												TBDP_DPTP.DPAC ACCTCD , TBDP_DMDMST.CCYCD CCY,
												DECODE(C.CUSTTPCD,'100','CANHAN','DNGHIEP') CUSTTP,
												--- SUM(clRBAL) BAL --test so ngay cu thi lay dong nay
												- SUM(CURBAL) BAL --dong tam vi truy van ngay cu  , chya live dong nay
											FROM 	DP1.TBDP_DMDMST , DP1.TBDP_DPTP , DP1.TBDP_IDXACCT , GL1.tbgl_baldd a,
											(
												SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
												FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
												WHERE A.BRCD = '1000'
												AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
												AND A.BRCD=B.BRCD
												AND B.TRDT <A.HLDY
												AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
												GROUP BY A.BRCD, A.HLDY
												UNION ALL
												SELECT A.BRCD, A.TRDT HLDY,A.TRDT
												FROM GL1.TBGL_STATUS A
												WHERE A.BRCD = '1000'
												AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
											) B , CM1.TBCM_GENERAL C
											WHERE TBDP_DMDMST.BRCD = '1000'
											AND TBDP_DMDMST.OPNCNCLFLG = '0'
											AND ((TBDP_DMDMST.CLSFLG = '0'and TBDP_DMDMST.curbal > 0 ))
											--AND TBDP_DMDMST.INATVFLG = '0'
											--AND TBDP_DMDMST.ABNDFLG = '0'
											AND TBDP_DMDMST.BRCD =TBDP_DPTP.BRCD
											AND TBDP_DMDMST.DPTPcd =TBDP_DPTP.DPTPCD
											AND TBDP_DMDMST.BRCD =TBDP_IDXACCT.BRCD
											AND TBDP_DMDMST.DPTPcd =TBDP_IDXACCT.DPTPCD
											AND TBDP_DMDMST.ACCTSEQ =TBDP_IDXACCT.ACCTSEQ
											AND TBDP_DMDMST.BRCD =a.BRCD
											AND TBDP_DMDMST.DPTPcd =a.trref
											AND TBDP_DMDMST.ACCTSEQ =a.trseq
											and TBDP_DPTP.dpac <>'469902'
											--and a.trdt> &h_predt and a.trdt<=&h_trdt
											AND TBDP_DMDMST.CUSTSEQ =C.CUSTSEQ
											AND C.BRCD='1000'
											--AND C.CUSTTPCD='100'
											AND A.BRCD=B.BRCD
											AND A.TRDT=B.TRDT

											GROUP BY A.BRCD,A.TRDT,B.HLDY,
												TBDP_DPTP.DPAC , TBDP_DMDMST.CCYCD ,
												DECODE(C.CUSTTPCD,'100','CANHAN','DNGHIEP')
		--END 20110307
										)
										GROUP BY BRCD,TRDT,HLDY,CUSTSEQ, ACCTCD,CCY,CUSTTP

									) A, GL1.TBGL_CACODB B
									WHERE A.BRCD=B.BRCD
									AND A.ACCTCD=B.ACCTCD
									GROUP BY A.BRCD,A.TRDT,B.ACCTCD,A.CCY,A.HLDY, A.CUSTTP

								) A, GL1.TBGL_SBVCD D
								WHERE A.ACCTCD     = D.ACCTCD
								AND DECODE(A.CCY,'VND','1','GD1','3','GD2','3','GD3','3','GD4','3','2') = D.BCCYFG
							) B
							WHERE
							trim(A.RPTCD)= 'FTP0'
							AND A.FLG='2'
							--AND TRIM(A.ACCTFOUR) = SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR)))
							AND TRIM(A.ACCTFOUR) = DECODE(SIGN(4-LENGTH(TRIM(A.ACCTFOUR))),-1,SUBSTR(B.ACCTCD1,1,LENGTH(TRIM(A.ACCTFOUR))),SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR))))
							AND NVL(TRIM(A.EXCEPT),'0') <> DECODE(NVL(TRIM(A.EXCEPT),'0'),'0','1',DECODE(SIGN(LENGTH(TRIM(A.EXCEPT))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.EXCEPT)))))
							AND trim(A.LEVEL2) = trim(C.FTPCD)
							AND DECODE(B.CUSTTP,'CANHAN','01','02')=SUBSTR(C.FTPCD,5,2)
							--AND trim(A.LEVEL2) IN ('B00301','B00302')
							GROUP BY B.BRCD,B.TRDT,B.HLDY,B.CCY,A.CONDITION,C.TENMUC,
								A.ACCTFOUR, A.LEVEL2,A.CONDITION, A.EXCEPT,
								C.FTPCD,C.BSIRKND, C.BSRTCD,B.CUSTTP
	--						ORDER BY B.BRCD,B.TRDT,B.HLDY,B.CCY,A.CONDITION,C.TENMUC,
	--							A.ACCTFOUR, A.LEVEL2,A.CONDITION, A.EXCEPT,
	--							C.FTPCD,C.BSIRKND, C.BSRTCD,B.CUSTTP
						) A
						WHERE DCN<>0 OR DCC<>0
						GROUP BY A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD--,A.CUSTTP
						--THAO THEM 20120420 & HAN MUC TON QUY TOI THIEU TREN VON HUY DONG CHO KHOAN MUC TIEN MAT
						UNION ALL
						SELECT A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD,
									0 AS DUCUOI,
									SUM(A.DUNO) DUCUOI1
						FROM
						(
							SELECT 	B.BRCD, B.TRDT,B.HLDY,B.CCY,
								C.FTPCD,
								C.BSIRKND, C.BSRTCD,
								C.TENMUC,
							 	(B.C_TOITHIEU) DUNO
							FROM
							(
								SELECT CODE FTPCD, STATCODE BSIRKND, STATDECODE BSRTCD, DECODE TENMUC
								FROM RACE.T_CODE
								WHERE CAT_NAME = 'GLFTP0'
								AND CODE='A00100'
							) C,
							(
								--VND TOI THIEU
								SELECT BRCD,TRDT,HLDY,CCY,ROUND(DECODE(SIGN(VHD_TMP-1000000000),-1,1000000000,VHD_TMP),0) C_TOITHIEU
								FROM
								(
									SELECT A.BRCD,D.TRDT,D.HLDY,A.CCY,SUM(A.TDBAL) VHD,SUM(A.TDBAL)*0.5/100 VHD_TMP
									FROM GL1.TBGL_MAST A, GL1.TBGL_SBVCD B,
									(
										SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
										FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
										WHERE A.BRCD = '1000'
										AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
										AND A.BRCD=B.BRCD
										AND B.TRDT <A.HLDY
										AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
										GROUP BY A.BRCD, A.HLDY
										UNION ALL
										SELECT A.BRCD, A.TRDT HLDY,A.TRDT
										FROM GL1.TBGL_STATUS A
										WHERE A.BRCD = '1000'
										AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
									) D
									WHERE A.BRCD=D.brcd
									AND A.TRDT = D.TRDT
									AND A.CCY='VND'
									AND A.ACCTCD=B.ACCTCD
									AND DECODE(A.CCY,'VND','1',DECODE(SUBSTR(A.CCY,1,2),'GD','3','2'))=B.BCCYFG
									AND (SUBSTR(B.SBVCD,1,2) IN ('42','43') OR B.SBVCD='4521')
									GROUP BY A.BRCD,D.TRDT,D.HLDY,A.CCY
								)
								--NGOAI TE KHAC USD  TOI THIEU
								UNION ALL
								SELECT BRCD,TRDT,HLDY,CCY,DECODE(CCY,'JPY',ROUND(VHD,0),ROUND(VHD,2)) C_TOITHIEU
								FROM
								(
									SELECT BRCD,TRDT,HLDY,CCY,MAX(VHD) VHD
									FROM
									(
										--3% VHD CA NHAN
										SELECT A.BRCD,D.TRDT,D.HLDY,A.CCY,SUM(A.TDBAL)*3/100 VHD
										FROM GL1.TBGL_MAST A, GL1.TBGL_SBVCD B, CM1.TBCM_GENERAL C,
										(
											SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
											FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
											WHERE A.BRCD = '1000'
											AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
											AND A.BRCD=B.BRCD
											AND B.TRDT <A.HLDY
											AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
											GROUP BY A.BRCD, A.HLDY
											UNION ALL
											SELECT A.BRCD, A.TRDT HLDY,A.TRDT
											FROM GL1.TBGL_STATUS A
											WHERE A.BRCD = '1000'
											AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
										) D
										WHERE A.BRCD=D.BRCD
										AND A.TRDT = D.TRDT
										AND A.CCY NOT IN ('USD','VND','GD1','GD2','GD3','GD4')
										AND A.ACCTCD=B.ACCTCD
										AND DECODE(A.CCY,'VND','1',DECODE(SUBSTR(A.CCY,1,2),'GD','3','2'))=B.BCCYFG
										AND (SUBSTR(B.SBVCD,1,2) IN ('42','43') OR B.SBVCD='4521')
										AND C.BRCD='1000'
										AND C.CUSTTPCD in ('100')
										AND A.CUSTSEQ=C.CUSTSEQ
										GROUP BY A.BRCD,D.TRDT,D.HLDY,A.CCY
										--50% CAM CO
										UNION ALL
										SELECT A.BRCD,D.TRDT,D.HLDY,A.CCY,SUM(A.TDBAL)*50/100 VHD
										FROM GL1.TBGL_MAST A,
										(
											SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
											FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
											WHERE A.BRCD = '1000'
											AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
											AND A.BRCD=B.BRCD
											AND B.TRDT <A.HLDY
											AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
											GROUP BY A.BRCD, A.HLDY
											UNION ALL
											SELECT A.BRCD, A.TRDT HLDY,A.TRDT
											FROM GL1.TBGL_STATUS A
											WHERE A.BRCD = '1000'
											AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
										) D
										WHERE A.BRCD=D.BRCD
										AND A.TRDT= D.TRDT
										AND A.CCY NOT IN ('USD','VND','GD1','GD2','GD3','GD4')
										AND A.ACCTCD='996007'
										GROUP BY A.BRCD,D.TRDT,D.HLDY,A.CCY
									)
									GROUP BY BRCD,TRDT,HLDY,CCY
								)
								--USD  TOI THIEU
								UNION ALL
								SELECT BRCD,TRDT,HLDY,CCY,ROUND(DECODE(SIGN(C - 10000),1,C,10000),2) C_TOITHIEU
								FROM
								(
									SELECT BRCD,TRDT,HLDY,CCY,
											DECODE(SIGN(VHD-50000000),1, (20000000*1.5/100) + (30000000*1/100) +  ((VHD-50000000)*0.5/100),
																		DECODE(SIGN(VHD-20000000),1,(20000000*1.5/100) + ((VHD-20000000)*1/100),(VHD*1.5/100)))	 C
									FROM
									(
										SELECT A.BRCD,D.TRDT,D.HLDY,A.CCY,SUM(A.TDBAL) VHD
										FROM GL1.TBGL_MAST A, GL1.TBGL_SBVCD B, CM1.TBCM_GENERAL C,
										(
											SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
											FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
											WHERE A.BRCD = '1000'
											AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
											AND A.BRCD=B.BRCD
											AND B.TRDT <A.HLDY
											AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
											GROUP BY A.BRCD, A.HLDY
											UNION ALL
											SELECT A.BRCD, A.TRDT HLDY,A.TRDT
											FROM GL1.TBGL_STATUS A
											WHERE A.BRCD = '1000'
											AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
										) D
										WHERE A.BRCD=D.BRCD
										AND A.TRDT = D.TRDT
										AND A.CCY='USD'
										AND A.ACCTCD=B.ACCTCD
										AND DECODE(A.CCY,'VND','1',DECODE(SUBSTR(A.CCY,1,2),'GD','3','2'))=B.BCCYFG
										AND (SUBSTR(B.SBVCD,1,2) IN ('42','43') OR B.SBVCD='4521')
										AND C.BRCD='1000'
										AND C.CUSTTPCD in ('100')
										AND A.CUSTSEQ=C.CUSTSEQ
										GROUP BY A.BRCD,D.TRDT,D.HLDY,A.CCY
									)
								)
								--VANG GD1 TOI THIEU
								UNION ALL
								SELECT BRCD,TRDT,HLDY,CCY,ROUND(VHD,2) C_TOITHIEU
								FROM
								(
									SELECT BRCD,TRDT,HLDY,CCY,MAX(VHD) VHD
									FROM
									(
										--5% VHD
										SELECT A.BRCD,D.TRDT,D.HLDY,A.CCY, SUM(A.TDBAL)*5/100 VHD
										FROM GL1.TBGL_MAST A, GL1.TBGL_SBVCD B,
										(
											SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
											FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
											WHERE A.BRCD = '1000'
											AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
											AND A.BRCD=B.BRCD
											AND B.TRDT <A.HLDY
											AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
											GROUP BY A.BRCD, A.HLDY
											UNION ALL
											SELECT A.BRCD, A.TRDT HLDY,A.TRDT
											FROM GL1.TBGL_STATUS A
											WHERE A.BRCD = '1000'
											AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
										) D
										WHERE A.BRCD=D.BRCD
										AND A.TRDT = D.TRDT
										AND A.CCY LIKE 'GD%'
										AND A.ACCTCD=B.ACCTCD
										AND DECODE(A.CCY,'VND','1',DECODE(SUBSTR(A.CCY,1,2),'GD','3','2'))=B.BCCYFG
										AND (SUBSTR(B.SBVCD,1,2) IN ('42','43') OR B.SBVCD='4521')
										GROUP BY A.BRCD,D.TRDT,D.HLDY,A.CCY
										--30% CAM CO VANG
										UNION ALL
										SELECT A.BRCD,D.TRDT,D.HLDY,A.CCY,SUM(A.TDBAL)*30/100 VHD
										FROM GL1.TBGL_MAST A,
										(
											SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
											FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
											WHERE A.BRCD = '1000'
											AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
											AND A.BRCD=B.BRCD
											AND B.TRDT <A.HLDY
											AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
											GROUP BY A.BRCD, A.HLDY
											UNION ALL
											SELECT A.BRCD, A.TRDT HLDY,A.TRDT
											FROM GL1.TBGL_STATUS A
											WHERE A.BRCD = '1000'
											AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
										) D
										WHERE A.BRCD=D.BRCD
										AND A.TRDT= D.TRDT
										AND A.CCY LIKE 'GD%'
										AND A.ACCTCD='996007'
										GROUP BY A.BRCD,D.TRDT,D.HLDY,A.CCY
									)
									GROUP BY BRCD,TRDT,HLDY,CCY
								)
						     ) B
						) A
						GROUP BY A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD
						--THAO THEM 20120508
						UNION ALL
						SELECT A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD,
									0 AS DUCUOI,
									SUM(A.DUNO) DUCUOI1
						FROM
						(
							SELECT 	B.BRCD, B.TRDT,B.HLDY,B.CCY,
								C.FTPCD,
								C.BSIRKND, C.BSRTCD,
								C.TENMUC,
							 	(B.DTBB) DUNO
							FROM
							(
								SELECT CODE FTPCD, STATCODE BSIRKND, STATDECODE BSRTCD, DECODE TENMUC
								FROM RACE.T_CODE
								WHERE CAT_NAME = 'GLFTP0'
								AND CODE IN ('A00220','A00250')
							) C,
							(
								--DU TRU BAT BUOC

								SELECT A.BRCD,B.TRDT,b.HLDY,A.CCYCD CCY,--A.FRDT,A.TODT,
											A.OBLRESAMT DTBB
								FROM
								(
									SELECT A.BRCD,A.CCYCD,
											DECODE(SIGN(A.APPLDT-&h_predt),-1,&h_predt,A.APPLDT) FRDT,
											NVL(B.APPLDT-1,&h_trdt) TODT,
											A.OBLRESAMT
									FROM
									(
										SELECT ROWNUM+1 STT, A.BRCD,A.CCYCD,A.APPLDT, A.OBLRESAMT
										FROM
										(
											SELECT A.BRCD,A.CCYCD,
													A.APPLDT,
													A.OBLRESAMT
											FROM CS1.TBCS_OBLRESLMT A,
											(
												SELECT B.BRCD,B.CCYCD,MAX(B.APPLDT) APPLDT
												FROM CS1.TBCS_OBLRESLMT B
												WHERE B.APPLDT <= &h_predt
												AND B.BRCD='1000'
												GROUP BY B.BRCD,B.CCYCD
											) B
											WHERE A.BRCD=B.BRCD
											AND A.CCYCD=B.CCYCD
											AND A.APPLDT BETWEEN B.APPLDT AND &h_trdt
								            ORDER BY A.BRCD,A.CCYCD,A.APPLDT
								        )  A
								   ) A,
								   (
								        SELECT ROWNUM STT, A.BRCD,A.CCYCD,A.APPLDT, A.OBLRESAMT
										FROM
										(
											SELECT A.BRCD,A.CCYCD,
													A.APPLDT,
													A.OBLRESAMT
											FROM CS1.TBCS_OBLRESLMT A,
											(
												SELECT B.BRCD,B.CCYCD,MAX(B.APPLDT) APPLDT
												FROM CS1.TBCS_OBLRESLMT B
												WHERE B.APPLDT <= &h_predt
												AND B.BRCD='1000'
												GROUP BY B.BRCD,B.CCYCD
											) B
											WHERE A.BRCD=B.BRCD
											AND A.CCYCD=B.CCYCD
											AND A.APPLDT BETWEEN B.APPLDT AND &h_trdt
								            ORDER BY A.BRCD,A.CCYCD,A.APPLDT
								        ) A
								   ) B
								   WHERE A.BRCD=B.BRCD(+)
								   AND A.CCYCD=B.CCYCD(+)
								   AND A.STT=B.STT(+)
								) A,
								(
								 	SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
									FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
									WHERE A.BRCD = '1000'
									AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
									AND A.BRCD=B.BRCD
									AND B.TRDT <A.HLDY
									AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
									GROUP BY A.BRCD, A.HLDY
									UNION ALL
									SELECT A.BRCD, A.TRDT HLDY,A.TRDT
									FROM GL1.TBGL_STATUS A
									WHERE A.BRCD = '1000'
									AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
								) B
								WHERE A.BRCD = B.BRCD
								AND B.TRDT BETWEEN A.FRDT AND A.TODT

						     ) B
						)  A
						GROUP BY A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD
						--END 20120508
					)
					GROUP BY BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD
				)
				WHERE DUCUOI<>0 OR DUCUOI1<>0
			)
			UNION ALL
			--START TTDTRAM ADD 20120210
			--Theo yeu cau 20120209 cua P.KTTH& Chinh lai suat FP 0% cho 1201_375000_104196569
			SELECT	BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD,DUCUOI,LAISUAT,DECODE(CCY,'JPY',round(LAI,0),'VND',round(LAI,0),round(LAI,2)) LAI,
					CS1.excrosscal(BRCD, 'VND',  TRDT, CCY, DECODE(CCY,'JPY',round(LAI,0),'VND',round(LAI,0),round(LAI,2)), '01', 'VND', '01') LAIQUIDOI
			FROM
			(
				SELECT BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD,	ABS(DUCUOI) DUCUOI,0 LAISUAT,0 LAI
				FROM
				(
					SELECT BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD,SUM(DUCUOI) DUCUOI
					FROM
					(
						SELECT A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD,
									--A.ACCTFOUR, A.LEVEL2 FPTCD, A.EXCEPT,
									SUM(DECODE(A.CONDITION,	'DN'	, A.DCN,
														'-DN'	, -A.DCN,
														'DC'	, A.DCC,
														'-DC'	, -A.DCC,
														'DN-DC' , A.DCN-A.DCC,
														'DC-DN'	, A.DCC-A.DCN,
														'CLDN'	, DECODE(SIGN(A.DCN-A.DCC),-1,0,A.DCN-A.DCC),
														'-CLDN'	, -DECODE(SIGN(A.DCN-A.DCC),-1,0,A.DCN-A.DCC),
														'CLDC'	, DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN),
														'-CLDC'	, -DECODE(SIGN(A.DCC-A.DCN),-1,0,A.DCC-A.DCN))) AS DUCUOI

						FROM
						(
							SELECT 	B.BRCD,B.TRDT,B.HLDY,B.CCY,
								A.ACCTFOUR,
								A.LEVEL2, A.CONDITION, A.EXCEPT,
								C.FTPCD,
								C.BSIRKND, C.BSRTCD,
								C.TENMUC,
							 	SUM(B.DCN) DCN, SUM(B.DCC) DCC
							FROM GL1.TBGL_RPTAC_NEW A,
							(
								SELECT CODE FTPCD, STATCODE BSIRKND, STATDECODE BSRTCD, DECODE TENMUC
								FROM RACE.T_CODE
								WHERE CAT_NAME = 'GLFTP0'
								AND CODE IN ('A01500')
							) C,
							(
								SELECT A.BRCD,A.TRDT,A.CCY,A.HLDY,
										A.ACCTCD ACCTCD1,D.SBVCD ACCTCD,
										DRBAL DCN,
										CRBAL DCC
								FROM
								(
									SELECT A.BRCD,A.TRDT,A.HLDY,
											B.ACCTCD AS ACCTCD,
											A.CCY AS CCY,
						            		SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, -A.BAL, 0),
																				DECODE(SIGN(A.BAL), -1, 0, A.BAL))) AS DRBAL,
											SUM(DECODE(B.ACBLDRCR, 'C', DECODE(SIGN(A.BAL), -1, 0, A.BAL),
																					DECODE(SIGN(A.BAL), -1, -A.BAL, 0))) AS CRBAL
									FROM
									(
									   	SELECT BRCD,TRDT,HLDY,CUSTSEQ, ACCTCD,CCY,SUM(BAL) BAL
									   	FROM
									   	(
									   		SELECT  A.BRCD,A.TRDT,B.HLDY,'000000000' CUSTSEQ,
														A.ACCTCD , A.CCY,
														SUM(A.TDBAL + A.TDACRBAL) AS BAL
											FROM  GL1.TBGL_MAST A,
											(
												SELECT A.BRCD, A.HLDY, max(B.TRDT) trdt
												FROM CS1.TBCS_BRHLDY A, GL1.TBGL_STATUS B
												WHERE A.BRCD = '1000'
												AND A.HLDY > &h_predt AND A.HLDY<=&h_trdt
												AND A.BRCD=B.BRCD
												AND B.TRDT <A.HLDY
												AND B.TRDT>TO_CHAR(TO_DATE(A.HLDY,'YYYYMMDD')-20,'YYYYMMDD')
												GROUP BY A.BRCD, A.HLDY
												UNION ALL
												SELECT A.BRCD, A.TRDT HLDY,A.TRDT
												FROM GL1.TBGL_STATUS A
												WHERE A.BRCD = '1000'
												AND A.TRDT > &h_predt AND A.TRDT<=&h_trdt
											) B
											WHERE A.BRCD=B.BRCD
											AND A.TRDT=B.TRDT
											AND A.BRCD='1201'
											AND A.ACCTCD='375000'
											AND A.CUSTSEQ ='104196569'
						   					GROUP BY  A.BRCD,A.TRDT,B.HLDY,
													A.ACCTCD , A.CCY
		--									--loai tru so lieu cua DP Thao them ngay 20110307

										)
										GROUP BY BRCD,TRDT,HLDY,CUSTSEQ, ACCTCD,CCY

									) A, GL1.TBGL_CACODB B
									WHERE A.BRCD=B.BRCD
									AND A.ACCTCD=B.ACCTCD
									GROUP BY A.BRCD,A.TRDT,B.ACCTCD,A.CCY,A.HLDY

								) A, GL1.TBGL_SBVCD D
								WHERE A.ACCTCD     = D.ACCTCD
								AND DECODE(A.CCY,'VND','1','GD1','3','GD2','3','GD3','3','GD4','3','2') = D.BCCYFG

							) B
							WHERE
							trim(A.RPTCD)= 'FTP0'
							AND A.FLG='2'
							--AND TRIM(A.ACCTFOUR) = SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR)))
							AND TRIM(A.ACCTFOUR) = DECODE(SIGN(4-LENGTH(TRIM(A.ACCTFOUR))),-1,SUBSTR(B.ACCTCD1,1,LENGTH(TRIM(A.ACCTFOUR))),SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.ACCTFOUR))))
							AND NVL(TRIM(A.EXCEPT),'0') <> DECODE(NVL(TRIM(A.EXCEPT),'0'),'0','1',DECODE(SIGN(LENGTH(TRIM(A.EXCEPT))-6),0,B.ACCTCD1,SUBSTR(B.ACCTCD,1,LENGTH(TRIM(A.EXCEPT)))))
							AND trim(A.LEVEL2) = trim(C.FTPCD)
							GROUP BY B.BRCD,B.TRDT,B.HLDY,B.CCY,A.CONDITION,C.TENMUC,
								A.ACCTFOUR, A.LEVEL2,A.CONDITION, A.EXCEPT,
								C.FTPCD,C.BSIRKND, C.BSRTCD
	--						ORDER BY B.BRCD,B.TRDT,B.HLDY,B.CCY,A.CONDITION,C.TENMUC,
	--							A.ACCTFOUR, A.LEVEL2,A.CONDITION, A.EXCEPT,
	--							C.FTPCD,C.BSIRKND, C.BSRTCD
						) A
						WHERE DCN<>0 OR DCC<>0
						GROUP BY A.BRCD,A.TRDT,A.HLDY,A.CCY,A.FTPCD,A.TENMUC,A.BSIRKND, A.BSRTCD
					)
					GROUP BY BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD
				)
				WHERE DUCUOI<>0
			)
			--END TTDTRAM ADD 20120210
			--Theo yeu cau 20120209 cua P.KTTH& Chinh lai suat FP 0% cho 1201_375000_104196569
		)
		GROUP BY BRCD,TRDT,HLDY,CCY,FTPCD,TENMUC,BSIRKND, BSRTCD
	) A
)
WHERE ACRAMT <> 0 OR BCEQA<>0 OR ACRBAMT<>0
ORDER BY TRSEQ, ACCTCD, CCY
