#=============================================================================
#	File:	HLI.pm
#	Author:	Dave Oberholtzer, (daveo@obernet.com)
#			Copyright (c)2001, David Oberholtzer and Measurisk.
#	Date:	2001/03/23
#	Use:	HLI #define variables made available to FameHLI::API
#=============================================================================
package FameHLI::API::HLI;

require 5.6.0;
use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use FameHLI::API::HLI ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	FNUMND
	FPRCND
	GLOBAL
	HABORT
	HAFRI
	HAFTER
	HALL
	HAMON
	HANAPR
	HANAUG
	HANDEC
	HANFEB
	HANJAN
	HANJUL
	HANJUN
	HANMAR
	HANMAY
	HANNOV
	HANOCT
	HANSEP
	HAPOST
	HAPPY
	HAPR
	HASAT
	HASUN
	HATHU
	HATUE
	HAUG
	HAWED
	HAYPP
	HBASRT
	HBATTR
	HBATYP
	HBBASI
	HBCLAS
	HBCNTX
	HBCONN
	HBCPU
	HBDATE
	HBDAY
	HBEFOR
	HBEGIN
	HBERNG
	HBFILE
	HBFLAB
	HBFLAG
	HBFMON
	HBFREQ
	HBFRI
	HBFUNC
	HBGLNM
	HBGROW
	HBGRP
	HBIMON
	HBINDX
	HBKEY
	HBLEN
	HBMISS
	HBMNOV
	HBMODE
	HBMON
	HBMONT
	HBNCHR
	HBNRNG
	HBOBJT
	HBOBSV
	HBOOLN
	HBOPT
	HBOPTV
	HBPER
	HBPHAS
	HBPROD
	HBPRSP
	HBREL
	HBRNG
	HBSAT
	HBSBUS
	HBSDAY
	HBSEL
	HBSRNG
	HBSRVR
	HBSUN
	HBSUND
	HBTHU
	HBTIME
	HBTUE
	HBUNIT
	HBUSER
	HBUSNS
	HBVER
	HBWED
	HBYEAR
	HCASEX
	HCEXI
	HCHANL
	HCHGAC
	HCLCHN
	HCLNLM
	HCLNT
	HCMODE
	HCONT
	HDAILY
	HDATE
	HDBCLM
	HDEC
	HDHOST
	HDMODE
	HDPRMC
	HDUP
	HDUTAR
	HEND
	HEXPIR
	HFAMER
	HFEB
	HFIN
	HFMENV
	HFRI
	HFRMLA
	HFUSE
	HFYAPR
	HFYAUG
	HFYAUT
	HFYDEC
	HFYFEB
	HFYFST
	HFYJAN
	HFYJUL
	HFYJUN
	HFYLST
	HFYMAR
	HFYMAY
	HFYNOV
	HFYOCT
	HFYSEP
	HGLFOR
	HGLNAM
	HHOUR
	HIFAIL
	HINITD
	HINTVL
	HITEM
	HJAN
	HJUL
	HJUN
	HLICFL
	HLICNS
	HLI_INCLUDED
	HLOCKD
	HLRESV
	HLSERV
	HMAR
	HMAXSCMD
	HMAY
	HMFILE
	HMGVAL
	HMIN
	HMON
	HMONTH
	HMPOST
	HNAMEL
	HNAMLEN
	HNAMSIZ
	HNAVAL
	HNBACK
	HNCONN
	HNCVAL
	HNDVAL
	HNEMPT
	HNETCN
	HNFAME
	HNFILE
	HNFMDB
	HNINIT
	HNLALL
	HNLOCL
	HNMCA
	HNMVAL
	HNO
	HNOMEM
	HNOOBJ
	HNOV
	HNPOST
	HNRESW
	HNSUPP
	HNTMIS
	HNTWIC
	HNUFRD
	HNULLP
	HNUMRC
	HNWFEA
	HNWILD
	HOBANN
	HOBAVG
	HOBBEG
	HOBEND
	HOBFRM
	HOBHI
	HOBLO
	HOBSUM
	HOBUND
	HOCT
	HOEXI
	HOLDDB
	HOMODE
	HOPEND
	HOPENW
	HP1REQ
	HP2REQ
	HPACK
	HPRECN
	HPROTOTYPES_SUPPORTED
	HPWWOU
	HQTDEC
	HQTNOV
	HQTOCT
	HQUOTA
	HREAD
	HREADO
	HRECRD
	HRESFD
	HRMKEY
	HRMODE
	HRMTDB
	HRNEXI
	HSAT
	HSCALA
	HSCLLM
	HSEC
	HSEP
	HSERIE
	HSERVR
	HSMAUG
	HSMDEC
	HSMFIL
	HSMJUL
	HSMLEN
	HSMNOV
	HSMOCT
	HSMODE
	HSMSEP
	HSNFIL
	HSPCDB
	HSRVST
	HSTRNG
	HSUCC
	HSUN
	HSUSPN
	HTENDA
	HTHU
	HTMIS
	HTMOUT
	HTRUNC
	HTUE
	HTWICM
	HUMODE
	HUNCHG
	HUNDFT
	HUNDFX
	HUNEXP
	HUPDRD
	HWAFRI
	HWAMON
	HWASAT
	HWASUN
	HWATHU
	HWATUE
	HWAWED
	HWBFRI
	HWBMON
	HWBSAT
	HWBSUN
	HWBTHU
	HWBTUE
	HWBWED
	HWED
	HWKFRI
	HWKMON
	HWKOPN
	HWKSAT
	HWKSUN
	HWKTHU
	HWKTUE
	HWKWED
	HWMODE
	HWRITE
	HYES
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

