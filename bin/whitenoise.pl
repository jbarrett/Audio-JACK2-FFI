#!/usr/bin/env perl

use FindBin qw($Bin);
use lib "$Bin/../lib";

use Audio::JACK2::FFI;

my $client = jack_client_open( "Perl whitenoise", JackNullOption );

my $port = jack_port_register ( $client, "output", JACK_DEFAULT_AUDIO_TYPE, 0x2 );

jack_set_process_callback ( $client, \&process );

jack_activate( $client );

sub process {
    my ( $nframes, $arg ) = @_;
    die $nframes;
}


sleep;
