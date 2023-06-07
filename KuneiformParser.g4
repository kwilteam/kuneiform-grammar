/*
 * A ANTLR4 grammar for Kuneiform.
 * Developed by the Kuneiform team.
*/

parser grammar KuneiformParser;

options {
    tokenVocab=KuneiformLexer;
}

sourceUnit:// databaseSpec then table or action declarations
    (database_directive | table_decl | action_decl)* EOF
;

database_directive: DATABASE_ IDENTIFIER SCOL;

//directive: // a sentence that is informative, setting global state
//;

declaration: // a sentence that declare a type of structure, not actually execute anything
    table_decl | action_decl
;

table_decl:
    TABLE_ table_name
    L_BRACE
    column_def_list
    (COMMA index_def_list)?
    R_BRACE
;

table_name:
    IDENTIFIER
;

column_def:
    column_name column_type column_constraint*
;

column_def_list:
    column_def (COMMA column_def)*
;

column_name:
    IDENTIFIER
;

column_name_list:
    column_name (COMMA column_name)*
;

column_type:
    INT_
    | TEXT_
;

column_constraint:
    PRIMARY_
    | DEFAULT_ L_PAREN (STRING_LITERAL | UNSIGNED_NUMBER_LITERAL) R_PAREN
    | MIN_ L_PAREN UNSIGNED_NUMBER_LITERAL R_PAREN
    | MAX_ L_PAREN UNSIGNED_NUMBER_LITERAL R_PAREN
    | MIN_LEN_ L_PAREN UNSIGNED_NUMBER_LITERAL R_PAREN
    | MAX_LEN_ L_PAREN UNSIGNED_NUMBER_LITERAL R_PAREN
    | NOT_NULL_
    | UNIQUE_
;

index_def:
    INDEX_NAME
    (UNIQUE_ | INDEX_)
    L_PAREN column_name_list R_PAREN
;

index_def_list:
    index_def (COMMA index_def)*
;

action_decl:
    ACTION_ action_name
    L_PAREN action_param_list R_PAREN
    (PUBLIC_ | PRIVATE_)
    L_BRACE
    action_stmt_list
    R_BRACE
;

action_param_list:
    ACTION_PARAMETER? (COMMA ACTION_PARAMETER)*
;

action_name:
    IDENTIFIER
;

action_stmt:
    sql_stmt
;

sql_keywords:
    SELECT_
    | INSERT_
    | UPDATE_
    | WITH_
;

sql_stmt:
    sql_keywords S_RAW_SQL SQL_END
;

action_stmt_list:
    action_stmt (action_stmt)*
;