;# h2xs created this with everything exported.  Hmmm...

our @EXPORT = qw(
);
our @DONT_EXPORT = qw(
	FNUMND
	FPRCND
	GLOBAL
	HABORT
	HAFRI
	HAFTER
	HALL
	HAMON
	HANAPR
	HANAUG
	HANDEC
	HANFEB
	HANJAN
	HANJUL
	HANJUN
	HANMAR
	HANMAY
	HANNOV
	HANOCT
	HANSEP
	HAPOST
	HAPPY
	HAPR
	HASAT
	HASUN
	HATHU
	HATUE
	HAUG
	HAWED
	HAYPP
	HBASRT
	HBATTR
	HBATYP
	HBBASI
	HBCLAS
	HBCNTX
	HBCONN
	HBCPU
	HBDATE
	HBDAY
	HBEFOR
	HBEGIN
	HBERNG
	HBFILE
	HBFLAB
	HBFLAG
	HBFMON
	HBFREQ
	HBFRI
	HBFUNC
	HBGLNM
	HBGROW
	HBGRP
	HBIMON
	HBINDX
	HBKEY
	HBLEN
	HBMISS
	HBMNOV
	HBMODE
	HBMON
	HBMONT
	HBNCHR
	HBNRNG
	HBOBJT
	HBOBSV
	HBOOLN
	HBOPT
	HBOPTV
	HBPER
	HBPHAS
	HBPROD
	HBPRSP
	HBREL
	HBRNG
	HBSAT
	HBSBUS
	HBSDAY
	HBSEL
	HBSRNG
	HBSRVR
	HBSUN
	HBSUND
	HBTHU
	HBTIME
	HBTUE
	HBUNIT
	HBUSER
	HBUSNS
	HBVER
	HBWED
	HBYEAR
	HCASEX
	HCEXI
	HCHANL
	HCHGAC
	HCLCHN
	HCLNLM
	HCLNT
	HCMODE
	HCONT
	HDAILY
	HDATE
	HDBCLM
	HDEC
	HDHOST
	HDMODE
	HDPRMC
	HDUP
	HDUTAR
	HEND
	HEXPIR
	HFAMER
	HFEB
	HFIN
	HFMENV
	HFRI
	HFRMLA
	HFUSE
	HFYAPR
	HFYAUG
	HFYAUT
	HFYDEC
	HFYFEB
	HFYFST
	HFYJAN
	HFYJUL
	HFYJUN
	HFYLST
	HFYMAR
	HFYMAY
	HFYNOV
	HFYOCT
	HFYSEP
	HGLFOR
	HGLNAM
	HHOUR
	HIFAIL
	HINITD
	HINTVL
	HITEM
	HJAN
	HJUL
	HJUN
	HLICFL
	HLICNS
	HLI_INCLUDED
	HLOCKD
	HLRESV
	HLSERV
	HMAR
	HMAXSCMD
	HMAY
	HMFILE
	HMGVAL
	HMIN
	HMON
	HMONTH
	HMPOST
	HNAMEL
	HNAMLEN
	HNAMSIZ
	HNAVAL
	HNBACK
	HNCONN
	HNCVAL
	HNDVAL
	HNEMPT
	HNETCN
	HNFAME
	HNFILE
	HNFMDB
	HNINIT
	HNLALL
	HNLOCL
	HNMCA
	HNMVAL
	HNO
	HNOMEM
	HNOOBJ
	HNOV
	HNPOST
	HNRESW
	HNSUPP
	HNTMIS
	HNTWIC
	HNUFRD
	HNULLP
	HNUMRC
	HNWFEA
	HNWILD
	HOBANN
	HOBAVG
	HOBBEG
	HOBEND
	HOBFRM
	HOBHI
	HOBLO
	HOBSUM
	HOBUND
	HOCT
	HOEXI
	HOLDDB
	HOMODE
	HOPEND
	HOPENW
	HP1REQ
	HP2REQ
	HPACK
	HPRECN
	HPROTOTYPES_SUPPORTED
	HPWWOU
	HQTDEC
	HQTNOV
	HQTOCT
	HQUOTA
	HREAD
	HREADO
	HRECRD
	HRESFD
	HRMKEY
	HRMODE
	HRMTDB
	HRNEXI
	HSAT
	HSCALA
	HSCLLM
	HSEC
	HSEP
	HSERIE
	HSERVR
	HSMAUG
	HSMDEC
	HSMFIL
	HSMJUL
	HSMLEN
	HSMNOV
	HSMOCT
	HSMODE
	HSMSEP
	HSNFIL
	HSPCDB
	HSRVST
	HSTRNG
	HSUCC
	HSUN
	HSUSPN
	HTENDA
	HTHU
	HTMIS
	HTMOUT
	HTRUNC
	HTUE
	HTWICM
	HUMODE
	HUNCHG
	HUNDFT
	HUNDFX
	HUNEXP
	HUPDRD
	HWAFRI
	HWAMON
	HWASAT
	HWASUN
	HWATHU
	HWATUE
	HWAWED
	HWBFRI
	HWBMON
	HWBSAT
	HWBSUN
	HWBTHU
	HWBTUE
	HWBWED
	HWED
	HWKFRI
	HWKMON
	HWKOPN
	HWKSAT
	HWKSUN
	HWKTHU
	HWKTUE
	HWKWED
	HWMODE
	HWRITE
	HYES
);
our $VERSION = '0.902';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/ || $!{EINVAL}) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    croak "Your vendor has not defined FameHLI::API::HLI macro $constname";
	}
    }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
	# # -- daveo
	# # May have been fixed but it doesn't seem to work here...
	# # -- daveo
