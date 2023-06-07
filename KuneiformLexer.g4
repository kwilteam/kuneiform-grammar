/*
 * A ANTLR4 grammar for Kuneiform.
 * Developed by the Kuneiform team.
*/

lexer grammar KuneiformLexer;

// symbols
SCOL:      ';';
L_PAREN:   '(';
L_BRACE:   '{';
R_PAREN:   ')';
R_BRACE:   '}';
COMMA:     ',';
PERIOD:    '.';
DOLLAR:    '$';
AT:        '@';
HASH:      '#';

// keywords
DATABASE_: 'database';
TABLE_:    'table';
ACTION_:   'action';
PUBLIC_:   'public';
PRIVATE_:  'private';
//// column type
INT_:      'int';
TEXT_:     'text';
//// column attrs
MIN_:      'min';
MAX_:      'max';
MIN_LEN_:  'minlen';
MAX_LEN_:  'maxlen';
NOT_NULL_: 'notnull';
PRIMARY_:  'primary';
DEFAULT_:  'default';
UNIQUE_:   'unique';
INDEX_:    'index';
//// sql stmt type
SELECT_:   [sS][eE][lL][eE][cC][tT] -> mode(SQL);
INSERT_:   [iI][nN][sS][eE][rR][tT] -> mode(SQL);
UPDATE_:   [uU][pP][dD][aA][tT][eE] -> mode(SQL);
WITH_:     [wW][iI][tT][hH]         -> mode(SQL);


// literals
IDENTIFIER:
    [a-zA-Z] [a-zA-Z_0-9]*
;

INDEX_NAME: '#' IDENTIFIER;
ACTION_PARAMETER: '$' IDENTIFIER;

UNSIGNED_NUMBER_LITERAL:
    DIGIT+
;

SIGNED_NUMBER_LITERAL:
    [+-]? DIGIT+
;

STRING_LITERAL:
    DOUBLE_QUOTE_STRING
    | SINGLE_QUOTE_STRING
;

WS:            [ \t]+        -> channel(HIDDEN);
TERMINATOR:    [\r\n]+       -> channel(HIDDEN);
BLOCK_COMMENT: '/*' .*? '*/' -> channel(HIDDEN);
LINE_COMMENT:  '//' ~[\r\n]* -> channel(HIDDEN);

UNEXPECTED_CHAR: .;

// fragments
fragment DIGIT: [0-9];

fragment DOUBLE_QUOTE_STRING_CHAR: ~["\r\n\\] | ('\\' .);
fragment SINGLE_QUOTE_STRING_CHAR: ~['\r\n\\] | ('\\' .);

fragment DOUBLE_QUOTE_STRING: '"' DOUBLE_QUOTE_STRING_CHAR* '"';
fragment SINGLE_QUOTE_STRING: '\'' SINGLE_QUOTE_STRING_CHAR* '\'';


// ----------------- Everything Follows a SQL keyword ---------------------
mode SQL;
SQL_END: SCOL -> mode(DEFAULT_MODE);
S_NL: [ \t\r\n]+ -> skip;
S_RAW_SQL: ~[;]+;

