#=============================================================================
#	File:	16_AnalytChan.t
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	Testing file for FameHLI functions
#	Editor:	vi with tabstops=4
#=============================================================================
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..11\n"; }
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
my		$vars			=	GetVars();
my		$conn;
my		$cbkey;
my		$dbkey;
my		$host			=	$vars->{hostname};
my		$pwd			=	$vars->{password};
my		$rbkey;
my		$rc;
my		$service		=	$vars->{service};
my		$siteserver		=	$vars->{siteserver};
my		$str			=	"";
my		$ticker			=	$vars->{fameseries};
my		$user			=	$vars->{username};
my		$work;
my		$TestWriteCount	=	31;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$class = 0;
my		$type = 0;
my		$freq = 0;
my		$eyear = 0;
my		$eprd = 0;
my		$fyear = 0;
my		$fprd = 0;
my		$lyear = 0;
my		$lprd = 0;
my		$syear = 0;
my		$sprd = 0;
my		$cdate = 0;
my		$mdate = 0;
my		$basis = 0;
my		$observ = 0;
my		$cyear = 0;
my		$cmonth = 0;
my		$cday = 0;
my		$myear = 0;
my		$mmonth = 0;
my		$mday = 0;
my		$year	=	0;
my		$month	=	0;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$strname = "teststr";
my		$numname = "testnum";
my		$precname = "testprec";
my		$datename = "testdate";
my		$boolname = "testbool";

my		$wr_num_test	=	"wr_num_test";
my		$wr_nml_test	=	"wr_nml_test";
my		$wr_boo_test	=	"wr_boo_test";
my		$wr_str_test	=	"wr_str_test";
my		$wr_prc_test	=	"wr_prc_test";
my		$wr_dat_test	=	"wr_dat_test";

my		$text		=	"Test Value";
my		$tmp		=	"";
my		$log = StartTest("16_AnalytChan");
		ShowResults($log, 1,0,"cfmini", Cfmini());

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmopcn", 
			Cfmopcn($conn, $service, $host, $user, $pwd), $conn);

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmopdb(u)", 
			Cfmopdb($dbkey, "testdb", HUMODE));

;#		------------------------------------------------------------
		printf($log "--> Using an Analytical Channel\n");
;#		------------------------------------------------------------
my		$newcbkey;
		ShowResults($log, 1,0,"cfmoprc", 
			Cfmoprc($cbkey, $conn), $cbkey);
		ShowResults($log, 1,0,"cfmgcid", 
			Cfmgcid($cbkey, $newcbkey), $newcbkey);
		ShowResults($log, 1,0,"cfmopre", 
			Cfmopre($rbkey, $siteserver), $rbkey);
		ShowResults($log, 1,0,"cfmrmev", 
			Cfmrmev($rbkey, "lastvalue($ticker)", "freq b",
				$dbkey, "ticker.last"),
				"Please see next entry for results");

		ShowResults($log, 1,0,"cfmwhat",
			Cfmwhat($dbkey, "ticker.last",
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
			ClassDesc($class),
			TypeDesc($type),
			FreqDesc($freq),
			BasisDesc($basis),
			ObservedDesc($observ),
			$lyear, $fprd, $lyear, $lprd,
			$cyear, $cmonth, $cday, $myear, $mmonth, $mday,
			$desc, $doc);

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmfin", Cfmfin());
}

