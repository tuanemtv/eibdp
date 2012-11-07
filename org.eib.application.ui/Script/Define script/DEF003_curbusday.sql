select 	curbusday h_trdt,
		decode (LN1.CHK_BRHLDY(brcd, to_char(TRUNC(to_date(curbusday, 'YYYYMMDD'),'MM'),'YYYYMMDD')), 'N',
				to_char(TRUNC(to_date(curbusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'),
				LN1.GET_BUSDAYCAL(brcd, to_char(TRUNC(to_date(curbusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'), 1, '1')) h_startdt,

		DECODE(LN1.CHK_BRHLDY(brcd, to_char(LAST_DAY(ADD_MONTHS(to_date(curbusday, 'YYYYMMDD'),-1)),'YYYYMMDD')), 'N',
				to_char(LAST_DAY(ADD_MONTHS(to_date(curbusday, 'YYYYMMDD'),-1)),'YYYYMMDD'),
				LN1.GET_BUSDAYCAL(brcd, to_char(LAST_DAY(ADD_MONTHS(to_date(curbusday, 'YYYYMMDD'),-1)),'YYYYMMDD'), -1, '1'))  h_enddt,

		DECODE(LN1.CHK_BRHLDY(brcd, to_char(TRUNC(to_date(curbusday, 'YYYYMMDD'),'MM'),'YYYYMMDD')), 'N',
					to_char(TRUNC(to_date(curbusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'),
					LN1.GET_BUSDAYCAL(brcd, to_char(TRUNC(to_date(curbusday, 'YYYYMMDD'),'MM'),'YYYYMMDD'), 1, '1')) h_bstartdt,
		LN1.GET_BUSDAYCAL(brcd, curbusday, -1, '1') h_predt
from tbcs_Brcd
where brcd ='1000'
