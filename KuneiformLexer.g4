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
AT:        '@';
PERIOD:    '.';
ASSIGN:    '=';
//// sql scalar function expressions symbols
//// probably a different Lexical mode is a good idea
PLUS:      '+';
MINUS:     '-';
STAR:      '*';
DIV:       '/';
MOD:       '%';
TILDE:     '~';
PIPE2:     '||';
LT2:       '<<';
GT2:       '>>';
AMP:       '&';
PIPE:      '|';
EQ:        '==';
LT:        '<';
LT_EQ:     '<=';
GT:        '>';
GT_EQ:     '>=';
SQL_NOT_EQ1: '!=';
SQL_NOT_EQ2: '<>';
////


// keywords
DATABASE_: 'database';
USE_:      'use';
AS_:       'as';
TABLE_:    'table';
ACTION_:   'action';
INIT_:     'init';
PUBLIC_:   'public';
PRIVATE_:  'private';
VIEW_:     'view';
MUSTSIGN_: 'mustsign';
OWNER_:    'owner';
//// column type
INT_:      'int';
TEXT_:     'text';
BLOB_:     'blob';
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
//// sql keywords (make it top level keywords)
SELECT_:   [sS][eE][lL][eE][cC][tT];
INSERT_:   [iI][nN][sS][eE][rR][tT];
UPDATE_:   [uU][pP][dD][aA][tT][eE];
DELETE_:   [dD][eE][lL][eE][tT][eE];
WITH_:     [wW][iI][tT][hH]        ;
//// scalar functions expressions keyworkds
//// probably a different Lexical mode is a good idea
NOT_: 'not';
AND_: 'and';
OR_:  'or';
////

// literals
IDENTIFIER:
    [a-zA-Z] [a-zA-Z_0-9]*
;

INDEX_NAME: HASH IDENTIFIER;
PARAM_OR_VAR: DOLLAR IDENTIFIER;
BLOCK_VAR_OR_ANNOTATION: AT IDENTIFIER;

UNSIGNED_NUMBER_LITERAL:
    DIGIT+
;

STRING_LITERAL:
    SINGLE_QUOTE_STRING
;

SQL_KEYWORDS: SELECT_ | INSERT_ | UPDATE_ | DELETE_ | WITH_;
SQL_STMT: SQL_KEYWORDS WSNL+ ~[;}]+;

WS:            [ \t]        -> channel(HIDDEN);
TERMINATOR:    [\r\n]       -> channel(HIDDEN);
BLOCK_COMMENT: '/*' .*? '*/' -> channel(HIDDEN);
LINE_COMMENT:  '//' ~[\r\n]* -> channel(HIDDEN);

// fragments
fragment WSNL: [ \t\r\n]; // whitespace with new line
fragment DIGIT: [0-9];

//fragment DOUBLE_QUOTE_STRING_CHAR: ~["\r\n\\] | ('\\' .);
fragment SINGLE_QUOTE_STRING_CHAR: ~['\r\n\\] | ('\\' .);

//fragment DOUBLE_QUOTE_STRING: '"' DOUBLE_QUOTE_STRING_CHAR* '"';
fragment SINGLE_QUOTE_STRING: '\'' SINGLE_QUOTE_STRING_CHAR* '\'';

