#=============================================================================
#	File:	06_DbInfoAttr.t
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	Testing file for FameHLI functions
#	Editor:	vi with tabstops=4
#=============================================================================
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..12\n"; }
END {print "not ok 1\n" unless $loaded;}
$loaded = 1;
print "ok 1\n";
$| = 1;

######################### End of black magic.

use		FameHLI::API ':all';
use		FameHLI::API::EXT ':all';
use		FameHLI::API::HLI ':all';
require("./t/subs.pm");

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
		ShowResults($log, 1,0,"cfmini", Cfmini());
		ShowResults($log, 1,0,"cfmopdb(u)", Cfmopdb($dbkey, "testdb", HUMODE));

;#		------------------------------------------------------------
		printf($log "--> Handling Database Information and Attributes\n");
;#		------------------------------------------------------------
my		$deslen;
my		$doclen;
my		$image = "<YEAR>/<MZ>/<DZ>";

		ShowResults($log, 1,0,"cfmddes", 
			Cfmddes($dbkey, "Test Database Description $$"));
		ShowResults($log, 1,0,"cfmddoc", 
			Cfmddoc($dbkey, "Test Database Documentation $$"));
		ShowResults($log, 1,0,"cfmpodb", Cfmpodb($dbkey));
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmopdb", Cfmopdb($dbkey, "testdb", HUMODE));
		ShowResults($log, 1,0,"cfmgdba", 
			Cfmgdba($dbkey, $cyear, $cmonth, $cday,
						$myear, $mmonth, $mday, $desc, $doc),
			"%s/%s/%s -- %s/%s/%s)\n\t(Desc: '%s')\n\t(Doc: '%s'",
			$cyear, $cmonth, $cday, $myear, $mmonth, $mday, $desc, $doc);
		ShowResults($log, 1,0,"cfmgdbd", 
			Cfmgdbd($dbkey, HBUSNS, $cdate, $mdate),
			"%s, %s", 
				FormatDate($cdate, HBUSNS), 
				FormatDate($mdate, HBUSNS));

		ShowResults($log, 1,0,"cfmglen", 
			Cfmglen($dbkey, $deslen, $doclen),
			"Des:%d, Doc:%d", $deslen, $doclen);

		ShowResults($log, 1,0,"cfmfin", Cfmfin());
}
