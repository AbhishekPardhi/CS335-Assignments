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

ReservedKeyword "abstract"|"continue"|"for"|"new"|"switch"|"assert"|"default"|"if"|"package"|"synchronized"|"boolean"|"do"|"goto"|"private"|"this"|"break"|"double"|"implements"|"protected"|"throw"|"byte"|"else"|"import"|"public"|"throws"|"case"|"enum"|"instanceof"|"return"|"transient"|"catch"|"extends"|"int"|"short"|"try"|"char"|"final"|"interface"|"static"|"void"|"class"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"while"
ContextualKeyword "exports"|"opens"|"requires"|"uses"|"module"|"permits"|"sealed"|"var"|"non-sealed"|"provides"|"to"|"with"|"open"|"record"|"transitive"|"yield"

Keyword {ReservedKeyword}|{ContextualKeyword}

NonZeroDigit [1-9]
Digit [0-9]
Underscores [_]+
DigitOrUnderscore {Digit}|[_]
DigitsAndUnderscores {DigitOrUnderscore}+
Digits {Digit}|({Digit}{DigitsAndUnderscores}{Digit})

DecimalNumeral ({NonZeroDigit}{Digits})|({NonZeroDigit}{Underscores}{Digits})
DecimalIntegerLiteral ({DecimalNumeral}{IntegerTypeSuffix})
HexIntegerLiteral ({HexNumeral}{IntegerTypeSuffix})
OctalIntegerLiteral ({OctalNumeral}{IntegerTypeSuffix})
BinaryIntegerLiteral ({BinaryNumeral}{IntegerTypeSuffix})
IntegerTypeSuffix [lL]

IntegerLiteral {DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral}

Literal = {IntegerLiteral}

%x COMMENT
%%
\n { yylineno++; }
{Keyword} AddLexeme(strdup(yytext),KEYWORD);
{Literal} AddLexeme(strdup(yytext),LITERAL);
. /*Couldn't recognize lexeme*/;
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
    cout << "\033[31mCompilation error at line no." << yylineno << ": " << errorTable[index] << endl;
}

int main(int argc, char*argv[]){
    lexemeCount=0;
    file=argv[1];
    yylex();
    PrintData();
}