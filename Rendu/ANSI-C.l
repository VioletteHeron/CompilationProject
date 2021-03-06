%{

#include "simple.h"
unsigned int lineno=1;
bool error_lexical=false;

%}

%option noyywrap

nombre 0|[1-9][[:digit:]]*
variable_booleenne bool(_|[[:alnum:]])*
variable_arithmetique ([[:alnum:]])*
%x  commentaire_1
%%
"/*"    {
            /* un marqueur de debut de commentaire trouve -> on lui dit que le lexeme commentaire_1 commence */
            BEGIN(commentaire_1);
            printf("Commentaire detecte en ligne %i\n",lineno);
        }
 
<commentaire_1>"\n"     {
                            /* si on trouve des retours chariots et que la condition de demarrage est commentaire_1, alors on incremente la variable lineno. sans cela, on serait en decalage pour la suite de l'analyse */
                            lineno++;
                        }
 
<commentaire_1>"*"+"/"      {
                                /* si on au moins une fois "*" suivi de "/" et que la condition de demarrage est commentaire_1, alors on lui dit que le lexeme commentaire_1 est fini */
                                BEGIN(INITIAL);
                                printf("Fin du commentaire en ligne %i\n",lineno);
                                return TOK_COMMENT;
                            }
 
<commentaire_1>.    {/* les autres caracteres suivants la conditions de demarrage sont absorbes par l'analyse est donc ingores */}
{nombre} {
    sscanf(yytext, "%ld", &yylval.nombre);
    return TOK_NOMBRE;
}
"for"		{return TOK_FOR;}

"while"		{return TOK_WHILE;}

"if"    	{return TOK_SI;}
     
"alors" 	{return TOK_ALORS;}
     
"else" 		{return TOK_SINON;}

"=="        	{return TOK_EQU;}

"!="           	{return TOK_DIFF;}

">"  		{return TOK_SUP;}

"<"  		{return TOK_INF;}

"default"	{return TOK_DEFAULT;}

">="          	{return TOK_SUPEQU;}

"<="          	{return TOK_INFEQU;}

"switch"	{return TOK_SWITCH;}

"case"		{return TOK_CASE ;}

"int"         	{ return TOK_TYPEINT ; }

"printd"      {return TOK_AFFICHER;}

"="             {return TOK_AFFECT;}

"+"             {return TOK_PLUS;}

"-"             {return TOK_MOINS;}

"*"             {return TOK_MUL;}

"/"             {return TOK_DIV;}

"("             {return TOK_PARG;}

")"             {return TOK_PARD;}

"{"             {return TOK_ACCOG;}

"}"             {return TOK_ACCOD;}

"["             {return TOK_CROG;}

"]"             {return TOK_CROD;}

"et"            {return TOK_ET;}

"ou"            {return TOK_OU;}

"non"           {return TOK_NON;}

";"             {return TOK_FINSTR;}

","             {return TOK_VIRGULE;}

"vrai"          {return TOK_VRAI;}

"faux"          {return TOK_FAUX;}

"main"          {return TOK_MAIN;}

"return"        {return TOK_RET;}

"extern"        {return TOK_EXT;}

"break"         {return TOK_BRK;}

">>"        	{return TOK_DECD;}

"<<"       	{return TOK_DECG;}

"\n"            {lineno++;}

{variable_booleenne} {
    yylval.texte = yytext;
    return TOK_VARB;
}


{variable_arithmetique} {
    yylval.texte = yytext;
    return TOK_VARE;
}

" "|"\t" {}

. {
    fprintf(stderr,"\tERREUR : Lexeme inconnu a la ligne %d. Il s'agit de %s et comporte %d lettre(s)\n",lineno,yytext,yyleng);
    error_lexical=true;
    return yytext[0];
}

%%
