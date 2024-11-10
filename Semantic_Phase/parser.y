%{
	void yyerror(char* s);
	int yylex();
	
	#include "stdio.h"
	#include "stdlib.h"
	#include "ctype.h"
	#include "string.h"

	void ins();
	void insV();

	int flag=0;
	
	extern char curid[20];
	extern char curtype[20];
	extern char curval[20];
	char return_store[20];
	extern int current_nesting;
	extern int yylineno;
	void createStack();
	void deletedata (int );
	int checkscope(char*);
	int check_id_is_func(char *);
	void insertST(char*, char*);
	void insertSTnest(char*, int);
	void insertSTtype(char*,char*);
	void insertSTparamscount(char*, int);
	int getSTparamscount(char*);
	int check_duplicate(char*);
	int check_declaration(char*, char *);
	int check_params(char*);
	int duplicate(char *s);
	int checkarray(char*);
	char currfunctype[100];
	char currfunc[100];
	char currfunccall[100];
	void insertSTF(char*);
	char gettype(char*,int);
	char getfirst(char*);
	extern int params_count;
	int call_params_count;
	void append_dim(int);
	void scope_push(int);
	void scope_pop();
	int is_iterative=0;
	int scope=0;
	char curfunction[20];
	void insert_dimensions(char* ,int);
	void insert_param_type(char* ,char* );
	int get_param_type(char* ,int );
	int check_compatibility(int a,int b){
		if(a==1){
			if(b == -1 || b==5){
				return -1;
			}
			return 1;
		}
		else if(a == 2){
			if(b!=2){
				return -1;
			}
			return 2;
		}
		else if(a==3){
			if(b == -1 || b==5){
				return -1;
			}
			return 3;
		}
		else if(a==4){
			if(b == -1 || b==5){
				return -1;
			}
			return 4;
		}
		else{
			if(b!=a){
				return -1;
			}
			return a;
		}
	}
	int dim=0;
	int param_flag=0;
	char cur_check[20];
%}

%nonassoc IF
%token INT CHAR FLOAT DOUBLE LONG SHORT SIGNED UNSIGNED 
%token INTs FLOATs CHARs DOUBLEs
%token CONST STRUCT ENUM UNION TYPEDEF
%token RETURN MAIN
%token VOID
%token WHILE FOR DO 
%token BREAK
%token ENDIF
%token SWITCH CASE CONTINUE DEFAULT SPREAD
%token AUTO STATIC REGISTER EXTERN VOLATILE INLINE
%token PRINTF SCANF

%token identifier array_identifier func_identifier
%token integer_constant string_constant float_constant character_constant

%nonassoc ELSE

%right leftshift_assignment_operator rightshift_assignment_operator
%right XOR_assignment_operator OR_assignment_operator
%right AND_assignment_operator modulo_assignment_operator
%right multiplication_assignment_operator division_assignment_operator
%right addition_assignment_operator subtraction_assignment_operator
%right assignment_operator

%left OR_operator
%left AND_operator
%left pipe_operator
%left caret_operator
%left amp_operator
%left equality_operator inequality_operator
%left lessthan_assignment_operator lessthan_operator greaterthan_assignment_operator greaterthan_operator
%left leftshift_operator rightshift_operator 
%left add_operator subtract_operator
%left multiplication_operator division_operator modulo_operator

%right SIZEOF
%right tilde_operator exclamation_operator
%left increment_operator decrement_operator 


%start program

%%
program
			: {scope_push(0);}declaration_list{scope_pop();};

declaration_list
			: declaration D 

D
			: declaration_list
			| ;

declaration
			: variable_declaration 
			| function_declaration
			| structure_definition
            | enum_declaration;

variable_declaration
			: type_specifier variable_declaration_list ';' 
			| storage_classes type_specifier variable_declaration_list ';'
			| storage_classes CONST type_specifier variable_declaration_list ';'
			| CONST type_specifier variable_declaration_list ';'
			| structure_declaration ';';

storage_classes
            : AUTO | STATIC | REGISTER | EXTERN | VOLATILE

variable_declaration_list
			: variable_declaration_list ',' variable_declaration_identifier | variable_declaration_identifier;

variable_declaration_identifier 
			: identifier {if(duplicate(curid)){printf("Duplicate identifier %s at %d\n",curid,yylineno);}
					else{insertST(curid,"Identifier");};
			insertSTnest(curid,current_nesting); ins();  } vdi   
			  | array_identifier {if(duplicate(curid)){printf("Duplicate identifier %s at %d\n",curid,yylineno);}
			  			else{insertST(curid,"Array Identifier");};
			  			insertSTnest(curid,current_nesting); if(strcmp(curtype,"char")==0){
			  									strcpy(curtype,"string");
			  								}
			  			ins(); dim=0; } vdi;
			
			

