#=============================================================================
#	File:	10_MissVals.t
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	Testing file for FameHLI functions
#	Editor:	vi with tabstops=4
#=============================================================================
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..8\n"; }
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

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("10_MissVals");
		ShowResults($log, 1,0,"cfmini", Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Handling Missing Values\n");
;#		------------------------------------------------------------
my		$nmiss;
my		$pmiss;
my		$bmiss;

		ShowResults($log, 0,0,"cfmsnm", Cfmsnm(1, 10, -100, $nmiss));
		for (my $i=0; $i<=$#{@$nmiss}; $i++) {
			printf($log "miss[$i] = $nmiss->[$i]\n");
		}

		ShowResults($log, 0,0,"cfmspm", Cfmspm(2, 20, -200, $pmiss));
		for (my $i=0; $i<=$#{@$pmiss}; $i++) {
			printf($log "miss[$i] = $pmiss->[$i]\n");
		}

		ShowResults($log, 0,0,"cfmsbm", Cfmsbm(9, -9, 42, $bmiss));
		for (my $i=0; $i<=$#{@$bmiss}; $i++) {
			printf($log "miss[$i] = $bmiss->[$i]\n");
		}

		ShowResults($log, 0,0,"cfmsdm", 999);
		ShowResults($log, 0,0,"cfmisnm", Cfmisnm(FNUMND, $ismiss),
			"ismiss says '%d'", $ismiss);
		ShowResults($log, 0,0,"cfmispm", Cfmispm(FPRCND, $ismiss),
			"ismiss says '%d'", $ismiss);
		ShowResults($log, 0,0,"cfmisbm", 999);
		ShowResults($log, 0,0,"cfmisdm", 999);
		ShowResults($log, 0,0,"cfmissm", 999);

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", Cfmfin());
}
