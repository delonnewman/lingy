use strict; use warnings;
package Lingy::Test;

use base 'Exporter';

use Test::More;
use YAML::PP;

use Lingy;
use Lingy::RT;
use Lingy::Common;
use Lingy::ReadLine;

use Capture::Tiny qw'capture capture_merged';
use File::Temp 'tempfile';

BEGIN {
    $ENV{LINGY_TEST} //= 1;
    if (defined $INC{'Carp/Always.pm'}) {
        eval "no Carp::Always";
    }
}

use lib 'lib', './test/lib', './t/lib';

symlink 't', 'test' if -d 't' and not -e 'test';

my $ypp = YAML::PP->new;

our $gnu_readline =
    Term::ReadLine->new('')->ReadLine eq 'Term::ReadLine::Gnu';

RT->init;
$Lingy::RT::OK = 0;

our $lingy =
    -f './blib/script/lingy' ? './blib/script/lingy' :
    -f './bin/lingy' ? './bin/lingy' :
    undef;

our $eg =
    -d 'eg' ? 'eg' :
    -d 'example' ? 'example' :
    die "Can't find eg/example directory";

our @EXPORT = qw<
    done_testing
    is
    like
    note
    pass
    plan
    subtest
    use_ok

    capture
    capture_merged
    tempfile

    $lingy
    $eg

    rep
    run_is
    test
    test_out
    tests

    PPP WWW XXX YYY ZZZ
>;

sub collapse;
sub line;

sub import {
    strict->import;
    warnings->import;
    shift->export_to_level(1, @_);
}

sub rep {
    RT->rep(@_);
}

sub tests {
    my ($spec) = @_;
    my $list = $ypp->load_string($spec);
    for my $elem (@$list) {
        if (ref($elem) eq 'HASH'){
            my ($key, $val) = %$elem;
            no strict 'refs';
            $key->($val);
        } else {
            test(@$elem);
        }
    }
}

# Test 'rep' for return value or error:
my $test_i = 0;
sub test {
    RT->nextID(10);
    $test_i++;
    if ($ENV{ONLY} and $ENV{ONLY} != $test_i) {
        return;
    }
    my ($input, $want, $label) = @_;
    $label //= "'${\ collapse $input}' -> '${\line $want}'";

    $Lingy::RT::OK = 1;
    my $got = eval { join("\n", RT->rep($input)) };
    $got = $@ if $@;
    chomp $got;

    $got =~ s/^Error: //;

    if (ref($want) eq 'Regexp') {
        like $got, $want, $label;
    } elsif ($want =~ s{^/(.*)/$}{$1}) {
        like $got, qr/$want/, $label;
    } else {
        is $got, $want, $label;
    }
}

sub test_out {
    my ($input, $want, $label) = @_;
    $label //= "'${\ collapse $input}' -> '${\line $want}'";
    my ($got) = Capture::Tiny::capture_merged {
        RT->rep($input);
    };
    chomp $got;
    chomp $want;

    $got =~ s/^Error: //;

    if (ref($want) eq 'Regexp') {
        like $got, $want, $label;
    } else {
        is $got, $want, $label;
    }
}

sub run_is {
    my ($cmd, $want, $label) = @_;
    $label //= "'$cmd' -> '$want'";
    $label =~ s/\$cmd/$cmd/g;
    $label =~ s/\$want/$want/g;
    $label =~ s/\n/\\n/g;
    my $got = `( $cmd ) 2>&1`;
    chomp $got;
    if (ref($want) eq 'Regexp') {
        like $got, $want, $label;
    } else {
        chomp $got;
        is $got, $want, $label;
    }
}

sub collapse {
    local $_ = shift;
    s/\s\s+/ /g;
    s/^ //;
    chomp;
    $_;
}

sub line {
    local $_ = shift;
    s/\n/\\n/g;
    $_;
}

no warnings 'redefine';

my $done_testing = 0;
sub done_testing {
    return if $done_testing++;
    goto &Test::More::done_testing;
}

END {
    package main;
    done_testing();
}

1;
