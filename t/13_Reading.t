#=============================================================================
#	File:	13_Reading.t
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

BEGIN { $| = 1; print "1..23\n"; }
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
my		$rc;
my		$TestWriteCount	=	31;

;#		------------------------------------------------------------
;#		------------------------------------------------------------
my		$wr_num_test	=	"wr_num_test";
my		$wr_nml_test	=	"wr_nml_test";
my		$wr_boo_test	=	"wr_boo_test";
my		$wr_str_test	=	"wr_str_test";
my		$wr_prc_test	=	"wr_prc_test";
my		$wr_dat_test	=	"wr_dat_test";

my		$log = StartTest("13_Reading");
		ShowResults($log, 1,0,"cfmini", FameHLI::API::Cfmini());

;#		------------------------------------------------------------
my		$syear	=	1999;
my		$sprd	=	1;
my		$eyear	=	1999;
my		$eprd	=	31;
my		$numobs	=	-1;
my		$rng;

		ShowResults($log, 1,0,"cfmsfis",
			FameHLI::API::Cfmsfis(HBUSNS, $syear, $sprd,
						$eyear, $eprd, $rng, $numobs),
			"sy:%s, sp:%s, ey:%s, ep:%s, n:%s",
			$syear, $sprd, $eyear, $eprd, $numobs);


		$eyear	=	-1;
		$eprd	=	-1;

		ShowResults($log, 1,0,"cfmsrng",
			FameHLI::API::Cfmsrng(HBUSNS, $syear, $sprd,
						$eyear, $eprd, $rng, $numobs),
			"sy:%s, sp:%s, ey:%s, ep:%s, n:%s", 
			$syear, $sprd, $eyear, $eprd, $numobs);

		ShowResults($log, 1,0,"cfmopdb(u)", 
			FameHLI::API::Cfmopdb($dbkey, "testdb", HUMODE));

;#		------------------------------------------------------------
		printf($log "--> Reading Data\n");
;#		------------------------------------------------------------
		ShowResults($log, 0,0,"cfmrdfa", 999);

my		$len	=	0;

		ShowResults($log, 1,0,"cfmgtnl", 
			FameHLI::API::Cfmgtnl($dbkey, $wr_nml_test, 
				HNLALL, $str, 100, $len), 
				"All: '%s'", $str);

		ShowResults($log, 1,0,"cfmgtnl", 
			FameHLI::API::Cfmgtnl($dbkey, $wr_nml_test, 
				2, $str, 100, $len), 
				"2nd: '%s'", $str);

my		$ndata;
my		@testdata = NumData();
my		@datetest = DateData();

		ShowResults($log, 1,0,"cfmfame", 
			FameHLI::API::Cfmfame("<freq b; date 1999m1> junk = uniform"));

		ShowResults($log, 1,0,"cfmrrng(num)", 
			FameHLI::API::Cfmrrng($dbkey, $wr_num_test, $rng, $ndata, 
				HNTMIS, $NoMissTbl));
		CompNumValues($log, \@testdata, $ndata, $TestWriteCount);

		ShowResults($log, 1,0,"cfmrrng(prc)", 
			FameHLI::API::Cfmrrng($dbkey, $wr_prc_test, $rng, $pdata, 
				HNTMIS, $NoMissTbl));
		CompNumValues($log, \@testdata, $pdata, $TestWriteCount);

		ShowResults($log, 1,0,"cfmrrng(dat)", 
			FameHLI::API::Cfmrrng($dbkey, $wr_dat_test, $rng, $ddata, 
				HNTMIS, $NoMissTbl));
		CompNumValues($log, \@datetest, $ddata, $TestWriteCount);

		ShowResults($log, 1,0,"cfmrrng(bool)", 
			FameHLI::API::Cfmrrng($dbkey, $wr_boo_test, $rng, $bdata, 
				HNTMIS, $NoMissTbl));
		CompBoolValues($log, \@testdata, $bdata, $TestWriteCount);

		ShowResults($log, 1,0,"cfmgtsts(strs)", 
			FameHLI::API::Cfmgtsts($dbkey, $wr_str_test, $rng, $sdata));

		ShowResults($log, 1,0,"cfmlsts",
			FameHLI::API::Cfmlsts($dbkey, $wr_str_test, $rng, $lenarray),
			"Array is: '%s'\n", join(", ", @{$lenarray}));

		CompStrValues($log, \@datetest, $sdata, $lenarray, $TestWriteCount);

		ShowResults($log, 1,0,"cfmgtstr(str)", 
			FameHLI::API::Cfmgtstr($dbkey, $wr_str_test, $rng, $str), $str);
		ShowResults($log, 1,1,"Comp String", $str eq $datetest[0],
			"Compare '%s' with '%s'\n", $str, $datetest[0]);

