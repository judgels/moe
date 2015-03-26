#!/usr/bin/perl
use common::sense;

# FIXME: Tie to specified machines

# Parses login.tex
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';
while (<STDIN>) {
	chomp;
	s[^\\user\{][] or next;
	s[}$][] or die;
	my ($login, $passwd, $full) = split /}{/;
	my ($fn, $ln) = split /\s+/, $full;
	print "cmsAddUser -c 1 -p '$passwd' '$fn' '$ln' '$login'\n";
}
