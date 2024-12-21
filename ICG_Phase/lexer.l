%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h> #include "y.tab.h"
	#include<limits.h>
	#define MAX 1000
	int counter=1;
	char curid[20];
	char curtype[20];
	char curval[20];
	char curparameters[100];

typedef struct Stack {
    int top;
    int items[MAX]; 
    // Fixed size array
} Stack;
Stack scope_info;

void createStack() {
    scope_info.top = -1;
    // Indicates the stack is empty
}

int isFull() {
    return scope_info.top == MAX - 
    1; // Check if stack is full
}

int isEmpty() {
    return scope_info.top == -1;
    // Check if stack is empty
}

void scope_push(int item) {
    if (!isFull()) {
        scope_info.items[++scope_info
        .top] = item; // Push the item
        //printf("pushed %d\n",item);
    } else {
        printf("Stack Overflow\n");
    }
}

int scope_pop() {
	
    if (!isEmpty()) {
        //printf("popped %d\n",scope_i
        nfo.items[scope_info.top]);
        return scope_info.items
        [scope_info.top--]; // Pop the item
    } else {
        printf("Stack Underflow\n");
        return -1; // Or some error code
    }
}
int scope_peek(){	
	if(scope_info.top < 1000 && sc
	ope_info.top >= 0 ){
		return scope_info.items
		[scope_info.top];
	}
	else{
		printf("stack is empty\n");
	}
}
	struct symboltable
	{
		char name[100];
		char class[100];
		char type[100];
		char value[100];
		char dimension[100];
		int nesting_val;
		int lineno;
		int length;
		int scope;
		int array_dimensions;
		int param_type[100];
		char parameters[100];
		int param_flag;
		int params_count;
	}ST[1007];

	struct constanttable
	{
		char name[100];
		char type[100];
		int length;
	}CT[1007];

	int current_nesting = 0;
	int params_count = 0;

	char array_dim_str[10000] = "";

	void append_dim(int val_
	to_append){
		char temp[1000];
		sprintf(temp," %d",
		val_to_append);
		strcat(array_dim_st
		r,temp);
	}

	int hash(char *str)
	{
		int value = 0;
		for(int i = 0 ; i < str
		len(str) ; i++)
		{
			value = 10*val
			ue + (str[i] - 'A');
			value = value %
			1007;
			while(value < 0)
				value
				
		= value + 1007;
		}
		return value;
	}
	void insert_dimensions(cha
	r* str,int dim){
		int current_scope=
		scope_peek();
		for(int i=counter;i>=0;i--){
			if(strcmp(
ST[i].name,str)==0 && ST[i].scope==current_scope){
ST[i].array_dimensions=dim;
return;
			}
		}
	}
	int lookupST(char *str1)
	{
		for(int i=0;i<counter;i++){
if(strcmp(ST[i].name,str1)==0){
if(strcmp(ST[i].class,"Identifier")!=0)
//printf("%s scope : %d current;
	return i;
				}
	else if(ST[i].scope==scope_peek()){
	return i;
				}
			}
		}
		return 0;
	}

	int lookupCT(char *str)
	{
		int value = hash(str);
		if(CT[value].length == 0)
			return 0;
		else if(strcmp(
		CT[value].name,str)==0)
			return 1;
		else
		{
			for(int i 
= value + 1 ; i!=value ; i = (i+1)%1007)
			{
				
	if(strcmp(CT[i].name,str)==0)
				{
	return 1;
				}
			}
			return 0;
		}
	}

	void insertSTline(char *str1, int line)
	{
		for(int i = 0 ; i < 1007 ; i++)
		{
		if(strcmp(ST[i].name,str1)==0)
			{
		ST[i].lineno = line;
			}
		}
	}
	int check_stack(int data){
		for(int i=0;i<=scope_info.top;i++){
			//printf("%d "
			,scope_info.items[i]);
	if(scope_info.items[i]==data){
				
				return 1;
			}
		}
		//printf("\n");
		return 0;
	}
	void insert_param_type(char* str,char* type){
		int current_scope=scope_peek();
		for(int i=counter;i>=0;i--){
			if(strcmp(s
	tr,ST[i].name)==0 && ST[i].scope==current_scope){
				if(strcmp(type,"int")==0){
					ST
		[i].param_type[ST[i].param_flag++]=1;
					
				}
	else if(strcmp(type,"char")==0){
	ST[i].param_type[ST[i].param_flag++]=2;
				}
else if(strcmp(type,"float")==0){
	ST[i].param_type[ST[i].param_flag++]=3;
				}
else if(strcmp(type,"double")==0){
	ST[i].param_type[ST[i].param_flag++]=4;
				}
else{ST[i].param_type[ST[i].param_flag++]=5;
				}
				return;
			}
		}
	}
	
	int get_param_type(char* str,int flag){
		int current_scope=scope_peek();
		for(int i=counter;i>=0;i--){
			
			if(strcmp(str,ST[
			i].name)==0 && s
			trcmp(ST[i].c
			lass, "Functi
			on")==0){
			
	return ST[i].param_type[flag];
			}
		}
	}
	
	void insertST(char *str1, char *str2)
	{
		if(strcmp(str2,"Identifier")!=0){
			if(lookupST(str1)){
				
				ST[look
	upST(str1)].lineno=yylineno;
				return;
			}
		}
		if(lookupST(str1)){
			if(strcmp(str2,
			"Identifier")!=0){
				return;
			}
			else{
				printf
				("redeclaration of %s at %
				d line scope: %d\n",
				str1,yylineno,scope_peek());
				return;
			}
		}
		else{
				int value=counter;counter++;
				strcpy(ST[value].name,str1);
				strcpy(ST[value].class,str2);
				ST[value].length = strlen(str1);
				ST[value].nesting_val = 0;
				ST[value].params_count = 0;
				ST[value].array_dimensions=0;
				ST[value].param_flag = 0;
				if(strcmp(ST[value].
				class,"Keyword")==0){
					ST[value].scope=-1;
					
				}	
				else{
					ST[value].
					scope=scope_peek();
					
				}
				ST[value].lineno=yylineno;
		}
	}
	void insertSTtype(char *str1, char *str2)
	{
		int current_scope=scope_peek();
		for(int i = counter ; i>=0 ; i--)
		{
			if(strcmp(ST[i].name,
	str1)==0 && ST[i].scope==current_scope)
			{	
				//pri
		strcpy(ST[i].type,str2);
				return;
			}
		}
       }
	
void insertSTparameters(char *str1, char *str2){
		for(int i=counter;i>=0;i--){
	if(strcmp(ST[i].name, str1)==0){
	if(strcmp(ST[i].name, "printf")==0){
	strcpy(ST[i].parameters, str2);
				}
				else{
		strcat(ST[i].parameters, " ");
		strcat(ST[i].parameters, str2);
				}
			}
		}
	}
	
	void getSTparameters(char *str1){
		for(int i=counter;i>=0;i--){
	if(strcmp(ST[i].name, str1)==0){
	strcpy(curparameters, ST[i].parameters);	
			}
		}
	}
int check_type(char* str){
		
		int value = hash(str);
		if(CT[value].length == 0)
			return 0;
		else if(strcmp
		(CT[value].name,str)==0){
			if(strcmp
	(CT[value].type,"Number Constant")==0){
		return 1;
			}
			else if(strc
			
			
mp(CT[value].type,"Character Constant")==0){
		return 2;
			}
			else if (
strcmp(CT[value].type,"Floating Constant")==0){
		return 3;
			}
			else{
	return 4;
			}
		}
			
		else
		{
			for(int i 
= value + 1 ; i!=value ; i = (i+1)%1007)
			{
	if(strcmp(CT[i].name,str)==0)
				{
	if(strcmp(CT[i].type,"Number Constant")==0){
	return 1;
					}
else if(strcmp(CT[value].type,"Charact
er Constant")==0){
		return 2;
					}
else if (strcmp(CT[i].type,
"Floating Constant")==0){
	return 3;
					}
else{
return 4;
					}
				}
			}
			return 0;
		}
	}
	int check_value(char* str1,char* str2){
		int store=check_type(str2);
		if(strcmp
		(str1,"int")==0 && store==1){
			return 1;
		}
		else if((strcmp
		(str1,"float")==0
		|| strcmp(str1,
		"double")==0)&&
		store==3)return 1;
		else if(strcmp
		(str1,"char")==
		0 && store==2)return 1;
		else if((strcmp
		(str1,"string")==0 || 
		strcmp(str1,"Array
		Identifier")==0)&& 
		store==4)return 1;
		else return 0;
	}
	void insertSTvalue(char *str1,
	char *str2)
	{
		
		for(int i = counter 
		; i>=0 ; i--)
		{	
			if(strcmp(ST
			[i].name,str1)==0 
			&& check_stack(ST[i].
			scope))// 
			{
if(strcmp(ST[i].class, "Function")==0){
	return;
					}
		else{
if(check_value(ST[i].type,str2)==0){
printf("\nError: Incompatible value
assigned for %s at %d line\n\n",str1,yylineno);
return;
		}
strcpy(ST[i].value,str2);
	return;
		}
			}
		}
	}


	void insertSTnest(char *s, int nest)
	{
		
		
			int value=lookupST(s);
			ST[value].nesting_val=nest;
		//}
	}

	void insertSTparamscount(char *s, int count)
	{
		for(int i = 0 ; i < 1007 ; i++)
		{
			if(strcmp(ST[i].name,s)==0 )
			{
				ST[i].params_count = count;
			}
		}
	}

	int getSTparamscount(char *s)
	{
		for(int i = 0 ; i < 1007 ; i++)
		{
			if(strcmp(ST[i].name,s)==0 )
			{
				return ST[i].param_flag;
			}
		}
		return -2;
	}
	
	int get_class(char *str){
		for(int i=counter;i>=0;i--){
			if(strcmp(ST[i].name,str)==0){
				if(strcmp
				(ST[i].class, "Identifier")==0){
					return 1;
				}
				else{
					return 0;
				}
			}
		}
	} 

	void insertSTF(char *s)
	{
		for(int i = 0 ; i < 1007 ; i++)
		{
			if(strcmp(ST[i].name,s)==0 )
			{
				strcpy(ST[
				i].class,"Function");
				return;
			}
		}

	}

	void insertCT(char *str1, char *str2)
	{
		if(lookupCT(str1))
			return;
		else
		{
			int value = hash(str1);
			if(CT[value].length == 0)
			{
				strcpy(CT[valu
				e].name,str1);
				strcpy(CT[val
				ue].type,str2);
				CT[value].len
				gth = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = value + 1;
			i!=value ; i = (i+1)%1007)
			{
				if(CT[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(CT[pos].name,str1);
			strcpy(CT[pos].type,str2);
			CT[pos].length = strlen(str1);
		}
	}

	void deletedata (int nesting)
	{
		for(int i = 0 ; i < 1007 ; i++)
		{
			if(ST[i].nesting_val == nesting)
			{
				ST[i].nesting_val = 99999;
			}
		}


	}

	int checkscope(char *s)
	{
		int flag = 0;
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].name,s)==0)
			{
				if(ST[i].nest
				ing_val > current_nesting)
				{
					flag = 1;
				}
				else
				{
					flag = 0;
					break;
				}
			}
		}
		if(!flag)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}

	int check_id_is_func(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].name,s)==0)
			{
				if(strcmp(ST[i].class
				,"Function")==0)
					return 1;
			}
		}
		return 0;
	}

	int checkarray(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].name,s)==0)
			{
				if(strcmp(ST[i].cla
ss,"Array Identifier")==0)
				{
					return 0;
				}
			}
		}
		return 1;
	}

	int duplicate(char *s)
	{
		int current_scope=scope_peek();
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].name,s)==0)
			{				
				if(ST[i].scope==
	current_scope)
				{	
			        	return 1;
				}
			}
		}
		
		return 0;
	}

	int check_duplicate(char* str)
	{
		for(int i=0; i<1007; i++)
		{
			if(strcmp(ST[i].name, str)
== 0 && strcmp(ST[i].class, "Function") == 0)
			{
printf("Function redeclaration not allowed\n");
				exit(0);
			}
		}
	}

	int check_declaration(char* str, char *check_type)
	{
		for(int i=0; i<1007; i++)
		{
			if(strcmp(ST[i].name
, str) == 0 && strcmp(ST[i].class, "Function"
) == 0 || strcmp(ST[i].name,"printf")==0 )
			{
				return 1;
			}
		}
		return 0;
	}

	int check_params(char* type_specifier)
	{
		if(!strcmp(type_specifier, "void"))
		{
			printf("Parameters ca
			nnot be of type void\n");
			exit(0);
		}
		return 0;
	}

	char gettype(char *s, int flag)
	{
			
	for(int i = counter ; i >=0 ; i-- )
			{
if(strcmp(ST[i].name,s)==0)
				{
	return ST[i].type[0];
				}
			}
		
	}
	

	void process_array_dimensions(){
		

		
		char *input = array_dim_str;
		char id[100];  
		char numbers[100];
		int offset = 0;
		
		while (sscanf(input + offset
, "%s %[^\n]s", id, numbers) == 2) {
			offset += snprintf(
NULL, 0, "%s %s", id, numbers) + 1;
			for(int i = 0 ; i
< 1007 ; i++)
			{
				if(strcmp
(ST[i].name,id)==0)// 
				{
	strcpy(ST[i].value,numbers);
				}
			}
		}
		
	}

	void printST()
	{	
		printf("--------------------------
		------------------
		------------------------------------
		------------------------------------
		------------------------------------
		-----------------------\n");
		printf(" %20s | %20s | %10s | 
		%20s | %10s
		| %10s | %15s | %15s | %15s | 
		%10s |\n","Symbol name", "Clas
		s", "Type","Array Dimensions"
		,"Value", "Line No.", "Nestin
		g Count", "Parameters", "Coun
		t of Params","Scope");
		printf("-------------------
		----------------
		---------------------------
		---------------------------
		----------------------------
		-------------------------
		----------------------
		-----------\n");
		for(int i = 0 ; i < 1007 ; i++)
		{
			if(ST[i].length == 0)
			{
				continue;
			}

			//printf("%d   length : 
			%d\n",i,ST[i].length);
			printf(" %20s | %20s 
			| %10s | %20d | %10s 
			| %10d | %15d | %15s
			| %15d | %10d |\n
			",ST[i].name, ST[i].
			class, ST[i].type,
			ST[i].array_dimens
			ions, ST[i].value,
			ST[i].lineno, ST[i
			].nesting_val, ST[
			i].parameters, ST
			[i].param_flag,ST[
			i].scope);



			
		}
		printf("----------------
		--------------------
		----------------------------
		-----------------------
		----------------------
		---------------------
		---------------------
		--------------------
		----\n");
							
    }


	void printCT()
	{
	printf("--------------------
	--------------------------\n");
	printf(" %20s | %20s |\n","
	Constant name", "Constant type");
	printf("---------------
	---------------------
	----------\n");
	for(int i = 0 ; i < 1007 ; i++)
		{
		if(CT[i].length == 0)
		continue;

printf(" %20s | %20s |\n",CT[i].name, CT[i].type);
		}
printf("----------------------------------------------\n");

		// printf("%s\n",array_dim_str);
	}

%}

DE "define"
IN "include"

%%
\n 	{yylineno++;}
([#][" "]({IN})[ ]([<]?)([A-Za-z]
+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"]{ }
([#][" "]({DE})[" "]([A-Za-z]+
)(" ")*[0-9]+)/["\n"|\/|" "|"\t"]{ } 
\/\/(.*)																		{ }
\/\([^]|[\r\n]|(\+([^/]|[\r\n])))\+\/{ }
[ \n\t] ;
";"				{ return SEMI
_COLON; }
","				{ return COMMA; }
("{")			{ return OPEN_CURLY; }
("}")			{ return CLOSE_CURLY; }
"("				{ return OPEN
_BRACE; }
")"				{ return CLOSE_
BRACE; }
("["|"<:")		{ return OPEN_SQR; }
("]"|":>") 		{ return CLOSE_SQR; }
":"				{ return COLON; }
"."				{ return DOT; }
"const"		    { insertST(yytext, "Keyword
");  return CONST;}
"default"		{ insertST(yytext,
"Keyword");  return DEFAULT;}
"char"			{ strcpy(curtype,yyte
xt); insertST(yytext, "Keyword");return CHAR;}
"double"		{ strcpy(curtype,yyte
xt); insertST(yytext, "Keyword"); return DOUBLE;}
"else"			{ insertST(yytext, "K
eyword"); return ELSE;}
"float"			{ strcpy(curtype,yyte
xt); insertST(yytext, "Keyword"); return FLOAT;}
"while"			{ insertST(yytext, "Ke
yword"); return WHILE;}
"do"			{ insertST(yytext, "Ke
yword"); return DO;}
"for"			{ insertST(yytext, "Key
word"); return FOR;}
"if"			{ insertST(yytext, "Key
word"); return IF;}
"int"			{ strcpy(curtype,yytex
t); insertST(yytext, "Keyword"); return INT;}
"long"			{ strcpy(curtype,yytext
); insertST(yytext, "Keyword"); return LONG;}
"return"		{ insertST(yytext, "Key
word"); return RETURN;}
"short"			{ strcpy(curtype,yytext);
insertST(yytext, "Keyword"); return SHORT;}
"signed"		{ strcpy(curtype,yytext);
insertST(yytext, "Keyword"); return SIGNED;}
"sizeof" 		{ insertST(yytext,
"Keyword"); return SIZEOF;}
"struct"		{ strcpy(curtype,yy
text);   insertST(yytext, "Keyword");
return STRUCT;}
"typedef"		{ strcpy(curtype,yyt
ext);   insertST(yytext, "Keyword"); 
return TYPEDEF;}
"enum"		    { strcpy(curtype,yytext)
; insertST(yytext, "Keyword");  return ENUM;}
"union"		    { strcpy(curtype,yytext);
insertST(yytext, "Keyword");  return UNION;}
"unsigned"		{ insertST(yytext, 
"Keyword");   return UNSIGNED;}
"void"			{ strcpy(curtype,
yytext);   insertST(yytext, "Keyword"); 
return VOID;}
"break"			{ insertST(yytext,
"Keyword");  return BREAK;}
"switch"		{ insertST(yytext,
"Keyword");  return SWITCH;}
"case"			{ insertST(yytext, 
"Keyword");  return CASE;}
"continue"			{ insertST
(yytext, "Keyword");  return CONTINUE;}

"int*"			{ strcpy(curtype
,yytext); insertST(yytext, "Keyword");return INTs;}
"float*"		{ strcpy(curtype,
yytext); insertST(yytext, "Keyword");return FLOATs;}
"char*"			{ strcpy(curtype
,yytext); insertST(yytext, "Keyword");return CHARs;}
"double*"		{ strcpy(curtype
,yytext); insertST(yytext, 
"Keyword");return DOUBLEs;}

"auto"          { insertST(yytext, "
Keyword"); return AUTO; }
"static"        { insertST(yytext,
"Keyword"); return STATIC; }
"register"      { insertST(yytext, 
"Keyword"); return REGISTER; }
"extern"        { insertST(yytext, 
"Keyword"); return EXTERN; }
"volatile"      { insertST(yytext,
"Keyword"); return EXTERN; }
"inline"        { insertST(yytext, 
"Keyword"); return INLINE; }

"printf"		{ insertST
(yytext, "Keyword");  return PRINTF;}
"scanf"			{ insertST(
yytext, "Keyword");  return SCANF;}


"++"	{ return INCREMENT_OPERATOR; }
"--"{ return DECREMENT_OPERATOR; }
"<<"	{ return LEFTSHIFT_OPERATOR; }
">>"	{ return RIGHTSHIFT_OPERATOR; }
"<="	{ return LESSTHAN_ASSIGNMENT_OPERATOR; }
"<"	{ return LESSTHAN_OPERATOR; }
">="	{ return GREATERTHAN_ASSIGNMENT_OPERATOR; }
">"	{ return GREATERTHAN_OPERATOR; }
"=="	{ return EQUALITY_OPERATOR; }
"!="	{ return INEQUALITY_OPERATOR; }
"&&"	{ return AND_OPERATOR; }
"||"	{ return OR_OPERATOR; }
"^"	{ return CARET_OPERATOR; }
"*="	{ return MULTIPLICATION_ASSIGNMENT_OPERATOR; }
"/="	{ return DIVISION_ASSIGNMENT_OPERATOR; }
"%="	{ return MODULO_ASSIGNMENT_OPERATOR; }
"+="	{ return ADDITION_ASSIGNMENT_OPERATOR; }
"-="	{ return SUBTRACTION_ASSIGNMENT_OPERATOR; }
"<<="	{ return LEFTSHIFT_ASSIGNMENT_OPERATOR; }
">>="	{ return RIGHTSHIFT_ASSIGNMENT_OPERATOR; }
"&="	{ return AND_ASSIGNMENT_OPERATOR; }
"^="	{ return XOR_ASSIGNMENT_OPERATOR; }
"|="	{ return OR_ASSIGNMENT_OPERATOR; }
"&"	{ return AMP_OPERATOR; }
"!"	{ return EXCLAMATION_OPERATOR; }
"~"	{ return TILDE_OPERATOR; }
"-"	{ return SUBTRACT_OPERATOR; }
"+"	{ return ADD_OPERATOR; }
"*"	{ return MULTIPLICATION_OPERATOR; }
"/"	{ return DIVISION_OPERATOR; }
"%"	{ return MODULO_OPERATOR; }
"|"	{ return PIPE_OPERATOR; }
\=	{ return ASSIGNMENT_OPERATOR;}

\"[^\n]*\"/[;|,|\)] 		
{strcpy(curval,yytext); 
insertCT(yytext,"String C
onstant"); return STRING_CONSTANT;}
\'[A-Z|a-z]\'/[;|,|\)|:] 					

{strcpy(curval,yytext); insertCT(yytext,"Character 
Constant"); return CHARACTER_CONSTANT;}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ 							
{strcpy(curid,yytext);  return ARRAY_IDENTIFIER;}
[1-9][0-9]|0|[;,\s\)\<\>\=\!\|\&\+\-\\/\%
\~\]\}\:\n\t\^] 			
{strcpy(curval,yytext); insertCT(yytext, "Number
Constant"); return INTEGER_CONSTANT;}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||
&|\+|\-|\*|\/|\%|~|\n|\t|\^] 	
{strcpy(curval,yytext); insertCT(yytext, 
"Floating Constant"); return FLOAT_CONSTANT;}
[A-Za-z_][A-Za-z_0-9]* {strcpy(curid,yyte
xt);  return IDENTIFIER;}

(.?) {
		if(yytext[0]=='#')
		{
			printf("Error 
			in Pre-Proces
			sor directive
	at line no. %d\n",yylineno);
		}
		else if(yytext[0]=='/')
		{
printf("ERR_UNMATCHED_COMMENT at line no. %d\n",yylineno);
		}
		else if(yytext[0]=='"')
		{
printf("ERR_INCOMPLETE_STRING at line no. %d\n",yylineno);
		}
		else
		{
printf("ERROR at line no. %d\n",yylineno);
		}
		printf("%s\n", yytext);
		return 0;
}

%%
