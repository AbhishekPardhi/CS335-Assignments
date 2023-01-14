%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #define TABLE_SIZE 128

    int entryCount = 0;

    char* tokenTable [] = {"Keyword","Identifier","Separator","Operator","Literal"};

    struct entry {
        char* key;
        int token;
        int count;
        int index;
        struct entry* next;
    };

    struct entry* table[TABLE_SIZE] = { NULL };

    unsigned int hash(char* key) {
        unsigned int hash = 0;
        for (int i = 0; i < strlen(key); i++) {
            hash = 31 * hash + key[i];
        }
        return hash % TABLE_SIZE;
    }

    void insert(char* key, int token, int count) {
        unsigned int index = hash(key);
        struct entry* newEntry = (struct entry*)malloc(sizeof(struct entry));
        newEntry->key = key;
        newEntry->token = token;
        newEntry->count = count;
        newEntry->index = entryCount++;
        newEntry->next = table[index];
        table[index] = newEntry;
    }

    struct entry* lookup(char* key) {
        unsigned int index = hash(key);
        struct entry* current = table[index];
        while (current != NULL) {
            if (strcmp(current->key, key) == 0) {
                return current;
            }
            current = current->next;
        }
        return NULL;
    }

    void addLexeme(char* key, int tokenIndex) {
		unsigned int index = hash(key);
        struct entry* current = table[index];
        while (current != NULL) {
            if (strcmp(current->key, key) == 0) {
                current->count++;
				return;
            }
            current = current->next;
        }
        // couldn't found the key
        insert(key, tokenIndex, 1);
    }

    int compare(const void* a, const void* b) {
        struct entry* entryA = *(struct entry**)a;
        struct entry* entryB = *(struct entry**)b;
        return (entryA->index>entryB->index);
    }

    struct entry** sortValues() {
        struct entry** entries = (struct entry**)malloc(sizeof(struct entry*) * entryCount);
        int k = 0;
        for (int i = 0; i < TABLE_SIZE; i++) {
            struct entry* current = table[i];
            while (current != NULL) {
                entries[k++] = current;
                current = current->next;
            }
        }
        qsort(entries, entryCount, sizeof(struct entry*), compare);
        return entries;
    }

    void printValues() {
        FILE *file = fopen("test.csv", "w");
        struct entry** entries = sortValues();
        
        printf("--------------------------------------\n");
        printf("Lexeme         Token          Count\n");
        printf("--------------------------------------\n");
        fprintf(file, "Lexeme,Token,Count\n");

        for (int i = 0; i < entryCount; i++) {
            printf("%s",entries[i]->key);
            int j=15-strlen(entries[i]->key);
            while(j--) printf(" ");
            printf("%s",tokenTable[entries[i]->token]);
            j=15-strlen(tokenTable[entries[i]->token]);
            while(j--) printf(" ");
            printf("%d\n",entries[i]->count);

            fprintf(file, "%s,%s,%d\n",entries[i]->key,tokenTable[entries[i]->token],entries[i]->count);
        }
        free(entries);
        fclose(file);
    }
%}

TYPE int|char|bool|float
DIGIT [0-9]
ID [a-z][a-z0-9]*

%%
"program"|"var"|"begin"|"for"|"to"|"do"|"end" addLexeme(strdup(yytext),0);
"add"|"or"|"not"|"div"|"mod"|"in" addLexeme(strdup(yytext),3);
{ID} addLexeme(strdup(yytext),1);
{DIGIT}+ addLexeme(strdup(yytext),4);
{DIGIT}+"."{DIGIT}* addLexeme(strdup(yytext),4);
"+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"^" addLexeme(strdup(yytext),3);
","|";"|":"|"("|")"|"["|"]"|".." addLexeme(strdup(yytext),2);

. /*Don't print*/;
%%

int main(){
    yylex();
    printValues();
}