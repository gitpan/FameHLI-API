#=============================================================================
#	File:	Makefile.PL
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#			All rights reserved.
#
#			This package is free software; you can redistribute it
#			and/or modify it under the same terms as Perl itself.
#
#	Date:	2001/04/18
#	Use:	Create Makefile for FameHLI::API stuff
#=============================================================================

use ExtUtils::MakeMaker;
use	File::Spec;

{
my		$missing = 0;

		print("\nChecking Environment Variables\n\n");
		if (PrintCheck("FAME", $ENV{FAME}, $ENV{FAME})) {
			if (! PrintCheck("HLI", $ENV{HLI}, $ENV{HLI})) {
				print("HLI variable not set.  Hunting for hli.h...\n");
				if ((-d "$ENV{FAME}/hli") && (-f "$ENV{FAME}/hli/hli.h")) {
					# Perl understands mixed \ and / on NT, but nmake doesn't
					$ENV{HLI} = File::Spec->catdir($ENV{FAME}, "hli");
					print("I set '\$HLI' to '\$FAME/hli'...\n");
					$missing = 0;
				} elsif (-f "$ENV{FAME}/hli.h") {
					$ENV{HLI} = $ENV{FAME};
					print("HLI set to FAME value.\n");
					$missing = 0;
				} else {
					print("Can't find hli.h!"
						.	"  Please set HLI environment variable.\n");
					$missing = 1;
					goto MISSING;
				}
			}
		} else {
			print("FAME variable not set.\n");
			$missing = 1;
			goto MISSING;
		}

		print("\nChecking for required files\n\n");

;#		Shouldn't happen.  Should be caught earlier...
		if (! PrintCheck("hli.h", -f "$ENV{HLI}/hli.h")) {
			$missing = 1;
			goto MISSING;
		}

;#		------------------------------------------------------------------
;#		Only one of these next two can work so we check for both and
;#		then decrement the result. (Thanks, Daniel)
;#		------------------------------------------------------------------
		if (!$ENV{STATICFAME}) {
			$missing += 1
				unless PrintCheck("libchli.so", -f "$ENV{HLI}/libchli.so");
			$missing += 1
				unless PrintCheck("chli.lib", -f "$ENV{HLI}/chli.lib");
			$missing--;
		} else {
			$missing = 1;
		}

		if ($missing) {
			print("Unable to find dynamically linked library...\n");
			if (PrintCheck("libchli.a", -f "$ENV{HLI}/libchli.a")) {
				print("I wonder why they did that...\n");
				$ENV{STATICFAME} = 1;
				$missing = 0;
			} else {
				print("Nope, couldn't find the static library either\n");
				goto MISSING;
			}
			
		}

		if ($missing) {
MISSING:
			print("\nExiting.\n");
			print("Please fix the aforementioned problems and rerun.\n\n");
			die("TTFN\n");
		} else {
			print("Well, let's get on with it!\n\n");
		}

		WriteMakefile(
    		'NAME'			=>	'FameHLI::API',
    		'VERSION_FROM'	=>	'API.pm',
    		'LIBS'			=>	["-L$ENV{HLI} -lchli"],
    		'OBJECT'		=>	'API.o',
    		'DEFINE'		=>	$ENV{STATICFAME}?'-DCFMINI_EVERYWHERE':'',
    		'INC'			=>	"-I$ENV{HLI}",
		);
}


;#============================================================================
;#		PrintCheck
;#============================================================================
;#		Prints the $name of the test and the 'truthfullness' of $passed.
;#		Returns: 0 if worked, 1 if failed.  This is used as an increment
;#			to an error count.
;#============================================================================
sub		PrintCheck {
my		$name	=	shift;
my		$passed	=	shift;
my		$print	=	shift;

my		$resp	=	1;

		print("--> ");
		print(substr($name . " " . "." x 20, 0, 20), " ");

		if ($passed) {
			print("found.");
			print(" ($print)") if $print;
			print("\n");
		} else {
			print("failed.\n");
			$resp = 0;
		}
		return $resp;
}
