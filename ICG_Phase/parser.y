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
	int isreturn=0;
	int return_id=0;
	int func_count=0;
	int main_flag=0;
	char switch_exp[10];
	int case_val=0;
	
	extern char curid[20];
	extern char curtype[20];
	extern char curval[20];
	extern char curparameters[100];
	char curarrayval[20];
	char curreturnval[5];
	char return_store[20];
	extern int current_nesting;
	extern int yylineno;
	extern char *yytext;
	void createStack();
	void deletedata (int );
	int checkscope(char*);
	int check_id_is_func(char *);
	void insertST(char*, char*);
	void insertSTnest(char*, int);
	void insertSTtype(char*,char*);
	void insertSTparamscount(char*, int);
	void insertSTparameters(char *, char *);
	void getSTparameters(char *);
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
	int get_class(char *);
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
	extern FILE *yyin;
	extern int yylineno;
	extern char *yytext;
	void insertSTtype(char *,char *);
	void insertSTvalue(char *, char *);
	void incertCT(char *, char *);
	void printST();
	void printCT();

	struct stack
	{
		char value[100];
		int labelvalue;
	}s[100],label[100], loopstack[10];

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
	int index_TAC=0;
	int TAC_counter=0;
	
	
	struct threeAddressCode{
		char op;
		char left_operand[10];
		char right_operand[10];
		char res[10];
	}TAC[100];
	
	void insertTAC(char op, char *arg1, char *arg2){
		TAC[index_TAC].op = op;
    		strcpy(TAC[index_TAC].left_operand, arg1);
    		strcpy(TAC[index_TAC].right_operand, arg2);
    		sprintf(TAC[index_TAC].res, "E%d", index_TAC);
    		index_TAC++;
	}
	
	void printCode() {
    		for (int i = 0; i < index_TAC; i++) {
     		   	printf("%s = %s %c %s\n", TAC[i].res, TAC[i].left_operand, TAC[i].op, TAC[i].right_operand);
    		}	
	}
	
	void push(char *s);
	void codegen();
	void codeassign();
	char* itoa(int num, char* str, int base);
	void reverse(char str[], int length);
	void swap(char*,char*);
	void label1();
	void label2();
	void label3();
	void label4();
	void label5();
	void label6();
	void genunary();
	void codegencon();
	void start_function();
	void end_function();
	void arggen();
	void print_params();
	void callgen();
	void start_loop();
	void end_loop();
	void pushloop();
	void poploop();
	void add_case_label();
	void add_default_label();
	void start_case();
	void start_default();
	void end_case();
	void end_default();
	void return_goto_func();
	
	int array_flag_string = 0;
	int array_flag=0;
	int array_tac_flag = 0;
	int top = 0,count=0,ltop=0,lno=0, looptop=0;
	char temp[3] = "t";
	char current_type[100];
	char top_store[100];
	void print_label(int);
	void print_goto(int);
	void label_if();
	void label_for();
	void label2_for();
	void pop_if();
	void pop_for();
	void label2_if();
	void label_while();
	void pop_while();
	int type_get(char c){
		if(c=='i'){
			return 1;
		}
		else if (c=='c'){
			return 2;
		}
		else if(c=='f'){
			return 3;
		}
		else if(c=='d'){
			return 4;
		}
		else if(c=='s'){
			return 5;
		}
		else{
			return -1;
		}
	}
	char temp1[100];
%}


%union { 
	struct var_name { 
		int value;
		char icg[100];
	} nd_obj; 
} 


%nonassoc <nd_obj> IF
%token <nd_obj> INT CHAR FLOAT DOUBLE LONG SHORT SIGNED UNSIGNED 
%token <nd_obj> INTs FLOATs CHARs DOUBLEs
%token <nd_obj> CONST STRUCT ENUM UNION TYPEDEF
%token <nd_obj> RETURN MAIN
%token <nd_obj> VOID
%token <nd_obj> WHILE FOR DO 
%token <nd_obj> BREAK
%token <nd_obj> ENDIF
%token <nd_obj> SWITCH CASE CONTINUE DEFAULT SPREAD
%token <nd_obj> AUTO STATIC REGISTER EXTERN VOLATILE INLINE
%token <nd_obj> PRINTF SCANF 

%token <nd_obj> SEMI_COLON COLON OPEN_CURLY CLOSE_CURLY OPEN_SQR CLOSE_SQR OPEN_BRACE CLOSE_BRACE DOT COMMA 

%token <nd_obj> IDENTIFIER ARRAY_IDENTIFIER FUNC_IDENTIFIER
%token <nd_obj> INTEGER_CONSTANT STRING_CONSTANT FLOAT_CONSTANT CHARACTER_CONSTANT

