#!/usr/bin/perl -w

=pod
=head1 $0 
=head2 script to convert roman numerals into arabic decimal notation
=cut

use strict;

my $debug = 0;

# set up roman to arabic hash
my %r2a = (
    'i' => 1,
    'v' => 5,
    'x' => 10,
    'l' => 50,
    'c' => 100,
    'm' => 1000
);

# instantiate running total and subtractor e.g. the 'I' in 'IV' must be carried to the next position and subtracted
my $total = 0;
my $subtractor = 0;
my @rn;

# validate input string
if ( not exists $ARGV[0] ) {
    print( $ARGV[0] );
    print( "Enter a roman numeral.\n" );
    exit -1;
} elsif ( length($ARGV[0]) > 0 ) {
    @rn = split(//, $ARGV[0]);
}

foreach my $char ( @rn ) {
    if ( not exists $r2a{$char} ) {
        print( "Invalid numeral '$char' in roman numeral '". str(@rn) . "'!" );
        exit -1;
    }
    if ( length($ARGV[0]) == 1 ) {
        print( "total is '$r2a{$char}'\n" );
        exit 0;
    }
}

# iterate validated string, adding to total or becoming subtractor
CHAR: foreach my $i ( 0 .. $#rn ) {
    print( "Processing $rn[$i]\n" ) if $debug;

    #  this position is subtractor if next is greater
    #XXX try:
    if ( $i < $#rn ) {
        if ( exists $r2a{$rn[$i+1]} && $r2a{$rn[$i+1]} > $r2a{$rn[$i]} ) {
            $subtractor = $r2a{$rn[$i]};
            print( "subtractor is '$subtractor'\n" ) if $debug;
            next CHAR;
        #XXX    continue
        # account for last position
        #XXXexcept IndexError:
        #XXX    pass
        }
    }

    # if we have a subtractor, subtract it from current value and add that to the total
    if ( $subtractor > 0 ) {
        print "found subtractor '$subtractor'\n" if $debug;
        my $to_add = $r2a{$rn[$i]} - $subtractor;
        print( "adding '$to_add' which is '$r2a{$rn[$i]}' minus '$subtractor'\n" ) if $debug;
        $subtractor = 0;
        $total += $to_add;
    # else add current value to total
    } else {
        print( "adding '$r2a{$rn[$i]}' without subtractor\n" ) if $debug;
        $total += $r2a{$rn[$i]};
    }
    $subtractor = 0;
}

    # return the running total
print "total is '$total'\n";