vdi : identifier_array_type | assignment_operator simple_expression  ; 

identifier_array_type
			: '[' {dim++;}initilization_params
			| ;

initilization_params
			: integer_constant ']' identifier_array_type {insert_dimensions(curid,dim);}initilization {if($$ < 1) {printf("Wrong array size at %d line\n",yylineno);
									} }
			| ']' identifier_array_type {insert_dimensions(curid,dim);insertSTtype(curid,"string");}string_initilization;

initilization
			: string_initilization
			| array_initialization
			| ;

type_specifier 
			: INT | CHAR | FLOAT  | DOUBLE | star_specifier 
			| LONG long_grammar 
			| SHORT short_grammar
			| UNSIGNED unsigned_grammar 
			| SIGNED signed_grammar
			| VOID  ;

star_specifier
			: INTs | CHARs {strcpy(curtype,"string");}| FLOATs | DOUBLEs ;

unsigned_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

signed_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

long_grammar 
			: INT  | ;

short_grammar 
			: INT | ;

structure_definition
			: struct_or_union identifier { if(duplicate(curid)){printf("Duplicate identifier %s at %d\n",curid,yylineno);}
					else{insertST(curid,"Identifier");insertSTtype(curid,"struct");}} '{' V1  '}' ';';
			| TYPEDEF struct_or_union identifier '{' V1 '}' identifier { if(duplicate(curid)){printf("Duplicate identifier %s at %d\n",curid,yylineno);}
					else{insertST(curid,"Identifier");insertSTtype(curid,"struct");}} ';';

V1 : variable_declaration V1 | ;

structure_declaration 
			: struct_or_union identifier variable_declaration_list;

struct_or_union
            : STRUCT
            | UNION ;

function_declaration
			: function_declaration_type function_declaration_param_statement;

function_declaration_type
			: type_specifier identifier {if(duplicate(curid)){printf("Duplicate identifier %s at %d\n",curid,yylineno);}
					else{insertST(curid,"Identifier");}
					strcpy(curfunction,curid);
					} '('  { strcpy(currfunctype, curtype); strcpy(currfunc, curid); 
			check_duplicate(curid); insertSTF(curid); ins(); };

function_declaration_param_statement
			: params ')' {scope_push(++scope);}statement{scope_pop();};

params 
			: parameters_list | ;

parameters_list 
			: type_specifier { check_params(curtype); insert_param_type(curfunction,curtype);} parameters_identifier_list { insertSTparamscount(currfunc, params_count); };

parameters_identifier_list 
			: param_identifier parameters_identifier_list_breakup;

parameters_identifier_list_breakup
			: ',' parameters_list 
			| ;

param_identifier 
			: identifier { ins();insertSTnest(curid,1); params_count++; } param_identifier_breakup;

param_identifier_breakup
			: '[' ']'
			| ;

statement 
			: expression_statment | compound_statement 
			| conditional_statements | iterative_statements {is_iterative++;}
			| return_statement | break_statement | continue_statement
			| variable_declaration 
            | switch_case 
			| printf_scanf_statements;

printf_scanf_statements
			: printf_statement ';'
			| scanf_statement ';' 
			;

printf_statement
			: PRINTF '(' printf_parameters ')' ;

scanf_statement
			:  SCANF '(' scanf_parameters ')' ;

printf_parameters
			: printf_parameters ',' expression
			| string_constant;

scanf_parameters
			: scanf_parameters ',' identifier
			| scanf_parameters ',' amp_operator identifier
			| string_constant;

compound_statement 
			: {current_nesting++;} '{' {scope_push(++scope);} statment_list {if(is_iterative){
											is_iterative--;
											scope_pop();
										}scope_pop();} '}' {current_nesting--;}  ;

statment_list 
			: statement statment_list 
			| ;

expression_statment 
			: expression ';' 
			| ';' ;

conditional_statements 
			: IF '(' simple_expression ')' {if($3!=1){printf("Condition checking is not of type int at %d line\n",yylineno);}} statement conditional_statements_breakup;

conditional_statements_breakup
			: ELSE statement
			| ;

iterative_statements 
			: WHILE '(' {scope_push(++scope);} expression ')' {if($4!=1){printf("Condition checking is not of type int at %d line\n",yylineno);}} statement 
			| FOR '('{scope_push(++scope);} variable_declaration_list ';' simple_expression ';' {if($6!=1){
										printf("Condition checking is not of type int at %d line\n",yylineno);}} expression ')' 
			| FOR '(' {scope_push(++scope);} type_specifier variable_declaration_list ';' simple_expression ';' {if($7!=1){
													printf("Condition checking is not of type int at %d line\n",yylineno);
													}
										         	      } expression ')' 
			| DO {scope_push(scope++);} statement WHILE '(' simple_expression ')'
			{if($6!=1){printf("Condition checking is not of type int at %d line\n",yylineno);}} ';';

