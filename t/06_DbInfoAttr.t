#=============================================================================
#	File:	06_DbInfoAttr.t
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

BEGIN { $| = 1; print "1..12\n"; }
END {print "not ok 1\n" unless $loaded;}
use FameHLI::API;
use	FameHLI::API::EXT;
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
my		$dbkey;
my		$rc;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("06_DbInfoAttr");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());
		ShowResults($log, 1,0,"cfmopdb(u)", 
			FameHLI::API::Cfmopdb($dbkey, "testdb", HUMODE));

;#		------------------------------------------------------------
		printf($log "--> Handling Database Information and Attributes\n");
;#		------------------------------------------------------------
my		$deslen;
my		$doclen;
my		$image = "<YEAR>/<MZ>/<DZ>";

		ShowResults($log, 1,0,"cfmddes", 
			FameHLI::API::Cfmddes($dbkey, "Test Database Description $$"));
		ShowResults($log, 1,0,"cfmddoc", 
			FameHLI::API::Cfmddoc($dbkey, "Test Database Documentation $$"));
		ShowResults($log, 1,0,"cfmpodb", FameHLI::API::Cfmpodb($dbkey));
		ShowResults($log, 1,0,"cfmcldb", FameHLI::API::Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmopdb", 
			FameHLI::API::Cfmopdb($dbkey, "testdb", HUMODE));
		ShowResults($log, 1,0,"cfmgdba", 
			FameHLI::API::Cfmgdba($dbkey, $cyear, $cmonth, $cday,
						$myear, $mmonth, $mday, $desc, $doc),
			"%s/%s/%s -- %s/%s/%s)\n\t(Desc: '%s')\n\t(Doc: '%s'",
			$cyear, $cmonth, $cday, $myear, $mmonth, $mday, $desc, $doc);
		ShowResults($log, 1,0,"cfmgdbd", 
			FameHLI::API::Cfmgdbd($dbkey, HBUSNS, $cdate, $mdate),
			"%s, %s", 
				FameHLI::API::EXT::FormatDate($cdate, HBUSNS), 
				FameHLI::API::EXT::FormatDate($mdate, HBUSNS));

		ShowResults($log, 1,0,"cfmglen", 
			FameHLI::API::Cfmglen($dbkey, $deslen, $doclen),
			"Des:%d, Doc:%d", $deslen, $doclen);

		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}