;#		------------------------------------------------------------
		ShowResults($log, 1,0,"cfmcldb", FameHLI::API::Cfmcldb($dbkey));
		ShowResults($log, 1,0,"cfmfin", FameHLI::API::Cfmfin());
}


;#		------------------------------------------------------------
;#		------------------------------------------------------------
sub		CompNumValues {
my		$log	=	shift;
my		$base	=	shift;
my		$test	=	shift;
my		$items	=	shift;

my		$err = 0;
my		$tmp = 0;
		for ($i=0; $i<$items; $i++) {
			if (defined($base->[$i])) {
				if (ref($base->[$i]) and ${$base->[$i]} eq "NA") {
					printf($log "Checking '%s' and '%s'\n",
						${$base->[$i]}, 
						ref($test->[$i]) ? ${$test->[$i]} : $test->[$i]);
					$tmp = 0;
				} elsif (ref($base->[$i]) and ${$base->[$i]} eq "NC") {
					printf($log "Checking '%s' and '%s'\n",
						${$base->[$i]},
						ref($test->[$i]) ? ${$test->[$i]} : $test->[$i]);
					$tmp = 0;
				} elsif (ref($base->[$i]) and ${$base->[$i]} eq "ND") {
					printf($log "Checking '%s' and '%s'\n",
						${$base->[$i]},
						ref($test->[$i]) ? ${$test->[$i]} : $test->[$i]);
					$tmp = 0;
				} else {
					$tmp = $base->[$i] - $test->[$i];
					printf($log "Checking '%g' and '%g' (%g)\n",
						$base->[$i], $test->[$i], $tmp);
				}
				if (abs($tmp) > .000001) {
					printf($log "test[$i] was off by '$tmp'\n");
					$err++;
				}
			} else {
				if (ref($test->[$i])) {
					if (${$test->[$i]} ne "ND") {
						printf($log "Why is $i set to '%s'?\n", ${$test->[$i]});
						$err++;
					}
				} else {
					printf($log "why is $i populated? '%s'\n", $test->[$i]);
					$err++;
				}
			}
		}
		ShowResults($log, 1,0,"Comp Num Vals", $err);
}

