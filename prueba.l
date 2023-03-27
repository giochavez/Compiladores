%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
FILE *yyin;
int Clase[10] = {0,1,2,3,4,5,6,7,8,9};
int contSimb = 0;

typedef struct ident{
	int *posicion;
	char *nombre;
	int *tipo;
	struct ident *sig;
}Identi;

Identi *TablaSimbolos;

%}

%option noyywrap

%option yylineno

/* Definicion de expresiones regulares */

DIGITO				[0-9]
LETRA				[a-z]
GUION_BAJO			["_"]
IDENTIFICADOR		{LETRA}({LETRA}|{DIGITO}|{GUION_BAJO})({LETRA}|{DIGITO}|{GUION_BAJO})*

PAREN_ABRE			["("]
PAREN_CIERRA		[")"]
LLAVE_ABRE			["{"]
LLAVE_CIERRA		["}"]
PUNTO_Y_COMA		[";"]
COMA				[","]
CORCHETE_ABRE		["["]
CORCHETE_CIERRA		["\]"]
SIMB_ESP			({PAREN_ABRE}|{PAREN_CIERRA}|{LLAVE_ABRE}|{LLAVE_CIERRA}|{PUNTO_Y_COMA}|{COMA}|{CORCHETE_ABRE}|{CORCHETE_CIERRA})

OP_IGUAL			["="]
OP_DIFF				["/="]
OP_MAYOR_IGUAL		[">="]
OP_MAYOR 			[">"]
OP_MENOR			["<"]
OP_MENOR_IGUAL		["<="]
OP_RELACIONAL		({OP_IGUAL}|{OP_DIFF}|{OP_MAYOR_IGUAL}|{OP_MAYOR}|{OP_MENOR}|{OP_MENOR_IGUAL})

OP_ASIG				"->"

ENT 				"ent"
FINSI				"finsi"
HAZ					"haz"
MIENTRAS			"mientras"
LARGE				"large"
PARA 				"para"
REAL 				"real"
REGRESA				"regresa"
SI 					"si"
SIMB 				"simb"
SINO 				"sino"
PALABRA_RESERVADA	({ENT}|{FINSI}|{HAZ}|{MIENTRAS}|{LARGE}|{PARA}|{REAL}|{REGRESA}|{SI}|{SIMB}|{SINO})

OP_SUMA 			["+"]
OP_RESTA			["\-"]
OP_MUL 				["*"]
OP_DIV 				["/"]
OP_MOD 				["%"]
OP_ARITMETICO		({OP_SUMA}|{OP_RESTA}|{OP_MUL}|{OP_DIV}|{OP_MOD})

DIGITO_SINCERO		[1-9]
DECIMALES			{DIGITO_SINCERO}({DIGITO})*
DIGITO_CERO 		[0]
DIGITO_OCTAL		[0-7]
OCTALES				{DIGITO_CERO}({DIGITO_OCTAL})*
DIGITO_CEROMIN		[0x]
DIGITO_CEROMAY		[0X]
LETRA_HEX			[a-fA-F]
HEXADECIMALES		({DIGITO_CEROMIN}|{DIGITO_CEROMAY})({DIGITO}|{LETRA_HEX})*
CONSTANTE_ENTERA	({DECIMALES}|{OCTALES}|{HEXADECIMALES})

CONSTANTE_CADENA	\"[^\n]*\"

CONSTANTE_CARACTER	\'.\'

PUNTO 				["."]
CONSTANTE_REAL		{DIGITO}{0,2}{PUNTO}{DIGITO}{1,2}

/* Reglas de Traduccion */

%%

{PALABRA_RESERVADA}		{printf("\n(%d,%s)\n", Clase[4], yytext);}
{OP_RELACIONAL}			{printf("\n(%d,%s)\n", Clase[2], yytext);}
{SIMB_ESP}				{printf("\n(%d,%s)\n", Clase[1], yytext);}
{OP_ASIG}				{printf("\n(%d,%s)\n", Clase[3], yytext);}
{OP_ARITMETICO}			{printf("\n(%d,%s)\n", Clase[5], yytext);}
{CONSTANTE_ENTERA}		{printf("\n(%d,%s)\n", Clase[6], yytext);}
{CONSTANTE_CADENA}		{printf("\n(%d,%s)\n", Clase[7], yytext);}
{CONSTANTE_CARACTER}	{printf("\n(%d,%s)\n", Clase[8], yytext);}
{CONSTANTE_REAL}		{printf("\n(%d,%s)\n", Clase[9], yytext);}
{IDENTIFICADOR}			{printf("\n(%d,%s)\n", Clase[0], yytext);}

"\n"
"\t"
" "
.						yyerror();

%%

/* Definicion de funciones */

int main(int argc, char *argv[]){
	TablaSimbolos = TablaSim(TablaSimbolos);
	if((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se abrio correctamente el archivo: %s\n", argv[1]);
		return 1;
	}
	else{
		printf("\nEl archivo %s se abrio correctamnete\n", argv[1]);
		printf("\nTOKENS:\n");
		yylex();
	}
	printf("\nFLEX finalizó con la lectura del archivo %s\n", argv[1]);
	fclose(yyin);
	return  0;
}

/* Funciones para la creacion y modificacion de la Tabla
	de simbolos */

Identi *TablaSim(Identi *Tabla){
	Tabla = NULL;
	return Tabla;
}

void yyerror(void){
	printf("\nError lexico encontrado: %s\n", yytext);
	printf("\nContinuando con el analisis\n");
}