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

{
my		$missing = 0;

		print("\nChecking Environment Variables\n\n");
		$missing += PrintCheck("FAME", $ENV{FAME}, $ENV{FAME});
		$missing += PrintCheck("HLI", $ENV{HLI}, $ENV{HLI});

		if (!$missing) {
			print("\nChecking for required files\n\n");
			$missing += PrintCheck("hli.h", -f "$ENV{HLI}/hli.h");
			$missing += PrintCheck("libchli.so", -f "$ENV{HLI}/libchli.so");
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
    		'LIBS'			=>	[''],
    		'OBJECT'		=>	'API.o ${HLI}/libchli.so',
    		'DEFINE'		=>	'',
    		'INC'			=>	'-I${HLI} -L${HLI}',
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
