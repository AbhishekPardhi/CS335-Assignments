%{
    #include <bits/stdc++.h>
    using namespace std;

    vector<string> tokenTable{"Keyword","Identifier","Separator","Operator","Literal"};
    enum Tokens{KEYWORD=0,IDENTIFIER=1,SEPARATOR=2,OPERATOR=3,LITERAL=4};
    vector<string> errorTable{"Decimal numbers must have a digit before decimal."};
    unordered_map<string, vector<int>> table;
    int lexemeCount;
    char*file;

    void AddLexeme(string lexeme,int token);

    bool comp(const pair<string,vector<int>> &a, const pair<string,vector<int>> &b);

    void PrintData();
    
    void ReportError(int index);
%}

DIGIT [0-9]
ID [a-zA-Z][a-zA-Z0-9]*
ERROR ^{ID}"."
OPERATOR "+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"^"|"add"|"or"|"not"|"div"|"mod"|"in"
STRING \"[^\"]*\"
KEYWORD array|begin|case|const|do|downto|else|end|file|for|function|goto|if|label|nil|of|packed|procedure|program|record|repeat|set|then|to|type|until|var|while|with
SEPARATOR ","|";"|":"|"("|")"|"["|"]"
LITERAL ({DIGIT}+|([-]?{DIGIT}+"."{DIGIT}+))+([eE][+-]?{DIGIT}+)?
WS [ \t\n\f]

%x COMMENT
%x PERIOD
%option yylineno
%%
[^a-zA-Z0-9\.]\. {cout << yytext<<endl;ReportError(0);PrintData();YY_FATAL_ERROR("Aborting...");}
"{" {BEGIN(COMMENT);}
<COMMENT>[^}]* /* ignore everything within the comment */
<COMMENT>"}" {BEGIN(INITIAL);}
[\.] {BEGIN(PERIOD);yymore();}
<PERIOD>[\.] {AddLexeme(yytext,SEPARATOR);BEGIN(INITIAL);}
<PERIOD>[a-zA-Z0-9] {yyless(1);AddLexeme(yytext,OPERATOR);BEGIN(INITIAL);}
{OPERATOR} AddLexeme(yytext,OPERATOR);
{KEYWORD} AddLexeme(yytext,KEYWORD);
{ID} AddLexeme(yytext,IDENTIFIER);
{LITERAL} AddLexeme(yytext,LITERAL);
{SEPARATOR} AddLexeme(yytext,SEPARATOR);
{STRING} AddLexeme(yytext,LITERAL);
{WS} /*ignore*/
. {cerr << "Error: invalid character sequence: " << yytext << " at line: " << yylineno << endl; }
%%

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
    cerr << "\033[31mCompilation error at line no." << yylineno << ": " << errorTable[index] << endl;
}

int main(int argc, char*argv[]){
    lexemeCount=0;
    if(argc<2)
    {
        cerr << "You must provide a .csv file as input to the command." << endl;
        return 0;
    }
    file=argv[1];
    yylex();
    PrintData();
}