#=============================================================================
#	File:	09_Dates.t
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

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("09_Dates");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Handling Dates\n");
;#		------------------------------------------------------------
my		$date;

		ShowResults($log, 0,0,"cfmfdiv", 999);

		ShowResults($log, 1,0,"cfmtody", 
			FameHLI::API::Cfmtody(HBUSNS, $date),
			FameHLI::API::EXT::FormatDate($date, HBUSNS));

my		$freq2	=	0;
my		$base	=	HSEC;
my		$nunits	=	10;
		$year	=	0;
		$month	=	0;

		ShowResults($log, 0,0,"cfmpind", 999);
		ShowResults($log, 0,0,"cfmpinm", 999);
		ShowResults($log, 0,0,"cfmpiny", 999);
		ShowResults($log, 0,0,"cfmwkdy", 999);
		ShowResults($log, 0,0,"cfmbwdy", 999);
		ShowResults($log, 0,0,"cfmislp", 999);
		ShowResults($log, 0,0,"cfmchfr", 999);

		ShowResults($log, 1,0,"cfmpfrq", 
			FameHLI::API::Cfmpfrq($freq2, $base, $nunits, $year, $month),
				"%s '%s'", $freq2, FameHLI::API::EXT::FreqDesc($freq2));

		ShowResults($log, 1,0,"cfmufrq", 
			FameHLI::API::Cfmufrq($freq2, $base, $nunits, $year, $month),
			"%s, %s, %s, %s", FameHLI::API::EXT::FreqDesc($base),
			$nunits, $year, $month);

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}