%nonassoc <nd_obj> ELSE

%right <nd_obj> LEFTSHIFT_ASSIGNMENT_OPERATOR RIGHTSHIFT_ASSIGNMENT_OPERATOR 
%right <nd_obj> XOR_ASSIGNMENT_OPERATOR OR_ASSIGNMENT_OPERATOR 
%right <nd_obj> AND_ASSIGNMENT_OPERATOR MODULO_ASSIGNMENT_OPERATOR
%right <nd_obj> MULTIPLICATION_ASSIGNMENT_OPERATOR DIVISION_ASSIGNMENT_OPERATOR
%right <nd_obj> ADDITION_ASSIGNMENT_OPERATOR SUBTRACTION_ASSIGNMENT_OPERATOR

%right <nd_obj> ASSIGNMENT_OPERATOR
%left <nd_obj> OR_OPERATOR
%left <nd_obj> AND_OPERATOR
%left <nd_obj> PIPE_OPERATOR
%left <nd_obj> CARET_OPERATOR
%left <nd_obj> AMP_OPERATOR

%left <nd_obj> EQUALITY_OPERATOR INEQUALITY_OPERATOR
%left <nd_obj> LESSTHAN_ASSIGNMENT_OPERATOR LESSTHAN_OPERATOR GREATERTHAN_ASSIGNMENT_OPERATOR GREATERTHAN_OPERATOR
%left <nd_obj> LEFTSHIFT_OPERATOR RIGHTSHIFT_OPERATOR 
%left <nd_obj> ADD_OPERATOR SUBTRACT_OPERATOR
%left <nd_obj> MULTIPLICATION_OPERATOR DIVISION_OPERATOR MODULO_OPERATOR

%right <nd_obj> SIZEOF
%right <nd_obj> TILDE_OPERATOR EXCLAMATION_OPERATOR
%left <nd_obj> INCREMENT_OPERATOR DECREMENT_OPERATOR 

%type <nd_obj> program declaration_list D declaration variable_declaration storage_classes variable_declaration_list variable_declaration_identifier vdi identifier_array_type initilization_params
%type <nd_obj> initilization type_specifier star_specifier unsigned_grammar signed_grammar long_grammar short_grammar structure_definition V1 structure_declaration struct_or_union function_declaration
%type <nd_obj> function_declaration_type function_declaration_param_statement params parameters_list parameters_identifier_list parameters_identifier_list_breakup param_identifier param_identifier_breakup
%type <nd_obj> statement printf_scanf_statements printf_statement scanf_statement printf_parameters scanf_parameters compound_statement statment_list expression_statment conditional_statements 
%type <nd_obj> conditional_statements_breakup iterative_statements return_statement break_statement continue_statement string_initilization array_initialization array_int_declarations 
%type <nd_obj> array_int_declarations_breakup expression simple_expression and_expression unary_relation_expression regular_expression relational_operators sum_expression sum_operators term MULOP factor 
%type <nd_obj> mutable immutable call arguments arguments_list A constant enum_declaration enum_list enumerator switch_case case_list case_entry sign for_type_specifier

%%
program
			: {printf("\nThree Address Code:\n\n");scope_push(0);}declaration_list{scope_pop();}
			;

declaration_list
			: declaration D
			;

D
			: declaration_list
			| {}
			;

declaration
			: variable_declaration 
			| function_declaration 
			| structure_definition
            		| enum_declaration
            		;

variable_declaration
			: type_specifier variable_declaration_list SEMI_COLON
			| storage_classes type_specifier variable_declaration_list SEMI_COLON
			| storage_classes CONST type_specifier variable_declaration_list SEMI_COLON
			| CONST type_specifier variable_declaration_list SEMI_COLON
			| structure_declaration SEMI_COLON
			;

storage_classes
   			: AUTO
   			| STATIC
   			| REGISTER
   			| EXTERN 
   			| VOLATILE
   			;

variable_declaration_list
			: variable_declaration_list COMMA variable_declaration_identifier
			| variable_declaration_identifier
			;
			
variable_declaration_identifier 
			: IDENTIFIER {
					push(curid);
					if(duplicate(curid)){printf("\nError: Duplicate identifier %s at %d\n\n",curid,yylineno);}
					else{insertST(curid,"Identifier");};
			insertSTnest(curid,current_nesting); ins(); strcpy(temp1,curid); } vdi   
			  | ARRAY_IDENTIFIER {if(duplicate(curid)){printf("\nError: Duplicate identifier %s at %d\n\n",curid,yylineno);}
			  			else{insertST(curid,"Array Identifier");};
			  			insertSTnest(curid,current_nesting); if(strcmp(curtype,"char")==0){
			  									strcpy(curtype,"string");
			  								}
			  			ins(); dim=0; } vdi;
			

