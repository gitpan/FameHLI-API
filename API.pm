;#=============================================================================
;#	File:	FameHLI-API.pm
;#	Author:	Dave Oberholtzer (daveo@obernet.com)
;#			Copyright (c)2001, David Oberholtzer and Measurisk.
;#	Date:	2001/03/23
;#	Use:	Access to FAME from Perl
;#=============================================================================
package FameHLI::API;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
our	%EXPORT_TAGS = (
	'all'	=> [ qw(
		Cfmini
		Cfmver
		Cfmfin
		Cfmsopt
		Cfmsrng
		Cfmsfis
		Cfmopcn
		Cfmgcid
		Cfmcmmt
		Cfmabrt
		Cfmclcn
		Cfmopdb
		Cfmspos
		Cfmcldb
		Cfmpodb
		Cfmrsdb
		Cfmpack
		Cfmopdc
		Cfmddes
		Cfmddoc
		Cfmgdba
		Cfmgdbd
		Cfmglen
		Cfmnwob
		Cfmalob
		Cfmcpob
		Cfmdlob
		Cfmrnob
		Cfmasrt
		Cfmosiz
		Cfmgdat
		Cfmwhat
		Cfmncnt
		Cfmdlen
		Cfmsdes
		Cfmsdoc
		Cfmsbas
		Cfmsobs
		Cfmgtatt
		Cfmsatt
		Cfmgnam
		Cfmgtali
		Cfmsali
		Cfmnlen
		Cfmgsln
		Cfmssln
		Cfmgtaso
		Cfmsaso
		Cfmfdiv
		Cfmtody
		Cfmpind
		Cfmpinm
		Cfmpiny
		Cfmwkdy
		Cfmbwdy
		Cfmislp
		Cfmchfr
		Cfmpfrq
		Cfmufrq
		Cfmsnm
		Cfmspm
		Cfmsbm
		Cfmsdm
		Cfmisnm
		Cfmispm
		Cfmisbm
		Cfmisdm
		Cfmissm
		Cfminwc
		Cfmnxwc
		Cfmrdfa
		Cfmgtnl
		Cfmrrng
		Cfmgtstr
		Cfmgtsts
		Cfmrdfm
		Cfmwrng
		Cfmwstr
		Cfmwsts
		Cfmwtnl
		Cfmwrmt
		Cfmtdat
		Cfmdatt
		Cfmddat
		Cfmdatd
		Cfmpdat
		Cfmdatp
		Cfmfdat
		Cfmdatf
		Cfmldat
		Cfmdatl
		Cfmidat
		Cfmdati
		Cfmfame
		Cfmopwk
		Cfmsinp 
		Cfmoprc
		Cfmrmev
		Cfmferr
	) ] );

our	@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our	@EXPORT = qw(
);

$VERSION = '1.000';

bootstrap FameHLI::API $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 COPYRIGHT

Copyright (c) 2001 Dave Oberholtzer (daveo@obernet.com) and Measurisk.
All rights reserved.  This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=head1 DISCLAIMER

This doc is longer than it should be because in includes elements
of I<README>, I<INSTALL> and the I<man> page.  In a later release I will
properly separate them.  Getting it to work well seemed much more important.

This release is considered to be basically stable.  Please report any
problems that you may find to me at 'daveo@obernet.com' so that I can
address them.

Please read about Missing Values (specifically that translation
tables are not yet supported). "Unit of Work" stuff is not tested
and in some cases not written (see notes below).

My sense of humor is a bit dry.  As this moves up the revision ladder, I
will try to tone it down a bit.

=head1 NAME

FameHLI::API consists of:

    FameHLI::API - Perl5 port of Fame C-HLI functions
    FameHLI::API::HLI - port of Fame hli.h variables
    FameHLI::API::EXT - helper function


=head1 SYNOPSIS

All C-HLI functions
are implemented using the same name as the C-HLI functions
with the I<FameHLI::API::> prefix and a capital first letter.

    use FameHLI::API;
    use FameHLI::API::HLI(:all);
    my $rc;
    $rc = FameHLI::API::Cfmini();
    if ($rc != HSUCC) {
      printf("There was an error %d: %s\n", $rc,
        FameHLI::API::EXT::ErrDesc($rc));
    }
    $rc = FameHLI::API::Cfmfin();

