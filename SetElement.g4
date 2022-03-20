grammar SetElement;

//Main
ELEMENT: 'Element';
SET: 'Set';

//Functions
MAIN : 'main';
VOID : 'void';
RETURN: 'return';
FUNCTION: 'function';

//Brackets
OPEN_CURLY_BRACKET : '{';
CLOSE_CURLY_BRACKET : '}';
OPEN_RECTANGULAR_BRACKET : '[';
CLOSE_RECTANGULAR_BRACKET : ']';
OPEN_BRACKET : '(';
CLOSE_BRACKET : ')';

//Conditional operators
IF: 'if';
ELSE: 'else';

//Math operators
UNION : '+';
INTERSECTION : '-';
CARTESIAN_MULTIPLICATION : '*';
SUBSTRACTION : '/';
ASSIGN : '=';
NEGATION : '!';
EQUAL: '==';
NON_EQUAL: '!=';

SET_OPERATION : UNION | INTERSECTION | CARTESIAN_MULTIPLICATION | SUBSTRACTION;

//Help-operators
DOT: '.';
COMMA : ',';

//
PRINT: 'print';
GET: 'get';

//Naming
LETTER: [a-zA-Z_];
DIGIT: [0-9];
NAME : (LETTER)+ (DIGIT)*;
SPACE :   [ \n\t\r]+ -> skip; // spaces are 'removed'
NUMBER : [0-9]+ ;
LINE : '"'(.)+?'"'; // print('"'Hello world'"') is correct.


initializeSetValue : OPEN_RECTANGULAR_BRACKET (NAME COMMA)* NAME CLOSE_RECTANGULAR_BRACKET;
type: SET|ELEMENT|VOID;

//function void main () {}
program: FUNCTION VOID MAIN functionBlock;
//{code_content}
functionBlock : OPEN_CURLY_BRACKET content* CLOSE_CURLY_BRACKET;
// Set set = [a,b];
setDeclaration: SET? NAME ASSIGN expression;
// Element element = 5;
elementDeclaration: ELEMENT? NAME ASSIGN (DIGIT|getExpression|functionCall);

//(element1,element2,set1)
inputSignature: OPEN_BRACKET (NAME COMMA)* NAME CLOSE_BRACKET;
// func(element1,set1) или func().
functionCall: (NAME type (inputSignature|(OPEN_BRACKET CLOSE_BRACKET)));


// (Set set1, Element element1, Element2,...)
signatureFunction: OPEN_BRACKET (type NAME COMMA)* (type NAME) CLOSE_BRACKET;
// function Element func(Set v1, Set v2, ...) { ... return v1 }
functionReturn : FUNCTION type NAME (signatureFunction|(OPEN_BRACKET CLOSE_BRACKET)) (blockReturn|blockNonReturn);

// { ... return v1 }
blockReturn : OPEN_CURLY_BRACKET content* RETURN NAME CLOSE_CURLY_BRACKET;
// { ... return }
blockNonReturn : OPEN_CURLY_BRACKET content* RETURN CLOSE_CURLY_BRACKET;

// [a,b] == [b,c]
equalCompare: (expression) (EQUAL|NON_EQUAL) (expression);
simpleCompare : equalCompare;
// !([a,b] == [b,c])
negationCompare : NEGATION OPEN_BRACKET simpleCompare CLOSE_BRACKET;
// if ([a] == [a]) { ... } else { ... }
ifBlock : IF OPEN_BRACKET (simpleCompare|negationCompare) CLOSE_BRACKET functionBlock elseBlock?;
elseBlock: ELSE functionBlock;

getExpression: NAME DOT GET OPEN_BRACKET NUMBER CLOSE_BRACKET;

// print('"'test'"')
print: PRINT OPEN_BRACKET LINE CLOSE_BRACKET;
// print(set)
printSet: PRINT OPEN_BRACKET NAME CLOSE_BRACKET;

// all possible operations with sets. can be used inline
expression:
        initializeSetValue
    |   NAME UNION NAME
    |   NAME INTERSECTION NAME
    |   NAME CARTESIAN_MULTIPLICATION NAME
    |   NAME SUBSTRACTION NAME
    |   NAME
    |   functionCall
    |   getExpression
    ;

// declare what can be contained in blocks, such as if () { ... }, while, main, etc.
content :
        print
    |   setDeclaration
    |   elementDeclaration
    |   printSet
    |   functionCall
    |   ifBlock
    |   elseBlock
    ;