vdi : identifier_array_type
    | ASSIGNMENT_OPERATOR {push("=");} simple_expression { if(type_get(gettype(temp1,0))!=$3.value)
    {printf("Error : Incompatible value assigned for %s at Line: %d\n",temp1,yylineno);} codeassign();}
    ; 

identifier_array_type
			: OPEN_SQR {dim++;} initilization_params
			| {}
			;
				
			
initilization_params
			: INTEGER_CONSTANT {if(atoi(curval)<1){yyerror("Array dimension less than 1");}append_dim($1.value);} CLOSE_SQR identifier_array_type {insert_dimensions(curid,dim);} initilization
			| CLOSE_SQR identifier_array_type {insert_dimensions(curid,dim);insertSTtype(curid,"string");} string_initilization
			;	
		

initilization
			: string_initilization
			| array_initialization
			| {}
			;

type_specifier 
			: INT {strcpy(current_type,"int");}
			| CHAR {strcpy(current_type,"char");}
			| FLOAT {strcpy(current_type,"float");}
			| DOUBLE {strcpy(current_type,"double");}
			| star_specifier 
			| LONG long_grammar 
			| SHORT short_grammar
			| UNSIGNED unsigned_grammar
			| SIGNED signed_grammar
			| VOID  
			;

			
star_specifier
			: INTs 
			| CHARs {strcpy(curtype,"string");}
			| FLOATs 
			| DOUBLEs 
			;

unsigned_grammar 
			: INT 
			| LONG long_grammar
			| SHORT short_grammar 
			| {}
			;

signed_grammar 
			: INT
			| LONG long_grammar 
			| SHORT short_grammar 
			| {}
			;

long_grammar 
			: INT
			| {}
			;

short_grammar 
			: INT
			| {}
			;
			
					
structure_definition
			: struct_or_union IDENTIFIER { if(duplicate(curid)){printf("\nError: Duplicate identifier %s at %d\n\n",curid,yylineno);}
					else{insertST(curid,"Identifier");insertSTtype(curid,"struct");}} OPEN_CURLY V1 CLOSE_CURLY SEMI_COLON
			| TYPEDEF struct_or_union IDENTIFIER OPEN_CURLY V1 CLOSE_CURLY IDENTIFIER { if(duplicate(curid)){printf("\nError: Duplicate identifier %s at %d\n\n",curid,yylineno);}
					else{insertST(curid,"Identifier");insertSTtype(curid,"struct");}} SEMI_COLON
			;

V1 : variable_declaration V1
   | {}
   ;

structure_declaration 
			: struct_or_union IDENTIFIER variable_declaration_list
			;

struct_or_union
            : STRUCT
            | UNION
            ;

function_declaration
			: function_declaration_type function_declaration_param_statement
			;
			
function_declaration_type
			: type_specifier IDENTIFIER {
					func_count++;
					//printf("%s - paramter\n",curid);
					if(strcmp(curid, "main")==0) main_flag=1; 
					else if(duplicate(curid)){printf("\nError: Duplicate identifier %s at %d\n\n",curid,yylineno);}
					else{
						//printf("%s - paramter\n",curid);
						insertST(curid,"Identifier");
						insertSTtype(curid,current_type);
					}
					strcpy(curfunction,curid);
					start_function();
					} OPEN_BRACE  { strcpy(currfunctype, curtype);  strcpy(currfunc, curid); check_duplicate(curid); insertSTF(curid); ins();
					isreturn=0;
			}
			;
			
function_declaration_param_statement
			: params CLOSE_BRACE {print_params();scope_push(++scope);} statement {scope_pop();}
			//{
			//	if(strcmp(currfunctype,"void")){ 
			//		if(isreturn==0){
			//			yyerror("Function of non void type does not return");
			//		}
			//	}
			//}
			;
			
params 
			: parameters_list 
			| {}
			;
			
parameters_list 
			: type_specifier { check_params(curtype); insert_param_type(curfunction,curtype);} parameters_identifier_list {insertSTparamscount(currfunc, params_count); }
			;
			
parameters_identifier_list 
			: param_identifier parameters_identifier_list_breakup
			;

parameters_identifier_list_breakup
			: COMMA parameters_list 
			| {}
			;
			
param_identifier 
			: IDENTIFIER {  insertSTparameters(curfunction, yytext);insertST(curid,"Identifier");
						insertSTtype(curid,current_type);  
						ins();insertSTnest(curid,1); params_count++;
						} 
			param_identifier_breakup
			;

param_identifier_breakup
			: OPEN_SQR CLOSE_SQR
			| {}
			;
			
			
