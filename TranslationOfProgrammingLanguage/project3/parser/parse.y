// Generated by transforming |cwd:///work-in-progress/2.7.2-bisonified.y| on 2016-11-23 at 15:46:56 +0000
%{
#include <iostream>
#include <string>
#include <map>
#include <stack>

int yylex (void);

extern char *yytext;
void yyerror (const char *);

// This struct is used to store name, start location and complexity of a function
struct func_info {
	std::string f_name; // Store the name of the function or class
	int f_begin_loc;	// Store the starting line of the function
	int f_begin_col;	// Store the starting column of the function
	int f_complexity = 0; // Store the complexity of the funciton
};

// Set global variable to store the current function
func_info *fi;
// Record whether a finally is along with try.
bool finally_exist;
// Record whether a function is within a class.
int class_scope = 0;
// Store the class name for further use.
std::string class_name = "";
// Get the output in inverse order to match the mccabe result.
std::stack<func_info> inverse_stack;
// Make a decorate flag
bool deco_flag;
// The print function.
void print_complexity_in_case();
%}

// 83 tokens, in alphabetical order:
%token AMPEREQUAL AMPERSAND AND AS ASSERT AT BACKQUOTE BAR BREAK CIRCUMFLEX
%token CIRCUMFLEXEQUAL CLASS COLON COMMA CONTINUE DEDENT DEF DEL DOT DOUBLESLASH
%token DOUBLESLASHEQUAL DOUBLESTAR DOUBLESTAREQUAL ELIF ELSE ENDMARKER EQEQUAL
%token EQUAL EXCEPT EXEC FINALLY FOR FROM GLOBAL GREATER GREATEREQUAL GRLT
%token IF IMPORT IN INDENT IS LAMBDA LBRACE LEFTSHIFT LEFTSHIFTEQUAL LESS
%token LESSEQUAL LPAR LSQB MINEQUAL MINUS NAME NEWLINE NOT NOTEQUAL NUMBER
%token OR PASS PERCENT PERCENTEQUAL PLUS PLUSEQUAL PRINT RAISE RBRACE RETURN
%token RIGHTSHIFT RIGHTSHIFTEQUAL RPAR RSQB SEMI SLASH SLASHEQUAL STAR STAREQUAL
%token STRING TILDE TRY VBAREQUAL WHILE WITH YIELD

%start start

%locations

%union
{
	char* str;
	int complexity;
}

%type <str> NAME
%type <complexity> suite stmt plus_stmt compound_stmt if_stmt while_stmt for_stmt
%type <complexity> try_stmt star_ELIF plus_except opt_FINALLY classdef funcdef with_stmt

%%

start
	: file_input
	{
		print_complexity_in_case();
	}
	;
file_input // Used in: start
	: star_NEWLINE_stmt ENDMARKER
	;
pick_NEWLINE_stmt // Used in: star_NEWLINE_stmt
	: NEWLINE
	| stmt
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt pick_NEWLINE_stmt
	| %empty
	;
decorator // Used in: decorators
	: AT dotted_name LPAR opt_arglist RPAR NEWLINE
	| AT dotted_name NEWLINE
	;
opt_arglist // Used in: decorator, trailer
	: arglist
	| %empty
	;
decorators // Used in: decorators, decorated
	: decorators decorator
	| decorator
	;
decorated // Used in: compound_stmt
	: decorators {deco_flag = true;} classdef
	| decorators {deco_flag = true;} funcdef
	;
funcdef // Used in: decorated, compound_stmt
	: DEF NAME parameters COLON suite
	{
		fi = new func_info();
		fi->f_begin_loc = @1.first_line;
		fi->f_begin_col = @1.first_column;
		if (class_scope > 0) {
			fi->f_name = class_name + "." + $2;
		}
		else{
			fi->f_name = $2;
		}
		fi->f_complexity = $5 + 1;
		inverse_stack.push(*fi);
		delete [] $2;
		//std::cout << "class_name1" << fi->f_name << std::endl;
		delete fi;
		//std::cout << "class_name2" << $5 << std::endl;
	}
	;
parameters // Used in: funcdef
	: LPAR varargslist RPAR
	| LPAR RPAR
	;
varargslist // Used in: parameters, old_lambdef, lambdef
	: star_fpdef_COMMA pick_STAR_DOUBLESTAR
	| star_fpdef_COMMA fpdef opt_EQUAL_test opt_COMMA
	;
opt_EQUAL_test // Used in: varargslist, star_fpdef_COMMA
	: EQUAL test
	| %empty
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef opt_EQUAL_test COMMA
	| %empty
	;
