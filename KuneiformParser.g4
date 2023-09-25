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
    (table_decl | action_decl | init_decl)*
    EOF
;

database_directive: DATABASE_ database_name;
extension_directive:
    USE_ extension_name
    (L_BRACE ext_config_list R_BRACE)?
    AS_ extension_name
    SCOL
;

ext_config_list:
    ext_config (COMMA ext_config)*
;

ext_config:
    ext_config_name COL ext_config_value
;

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
    | BLOB_
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

action_visibility:
    PUBLIC_
    | PRIVATE_
;

action_mutability:
    VIEW_
;

action_auxiliary:
    MUSTSIGN_
    | OWNER_
;

action_attr_list:
    (action_visibility | action_mutability | action_auxiliary)*
;

action_decl:
    ACTION_ action_name
    L_PAREN param_list R_PAREN
    action_attr_list
    L_BRACE
    action_stmt_list
    R_BRACE
;

param_list:
    parameter? (COMMA parameter)*
;

parameter:
    PARAM_OR_VAR
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

// parsed as action
init_decl:
    INIT_
    L_PAREN R_PAREN
    L_BRACE
    action_stmt_list
    R_BRACE
;

action_stmt_list:
    action_stmt+
;

action_stmt:
    sql_stmt
    | call_stmt
;

sql_stmt:
    SQL_STMT SCOL
;

call_stmt:
    (call_receivers ASSIGN)?
    call_body SCOL
;

call_receivers:
    variable (COMMA variable)*
;

call_body:
    fn_name L_PAREN fn_arg_list R_PAREN
;

variable:
    PARAM_OR_VAR
;

block_var:
    BLOCK_VAR
;

extension_call_name:
    IDENTIFIER PERIOD IDENTIFIER
;

//external_action_name:
//    IDENTIFIER PERIOD IDENTIFIER
//;

// function name
fn_name:
    extension_call_name
    | action_name
//    | external_action_name
;

// (inside action) scalar function name
sfn_name:
    IDENTIFIER
;

//fn_arg:
//    literal_value
//    | variable
//    | block_var
//;

fn_arg_list:
//    fn_arg? (COMMA fn_arg)*
    fn_arg_expr? (COMMA fn_arg_expr)*
;

// NOTE: this will only be used inside fn_arg_list, his is based on sqlparser's expr.
// This is only meant to support the most basic expressions.
//
// binary operators precedence: highest to lowest:
//   ||
//   * / %
//   << >> & |
//   < <= > >=
//   = == != <>
//   AND
//   OR
fn_arg_expr:
    // primary expressions(don't fit in operator pattern), order is irrelevant
    literal_value
    | variable
    | block_var
    // order is relevant for below expressions
    | L_PAREN elevate_expr=fn_arg_expr R_PAREN
    | ( MINUS | PLUS | TILDE ) unary_expr=fn_arg_expr
    // binary operators
    | fn_arg_expr PIPE2 fn_arg_expr
    | fn_arg_expr ( STAR | DIV | MOD ) fn_arg_expr
    | fn_arg_expr ( PLUS | MINUS) fn_arg_expr
    | fn_arg_expr ( LT2 | GT2 | AMP | PIPE ) fn_arg_expr
    | fn_arg_expr ( LT | LT_EQ | GT | GT_EQ ) fn_arg_expr
    | fn_arg_expr ( ASSIGN | EQ | SQL_NOT_EQ1 | SQL_NOT_EQ2 ) fn_arg_expr
    // logical operators
    | NOT_ unary_expr=fn_arg_expr
    | fn_arg_expr AND_ fn_arg_expr
    | fn_arg_expr OR_ fn_arg_expr
    // scalar functions
    | sfn_name L_PAREN ( (fn_arg_expr (COMMA fn_arg_expr)*) | STAR )? R_PAREN
;

// future expr, replace whole `call_body`?