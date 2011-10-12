# Brainfuck

## An Eight-Instruction Turing-Complete Programming Language

Brainfuck is the ungodly creation of Urban Müller, whose goal was apparently to
create a Turing-complete language for which he could write the smallest
compiler ever, for the Amiga OS 2.0. His compiler was 240 bytes in size.
(Though he improved upon this later -- he informed me at one point that he had
managed to bring it under 200 bytes.)

I originally started playing around with Brainfuck because of my own interest
in writing very small programs for x86 Linux. I also used it as a vehicle for
writing a program that created ELF files. Eventually, however, I too succumbed
to the Imp of the Perverse and wrote some actual Brainfuck programs of my own.

## The Language

A Brainfuck program has an implicit byte pointer, called "the pointer", which
is free to move around within an array of 30000 bytes, initially all set to
zero. The pointer itself is initialized to point to the beginning of this
array.

The Brainfuck programming language consists of eight commands, each of which is
represented as a single character.

* `>`   Increment the pointer.
* `<`   Decrement the pointer.
* `+`   Increment the byte at the pointer.
* `-`   Decrement the byte at the pointer.
* `.`   Output the byte at the pointer.
* `,`   Input a byte and store it in the byte at the pointer.
* `[`   Jump forward past the matching ] if the byte at the pointer is zero.
* `]`   Jump backward to the matching [ unless the byte at the pointer is zero.

The semantics of the Brainfuck commands can also be succinctly expressed in
terms of C, as follows (assuming that p has been previously defined as a
`char*`):

* `>`   becomes     `++p;`
* `<`   becomes     `--p;`
* `+`   becomes     `++*p;`
* `-`   becomes     `--*p;`
* `.`   becomes     `putchar(*p);`
* `,`   becomes     `*p = getchar();`
* `[`   becomes     `while (*p) {`
* `]`   becomes     `}`