opt_DOUBLESTAR_NAME // Used in: pick_STAR_DOUBLESTAR
	: COMMA DOUBLESTAR NAME
	{ delete [] $3;}
	| %empty
	;
pick_STAR_DOUBLESTAR // Used in: varargslist
	: STAR NAME opt_DOUBLESTAR_NAME
	{ delete [] $2;}
	| DOUBLESTAR NAME
	//{	delete [] $2;	}
	;
opt_COMMA // Used in: varargslist, opt_test, opt_test_2, testlist_safe, listmaker, testlist_comp, pick_for_test_test, pick_for_test, pick_argument
	: COMMA
	| %empty
	;
fpdef // Used in: varargslist, star_fpdef_COMMA, fplist, star_fpdef_notest
	: NAME
	{ delete [] $1;}
	| LPAR fplist RPAR
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest COMMA
	| fpdef star_fpdef_notest
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest COMMA fpdef
	| %empty
	;
stmt // Used in: pick_NEWLINE_stmt, plus_stmt
	: simple_stmt
	{ $$ = 0; }
	| compound_stmt
	{ $$ = $1; }
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt SEMI NEWLINE
	| small_stmt star_SEMI_small_stmt NEWLINE
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt SEMI small_stmt
	| %empty
	;
small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: expr_stmt
	| print_stmt
	| del_stmt
	| pass_stmt
	| flow_stmt
	| import_stmt
	| global_stmt
	| exec_stmt
	| assert_stmt
	;
expr_stmt // Used in: small_stmt
	: testlist augassign pick_yield_expr_testlist
	| testlist star_EQUAL
	;
pick_yield_expr_testlist // Used in: expr_stmt, star_EQUAL
	: yield_expr
	| testlist
	;
star_EQUAL // Used in: expr_stmt, star_EQUAL
	: star_EQUAL EQUAL pick_yield_expr_testlist
	| %empty
	;
augassign // Used in: expr_stmt
	: PLUSEQUAL
	| MINEQUAL
	| STAREQUAL
	| SLASHEQUAL
	| PERCENTEQUAL
	| AMPEREQUAL
	| VBAREQUAL
	| CIRCUMFLEXEQUAL
	| LEFTSHIFTEQUAL
	| RIGHTSHIFTEQUAL
	| DOUBLESTAREQUAL
	| DOUBLESLASHEQUAL
	;
print_stmt // Used in: small_stmt
	: PRINT opt_test
	| PRINT RIGHTSHIFT test opt_test_2
	;
star_COMMA_test // Used in: star_COMMA_test, opt_test, listmaker, testlist_comp, testlist, pick_for_test
	: star_COMMA_test COMMA test
	| %empty
	;
opt_test // Used in: print_stmt
	: test star_COMMA_test opt_COMMA
	| %empty
	;
plus_COMMA_test // Used in: plus_COMMA_test, opt_test_2
	: plus_COMMA_test COMMA test
	| COMMA test
	;
opt_test_2 // Used in: print_stmt
	: plus_COMMA_test opt_COMMA
	| %empty
	;
del_stmt // Used in: small_stmt
	: DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: BREAK
	;
continue_stmt // Used in: flow_stmt
	: CONTINUE
	;
return_stmt // Used in: flow_stmt
	: RETURN testlist
	| RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: RAISE test opt_test_3
	| RAISE
	;
opt_COMMA_test // Used in: opt_test_3, exec_stmt
	: COMMA test
	| %empty
	;
opt_test_3 // Used in: raise_stmt
	: COMMA test opt_COMMA_test
	| %empty
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: FROM pick_dotted_name IMPORT pick_STAR_import
	;
pick_dotted_name // Used in: import_from
	: star_DOT dotted_name
	| star_DOT DOT
	;
pick_STAR_import // Used in: import_from
	: STAR
	| LPAR import_as_names RPAR
	| import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: NAME AS NAME
//	{ delete [] $1;
	//	delete [] $3;}
	| NAME
	{ delete [] $1;}
	;
dotted_as_name // Used in: dotted_as_names
	: dotted_name AS NAME
//	{ delete [] $3;}
	| dotted_name
	;
import_as_names // Used in: pick_STAR_import
	: import_as_name star_COMMA_import_as_name COMMA
	| import_as_name star_COMMA_import_as_name
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name COMMA import_as_name
	| %empty
	;
dotted_as_names // Used in: import_name, dotted_as_names
	: dotted_as_name
	| dotted_as_names COMMA dotted_as_name
	;