;#		------------------------------------------------------------
;#		------------------------------------------------------------
sub		CompStrValues {
my		$log	=	shift;
my		$base	=	shift;
my		$test	=	shift;
my		$len	=	shift;
my		$items	=	shift;
my		$rc;
my		$b;
my		$t;
my		$tmp;

my		$err = 0;
		for ($i=0; $i<$items; $i++) {
			if (defined($base->[$i])) {
				if (ref($base->[$i]) and ${$base->[$i]} eq "NA") {
					printf($log "Checking '%s' and '%s'", ${$base->[$i]},
						ref($test->[$i]) ? ${$test->[$i]} : $test->[$i]);
					if (ref($test->[$i])) {
						if (${$test->[$i]} eq "NA") {
							printf($log "... ok\n");
						} else {
							printf($log "... failed\n");
							$err++;
						}
					} else {
						printf($log "... not a ref!\n");
						$err++;
					}
				} elsif (ref($base->[$i]) and ${$base->[$i]} eq "NC") {
					printf($log "Checking '%s' and '%s'", ${$base->[$i]},
						ref($test->[$i]) ? ${$test->[$i]} : $test->[$i]);
					if (ref($test->[$i])) {
						if (${$test->[$i]} eq "NC") {
							printf($log "... ok\n");
						} else {
							printf($log "... failed\n");
							$err++;
						}
					} else {
						printf($log "... not a ref!\n");
						$err++;
					}
				} elsif (ref($base->[$i]) and ${$base->[$i]} eq "ND") {
					printf($log "Checking '%s' and '%s'", ${$base->[$i]},
						ref($test->[$i]) ? ${$test->[$i]} : $test->[$i]);
					if (ref($test->[$i])) {
						if (${$test->[$i]} eq "ND") {
							printf($log "... ok\n");
						} else {
							printf($log "... failed\n");
							$err++;
						}
					} else {
						printf($log "... not a ref!\n");
						$err++;
					}
				} else {
					printf($log "Checking '%s' and '%s' (%d)\n",
						$base->[$i], $test->[$i], $len->[$i]);
					if ($base->[$i] ne $test->[$i]) {
						print($log "--> '$base->[$i]' ne\n");
						print($log "--> '$test->[$i]'\n\n");
						$err++;
					}
					if (length($test->[$i]) != $len->[$i]) {
						print($log "'$test->[$i]' isn't $len->[$i] long!\n");
					}
				}
			} elsif (ref($test->[$i])) {
				if (${$test->[$i]} ne "ND") {
					printf($log "Why is $i set to '%s'?\n", ${$test->[$i]});
					$err++;
				}
			} else {
				if ($test->[$i]) {
					printf($log "why is $i populated? '%s'\n", $test->[$i]);
					$err++;
				} else {
					print($log "$i is not defined\n");
					if ($len->[$i] != 2) {
						printf($log "Why does it think it is %d long?\n",
								$len->[$i]);
						$err++;
					}
				}
			}
		}
		if ($err == 0) {
			$rc = 0;
		} else {
			$rc = -1;
		}

		ShowResults($log, 1,0,"Comp Str Vals", $rc);
}

;#		------------------------------------------------------------
;#		------------------------------------------------------------
sub		CompBoolValues {
my		$log	=	shift;
my		$base	=	shift;
my		$test	=	shift;
my		$items	=	shift;

my		$err = 0;
		for ($i=0; $i<$items; $i++) {
my			$t1;
			if (defined($base->[$i])) {
				if (ref($base->[$i])) {
					$t1 = ${$base->[$i]};
				} elsif ($base->[$i]) {
					$t1 = "1";
				} else {
					$t1 = "0";
				}
			}
			if (defined($t1)) {
				if ($t1 eq "NA" or $t1 eq "NC" or $t1 eq "ND") {
					printf($log "Checking '%s' and '%s'",
						$t1,
						ref($test->[$i]) ? ${$test->[$i]} : $test->[$i]);
					if (ref($test->[$i]) and ${$test->[$i]} eq $t1) {
						printf($log "... ok\n");
					} else {
						printf($log "... failed\n");
						$err++;
					}
				} else {
					printf($log "Checking '%g' and '%g'\n",
						$t1, $test->[$i]);
					if ($t1 ne $test->[$i]) {
						printf($log "--> '$t1' ne\n");
						printf($log "--> '$test->[$i]'\n\n");
					}
				}
			} elsif (ref($test->[$i])) {
				if (${$test->[$i]} ne "ND") {
					printf($log "Why is $i set to '%s'?\n", ${$test->[$i]});
					$err++;
				}
			} else {
				printf($log "why is $i populated? '%s'\n", $test->[$i]);
				$err++;
			}
		}
		ShowResults($log, 1,0,"Comp Str Vals", $err);
}


