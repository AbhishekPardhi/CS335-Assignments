%{
    #include <bits/stdc++.h>
    using namespace std;
    int yylex();
    void yyerror(const char* s)
    {
        fprintf(stderr, "error: %s\n", s);
    }
%}




%union {
    int num;
    char sym;
}





%token        EOL
%token  <num> NUMBER
%type   <num> exp
%token        PLUS

%%

input:
|   line input
;

line:
    exp EOL             { cout << $1 << endl;           }
|   EOL
;

exp:
    NUMBER              { $$=$1;                }
|   NUMBER PLUS NUMBER  { $$=$1+$3;             }
;

%%

int main()
{
    yyparse();
}

