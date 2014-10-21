#!/usr/bin/perl -w

use Test;
BEGIN { plan tests => 8 }

use strict;
use Data::Dumper;
use Inline::Ruby qw(rb_eval);

my @exc = (
    ['divided by 0', 'ZeroDivisionError'],
    ["compile error\n(eval): parse error", 'SyntaxError'],
);

my $n = 0;
sub e {
    my $str = shift;
    eval { rb_eval($str) };
    return unless $@;
    my $x = $@;

    my $inspect = sprintf("#<%s: %s>", $x->type, $x->message);

    # Methods:
    ok($x->message, $exc[$n][0]);
    print Dumper $x->message;

    ok($x->type, $exc[$n][1]);
    print Dumper $x->type;

    ok($x->inspect, $inspect);
    print Dumper $x->inspect;

    # Stringification:
    ok("$x", "$inspect\n");
    print "Stringified: '$x'\n";

    # Backtrace (not tested)
    print Dumper $x->backtrace;

    $n++;
}

e "1/0";	# div by zero
e "1/";		# parse error
