#=============================================================================
#	File:	07_DataObjects.t
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	Testing file for FameHLI functions
#=============================================================================
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..11\n"; }
END {print "not ok 1\n" unless $loaded;}
use FameHLI::API;
use	FameHLI::API::HLI ':all';
$loaded = 1;
print "ok 1\n";
$| = 1;
require("./t/subs.pm");

######################### End of black magic.

		$test::num	=	0;
		$test::num	=	1;
my		$err		=	0;
my		$warn		=	0;

{
my		$vars			=	GetVars();
my		$dbkey;
my		$host			=	$vars->{hostname};
my		$pwd			=	$vars->{password};
my		$rbkey;
my		$rc;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$strname = "teststr";
my		$numname = "testnum";
my		$precname = "testprec";
my		$datename = "testdate";
my		$boolname = "testbool";

my		$log = StartTest("07_DataObjects");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmopdb(u)", 
			FameHLI::API::Cfmopdb($dbkey, "testdb", HUMODE));

;#		------------------------------------------------------------
		printf($log "--> Handling Data Objects\n");
;#		------------------------------------------------------------
my		$firstname = "testobj";
my		$secondname = "testobj2";
my		$thirdname = "finalobj";
my		$aliases = "{alias1,alias2}";
my		$len;
my		$image = "<YEAR>/<MZ>/<DZ>";

		ShowResults($log, 1,0,"cfmnwob(n)", 
			FameHLI::API::Cfmnwob($dbkey, $firstname, HSERIE, HBUSNS, HNUMRC,
								HBSDAY, HOBEND));
		ShowResults($log, 1,0,"cfmnwob(s)", 
			FameHLI::API::Cfmnwob($dbkey, $strname, HSCALA, HUNDFX, HSTRNG,
								HBSUND, HOBUND));
		ShowResults($log, 0,0,"cfmalob", 999);
		ShowResults($log, 1,0,"cfmcpob", 
			FameHLI::API::Cfmcpob($dbkey, $dbkey, $firstname, $secondname));
		ShowResults($log, 1,0,"cfmdlob",
			FameHLI::API::Cfmdlob($dbkey, $firstname));
		ShowResults($log, 1,0,"cfmrnob",
			FameHLI::API::Cfmrnob($dbkey, $secondname, $thirdname));

		ShowResults($log, 0,0,"cfmasrt", 999);

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmpodb", FameHLI::API::Cfmpodb($dbkey));
		ShowResults($log, 1,0,"cfmcldb", FameHLI::API::Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}
