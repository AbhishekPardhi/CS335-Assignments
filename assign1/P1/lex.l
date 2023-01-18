%{
    #include <bits/stdc++.h>
    using namespace std;

    vector<string> tokenTable{"Keyword","Identifier","Separator","Operator","Literal"};
    vector<string> errorTable{"Nested comment found.","Decimal numbers must have a digit before decimal."};
    unordered_map<string, vector<int>> table;
    int lexemeCount;
    char*file;

    void AddLexeme(string lexeme,int token);

    bool comp(const pair<string,vector<int>> &a, const pair<string,vector<int>> &b);

    void PrintData();
    
    void ReportError(int index);
%}

TYPE int|char|bool|float
DIGIT [0-9]
ID [a-zA-Z][a-zA-Z0-9]*
ERROR {ID}"."

%%
\n { yylineno++; }
{ERROR} {ReportError(1);PrintData();return 0;}
"{"[^{\n]*"{" {ReportError(0);PrintData();return 0;}
"{"[^{}}]*"}" /* eat up comments */
"array"|"begin"|"case"|"const"|"do"|"downto"|"else"|"end"|"file"|"for"|"function"|"goto"|"if"|"label"|"nil"|"of"|"packed"|"procedure"|"program"|"record"|"repeat"|"set"|"then"|"to"|"type"|"until"|"var"|"while"|"with" AddLexeme(strdup(yytext),0);
"add"|"or"|"not"|"div"|"mod"|"in" AddLexeme(strdup(yytext),3);
{ID} AddLexeme(strdup(yytext),1);
"-"?{DIGIT}+ AddLexeme(strdup(yytext),4);
"-"?{DIGIT}+"."{DIGIT}+ AddLexeme(strdup(yytext),4);
","|";"|":"|"("|")"|"["|"]"|".." AddLexeme(strdup(yytext),2);
"+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"^" AddLexeme(strdup(yytext),3);
. /*Don't print*/;
%%

/*
0 = Keyword
1 = Identifier
2 = Separator
3 = Operator
4 = Literal
*/

void AddLexeme(string lexeme,int token)
{
    if(table.find(lexeme) == table.end())
        table[lexeme] = vector<int>{token, 1, lexemeCount++};
    else
        table[lexeme][1]++;
}

bool comp(const pair<string,vector<int>> &a, const pair<string,vector<int>> &b)
{
    return a.second[2] < b.second[2];
}

void PrintData()
{
    ofstream fout;
    fout.open(file);
    vector <pair<string, vector<int>>> newData;
    for(auto element:table)
        newData.push_back(make_pair(element.first, element.second));
    sort(newData.begin(), newData.end(), comp);
    fout << "Lexeme,Token,Count" << endl;
    for(auto element:newData)
    {
        fout << element.first << "," << tokenTable[element.second[0]] << "," << element.second[1] <<  endl;
    }
    fout.close();
}

void ReportError(int index)
{
    cout << "\033[31mCompilation error at line no." << yylineno << ": " << errorTable[index] << endl;
}

int main(int argc, char*argv[]){
    lexemeCount=0;
    file=argv[1];
    yylex();
    PrintData();
}