dotted_name // Used in: decorator, pick_dotted_name, dotted_as_name, dotted_name
	: NAME
	{ delete [] $1;}
	| dotted_name DOT NAME
	{ delete [] $3;}
	;
global_stmt // Used in: small_stmt
	: GLOBAL NAME star_COMMA_NAME
	{ delete [] $2;}
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME COMMA NAME
	{ delete [] $3;}
	| %empty
	;
exec_stmt // Used in: small_stmt
	: EXEC expr IN test opt_COMMA_test
	| EXEC expr
	;
assert_stmt // Used in: small_stmt
	: ASSERT test COMMA test
	| ASSERT test
	;
compound_stmt // Used in: stmt
	:	if_stmt
	{ $$ = $1; }
	| while_stmt
	{ $$ = $1; }
	| for_stmt
	{ $$ = $1; }
	| try_stmt
	{ $$ = $1; }
	| with_stmt
	{ $$ = $1; }
	| funcdef
	{ $$ = $1; }
	| classdef
	{ $$ = $1; }
	| decorated
	{ $$ = 0; }
	;
if_stmt // Used in: compound_stmt
	:	IF test COLON suite star_ELIF ELSE COLON suite
	{
		$$ = $4 + $5 + 1;
	}
	| IF test COLON suite star_ELIF
	{
		$$ = $4 + $5 + 1;
	}
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF ELIF test COLON suite
	{ $$ = $5 + 1;
	}
	| %empty
	{ $$ = 0;
	}
	;
while_stmt // Used in: compound_stmt
	: WHILE test COLON suite ELSE COLON suite
	{ $$ = $4 + 1; }
	| WHILE test COLON suite
	{ $$ = $4 + 1; }
	;
for_stmt // Used in: compound_stmt
	: FOR exprlist IN testlist COLON suite ELSE COLON suite
	{ $$ = $6 + 1; }
	| FOR exprlist IN testlist COLON suite
	{ $$ = $6 + 1; }
	;
try_stmt // Used in: compound_stmt
	: TRY COLON suite plus_except opt_ELSE opt_FINALLY
	{
		if(!finally_exist){
			$$ = $3 + $4 + 1;
		}
		else {
			$$ = 0;
		}
		finally_exist = false;
	}
	| TRY COLON suite FINALLY COLON suite
	{ $$ = 0; }
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause COLON suite
	{ $$ = $4 + 1; }
	| except_clause COLON suite
	{ $$ = $3 + 1; }
	;
opt_ELSE // Used in: try_stmt
	: ELSE COLON suite
	| %empty
	;
opt_FINALLY // Used in: try_stmt
	: FINALLY {finally_exist = true;} COLON suite
	{ $$ = 0; }
	| %empty
	{ $$ = 0; finally_exist = false;}
	;
with_stmt // Used in: compound_stmt
	: WITH with_item star_COMMA_with_item COLON suite
	{ $$ = $5; }
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item COMMA with_item
	| %empty
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test AS expr
	| test
	;
except_clause // Used in: plus_except
	: EXCEPT test opt_AS_COMMA
	| EXCEPT
	;
pick_AS_COMMA // Used in: opt_AS_COMMA
	: AS
	| COMMA
	;
opt_AS_COMMA // Used in: except_clause
	: pick_AS_COMMA test
	| %empty
	;
suite // Used in: funcdef, if_stmt, star_ELIF, while_stmt, for_stmt, try_stmt, plus_except, opt_ELSE, opt_FINALLY, with_stmt, classdef
	: simple_stmt
	{ $$ = 0; }
	| NEWLINE INDENT plus_stmt DEDENT
	{
		$$ = $3;
	}
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	{ $$ = $1 + $2; }
	| stmt
	{ $$ = $1;
	}
	;
testlist_safe // Used in: list_for
	: old_test plus_COMMA_old_test opt_COMMA
	| old_test
	;
plus_COMMA_old_test // Used in: testlist_safe, plus_COMMA_old_test
	: plus_COMMA_old_test COMMA old_test
	| COMMA old_test
	;
old_test // Used in: testlist_safe, plus_COMMA_old_test, old_lambdef, list_if, comp_if
	: or_test
	| old_lambdef
	;
old_lambdef // Used in: old_test
	: LAMBDA varargslist COLON old_test
	| LAMBDA COLON old_test
	;