return_statement 
			: RETURN ';' {if(strcmp(currfunctype,"void")) {printf("Returning void of a non-void function at %d line\n",yylineno); }}
			| RETURN {strcpy(return_store,"return");}expression {strcpy(return_store," ");}';' { if(!strcmp(currfunctype, "void"))
										{ 
											printf("Function returns something but is declared void at %d line\n",yylineno);
										}

										if(currfunctype[0]=='i'  && $3!=1)
										{
											printf("Expression doesn't match return type of function at %d line\n",yylineno); 
										}
										else if(currfunctype[0]=='c'  && $3!=2){
											printf("Expression doesn't match return type of function at %d line\n",yylineno);
										}
										else if(currfunctype[0]=='f'  && $3!=3){
											printf("Expression doesn't match return type of function at %d line\n",yylineno);
										}
										else if(currfunctype[0]=='d'  && $3!=4){
											printf("Expression doesn't match return type of function at %d line\n",yylineno);
										}
										else if(currfunctype[0]=='s'  && $3!=5){
											printf("Expression doesn't match return type of function at %d line\n",yylineno);
										}
			              
			                     	};

break_statement 
			: BREAK ';' ;

continue_statement 
			: CONTINUE ';' ;

string_initilization
			: assignment_operator string_constant {insV();} ;

array_initialization
			: assignment_operator '{' array_int_declarations '}';

array_int_declarations
			: integer_constant array_int_declarations_breakup;

array_int_declarations_breakup
			: ',' array_int_declarations 
			| ;

