#=============================================================================
#	File:	15_FameServer.t
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
my		$vars			=	GetVars();
my		$rc;
my		$work;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$class;
my		$type;
my		$freq;
my		$eyear;
my		$eprd;
my		$fyear;
my		$fprd;
my		$lyear;
my		$lprd;
my		$syear;
my		$sprd;
my		$cdate;
my		$mdate;
my		$basis;
my		$observ;
my		$cyear;
my		$cmonth;
my		$cday;
my		$myear;
my		$mmonth;
my		$mday;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("15_FameServer");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Using the FAME/Server\n");
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmopwk", FameHLI::API::Cfmopwk($work));
		ShowResults($log, 1,0,"cfmfame", 
			FameHLI::API::Cfmfame("fred = today"));
		ShowResults($log, 1,0,"cfmwhat",
			FameHLI::API::Cfmwhat($work, "fred",
				$class, $type, $freq, $basis, $observ,
				$fyear, $fprd, $lyear, $lprd,
				$cyear, $cmonth, $cday,
				$myear, $mmonth, $mday,
				$desc, $doc),
			"%s, %s, %s, %s, %s,\n"
				. "\t\t%s, %s, %s, %s,\n"
				. "\t\t%s/%s/%s,\n"
				. "\t\t%s/%s/%s,\n"
				. "\t\t%s, %s",
			FameHLI::API::EXT::ClassDesc($class),
			FameHLI::API::EXT::TypeDesc($type),
			FameHLI::API::EXT::FreqDesc($freq),
			FameHLI::API::EXT::BasisDesc($basis),
			FameHLI::API::EXT::ObservedDesc($observ),
			$lyear, $fprd, $lyear, $lprd,
			$cyear, $cmonth, $cday, $myear, $mmonth, $mday,
			$desc, $doc);

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}

