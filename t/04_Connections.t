#=============================================================================
#	File:	04_Connections.t
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	Testing file for FameHLI functions
#	Editor:	vi with tabstops=4
#=============================================================================
#	NOTE:
#		This unit test "Unit Of Work" functions which, well, aren't tested
#		here.  Maybe someday...
#=============================================================================
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..5\n"; }
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
my		$conn;
my		$host			=	$vars->{hostname};
my		$rc;
my		$service		=	$vars->{service};

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("04_Connections");
		ShowResults($log, 1,0,"cfmini", Cfmini());

;#		------------------------------------------------------------
		print($log "--> Handling Connections\n");
;#		------------------------------------------------------------
my		$user = "";
my		$pwd = "";
		print($log "service is '$service'\n");
		if ($service eq "none") {
			SkipResults($log, 1,0,"cfmopcn", 0, "PWD file not found");
			SkipResults($log, 1,0,"cfmclcn", 0, "PWD file not found");
		} else {
			ShowResults($log, 1,0,"cfmopcn", 
				Cfmopcn($conn, $service, $host, $user, $pwd), $conn);
			ShowResults($log, 0,0,"cfmgcid", 999);#checked in Analytical Channel
			ShowResults($log, 0,0,"cfmcmmt", 999);
			ShowResults($log, 0,0,"cfmabrt", 999);
			ShowResults($log, 1,0,"cfmclcn", Cfmclcn($conn));
		}
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", Cfmfin());
}