expression 
			: mutable assignment_operator expression              {
										int store=check_compatibility($1,$3);
										if(store!=-1) 
										{
			                                                          $$=store;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch %d line\n",yylineno); } 
			                                                       }
			| mutable addition_assignment_operator expression     {
										int store=check_compatibility($1,$3);
										if(store!=-1) 
										{
			                                                          $$=store;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch %d line\n",yylineno); } 
			                                                       }
			| mutable subtraction_assignment_operator expression  {
										int store=check_compatibility($1,$3);
										if(store!=-1) 
										{
			                                                          $$=store;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch %d line\n",yylineno);} 
			                                                       }
			| mutable multiplication_assignment_operator expression {
										int store=check_compatibility($1,$3);
										if(store!=-1) 
										{
			                                                          $$=store;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch %d line\n",yylineno);} 
			                                                       }
			| mutable division_assignment_operator expression {
										int store=check_compatibility($1,$3);
										if(store!=-1) 
										{
			                                                          $$=store;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch %d line\n",yylineno);} 
			                                                       }
			| mutable modulo_assignment_operator expression 	{
										int store=check_compatibility($1,$3);
										if(store!=-1) 
										{
			                                                          $$=store;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch %d line\n",yylineno);} 
			                                                       }
			| mutable increment_operator 							{$$=$1;}
			| mutable decrement_operator 							{$$=$1;}
			| simple_expression {$$=$1;}
			;


simple_expression 
			: simple_expression OR_operator and_expression {if($1 != -1 && $3!=-1) $$=1; else $$=-1;}
			| and_expression { $$=$1;};

and_expression 
			: and_expression AND_operator unary_relation_expression {if($1 != 1 && $3!=-1) $$=1; else $$=-1;}
			  |unary_relation_expression { $$=$1;} ;


unary_relation_expression 
			: exclamation_operator unary_relation_expression {if($2!=-1) $$=$2; else $$=-1;} 
			| regular_expression { $$=$1;} ;

regular_expression 
			: regular_expression relational_operators sum_expression {if($1 != -1 && $3!=-1) $$=1; else {$$=-1;printf("%d   %d\n", $1,$3);}}
			  | sum_expression {$$=$1;} ;
			
relational_operators 
			: greaterthan_assignment_operator | lessthan_assignment_operator | greaterthan_operator 
			| lessthan_operator | equality_operator | inequality_operator ;

sum_expression 
			: sum_expression sum_operators term  {if($1 != -1 && $3!= -1) {$$=1;} else {$$=-1;}}
			| term {  $$=$1;};

sum_operators 
			: add_operator 
			| subtract_operator ;

term
			: term MULOP factor {if($1 != -1 && $3!=-1) $$=1; else $$=-1;}
			| factor {$$=$1;} ;

MULOP 
			: multiplication_operator | division_operator | modulo_operator ;

factor 
			: immutable {$$=$1;} 
			| mutable {$$=$1;} ;

mutable 
			: identifier {
						  if(check_id_is_func(curid))
						  {printf("Function name %s is used as Identifier at %d line\n",curid,yylineno); }
			              //if(!checkscope(curid))
			              //{printf("%s\n",curid);printf("Undeclared\n");exit(0);} 
			              //if(!checkarray(curid))
			              //{printf("%s :",curid);printf("Array ID has no subscript at line %d\n",yylineno);}
			              //printf("%s\n",curid);
			              //printf("%c\n",gettype(curid,0));
			              if(gettype(curid,0)=='i'){
			              	$$ = 1;
			              	//printf("hi\n");
			              }
			              else if(gettype(curid,0)== 'c'){
			              	$$=2;
			              }
			              else if(gettype(curid,0)== 'f'){
			              	$$=3;
			              }
			              else if(gettype(curid,0)== 'd'){
			              	$$=4;
			              }
			              else if(gettype(curid,0)== 's'){
			              	$$=5;
			              }
			              else
			              $$ = -1;
			              }
			| array_identifier {//if(!checkscope(curid)){printf("%s\n",curid);printf("Undeclared\n");exit(0);}
			} '[' expression ']' 
			                   {if(gettype(curid,0)=='i' || gettype(curid,1)== 'c')
			              		$$ = 1;
			              		else
			              		$$ = -1;
			              		}
			| amp_operator identifier;

immutable 
			: '(' expression ')' {if($2!=-1) $$=$1; else $$=-1;}
			| call 
			| constant {if($1!=-1) $$=$1; else $$=-1;};

call
			: identifier {strcpy(cur_check,curid);}'('{
			             if(!check_declaration(curid, "Function"))
			             { printf("Need to declare function %s at %d line\n",curid,yylineno); } 
			             insertSTF(curid); 
						 strcpy(currfunccall,curid);
						 param_flag=0;
			             } arguments ')' 
						 { if(strcmp(currfunccall,"printf"))
							{ 
								if(getSTparamscount(currfunccall)!=call_params_count)
								{	
									printf("function arguments required does not match the passed arguments at %d line\n",yylineno);
									
								}
							} 
						 };

arguments 
			: arguments_list | ;

arguments_list 
			: expression { call_params_count++; if(get_param_type(cur_check,param_flag)!=$1){
									printf("parameter number %d is not matching at %d line\n",++param_flag,yylineno);	
							    }
					
					} A ;

A
			: ',' expression { call_params_count++; if(get_param_type(cur_check,param_flag)!=$1){
									printf("parameter number %d is not matching at %d line\n",++param_flag,yylineno);	
							    }
					
					 } A 
			| ;

constant 
			: integer_constant 	{ if(strcmp(return_store,"return")!=0) insV(); $$=1; } 
			| string_constant	{ if(strcmp(return_store,"return")!=0) insV(); $$=5;} 
			| float_constant	{ if(strcmp(return_store,"return")!=0) insV(); $$=3;} 
			| character_constant	{ if(strcmp(return_store,"return")!=0) insV();$$=2; };

enum_declaration
            : ENUM identifier '{' enum_list '}' ';'
            ;

enum_list
            : enumerator
            | enum_list ',' enumerator ;

enumerator
            : identifier
            | identifier assignment_operator integer_constant
            ;

switch_case
            : SWITCH  '(' identifier ')' '{' case_list '}' ;

case_list
            : case_entry  ';'
            | case_list case_entry  ';'
            ;

case_entry  
            : CASE constant ':' statement
            | CASE constant SPREAD constant':' statement
            | DEFAULT ':' statement
            |
            ;

%%

extern FILE *yyin;
extern int yylineno;
extern char *yytext;
void insertSTtype(char *,char *);
void insertSTvalue(char *, char *);
void incertCT(char *, char *);
void printST();
void printCT();

int main()
{	createStack();
	yyin = fopen("text.c", "r");
	yyparse();

	if(flag == 0)
	{
		//printf( "PASSED: Semantic Phase\n");
		printf("\n\n");
		printf("%54s %s\n", " ", "-----------------------");
		printf("%56s"  "PRINTING SYMBOL TABLE\n", " ");
		printf("%54s %s\n", " ", "-----------------------");
		printST();
		printf("\n\n");
		printf("%54s %s\n", " ", "-----------------------");
		printf("%55s"  "PRINTING CONSTANT TABLE\n" , " ");
		printf("%54s %s\n", " ", "-----------------------");
		printf("\n\n");
		printCT();
	}
}

void yyerror(char *s)
{
	printf( "%d %s %s\n", yylineno, s, yytext);
	flag=1;
	printf( "FAILED: Semantic Phase Parsing failed at %d line\n",yylineno );
	exit(7);
}

void ins()
{
	insertSTtype(curid,curtype);
}

void insV()
{
	insertSTvalue(curid,curval);
}

int yywrap()
{
	return 1;
}
