#=============================================================================
#	File:	11_Wildcards.t
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

BEGIN { $| = 1; print "1..30\n"; }
END {print "not ok 1\n" unless $loaded;}
use FameHLI::API;
use FameHLI::API::EXT;
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

my		$class;
my		$dbkey;
my		$freq;
my		$rc;
my		$str;
my		$type;

;#		------------------------------------------------------------
my		$tmpstr;
my		$log = StartTest("11_Wildcards");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmopdb(u)", 
			FameHLI::API::Cfmopdb($dbkey, "testdb", HUMODE));


;#		------------------------------------------------------------
		printf($log "--> Wildcarding\n");
;#		------------------------------------------------------------

		ShowResults($log, 1,0,"cfmpodb", FameHLI::API::Cfmpodb($dbkey));

			$rc = FameHLI::API::Cfminwc($dbkey, "?");
			ShowResults($log, 1,0,"cfminwc", $rc, "?");
			while ($rc != HNOOBJ) {
				$rc = FameHLI::API::Cfmnxwc($dbkey, $str, $class, $type, $freq); 
				if ($rc == HNOOBJ) {
					ShowResults($log, 0,HNOOBJ, ,"cfmnxwc", $rc,
						"End of list");
				} else {
					ShowResults($log, 1,0,"cfmgnam",
						FameHLI::API::Cfmgnam($dbkey, $str, $tmpstr),
						"Realname is '$tmpstr'");
					ShowResults($log, 0,0,"cfmnxwc", $rc,
						"'%s' (%s) %s, %s, %s", 
						$str,
						$tmpstr,
						FameHLI::API::EXT::ClassDesc($class),
						FameHLI::API::EXT::TypeDesc($type),
						FameHLI::API::EXT::FreqDesc($freq));
				}
			}

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmcldb", FameHLI::API::Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}