statement 
			: expression_statment 
			| compound_statement
			| conditional_statements
			| iterative_statements {is_iterative++;}
			| return_statement
			| break_statement
			| continue_statement
			| variable_declaration 
            		| switch_case
			| printf_scanf_statements
			;

printf_scanf_statements
			: printf_statement SEMI_COLON
			| scanf_statement SEMI_COLON
			;


printf_statement
			: PRINTF {strcpy(currfunccall, "printf");pushloop("printf");start_loop();} OPEN_BRACE printf_parameters CLOSE_BRACE {strcpy(curfunction, "printf");print_params(); callgen();end_loop();}
			;

scanf_statement
			:  SCANF OPEN_BRACE scanf_parameters CLOSE_BRACE
			;

printf_parameters
			: printf_parameters COMMA expression 
			{
				if(get_class(curid)==1){
					insertSTparameters("printf", curid);
				}
			}
			| STRING_CONSTANT
			{
				insertSTparameters("printf", curval);
			}
			;
			
scanf_parameters
			: scanf_parameters COMMA IDENTIFIER
			| scanf_parameters COMMA AMP_OPERATOR IDENTIFIER
			| STRING_CONSTANT
			;


compound_statement 
			: {current_nesting++;} OPEN_CURLY {scope_push(++scope);} statment_list {if(is_iterative){
											is_iterative--;
											scope_pop();
										}scope_pop();} CLOSE_CURLY {current_nesting--;} 
			;

statment_list 
			: statement statment_list 
			| {}
			;

expression_statment 
			: expression SEMI_COLON
			| SEMI_COLON
			;
			
conditional_statements 
			: IF {pushloop("if"); start_loop();label_if();} OPEN_BRACE simple_expression CLOSE_BRACE {label2_if();if($4.value!=1){printf("\nError: Condition checking is not of type int at %d line\n\n",yylineno);}} compound_statement {print_goto(0); end_loop();} conditional_statements_breakup
			;

conditional_statements_breakup
			: ELSE {pushloop("else"); start_loop();printf("\n");print_label(1);} compound_statement  {end_loop(); pop_if();}
			|  {print_label(1);printf("\n"); pop_if();}
			;

iterative_statements 
			: WHILE {pushloop("while");start_loop();label_if();print_label(1);} OPEN_BRACE { scope_push(++scope);} 
			expression CLOSE_BRACE {label_while();} compound_statement
			{ if($5.value!=1){printf("Condition checking is not of type int at %d line\n",yylineno);}
			print_goto(1);printf("\n");pop_while();end_loop();} 			
			| FOR {pushloop("for");start_loop();printf("\n");} OPEN_BRACE {scope_push(++scope);label_for();} 
			for_type_specifier variable_declaration_list {print_label(3);} SEMI_COLON simple_expression SEMI_COLON
			{label2_for();printf("\n");print_label(2);if($9.value!=1){
								printf("\nError: Condition checking is not of type int at %d line\n\n",yylineno);}} 
								expression {print_goto(3);printf("\n");print_label(1);}
								CLOSE_BRACE compound_statement {print_goto(2); end_loop(); printf("\n"); pop_for();}
			|  DO {pushloop("do");start_loop();label4();scope_push(scope++);} compound_statement WHILE OPEN_BRACE expression CLOSE_BRACE {label1(); label5(); end_loop(); if($6.value!=1){printf("Condition checking is not of type int at %d line\n",yylineno);}} SEMI_COLON
			;
			
for_type_specifier : type_specifier
		   | {}
		   ;                     	
return_statement 
			: RETURN {isreturn=1;} SEMI_COLON { if(strcmp(currfunctype,"void")) {printf("\nError: Returning void of a non-void function at %d line\n\n",yylineno);}}
			| RETURN {  strcpy(return_store,"return");} expression {strcpy(return_store," ");} SEMI_COLON { 
										isreturn=1; codegencon(); return_goto_func(); isreturn=0;
										if(!strcmp(currfunctype, "void"))
										{ 
											printf("\nError: Function returns something but is declared void at %d line\n\n",yylineno);
										}

										if(currfunctype[0]=='i'  && $3.value!=1)
										{
											printf("%d\n", $3.value);
											printf("\nError: Expression doesn't match return type of function at %d line\n\n",yylineno); 
										}
										else if(currfunctype[0]=='c'  && $3.value!=2){
											printf("\nError: Expression doesn't match return type of function at %d line\n\n",yylineno);
										}
										else if(currfunctype[0]=='f'  && $3.value!=3){
											printf("\nError: Expression doesn't match return type of function at %d line\n\n",yylineno);
										}
										else if(currfunctype[0]=='d'  && $3.value!=4){
											printf("\nError: Expression doesn't match return type of function at %d line\n\n",yylineno);
										}
										else if(currfunctype[0]=='s'  && $3.value!=5){
											printf("\nError: Expression doesn't match return type of function at %d line\n\n",yylineno);
										}
			}
			;

