#=============================================================================
#	File:	17_Misc.t
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

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("17_Misc");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Getting FAME Errors\n");
;#		------------------------------------------------------------
		ShowResults($log, 1,HFAMER,"cfmfame", FameHLI::API::Cfmfame("fred is here"));
		ShowResults($log, 0,HSUCC,"cfmferr", 0, FameHLI::API::Cfmferr($msg), $msg);
		ShowResults($log, 0,HSUCC,"cfmlerr", 999);

my		$db = $vars->{spindex};
my		$datstr = $vars->{spindate};
my		$date;

		print($log "DB:'$db'\nDate:$datstr\n");

		if ($db) {
			ShowResults($log, 1,HSUCC,"Cfmopdb",
				FameHLI::API::Cfmopdb($dbkey, $db, HRMODE));

my			($syear, $sprd, $eyear, $eprd, $numobs) = (-1, -1, -1, -1, 1);
my			$divisor;
my			$nada;
my			$range;

			ShowResults($log, 1,HSUCC,"Cfmidat",
				FameHLI::API::Cfmidat(HBUSNS, $date, $datstr, "<YEAR><MZ><DZ>",
								HDEC, HFYFST, 2000), "%s (%d)", $datstr, $date);

			ShowResults($log, 1,HSUCC,"Cfmdatp",
				FameHLI::API::Cfmdatp(HBUSNS, $date, $syear, $sprd),
					"%d (%d:%d)", $date, $syear, $sprd);

			ShowResults($log, 1,HSUCC,"Cfmsrng",
				FameHLI::API::Cfmsrng(HBUSNS, $syear, $sprd,
								$eyear, $eprd, $range, $numobs));

			ShowResults($log, 1,HSUCC,"Cfmrrng",
				FameHLI::API::Cfmrrng($dbkey, "SP500.DIVISOR", $range,
						$divisor, HNTMIS, $nada),
						"Divisor is %3.3f", $divisor->[0]);

			ShowResults($log, 1,0,"cfmcldb", FameHLI::API::Cfmcldb($dbkey));
		} else {
			print($log "Start -- Skipping SPINDEX test\n");
			for (my $i=0; $i<6; $i++) {
				printf("ok %d\n", ++$test::num);
				printf($log "skipped %d\n", $test::num);
			}
			print($log "End ---- Skipping SPINDEX test\n");
		}

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}

