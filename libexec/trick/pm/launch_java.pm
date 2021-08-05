#!/usr/bin/perl
package launch_java ;
@ISA = qw(Exporter);
@EXPORT = qw(launch_java);

# launch_java determines trick_home based on execution location of the calling script.
use File::Basename ;
use Cwd 'abs_path';
use gte ;

sub launch_java($$) {

    my ($name, $application ) = @_ ;

    if ( ! exists $ENV{TRICK_HOME} ) {
        $trick_bin = dirname(abs_path($0)) ;
        $trick_home = dirname($trick_bin) ;

        # set TRICK_HOME based on the value of trick_home
        $ENV{TRICK_HOME} = $trick_home ;
    }

    if ( -e "$ENV{TRICK_HOME}/libexec/trick" ) {
        $lib_dir = "libexec" ;
    } else {
        $lib_dir = "lib" ;
    }
    $java_dir = "$ENV{TRICK_HOME}/$lib_dir/trick/java" ;

    $host_cpu = gte("TRICK_HOST_CPU") ;
    chomp($host_cpu) ;
    $ENV{TRICK_HOST_CPU} = $host_cpu ;

    if ( $^O eq "darwin" ) {
        $command = "java -classpath $java_dir/dist/*:$java_dir/lib/*:$java_dir/lib/ \\
             -Xdock:name=\"$name\" \\
             -Xdock:icon=$java_dir/resources/trick_icon.png \\
             $application" ;
    } else {
        $command = "java -cp $java_dir/dist/*:$java_dir/lib/*:$java_dir/lib/ $application" ;
    }

    foreach (@ARGV) {
       $command .= " $_";
    }

    system $command ;
    exit $? >> 8;
}

1;
