#=============================================================================
#	File:	04_Connections.t
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

BEGIN { $| = 1; print "1..5\n"; }
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
my		$conn;
my		$host			=	$vars->{hostname};
my		$rc;
my		$service		=	$vars->{service};

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$log = StartTest("04_Connections");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
		print($log "--> Handling Connections\n");
;#		------------------------------------------------------------
my		$user = "";
my		$pwd = "";
		ShowResults($log, 1,0,"cfmopcn", 
			FameHLI::API::Cfmopcn($conn, $service, $host, $user, $pwd), $conn);
		ShowResults($log, 0,0,"cfmgcid", 999);	# checked in Analytical Channel
		ShowResults($log, 0,0,"cfmcmmt", 999);
		ShowResults($log, 0,0,"cfmabrt", 999);
		ShowResults($log, 1,0,"cfmclcn", FameHLI::API::Cfmclcn($conn));
;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}
