#include <vector>
#include <stack>
#include <fstream>
#include <iostream>
#include <string>
#include <list>
#include <regex>

#define MAX_VALUE 32768

#include <termios.h>
#include <unistd.h>

int mygetch(void){
    struct termios oldt, newt;
    int ch;
    tcgetattr( STDIN_FILENO, &oldt );
    newt = oldt;
    newt.c_lflag &= ~( ICANON | ECHO );
    tcsetattr( STDIN_FILENO, TCSANOW, &newt );
    ch = getchar();
    tcsetattr( STDIN_FILENO, TCSANOW, &oldt );
    return ch;
}


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

typedef struct {
    char type;
    int operand;
    int position;
    int length;
}
pattern_t;

bool compare_pattern (pattern_t first, pattern_t second){
    return first.position < second.position;
}

int main (int argc, char** argv) {
    vector<instruction_t> program;
    list<pattern_t> patterns;
    pattern_t pattern;
    stack<unsigned int> loop_match;
    vector<int> memory( MAX_VALUE, 0);
    fstream file;
    instruction_t instruction;
    int pos = 0;
    unsigned int process = 0;
    char c, last_c, input;
    string source;
    string line;

    smatch match;
    regex zeroing_pattern ("\\[(\\+|-)\\]");

    if (argc >= 2) {
        file.open( argv[1], fstream::in);
    }
    else {
        cerr << "usage: " << endl << argv[0] << " <filename.bf>" << endl;
        return 1;
    }

    while (! file.eof() ) {
        c = file.get();
        if (c == '<' || c == '>' || c == '+' || c == '-' || c == '.' ||
            c == ',' || c == '[' || c == ']') {
            source.push_back(c);
        }
    }
    file.close();

    regex_iterator<string::iterator> rit ( source.begin(), source.end(), zeroing_pattern);
    regex_iterator<string::iterator> rend;

    while (rit!=rend) {
        pattern.type = '0';
        pattern.operand = 0;
        pattern.position = rit->position();
        pattern.length = rit->length();
        patterns.push_back(pattern);
        ++rit;
    }

    /*rit = regex_iterator<string::iterator> ( source.begin(), source.end(), zeroing_pattern);
    rend = regex_iterator<string::iterator> ();

    while (rit!=rend) {
        cout << rit->position() << endl;
        cout << rit->length() << endl;
        ++rit;
    }*/

    patterns.sort(compare_pattern);

    last_c = '\0';
    process = 0;
    for (int i = 0; i < source.size(); i++) {
        if(!patterns.empty()){
            pattern = patterns.front();

            if(pattern.position == i){
                patterns.pop_front();
                instruction.command = pattern.type;
                instruction.data.repetition = 1;
                program.push_back(instruction);
                process ++;
                i += pattern.length - 1;
                continue;
            }
        }

        c = source[i];

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

    if (!loop_match.empty()) {
        cerr << "unmatched bracket [ (instruction #" << loop_match.top() << ')' << endl;
        return 1;
    }

    process = 0;
    while (process < program.size()) {

        instruction = program[ process ];
        switch (instruction.command) {
            case '>':
                pos = (pos + instruction.data.repetition) % MAX_VALUE;
                break;
            case '<':
                pos -= instruction.data.repetition;
                while ( pos < 0) { pos += MAX_VALUE; }
                break;
            case '+':
                memory[pos] = (memory[pos] + instruction.data.repetition) % MAX_VALUE;
                break;
            case '-':
                memory[pos] -= instruction.data.repetition;
                while ( memory[pos] < 0) { memory[pos] += MAX_VALUE; }
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
                memory[pos] = mygetch();
                break;
            case '.':
                for (unsigned int i=0; i < instruction.data.repetition; i++) {
                    cout.put( memory[pos] );
                }
                break;

            /* non brainfuck instructions. Those are intermediate-generated
               by the compiler to optimize running time */
            case '0':
                memory[pos] = 0;
                break;

        }
        process ++;
    }

    return 0;
}

