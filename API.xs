/*****************************************************************************
**	File:	API.xs
**	Type:	interface library (for Perl and friends)
**	Author:	David Oberholtzer, (daveo@obernet.com)
**			Copyright (c)2001, David Oberholtzer and Measurisk.
**	Date:	2001/03/23
**	Rev:	$Id: API.xs,v 1.1 2001/04/19 04:33:17 datadev Exp datadev $
**	Use:	Access to  FAME functions in other platforms.
******************************************************************************
**	This library is an abstraction layer for FAME C-HLI functions
**
**	NOTE: The most obvious difference between CHLI functions and FameHLI::API
**		functions is moving 'status' from 'argument' status to being the
**		'return value' of the function.
**
******************************************************************************
**	To Do
**		Reads & Writes: fix translation tables.
**
*****************************************************************************/
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "hli.h"
#include "API.h"

#define	DEF_CENT				1900
#define	RANGE_OBJECT_ME			1957
#define	DATA_OBJECT_ME			1958
#define	MISS_TBL_OBJECT_ME		1959


//***************************************************************************
//***************************************************************************
//	G L O B A L   V A R I A B L E S
//***************************************************************************
//***************************************************************************
static	int		status = 0;
static	int		xx_cnt = 0;


//***************************************************************************
//***************************************************************************
//		E x t e n s i o n   F u n c t i o n ( s )
//***************************************************************************
//***************************************************************************

//===========================================================================
//		N E W   S T R I N G
//===========================================================================
char	*newString(char *src)
{
int		len;
char	*ptr;

		if (src) {
			len = strlen(src) + 1;
			ptr = (char *)safemalloc(sizeof(char) * len);
			strcpy(ptr, src);
		} else {
			ptr = (char *)safemalloc(sizeof(char));
			*ptr = '\0';
		}
		return(ptr);
}





//***************************************************************************
//***************************************************************************
//	P E R L - H L I   M O D U L E   S T A R T S
//***************************************************************************
//**************************************************************************/

MODULE = FameHLI::API		PACKAGE = FameHLI::API		PREFIX = perl_

BOOT:
		status = HSUCC;
#*		printf("This is the Boot code.\n");


#*
#*
#*	P U B L I C   F U N C T I O N S
#*
#*

#****************************************************************************
#****************************************************************************
#*		P E R L   H E L P E R   F U N C T I O N S
#****************************************************************************
#****************************************************************************


#****************************************************************************
#****************************************************************************
#*		U s i n g   t h e   H L I
#****************************************************************************
#****************************************************************************


#*===========================================================================
#*		cfmini		F A M E   L I B R A R Y   I N I T I A L I Z A T I O N
#*===========================================================================
#*		Tested	2000/10/10
#*=========================================================================*/
int
perl_Cfmini()
	CODE:
		cfmini(&status);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmver
#*===========================================================================
#*		Tested	2000/10/10
#*=========================================================================*/
int
perl_Cfmver(sv_ver)
SV		*sv_ver

	PREINIT:
float	version;

	CODE:
		cfmver(&status, &version);
		sv_setnv(sv_ver, version);
		RETVAL = status;
	OUTPUT:
		RETVAL
		sv_ver


#*===========================================================================
#*		cfmfin		F A M E   L I B R A R Y   C L O S E / T E R M I N A T I O N
#*===========================================================================
#*		Tested	2000/10/10
#*=========================================================================*/
int
perl_Cfmfin()

	CODE:
		cfmfin(&status);
		RETVAL = status;

	OUTPUT:
		RETVAL


#****************************************************************************
#****************************************************************************
#*		S e t t i n g   O p t i o n s   i n   t h e   H L I
#****************************************************************************
#***************************************************************************/

#*===========================================================================
#*		cfmsopt
#*=========================================================================*/
#*		Tested 2000/10/17
#*=========================================================================*/
int
perl_Cfmsopt(optname, optval)
char	*optname
char	*optval

	CODE:
		cfmsopt(&status, optname, optval);
		RETVAL = status;

	OUTPUT:
		RETVAL



#****************************************************************************
#****************************************************************************
#*		S e t t i n g   R a n g e s
#****************************************************************************
#***************************************************************************/


#============================================================================
#*		cfmsrng
#============================================================================
int
perl_Cfmsrng(freq, sv_syear, sv_sprd, sv_eyear, sv_eprd, range, sv_numobs)
int		freq
SV		*sv_syear
SV		*sv_sprd
SV		*sv_eyear
SV		*sv_eprd
SV		*range
SV		*sv_numobs

	PREINIT:
int		syear;
int		sprd;
int		eyear;
int		eprd;
int		rng[3];
int		numobs;
int		i;
I32		ix;
AV		*rngarray;
SV		*sv;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given anything valid.  If so, use it.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
			av_clear(rngarray);
				
