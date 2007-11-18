# Test cases for token.c
# BEWARE: This file contains strange spacing (trailing spaces etc.), which is vital.
# Please edit carefully.

# A simple test case with several spaces
Name:	std
Run:	./test-tok
In:	   abc   
	10  20   30
Out:	<abc>
	<10>
	<20>
	<30>

# The same test case in line mode
Name:	std-l
Run:	./test-tok -l
In:	   abc   
	10  20   30
Out:	<abc>
	<>
	<10>
	<20>
	<30>
	<>

# An unterminated line
Name:	unterm
Run:	tr -d '\n' | ./test-tok
In:	abc
Out:	<abc>

# An unterminated line in line mode
Name:	unterm-l
Run:	tr -d '\n' | ./test-tok -l
In:	abc
Out:	<abc>

# Small token size limit, but fits
Name:	big1
Run:	./test-tok -s
In:	abcdefghijklmnop
Out:	<abcdefghijklmnop>

# Small token size limit, does not fit
Name:	big2
Run:	./test-tok -s
In:	abcdefghijklmnopq
Exit:	1

# Testing parsers
Name:	parse1
Run:	./test-tok -vl
In:	abcdef
	0 5 -5
Out:	<abcdef>
	<>
	<0> = int 0 = uint 0 = long 0 = ulong 0 = double 0.000000 = long_double 0.000000
	<5> = int 5 = uint 5 = long 5 = ulong 5 = double 5.000000 = long_double 5.000000
	<-5> = int -5 = long -5 = double -5.000000 = long_double -5.000000
	<>

# More parsing: integer extremes
Name:	parse2
Run:	./test-tok -v
In:	-2147483647 2147483647
	-2147483648 2147483648
	-4294967295 4294967295
	-4294967296 4294967296
Out:	<-2147483647> = int -2147483647 = long -2147483647 = double -2147483647.000000 = long_double -2147483647.000000
	<2147483647> = int 2147483647 = uint 2147483647 = long 2147483647 = ulong 2147483647 = double 2147483647.000000 = long_double 2147483647.000000
	<-2147483648> = int -2147483648 = long -2147483648 = double -2147483648.000000 = long_double -2147483648.000000
	<2147483648> = uint 2147483648 = ulong 2147483648 = double 2147483648.000000 = long_double 2147483648.000000
	<-4294967295> = double -4294967295.000000 = long_double -4294967295.000000
	<4294967295> = uint 4294967295 = ulong 4294967295 = double 4294967295.000000 = long_double 4294967295.000000
	<-4294967296> = double -4294967296.000000 = long_double -4294967296.000000
	<4294967296> = double 4294967296.000000 = long_double 4294967296.000000

# More parsing: floating point numbers
Name:	parse3
In:	1000000000
	0. .0 .
	0 +0 -0
	+5 -5
	+1e+5 -1e-5
	1e+99999
Out:	<1000000000> = int 1000000000 = uint 1000000000 = long 1000000000 = ulong 1000000000 = double 1000000000.000000 = long_double 1000000000.000000
	<0.> = double 0.000000 = long_double 0.000000
	<.0> = double 0.000000 = long_double 0.000000
	<.>
	<0> = int 0 = uint 0 = long 0 = ulong 0 = double 0.000000 = long_double 0.000000
	<+0> = int 0 = uint 0 = long 0 = ulong 0 = double 0.000000 = long_double 0.000000
	<-0> = int 0 = long 0 = double -0.000000 = long_double -0.000000
	<+5> = int 5 = uint 5 = long 5 = ulong 5 = double 5.000000 = long_double 5.000000
	<-5> = int -5 = long -5 = double -5.000000 = long_double -5.000000
	<+1e+5> = double 100000.000000 = long_double 100000.000000
	<-1e-5> = double -0.000010 = long_double -0.000010
	<1e+99999>