break_statement 
			: BREAK {label2();} SEMI_COLON 
			;

continue_statement 
			: CONTINUE {label2();} SEMI_COLON
			;
			
string_initilization
			: ASSIGNMENT_OPERATOR STRING_CONSTANT {array_flag_string=1;codegencon();insV();} 
			;

array_initialization
			: ASSIGNMENT_OPERATOR OPEN_CURLY array_int_declarations {array_flag=1;codegencon();} CLOSE_CURLY
			;

array_int_declarations
			: INTEGER_CONSTANT {strcat(curarrayval, yytext);} array_int_declarations_breakup
			;

array_int_declarations_breakup
			: COMMA array_int_declarations
			| {}
			;
			

			
expression 
			: mutable ASSIGNMENT_OPERATOR {push("=");} expression              {
										  int store=check_compatibility($1.value,$4.value);
										if(store!=-1) 
										{
			                                                          $$.value=store;
			                                                          } 
			                                                          else 
			                                                          {$$.value=-1; printf("\nError: Type mismatch %d line\n\n",yylineno); }
			                               
			       	codeassign();
			}
			| mutable ADDITION_ASSIGNMENT_OPERATOR expression     { 
			                                                   int store=check_compatibility($1.value,$3.value);
										if(store!=-1) 
										{
			                                                          $$.value=store;
			                                                          } 
			                                                          else 
			                                                          {$$.value=-1; printf("\nError: Type mismatch %d line\n\n",yylineno); }
			        codeassign();
			}
			| mutable SUBTRACTION_ASSIGNMENT_OPERATOR expression  { 
			                                                          int store=check_compatibility($1.value,$3.value);
										if(store!=-1) 
										{
			                                                          $$.value=store;
			                                                          } 
			                                                          else 
			                                                          {$$.value=-1; printf("\nError: Type mismatch %d line\n\n",yylineno);} 
			}
			| mutable MULTIPLICATION_ASSIGNMENT_OPERATOR expression {
										int store=check_compatibility($1.value,$3.value);
										if(store!=-1) 
										{
			                                                          $$.value=store;
			                                                          } 
			                                                          else 
			                                                          {$$.value=-1;printf("\nError: Type mismatch %d line\n\n",yylineno);} 
				codeassign();
			}
			| mutable DIVISION_ASSIGNMENT_OPERATOR expression {
										int store=check_compatibility($1.value,$3.value);
										if(store!=-1) 
										{
			                                                          $$.value=store;
			                                                          } 
			                                                          else 
			                                                          {$$.value=-1;printf("\nError: Type mismatch %d line\n\n",yylineno);}
				codeassign();
			}
			| mutable MODULO_ASSIGNMENT_OPERATOR expression {
									int store=check_compatibility($1.value,$3.value);
										if(store!=-1) 
										{
			                                                          $$.value=store;
			                                                          } 
			                                                          else 
			                                                          {$$.value=-1;printf("\nError: Type mismatch %d line\n\n",yylineno);} 
				codeassign();
			}
			| mutable INCREMENT_OPERATOR  
			{
				push("++");
				$$.value=$1.value;
				genunary();
			}
			| mutable DECREMENT_OPERATOR
			{
				push("--");
				$$.value=$1.value;
				genunary();
			}
			| simple_expression {$$.value=$1.value; }
			;


simple_expression 
			: simple_expression OR_OPERATOR and_expression 
			{
				if($1.value != -1 && $3.value!=-1) $$.value=1; else $$.value=-1;
				codegen();
			}
			| and_expression 
			{
				$$.value=$1.value;
			}
			;

and_expression 
			: and_expression AND_OPERATOR unary_relation_expression
			{
				if($1.value != -1 && $3.value!=-1) $$.value=1; else $$.value=-1;
				 codegen();
			}
			| unary_relation_expression 
			{
				$$.value=$1.value;
			} 
			;
			
unary_relation_expression 
			: EXCLAMATION_OPERATOR unary_relation_expression 
			{
				if($2.value!=-1) $$.value=$2.value; else $$.value=-1;
				 codegen();
			} 
			| regular_expression 
			{
				$$.value=$1.value;
			} 
			;
			  
regular_expression 
			: regular_expression relational_operators sum_expression 
			{
				 //printf("$1.value: %d   $3.value: %d\n", $1.value,$3.value);
				if($1.value != -1 && $3.value!=-1) $$.value=1; else {$$.value=-1;}
				 codegen();
			}
			| sum_expression 
			{
				$$.value=$1.value;
			} 
			;
			
