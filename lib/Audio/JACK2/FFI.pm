use strict;
use warnings;
package Audio::JACK2::FFI;

use Carp;
use FFI::Platypus 2.00;
use FFI::CheckLib 0.25; # lazy prereqs

use base qw/ Exporter /;

my $enum_JackOptions = {
    JackNullOption    => 0x00,
    JackNoStartServer => 0x01,
    JackUseExactName  => 0x02,
    JackServerName    => 0x04,
    JackLoadName      => 0x08,
    JackLoadInit      => 0x10,
    JackSessionID     => 0x20
};

my $enum_JackStatus = {
    JackFailure       => 0x01,
    JackInvalidOption => 0x02,
    JackNameNotUnique => 0x04,
    JackServerStarted => 0x08,
    JackServerFailed  => 0x10,
    JackServerError   => 0x20,
    JackNoSuchClient  => 0x40,
    JackLoadFailure   => 0x80,
    JackInitFailure   => 0x100,
    JackShmFailure    => 0x200,
    JackVersionError  => 0x400,
    JackBackendError  => 0x800,
    JackClientZombie  => 0x1000
};

my $enum_JackLatencyCallbackMode = {
    JackCaptureLatency  => 0,
    JackPlaybackLatency => 1
};

my $defines = {
    JACK_DEFAULT_AUDIO_TYPE => '32 bit float mono audio',
    JACK_DEFAULT_MIDI_TYPE => '8 bit raw midi'
};

my $types = {
    jack_shmsize_t => 'int32_t',
    jack_uuid_t => 'uint64_t',
    jack_nframes_t => 'uint32_t',
    jack_port_t => 'opaque',
    jack_client_t => 'opaque',
    jack_options_t => 'enum',
    jack_status_t => 'enum',
    jack_latency_callback_mode_t => 'enum',
    
};

my $binds = {
    jack_get_version              => [ [ 'int*', 'int*', 'int*', 'int*' ] => 'void', &_jack_get_version ],
    jack_get_version_string       => [ [ 'void' ] => 'string' ],
    jack_client_open              => [ [ 'string', 'jack_options_t', 'jack_status_t*' ], [ 'string' ] => 'jack_client_t' ],
    jack_client_close             => [ [ 'jack_client_t' ] => 'int' ],
    jack_client_name_size         => [ [ 'void' ] => 'int' ],
    jack_get_client_name          => [ [ 'jack_client_t' ] => 'string' ],
    jack_get_uuid_for_client_name => [ [ 'jack_client_t', 'string' ] => 'string' ],
    jack_get_client_name_by_uuid  => [ [ 'jack_client_t', 'string' ] => 'string' ],
    jack_activate                 => [ [ 'jack_client_t' ] => 'int' ],
    jack_deactivate               => [ [ 'jack_client_t' ] => 'int' ],
    jack_get_client_pid           => [ [ 'string' ] => 'int' ],
    # jack_client_thread_id
    jack_is_realtime              => [ [ 'jack_client_t' ] => 'int' ],
    jack_cycle_signal             => [ [ 'jack_client_t', 'int' ] => 'void' ],
    jack_set_freewheel            => [ [ 'jack_client_t', 'int' ] => 'int' ],
    jack_set_buffer_size          => [ [ 'jack_client_t', 'jack_nframes_t' ] => 'int' ],
    jack_get_sample_rate          => [ [ 'jack_client_t' ] => 'jack_nframes_t' ],
    jack_engine_takeover_timebase => [ [ 'jack_client_t' ] => 'int' ],
    jack_cpu_load                 => [ [ 'jack_client_t' ] => 'float' ],
    jack_port_register            => [ [ 'jack_client_t', 'string', 'string', 'unsigned long', 'unsigned long' ] => 'jack_port_t' ],
    jack_port_unregister          => [ [ 'jack_client_t', 'jack_port_t' ] => 'int' ],
    # jack_on_shutdown 
    # jack_set_process_thread
    # jack_set_thread_init_callback
    # jack_on_info_shutdown 
    # jack_set_process_callback 
    # jack_set_freewheel_callback 
    # jack_set_buffer_size_callback 
    # jack_set_sample_rate_callback 
    # jack_set_client_registration_callback 
    # jack_set_port_registration_callback 
    # jack_set_port_connect_callback 
    # jack_set_port_rename_callback 
    # jack_set_graph_order_callback 
    # jack_set_xrun_callback 
    # jack_set_latency_callback 

};

my $ffi;
BEGIN {
    $ffi = FFI::Platypus->new( api => 2 );
    $ffi->find_lib( lib => 'jack64' ); #Win32
    $ffi->find_lib( lib => 'jack') unless $ffi->lib;
    croak( "Could not find JACK2 libraries!" ) unless $ffi->lib;
}

sub _jack_get_version {

}

1;

=pod

=encoding UTF-8

=head1 NAME

Audio::JACK2::FFI - bindings for the JACK Audio Connection Kit API version 2.

=head1 VERSION

version 0.00

=head1 SYNOPSIS

Run away quite fast.

=cut
