package org.eib.common;


import java.security.MessageDigest;

public class PasswordSecurity {
	
	 private static MessageDigest digest = null;
	 private static boolean isInited = false;

	 private static final int  BASELENGTH         = 255;
	 private static final int  LOOKUPLENGTH       = 64;
	 private static final int  TWENTYFOURBITGROUP = 24;
	 private static final int  EIGHTBIT           = 8;
	 private static final int  SIXTEENBIT         = 16;
	 private static final int  SIGN               = -128;
	 private static final byte PAD                = (byte) '=';
	 private static byte [] base64Alphabet       = new byte[BASELENGTH];
	 private static byte [] lookUpBase64Alphabet = new byte[LOOKUPLENGTH];
	 
	 static
	    {
	        for (int i = 0; i < BASELENGTH; i++ )
	        {
	            base64Alphabet[i] = -1;
	        }
	        for (int i = 'Z'; i >= 'A'; i--)
	        {
	            base64Alphabet[i] = (byte) (i - 'A');
	        }
	        for (int i = 'z'; i>= 'a'; i--)
	        {
	            base64Alphabet[i] = (byte) (i - 'a' + 26);
	        }
	        for (int i = '9'; i >= '0'; i--)
	        {
	            base64Alphabet[i] = (byte) (i - '0' + 52);
	        }

	        base64Alphabet['+']  = 62;
	        base64Alphabet['/']  = 63;

	        for (int i = 0; i <= 25; i++ ) {
				lookUpBase64Alphabet[i] = (byte) ('A' + i);
			}

	        for (int i = 26,  j = 0; i <= 51; i++, j++ ) {
				lookUpBase64Alphabet[i] = (byte) ('a'+ j);
			}

	        for (int i = 52,  j = 0; i <= 61; i++, j++ ) {
				lookUpBase64Alphabet[i] = (byte) ('0' + j);
			}

	        lookUpBase64Alphabet[62] = (byte) '+';
	        lookUpBase64Alphabet[63] = (byte) '/';
	    }
	 
	 	/**
	     * This method return a String that has been encrypted as MD5 and then escaped using Base64.<p>
	     * This method should be used to encrypt all password for maximum security.
	     * @param input String the string that need encrypted
	     * @return String the string after encrypted
	     */	  
	    public static synchronized String ConvertPassword(final String input) {
	        // please note that we dont use digest, because if we
	        // cannot get digest, then the second time we have to call it
	        // again, which will fail again
	    	String retValue=null;
	    	if(input!=null){	    			    
	    		if (isInited == false) {
	                isInited = true;
	                try {
	                    digest = MessageDigest.getInstance("MD5");
	                } catch (Exception ex) {
	                    //log.fatal("Cannot get MessageDigest. Application may fail to run correctly.", ex);
	                }
	            }
	            if (digest == null) {
					return input;
				}

	            // now everything is ok, go ahead
	            try {
	                digest.update(input.getBytes("UTF-8"));
	            } catch (java.io.UnsupportedEncodingException ex) {
	                //log.error("Assertion: This should never occur.");
	            }
	            byte[] rawData = digest.digest();
	            byte[] encoded = encode(rawData);
	            retValue= new String(encoded);

	    	}        
	    	return retValue;
	    }

	    /**
	     * 
	     * @param binaryData
	     * @return
	     */	
	    public static byte[] encode( final byte[] binaryData )
	    {
	        int      lengthDataBits    = binaryData.length*EIGHTBIT;
	        int      fewerThan24bits   = lengthDataBits%TWENTYFOURBITGROUP;
	        int      numberTriplets    = lengthDataBits/TWENTYFOURBITGROUP;
	        byte[]     encodedData     = null;


	        if (fewerThan24bits != 0)
	        {
	            //data not divisible by 24 bit
	            encodedData = new byte[ (numberTriplets + 1 ) * 4 ];
	        }
	        else
	        {
	            // 16 or 8 bit
	            encodedData = new byte[ numberTriplets * 4 ];
	        }

	        byte k = 0, l = 0, b1 = 0, b2 = 0, b3 = 0;

	        int encodedIndex = 0;
	        int dataIndex   = 0;
	        int i           = 0;
	        for ( i = 0; i<numberTriplets; i++ )
	        {
	            dataIndex = i*3;
	            b1 = binaryData[dataIndex];
	            b2 = binaryData[dataIndex + 1];
	            b3 = binaryData[dataIndex + 2];

	            l  = (byte)(b2 & 0x0f);
	            k  = (byte)(b1 & 0x03);

	            encodedIndex = i * 4;
	            byte val1 = ((b1 & SIGN)==0)?(byte)(b1>>2):(byte)((b1)>>2^0xc0);
	            byte val2 = ((b2 & SIGN)==0)?(byte)(b2>>4):(byte)((b2)>>4^0xf0);
	            byte val3 = ((b3 & SIGN)==0)?(byte)(b3>>6):(byte)((b3)>>6^0xfc);

	            encodedData[encodedIndex]   = lookUpBase64Alphabet[ val1 ];
	            encodedData[encodedIndex+1] =
	                lookUpBase64Alphabet[ val2 | ( k<<4 )];
	            encodedData[encodedIndex+2] =
	                lookUpBase64Alphabet[ (l <<2 ) | val3 ];
	            encodedData[encodedIndex+3] = lookUpBase64Alphabet[ b3 & 0x3f ];
	        }

	        // form integral number of 6-bit groups
	        dataIndex    = i*3;
	        encodedIndex = i*4;
	        if (fewerThan24bits == EIGHTBIT )
	        {
	            b1 = binaryData[dataIndex];
	            k = (byte) ( b1 &0x03 );	            
	            byte val1 = ((b1 & SIGN)==0)?(byte)(b1>>2):(byte)((b1)>>2^0xc0);
	            encodedData[encodedIndex]     = lookUpBase64Alphabet[ val1 ];
	            encodedData[encodedIndex + 1] = lookUpBase64Alphabet[ k<<4 ];
	            encodedData[encodedIndex + 2] = PAD;
	            encodedData[encodedIndex + 3] = PAD;
	        }
	        else if (fewerThan24bits == SIXTEENBIT)
	        {

	            b1 = binaryData[dataIndex];
	            b2 = binaryData[dataIndex +1 ];
	            l = (byte) (b2 & 0x0f);
	            k = (byte) (b1 & 0x03);

	            byte val1 = ((b1 & SIGN) == 0)?(byte)(b1>>2):(byte)((b1)>>2^0xc0);
	            byte val2 = ((b2 & SIGN) == 0)?(byte)(b2>>4):(byte)((b2)>>4^0xf0);

	            encodedData[encodedIndex]     = lookUpBase64Alphabet[ val1 ];
	            encodedData[encodedIndex + 1] =
	                lookUpBase64Alphabet[ val2 | ( k<<4 )];
	            encodedData[encodedIndex + 2] = lookUpBase64Alphabet[ l<<2 ];
	            encodedData[encodedIndex + 3] = PAD;
	        }

	        return encodedData;
	    }
}