relational_operators 
			: GREATERTHAN_ASSIGNMENT_OPERATOR 
			{
				push(">=");
			}
			| LESSTHAN_ASSIGNMENT_OPERATOR 
			{
				push("<=");
			}
			| GREATERTHAN_OPERATOR
			{
				push(">");
			}
			| LESSTHAN_OPERATOR
			{
				push("<");
			}
			| EQUALITY_OPERATOR
			{
				push("==");
			}
			| INEQUALITY_OPERATOR
			{
				push("!=");
			}
			;


sum_expression 
			: sum_expression sum_operators term 
			{
				if($1.value != -1 && $3.value!=-1) $$.value=1; else $$.value=-1;
				 codegen();
			}
			| term 
			{
				$$.value=$1.value;
			}
			;

sum_operators 
			: ADD_OPERATOR
			{
				push("+");
			} 
			| SUBTRACT_OPERATOR 
			{
				push("-");
			}
			;

term
			: term MULOP factor 
			{
				if($1.value != -1 && $3.value!=-1) $$.value=1; else $$.value=-1;
				codegen();
			}
			| factor 
			{	
				$$.value=$1.value;
			} 
			;

MULOP 
			: MULTIPLICATION_OPERATOR
			{
				push("*");
			} 
			| DIVISION_OPERATOR
			{
				push("/");
			} 
			| MODULO_OPERATOR 
			{
				push("%");
			}
			;

factor 
			: immutable 
			{
				$$.value=$1.value;
			} 
			| mutable 
			{
				$$.value=$1.value;
			} 
			;

mutable 
			: IDENTIFIER {
					push(curid);
					
						  if(check_id_is_func(curid))
						  {printf("\nError: Function name %s is used as Identifier at %d line\n\n",curid,yylineno); }
					//printf("%c - gettype \n",gettype(curid,0));
			              if(gettype(curid,0)=='i'){
			              	//printf("type of curid: %c - %s\n", gettype(curid,0),curid);
			              	$$.value = 1;
			              }
			              else if(gettype(curid,0)== 'c'){
			              	$$.value=2;
			              }
			              else if(gettype(curid,0)== 'f'){
			              	$$.value=3;
			              }
			              else if(gettype(curid,0)== 'd'){
			              	$$.value=4;
			              }
			              else if(gettype(curid,0)== 's'){
			              	$$.value=5;
			              }
			              else
			              $$.value = -1;
			}
			| ARRAY_IDENTIFIER OPEN_SQR INTEGER_CONSTANT CLOSE_SQR 
			                   {
			                   	printf("t%d = 4 * %s\n",count++ ,curval);
						printf("t%d = %s + t%d\n",count, curid ,count-1);
						count++;
						printf("t%d = *t%d\n\n",count++, count-1);
						
						sprintf(top_store,"t%d",count-1);
						push(top_store);
			                   	if(gettype(curid,0)=='i' || gettype(curid,1)== 'c')
			              		$$.value = 1;
			              		else
			              		$$.value = -1;
			}
			| AMP_OPERATOR IDENTIFIER
			{
				// ICG generation for AMP_OPERATOR IDENTIFIER
			}
			;


immutable 
			: OPEN_BRACE expression CLOSE_BRACE 
			{	
				if($2.value != -1) $$.value = $1.value; 
				else $$.value = -1;
			}
			| call               
			{
			}
			| constant 
			{	
				if($1.value != -1) $$.value = $1.value; 
				else $$.value = -1;
			}
			;

call: IDENTIFIER {strcpy(cur_check, curid);} OPEN_BRACE {
			             if(!check_declaration(curid, "Function"))
			             { printf("\nError: Need to declare function %s at %d line\n\n", curid, yylineno); } 
			             insertSTF(curid); 
						 strcpy(currfunccall, curid);
						 param_flag = 0;
			             } arguments CLOSE_BRACE 
			{ 
				$$.value = type_get(gettype(currfunccall,0));
				if(strcmp(currfunccall, "printf")) {
					if(getSTparamscount(currfunccall) != call_params_count) {	
						printf("\nError: Function arguments required do not match the passed arguments at %d line\n\n", yylineno);
					}
				} 
				callgen();
			}
   ;

arguments 
			: arguments_list 
			| {}
			;
					
arguments_list 
			: expression { 
				call_params_count++;	
				
				if(get_param_type(cur_check, param_flag) != $1.value) {
					//printf("error : %d not matching  %d\n",get_param_type(cur_check, param_flag),$1.value);
					printf("\nError: Parameter number %d is not matching at %d line\n\n", ++param_flag, yylineno);	
				} else {
					param_flag++;
				}
			} A
			;
			