;#	if ($] >= 5.00561) {
;#	    *$AUTOLOAD = sub () { $val };
;#	}
;#	else {
	    *$AUTOLOAD = sub { $val };
;#	}
    }
    goto &$AUTOLOAD;
}

bootstrap FameHLI::API::HLI $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 COPYRIGHT

Copyright (c) 2001 Dave Oberholtzer (daveo@obernet.com) and Measurisk.
All rights reserved. This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.


=head1 REDIRECT

This page is probably out of date.  Please refer to the L<FameHLI::API>
or I<README> file for more accurate info.  This discrepency will be
handled in a later release because I really do want accurate 
documentation.

=head1 NAME

FameHLI::API::HLI - Perl extension for Fame C-HLI functions
=head1 SYNOPSIS

  use FameHLI::API;
  use FameHLI::API::HLI;
  my $rc = FameHLI::API::Cfmxxx(arg_list);

=head1 DESCRIPTION

The Perl/Fame-HLI functions are an attempt to package the 
C-HLI in Perl with as as few changes to the calling sequence 
as possible.  The most noticable change is that 'status' has
been moved out of the argument list and is now returned as
the return value of the function.

This port is written entirely in 'C' via XS.

=head1 CAVEAT

The I<Missing Values> functions aren't quite there yet.

=head1 EXPORT

None by default.

