#!/usr/bin/rdmd -unittest
/++
 + Authors: azet@azet.org
 + License: MIT License
++/
import std.stdio, std.string, std.math;

/// enable: compiler option -unittest
unittest {
	assert(func(1, -4));
	assert(func(1, 23.23232323));
	assert(func(0, 23));
}

/// function
bool func(bool bla, float bla2) {
	if(!bla) return 0;
	else if(sqrt(bla2)) return 1;
}


int main() { return 0; }