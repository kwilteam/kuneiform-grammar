/*
 * A ANTLR4 grammar for Kuneiform.
 * Developed by the Kuneiform team.
*/

parser grammar KuneiformParser;

options {
    tokenVocab=KuneiformLexer;
}

source_unit:// databaseSpec then table or action declarations
    database_directive SCOL
    (table_decl | action_decl)*
    EOF
//    (database_directive | table_decl | action_decl)* EOF
;

database_directive: DATABASE_ database_name;

//directive: // a sentence that is informative, setting global state
//;

table_decl:
    TABLE_ table_name
    L_BRACE
    column_def_list
    (COMMA index_def_list)?
    (COMMA foreign_key_def_list)?
    COMMA? // optional comma
    R_BRACE
;

column_def:
    column_name column_type column_constraint*
;

column_def_list:
    column_def (COMMA column_def)*
;

column_type:
    INT_
    | TEXT_
;

column_constraint:
    PRIMARY_
    | NOT_NULL_
    | UNIQUE_
    | DEFAULT_ L_PAREN literal_value R_PAREN
    | MIN_ L_PAREN number_value R_PAREN
    | MAX_ L_PAREN number_value R_PAREN
    | MIN_LEN_ L_PAREN number_value R_PAREN
    | MAX_LEN_ L_PAREN number_value R_PAREN
;

literal_value:
    STRING_LITERAL
    | UNSIGNED_NUMBER_LITERAL
;

number_value:
    UNSIGNED_NUMBER_LITERAL
;

index_def:
    index_name
    (UNIQUE_ | INDEX_ | PRIMARY_)
    L_PAREN column_name_list R_PAREN
;

index_def_list:
    index_def (COMMA index_def)*
;

foreign_key_action:
    (ACTION_ON_UPDATE_ | ACTION_ON_DELETE_)
    ACTION_DO_
    (ACTION_DO_NO_ACTION_
    | ACTION_DO_RESTRICT_
    | ACTION_DO_SET_NULL_
    | ACTION_DO_SET_DEFAULT_
    | ACTION_DO_CASCADE_)
;

foreign_key_def:
    FOREIGN_KEY_
    L_PAREN column_name_list R_PAREN
    REFERENCES_ table_name
    L_PAREN column_name_list R_PAREN
    foreign_key_action*
;

foreign_key_def_list:
    foreign_key_def (COMMA foreign_key_def)*
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

database_name:
    IDENTIFIER
;

table_name:
    IDENTIFIER
;

action_name:
    IDENTIFIER
;

column_name:
    IDENTIFIER
;

column_name_list:
    column_name (COMMA column_name)*
;

index_name:
    INDEX_NAME
;

sql_keywords:
    SELECT_
    | INSERT_
    | UPDATE_
    | DELETE_
    | WITH_
;

sql_stmt:
    sql_keywords SQL_STMT SQL_END_SCOL
;

action_stmt:
    sql_stmt
;

action_stmt_list:
    action_stmt (action_stmt)*
;