#=============================================================================
#	File:	05_Databases.t
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

BEGIN { $| = 1; print "1..6\n"; }
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
my		$dbkey;
my		$rc;

;#		------------------------------------------------------------
my		$log = StartTest("05_Databases");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Handling Databases\n");
;#		------------------------------------------------------------
		unlink("testdb.db");
		ShowResults($log, 1,0,"cfmopdb(c)", 
			FameHLI::API::Cfmopdb($dbkey, "testdb", HCMODE));
		ShowResults($log, 1,0,"cfmcldb", FameHLI::API::Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmopdb(u)", 
			FameHLI::API::Cfmopdb($dbkey, "testdb", HUMODE));
		ShowResults($log, 0,0,"cfmrsdb", 999);
		ShowResults($log, 0,0,"cfmpack", 999);
		ShowResults($log, 0,0,"cfmopdc", 999);

		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}
