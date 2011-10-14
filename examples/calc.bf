======== Symbols ==========

#0      limit
#1      currentChar
#2      readChar
#4      limitCopy
#5      newLine
#6      aux
#7      baseChar
#8      space
#10     operand1Start
#20     operand2Start

===========================


==================================== HEADER ==========================================

>>>>>++++++++++             #newLine = 10('\n')
>++++++                     #aux=6
[                           #while aux
    -                           #decrement aux
    >++++++++++                 #baseChar plus 10
    >++++++<                    #space plus 6
    <                           #go to aux
]
>>----                      #space = 32(\s)
<+++++                      #baseChar = 65(A)


++.--.+++++++++++.---------.++++++++++++++++++.---------.   #print 'CALCU'
-----------.+++++++++++++++++++.-----.+++.                  #print 'LATOR'
<<..                                                        #print '\n' 2 times

======================================================================================



=============================== READING OPERAND1 =====================================

>>-------------                                             #sets BaseChar to E

.+++++++++.++++++.---------------.+++++++++++++.                #print 'ENTER'
>.<---------------- -.>.<                                       #print ' A '
+++++++++++++.+++++++.--------.-----------.+++.+++++++++++++.   #print 'NUMBER'
------------------------.>.<                                    #print ': '
+++++++++++                                                     #set BaseChar to 'E'


<<<<<<<

++++                        #limit = 4
>>+                         #readChar = true
[                           #while readChar
    -                           #readChar = false
    <                           #go to currentChar
    ,.                          #currentChar = readch()
    ----------                  #currentChar minus 10
    [                           #if currentChar minus 10
        <->                         #decrement limit
        ++++++++++                  #restores currentChar value
        >>>>>>>>>>                  #go to first char of operand1
        [>]                         #go to first available slot on operand1
        +                           #increment slot
        [<]                         #backs to operand1Start
        <<<<<<<<<                   #backs to currentChar
        -                           #decrement currentChar
        [                           #while currentChar
            -                           #decrement currentChar
            >>>>>>>>>>                  #go to first char of operand1
            [>]<                        #go to last char of operand1
            +                           #increment slot
            [<]                         #backs to operand1Start
            <<<<<<<<<                   #backs to currentChar
        ]
        <[                          #if limit
            >>+<<                       #readChar = true
            [->>>>+<<<<]                #tranfer limit to limitCopy
        ]
        >>>>[-<<<<+>>>>]            #transfer limitCopy to limit
        <<<                         #go to currentChar
    ]
    >                               #go to readChar
]

>>>.                                #print '\n'

======================================================================================


=============================== READING OPERAND2 =====================================

>>                                                          #go to BaseChar

.+++++++++.++++++.---------------.+++++++++++++.                #print 'ENTER'
>.<---------------- -.>.<                                       #print ' A '
+++++++++++++.+++++++.--------.-----------.+++.+++++++++++++.   #print 'NUMBER'
------------------------.>.<                                    #print ': '
+++++++                                                         #set BaseChar to 'A'


<<<<<<<

++++                        #limit = 4
>>+                         #readChar = true
[                           #while readChar
    -                           #readChar = false
    <                           #go to currentChar
    ,.                          #currentChar = readch()
    ----------                  #currentChar minus 13
    [                           #if currentChar minus 13
        <->                         #decrement limit
        ++++++++++                  #restores currentChar value
        >>>>>>>>>>>>>>>>>>>>        #go to first char of operand2
        [>]                         #go to first available slot on operand2
        +                           #increment slot
        [<]                         #backs to operand2Start
        <<<<<<<<<<<<<<<<<<<         #backs to currentChar
        -                           #decrement currentChar
        [                           #while currentChar
            -                           #decrement currentChar
            >>>>>>>>>>>>>>>>>>>>        #go to first char of operand2
            [>]<                        #go to last char of operand2
            +                           #increment slot
            [<]                         #backs to operand2Start
            <<<<<<<<<<<<<<<<<<<         #backs to currentChar
        ]
        <[                          #if limit
            >>+<<                       #readChar = true
            [->>>>+<<<<]                #tranfer limit to limitCopy
        ]
        >>>>[-<<<<+>>>>]            #transfer limitCopy to limit
        <<<                         #go to currentChar
    ]
    >                               #go to readChar
]

>>>.                                #print '\n'

======================================================================================



======== Symbols ==========
#0      operand1Int
#1      operand2Int
#2      currentDigit
#3      factor
#4      factorCopy
#5      multipliedDigit
#6      ten
#7      currentDigitCopy
#10     operand1Start
#20     operand2Start

===========================



=============================== CONVERTING OPERAND1 ==================================
<<<<<                               #go to 0
[-]>[-]>[-]>[-]>[-]>[-]>[-]>[-]     #resets positions 0 to 7
<<<<<<<                             #go to 0
>>>+                                #factor=1
>>>>>>>>                            #go to first char of operand1
[>]<                                #go to last char of operand1

[                                   #loops from last to first char of operand1
    [->+<]                              #shift right last char of operand1
    >[-<<[<]<<<<<<<<+>>>>>>>>>[>]>]     #transfer value to currentDigit
    <<[<]<<<<<<<<                       #go to currentDigit
    ---------- ---------- ----------    #currentDigit minus 30
    ---------- --------                 #currentDigit to int
    >                                   #go to factor
    [                                   #while factor
        -                                   #decrement factor
        >+                                  #increment factorCopy
        <<                                  #go to currentDigit
        [                                   #while currentDigit
            -                                   #decrement currentDigit
            >>>+                                #increment multipliedDigit
            >>+                                 #increment currentDigitCopy
            <<<<<                               #go to currentDigit
        ]
        >>>>>[-<<<<<+>>>>>]                 #restores currentDigitCopy into currentDigit
        <<<<                                #go to factor
    ]
    >>[-<<<<<+>>>>>]                    #adds multipliedDigit to operand1Int
    <                                   #go to factorCopy
    [                                   #while factorCopy
        -                                   #decrement factorCopy
        >>++++++++++                        #ten = 10
        [-<<<+>>>]                          #increment factor 10 times
        <<                                  #go to factorCopy
    ]
    <<[-]                               #resets currentDigit
    >>>>>>>>>[>]<                       #go to new last char of operand1
]

