#!/bin/bash
flex lex.l
g++ -o scan lex.yy.c -ll
# ./scan test1.csv < BubbleSort.java
# ./scan test2.csv < SyntaxCheck.java
# ./scan test3.csv < test_25.java
# ./scan test4.csv < TypeCoercion.java
./scan test.csv < test.java
