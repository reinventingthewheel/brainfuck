#include <vector>
#include <stack>
#include <fstream>
#include <iostream>

#define MEMORY_SIZE 2048

using namespace std;

typedef struct {
    char command;
    union {
        unsigned int match;
        unsigned int repetition;
    }
    data;
}
instruction_t;

int main (int argc, char** argv) {

    vector<instruction_t> program;
    stack<unsigned int> loop_match;
    vector<int> memory(MEMORY_SIZE, 0);
    fstream file;
    instruction_t instruction;
    unsigned int pos = 0;
    unsigned int process = 0;
    char c, last_c, input;

    if (argc >= 2) {
        file.open( argv[1], fstream::in);
    }
    else {
        cerr << "usage: " << endl << argv[0] << " <filename.bf>" << endl;
        return 1;
    }

    last_c = '\0';
    process = 0;
    while (! file.eof() ) {
        c = file.get();
        if (c == '<' || c == '>' || c == '+' || c == '-' || c == '.' || 
            c == ',' || c == '[' || c == ']') {

            if (c == last_c && c != '[' && c != ']') {
                program.back().data.repetition ++;
            }
            else {
                instruction.command = c;
                if ( c == '[') {
                    loop_match.push( process );
                }
                else if ( c == ']') {
                    if (loop_match.empty()) {
                        cerr << "Error: unmatched bracket ] (instruction #" << process << ')' << endl;
                        file.close();
                        return 1;
                    }
                    else {
                        instruction.data.match = loop_match.top();
                        program[ loop_match.top() ].data.match = process;
                        loop_match.pop();
                    }
                }
                else {
                    instruction.data.repetition = 1;
                }
                program.push_back( instruction );
                process ++;
            }

            last_c = c;
        }
    }
    file.close();

    if (!loop_match.empty()) {
        cerr << "unmatched bracket [ (instruction #" << loop_match.top() << ')' << endl;
        return 1;
    }

    process = 0;
    while (process < program.size()) {

        instruction = program[ process ];
        switch (instruction.command) {
            case '>':
                pos = (pos + instruction.data.repetition) % MEMORY_SIZE;
                break;
            case '<':
                pos -= instruction.data.repetition;
                while ( pos < 0) { pos += MEMORY_SIZE; }
                break;
            case '+':
                memory[pos] += instruction.data.repetition;
                break;
            case '-':
                memory[pos] -= instruction.data.repetition;
                break;
            case '[':
                if (memory[pos] == 0) {
                    process = instruction.data.match;
                }
                break;
            case ']':
                if (memory[pos] != 0) {
                    process = instruction.data.match;
                }
                break;
            case ',':
                if (instruction.data.repetition > 1) {
                    cin.ignore( instruction.data.repetition - 1 );
                }
                memory[pos] = cin.get();
                break;
            case '.':
                for (unsigned int i=0; i < instruction.data.repetition; i++) {
                    cout.put( memory[pos] );
                }
                break;

        }
        process ++;
    }

    return 0;
}