<<<<<<<<<<                              #go to #0

======================================================================================


======== Symbols ==========
#0      operand1Int
#1      operand2Int
#2      currentDigit
#3      factor
#4      factorCopy
#5      multipliedDigit
#6      ten
#7      currentDigitCopy
#10     operand1Start
#20     operand2Start

===========================

=============================== CONVERTING OPERAND2 ==================================
>[-]>[-]>[-]>[-]>[-]>[-]>[-]        #resets positions 1 to 7
<<<<<<                              #go to 1
>>+                                 #factor=1
>>>>>>>>>>>>>>>>>>                  #go to first char of operand2
[>]<                                #go to last char of operand2

[                                   #loops from last to first char of operand2
    [->+<]                              #shift right last char of operand2

    >[-<<[<]<<<<<<<<<<<<<<<<<<+
           >>>>>>>>>>>>>>>>>>>[>]>]     #transfer value to currentDigit

    <<[<]<<<<<<<<<<<<<<<<<<             #go to currentDigit
    ---------- ---------- ----------    #currentDigit minus 30
    ---------- --------                 #currentDigit to int
    >                                   #go to factor
    [                                   #while factor
        -                                   #decrement factor
        >+                                  #increment factorCopy
        <<                                  #go to currentDigit
        [                                   #while currentDigit
            -                                   #decrement currentDigit
            >>>+                                #increment multipliedDigit
            >>+                                 #increment currentDigitCopy
            <<<<<                               #go to currentDigit
        ]
        >>>>>[-<<<<<+>>>>>]                 #restores currentDigitCopy into currentDigit
        <<<<                                #go to factor
    ]
    >>[-<<<<+>>>>]                      #adds multipliedDigit to operand2Int
    <                                   #go to factorCopy
    [                                   #while factorCopy
        -                                   #decrement factorCopy
        >>++++++++++                        #ten = 10
        [-<<<+>>>]                          #increment factor 10 times
        <<                                  #go to factorCopy
    ]
    <<[-]                               #resets currentDigit
    >>>>>>>>>>>>>>>>>>>[>]<             #go to new last char of operand1
]

<<<<<<<<<<<<<<<<<<<                     #go to new last char of operand2Int

======================================================================================

[-<+>]                                  #sum operand2Int into operand1Int
<                                       #go to operand1Int




======== Symbols ==========
#0      result
#1      intDigit
#2      digits
#3      exponent
#4      tmp
#5      divisor
#6      nextDivisor
#7      resultCopy
#8      isZero
===========================

>[-]>[-]>[-]>[-]>[-]>[-]>[-]>[-]>[-]    #resets slots 1 to 9
<<<<<<<<<                               #go to #0

================================ CONVERTING RESULT ===================================

>>+++++                                 #digits=5
[                                       #while digits
    >[-]                                    #exponent=0
    >[-]                                    #tmp =0
    >[-]                                    #divisor=0
    <<<[->+>+<<]                            #tmp = exponent = digits
    >>[-<<+>>]                              #digits = tmp
    >+                                      #divisor = 1
    <<-                                     #decrement exponent
    [                                       #while exponent
        -                                       #decrement exponent
        >>[                                     #while divisor
            -                                       #decrement divisor
            <++++++++++                             #tmp=10
            [                                       #while tmp
                -                                       #decrement tmp
                >>+                                     #increment nextDivisor
                <<                                      #go to tmp
            ]
            >                                       #go to divisor
        ]
        >[-<+>]                                 #divisor = nextDivisor
        <<<                                     #go to exponent
    ]

    <<<                                     #go to result
    [->>>>+>>>+<<<<<<<]                     #tmp = resultCopy = result
    >>>>[-<<<<+>>>>]                        #result = tmp
    >>>                                     #go to resultCopy

    [                                       #while resultCopy
        <<<<<<+                                 #increment intDigit
        >>>>>>>[-]                              #isZero = false
        <<<[                                    #while divisor
            -                                       #decrement divisor
            >+                                      #increment nextDivisor
            >-                                      #decrement resultCopy
            >[                                      #if isZero
                <+                                      #avoids negative resultCopy
                <<[->+<]                                #resets divisor
                <<<<-                                   #undo intDigit increment
                >>>>>>>-                                #resets isZero
            ]
            +                                       #isZero = true
            <[                                      #if resultCopy:
                >-                                      #isZero = false
                <[-<<<+>>>]                             #tmp = resultCopy
            ]
            <<<[->>>+<<<]                           #restores resultCopy from tmp
            >                                       #go to divisor
        ]
        >[-<+>]                                 #divisor = nextDivisor
        >                                       #go to resultCopy
    ]

    <<<<<< ++++++++++++++++++++++++++++++++++++++++++++++++ .
           ------------------------------------------------

    [                                           #while intDigit
        -                                           #decrement intDigit
        >>>>>[-]                                    #nextDivisor = 0
        <[                                          #while divisor
            -                                           #decrement divisor
            >+                                          #increment nextDivisor
            <<<<<<-                                     #decrement result
            >>>>>                                       #go to divisor
        ]
        >[-<+>]                                     #divisor = nextDivisor
        <<<<<                                       #go to intDigit
    ]

    >-                                  #decrement digits
]

++++++++++.                             #print \n

======================================================================================