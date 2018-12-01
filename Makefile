#! /bin/make

all::
	mkdir -p build
	xcodebuild -scheme Brainfuck -archivePath build/bf.xcarchive archive
	cp ./build/bf.xcarchive/Products/usr/local/bin/Brainfuck-Interpreter /usr/local/bin/bf
	cp ./build/bf.xcarchive/Products/usr/local/bin/Brainfuck-Interpreter bf