/*
 * A ANTLR4 grammar for Kuneiform.
 * Developed by the Kuneiform team.
*/

lexer grammar KuneiformLexer;

// symbols
COL:       ':';
SCOL:      ';';
L_PAREN:   '(';
L_BRACE:   '{';
R_PAREN:   ')';
R_BRACE:   '}';
COMMA:     ',';
DOLLAR:    '$';
HASH:      '#';

// keywords
DATABASE_: 'database';
USE_:      'use';
AS_:       'as';
TABLE_:    'table';
ACTION_:   'action';
PUBLIC_:   'public';
PRIVATE_:  'private';
VIEW_:     'view';
INIT_:     'init';
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
FOREIGN_KEY_ABBR_:      'fk';
REFERENCES_:            'references';
REFERENCES_ABBR_:       'ref';
ACTION_ON_UPDATE_:      'on_update';
ACTION_ON_DELETE_:      'on_delete';
ACTION_DO_:             'do';
ACTION_DO_NO_ACTION_:   'no_action';
ACTION_DO_CASCADE_:     'cascade';
ACTION_DO_SET_NULL_:    'set_null';
ACTION_DO_SET_DEFAULT_: 'set_default';
ACTION_DO_RESTRICT_:    'restrict';
// sql keywords (make it top level keywords)
SELECT_:   [sS][eE][lL][eE][cC][tT];
INSERT_:   [iI][nN][sS][eE][rR][tT];
UPDATE_:   [uU][pP][dD][aA][tT][eE];
DELETE_:   [dD][eE][lL][eE][tT][eE];
WITH_:     [wW][iI][tT][hH]        ;

//// switch to ACTION_MODE
ACTION_OPEN: (PUBLIC_|PRIVATE_) (WSNL+ VIEW_)? WSNL* L_BRACE -> mode(ACTION_MODE);
INIT_OPEN: INIT_ WSNL* L_PAREN WSNL* R_PAREN WSNL* L_BRACE -> mode(ACTION_MODE);

// literals
IDENTIFIER:
    [a-zA-Z] [a-zA-Z_0-9]*
;

INDEX_NAME: HASH IDENTIFIER;
PARAMETER: DOLLAR IDENTIFIER;

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

WS:            [ \t]        -> channel(HIDDEN);
TERMINATOR:    [\r\n]       -> channel(HIDDEN);
BLOCK_COMMENT: '/*' .*? '*/' -> channel(HIDDEN);
LINE_COMMENT:  '//' ~[\r\n]* -> channel(HIDDEN);

// fragments
fragment WSNL: [ \t\r\n]; // whitespace with new line
fragment DIGIT: [0-9];

fragment DOUBLE_QUOTE_STRING_CHAR: ~["\r\n\\] | ('\\' .);
fragment SINGLE_QUOTE_STRING_CHAR: ~['\r\n\\] | ('\\' .);

fragment DOUBLE_QUOTE_STRING: '"' DOUBLE_QUOTE_STRING_CHAR* '"';
fragment SINGLE_QUOTE_STRING: '\'' SINGLE_QUOTE_STRING_CHAR* '\'';


// ----------------- ACTION_MODE -----------------
mode ACTION_MODE;
ACTION_CLOSE: R_BRACE -> mode(DEFAULT_MODE);

EQ:         '=';
PLUS:       '+';
PERIOD:     '.';
A_COMMA:    COMMA;
A_DOLLAR:   DOLLAR;
A_AT:       '@';
A_L_PAREN:  L_PAREN;
A_R_PAREN:  R_PAREN;
A_STMT_END: SCOL;

SQL_KEYWORDS: SELECT_ | INSERT_ | UPDATE_ | DELETE_ | WITH_;

A_IDENTIFIER: IDENTIFIER;
A_VARIABLE: A_DOLLAR A_IDENTIFIER;
A_REF: A_AT A_IDENTIFIER;
A_UNSIGNED_NUMBER_LITERAL: UNSIGNED_NUMBER_LITERAL;
A_SIGNED_NUMBER_LITERAL: SIGNED_NUMBER_LITERAL;
A_STRING_LITERAL: STRING_LITERAL;

// we only need sql statement as a whole, sql-parser will parse it
A_SQL_STMT: SQL_KEYWORDS ~[;}]+;

A_WS:            WS -> channel(HIDDEN);
A_TERMINATOR:    TERMINATOR -> channel(HIDDEN);
A_BLOCK_COMMENT: BLOCK_COMMENT -> channel(HIDDEN);
A_LINE_COMMENT:  LINE_COMMENT -> channel(HIDDEN);

// if not enforce syntax on call stmt, use this for action_stmt instead
//ACTION_STMT: ~[;}]+;