/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
">"                   return '>'
"<"                   return '<'
"=="                  return '=='
"("                   return '('
")"                   return ')'
"&&"                  return '&&'
"||"                  return '||'
"!"                   return '!'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%start expressions

%% /* language grammar */

expressions
    : e EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

e
    : e '||' CompExp
        {$$ = '(' + $1 + ' || ' + $3 + ')';}
    | e '&&' CompExp
        {$$ = '(' + $1 + ' && ' + $3 + ')';}
    | CompExp
        {$$ = $1;}
    ;

CompExp
    : CompExp '==' PlusExp
        {$$ = '(' + $1 + ' == ' + $3 + ')';}
    | CompExp '>' PlusExp
        {$$ = '(' + $1 + ' > ' + $3 + ')';}
    | CompExp '<' PlusExp
        {$$ = '(' + $1 + ' < ' + $3 + ')';}
    | PlusExp
        {$$ = $1;}
    ;

PlusExp
    : PlusExp '+' MulExp
        {$$ = '(' + $1 + ' + ' + $3 + ')';}
    | PlusExp '-' MulExp
        {$$ = '(' + $1 + ' - ' + $3 + ')';}
    | MulExp
        {$$ = $1;}
    ;
    
MulExp
    : MulExp '*' NegExp
        {$$ = '(' + $1 + ' * ' + $3 + ')';}
    | MulExp '/' NegExp
        {$$ = '(' + $1 + ' / ' + $3 + ')';}
    | NegExp
        {$$ = $1;}
    ;

NegExp
    : '-' RootExp
        {$$ = '(-' + $2 + ')';}
    | '!' RootExp
        {$$ = '(!' + $2 + ')';}
    | RootExp
        {$$ = $1;}
    ;

RootExp
    : '(' e ')'
        {$$ = '(' + $2 + ')';}
    | NUMBER
        {$$ = Number(yytext);}
    ;