#/		----------------------------------------------------------------------
#/		It isn't a refrence or an array.  For now, blow away the old thing 
#/		and create a new reference.
#/		----------------------------------------------------------------------
		} else {
			rngarray = newAV();
			SvREFCNT_dec(range);
			range = newRV_inc((SV *)rngarray);
		}
		syear = SvIV(sv_syear);
		sprd = SvIV(sv_sprd);
		eyear = SvIV(sv_eyear);
		eprd = SvIV(sv_eprd);
		numobs = SvIV(sv_numobs);

		cfmsrng(&status, freq, &syear, &sprd, &eyear, &eprd, rng, &numobs);
		if (status == HSUCC) {
			sv_setiv(sv_syear, syear);
			sv_setiv(sv_sprd, sprd);
			sv_setiv(sv_eyear, eyear);
			sv_setiv(sv_eprd, eprd);
			for (i=0; i<3; i++) {
				sv = newSViv(rng[i]);
				av_push(rngarray, sv);
			}
			sv_setiv(sv_numobs, numobs);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_syear
		sv_sprd
		sv_eyear
		sv_eprd
		range
		sv_numobs


#*===========================================================================
#*		cfmsfis
#*===========================================================================
int
perl_Cfmsfis(freq, sv_syear, sv_sprd, sv_eyear, sv_eprd, range, sv_numobs, fmonth=HDEC, flabel=HFYFST)
int		freq
SV		*sv_syear
SV		*sv_sprd
SV		*sv_eyear
SV		*sv_eprd
SV		*range
SV		*sv_numobs
int		fmonth
int		flabel

	PREINIT:
int		syear;
int		sprd;
int		eyear;
int		eprd;
int		rng[3];
int		numobs;
int		i;
I32		ix;
AV		*rngarray;
SV		*sv;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given anything valid.  If so, use it.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
			av_clear(rngarray);
				
#/		----------------------------------------------------------------------
#/		It isn't a refrence or an array.  For now, blow away the old thing 
#/		and create a new reference.
#/		----------------------------------------------------------------------
		} else {
			rngarray = newAV();
			SvREFCNT_dec(range);
			range = newRV_inc((SV *)rngarray);
		}

		syear = SvIV(sv_syear);
		sprd = SvIV(sv_sprd);
		eyear = SvIV(sv_eyear);
		eprd = SvIV(sv_eprd);
		numobs = SvIV(sv_numobs);

		cfmsfis(&status, freq, &syear, &sprd, &eyear, &eprd,
				rng, &numobs, fmonth, flabel);
		if (status == HSUCC) {
			sv_setiv(sv_syear, syear);
			sv_setiv(sv_sprd, sprd);
			sv_setiv(sv_eyear, eyear);
			sv_setiv(sv_eprd, eprd);
			for (i=0; i<3; i++) {
				sv = newSViv(rng[i]);
				av_push(rngarray, sv);
			}
			sv_setiv(sv_numobs, numobs);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		sv_syear
		sv_sprd
		sv_eyear
		sv_eprd
		range
		sv_numobs


#****************************************************************************
#****************************************************************************
#*		H a n d l i n g   C o n n e c t i o n s
#****************************************************************************
#***************************************************************************/

#*===========================================================================
#*		cfmopcn		Open connection
#*===========================================================================
#*		Tested
#*=========================================================================*/
int
perl_Cfmopcn(sv_connkey, service="mcadbs", hostname="localhost", username="", password="")
SV		*sv_connkey
char	*service
char	*hostname
char	*username
char	*password

	PREINIT:
int		connkey;

	CODE:
		cfmopcn(&status, &connkey, service, hostname, username, password);
		
		if (status == HSUCC) {
			sv_setiv(sv_connkey, connkey);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_connkey


#*===========================================================================
#*		cfmgcid		Get channel id
#*=========================================================================*/
int
perl_Cfmgcid(dbkey, sv_connkey)
int		dbkey
SV		*sv_connkey

	PREINIT:
int		connkey;

	CODE:
		cfmgcid(&status, dbkey, &connkey);
		if (status == HSUCC) {
			sv_setiv(sv_connkey, connkey);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_connkey


#*===========================================================================
#*		cfmcmmt		Commit unit of work
#*=========================================================================*/
int
perl_Cfmcmmt(connkey)
int		connkey

	CODE:
		cfmcmmt(&status, connkey);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmabrt		Abort unit of work
#*=========================================================================*/
int
perl_Cfmabrt(connkey)
int		connkey

	CODE:
		cfmabrt(&status, connkey);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmclcn
#*===========================================================================
int
perl_Cfmclcn(connkey)
int		connkey

	CODE:
		cfmclcn(&status, connkey);
		RETVAL = status;

	OUTPUT:
		RETVAL


#****************************************************************************
#****************************************************************************
#*		H a n d l i n g   D a t a b a s e s
#****************************************************************************
#***************************************************************************/

#*===========================================================================
#*		cfmopdb		O P E N   F A M E   D A T A B A S E
#*===========================================================================
#*		Tested	HCMODE, HUMODE
#*=========================================================================*/
int
perl_Cfmopdb(sv_dbkey, dbname, mode=HRMODE)
SV		*sv_dbkey
char	*dbname
int		mode

	PREINIT:
int		dbkey;
char	name[SMALLBUF];
int		key;

	CODE:
		strcpy(name, dbname);
		cfmopdb(&status, &dbkey, name, mode);
		if (status == HSUCC) {
			sv_setiv(sv_dbkey, dbkey);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_dbkey


#*===========================================================================
#*		cfmcldb		C L O S E   F A M E   D A T A B A S E
#*===========================================================================
#*		Tested
#*=========================================================================*/
int
perl_Cfmcldb(key)
int		key

	CODE:
		cfmcldb(&status, key);
		RETVAL = status;

	OUTPUT:
		RETVAL

#*===========================================================================
#*		cfmpodb		P O S T   D A T A B A S E
#*===========================================================================
#*		Tested
#*=========================================================================*/
int
perl_Cfmpodb(dbkey)
int		dbkey

	CODE:
		cfmpodb(&status, dbkey);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmrsdb		R E S T O R E   D A T A B A S E
#*=========================================================================*/
int
perl_Cfmrsdb(dbkey)
int		dbkey

	CODE:
		cfmrsdb(&status, dbkey);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmpack		P A C K   D A T A B A S E
#*=========================================================================*/
int
perl_Cfmpack(dbkey)
int		dbkey

	CODE:
		cfmpack(&status, dbkey);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmopdc		O P E N   D A T A B A S E   C O N N E C T I O N
#*=========================================================================*/
int
perl_Cfmopdc(sv_dbkey, dbname, mode, connkey)
SV		*sv_dbkey
char	*dbname
int		mode
int		connkey

	PREINIT:
int		dbkey;

	CODE:
		cfmopdc(&status, &dbkey, dbname, mode, connkey);
		if (status == HSUCC) {
			sv_setiv(sv_dbkey, dbkey);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_dbkey


#****************************************************************************
#****************************************************************************
#*		H a n d l i n g   D a t a b a s e   I n f o r m a t i o n
#*					A n d   A t t r i b u t e s
#****************************************************************************
#***************************************************************************/

#*===========================================================================
#*		cfmddes
#*===========================================================================
int
perl_Cfmddes(dbkey, desc)
int		dbkey
char	*desc

	CODE:
		cfmddes(&status, dbkey, desc);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmddoc
#*===========================================================================
int
perl_Cfmddoc(dbkey, doc)
int dbkey
char *doc

	CODE:
		cfmddoc(&status, dbkey, doc);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmgdba
#*===========================================================================
#*		Tested
#*=========================================================================*/
int
perl_Cfmgdba(dbkey, sv_cyear, sv_cmonth, sv_cday, sv_myear, sv_mmonth, sv_mday, sv_desc, sv_doc)
int		dbkey
SV		*sv_cyear
SV		*sv_cmonth
SV		*sv_cday
SV		*sv_myear
SV		*sv_mmonth
SV		*sv_mday
SV		*sv_desc
SV		*sv_doc

	PREINIT:
int		cyear;
int		cmonth;
int		cday;
int		myear;
int		mmonth;
int		mday;
char	*desc;
char	*doc;
int		deslen, doclen, i;

	CODE:
		cfmglen(&status, dbkey, &deslen, &doclen);
		if (status == HSUCC) {
			desc = (char *)safemalloc(sizeof(char) * (deslen + 1));
			for (i=0; i<deslen; i++) {
				desc[i] = ' ';
			}

			doc = (char *)safemalloc(sizeof(char) * (doclen + 1));
			for (i=0; i<doclen; i++) {
				doc[i] = ' ';
			}

			cfmgdba(&status, dbkey, &cyear, &cmonth, &cday, 
									&myear, &mmonth, &mday, 
									desc, doc);
		}
		if (status == HSUCC) {
			sv_setiv(sv_cyear, cyear);
			sv_setiv(sv_cmonth, cmonth);
			sv_setiv(sv_cday, cday);
			sv_setiv(sv_myear, myear);
			sv_setiv(sv_mmonth, mmonth);
			sv_setiv(sv_mday, mday);
			sv_setpv(sv_desc, desc);
			sv_setpv(sv_doc, doc);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_cyear
		sv_cmonth
		sv_cday
		sv_myear
		sv_mmonth
		sv_mday
		sv_desc
		sv_doc


#*===========================================================================
#*		cfmgdbd		Get database's creation/modification dates at FREQ
#*=========================================================================*/
int
perl_Cfmgdbd(dbkey, freq, sv_cdate, sv_mdate)
int		dbkey
int		freq
SV		*sv_cdate
SV		*sv_mdate

	PREINIT:
int		cdate;
int		mdate;

	CODE:
		cfmgdbd(&status, dbkey, freq, &cdate, &mdate);
		if (status == HSUCC) {
			sv_setiv(sv_cdate, cdate);
			sv_setiv(sv_mdate, mdate);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_cdate
		sv_mdate


#*===========================================================================
#*		cfmglen
#*=========================================================================*/
int
perl_Cfmglen(dbkey, sv_deslen, sv_doclen)
int		dbkey
SV		*sv_deslen
SV		*sv_doclen

	PREINIT:
int		deslen;
int		doclen;

	CODE:
		cfmglen(&status, dbkey, &deslen, &doclen);
		if (status == HSUCC) {
			sv_setiv(sv_deslen, deslen);
			sv_setiv(sv_doclen, doclen);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_deslen
		sv_doclen


#/***************************************************************************
#****************************************************************************
#*		H a n d l i n g   D a t a   O b j e c t s
#****************************************************************************
#***************************************************************************/

#*===========================================================================
#*		cfmnwob		C R E A T E   O B J E C T
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmnwob(dbkey, objnam, class=HSERIE, freq=HBUSNS, type=HNUMRC, basis=HBSDAY, observ=HOBEND)
int		dbkey
char	*objnam
int		class
int		freq
int		type
int		basis
int		observ

	CODE:
		cfmnwob(&status, dbkey, objnam, class, freq, type, basis, observ);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmalob		A L L O C A T E   O B J E C T
#*=========================================================================*/
#*=========================================================================*/
int
perl_Cfmalob(dbkey, objnam, class=HSERIE, freq=HBUSNS, type=HNUMRC, basis=HBSDAY, observ=HOBEND, numobs=20, numchr=1024, growth=0.15)
int		dbkey
char	*objnam
int		class
int		freq
int		type
int		basis
int		observ
int		numobs
int		numchr
double	growth

	CODE:
		cfmalob(&status, dbkey, objnam, class, freq, type, 
					basis, observ, numobs, numchr, growth);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmcpob		C O P Y   O B J E C T
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmcpob(srckey, tarkey, srcnam, tarnam)
int		srckey
int		tarkey
char	*srcnam
char	*tarnam

	CODE:
		cfmcpob(&status, srckey, tarkey, srcnam, tarnam);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmdlob		D E L E T E   O B J E C T
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmdlob(dbkey, objnam)
int dbkey
char *objnam

	CODE:
		cfmdlob(&status, dbkey, objnam);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmrnob		R E N A M E   O B J E C T
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmrnob(dbkey, oldname, newname)
int		dbkey
char	*oldname
char	*newname

	CODE:
		cfmrnob(&status, dbkey, oldname, newname);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmasrt		A S S E R T   S o m e t h i n g
#*=========================================================================*/
int
perl_Cfmasrt(connkey, assert_type, assertion, perspective, grouping, dblist)
int		connkey
int		assert_type
char	*assertion
int		perspective
int		grouping
int		dblist

	CODE:
		cfmasrt(&status, connkey, assert_type, assertion, 
					perspective, grouping, &dblist);
		RETVAL = status;
	OUTPUT:
		RETVAL



#****************************************************************************
#****************************************************************************
#*		H a n d l i n g   D a t a   O b j e c t s   I n f o r m a t i o n
#*						a n d   A t t r i b u t e s
#****************************************************************************
#***************************************************************************/

#*===========================================================================
#*		cfmosiz		Get the size of an object
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmosiz(dbkey, objname, sv_class, sv_type, sv_freq, sv_fyear, sv_fprd, sv_lyear, sv_lprd)
int		dbkey
char	*objname
SV		*sv_class
SV		*sv_type
SV		*sv_freq
SV		*sv_fyear
SV		*sv_fprd
SV		*sv_lyear
SV		*sv_lprd

	PREINIT:
int		class;
int		type;
int		freq;
int		fyear;
int		fprd;
int		lyear;
int		lprd;

	CODE:
		cfmosiz(&status, dbkey, objname, &class, &type, &freq,
					&fyear, &fprd, &lyear, &lprd);
		if (status == HSUCC) {
			sv_setiv(sv_class, class);
			sv_setiv(sv_type, type);
			sv_setiv(sv_freq, freq);
			sv_setiv(sv_fyear, fyear);
			sv_setiv(sv_fprd, fprd);
			sv_setiv(sv_lyear, lyear);
			sv_setiv(sv_lprd, lprd);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		sv_class
		sv_type
		sv_freq
		sv_fyear
		sv_fprd
		sv_lyear
		sv_lprd


#*===========================================================================
#*		cfmgdat		Get an objects creation, mod dates at FREQ
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmgdat(dbkey, objnam, freq, sv_cdate, sv_mdate)
int		dbkey
char	*objnam
int		freq
SV		*sv_cdate
SV		*sv_mdate

	PREINIT:
int		cdate;
int		mdate;

	CODE:
		cfmgdat(&status, dbkey, objnam, freq, &cdate, &mdate);
		if (status == HSUCC) {
			sv_setiv(sv_cdate, cdate);
			sv_setiv(sv_mdate, mdate);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		sv_cdate
		sv_mdate


#*===========================================================================
#*		cfmwhat		Get lots of info
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmwhat(dbkey, objnam, sv_class, sv_type, sv_freq, sv_basis, sv_observ, sv_fyear, sv_fprd, sv_lyear, sv_lprd, sv_cyear, sv_cmonth, sv_cday, sv_myear, sv_mmonth, sv_mday, sv_desc, sv_doc)
int		dbkey
char	*objnam
SV		*sv_class
SV		*sv_type
SV		*sv_freq
SV		*sv_basis
SV		*sv_observ
SV		*sv_fyear
SV		*sv_fprd
SV		*sv_lyear
SV		*sv_lprd
SV		*sv_cyear
SV		*sv_cmonth
SV		*sv_cday
SV		*sv_myear
SV		*sv_mmonth
SV		*sv_mday
SV		*sv_desc
SV		*sv_doc

	PREINIT:
int		class, type, freq, basis, observ;
int		fyear, fprd, lyear, lprd;
int		cyear, cmonth, cday, myear, mmonth, mday;
int		deslen, doclen, i;
char	*desc;
char	*doc;

	CODE:
		cfmdlen(&status, dbkey, objnam, &deslen, &doclen);
		if (status == HSUCC) {
			desc = (char *)safemalloc(sizeof(char) * (deslen + 1));
			for (i=0; i<deslen; i++) {
				desc[i] = ' ';
			}
			desc[deslen] = '\0';

			doc = (char *)safemalloc(sizeof(char) * (doclen + 1));
			for (i=0; i<doclen; i++) {
				doc[i] = ' ';
			}
			doc[deslen] = '\0';

			cfmwhat(&status, dbkey, objnam,
				&class, &type, &freq, &basis, &observ, 
				&fyear, &fprd, &lyear, &lprd, &cyear, &cmonth, &cday,
				&myear, &mmonth, &mday, desc, doc);
		}
		if (status == HSUCC) {
			sv_setiv(sv_class, class);
			sv_setiv(sv_type, type);
			sv_setiv(sv_freq, freq);
			sv_setiv(sv_basis, basis);
			sv_setiv(sv_observ, observ);
			sv_setiv(sv_fyear, fyear);
			sv_setiv(sv_fprd, fprd);
			sv_setiv(sv_lyear, lyear);
			sv_setiv(sv_lprd, lprd);
			sv_setiv(sv_cyear, cyear);
			sv_setiv(sv_cmonth, cmonth);
			sv_setiv(sv_cday, cday);
			sv_setiv(sv_myear, myear);
			sv_setiv(sv_mmonth, mmonth);
			sv_setiv(sv_mday, mday);
			sv_setpv(sv_desc, desc);
			sv_setpv(sv_doc, doc);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		sv_class
		sv_type
		sv_freq
		sv_basis
		sv_observ
		sv_fyear
		sv_fprd
		sv_lyear
		sv_lprd
		sv_cyear
		sv_cmonth
		sv_cday
		sv_myear
		sv_mmonth
		sv_mday
		sv_desc
		sv_doc


#*===========================================================================
#*		cfmncnt		Get the length of a namelist
#*=========================================================================*/
int
perl_Cfmncnt(dbkey, objnam, sv_length)
int		dbkey
char	*objnam
SV		*sv_length

	PREINIT:
int		length;

	CODE:
		cfmncnt(&status, dbkey, objnam, &length);
		if (status == HSUCC) {
			sv_setiv(sv_length, length);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_length


#*===========================================================================
#*		cfmdlen		Get NAMELIST's doc and desc length
#*===========================================================================
#*		This is implemented here for completeness and because it is easy.
#*		There really isn't any reason to include it since you can get the
#*		strings WITHOUT knowing how long they are anyway.
#*=========================================================================*/
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmdlen(dbkey, objnam, sv_deslen, sv_doclen)
int		dbkey
char	*objnam
SV		*sv_deslen
SV		*sv_doclen

	PREINIT:
int		deslen;
int		doclen;

	CODE:
		cfmdlen(&status, dbkey, objnam, &deslen, &doclen);
		if (status == HSUCC) {
			sv_setiv(sv_deslen, deslen);
			sv_setiv(sv_doclen, doclen);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_deslen
		sv_doclen


#*===========================================================================
#*		cfmsdes		Set NAMELIST desc field
#*=========================================================================*/
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmsdes(dbkey, objnam, desc)
int		dbkey
char	*objnam
char	*desc

	CODE:
		cfmsdes(&status, dbkey, objnam, desc);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmsdoc		Set NAMELIST doc field
#*=========================================================================*/
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmsdoc(dbkey, objnam, doc)
int		dbkey
char	*objnam
char	*doc

	CODE:
		cfmsdoc(&status, dbkey, objnam, doc);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmsbas		Set objects BASIS attribute
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmsbas(dbkey, objnam, basis)
int dbkey
char *objnam
int basis

	CODE:
		cfmsbas(&status, dbkey, objnam, basis);
		RETVAL = status;

	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmsobs		Set objects OBSERVED attribute
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmsobs(dbkey, objnam, observ)
int		dbkey
char	*objnam
int		observ

	CODE:
		cfmsobs(&status, dbkey, objnam, observ);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		U s e r - D e f i n e d   A t t r i b u t e s
#*===========================================================================
#*		Since it is easier to use a specific type of function than it
#*		is to pass a varient data-type, we just create a seperate function
#*		for each data type.
#*===========================================================================

#*===========================================================================
#*		cfmgtatt	Get User defined attribute value
#*=========================================================================*/
#*		Tested
#*			Boolean		2001/03/21
#*			Numeric		2001/03/22
#*			Precision	2001/03/22
#*			NameList	2001/03/22
#*			String		2001/03/22
#*			Date		2001/03/22
#*===========================================================================
int
perl_Cfmgtatt(dbkey, objnam, sv_atttype, attnam, sv_value, inlen, sv_outlen)
int		dbkey
char	*objnam
SV		*sv_atttype
char	*attnam
SV		*sv_value
int		inlen
SV		*sv_outlen

	PREINIT:
int		worked	=	TRUE;
int		atttype;
int		outlen	=	0;
float	f_value;
double	d_value;
int		i_value;
char	*s_value;
float	*valptr;

	CODE:
		atttype = SvIV(sv_atttype);
		switch (atttype) {
		  case HNUMRC:
			valptr = &f_value;
			break;
		  case HPRECN:
			valptr = (float *)(&d_value);
			break;
		  case HNAMEL:
		  case HSTRNG:
			if (inlen < 1) {
				cfmlatt(&status, dbkey, objnam, atttype, attnam, &inlen);
				if (status != HSUCC) {
					printf("Couldn't get the attribute length!(%d)\n", status);
					worked = FALSE;
				}
			}
			if (worked) {
				s_value = (char *)safemalloc(sizeof(char *) * inlen);
				valptr = (float *)s_value;
			}
			break;
		  case HBOOLN:
		  case HDATE:
			valptr = (float *)(&i_value);
			break;
		  default:
			printf("Cfmgtatt: Invalid Attribute Type\n");
			worked = FALSE;
			break;
		}

		if (worked) {
			cfmgtatt(&status, dbkey, objnam, &atttype, attnam, valptr, 
					inlen, &outlen);
			worked = (status == HSUCC || status == HTRUNC);
		}

		if (worked) {
			switch(atttype) {
			  case HNUMRC:
				sv_setnv(sv_value, f_value);
				break;
			  case HPRECN:
				sv_setnv(sv_value, d_value);
				break;
			  case HNAMEL:
			  case HSTRNG:
				sv_setpv(sv_value, s_value);
				break;
			  case HBOOLN:
			  case HDATE:
			  case HBUSNS:
			  case HDAILY:
				sv_setiv(sv_value, i_value);
				break;
			  default:
				printf("Cfmgtatt: Why am I not elsewhere?\n");
				break;
			}
			sv_setiv(sv_atttype, atttype);
			sv_setiv(sv_outlen, outlen);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_value
		sv_atttype
		sv_outlen


#*===========================================================================
#*		cfmlatt		Get length of a user defined string or NAMELIST attribute
#*===========================================================================
#*		Tested	2001/03/22
#*=========================================================================*/
int
perl_Cfmlatt(dbkey, objnam, attyp, attnam, attlen)
int		dbkey
char	*objnam
int		attyp
char	*attnam
int		attlen		=	NO_INIT

	CODE:
		cfmlatt(&status, dbkey, objnam, attyp, attnam, &attlen);
		RETVAL = status;
	OUTPUT:
		RETVAL
		attlen


#*===========================================================================
#*		cfmsatt		Set the value of a user defined attribute
#*=========================================================================*/
#*		Tested
#*			Boolean		2001/03/22
#*			Numeric		2001/03/22
#*			Precision	2001/03/22
#*			NameList	2001/03/22
#*			String		2001/03/22
#*			Date		2001/03/22
#*===========================================================================
int
perl_Cfmsatt(dbkey, objnam, atttype, attnam, sv_value)
int		dbkey
char	*objnam
int		atttype
char	*attnam
SV		*sv_value

	PREINIT:
int		i_value;
float	f_value;
double	d_value;
char	*s_value;
float	*valptr;
int		xlen;

	CODE:
		switch (atttype) {
		  case HNUMRC:
			f_value = SvNV(sv_value);
			valptr = &f_value;
			break;
		  case HPRECN:
			d_value = SvNV(sv_value);
			valptr = (float *)(&d_value);
			break;
		  case HNAMEL:
		  case HSTRNG:
			s_value = SvPV(sv_value, xlen);
			valptr = (float *)(s_value);
			break;
		  case HBOOLN:
		  case HDATE:
		  case HBUSNS:
		  case HDAILY:
			i_value = SvIV(sv_value);
			valptr = (float *)(&i_value);
			break;
		  default:
			printf("Cfmsatt: Why am I not elsewhere?\n");
			break;
		}
		cfmsatt(&status, dbkey, objnam, atttype, attnam, valptr);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmgnam		Get base name of an object
#*===========================================================================
#*		Tested 2001/03/22
#*===========================================================================
int
perl_Cfmgnam(dbkey, objnam, sv_basnam)
int		dbkey
char	*objnam
SV		*sv_basnam

	PREINIT:
char	buff[SMALLBUF];

	CODE:
		cfmgnam(&status, dbkey, objnam, buff);
		if (status == HSUCC) {
			sv_setpv(sv_basnam, buff);
		} else {
			printf("Cfmgnam: Danger Will Robinson! (%d)\n", status);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_basnam


#*===========================================================================
#*		cfmgtali	Get the aliases of an object
#*===========================================================================
#*		Tested 2001/03/22
#*===========================================================================
int
perl_Cfmgtali(dbkey, objnam, sv_alias, inlen, sv_outlen)
int		dbkey
char	*objnam
SV		*sv_alias
int		inlen;
SV		*sv_outlen;

	PREINIT:
int		outlen;
char	*buff;

	CODE:
		if (inlen < 1) {
			cfmlali(&status, dbkey, objnam, &inlen);
		}

		buff = (char *)safemalloc(inlen+1);
		outlen = inlen;

		cfmgtali(&status, dbkey, objnam, buff, inlen, &outlen);
		if (status == HSUCC) {
			sv_setpv(sv_alias, buff);
			sv_setiv(sv_outlen, outlen);
		} else {
			printf("Cfmgtali: Danger Will Robinson! (%d)\n", status);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_alias
		sv_outlen


#*===========================================================================
#*		cfmlali		Get the length of an objects aliases
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmlali(dbkey, objnam, sv_alilen)
int		dbkey
char	*objnam
SV		*sv_alilen

	PREINIT:
int		len;

	CODE:
		sv_setiv(sv_alilen, -1);
		cfmlali(&status, dbkey, objnam, &len);
		if (status == HSUCC) {
			sv_setiv(sv_alilen, len);
		} else {
			printf("Cfmlali: Danger Will Robinson! (%d)\n", status);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		sv_alilen


#*===========================================================================
#*		cfmsali		Set the alias of an object
#*===========================================================================
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmsali(dbkey, objnam, aliass)
int		dbkey
char	*objnam
char	*aliass

	PREINIT:
int		x;

	CODE:
		cfmsali(&status, dbkey, objnam, aliass);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmlsts		Get the lengths of a range of strings
#*=========================================================================*/
#*		Tested	??	2001/03/22
#*=========================================================================*/
int
perl_Cfmlsts(dbkey, objnam, range, sv_lenary)
int		dbkey
char	*objnam
SV		*range
SV		*sv_lenary

	PREINIT:
int		i;
int		worked	=	TRUE;
SV		**svptr;
SV		*sv;
I32		ix;
int		rlen;
int		rng[3];
AV		*rngarray;
AV		*lenarray;
int		class, type, freq;
int		fyear, fprd, lyear, lprd;
int		*lenary;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given anything valid.  If so, use it.
#/		----------------------------------------------------------------------
		if (SvROK(sv_lenary) && (SvTYPE(SvRV(sv_lenary)) == SVt_PVAV)) {
			lenarray = (AV *)SvRV(sv_lenary);
			av_clear(lenarray);
				
#/		----------------------------------------------------------------------
#/		It isn't a refrence or an array.  For now, blow away the old thing 
#/		and create a new reference.
#/		----------------------------------------------------------------------
		} else {
			lenarray = newAV();
			SvREFCNT_dec(sv_lenary);
			sv_lenary = newRV_inc((SV *)lenarray);
		}

#/		----------------------------------------------------------------------
#/		First, let's see what type of data object we are reading.  This will
#/		affect what we do with the DATA set and the MISSING TABLE stuff.
#/		----------------------------------------------------------------------
		cfmosiz(&status, dbkey, objnam, &class, &type, &freq,
					&fyear, &fprd, &lyear, &lprd);

#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid RANGE.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
		} else {
			status = HBRNG;
			worked = FALSE;
		}

		if (worked && av_len(rngarray) == 2) {
			for (ix=0; ix<3; ix++) {
				svptr = av_fetch(rngarray, ix, 0);
				rng[ix] = SvIV(*svptr);
			}
#/			----------------------------------------------------------
#/			This might be cheating but I believe it is correct...
#/			[0]=freq, [1]=start, [2]=end so [2]-[1] should be nobs - 1.
#/			----------------------------------------------------------
			rlen = rng[2] - rng[1] + 1;
		}

		lenary = NULL;

		if (worked) {
			lenary = (int *)safemalloc(sizeof(int) * rlen);
			cfmlsts(&status, dbkey, objnam, rng, lenary);
		}

		if (status == HSUCC) {
			for (i=0; i<rlen; i++) {
				sv = newSViv(lenary[i]);
				av_push(lenarray, sv);
			}
		} else {
			printf("Cfmlsts: Danger Will Robinson! (%d)\n", status);
		}

		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_lenary


#*===========================================================================
#*		cfmnlen		Get the buffer length needed for reading a namelist
#*=========================================================================*/
#*		Tested ??		NOT TESTED
#*=========================================================================*/
int
perl_Cfmnlen(dbkey, objnam, index, sv_length)
int		dbkey
char	*objnam
int		index
SV		*sv_length

	PREINIT:
int		length;

	CODE:
		cfmnlen(&status, dbkey, objnam, index, &length);
		sv_setiv(sv_length, -1);
		if (status == HSUCC) {
			sv_setiv(sv_length, length);
		} else {
			printf("Cfmnlen: Danger Will Robinson! (%d)\n", status);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_length


#*===========================================================================
#*		cfmgsln		Get the STRINGLENGTH attribute of an object
#*=========================================================================*/
#*		Tested ??		NOT TESTED
#*===========================================================================
int
perl_Cfmgsln(dbkey, objnam, sv_length)
int		dbkey
char	*objnam
SV		*sv_length

	PREINIT:
int		length;

	CODE:
		sv_setiv(sv_length, -1);
		cfmgsln(&status, dbkey, objnam, &length);
		if (status == HSUCC) {
			sv_setiv(sv_length, length);
		} else {
			printf("Cfmgsln: Danger Will Robinson! (%d)\n", status);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		sv_length


#*===========================================================================
#*		cfmssln		Set the STRINGLENGTH attribute of an object
#*=========================================================================*/
#*		Tested 2001/02/14
#*===========================================================================
int
perl_Cfmssln(dbkey, objnam, length)
int		dbkey
char	*objnam
int		length

	CODE:
		cfmssln(&status, dbkey, objnam, length);
		RETVAL = status;
	OUTPUT:
		RETVAL


#*===========================================================================
#*		cfmgtaso	G e t   A S S O C I A T E  A t t r i b u t e
#*=========================================================================*/
#*		Tested	2001/03/22
#*=========================================================================*/
int
perl_Cfmgtaso(dbkey, objnam, sv_assoc)
int		dbkey
char	*objnam
SV		*sv_assoc

	PREINIT:
int		inlen;
int		outlen;
char	tmp[2];
char	*buff;
int		cnt = 0;

	CODE:
		inlen = 1;
		cfmgtaso(&status, dbkey, objnam, tmp, inlen, &outlen);

		buff = NULL;
		if (status == HSUCC || status == HTRUNC) {
			inlen = outlen;
			buff = (char *)safemalloc(outlen+1);
			cfmgtaso(&status, dbkey, objnam, buff, inlen, &outlen);
		}

		if (status == HSUCC) {
			sv_setpv(sv_assoc, buff);
		} else {
			printf("Cfmgtaso: Danger Will Robinson! (%d)\n", status);
		}

		if (buff) {
			safefree(buff);
		}

		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_assoc


#*===========================================================================
#*		cfmlaso		A S S O C I A T E  A t t r i b u t e   L e n g t h
#*=========================================================================*/
#*		Tested	2001/03/22
#*=========================================================================*/
int
perl_Cfmlaso(dbkey, objnam, sv_asolen)
int		dbkey
char	*objnam
SV		*sv_asolen

	PREINIT:
int		asolen;

	CODE:
		sv_setiv(sv_asolen, -1);
		cfmlaso(&status, dbkey, objnam, &asolen);
		if (status == HSUCC) {
			sv_setiv(sv_asolen, asolen);
		} else {
			printf("Cfmlaso: Danger Will Robinson! (%d)\n", status);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_asolen


#*===========================================================================
#*		cfmsaso		S e t   A S S O C I A T E  A t t r i b u t e
#*=========================================================================*/
#*		Tested	2001/03/22
#*=========================================================================*/
int
perl_Cfmsaso(dbkey, objnam, assoc)
int		dbkey
char	*objnam
char	*assoc

	CODE:
		cfmsaso(&status, dbkey, objnam, assoc);
		RETVAL = status;
	OUTPUT:
		RETVAL



#/***************************************************************************
#/***************************************************************************
#/					H A N D L I N G   D A T E S
#/***************************************************************************
#/***************************************************************************


#/===========================================================================
#/		cfmfdiv		F r e q 1   D i v i s i b l e   B y   F r e q 2   ?
#/===========================================================================
#/===========================================================================
int
perl_Cfmfdiv(freq1, freq2, flag)
int		freq1
int		freq2
int		flag		=	NO_INIT

	CODE:
		cfmfdiv(&status, freq1, freq2, &flag);
		RETVAL = status;
	OUTPUT:
		RETVAL
		flag


#/===========================================================================
#/		cfmtody		R E T R E I V E   T O D A Y ' S   D A T E
#/===========================================================================
#*		Tested 2001/02/14
#/===========================================================================
int
perl_Cfmtody(freq, date)
int freq
int date		=	NO_INIT

	CODE:
		cfmtody(&status, freq, &date);
		RETVAL = status;
	OUTPUT:
		RETVAL
		date


#/===========================================================================
#/		cfmpind		G e t   P e r i o d s   i n   a   D a y
#/===========================================================================
#/		Tested:	2001/04/18
#/===========================================================================
int
perl_Cfmpind(freq, count)
int freq
int count		=	NO_INIT

	CODE:
		cfmpind(&status, freq, &count);
		RETVAL = status;
	OUTPUT:
		RETVAL
		count


#/===========================================================================
#/		cfmpinm		G e t   P e r i o d s   i n   a   M o n t h
#/===========================================================================
#/		Tested:	2001/04/18
#/===========================================================================
int
perl_Cfmpinm(freq, year, month, count)
int freq
int year
int month
int count		=	NO_INIT

	CODE:
		cfmpinm(&status, freq, year, month, &count);
		RETVAL = status;
	OUTPUT:
		RETVAL
		count


#/===========================================================================
#/		cfmpiny		G e t   P e r i o d s   i n   a   Y e a r
#/===========================================================================
#/		Tested:	2001/04/18
#/===========================================================================
int
perl_Cfmpiny(freq, year, count)
int freq
int year
int count		=	NO_INIT

	CODE:
		cfmpiny(&status, freq, year, &count);
		RETVAL = status;
	OUTPUT:
		RETVAL
		count


#/===========================================================================
#/		cfmwkdy		G e t   W e e k d a y   o f   a   D a t e
#/===========================================================================
#/		Tested:	2001/04/18
#/===========================================================================
int
perl_Cfmwkdy(freq, date, wkdy)
int freq
int date
int wkdy		=	NO_INIT

	CODE:
		cfmwkdy(&status, freq, date, &wkdy);
		RETVAL = status;
	OUTPUT:
		RETVAL
		wkdy


#/===========================================================================
#/		cfmbwdy		G e t   B i w e e k d a y   o f   a   D a t e
#/===========================================================================
#/		Tested:	2001/04/18
#/===========================================================================
int
perl_Cfmbwdy(freq, date, biwkdy)
int freq
int date
int biwkdy		=	NO_INIT

	CODE:
		cfmbwdy(&status, freq, date, &biwkdy);
		RETVAL = status;
	OUTPUT:
		RETVAL
		biwkdy


#/===========================================================================
#/		cfmislp		I s   Y e a r   L e a p   Y e a r ?
#/===========================================================================
#/		Tested:	2001/04/18
#/===========================================================================
int
perl_Cfmislp(year, leap)
int year
int leap		=	NO_INIT

	CODE:
		cfmislp(&status, year, &leap);
		RETVAL = status;
	OUTPUT:
		RETVAL
		leap


#/===========================================================================
#/		cfmchfr		C h a n g e   F r e q   o f   D a t e
#/===========================================================================
int
perl_Cfmchfr(sfreq, sdate, select, tfreq, tdate, relate)
int sfreq
int sdate
int select
int tfreq
int tdate		=	NO_INIT
int relate

	CODE:
		cfmchfr(&status, sfreq, sdate, select, tfreq, &tdate, relate);
		RETVAL = status;
	OUTPUT:
		RETVAL
		tdate


#/===========================================================================
#/		cfmpfrq
#/===========================================================================
#*		Tested 2001/02/14
#/===========================================================================
int
perl_Cfmpfrq(freq, base, nunits, year, month)
int freq		=	NO_INIT
int base
int nunits
int year
int month

	CODE:
		cfmpfrq(&status, &freq, base, nunits, year, month);
		RETVAL = status;
	OUTPUT:
		RETVAL
		freq


#/===========================================================================
#/		cfmufrq
#/===========================================================================
#*		Tested 2001/02/14
#/===========================================================================
int
perl_Cfmufrq(freq, base, nunits, year, month)
int freq
int base		=	NO_INIT
int nunits		=	NO_INIT
int year		=	NO_INIT
int month		=	NO_INIT

	CODE:
		cfmufrq(&status, freq, &base, &nunits, &year, &month);
		RETVAL = status;
	OUTPUT:
		RETVAL
		base
		nunits
		year
		month


#/***************************************************************************
#/***************************************************************************
#/		H a n d l i n g   M i s s i n g   V a l u e s
#/***************************************************************************
#/***************************************************************************


#/===========================================================================
#/		cfmsnm
#/===========================================================================
#/		In progress
#/===========================================================================
int
perl_Cfmsnm(t_nctran = FNUMNC, t_ndtran = FNUMND, t_natran = FNUMNA, table)
double		t_nctran
double		t_ndtran
double		t_natran
SV			*table

	PREINIT:
float		nctran;
float		ndtran;
float		natran;
float		tbl[3];
int			i;
AV			*misarray;
SV			*sv;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given anything valid.  If so, use it.
#/		----------------------------------------------------------------------
		if (SvROK(table) && (SvTYPE(SvRV(table)) == SVt_PVAV)) {
			misarray = (AV *)SvRV(table);
			av_clear(misarray);

#/		----------------------------------------------------------------------
#/		It isn't a refrence or an array.  For now, blow away the old thing 
#/		and create a new reference.
#/		----------------------------------------------------------------------
		} else {
			misarray = newAV();
			SvREFCNT_dec(table);
			table = newRV_inc((SV *)misarray);
		}

		nctran = t_nctran;
		ndtran = t_ndtran;
		natran = t_natran;
		cfmsnm(&status, nctran, ndtran, natran, tbl);

		if (status == HSUCC) {
			for (i=0; i<3; i++) {
				sv = newSVnv(tbl[i]);
				av_push(misarray, sv);
			}
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		table


#/===========================================================================
#/		cfmspm
#/===========================================================================
#/		In progress
#/===========================================================================
int
perl_Cfmspm(nctran = FPRCNC, ndtran = FPRCND, natran = FPRCNA, table)
double		nctran
double		ndtran
double		natran
SV			*table

	PREINIT:
double		tbl[3];
int			i;
AV			*misarray;
SV			*sv;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given anything valid.  If so, use it.
#/		----------------------------------------------------------------------
		if (SvROK(table) && (SvTYPE(SvRV(table)) == SVt_PVAV)) {
			misarray = (AV *)SvRV(table);
			av_clear(misarray);

#/		----------------------------------------------------------------------
#/		It isn't a refrence or an array.  For now, blow away the old thing 
#/		and create a new reference.
#/		----------------------------------------------------------------------
		} else {
			misarray = newAV();
			SvREFCNT_dec(table);
			table = newRV_inc((SV *)misarray);
		}

		cfmspm(&status, nctran, ndtran, natran, tbl);
		if (status == HSUCC) {
			for (i=0; i<3; i++) {
				sv = newSVnv(tbl[i]);
				av_push(misarray, sv);
			}
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		table


#/===========================================================================
#/		cfmsbm
#/===========================================================================
#/		In progress
#/===========================================================================
int
perl_Cfmsbm(t_nctran = FBOONC, t_ndtran = FBOOND, t_natran = FBOONA, table)
double		t_nctran;
double		t_ndtran;
double		t_natran;
SV			*table

	PREINIT:
int		nctran;
int		ndtran;
int		natran;
int		tbl[3];
int		i;
AV		*misarray;
SV		*sv;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given anything valid.  If so, use it.
#/		----------------------------------------------------------------------
		if (SvROK(table) && (SvTYPE(SvRV(table)) == SVt_PVAV)) {
			misarray = (AV *)SvRV(table);
			av_clear(misarray);

#/		----------------------------------------------------------------------
#/		It isn't a refrence or an array.  For now, blow away the old thing 
#/		and create a new reference.
#/		----------------------------------------------------------------------
		} else {
			misarray = newAV();
			SvREFCNT_dec(table);
			table = newRV_inc((SV *)misarray);
		}

		nctran = t_nctran;
		ndtran = t_ndtran;
		natran = t_natran;

		cfmsbm(&status, nctran, ndtran, natran, tbl);
		if (status == HSUCC) {
			for (i=0; i<3; i++) {
				sv = newSViv(tbl[i]);
				av_push(misarray, sv);
			}
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		table


#/===========================================================================
#/		cfmsdm
#/===========================================================================

#/===========================================================================
#/		cfmisnm
#/===========================================================================
#/		Doesn't quite work passing in ND...
#/===========================================================================
int
perl_Cfmisnm(t_value, ismiss)
double	t_value
int		ismiss		=	NO_INIT

	PREINIT:
float	value;

	CODE:
		value = t_value;
		printf("value is '%f'\n", value);
		cfmisnm(&status, value, &ismiss);
		RETVAL = status;

	OUTPUT:
		RETVAL
		ismiss


#/===========================================================================
#/		cfmispm
#/===========================================================================
int
perl_Cfmispm(value, ismiss)
double	value
int		ismiss		=	NO_INIT

	CODE:
		printf("value is '%f'\n", value);
		cfmisnm(&status, value, &ismiss);
		RETVAL = status;

	OUTPUT:
		RETVAL
		ismiss


#/===========================================================================
#/		cfmisbm
#/===========================================================================

#/===========================================================================
#/		cfmisdm
#/===========================================================================

#/===========================================================================
#/		cfmissm
#/===========================================================================

#/***************************************************************************
#/***************************************************************************
#/		W i l d c a r d i n g
#/***************************************************************************
#/***************************************************************************

#/===========================================================================
#/		cfminwc		I n i t   W i l d c a r d
#/===========================================================================
#/		Tested	2000/10/16
#/===========================================================================
int
perl_Cfminwc(dbkey, wildname)
int dbkey
char *wildname

	CODE:
		cfminwc(&status, dbkey, wildname);
		RETVAL = status;
	OUTPUT:
		RETVAL

#/===========================================================================
#/		cfmnxwc		N e x t   W i l d c a r d   M a t c h
#/===========================================================================
#/		Object names can only be 64 characters long so the buffer is more
#/		than enough.
#/===========================================================================
#/		Tested	2001/03/16
#/===========================================================================
int
perl_Cfmnxwc(dbkey, obj, class, type, freq)
int		dbkey
char	*obj	=	NO_INIT
int		class	=	NO_INIT
int		type	=	NO_INIT
int		freq	=	NO_INIT

	PREINIT:
char	buffer[SMALLBUF];
static	int	xx = 0;
char	*thing;
int		len;

	CODE:
		cfmnxwc(&status, dbkey, buffer, &class, &type, &freq);
		if (status == HSUCC) {
			len = strlen(buffer) + 1;
			obj = safemalloc(len);
			strcpy(obj, buffer);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		obj
		class
		type
		freq


#/***************************************************************************
#/***************************************************************************
#/		R e a d i n g   D a t a
#/***************************************************************************
#/***************************************************************************

#/===========================================================================
#/		cfmrdfa		R e a d   A l l   D a t a   F r o m   O b j e c t
#/===========================================================================
#/	BROKE
#/===========================================================================
int
perl_Cfmrdfa(dbkey, objnam, wntobs, syear, sprd, gotobs, data, tmiss, tbl)
int		dbkey
char	*objnam
int		wntobs
int		syear
int		sprd
int		gotobs
double	data		=	NO_INIT
int		tmiss
double	tbl

	CODE:
		status = -1;
#		cfmrdfa(&status, dbkey, objnam, wntobs, &syear, &sprd, &gotobs, 
#				(float *)(data->data), tmiss, (float *)tbl->tbl);
		RETVAL = status;
	OUTPUT:
		RETVAL
		syear
		sprd
		gotobs
		data


#/===========================================================================
#/		cfmgtnl		G e t   N a m e l i s t  ( E l e m e n t   o r   A l l )
#/===========================================================================
#/===========================================================================
int
perl_Cfmgtnl(dbkey, objnam, index, str, inlen, outlen)
int		dbkey
char	*objnam
int		index
char	*str		=	NO_INIT
int		inlen
int		outlen		=	NO_INIT

	PREINIT:
char	*buffer = (char *)safemalloc((inlen+1) * sizeof(char));

	CODE:
		cfmgtnl(&status, dbkey, objnam, index, buffer, inlen, &outlen);
		str = newString(buffer);
		safefree(buffer);
		RETVAL = status;

	OUTPUT:
		RETVAL
		str
		outlen

#/===========================================================================
#/		cfmrrng		R e a d   R a n g e   o f   D a t a
#/===========================================================================
#/		Tested
#/			2001/04/17
#/		Missing values passed, but not missing table values.
#/===========================================================================
int
perl_Cfmrrng(dbkey, objnam, range, data, miss, table)
int		dbkey
char	*objnam
SV		*range
SV		*data
int		miss
SV		*table

	PREINIT:
int		i;
int		worked	=	TRUE;
SV		**svptr;
SV		*sv;
SV		*sv2;
I32		ix;
int		len;
int		rlen;
int		rng[3];
AV		*datarray;
AV		*rngarray;
AV		*tblarray;
int		*iptr;
float	*fptr;
void	*vptr;
int		*mitbl	=	NULL;
float	*mftbl	=	NULL;
double	*mdtbl	=	NULL;
void	*tbl	=	NULL;
int		class;
int		type;
int		freq;
int		fyear;
int		fprd;
int		lyear;
int		lprd;
double	*dptr;
double	dtmp;


	CODE:
#/		----------------------------------------------------------------------
#/		See if we were given a real variable.  If so, clear it out.
#/		----------------------------------------------------------------------
		if (SvROK(data) && (SvTYPE(SvRV(data)) == SVt_PVAV)) {
			datarray = (AV *)SvRV(data);
			av_clear(datarray);

#/		----------------------------------------------------------------------
#/		----------------------------------------------------------------------
		} else {
			datarray = newAV();
			SvREFCNT_dec(data);
			data = newRV_inc((SV *)datarray);
		}

#/		----------------------------------------------------------------------
#/		First, let's see what type of data object we are reading.  This will
#/		affect what we do with the DATA set and the MISSING TABLE stuff.
#/		----------------------------------------------------------------------
		cfmosiz(&status, dbkey, objnam, &class, &type, &freq,
					&fyear, &fprd, &lyear, &lprd);

#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid RANGE.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
		} else {
			status = HBRNG;
			worked = FALSE;
		}

		if (worked && av_len(rngarray) == 2) {
			for (ix=0; ix<3; ix++) {
				svptr = av_fetch(rngarray, ix, 0);
				rng[ix] = SvIV(*svptr);
			}
#/			----------------------------------------------------------
#/			This might be cheating but I believe it is correct...
#/			[0]=freq, [1]=start, [2]=end so [2]-[1] should be nobs - 1.
#/			----------------------------------------------------------
			rlen = rng[2] - rng[1] + 1;
		}

#/		----------------------------------------------------------------------
#/		Next, depending on the type of data that we will be reading...
#/		----------------------------------------------------------------------
		if (worked) {
			switch (type) {
			  case HNUMRC:
				fptr = (float *)safemalloc(sizeof(float) * rlen);
				vptr = (void *)fptr;
				break;
			  case HBUSNS:
			  case HDAILY:
			  case HBOOLN:
				iptr = (int *)safemalloc(sizeof(int) * rlen);
				vptr = (void *)iptr;
				break;
			  case HPRECN:
				dptr = (double *)safemalloc(sizeof(double) * rlen);
				vptr = (void *)dptr;
				break;
			  default:
				printf("I don't know how to process '%d'\n", type);
				break;
			}
		}

#/		----------------------------------------------------------------------
#/		----------------------------------------------------------------------
		cfmrrng(&status, dbkey, objnam, rng, (float *)vptr, miss, tbl);

		if (worked) {
			for (i=0; i<rlen; i++) {
				switch(type) {
				  case HNUMRC:
					if (fptr[i] == FNUMNA) {
						sv = newSVpv("NA", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (fptr[i] == FNUMNC) {
						sv = newSVpv("NC", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (fptr[i] == FNUMND) {
						sv = newSVpv("ND", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else {
						sv = newSVnv(fptr[i]);
						av_push(datarray, sv);
					}
					break;

				  case HBOOLN:
					if (iptr[i] == FBOONA) {
						sv = newSVpv("NA", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (iptr[i] == FBOONC) {
						sv = newSVpv("NC", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (iptr[i] == FBOOND) {
						sv = newSVpv("ND", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else {
						sv = newSViv(iptr[i]);
						av_push(datarray, sv);
					}
					break;

				  case HPRECN:
					if (dptr[i] == FPRCNA) {
						sv = newSVpv("NA", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (dptr[i] == FPRCNC) {
						sv = newSVpv("NC", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (dptr[i] == FPRCND) {
						sv = newSVpv("ND", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else {
						sv = newSVnv(dptr[i]);
						av_push(datarray, sv);
					}
					break;

				  case HBUSNS:
				  case HDAILY:
					if (iptr[i] == FDATNA) {
						sv = newSVpv("NA", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (iptr[i] == FDATNC) {
						sv = newSVpv("NC", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else if (iptr[i] == FDATND) {
						sv = newSVpv("ND", 0);
						sv2 = newRV_noinc(sv);
						av_push(datarray, sv2);
					} else {
						sv = newSViv(iptr[i]);
						av_push(datarray, sv);
					}
					break;

				  default:
					printf("I don't know how to handle that...\n");
					break;
				}
			}
		}

		RETVAL = status;

	OUTPUT:
		RETVAL
		data


#/===========================================================================
#/		cfmgtstr	G e t   A   S i n g l e   S t r i n g   V a l u e
#/===========================================================================
#/		Tested
#/			2001/04/17
#/===========================================================================
#/		The last three variables are there for completeness.  They aren't
#/		needed and, currently, aren't used.
#/===========================================================================
int
perl_Cfmgtstr(dbkey, objnam, range, sv_str, sv_ismiss=0, inlen=0, sv_out=0)
int		dbkey
char	*objnam
SV		*range
SV		*sv_str
SV		*sv_ismiss
int		inlen
SV		*sv_out

	PREINIT:
int		i;
int		worked	=	TRUE;
SV		**svptr;
SV		*sv;
SV		*sv2;
I32		ix;
int		rng[3];
AV		*rngarray;
char	*buff;
char	*str;
int		ismiss;
int		outlen;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid RANGE.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
		} else {
			worked = FALSE;
		}

		if (worked && av_len(rngarray) == 2) {
			for (ix=0; ix<3; ix++) {
				svptr = av_fetch(rngarray, ix, 0);
				rng[ix] = SvIV(*svptr);
			}
#/			----------------------------------------------------------
#/			If there is no range object provided, fake one.  This
#/			might be a scalar which ignores it.
#/			----------------------------------------------------------
		} else {
			rng[0] = 0;
			rng[1] = 0;
			rng[2] = 0;
		}

#/		----------------------------------------------------------------------
#/		Get the length of the item, then get the item.
#/		----------------------------------------------------------------------
		if (inlen == 0) {
			buff = (char *)safemalloc(sizeof(char) * 2);
			cfmgtstr(&status, dbkey, objnam, rng, buff, &ismiss, 1, &inlen);
			worked = (status == HSUCC || status == HTRUNC);
			safefree(buff);
		} else if (inlen < 1) {
			worked = FALSE;
			status = HBLEN;
		}

		if (worked) {
			buff = (char *)safemalloc((inlen +1) * sizeof(char));
			cfmgtstr(&status, dbkey, objnam, rng, buff,
				&ismiss, inlen, &outlen);
			worked = status == HSUCC;
		}

#/		----------------------------------------------------------------------
#/		Now, if Missing Value, set it so, otherwise set the value.
#/		----------------------------------------------------------------------
		if (worked) {
			if (ismiss == HNAVAL) {
				sv = newSVpv("NA", 0);
				sv2 = newRV_noinc(sv);
				sv_setsv(sv_str, sv2);
				SvROK_on(sv_str);
			} else if (ismiss == HNCVAL) {
				sv = newSVpv("NC", 0);
				sv2 = newRV_noinc(sv);
				sv_setsv(sv_str, sv2);
				SvROK_on(sv_str);
			} else if (ismiss == HNDVAL) {
				sv = newSVpv("ND", 0);
				sv2 = newRV_noinc(sv);
				sv_setsv(sv_str, sv2);
				SvROK_on(sv_str);
			} else {
				sv_setpv(sv_str, buff);
			}
		}
		if (*buff) {
			safefree(buff);
		}

		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_str


#/===========================================================================
#/		cfmgtsts	G e t   A   R a n g e   o f   S t r i n g   V a l u e s
#/===========================================================================
#/		Tested
#/			2001/04/17
#/		Missing values passed, but not missing table values.
#/===========================================================================
int
perl_Cfmgtsts(dbkey, objnam, range, data)
int		dbkey
char	*objnam
SV		*range
SV		*data

	PREINIT:
int		i;
int		worked	=	TRUE;
SV		**svptr;
SV		*sv;
SV		*sv2;
I32		ix;
int		rlen;
int		rng[3];
AV		*datarray;
AV		*rngarray;
int		class;
int		type;
int		freq;
int		fyear;
int		fprd;
int		lyear;
int		lprd;
char	**strdata;
int		*inlen;
int		*outlen;
int		*misarray;

	CODE:
#/		----------------------------------------------------------------------
#/		See if we were given a real variable.  If so, clear it out.
#/		----------------------------------------------------------------------
		if (SvROK(data) && (SvTYPE(SvRV(data)) == SVt_PVAV)) {
			datarray = (AV *)SvRV(data);
			av_clear(datarray);

#/		----------------------------------------------------------------------
#/		----------------------------------------------------------------------
		} else {
			datarray = newAV();
			SvREFCNT_dec(data);
			data = newRV_inc((SV *)datarray);
		}

#/		----------------------------------------------------------------------
#/		First, let's see what type of data object we are reading.  We want
#/		to make sure that it is proper.
#/		----------------------------------------------------------------------
		cfmosiz(&status, dbkey, objnam, &class, &type, &freq,
					&fyear, &fprd, &lyear, &lprd);

#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid RANGE.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
		} else {
			status = HBRNG;
			worked = FALSE;
		}

		if (worked && av_len(rngarray) == 2) {
			for (ix=0; ix<3; ix++) {
				svptr = av_fetch(rngarray, ix, 0);
				rng[ix] = SvIV(*svptr);
			}
#/			----------------------------------------------------------
#/			This might be cheating but I believe it is correct...
#/			[0]=freq, [1]=start, [2]=end so [2]-[1] should be nobs - 1.
#/			----------------------------------------------------------
			rlen = rng[2] - rng[1] + 1;
		}

#/		----------------------------------------------------------------------
#/		Next, depending on the type of data that we will be reading...
#/		----------------------------------------------------------------------
		if (worked) {
			worked = type == HSTRNG;
		} else {
			printf("I need a string to use this function!\n");
		}

		if (worked) {
			inlen = (int *)safemalloc(sizeof(int) * rlen);
			outlen = (int *)safemalloc(sizeof(int) * rlen);
			misarray = (int *)safemalloc(sizeof(int) * rlen);
			strdata = (char **)safemalloc(sizeof(char *) * rlen);
			for (i=0; i<rlen; i++) {
				strdata[i] = (char *)safemalloc(sizeof(char) * 2);
				inlen[i] = 1;
			}

#/		----------------------------------------------------------------------
#/		Get the length of elements in fame right now and store in outlen.
#/		----------------------------------------------------------------------
			cfmgtsts(&status, dbkey, objnam, rng, strdata,
				misarray, inlen, outlen);
			worked = status == HSUCC || status == HTRUNC;
		}

#/		----------------------------------------------------------------------
#/		Free any data stored in the data array and reallocate space to match
#/		what FAME needs to store data.  Then, get the data.
#/		----------------------------------------------------------------------
		if (worked) {
			for (i=0; i<rlen; i++) {
				safefree(strdata[i]);
				strdata[i] = (char *)malloc(sizeof(char) * (outlen[i]+1));
			}
			cfmgtsts(&status, dbkey, objnam, rng, strdata,
				misarray, outlen, inlen);
		}

#/		----------------------------------------------------------------------
#/		Next, send the data back.
#/		----------------------------------------------------------------------
		if (worked) {
			for (i=0; i<rlen; i++) {
				switch(misarray[i]) {
				  case HNMVAL:
					sv = newSVpv(strdata[i], 0);
					av_push(datarray, sv);
					break;
				  case HNAVAL:
					sv = newSVpv("NA", 0);
					sv2 = newRV_noinc(sv);
					av_push(datarray, sv2);
					break;
				  case HNCVAL:
					sv = newSVpv("NC", 0);
					sv2 = newRV_noinc(sv);
					av_push(datarray, sv2);
					break;
				  case HNDVAL:
					sv = newSVpv("ND", 0);
					sv2 = newRV_noinc(sv);
					av_push(datarray, sv2);
					break;
				  case HMGVAL:
					printf("I just plopped on a Magic Nullsv\n");
					av_push(datarray, &PL_sv_undef);
					break;
				  default:
					break;
				}
			}
		} else {
			printf("It didn't work.\n");
		}

#/		----------------------------------------------------------------------
#/		----------------------------------------------------------------------
		if (inlen)		{	safefree(inlen);	}
		if (outlen)		{	safefree(outlen);	}
		if (misarray)	{	safefree(misarray);	}
		if (strdata)	{
			for (i=0; i<rlen; i++) {
				safefree(strdata[i]);
			}
			safefree(strdata);
		}

		RETVAL = status;

	OUTPUT:
		RETVAL
		data


#/===========================================================================
#/		cfmrdfm		R e a d   F o r m u l a   S o u r c e
#/===========================================================================
#/		The function 'cfmrdfm' does not currently work.  This is an
#/		outstanding FAME bug (djo 12/7/1999 Release 8.032).
#/===========================================================================
#/	BROKE
#/===========================================================================
int
perl_Cfmrdfm(dbkey, objname, source)
int		dbkey
char	*objname
char	*source		=	NO_INIT

	PREINIT:
char	**dsrc = (char **)source;
char	*localsrc = *dsrc;
int		srclen, famelen, i;
char	buffer[255];

	CODE:
		srclen = 60;	// Just an arbitrary not too long number.

		cfmrdfm(&status, dbkey, objname, buffer, srclen, &famelen);
		if (status == HSUCC) {
			source = newString(buffer);
			printf("Cfmrdfm: (%d) '%s', '%s'\n", famelen, objname, buffer);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		source

#/***************************************************************************
#/***************************************************************************
#/		W r i t i n g   D a t a
#/***************************************************************************
#/***************************************************************************

#/===========================================================================
#/		cfmwrng
#/===========================================================================
#/		Tested	2001/03/16
#/			Numeric, Boolean, Precision, Date
#/===========================================================================
int
perl_Cfmwrng(dbkey, objnam, range, data, miss, table)
int		dbkey
char	*objnam
SV		*range
SV		*data
int		miss
SV		*table

	PREINIT:
int		worked	=	TRUE;
SV		**svptr;
SV		*sv;
I32		ix;
int		len;
int		rlen;
int		xlen;
#
AV		*rngarray;
int		rng[3];
#
AV		*datarray;
int		*iptr;
float	*fptr;
void	*vptr;
#
AV		*tblarray;
int		*mitbl	=	NULL;
float	*mftbl	=	NULL;
double	*mdtbl	=	NULL;
void	*tbl	=	NULL;
#
int		class;
int		type;
int		freq;
int		fyear;
int		fprd;
int		lyear;
int		lprd;
int		missing	=	0;
char	*tempstr;
double	*dptr;

	CODE:
#/		----------------------------------------------------------------------
#/		First, let's see what type of data object we are writing.  This will
#/		affect what we do with the DATA set and the MISSING TABLE stuff.
#/		----------------------------------------------------------------------
		cfmosiz(&status, dbkey, objnam, &class, &type, &freq,
					&fyear, &fprd, &lyear, &lprd);

#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid RANGE.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
		} else {
			status = HBRNG;
			worked = FALSE;
		}

		if (worked && av_len(rngarray) == 2) {
			for (ix=0; ix<3; ix++) {
				svptr = av_fetch(rngarray, ix, 0);
				rng[ix] = SvIV(*svptr);
			}
#/			----------------------------------------------------------
#/			This might be cheating but I believe it is correct...
#/			[0]=freq, [1]=start, [2]=end so [2]-[1] should be nobs - 1.
#/			----------------------------------------------------------
			rlen = rng[2] - rng[1] + 1;
		}

#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid MISSING TABLE.
#/		----------------------------------------------------------------------
		if (worked && miss == HTMIS) {
			if (SvROK(table) && (SvTYPE(SvRV(table)) == SVt_PVAV)) {
				tblarray = (AV *)SvRV(range);
			} else {
				status = HBMISS;
				worked = FALSE;
			}
		}

#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid DATA set.
#/		----------------------------------------------------------------------
		if (worked && SvROK(data) && (SvTYPE(SvRV(data)) == SVt_PVAV)) {
			datarray = (AV *)SvRV(data);
		} else {
			status = HUNEXP;
			worked = FALSE;
		}

		len = av_len(datarray);
		if (worked) {
#/			----------------------------------------------------------
#/			First, we allocate memory based on type.
#/			----------------------------------------------------------
			switch (type) {
			  case HNUMRC:
				fptr = (float *)safemalloc(sizeof(float) * rlen);
				break;
			  case HBOOLN:
				iptr = (int *)safemalloc(sizeof(int) * rlen);
				break;
			  case HPRECN:
				dptr = (double *)safemalloc(sizeof(double) * rlen);
				break;
			  case HBUSNS:
			  case HDAILY:
				iptr = (int *)safemalloc(sizeof(int) * rlen);
				break;
			}

#/			----------------------------------------------------------
#/			Next we get the value and determine if it is missing
#/			or not
#/			----------------------------------------------------------
			for (ix=0; ix<= len; ix++) {
				missing = 0;
				svptr = av_fetch(datarray, ix, 0);
				if (SvROK(*svptr) && (SvTYPE(SvRV(*svptr)) == SVt_PV)) {
					sv = SvRV(*svptr);
					tempstr = SvPV(sv, xlen);
					if (strncmp(tempstr, "NA", 2) == 0) {
						missing = 1;
					} else if (strncmp(tempstr, "NC", 2) == 0) {
						missing = 2;
					} else if (strncmp(tempstr, "ND", 2) == 0) {
						missing = 3;
					} else {
						missing = 4;
					}
				}


#/			----------------------------------------------------------
#/			Next, depending on type, we stuff it into the array.
#/			----------------------------------------------------------
				switch (type) {
				  case HNUMRC:
					switch(missing) {
					  case 0:
						fptr[ix] = SvNV(*svptr);
						break;
					  case 1:
						fptr[ix] = FNUMNA;
						break;
					  case 2:
						fptr[ix] = FNUMNC;
						break;
					  case 3:
						fptr[ix] = FNUMND;
						break;
					  default:
						fptr[ix] = FNUMND;
						printf("Cfmwrng(num): What was that at %d?\n", ix);
						break;
					}
					break;
				  case HBOOLN:
					switch(missing) {
					  case 0:
						iptr[ix] = (SvTRUE(*svptr) ? HYES : HNO);
						break;
					  case 1:
						iptr[ix] = FBOONA;
						break;
					  case 2:
						iptr[ix] = FBOONC;
						break;
					  case 3:
						iptr[ix] = FBOOND;
						break;
					  default:
						iptr[ix] = FBOOND;
						printf("Cfmwrng(bool): What was that at %d?\n", ix);
						break;
					}
					break;
				  case HPRECN:
					switch(missing) {
					  case 0:
						dptr[ix] = SvNV(*svptr);
						break;
					  case 1:
						dptr[ix] = FPRCNA;
						break;
					  case 2:
						dptr[ix] = FPRCNC;
						break;
					  case 3:
						dptr[ix] = FPRCND;
						break;
					  default:
						dptr[ix] = FPRCND;
						printf("Cfmwrng(prec): What was that at %d?\n", ix);
						break;
					}
					break;
				  case HBUSNS:
				  case HDAILY:
					switch(missing) {
					  case 0:
						iptr[ix] = SvIV(*svptr);
						break;
					  case 1:
						iptr[ix] = FDATNA;
						break;
					  case 2:
						iptr[ix] = FDATNC;
						break;
					  case 3:
						iptr[ix] = FDATND;
						break;
					  default:
						iptr[ix] = FDATND;
						printf("Cfmwrng(date): What was that at %d?\n", ix);
						break;
					}
					break;
				}
			}

#/			----------------------------------------------------------
#/			Now, flesh out the rest with NDs and write it.
#/			----------------------------------------------------------
			switch(type) {
			  case HNUMRC:
				for (ix=len+1; ix<rlen; ix++) {
					fptr[ix] = FNUMND;
				}
				cfmwrng(&status, dbkey, objnam, rng, fptr, 
							miss, (float *)tbl);
				break;
			  case HBOOLN:
				for (ix=len+1; ix<rlen; ix++) {
					iptr[ix] = FBOOND;
				}
				cfmwrng(&status, dbkey, objnam, rng, (float *)iptr, 
							miss, (float *)tbl);
				break;
			  case HPRECN:
				for (ix=len+1; ix<rlen; ix++) {
					dptr[ix] = FPRCND;
				}
				cfmwrng(&status, dbkey, objnam, rng, (float *)dptr, 
							miss, (float *)tbl);
				break;
			  case HBUSNS:
			  case HDAILY:
				for (ix=len+1; ix<rlen; ix++) {
					iptr[ix] = FDATND;
				}
				cfmwrng(&status, dbkey, objnam, rng, (float *)iptr, 
							miss, (float *)tbl);
				break;
			  default:
				printf("I don't know how to process '%d'.\n", type);
				break;
			}
#/			----------------------------------------------------------
#/			This might, of course, be valid if you want to write out
#/			a bunch of missing values!
#/			----------------------------------------------------------
		} else {
			printf("You didn't give me any data!\n");
			worked = FALSE;
		}

		switch (type) {
		  case HNUMRC:
			if (fptr) {
				safefree(fptr);
			}
			break;
		  case HPRECN:
			if (dptr) {
				safefree(dptr);
			}
			break;
		  case HBOOLN:
		  case HDATE:
		  case HBUSNS:
		  case HDAILY:
			if (iptr) {
				safefree(iptr);
			}
			break;
		  default:
			printf("I don't know how to process '%d'.\n", type);
			break;
		}
		RETVAL = status;
	OUTPUT:
		RETVAL


#/===========================================================================
#/		cfmwstr
#/===========================================================================
#/		Tested	2001/03/16
#/===========================================================================
int
perl_Cfmwstr(dbkey, objnam, range, val, ismiss, length)
int		dbkey
char	*objnam
SV		*range
char	*val
int		ismiss
int		length

	PREINIT:
int		worked	=	TRUE;
I32		ix;
AV		*rngarray;
int		rng[3];
SV		**svptr;
int		rlen;

	CODE:
#/		----------------------------------------------------------------------
#/		First, check to see if we have been given a valid RANGE.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
		} else {
			worked = FALSE;
		}

		if (worked && av_len(rngarray) == 2) {
			for (ix=0; ix<3; ix++) {
				svptr = av_fetch(rngarray, ix, 0);
				rng[ix] = SvIV(*svptr);
			}
#/			----------------------------------------------------------
#/			This might be cheating but I believe it is correct...
#/			[0]=freq, [1]=start, [2]=end so [2]-[1] should be nobs - 1.
#/			----------------------------------------------------------
			rlen = rng[2] - rng[1] + 1;
#/			----------------------------------------------------------
#/			If it wasn't a valid range object it may be because we
#/			going to write to a scalar.  Create an empty range object.
#/			----------------------------------------------------------
		} else {
			for (ix=0; ix<3; ix++) {
				rng[ix] = 0;
			}
		}

		cfmwstr(&status, dbkey, objnam, rng, val, ismiss, length);
		RETVAL = status;
	OUTPUT:
		RETVAL


#/===========================================================================
#/		cfmwsts
#/===========================================================================
#/	UNDER CONSTRUCTION
#/===========================================================================
int
perl_Cfmwsts(dbkey, objnam, range, data)
int		dbkey
char	*objnam
SV		*range
SV		*data

	PREINIT:
int		worked	=	TRUE;
int		rng[3];
AV		*rngarray;
char	**saray;
char	*sptr;
int		*lptr;
int		xlen;
char	*str;
I32		ix;
int		len;
int		rlen;
SV		**svptr;
SV		*sv;
AV		*datarray;
int		*iptr;
char	*tempstr;
int		missing;

	CODE:
#/		----------------------------------------------------------------------
#/		Check to see if we have been given a valid RANGE.
#/		----------------------------------------------------------------------
		if (SvROK(range) && (SvTYPE(SvRV(range)) == SVt_PVAV)) {
			rngarray = (AV *)SvRV(range);
		} else {
			status = HBRNG;
			worked = FALSE;
		}

		if (worked && av_len(rngarray) == 2) {
			for (ix=0; ix<3; ix++) {
				svptr = av_fetch(rngarray, ix, 0);
				rng[ix] = SvIV(*svptr);
			}
#/			----------------------------------------------------------
#/			This might be cheating but I believe it is correct...
#/			[0]=freq, [1]=start, [2]=end so [2]-[1] should be nobs - 1.
#/			----------------------------------------------------------
			rlen = rng[2] - rng[1] + 1;
		}

#/		----------------------------------------------------------------------
#/		Next, we need to see if we have data and "dereference" it.
#/		----------------------------------------------------------------------
		if (worked && SvROK(data) && (SvTYPE(SvRV(data)) == SVt_PVAV)) {
			datarray = (AV *)SvRV(data);
			len = av_len(datarray);
		} else {
			status = HUNEXP;
		}

#/		----------------------------------------------------------------------
#/		If we have data, let's see what we can do with it...
#/		----------------------------------------------------------------------
		if (worked) {
			saray = (char **)safemalloc(sizeof(char *) * rlen);
			iptr = (int *)safemalloc(sizeof(int) * rlen);
			lptr = (int *)safemalloc(sizeof(int) * rlen);

			for (ix=0; ix<= len; ix++) {
				missing = 0;
				svptr = av_fetch(datarray, ix, 0);
				if (SvROK(*svptr) && (SvTYPE(SvRV(*svptr)) == SVt_PV)) {
 					sv = SvRV(*svptr);
 					tempstr = SvPV(sv, xlen);
 					if (strncmp(tempstr, "NA", 2) == 0) {
 						missing = 1;
 					} else if (strncmp(tempstr, "NC", 2) == 0) {
 						missing = 2;
 					} else if (strncmp(tempstr, "ND", 2) == 0) {
 						missing = 3;
 					} else {
 						missing = 4;
 					}
				}
				if (missing == 0) {
					str = SvPV(*svptr, xlen);
					saray[ix] = newString(str);
					iptr[ix] = HNMVAL;
					lptr[ix] = xlen;
				} else {
					saray[ix] = (char *)safemalloc((HSMLEN+1) * sizeof(char));
					saray[ix][HSMLEN] = '\0';
					switch(missing) {
					  case 1:
						iptr[ix] = HNAVAL;
						lptr[ix] = 2;
						strncpy(saray[ix], FSTRNA, HSMLEN);
						break;
					  case 2:
						iptr[ix] = HNCVAL;
						lptr[ix] = 2;
						strncpy(saray[ix], FSTRNC, HSMLEN);
						break;
					  case 3:
						iptr[ix] = HNDVAL;
						lptr[ix] = 2;
						strncpy(saray[ix], FSTRND, HSMLEN);
						break;
					  default:
						strncpy(saray[ix], FSTRND, HSMLEN);
						iptr[ix] = HNDVAL;
						lptr[ix] = 2;
						printf("Cfmwsts: What was that at %d?\n", ix);
						break;
					}
				}
			}
			for (ix=len+1; ix<rlen; ix++) {
				saray[ix] = (char *)safemalloc((HSMLEN+1) * sizeof(char));
				sptr = saray[ix];
				strncpy(sptr, (FSTRNA), (HSMLEN));
				iptr[ix] = HNDVAL;
				lptr[ix] = 2;
			}
			cfmwsts(&status, dbkey, objnam, rng, saray, iptr, lptr);

			for (ix=len+1; ix<rlen; ix++) {
				safefree(saray[ix]);
			}
			safefree(saray);
			safefree(iptr);
			safefree(lptr);
		}

		RETVAL = status;
	OUTPUT:
		RETVAL


#/===========================================================================
#/		cfmwtnl
#/===========================================================================
int
perl_Cfmwtnl(dbkey, objnam, idx, val)
int		dbkey
char	*objnam
int		idx
char	*val

	CODE:
		cfmwtnl(&status, dbkey, objnam, idx, val);
		RETVAL = status;
	OUTPUT:
		RETVAL


#/===========================================================================
#/		cfmwrmt
#/===========================================================================
#/		Untested and not implemented
#/===========================================================================
int
perl_Cfmwrmt(dbkey, objnam, objtyp, rng, data, miss, tbl)
int		dbkey
char	*objnam
int		objtyp
double	rng
double	data
int		miss
double	tbl

	CODE:
		status = -1;
#		cfmwrmt(&status, dbkey, objnam, objtyp, (int *)rng,
#				(float *)(data->data), miss, (float *)tbl->tbl);
		RETVAL = status;

	OUTPUT:
		RETVAL


#/***************************************************************************
#/***************************************************************************
#/		C o n v e r t i n g   D a t e s
#/***************************************************************************
#/***************************************************************************

#/===========================================================================
#/		cfmtdat
#/===========================================================================
int
perl_Cfmtdat(freq, date, hour, minute, second, ddate)
int		freq
int		date		=	NO_INIT
int		hour
int		minute
int		second
int		ddate

	CODE:
		cfmtdat(&status, freq, &date, hour, minute, second, ddate);
		RETVAL = status;
	OUTPUT:
		RETVAL
		date


#/===========================================================================
#/		cfmdatt
#/===========================================================================
int
perl_Cfmdatt(freq, date, hour, minute, second, ddate)
int freq
int date
int hour		=	NO_INIT
int minute		=	NO_INIT
int second		=	NO_INIT
int ddate		=	NO_INIT

	CODE:
		cfmdatt(&status, freq, date, &hour, &minute, &second, &ddate);
		RETVAL = status;
	OUTPUT:
		RETVAL
		hour
		minute
		second
		ddate


#/===========================================================================
#/		cfmddat
#/===========================================================================
int
perl_Cfmddat(freq, date, year, month, day)
int		freq
int		date		=	NO_INIT
int		year
int		month
int		day

	CODE:
		cfmddat(&status, freq, &date, year, month, day);
		RETVAL = status;
	OUTPUT:
		RETVAL
		date


#/===========================================================================
#/		cfmdatd
#/===========================================================================
#/		Tested
#/===========================================================================
int
perl_Cfmdatd(freq, date, year, month, day)
int		freq
int		date
int		year
int		month	=	NO_INIT
int		day		=	NO_INIT

	CODE:
		cfmdatd(&status, freq, date, &year, &month, &day);
		RETVAL = status;
	OUTPUT:
		RETVAL
		year
		month
		day


#/===========================================================================
#/		cfmpdat
#/===========================================================================
int
perl_Cfmpdat(freq, date, year, period)
int		freq
int		date		=	NO_INIT
int		year
int		period

	CODE:
		cfmpdat(&status, freq, &date, year, period);
		RETVAL = status;
	OUTPUT:
		RETVAL
		date


#/===========================================================================
#/		cfmdatp
#/===========================================================================
int
perl_Cfmdatp(freq, date, year, period)
int		freq
int		date
int		year		=	NO_INIT
int		period		=	NO_INIT

	CODE:
		cfmdatp(&status, freq, date, &year, &period);
		RETVAL = status;
	OUTPUT:
		RETVAL
		year
		period


#/===========================================================================
#/		cfmfdat
#/===========================================================================
int
perl_Cfmfdat(freq, date, year, period, fmonth=HDEC, flabel=HFYFST)
int freq
int date		=	NO_INIT
int year
int period
int fmonth
int flabel

	CODE:
		cfmfdat(&status, freq, &date, year, period, fmonth=HDEC, flabel=HFYFST);
		RETVAL = status;
	OUTPUT:
		RETVAL
		date


#/===========================================================================
#/		cfmdatf
#/===========================================================================
int
perl_Cfmdatf(freq, date, year, period, fmonth, flabel)
int		freq
int		date
int		year		=	NO_INIT
int		period		=	NO_INIT
int		fmonth
int		flabel

	CODE:
		cfmdatf(&status, freq, date, &year, &period, fmonth=HDEC, flabel=HFYFST);
		RETVAL = status;
	OUTPUT:
		RETVAL
		year
		period


#/===========================================================================
#/		cfmldat
#/===========================================================================
#/		Tested
#/===========================================================================
int
perl_Cfmldat(freq, date, datestr, month=HDEC, label=HFYFST, century=DEF_CENT)
int		freq
int		date	=	NO_INIT
char	*datestr
int		month
int		label
int		century

	CODE:
		cfmldat(&status, freq, &date, datestr, month, label, century);
		RETVAL = status;
	OUTPUT:
		RETVAL
		date


#/===========================================================================
#/		cfmdatl
#/===========================================================================
int
perl_Cfmdatl(freq, date, datestr, month=HDEC, label=HFYFST)
int		freq
int		date
char	*datestr	=	NO_INIT
int		month
int		label

	PREINIT:
char	buf[SMALLBUF];

	CODE:
		cfmdatl(&status, freq, date, buf, month, label);
		if (status == HSUCC) {
			datestr = newString(buf);
		}
		RETVAL = status;
	OUTPUT:
		RETVAL
		datestr


#/===========================================================================
#/		cfmidat
#/===========================================================================
int
perl_Cfmidat(freq, date, datestr, image="<YEAR>/<MZ>/<DZ>", month=HDEC, label=HFYFST, century=DEF_CENT)
int		freq
int		date	=	NO_INIT
char	*datestr
char	*image
int		month
int		label
int		century

	CODE:
		cfmidat(&status, freq, &date, datestr, image, month, label, century);
		RETVAL = status;
	OUTPUT:
		RETVAL
		date


#/===========================================================================
#/		cfmdati
#/===========================================================================
int
perl_Cfmdati(freq, date, datestr, image="<YEAR>/<MZ>/<DZ>", month=HDEC, label=HFYFST)
int		freq
int		date
char	*datestr	=	NO_INIT
char	*image
int		month
int		label

	PREINIT:
char	buf[SMALLBUF];

	CODE:
		cfmdati(&status, freq, date, buf, image, month, label);
		if (status == HSUCC) {
			datestr = newString(buf);
		}
		RETVAL = status;

	OUTPUT:
		RETVAL
		datestr


#/***************************************************************************
#/***************************************************************************
#/		U s i n g   t h e   F A M E  / S e r v e r
#/***************************************************************************
#/***************************************************************************

#/===========================================================================
#/		cfmfame
#/===========================================================================
int
perl_Cfmfame(command)
char	*command

	CODE:
		cfmfame(&status, command);
		RETVAL = status;
	OUTPUT:
		RETVAL

#/===========================================================================
#/		cfmopwk
#/===========================================================================
int
perl_Cfmopwk(dbkey)
int		dbkey		=	NO_INIT

	CODE:
		cfmopwk(&status, &dbkey);
		RETVAL = status;

	OUTPUT:
		RETVAL
		dbkey

#/===========================================================================
#/		cfmsinp
#/===========================================================================
int
perl_Cfmsinp(cmd) 
char	*cmd

	CODE:
char	**dcmd = (char **)cmd;
char	buffer[HMAXSCMD];

		cfmsinp(&status, buffer);
		safefree(*dcmd);
		*dcmd = newString(buffer);
		RETVAL = status;

	OUTPUT:
		RETVAL

#/***************************************************************************
#/***************************************************************************
#/		U s i n g   a n   A n a l y t i c a l  C h a n n e l
#/***************************************************************************
#/***************************************************************************

#/===========================================================================
#/		cfmoprc
#/===========================================================================
int
perl_Cfmoprc(dbkey, connkey)
int		dbkey		=	NO_INIT
int		connkey

	CODE:
		cfmoprc(&status, &dbkey, connkey);
		RETVAL = status;

	OUTPUT:
		RETVAL
		dbkey


#/===========================================================================
#/		cfmopre
#/===========================================================================
int
perl_Cfmopre(dbkey, svname)
int		dbkey		=	NO_INIT
char	*svname

	CODE:
		cfmopre(&status, &dbkey, svname);
		RETVAL = status;

	OUTPUT:
		RETVAL
		dbkey


#/===========================================================================
#/		cfmrmev
#/===========================================================================
int
perl_Cfmrmev(dbkey, expr, optns, wdbkey, objnam)
int		dbkey
char	*expr
char	*optns
int		wdbkey
char	*objnam

	CODE:
		cfmrmev(&status, dbkey, expr, optns, wdbkey, objnam);
		RETVAL = status;

	OUTPUT:
		RETVAL


#/===========================================================================
#/		cfmferr
#/===========================================================================
#/		???
#/===========================================================================
int
perl_Cfmferr(errtxt)
char	*errtxt		=	NO_INIT

	PREINIT:
int		i;
char	buf[BIGBUF+1];

	CODE:
		for (i=0; i<BIGBUF; i++) {
			buf[i] = ' ';
		}
		buf[BIGBUF] = '\0';
		cfmferr(&status, buf);
		for (i=BIGBUF-1; buf[i] == ' '; i--) {
			buf[i] = '\0';
		}
		errtxt = newString(buf);
		RETVAL = status;

	OUTPUT:
		RETVAL
		errtxt


#/===========================================================================
#/		cfmlerr
#/===========================================================================
#/		???
#/===========================================================================
int
perl_Cfmlerr(sv_len)
SV		*sv_len

	PREINIT:
int		errlen;

	CODE:
		cfmlerr(&status, &errlen);
		sv_setiv(sv_len, errlen);
		RETVAL = status;

	OUTPUT:
		RETVAL
		sv_len

