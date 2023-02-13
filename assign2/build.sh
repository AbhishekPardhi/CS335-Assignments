#!/bin/bash

bison -d -t parser.y
flex lexer.l
g++ parser.tab.c lex.yy.c -ll -o parser
./parser