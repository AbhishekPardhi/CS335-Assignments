#!/bin/bash
flex lex.l
g++ -o scan lex.yy.c -ll
./scan test.csv < test.335
# ./scan test1.csv < public1.335
# ./scan test2.csv < public2.335
# ./scan test3.csv < public3.335
# ./scan test4.csv < public4.335