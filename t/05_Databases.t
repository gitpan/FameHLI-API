#=============================================================================
#	File:	05_Databases.t
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	Testing file for FameHLI functions
#	Editor:	vi with tabstops=4
#=============================================================================
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..24\n"; }
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
;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$vars			=	GetVars();
my		$conn;
my		$dbkey;
my		$dbname			=	$vars->{famedb};
my		$host			=	$vars->{hostname};
my		$issuer			=	$vars->{fameissuer};
my		$name			=	"\%junk";
my		$pwd			=	$vars->{username};
my		$rc;
my		$rng;
my		$service		=	$vars->{service};
my		$str			=	"Some stuff";
my		$ticker			=	$vars->{fameseries};
my		$user			=	$vars->{password};

;#		------------------------------------------------------------
my		$log = StartTest("05_Databases");
		ShowResults($log, 1,0,"cfmini", Cfmini());

;#		------------------------------------------------------------
		printf($log "--> Handling Databases\n");
;#		------------------------------------------------------------
		unlink("testdb.db");
		ShowResults($log, 1,0,"cfmopdb(c)", Cfmopdb($dbkey, "testdb", HCMODE));
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmopdb(u)", Cfmopdb($dbkey, "testdb", HUMODE));

;#		------------------------------------------------------------
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmnwob",
			Cfmnwob($dbkey, $name, HSCALA, HUNDFX, HSTRNG, HBSUND, HOBUND),
			"create '%s'", $name);
		ShowResults($log, 1,0,"cfmwstr", 
			Cfmwstr($dbkey, $name, $rng, $str, HNMVAL, length($str)),
			"write a value");
		ShowResults($log, 1,0,"cfmgtstr",
			Cfmgtstr($dbkey, $name, $rng, $answer),
			$answer);
		ShowResults($log, 0,0,"Check value", $answer eq $str ? HSUCC : -1);

;#		------------------------------------------------------------
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmrsdb", Cfmrsdb($dbkey));
		$rc = Cfmgtstr($dbkey, $name, $rng, $answer),
		ShowResults($log, 1,0,"cfmgtstr", ($rc == HNOOBJ) ? HSUCC : -1,
			"'%s' is gone now", $name);
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));

;#		------------------------------------------------------------
;#		------------------------------------------------------------
		unlink("packdb.db");
		ShowResults($log, 1,0,"cfmopdb(c)", Cfmopdb($dbkey, "packdb", HCMODE));
		ShowResults($log, 1,0,"cfmpack", Cfmpack($dbkey));
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmopdb(r)", Cfmopdb($dbkey, "packdb", HRMODE));
		ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));

;#		------------------------------------------------------------
;#		If there is no service then we cannot open the channel
;#		------------------------------------------------------------
		if ($service eq "none") {
			SkipResults($log, 1,0,"cfmopcn", 0, "PWD file not found");
			SkipResults($log, 1,0,"cfmopdc", 0, "PWD file not found");
			SkipResults($log, 1,0,"cfmgcid", 0, "PWD file not found");
			SkipResults($log, 1,0,"cfmgtstr",0, "PWD file not found");
			SkipResults($log, 1,0,"cfmcldb", 0, "PWD file not found");
			SkipResults($log, 1,0,"cfmclcn", 0, "PWD file not found");

;#		------------------------------------------------------------
;#		Otherwise, let's test what we are given.
;#		------------------------------------------------------------
		} else {
			ShowResults($log, 1,0,"cfmopcn", 
				Cfmopcn($conn, $service, $host, $user, $pwd), $conn);
			ShowResults($log, 1,0,"cfmopdc",
				Cfmopdc($dbkey, $dbname, HRMODE, $conn));
			ShowResults($log, 1,0,"cfmgcid", Cfmgcid($dbkey, $conn));
	
			ShowResults($log, 1,0,"cfmgtstr",
				Cfmgtstr($dbkey, $issuer, $rng, $answer),
				$answer);

			ShowResults($log, 1,0,"cfmcldb", Cfmcldb($dbkey));
			ShowResults($log, 1,0,"cfmclcn", Cfmclcn($conn));
		}

		ShowResults($log, 1,0,"cfmfin", Cfmfin());
}
