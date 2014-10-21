# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

use Test;
use Data::Dumper;
BEGIN { plan tests => 15 }
END {print "not ok 1\n" unless $loaded;}
use Inline Ruby;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

# A non-method:
print "not " unless some_function(17) == 42;
print "ok 2\n";

# A non-method with an iterator:
print "not " unless iter(sub{ $_[0] + 25 })->some_iter(17) == 42;
print "ok 3\n";

# Create a new object:
my $o = Stumpme->new;

# Instance and class methods:
$o->inst_method(4, 5, 6);
Stumpme->class_method(7, 8, 9);

# With iterators:
$o->iter(sub{ print "ok $_[0]\n" })->inst_iterator(10, 11, 12);
Stumpme->iter(sub{ print "ok $_[0]\n" })->class_iterator(13, 14, 15);

__END__
__Ruby__

class Stumpme
  def inst_method(*args)
    args.each { |x| print "ok #{x}\n" }
  end
  def Stumpme.class_method(*args)
    args.each { |x| print "ok #{x}\n" }
  end
  def inst_iterator(*args) 
    args.each { |x| yield x }	# calls back into Perl
  end
  def Stumpme.class_iterator(*args)
    args.each { |x| yield x}	# calls back into Perl
  end
end

def some_function(a)
  print "Inside ruby's some_function(a) method. A is '#{a}'.\n"
  return 42
end

def some_iter(a)
  yield a
end