test // Used in: opt_EQUAL_test, print_stmt, star_COMMA_test, opt_test, plus_COMMA_test, raise_stmt, opt_COMMA_test, opt_test_3, exec_stmt, assert_stmt, if_stmt, star_ELIF, while_stmt, with_item, except_clause, opt_AS_COMMA, opt_IF_ELSE, listmaker, testlist_comp, lambdef, subscript, opt_test_only, sliceop, testlist, dictorsetmaker, star_test_COLON_test, opt_DOUBLESTAR_test, pick_argument, argument, testlist1
	: or_test opt_IF_ELSE
	| lambdef
	;
opt_IF_ELSE // Used in: test
	: IF or_test ELSE test
	| %empty
	;
or_test // Used in: old_test, test, opt_IF_ELSE, or_test, comp_for
	: and_test
	| or_test OR and_test
	;
and_test // Used in: or_test, and_test
	: not_test
	| and_test AND not_test
	;
not_test // Used in: and_test, not_test
	: NOT not_test
	| comparison
	;
comparison // Used in: not_test, comparison
	: expr
	| comparison comp_op expr
	;
comp_op // Used in: comparison
	: LESS
	| GREATER
	| EQEQUAL
	| GREATEREQUAL
	| LESSEQUAL
	| GRLT
	| NOTEQUAL
	| IN
	| NOT IN
	| IS
	| IS NOT
	;
expr // Used in: exec_stmt, with_item, comparison, expr, exprlist, star_COMMA_expr
	: xor_expr
	| expr BAR xor_expr
	;
xor_expr // Used in: expr, xor_expr
	: and_expr
	| xor_expr CIRCUMFLEX and_expr
	;
and_expr // Used in: xor_expr, and_expr
	: shift_expr
	| and_expr AMPERSAND shift_expr
	;
shift_expr // Used in: and_expr, shift_expr
	: arith_expr
	| shift_expr pick_LEFTSHIFT_RIGHTSHIFT arith_expr
	;
pick_LEFTSHIFT_RIGHTSHIFT // Used in: shift_expr
	: LEFTSHIFT
	| RIGHTSHIFT
	;
arith_expr // Used in: shift_expr, arith_expr
	: term
	| arith_expr pick_PLUS_MINUS term
	;
pick_PLUS_MINUS // Used in: arith_expr
	: PLUS
	| MINUS
	;
term // Used in: arith_expr, term
	: factor
	| term pick_multop factor
	;
pick_multop // Used in: term
	: STAR
	| SLASH
	| PERCENT
	| DOUBLESLASH
	;
factor // Used in: term, factor, power
	: pick_unop factor
	| power
	;
pick_unop // Used in: factor
	: PLUS
	| MINUS
	| TILDE
	;
power // Used in: factor
	: atom star_trailer DOUBLESTAR factor
	| atom star_trailer
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer
	| %empty
	;
atom // Used in: power
	: LPAR opt_yield_test RPAR
	| LSQB opt_listmaker RSQB
	| LBRACE opt_dictorsetmaker RBRACE
	| BACKQUOTE testlist1 BACKQUOTE
	| NAME
	{
			delete [] $1;
	}
	| NUMBER
	| plus_STRING
	;
pick_yield_expr_testlist_comp // Used in: opt_yield_test
	: yield_expr
	| testlist_comp
	;
opt_yield_test // Used in: atom
	: pick_yield_expr_testlist_comp
	| %empty
	;
opt_listmaker // Used in: atom
	: listmaker
	| %empty
	;
opt_dictorsetmaker // Used in: atom
	: dictorsetmaker
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING STRING
	| STRING
	;
listmaker // Used in: opt_listmaker
	: test list_for
	| test star_COMMA_test opt_COMMA
	;
testlist_comp // Used in: pick_yield_expr_testlist_comp
	: test comp_for
	| test star_COMMA_test opt_COMMA
	;
lambdef // Used in: test
	: LAMBDA varargslist COLON test
	| LAMBDA COLON test
	;
trailer // Used in: star_trailer
	: LPAR opt_arglist RPAR
	| LSQB subscriptlist RSQB
	| DOT NAME
	{ delete [] $2;}
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript COMMA
	| subscript star_COMMA_subscript
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript COMMA subscript
	| %empty
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: DOT DOT DOT
	| test
	| opt_test_only COLON opt_test_only opt_sliceop
	;
opt_test_only // Used in: subscript
	: test
	| %empty
	;
opt_sliceop // Used in: subscript
	: sliceop
	| %empty
	;
sliceop // Used in: opt_sliceop
	: COLON test
	| COLON
	;
