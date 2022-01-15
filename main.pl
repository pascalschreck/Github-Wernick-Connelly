/*

main.pl

*/

/* syntactic definitions:

a rule has the form
    if something and something ... then [ do this, do this ....].
    where
    something := fact | fact as Var | equivalenceStep
    do this   := change fact by fact
    fact      :=   a | b | c | o | m(a) | .... | n
                 | perpend/4 
                 | collinear/3
                 | onAngleBisector/4
                 | onPerpendBisector/3
    point      := point - point | 2*point

*/
:-op(800, fx, if).
:-op(810, xfx, then).
:-op(710, xfy, and).
:-op(705, fx, change).
:-op(700, xfx, [by, among, is_not, are_not]).
:-op(690, xf, stated).

:-dynamic([
	    perpend/4,
	    collinear/3,
	    onAngleBisector/4,
	    onPerpendBisector/3,
	    egx/2,
	    egy/2,
	    midpointx/3,
	    midpointy/3,
	    isobarx/4,
	    isobary/4,
	    a/0, b/0, c/0, o/0,
	    m/1, g/0,
	    h/1, h/0,
	    t/1, i/0,
	    e/1, n/0,
	    changed/3
	    ]).

:- [                       /* loading the files of the project                     */
    iw,                    /* iw.pl    : tools for reading a file (winput)         */
    ow,                    /* ow.pl    : tools for writing equations in a file     */
    rules                  /* rules.pl :rules + inf. engine                        */
    ].
                /* in iw.pl for the moment                              */

:- init.

go :- go(1).

go(N) :- write(woutput,'problem C'),writeln(woutput,N),
	 oneTreatment, !, 
	writeln(woutput,'------------------------------------------'),
	NN is N+1, go(NN).
go(_).

oneTreatment :- 
     getStatement,    /*  * set up the database with the predefinite equation system */
     apply,           /*  * simplify it using the rules                              */
     writeStatement,  /*  * write the simplified system in a file                    */
     clearStatement.  /*  * clear the constraints                                    */
    
:- go, halt.