=head2 Exportable constants

  HMON HTUE HWED HTHU HFRI HSAT HSUN
  HAMON HATUE HAWED HATHU HAFRI HASAT HASUN

  HQTOCT HQTNOV HQTDEC
  HFYJAN HFYFEB HFYMAR HFYAPR HFYMAY HFYJUN
  HFYJUL HFYAUG HFYSEP HFYOCT HFYNOV HFYDEC
  HJAN HFEB HMAR HAPR HMAY HJUN
  HJUL HAUG HSEP HOCT HNOV HDEC
  HSMJUL HSMAUG HSMSEP HSMOCT HSMNOV HSMDEC
  HWAMON HWATUE HWAWED HWATHU HWAFRI HWASAT HWASUN
  HWBMON HWBTUE HWBWED HWBTHU HWBFRI HWBSAT HWBSUN
  HWKMON HWKTUE HWKWED HWKTHU HWKFRI HWKSAT HWKSUN
  HANJAN HANFEB HANMAR HANAPR HANMAY HANJUN
  HANJUL HANAUG HANSEP HANOCT HANNOV HANDEC
  FNUMNA FNUMNC FNUMND
  FPRCNA FPRCNC FPRCND
  HBEFOR HAFTER

and

  GLOBAL HABORT HALL HAPOST HAPPY HAYPP HBASRT HBATTR HBATYP HBBASI
  HBCLAS HBCNTX HBCONN HBCPU HBDATE HBDAY HBEGIN HBERNG HBFILE HBFLAB
  HBFLAG HBFMON HBFREQ HBFRI HBFUNC HBGLNM HBGROW HBGRP HBIMON HBINDX
  HBKEY HBLEN HBMISS HBMNOV HBMODE HBMON HBMONT HBNCHR HBNRNG HBOBJT
  HBOBSV HBOOLN HBOPT HBOPTV HBPER HBPHAS HBPROD HBPRSP HBREL HBRNG
  HBSAT HBSBUS HBSDAY HBSEL HBSRNG HBSRVR HBSUN HBSUND HBTHU HBTIME
  HBTUE HBUNIT HBUSER HBUSNS HBVER HBWED HBYEAR HCASEX HCEXI HCHANL
  HCHGAC HCLCHN HCLNLM HCLNT HCMODE HCONT HDAILY HDATE HDBCLM HDHOST
  HDMODE HDPRMC HDUP HDUTAR HEND HEXPIR HFAMER HFIN HFMENV HFRMLA
  HFUSE HFYAUT HFYFST HFYLST HGLFOR HGLNAM HHOUR HIFAIL HINITD HINTVL
  HITEM HLICFL HLICNS HLI_INCLUDED HLOCKD HLRESV HLSERV HMAXSCMD
  HMFILE HMGVAL HMIN HMONTH HMPOST HNAMEL HNAMLEN HNAMSIZ HNAVAL
  HNBACK HNCONN HNCVAL HNDVAL HNEMPT HNETCN HNFAME HNFILE HNFMDB
  HNINIT HNLALL HNLOCL HNMCA HNMVAL HNO HNOMEM HNOOBJ HNPOST HNRESW
  HNSUPP HNTMIS HNTWIC HNUFRD HNULLP HNUMRC HNWFEA HNWILD HOBANN HOBAVG
  HOBBEG HOBEND HOBFRM HOBHI HOBLO HOBSUM HOBUND HOEXI HOLDDB HOMODE
  HOPEND HOPENW HP1REQ HP2REQ HPACK HPRECN HPROTOTYPES_SUPPORTED
  HPWWOU HQUOTA HREAD HREADO HRECRD HRESFD HRMKEY HRMODE HRMTDB
  HRNEXI HSCALA HSCLLM HSEC HSERIE HSERVR HSMFIL HSMLEN HSMODE
  HSNFIL HSPCDB HSRVST HSTRNG HSUCC HSUSPN HTENDA HTMIS HTMOUT
  HTRUNC HTWICM HUMODE HUNCHG HUNDFT HUNDFX HUNEXP HUPDRD HWKOPN
  HWMODE HWRITE HYES


=head1 AUTHOR

=head2 Of The Perl5 Module

Dave Oberholtzer (daveo@obernet.com)

=head2 Of The C-HLI and hli.h

Fame Information Services (www.fame.com)

=head1 SEE ALSO

L<perl(1)>, L<FameHLI::API(3)>, L<FameHLI::EXT(3)>.

=cut