exprlist // Used in: del_stmt, for_stmt, list_for, comp_for
	: expr star_COMMA_expr COMMA
	| expr star_COMMA_expr
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr COMMA expr
	| %empty
	;
testlist // Used in: expr_stmt, pick_yield_expr_testlist, return_stmt, for_stmt, opt_testlist, yield_expr
	: test star_COMMA_test COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: opt_dictorsetmaker
	: test COLON test pick_for_test_test
	| test pick_for_test
	;
star_test_COLON_test // Used in: star_test_COLON_test, pick_for_test_test
	: star_test_COLON_test COMMA test COLON test
	| %empty
	;
pick_for_test_test // Used in: dictorsetmaker
	: comp_for
	| star_test_COLON_test opt_COMMA
	;
pick_for_test // Used in: dictorsetmaker
	: comp_for
	| star_COMMA_test opt_COMMA
	;
classdef // Used in: decorated, compound_stmt
	: CLASS NAME LPAR opt_testlist RPAR COLON
	{
		if(class_scope > 0){
			class_name = class_name + "." + $2;
		}
		else{
			class_name = $2;
		}
		//std::cout << "class_name1" << class_name << std::endl;
		class_scope++;
		delete [] $2;
	}
	suite
	{
		if(class_name.find_last_of('.') == std::string::npos)
			class_name.clear();
		else
			class_name.erase(class_name.find_last_of('.'), class_name.size());
		//std::cout << "class_name2" << class_name << std::endl;
		class_scope--;
	}
	| CLASS NAME COLON
	{
		if(class_scope){
			class_name = class_name + "." + $2;
		}
		else{
			class_name = $2;
		}
		//std::cout << "class_name3" << class_name << std::endl;
		class_scope++;
		delete [] $2;
	}
	suite
	{
		if(class_name.find_last_of('.') == std::string::npos)
			class_name.clear();
		else
			class_name.erase(class_name.find_last_of('.'), class_name.size());
		//std::cout << "class_name4" << class_name << std::endl;
		class_scope--;
	}
	;
opt_testlist // Used in: classdef
	: testlist
	| %empty
	;
arglist // Used in: opt_arglist
	: star_argument_COMMA pick_argument
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA
	: star_argument_COMMA argument COMMA
	| %empty
	;
star_COMMA_argument // Used in: star_COMMA_argument, pick_argument
	: star_COMMA_argument COMMA argument
	| %empty
	;
opt_DOUBLESTAR_test // Used in: pick_argument
	: COMMA DOUBLESTAR test
	| %empty
	;
pick_argument // Used in: arglist
	: argument opt_COMMA
	| STAR test star_COMMA_argument opt_DOUBLESTAR_test
	| DOUBLESTAR test
	;
argument // Used in: star_argument_COMMA, star_COMMA_argument, pick_argument
	: test opt_comp_for
	| test EQUAL test
	;
opt_comp_for // Used in: argument
	: comp_for
	| %empty
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: FOR exprlist IN testlist_safe list_iter
	| FOR exprlist IN testlist_safe
	;
list_if // Used in: list_iter
	: IF old_test list_iter
	| IF old_test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, pick_for_test_test, pick_for_test, opt_comp_for, comp_iter
	: FOR exprlist IN or_test comp_iter
	| FOR exprlist IN or_test
	;
comp_if // Used in: comp_iter
	: IF old_test comp_iter
	| IF old_test
	;
testlist1 // Used in: atom, testlist1
	: test
	| testlist1 COMMA test
	;
yield_expr // Used in: pick_yield_expr_testlist, yield_stmt, pick_yield_expr_testlist_comp
	: YIELD testlist
	| YIELD
	;
star_DOT // Used in: pick_dotted_name, star_DOT
	: star_DOT DOT
	| %empty
	;

%%

#include <stdio.h>
void yyerror (const char *s)
{
    if(yylloc.first_line > 0)	{
        fprintf (stderr, "%d.%d-%d.%d:", yylloc.first_line, yylloc.first_column,
	                                     yylloc.last_line,  yylloc.last_column);
    }
    fprintf(stderr, " %s with [%s]\n", s, yytext);
}

void print_complexity_in_case() {
	while( !inverse_stack.empty() ){
		std::cout << "(\"" << inverse_stack.top().f_begin_loc << ":"
			<< inverse_stack.top().f_begin_col-1 << ": \'"
			<< inverse_stack.top().f_name << "\'\", "
			<< inverse_stack.top().f_complexity
			<< ")" << std::endl;
		inverse_stack.pop();
	}
}
