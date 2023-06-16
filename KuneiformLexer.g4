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
//// foreign key
FOREIGN_KEY_:           'foreign_key';
REFERENCES_:            'references';
ACTION_ON_UPDATE_:      'on_update';
ACTION_ON_DELETE_:      'on_delete';
ACTION_DO_:             'do';
ACTION_DO_NO_ACTION_:   'no_action';
ACTION_DO_CASCADE_:     'cascade';
ACTION_DO_SET_NULL_:    'set_null';
ACTION_DO_SET_DEFAULT_: 'set_default';
ACTION_DO_RESTRICT_:    'restrict';
//// switch to SQL_MODE
SELECT_:   [sS][eE][lL][eE][cC][tT] -> mode(SQL_MODE);
INSERT_:   [iI][nN][sS][eE][rR][tT] -> mode(SQL_MODE);
UPDATE_:   [uU][pP][dD][aA][tT][eE] -> mode(SQL_MODE);
DELETE_:   [dD][eE][lL][eE][tT][eE] -> mode(SQL_MODE);
WITH_:     [wW][iI][tT][hH]         -> mode(SQL_MODE);


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
mode SQL_MODE;
SQL_END_SCOL: SCOL -> mode(DEFAULT_MODE);
SQL_NL: [ \t\r\n]+ -> skip;
SQL_STMT: ~[;]+;

