#=============================================================================
#	File:	14_ConvDates.t
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
my		$rc;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("14_ConvDates");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Converting Dates\n");
;#		------------------------------------------------------------
;#		This first variable is a little iffy... It should be set 
;#		somewhere where we can make sure that it is valid...
;#		------------------------------------------------------------
		{
my			$date		=	0;
my			$intradate	=	54000;
my			$hour		=	12;
my			$minute		=	30;
my			$second		=	15;

			ShowResults($log, 1,0,"cfmtdat", 
				FameHLI::API::Cfmtdat(HSEC, $date, 
					$hour, $minute, $second, $intradate),
				$date);

			ShowResults($log, 1,0,"cfmdatt", 
				FameHLI::API::Cfmdatt(HSEC, $date, 
					$hour, $minute, $second, $intradate),
				"%s, %s:%s:%s", $intradate, $hour, $minute, $second);
		}
;#		------------------------------------------------------------
		{
my			$date = 0;
my			$year = 0;
my			$month = 0;
my			$day = 0;

			ShowResults($log, 1,0,"cfmddat", 
				FameHLI::API::Cfmddat(HBUSNS, $date, 1999, 9, 1),
							$date);

			ShowResults($log, 1,0,"cfmdatd", 
				FameHLI::API::Cfmdatd(HBUSNS, $date, 
					$year, $month, $day),
				"%s/%s/%s", $year, $month, $day);

;#		------------------------------------------------------------
my			$xyear = 0;
my			$xperiod = 0;

			ShowResults($log, 0,0,"cfmpdat", 999);
			ShowResults($log, 0,0,"cfmdatp", 999);
			ShowResults($log, 0,0,"cfmfdat", 999);
			ShowResults($log, 0,0,"cfmdatf", 999);
		}
;#		------------------------------------------------------------
;#		------------------------------------------------------------
		{
my			$date = 0;
my			$year = 0;
my			$month = 0;
my			$day = 0;

			ShowResults($log, 1,0,"cfmldat", 
				FameHLI::API::Cfmldat(HBUSNS, $date, "1sep1999",
									HDEC, HFYFST, 1999), $date);

			ShowResults($log, 1,0,"cfmdatl", 
				FameHLI::API::Cfmdatl(HBUSNS, $date, $datestr,
									HDEC, HFYFST),
				$datestr);
		}
;#		------------------------------------------------------------

		{
my			$image = "<YEAR>/<MZ>/<DZ>";

			ShowResults($log, 1,0,"cfmidat", 
				FameHLI::API::Cfmidat(HBUSNS, $date, "1999/09/01",
						$image, HDEC, HFYFST), $date);

			ShowResults($log, 1,0,"cfmdati", 
				FameHLI::API::Cfmdati(HBUSNS, $date, $datestr, $image, 
						HDEC, HFYFST), 
				$datestr);
		}

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}

