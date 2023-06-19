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
    (extension_directive)*
    (table_decl | action_decl)*
    EOF
//    (database_directive | table_decl | action_decl)* EOF
;

database_directive: DATABASE_ database_name;
extension_directive:
    USE_ extension_name
    (L_BRACE ext_config_list R_BRACE)?
    (AS_ extension_name)?
    SCOL
;

ext_config_list:
    ext_config (COMMA ext_config)*
;

ext_config:
    ext_config_name COL ext_config_value
;

//directive: // a sentence that is informative, setting global state
//;

table_decl:
    TABLE_ table_name
    L_BRACE
    column_def_list
    (COMMA (index_def | foreign_key_def))*
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

foreign_key_action:
    (ACTION_ON_UPDATE_ | ACTION_ON_DELETE_)
    ACTION_DO_?
    (ACTION_DO_NO_ACTION_
    | ACTION_DO_RESTRICT_
    | ACTION_DO_SET_NULL_
    | ACTION_DO_SET_DEFAULT_
    | ACTION_DO_CASCADE_)
;

foreign_key_def:
    (FOREIGN_KEY_ | FOREIGN_KEY_ABBR_)
    L_PAREN column_name_list R_PAREN
    (REFERENCES_ | REFERENCES_ABBR_)
    table_name
    L_PAREN column_name_list R_PAREN
    foreign_key_action*
;

action_decl:
    ACTION_ action_name
    L_PAREN param_list R_PAREN
    (ACTION_OPEN_PUBLIC | ACTION_OPEN_PRIVATE)
    action_stmt_list
    ACTION_CLOSE
;

param_list:
    PARAMETER? (COMMA PARAMETER)*
;

database_name:
    IDENTIFIER
;

extension_name:
    IDENTIFIER
;

ext_config_name:
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

ext_config_value:
    literal_value
;

// --------- action statements ---------
// only for enforing syntax, won't actually parse

action_stmt_list:
    action_stmt+
;

action_stmt:
    a_sql_stmt
    | a_call_stmt
;

a_sql_stmt:
    A_SQL_STMT A_STMT_END
;

a_variable_name:
    A_VARIABLE
;

a_block_variable_name:
    A_REF
;

a_literal_value:
    A_STRING_LITERAL
    | A_UNSIGNED_NUMBER_LITERAL
;

a_fn_name:
    A_IDENTIFIER (PERIOD A_IDENTIFIER)?
;

a_call_receivers:
    a_variable_name (A_COMMA a_variable_name)*
;

a_call_stmt:
    (a_call_receivers EQ)?
    a_call_body  A_STMT_END
;

a_call_body:
    a_fn_name A_L_PAREN a_fn_arg_list A_R_PAREN
;

a_fn_arg_list:
    a_fn_arg? (A_COMMA a_fn_arg)*
;

a_fn_arg:
    a_literal_value
    | a_variable_name
    | a_block_variable_name
;