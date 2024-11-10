# C Compiler Course Project

This repository contains the implementation of a **C Compiler** as part of a course project. The project covers various phases of a compiler including **lexical analysis**, **parsing**, **semantic analysis**, and **symbol table management**. The goal of this project is to develop a simple compiler that can read and process basic C code and perform fundamental tasks such as tokenization, syntax checking, semantic analysis, and symbol table updates.

## Important terms

### 1. **Lexical Analysis**
- The lexer breaks down the input C code into a sequence of tokens (keywords, identifiers, constants, operators, etc.).
- Supports recognition of basic constructs such as variable declarations, operators, and constants.

### 2. **Parsing**
- A **Parser** is implemented to parse the token stream and check for syntactical correctness based on C language grammar.
- It constructs an **Abstract Syntax Tree (AST)**, which represents the syntactical structure of the code.

### 3. **Semantic Analysis**
- The semantic analyzer ensures that the C program adheres to semantic rules, such as type checking and symbol table management.
- Includes checks for undeclared variables, type mismatches, etc.

### 4. **Symbol Table Management**
- **Symbol Table** stores information about variables, functions, and constants encountered during the compilation process.
- scope is implemented using a stack.
- **Constant Table** keeps track of constant values encountered during lexical analysis.
- The recently encountered **identifier's value** field is updated whenever a constant is encountered.

### 5. **Constant Table and Symbol Table Updates (Pending)**
- **Feature to be implemented:** Whenever a constant is encountered, it will be pushed into the **Constant Table**, and the recently encountered **identifier** will have its **value field** updated in the **Symbol Table**.
  - This feature is designed to ensure that constants are correctly stored and linked with the corresponding variables or identifiers.

## **Features**
- Symbol Table is made using array (not hash function).
- Constant table uses hash function to insert values
- Scope is implemented using stack
- Typechecking is implemented (only for int,char,float,double,string).
- Typechecking in function calls is also implemented

  
## **Areas of Improvement**
- Checking array dimentionality while defining.
- only structure declarations are included.
- adding the constants properly into constant table and symbol table.
  



## Usage

1. **Clone the Repository:**

   To get started with the project, first clone the repository:

   ```bash
   git clone https://github.com/harshini-20-05/C-Compiler.git
   cd C-Compiler

