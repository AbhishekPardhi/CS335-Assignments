%{
    #include <bits/stdc++.h>
    using namespace std;

    vector<string> tokenTable{"Keyword","Identifier","Separator","Operator","Literal"};
    enum Tokens{KEYWORD=0,IDENTIFIER=1,SEPARATOR=2,OPERATOR=3,LITERAL=4};
    vector<string> errorTable{"Text Block can not have \\ in it."};
    unordered_map<string, vector<int>> table;
    int lexemeCount;
    char*file;

    void AddLexeme(string lexeme,int token);

    bool comp(const pair<string,vector<int>> &a, const pair<string,vector<int>> &b);

    void PrintData();
    
    void ReportError(int index);
%}
/*#############################*/
LineTerminator "\n"|"\r"|"\r\n"
WhiteSpace " "|"\t"|"\f"|{LineTerminator}
WS [ \t\f]
/*#############################*/
EndOfLineComment "//"[^\n]*
NotStarNotSlash [^*/]|{LineTerminator}
NotStar [^*]|{LineTerminator}
CommentTailStar [//]|([*]{CommentTailStar})|({NotStarNotSlash}{CommentTail})
CommentTail ({NotStar}{CommentTail})
TraditionalComment "/*"{CommentTail}
Comment "/*"[^"*/"]"*/"
/*#############################*/
JavaLetter [a-zA-Z_]
JavaLetterOrDigit [a-zA-Z0-9_]
IdentifierChars {JavaLetter}{JavaLetterOrDigit}*
Identifier {IdentifierChars}
/*#############################*/
ReservedKeyword "abstract"|"continue"|"for"|"new"|"switch"|"assert"|"default"|"if"|"package"|"synchronized"|"boolean"|"do"|"goto"|"private"|"this"|"break"|"double"|"implements"|"protected"|"throw"|"byte"|"else"|"import"|"public"|"throws"|"case"|"enum"|"instanceof"|"return"|"transient"|"catch"|"extends"|"int"|"short"|"try"|"char"|"final"|"interface"|"static"|"void"|"class"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"while"
ContextualKeyword "exports"|"opens"|"requires"|"uses"|"module"|"permits"|"sealed"|"var"|"non-sealed"|"provides"|"to"|"with"|"open"|"record"|"transitive"|"yield"
Keyword {ReservedKeyword}|{ContextualKeyword}
/*#############################*/
NonZeroDigit [1-9]
Digit [0-9]
Underscores [_]+
DigitOrUnderscore {Digit}|[_]
DigitsAndUnderscores {DigitOrUnderscore}+
Digits {Digit}|({Digit}{DigitsAndUnderscores}?{Digit})
DecimalNumeral [0]|({NonZeroDigit}{Digits}?)|({NonZeroDigit}{Underscores}{Digits})
IntegerTypeSuffix [lL]
DecimalIntegerLiteral ({DecimalNumeral}{IntegerTypeSuffix}?)
/*-----------------------------*/
HexDigit [0-9a-fA-F]
HexDigitOrUnderscore {HexDigit}|[_]
HexDigitsAndUnderscores {HexDigitOrUnderscore}+
HexDigits {HexDigit}|({HexDigit}{HexDigitsAndUnderscores}{HexDigit})
HexNumeral ("0x"{HexDigits})|("0X"{HexDigits})
HexIntegerLiteral ({HexNumeral}{IntegerTypeSuffix}?)
/*-----------------------------*/
OctalDigit [0-7]
OctalDigitOrUnderscore {OctalDigit}|[_]
OctalDigitsAndUnderscores {OctalDigitOrUnderscore}+
OctalDigits {OctalDigit}|({OctalDigit}{OctalDigitsAndUnderscores}?{OctalDigit})
OctalNumeral ("0"{OctalDigits})|("0"{Underscores}{OctalDigits})
OctalIntegerLiteral ({OctalNumeral}{IntegerTypeSuffix}?)
/*-----------------------------*/
BinaryDigit [01]
BinaryDigitOrUnderscore {BinaryDigit}|[_]
BinaryDigitsAndUnderscores {BinaryDigitOrUnderscore}+
BinaryDigits {BinaryDigit}|({BinaryDigit}{BinaryDigitsAndUnderscores}?{BinaryDigit})
BinaryNumeral ("0b"{BinaryDigits})|("0B"{BinaryDigits})
BinaryIntegerLiteral ({BinaryNumeral}{IntegerTypeSuffix}?)
/*-----------------------------*/
IntegerLiteral {DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral}
/*-----------------------------*/
FloatTypeSuffix [fFdD]
Sign [+-]
SignedInteger {Sign}?{Digits}
ExponentIndicator [eE]
ExponentPart {ExponentIndicator}{SignedInteger}
DecimalFloatingPointLiteral ({Digits}[\.]{Digits}?{ExponentPart}?{FloatTypeSuffix}?)|([\.]{Digits}{ExponentPart}?{FloatTypeSuffix}?)|({Digits}{ExponentPart}{FloatTypeSuffix}?)|({Digits}{ExponentPart}?{FloatTypeSuffix})
/*-----------------------------*/
BinaryExponentIndicator [pP]
BinaryExponent {BinaryExponentIndicator}{SignedInteger}
HexSignificand ({HexNumeral}[\.]?)|("0x"{HexDigits}?[\.]{HexDigits})|("0X"{HexDigits}?[\.]{HexDigits})
HexadecimalFloatingPointLiteral {HexSignificand}{BinaryExponent}{FloatTypeSuffix}?
/*-----------------------------*/
FloatingPointLiteral {DecimalFloatingPointLiteral}|{HexadecimalFloatingPointLiteral}
/*-----------------------------*/
BooleanLiteral true|false
/*-----------------------------*/
SingleCharacter [^\'\]
CharacterLiteral [\'][^\'\][\']
/*-----------------------------*/
StringCharacter [^\"\n]
StringLiteral ["]{StringCharacter}*["]
/*-----------------------------*/
TextBlockCharacter [^\\]|{LineTerminator}
TextBlockWhiteSpace " "|"\t"|"\f"
TextBlock [\"]{3}{TextBlockWhiteSpace}*{LineTerminator}{TextBlockCharacter}*[\"]{3}
/*-----------------------------*/
NullLiteral null
/*-----------------------------*/
Literal {IntegerLiteral}|{FloatingPointLiteral}|{BooleanLiteral}|{CharacterLiteral}|{StringLiteral}|{NullLiteral}
/*#############################*/
Separator "\("|"\)"|"\{"|"\}"|"\["|"\]"|";"|","|"."|"..."|"@"|"::"
/*#############################*/
Operator "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="
/*#############################*/
Token {Identifier}|{Keyword}|{Literal}|{Separator}|{Operator}
InputElement {WhiteSpace}|{Comment}|{Token}
Input {InputElement}*

%x COMMENT
%x TEXTBLOCK
%%
\n { yylineno++; }
"/*" {BEGIN(COMMENT);}
<COMMENT>[^*\n]*
<COMMENT>"*"+[^*/\n]*
<COMMENT>[\n] {yylineno++;}
<COMMENT>"*/" {BEGIN(INITIAL);}
"//"+.* 
[\"]{3}{WS}*{LineTerminator} {BEGIN(TEXTBLOCK);yymore();}
<TEXTBLOCK>[\"]{3} {AddLexeme(yytext,LITERAL);BEGIN(INITIAL);}
<TEXTBLOCK>[\\] {ReportError(0);PrintData();return 0;}
<TEXTBLOCK>[\n] {yylineno++;yymore();}
<TEXTBLOCK>[\"]{0,2}+[^\"\n]* {yymore();}
{Keyword} AddLexeme(yytext,KEYWORD);
{Literal} AddLexeme(yytext,LITERAL);
{Separator} AddLexeme(yytext,SEPARATOR);
{Operator} AddLexeme(yytext,OPERATOR);
{Identifier} AddLexeme(yytext,IDENTIFIER);
. /*{cout << yytext << endl;}*/
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
        fout << ((element.first==",")?"\",\"":element.first) << "," << tokenTable[element.second[0]] << "," << element.second[1] <<  endl;
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