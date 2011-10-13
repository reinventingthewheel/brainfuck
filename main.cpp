#include <vector>
#include <fstream>
#include <iostream>

#define MEMORY_SIZE 2048

using namespace std;

int findOpening(const vector<char> &program, int pos) {
    int stack = 0;

    while (pos >= 0) {

        if (program[pos] == ']') { stack ++; }
        else if (program[pos] == '[') { 
            stack --; 
            if (stack == 0) { return pos; }
        }

        pos--;
    }

    return -1;
}

int findClosing(const vector<char> &program, int pos) {
    int stack = 0;

    while (pos < program.size() ) {

        if (program[pos] == '[') { stack ++; }
        else if (program[pos] == ']') { 
            stack --; 
            if (stack == 0) { return pos; }
        }

        pos++;
    }

    return -1;
}

int main (int argc, char** argv) {

    vector<char> program;
    vector<int> memory(MEMORY_SIZE, 0);
    fstream file;
    int pos = 0;
    int process = 0;
    char c, input;

    if (argc >= 2) {
        file.open( argv[1], fstream::in);
    }
    else {
        cerr << "usage: " << endl << argv[0] << " <filename.bf>" << endl;
        return 1;
    }

    while (! file.eof() ) {
        file >> c;
        if (c == '<' || c == '>' || c == '+' || c == '-' || c == '.' || 
            c == ',' || c == '[' || c == ']') {
            program.push_back( c );
        }
    }
    file.close();

    while (process < program.size()) {

        switch (program[process]) {
            case '>':
                pos = (pos + 1) % MEMORY_SIZE;
                break;
            case '<':
                pos = (pos + (MEMORY_SIZE - 1)) % MEMORY_SIZE;
                break;
            case '+':
                memory[pos] ++;
                break;
            case '-':
                memory[pos] --;
                break;
            case '[':
                if (memory[pos] == 0) {
                    process = findClosing( program, process);
                    if (process == -1) {
                        cerr << "unable to find closing ] at line " << process << endl;
                        return 1;
                    }
                }
                break;
            case ']':
                if (memory[pos] != 0) {
                    process = findOpening( program, process);
                    if (process == -1) {
                        cerr << "unable to find opening [ at line " << process << endl;
                        return 1;
                    }
                }
                break;
            case ',':
                memory[pos] = cin.get();
                break;
            case '.':
                cout.put( memory[pos] );
                break;

        }
        process ++;
    }

    return 0;
}

