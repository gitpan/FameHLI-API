#=============================================================================
#	File:	17_Misc.t
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	Testing file for FameHLI functions
#	Editor:	vi with tabstops=4
#=============================================================================
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..19\n"; }
END {print "not ok 1\n" unless $loaded;}
$loaded = 1;
print "ok 1\n";
$| = 1;

######################### End of black magic.

use		FameHLI::API ':all';
use		FameHLI::API::HLI ':all';
require("./t/subs.pm");

		$test::num	=	0;
		$test::num	=	1;
my		$err		=	0;
my		$warn		=	0;

{
my		$vars			=	GetVars();
my		$datstr = $vars->{spindate};
my		$db = $vars->{spindex};
my		$dbkey;
my		$host			=	$vars->{hostname};
my		$service		=	$vars->{service};

;#		------------------------------------------------------------
;#		Start things off by opening the log and initialzing Fame.
;#		------------------------------------------------------------
my		$log = StartTest("17_Misc");
		ShowResults($log, 1,0,"cfmini", Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Getting FAME Errors\n");
;#		------------------------------------------------------------
;#		First, let's load up the return codes...
;#		------------------------------------------------------------
		$r1 = Cfmfame("fred is here");
		$r2 = Cfmlerr($len);
		$r3 = Cfmferr($msg);

;#		------------------------------------------------------------
;#		Print out the messages and, whazzup? No error length!
;#		------------------------------------------------------------
		ShowResults($log, 1,HFAMER,"cfmfame", $r1, "Failed properly");
		ShowResults($log, 1,HSUCC,"cfmlerr", $r2, $len);
		ShowResults($log, 1,HSUCC,"cfmferr", $r3, $msg);

;#		------------------------------------------------------------
;#		Now, open some stuff so we can use remeval...
;#		------------------------------------------------------------
		ShowResults($log, 1,HSUCC,"cfmopre", 
			Cfmopre($dbkey, "$service\@$host"));
		ShowResults($log, 1,HSUCC,"cfmopdb", 
			Cfmopdb($wdbkey, "testdb", HUMODE));

;#		------------------------------------------------------------
;#		Load up a new batch of return codes...
;#		------------------------------------------------------------
		$r1 = Cfmrmev($dbkey, "fred is here", "", $wdbkey, "fred");
		$r2 = Cfmlerr($len);
		$r3 = Cfmferr($msg);

;#		------------------------------------------------------------
;#		Print out the messages and voila! we have an error length!
;#		------------------------------------------------------------
		ShowResults($log, 1,HFAMER,"cfmrmev", $r1, "Failed properly");
		ShowResults($log, 1,HSUCC,"cfmlerr", $r2, $len);
		ShowResults($log, 1,HSUCC,"cfmferr", $r3, $msg);

;#		------------------------------------------------------------
;#		Now, let's clean up after ourselves.
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($wdbkey));
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$date;

		print($log "DB:'$db'\nDate:$datstr\n");

		if ($db) {
			ShowResults($log, 1,HSUCC,"Cfmopdb",
				Cfmopdb($dbkey, $db, HRMODE));

my			($syear, $sprd, $eyear, $eprd, $numobs) = (-1, -1, -1, -1, 1);
my			$divisor;
my			$nada;
my			$range;

			ShowResults($log, 1,HSUCC,"Cfmidat",
				Cfmidat(HBUSNS, $date, $datstr, "<YEAR><MZ><DZ>",
							HDEC, HFYFST, 2000), "%s (%d)", $datstr, $date);

			ShowResults($log, 1,HSUCC,"Cfmdatp",
				Cfmdatp(HBUSNS, $date, $syear, $sprd),
					"%d (%d:%d)", $date, $syear, $sprd);

			ShowResults($log, 1,HSUCC,"Cfmsrng",
				Cfmsrng(HBUSNS, $syear, $sprd,
								$eyear, $eprd, $range, $numobs));

			ShowResults($log, 1,HSUCC,"Cfmrrng",
				Cfmrrng($dbkey, "SP500.DIVISOR", $range,
						$divisor, HNTMIS, $nada),
						"Divisor is %3.3f", $divisor->[0]);

			ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));
		} else {
			print($log "Start -- Skipping SPINDEX test\n");
			for (my $i=0; $i<6; $i++) {
				printf("ok %d\n", ++$test::num);
				printf($log "skipped %d\n", $test::num);
			}
			print($log "End ---- Skipping SPINDEX test\n");
		}

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", Cfmfin());
}