A
			: COMMA expression { 
				call_params_count++; 
				if(get_param_type(cur_check, param_flag) != $2.value) {
					//printf("error : %d not matching  %d\n",get_param_type(cur_check, param_flag),$2.value);
					printf("\nError: Parameter number %d is not matching at %d line\n\n", ++param_flag, yylineno);	
				} else {
					param_flag++;
				}
			} A 
			| {}
			;


constant 
			: sign INTEGER_CONSTANT 	
			{  
				if(strcmp(return_store, "return") != 0) insV(); 
				$$.value = 1;
				strcpy(curreturnval, curval);
				codegencon();
			} 
			| STRING_CONSTANT	
			{  
				if(strcmp(return_store, "return") != 0) insV(); 
				$$.value = 5;
				 codegencon();
			} 
			| sign FLOAT_CONSTANT	
			{  
				if(strcmp(return_store, "return") != 0) insV(); 
				$$.value = 3;
				 codegencon();
			} 
			| CHARACTER_CONSTANT
			{  
				if(strcmp(return_store, "return") != 0) insV();
				$$.value = 2;
				 codegencon();
			}
			;
			
sign : ADD_OPERATOR
     {
     	push("+");
     }
     | SUBTRACT_OPERATOR
     {
     	push("-");
     }
     |
     {
     }
     ;

enum_declaration
            : ENUM IDENTIFIER OPEN_CURLY enum_list CLOSE_CURLY SEMI_COLON
            {
            }
            ;

enum_list
            : enumerator
            {
            }
            | enum_list COMMA enumerator 
            {
            }
            ;

enumerator
            : IDENTIFIER
            {
            }
            | IDENTIFIER ASSIGNMENT_OPERATOR INTEGER_CONSTANT
            {
            }
            ;

switch_case
            : SWITCH {pushloop("switch"); start_loop();} OPEN_BRACE IDENTIFIER {strcpy(switch_exp, curid); push(curid);} CLOSE_BRACE OPEN_CURLY case_list CLOSE_CURLY {end_loop();}
            {
            } 
            ;

case_list
            : case_list case_entry 
            {
            }
            | {}
            ;
                       

case_entry  
            : CASE constant {case_val=atoi(curval);add_case_label(case_val);  start_case(case_val); } COLON statment_list {end_case(case_val);}
            {
            }
            | DEFAULT {add_default_label(); start_default();} COLON statment_list {end_default();}
            {
            }
            ;


%%



void push(char *x)
{
	strcpy(s[++top].value,x);
}

void pushloop(char *x){
	strcpy(loopstack[++looptop].value, x);
}

void pop(){
	top--;
}

void poploop(){
	looptop--;
}

void codegen()
{
	printf("t%d = %s %s %s\n",count,s[top-2].value,s[top-1].value,s[top].value);
	top = top - 2;
    sprintf(temp, "t%d", count);
	strcpy(s[top].value,temp);
	count++;
}

void codegencon()
{
	if(array_flag_string == 1){
		int size=strlen(curval)-1;
		//printf("size: %d\n", size);
		for(int i=1;i<size;i++){
			printf("t%d = 4 * %d\n",count++ ,i-1);
			printf("t%d = %s + t%d\n",count, curid ,count-1);
			count++;
			printf("*t%d = %c\n\n",count++, curval[i]);
		}
		//array_tac_flag = 1;
	}
	else if(array_flag==1){
		int n=strlen(curarrayval);
		for(int i=0;i<n;i++){
			printf("t%d = 4 * %d\n",count++ ,i);
			printf("t%d = %s + t%d\n",count, curid ,count-1);
			count++;
			printf("*t%d = %c\n\n",count++, curarrayval[i]);
		}
	}
	else if(isreturn==1){
		//printf("t%d = %s\n", count, curreturnval);
		printf("return %s\n",s[top].value);
	}
	else{
		printf("t%d = %s\n", count, curval);
	}
	sprintf(temp, "t%d", count);
	push(temp);
	count++;
	array_flag_string = 0;
	array_flag=0;
}

void codeassign()
{
	if(array_tac_flag == 1)
		printf("*%s = %s\n",s[top-2].value,s[top].value);
	else
		printf("%s = %s\n",s[top-2].value,s[top].value);
	array_tac_flag = 0;
	//if(top-3 >= 0 )
	//printf("%s - s top\n",s[top-3].value);
	top = top - 2;
}

int isunary(char *s)
{
	if(strcmp(s, "--")==0 || strcmp(s, "++")==0)
	{
		return 1;
	}
	return 0;
}

