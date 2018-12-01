#! /bin/make

bf:
	mkdir -p build
	xcodebuild -scheme Brainfuck -archivePath build/bf.xcarchive archive
	cp ./build/bf.xcarchive/Products/usr/local/bin/Brainfuck-Interpreter /usr/local/bin/bf