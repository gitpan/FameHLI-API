#=============================================================================
#	File:	02_SetOptions.t
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

BEGIN { $| = 1; print "1..4\n"; }
END {print "not ok 1\n" unless $loaded;}
use FameHLI::API;
use	FameHLI::API::HLI ':all';
$loaded = 1;
print "ok 1\n";
$| = 1;
require("./t/subs.pm");

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

		$test::num	=	0;
		$test::num	=	1;
my		$err		=	0;
my		$warn		=	0;
		$| = 1;

{
my		$log = StartTest("02_SetOptions");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmsopt", FameHLI::API::Cfmsopt("Item Alias", "on"));
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}
