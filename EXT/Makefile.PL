#=============================================================================
#	File:	Makefile.PL
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/04/18
#	Use:	Create Makefile for FameHLI::API::EXT stuff
#=============================================================================
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
if (!$ENV{HLI}) {
	die("Please define 'HLI' before continuing.\n");
}
WriteMakefile(
    'NAME'	=> 'FameHLI::API::EXT',
    'VERSION_FROM' => 'EXT.pm',					# finds $VERSION
    'LIBS'	=> [''],							# e.g., '-lm' 
    'OBJECT' => 'EXT.o ${HLI}/libchli.a',		# .o files
    'DEFINE'	=> '',							# e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '-I${FAME}/hli -L${FAME}/hli',	# include path
);