=head1 DESCRIPTION

FameHLI::API is an XS port of the Fame C-HLI.  It provides access
to the FAME C-HLI function library as well as the 'hli.h' #define
values.  The interface is written entirely using XS and Perl.

Unlike many modules, this one is simply a library of functions
as opposed to any objects.  Objects, on the other hand, can now
be easily developed using this library and added to the I<FameHLI>
namespace.

The 'library' includes:

=over 4

=item *

Nearly all of the cfm* functions (exceptions are noted and
are primarily limited to "Unit of Work" and "Missing Value"
functions)

=item *

HLI #define variables are available (noting the aforementioned
issues surrounding Missing Values)

=item *

Several 'Helper Functions' which return textual descriptions of HLI codes

=back

In addition, the build package includes sample/test scripts
showing the use of the functions.  These scripts can be found
in the "t" subdirectories of their respective sections:

    FameHLI::API        ->  ./t/*.t
    FameHLI::API::HLI   ->  ./HLI/t/*.t
    FameHLI::API::EXT   ->  ./EXT/t/*.t

If you used the I<cpan> module and/or need more help finding these 
files you should either talk to your SysAdmin or Local Perl Guru to
find out where I<cpan> keeps its I<build> tree or try to use
C<find>:

  find / -name API.xs > /tmp/API.search

Be aware that this could take a LONG time and, unless you
are running as I<root>, will produce a LOT of "you can't
look there" warnings.  After all is through, you should
look at I</tmp/API.search> and you should only see one
useful entry.  The file should live in the I<FameHLI::API> 
base directory and from there you should be able to find 
the I<t/> subdirectories mentioned above.

=head1 RETURN VALUE

Each function will return the status as indicated by the
Programmers Guide to the C-HLI.  Since the functions behave
(in most cases) exactly as described in FAME's rather hefty 
documentation, I will forego retyping that text.

Many C-HLI functions take pointers so as to return values via
the argument list.  These values are returned to Perl via the
argument list as well.  You should not pass a reference to the
variable in the argument list; FameHLI (by way of XS) understands
to change the value contained in the variable.

=head2 Scalars

Scalar values are returned in scalar variables.  Keep in mind
that this refers to things that are returned as scalars in
the C-HLI.  C<cfmrrng> returns an array of one element when
the OBJECT being read is a scalar.  Therefore, Cfmrrng will
return an array of one element.  (See note on 'Arrays' below.)

=head2 Arrays

Arrays are returned to Perl in scalar references to anonymous
arrays.  To access values in one of these arrays you must use
the 'pointer' or 'dereferencing' notation.  For instance, to
access the first element of an array reference you would use:

    my $val;
    my $rc = FameHLI::API::Cfmrrng($dbkey, $objname, $range,
				$valary, HNTMIS, $mistt);
	if ($rc == HSUCC) {
        $val = $valary->[0];
    } else {
my		$msg = "Error accessing $objname! "
			. FameHLI::API::EXT::ErrDesc($rc);
		carp($msg);
    }

You noted, of course, that since Missing Values translation
tables aren't supported you opted for "No Translation of
Missing Values".  The C<$mistt> can be any scalar as it will
be completely ignored.  I do not ignore C<tmiss> so you
will get very unpredictable results if you specify anything
other than HNTMIS.

=head1 ERRORS

Perl will let you know about strange errors, either by
warnings or by dumping core.  I haven't gotten a core dump
in quite a while so either I have found most of the evil
bugs or I have gotten more careful of what to avoid. ;-)

=head1 EXAMPLES

The best source of examples will come from the FAME C-HLI 
documentation.  The main difference is that C<status> has
been removed from the argument list and is now returned as
the value of the function.

=head2 "C"

    int status;
    cfmini(&status);

=head2 Perl

    my $rc = FameHLI::API::Cfmini();

=head1 PREREQUISITES

FameHLI::API requires

=over 4

=item *

Fame (Forcasting and Analytical Modeling Environment) installed
on your system.  (www.fame.com)  (tested with 8.0 and 9.035)

=item *

Perl and a compiler (this port was tested with Perl 5.6.0 and gcc 2.95.2)

=item *

A working knowledge of Fame and the C-HLI and/or access to the
Fame C-HLI documentation.  If you have Fame, you should have
the documentation online (or download the PDF from www.fame.com).

=back

=head1 ENVIRONMENT

You will need to have the various I<FAME> environment variables
set as noted in the Fame documentation.

=head1 BUILDING THE MODULE

Building the module is handled in the standard way.  There is a
pre-test which checks for the $FAME and $HLI environment variables
and then checks for "hli.h" and "libchli.so".  Passing that, it
continues on in the normal fashion.

'make test' runs a suite of test scripts (located in the "t/" 
subdirectory).  These tests leave associated "*.log" files in the
build directory.  The names of the tests will look familiar if you
have seen the outline of the on-line Fame HELP Index.

Before running 'make test' you should copy the "PWD.sample"
file to the parent directory as "PWD" and edit it to contain valid
values.  Refer to the PWD section under FILES below.

    perl Makefile.PL

or alternatively

    perl Makefile.PL LIB=~/lib

and then

    make
    make test

=head1 INSTALLATION

'make install' will install the module in the normal way.  If
you have allowed the default location for the installation you
may need 'root' access.  If, on the other hand, you chose the
alternative installation method above, you will need to ensure
that either the given directory is in the PERL5LIB library path
or you have the command "use lib '/your/path/to/lib';" in your
program before the module can be used.

    make install

=head1 PORTABILITY

This module was developed and tested under the following conditions:

   - Developed with Perl 5.6.0 on Solaris 2.6
   - Compiled using 'gcc' version 2.95.2
   - Tested on Solaris 2.6 using Fame 8.032 and 9.035

=head1 FILES

As with any installation using the Fame software, you will
need current license files in the path list specified by
either the I<FAME> or I<FAME_PATH> environment variables.

=head2 PWD

The PWD file should contain values which are correct for your
system.  The values needed are:

=over 4

=item *

SERVICE - the service port of an MCADBS.  This MCADBS will need
to have at least one database open.  This is used to test C<Cfmrmev>
which will look for FAMESERIES (noted below) in that MCADBS

=item *

HOSTNAME - The host on which your MCADBS runs.

=item *

FAMESERIES - the name of a time series object available from the just
noted MCADBS.  The series MUST have some values in it as the
C<Cfmrmev> will look for the C<LASTVALUE> of that series.

=item *

FAMEISSUER - the name of a string scalar object available from the
same MCADBS.  If you were to specify "IBM.CLOSE" for FAMESERIES
you could specify "IBM.ISSUER" for this object.

=item *

FAMEDB - the name of the database which contains the data
in the same MCADBS.  Using the examples above, you would 
specify "PRC" as your database (North American Pricing).

=item *

USERNAME - If the above referenced  MCADBS requires a username 
and password, this is where you specify it.

Mine doesn't require username/password so
I haven't tested this feature yet.  If you test it, please let
me know so I can either fix it or remove this comment.

=item *

PASSWORD - the password for the aforementioned USERNAME

=item *

SITESERVER - the name of a SiteServer MCADBS instance which
has the North American Pricing database available.

=item *

SPINDEX - the string needed to open a given spindex daily database
in a standard "open" command.

=item *

SPINDATE - the date of the SPINDEX database

=back

=head1 CAVEATS (Bugs/Features)

This module has not yet been tested against a Windows 
installation.  If you do try it there and it works, please
let me know.  If it doesn't work, please let me know how
you fixed it. :-)  I will attempt to get those fixes in
the next release.

=head2 And Speaking of Windows

At the time of this writing, HDMODE does not work correctly
(or at all) on Windows NT.  This is a known condition and
Fame is working on a fix.  It should become available after 
the next NT build for Fame.

=head2 Missing Values

Missing values are implemented as references to a string whose
value (as would be expected) is "NA", "NC" or "ND".  Translation
tables are not yet implemented.  Therefore, since references
aren't valid in FameLand, you can check to see if any returned
value is a reference.  If so, it is probably one of the 3
Missing Values.  Simply dereference it to see which one.

=head2 String Length arguments

In any C-HLI function which returns a string, you are 
required to provide space for that string as well as telling
the C-HLI how much space you provided.  The length arguments
are option in FameHLI::API and are, for the most part, ignored
even if you do proivde them.

=head2 Object Name Conversion

In any C-HLI functions which take an OBJNAM as one of the
arguments, the HLI "trims the name and converts it to
uppercase."  This is true of some other string arguments as
well.  I don't do that here.  I don't see the point, do you?
The HLI does it because the HLI is very concerned with NOT
screwing up core memory.  If they have to malloc some space,
copy the string and convert it then they have some extra
work (time consumption) to do.  If, however, they convert
it in place, they can avoid that extra work.  They have to
have an UPPER CASE objnam so that they can look it up in
the internal database namespace.

I currently copy the objnam to a static buffer and pass that
buffer to HLI to play with.  To return the converted
string back to the caller, I will need to free up your old 
variable, malloc some new space, assign that to your variable 
and play some calling-stack games.

If anyone can give me a valid reason to do this, I will put
it in.  Otherwise, I take the object name as READ ONLY.

=head1 TO DO LIST

There are a few areas which still need improvement.  
These improvements will be in later releases.  (Order
will be dependent on demand.)

=head2 Error Checking / Handling

In this early release of FameHLI::API there is not a lot of 
error checking for things that you just shouldn't do.
If you happen to pass a string where the function expects
a number, I don't know what will happen.

=head2 Diagnostics and Warnings

Additionally, there aren't many useful diagnostics which
use standard Perl channels.  Most of the error messages are
printed to STDOUT.  So, until I can get to this, please
don't make any mistakes.  ;-)

=head2 Missing Values

Missing Values in FameLand can take one of 3 different values
and, therefore, don't quite work like an C<undef> in PerlLand.
Because of this, I am implementing Missing Values in the
following manner:

=over 4

=item *

Missing Values are implemented as references to the
strings 'NA', 'NC' and 'ND'. [Done]

=item *

Upon requesting a scalar which has a missing value, the
variable will contain a reference to the anonymous scalar
"ND" (for example). [Done]

=item *

Upon requesting a series which has missing values, each
element which represents a missing value will contain a
reference pointing to the single anonymous scalar string
created for that array for that type of missing value.

In this way, strings, numbers and dates will
all have either valid values or references.

    for (my $i=1; $i<$#@{$data}; $i++) {
        if (ref($data->[$i])) {
            printf("<%s>\n", ${$data->[$i]});
        } else {
            printf("Value is '%s'\n", $data->[$i]);
        }
    }

in this way, you can actually see the "NA", "NC" or "ND"
string and _know_ it is a missing value. [Done]

=item *

cfmis[bdnps]m functions will need to look at the value, see
that it is a reference, check the value pointed to and see
if it is any of "NA", "NC" or "ND".  I considered using a
single 'static' value for each missing value and having
everybody point to that one but that seems too restrictive.
[Not done]

=item *

cfms[bdnps]m functions would each contain a simple array
of references to the scalars provided when calling them.
No muss, no fuss, no casting.
[Not done]

=back

=head1 RESTRICTIONS

You will need to already have FAME installed on your system.
This module was developed using FAME 8.032 and 9.035

Just as the C-HLI is not thread-safe, neither is this library
since it is based entirely on libchli.  You have been warned.

=head1 SEE ALSO

L<perl(1)> L<FameHLI::API::HLI(3)> L<FameHLI::EXT(3)>.

=head1 AUTHOR

Dave Oberholtzer (daveo@obernet.com)

=head1 HISTORY

=head2 Various Ports

There have been several attempts to port the C-HLI to Perl.
They fall into two camps: 'Thin and Perlish' and 'Fameish'.

The 'Thin and Perlish' ports are good if you have never used
the C-HLI before and don't mind figuring out how the FAME 
documentation matches up to the reformatted calling sequence
of these ports.  The more useful portion of these ports comes
in using the accompanying Perl objects.  These objects are
complete departures from the FAME docs.  The fact that you
are reading this suggests to me that you are probably very
comfortable (or at least familiar) with 'departing from the
docs' anyway so that shouldn't be a problem.

This 'Fameish' port is designed specifically to match the
FAME documentation as closely as possible (well, except for
the 'status' thing).

=head2 This Port

The FameHLI::API module is a direct successor of the FameLayer
written using SWIG.  While SWIG is a powerful and somewhat
easier package to use to create a set of wrapper functions,
I was unable to achieve some of the transparency that Perl
programmers require.

This follow up is much closer to the actual C-HLI and to
the way Perl programmers are used to working.

Both FameLayer and FameHLI::API were developed because I wanted
to get at the FAME 8.0 HDMODE functionality and because I
didn't want to be tied to any given MCADBS process.  The 
result is a package written entirely in XS which may be
portable to Windows (although I haven't tried it yet).

=head1 IF YOU MUST KNOW

For those of you who want an on-line list of functions and
their signatures, here it is.  

Please note: Any function which does not have a set of parenthesis
after it or that has an I<x> in front of it
is not currently implemented.  This is mainly limited to
the functions dealing with B<Missing Values> and B<Unit of Work> stuff.

The notable exception to this is C<Cfmrdfm> which is 
partly broken in the underlying HLI itself.

Also note: Any function with an I<*> (asterisk) in front of it has
not been ported to Perl.  In I<C> you need to feed a properly
sized buffer for string variables.  In Perl we do that for you.
In addition, most C<inlen> and C<outlen> arguments are optional.
If you do provide values for these, the values are ignored.
These cases are noted with square braces around the argument.

=head2 01 Using the HLI

  Cfmini()
  Cfmver(ver)
  Cfmfin()

=head2 02 Setting Options in the HLI

  Cfmsopt(optname, optval)

=head2 03 Setting Ranges

  Cfmsrng(freq, syear, sprd, eyear, eprd, range, numobs)
  Cfmsfis(freq, syear, sprd, eyear, eprd, range, numobs, fmonth, flabel)

=head2 04 Handling Connections

  Cfmopcn(connkey, service, hostname, username, password)
  Cfmgcid(dbkey, connkey)
 x Cfmcmmt(connkey)
 x Cfmabrt(connkey)
  Cfmclcn(connkey)
 x Cfmasrt(connkey, assert_type, assertion, perspective, grouping, dblist)

=head2 05 Handling Databases

  Cfmopdb(dbkey, dbname, mode)
  Cfmspos(flag)
  Cfmcldb(key)
  Cfmpodb(dbkey)
  Cfmrsdb(dbkey)
  Cfmpack(dbkey)
  Cfmopdc(dbkey, dbname, mode, connkey)

=head2 06 Handling Database Information and Attributes

  Cfmddes(dbkey, desc)
  Cfmddoc(dbkey, doc)
  Cfmgdba(dbkey, cyear, cmonth, cday, myear, mmonth, mday, desc, doc)
  Cfmgdbd(dbkey, freq, cdate, mdate)
 * Cfmglen

=head2 07 Handling Data Objects

  Cfmnwob(dbkey, objnam, class, freq, type, basis, observ)
  Cfmalob(dbkey, objnam, class, freq, type, basis, observ, 
            numobs, numchr, growth)
  Cfmcpob(srckey, tarkey, srcnam, tarnam)
  Cfmdlob(dbkey, objnam)
  Cfmrnob(dbkey, oldname, newname)

=head2 08 Handling Data Object Information and Attributes

  Cfmosiz(dbkey, objname, class, type, freq, fyear, fprd, lyear, lprd)
  Cfmgdat(dbkey, objnam, freq, cdate, mdate)
  Cfmwhat(dbkey, objnam, class, type, freq, basis, observ, 
            fyear, fprd, lyear, lprd, cyear, cmonth, cday, 
            myear, mmonth, mday, desc, doc)
 * Cfmncnt
 * Cfmdlen
  Cfmsdes(dbkey, objnam, desc)
  Cfmsdoc(dbkey, objnam, doc)
  Cfmsbas(dbkey, objnam, basis)
  Cfmsobs(dbkey, objnam, observ)
  Cfmgtatt(dbkey, objnam, atttype, attnam, value [, inlen [, outlen]])
 * Cfmlatt
  Cfmsatt(dbkey, objnam, atttype, attnam, value)
  Cfmgnam(dbkey, objnam, basnam)
  Cfmgtali(dbkey, objnam, alias [, inlen [, outlen]])
 * Cfmlali
  Cfmsali(dbkey, objnam, aliass)
 * Cfmlsts
 * Cfmnlen
  Cfmgsln(dbkey, objnam, length)
  Cfmssln(dbkey, objnam, length)
  Cfmgtaso(dbkey, objnam, assoc)
 * Cfmlaso
  Cfmsaso(dbkey, objnam, assoc)

=head2 09 Handling Dates

  Cfmfdiv(freq1, freq2, flag)
  Cfmtody(freq, date)
  Cfmpind(freq, count)
  Cfmpinm(freq, year, month, count)
  Cfmpiny(freq, year, count)
  Cfmwkdy(freq, date, wkdy)
  Cfmbwdy(freq, date, biwkdy)
  Cfmislp(year, leap)
  Cfmchfr(sfreq, sdate, select, tfreq, tdate, relate)
  Cfmpfrq(freq, base, nunits, year, month)
  Cfmufrq(freq, base, nunits, year, month)

=head2 10 Handling Missing Values

These are not implemented in such a way as you would want to use them.

 x Cfmsnm(nctran, ndtran, natran, table)
 x Cfmspm(nctran, ndtran, natran, table)
 x Cfmsbm(nctran, ndtran, natran, table)
 x Cfmsdm
 x Cfmisnm(value, ismiss)
 x Cfmispm(value, ismiss)
 x Cfmisbm
 x Cfmisdm
 x Cfmissm

=head2 11 Wildcarding

  Cfminwc(dbkey, wildname)
  Cfmnxwc(dbkey, obj, class, type, freq)

=head2 13 Reading Data

 * Cfmrdfa
  Cfmgtnl(dbkey, objnam, index, str [, inlen [, outlen]])
  Cfmrrng(dbkey, objnam, range, data, miss, table)
  Cfmgtstr(dbkey, objnam, range, str)
  Cfmgtsts(dbkey, objnam, range, data [, misaray])
 x Cfmrdfm(dbkey, objname, source)

=head2 12 Writing Data

  Cfmwrng(dbkey, objnam, range, data, miss, table)
  Cfmwstr(dbkey, objnam, range, val, ismiss, length)
  Cfmwsts(dbkey, objnam, range, data)
  Cfmwtnl(dbkey, objnam, idx, val)
 x Cfmwrmt(dbkey, objnam, objtyp, rng, data, miss, tbl)

=head2 14 Converting Dates

  Cfmtdat(freq, date, hour, minute, second, ddate)
  Cfmdatt(freq, date, hour, minute, second, ddate)
  Cfmddat(freq, date, year, month, day)
  Cfmdatd(freq, date, year, month, day)
  Cfmpdat(freq, date, year, period)
  Cfmdatp(freq, date, year, period)
  Cfmfdat(freq, date, year, period, fmonth, flabel)
  Cfmdatf(freq, date, year, period, fmonth, flabel)
  Cfmldat(freq, date, datestr, month, label, century)
  Cfmdatl(freq, date, datestr, month, label)
  Cfmidat(freq, date, datestr, image, month, label, century)
  Cfmdati(freq, date, datestr, image, month, label)

=head2 15 Using the FAME/Server

  Cfmfame(command)
  Cfmopwk(dbkey)
  Cfmsinp(cmd) 

=head2 16 Using an Analytical Channel

  Cfmoprc(dbkey, connkey)
 * Cfmopre
  Cfmrmev(dbkey, expr, optns, wdbkey, objnam)

=head2 17 Getting FAME Errors

  Cfmferr(errtxt)
 * Cfmlerr

=head2 Extensions

The extensions all return a character string which represents the textual
version of what the code indicates.  For instance, C<FreqDesc(HBUSNS)> will
return the string "BUSINESS".  C<FormatDate> is simply a convenient
wrapper for the C<cfmdati> function.

  FormatDate(date, freq, image, fmonth, flabel)

  AccessModeDesc(code)
  BasisDesc(code)
  BiWeekdayDesc(code)
  ClassDesc(code)
  ErrDesc(code)
  FreqDesc(code)
  FYLabelDesc(code)
  MonthsDesc(code)
  ObservedDesc(code)
  OldFYEndDesc(code)
  TypeDesc(code)
  WeekdayDesc(code)

=cut
