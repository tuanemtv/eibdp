
--h_trdt(Ngay query du lieu)
--h_startdt (Ngay dau thang)
--h_enddt (Ngay cuoi thang truoc)
--h_bstartdt(Ngay gdich dau thang nay)
--h_predt (Ngay giao dich truoc)

--DECODE(LN1.CHK_BRHLDY(brcd, FOM), 'N',
--		FOM,
--		LN1.GET_BUSDAYCAL(brcd, FOM, 1, '1')) FOM

select 	prebusday h_trdt,
		decode (LN1.CHK_BRHLDY(brcd, to_char(TRUNC(to_date(prebusday, 'YYYYMMDD'),'MM'),'YYYYMMDD')), 'N',
				to_char(TRUNC(to_date(prebusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'),
				LN1.GET_BUSDAYCAL(brcd, to_char(TRUNC(to_date(prebusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'), 1, '1')) h_startdt,

		DECODE(LN1.CHK_BRHLDY(brcd, to_char(LAST_DAY(ADD_MONTHS(to_date(prebusday, 'YYYYMMDD'),-1)),'YYYYMMDD')), 'N',
				to_char(LAST_DAY(ADD_MONTHS(to_date(prebusday, 'YYYYMMDD'),-1)),'YYYYMMDD'),
				LN1.GET_BUSDAYCAL(brcd, to_char(LAST_DAY(ADD_MONTHS(to_date(prebusday, 'YYYYMMDD'),-1)),'YYYYMMDD'), -1, '1'))  h_enddt,

		DECODE(LN1.CHK_BRHLDY(brcd, to_char(TRUNC(to_date(prebusday, 'YYYYMMDD'),'MM'),'YYYYMMDD')), 'N',
					to_char(TRUNC(to_date(prebusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'),
					LN1.GET_BUSDAYCAL(brcd, to_char(TRUNC(to_date(prebusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'), 1, '1')) h_bstartdt,
		LN1.GET_BUSDAYCAL(brcd, prebusday, -1, '1') h_predt
from tbcs_Brcd
where brcd ='1000'