void genunary()
{
	char temp1[100], temp2[100], temp3[100];
	strcpy(temp1, s[top].value);
	strcpy(temp2, s[top-1].value);

	if(isunary(temp1))
	{
		strcpy(temp3, temp1);
		strcpy(temp1, temp2);
		strcpy(temp2, temp3);
	}

	if(strcmp(temp2,"--")==0)
	{
		printf("t%d = %s - 1\n", count, temp1);
		printf("%s = t%d\n", temp1, count);
	}

	if(strcmp(temp2,"++")==0)
	{
		printf("t%d = %s + 1\n", count, temp1);
		printf("%s = t%d\n", temp1, count);
	}
	count++;
	top = top -2;
}

void print_label(int place){
	printf("L%d : \n",label[ltop-place].labelvalue);
}

void label_if(){
	for(int i=0;i<2;i++){
		label[++ltop].labelvalue = lno++;
	}
}

void label2_if(){
	printf("IF not %s goto L%d\n",s[top].value,label[ltop-1].labelvalue);
	
}

void label_while(){
	printf("IF not %s goto L%d\n",s[top].value,label[ltop].labelvalue);
}

void pop_while(){
	print_label(0);
	ltop=ltop-2;
}

void pop_if(){
	label[ltop-1].labelvalue=label[ltop].labelvalue;
	ltop=ltop-1;
	print_label(0);
	ltop=ltop-1;
	
}
void pop_for(){
	label[ltop-3].labelvalue=label[ltop].labelvalue;
	ltop=ltop-3;
	print_label(0);
	ltop=ltop-1;	
	
}


void label_for(){
	for(int i=0;i<4;i++){
		label[++ltop].labelvalue = lno++;
	}
}

void print_goto(int place){
	printf("goto L%d\n",label[ltop-place].labelvalue);
}

void label2_for(){
	printf("IF not %s goto L%d\n",s[top].value,label[ltop].labelvalue);
	print_goto(1);
}



void label1()
{
	printf("IF not %s goto L%d\n",s[top].value,label[ltop].labelvalue);
	label[++ltop].labelvalue = lno++;
}

void label2()
{
 	printf("goto L%d\n",lno);
	printf("L%d:\n",label[ltop].labelvalue);
	ltop--;
	label[++ltop].labelvalue=lno++;
}

void label3()
{
	printf("L%d:\n",label[ltop].labelvalue);
	ltop--;
}

void label4()
{
	printf("L%d:\n",lno);
	label[++ltop].labelvalue = lno++;
}

void start_loop(){
	printf("\nL_start_%s\n", loopstack[looptop].value);
}

void end_loop(){
	printf("L_end_%s\n\n",  loopstack[looptop].value);
	poploop();
}

void label5()
{
	printf("goto L%d:\n",label[ltop-1].labelvalue);
	printf("L%d:\n",label[ltop].labelvalue);
	ltop = ltop - 2;
}

void start_function()
{
	printf("\nfunction begin: %s\n",curfunction);
}

void print_params(){
	getSTparameters(curfunction);
	printf("parameters : %s\n", curparameters);
}

void end_function()
{
	printf("function end\n");
}

void return_goto_func(){
	printf("goto L%d\n",lno);
	printf("L%d:\n",lno);
	end_function();
	ltop--;
	label[++ltop].labelvalue=lno++;
}

void callgen()
{
	printf("refparam result\n");
	push("result");
	printf("call %s, %d\n",currfunccall,call_params_count);
}

void add_case_label(int cl) {
    printf("IF switch_expr == %d goto L_case_%d\n", cl, cl);
}

void start_case(int case_val) {
    printf("L_start_case_%d\n", case_val);
}

void end_case(int case_val){
    printf("L_end_case_%d\n", case_val);
} 

void add_default_label() {
    printf("If switch_expr != any case_val\n");
    printf("goto L_default\n");
}

void start_default() {
    printf("L_start_default\n");
}

void end_default(){
    printf("L_end_default\n");
}

int main()
{	
	createStack();
	yyin = fopen("text.c", "r");
	yyparse();
	if(main_flag==0){
		yyerror("No main function");
	}
	if(flag == 0)
	{
		//printf( "PASSED: Semantic Phase\n");
		printf("\n\n");
		printf("%56s"  "PRINTING SYMBOL TABLE\n", " ");
		printST();
		printf("\n\n");
		printf("%30s"  "PRINTING CONSTANT TABLE\n" , " ");
		printf("\n\n");
		printCT();
		//printf("\n\nLevel Order Traversal of AST\n\n");
        	//levelOrderTraversal(head);
	}
        else{
        	printf("\nNo AST\n");
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
