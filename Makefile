#! /bin/make

bf: main.cpp
	$(CXX) -std=c++11 -stdlib=libc++ -o bf main.cpp

