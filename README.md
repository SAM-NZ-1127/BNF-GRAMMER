# BNF-GRAMMER

modify the following BNF grammar to resolve
the ambiguity due to operator precedence and associativity.
<e> ::= <e> + <e>
| <e> - <e>
| <e> * <e>
| <e> / <e>
| <e> && <e>
| <e> || <e>
| <e> > <e>
| <e> < <e>
| <e> == <e>
| ! <e>
| - <e>
| ( <e> )
| <NUMBER>
Note that your grammars do not consider white spaces and <NUMBER> is a
non-terminal that refers to numbers.
1 Requirement
1. The new grammar should have precedence as shown below, where the
operators in the lower lines have higher precedence.
&&, ||
==, <, >
+, -
*, /
- (unary), !
2. The new grammar should enforce left associativity for all binary operators.
3. Please verify the new grammar using jison. To use jison, go to the
website https://github.com/zaach/jison download examples and in-
stall the source code using npm. Note that you should install node.js
first, which comes with npm.
1
I have provided a jison source file called hwk2.jison, which can be tested:
jison hwk2.jison
node hwk2.js test.txt
where test.txt is a plain text file with only the content:
1 + 2 + (3 - 4) * -5 / 6 < 7 && !(8 > 9) || 10 == 11
The execution result is
(((((1 + 2) + ((((3 - 4)) * (-5)) / 6)) < 7) && (!((8 > 9)))) || (10 == 11))
where the parenthesises correspond to the shape of the parse tree.
The relevant portion of the jison input is shown below.
e : e ’+’ e
{$$ = ’(’ + $1 + ’ + ’ + $3 + ’)’;}
| e ’-’ e
{$$ = ’(’ + $1 + ’ - ’ + $3 + ’)’;}
| e ’*’ e
{$$ = ’(’ + $1 + ’ * ’ + $3 + ’)’;}
| e ’/’ e
{$$ = ’(’ + $1 + ’ / ’ + $3 + ’)’;}
| e ’==’ e
{$$ = ’(’ + $1 + ’ == ’ + $3 + ’)’;}
| e ’>’ e
{$$ = ’(’ + $1 + ’ > ’ + $3 + ’)’;}
| e ’<’ e
{$$ = ’(’ + $1 + ’ < ’ + $3 + ’)’;}
| e ’&&’ e
{$$ = ’(’ + $1 + ’ && ’ + $3 + ’)’;}
| e ’||’ e
{$$ = ’(’ + $1 + ’ || ’ + $3 + ’)’;}
| ’!’ e
{$$ = ’(’ + ’!’ + $2 + ’)’;}
| ’-’ e %prec UMINUS
{$$ = ’(-’ + $2 + ’)’;}
| ’(’ e ’)’
{$$ = ’(’ + $2 + ’)’;}
| NUMBER
{$$ = Number(yytext);}
;
You do not need to modify the lines enclosed by { and }, which are used
to generate the output. Note that this jison file is not ambiguous be-
cause the following lines above the production rules, which establishes the
precedence and associativity.
2
%left ’&&’ ’||’
%left ’>’ ’<’ ’==’
%left ’+’ ’-’
%left ’*’ ’/’
%left UMINUS ’!’
You should delete them from your jison file. After deleting these lines,
if you run jison hwk2.jison, you will get errors that say the grammar
is ambiguous for parsing. You should add non-terminals to resolve the
ambiguity. In particular, you should add non-terminals called
(a) RootExp to represent any expression that does not include operators
except when they are enclosed by parenthesis,
(b) NegExp to represent arithmetic and logical negation expression,
(c) MulExp to represent multiplication and division.
(d) PlusExp to represent addition and subtraction.
(e) CompExp to represent comparison expressions.
For example, below is an unambiguous grammar for expressions with plus
and times.
e
: e ’+’ MulExp
{$$ = ’(’ + $1 + ’ + ’ + $3 + ’)’;}
| MulExp
{$$ = $1;}
;
MulExp
: MulExp ’*’ RootExp
{$$ = ’(’ + $1 + ’ * ’ + $3 + ’)’;}
| RootExp
{$$ = $1;}
;
RootExp
: ’(’ e ’)’
{$$ = ’(’ + $2 + ’)’;}
| NUMBER
{$$ = Number(yytext);}
;
Note that $$ refers to the variable that holds the value of the non-terminal
on the left-hand-side of the production rule while $1, $2, $3 refer to the
first, second, and third non-terminal or token appearing on the right-hand-
side of the production rule. If your implementation is correct, you should
get the same output as you do with the original hwk2.jison.
3
4. The new grammar should not include %prec UMINUS.
