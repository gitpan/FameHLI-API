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
		$missing += PrintCheck("FAME", $ENV{FAME}, $ENV{FAME});
		if (!$missing) {
			$missing += PrintCheck("HLI", $ENV{HLI}, $ENV{HLI});
			if ($missing) {
				print("HLI variable not set.  Hunting for hli.h...\n");
				if ((-d "$ENV{FAME}/hli") && (-f "$ENV{FAME}/hli/hli.h")) {
					# Perl understands mixed \ and / on NT, but nmake doesn't
					$ENV{HLI} = File::Spec->catdir($ENV{FAME}, "hli");
					$missing = 0;
				} elsif (-f "$ENV{FAME}/hli.h") {
					$ENV{HLI} = $ENV{FAME};
					$missing = 0;
				} else {
					print("Can't find hli.h!"
						.	"  Please set HLI environment variable.\n");
				}
			}
		}

		if (!$missing) {
			print("\nChecking for required files\n\n");
			$missing += PrintCheck("hli.h", -f "$ENV{HLI}/hli.h");
;#		------------------------------------------------------------------
;#		Only one of these next two can work so we check for both and
;#		then decrement the result. (Thanks, Daniel)
;#		------------------------------------------------------------------
			$missing += PrintCheck("libchli.so", -f "$ENV{HLI}/libchli.so");
			$missing += PrintCheck("chli.lib", -f "$ENV{HLI}/chli.lib");
			$missing--;
		}

		if ($missing) {
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
    		'DEFINE'		=>	'',
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

my		$resp	=	0;

		print("--> ");
		print(substr($name . " " . "." x 20, 0, 20), " ");

		if ($passed) {
			print("found.");
			print(" ($print)") if $print;
			print("\n");
		} else {
			print("failed.\n");
			$resp = 1;
		}
		return $resp;
}
