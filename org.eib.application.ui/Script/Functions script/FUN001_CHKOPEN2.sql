CREATE OR REPLACE FUNCTION DP1.CHKOPEN2 (ibrcd IN CHAR, idptpcd IN CHAR, iacctseq IN CHAR)
RETURN CHAR IS onReturn NUMBER(21,3);
	BEGIN
	   onReturn :=0.0;

		SELECT count(*)
				into
					  onReturn
		FROM tbdp_trlst
		WHERE BRCD = ibrcd
		AND DPTPCD  = idptpcd
		AND ACCTSEQ =  iacctseq
		and trcd ='W060'
		and husrid = brcd ||'DP'
		and FNDTPCD = '201';

	   RETURN onReturn;
	   EXCEPTION
	     WHEN NO_DATA_FOUND THEN
	         RETURN onReturn;
	     WHEN OTHERS THEN
	       -- Consider logging the error and then re-raise
	       RAISE;
END CHKOPEN2;
/
