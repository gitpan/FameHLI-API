#=============================================================================
#	File:	Makefile.PL
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/04/18
#	Use:	Makefile generator for FameHLI::API::HLI
#=============================================================================
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'FameHLI::API::HLI',
    'VERSION_FROM'	=> 'HLI.pm',					# finds $VERSION
    'PREREQ_PM'		=> {},							# e.g., Module::Name => 1.1
    'LIBS'		=> [''],							# e.g., '-lm'
	'OBJECT'	=> 'HLI.o ${HLI}/libchli.a',		# .o files
    'DEFINE'		=> '',							# e.g., '-DHAVE_SOMETHING'
    'INC'		=> '-I${FAME}/hli -L${FAME}/hli',	# include path
);
