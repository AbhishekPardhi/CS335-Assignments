%{
    #include <bits/stdc++.h>
    #include "parser.tab.h"
    using namespace std;
%}

%%

[0-9]+      { yylval.num=atoi(yytext); return NUMBER; }
\n          { return EOL;                             }
"+"         {return PLUS;}
.           {                                         }

%%