/*

rules.pl

*/




/*--------------------------------------------
              pieces of knowledge  
h(a) means Ha
h    means H
a    means A
m(a) means Ma
and so on
-------------------------------------------*/

vertices(a,b,c).
vertices(a,c,b).
vertices(b,c,a).
vertices(b,a,c).
vertices(c,a,b).
vertices(c,b,a).

point(a).     point(b).     point(c).     point(o).
point(m(a)).  point(m(b)).  point(m(c)).  point(g).
point(h(a)).  point(h(b)).  point(h(c)).  point(h).
point(t(a)).  point(t(b)).  point(t(c)).  point(i).
point(e(a)).  point(e(b)).  point(e(c)).  point(n).

/*----------------------------------------------------------

           rules
           
           
-------------------------------------------------------------*/
/*-----------------------------------------------------------
 *  
 *  0- ponctual reductions: they consists in replacing some
 *     points by other points. Usually they estabish classes 
 *     of equivalent problems and correspond to geometric 
 *     theorems on the form P1 = f_1(P2, P3)
 *      ** G, H, O, N
 *      ** Ex, N, Mx
 *      ** y Mx z
 *      ** x G Mx
 *      ** x Ex H
 *     these rules should be applied before setting up equations 
 *     since they only change the triple of points
 * 
 *  1- locus reduction: here an equation is transformed into 
 *     another using the fact that 2 lines are equals (for 
 *     instance x I and x Tx). it could also be possible to
 *     use cocyclicity but more points are involved (Euler's circle).
 *     For instance: onAngleBisector(P, A, B, C) could be replaced
 *     by onAngleBisector(P, A, Hb, B)if Hb is known.
 *     collinearity (that are not related to exact positions)
 *      ** x H Hx
 *      ** y Mx Hx Tx z
 *      ** x I Tx
 *      ** 
 * 
 * 2- configuration reduction: use a particular configuration to
 *    replace a complicated equation by a simpler one (collinearity).
 *    For instance: if H and Ha are given, the equation about perp.
 *    of lines AHa and BC can be moved into collinearity of A H and Ha 
 * 
 * 3- others
 * 
 * ----------------------------------------------------------*/

/* Rules O */
if
      equivalenceStep and
      g and m(X) 
then
    [
      change m(X) by X
    ].
    

if
      equivalenceStep and
      h and e(X)
then
    [
      change e(X) by X
    ].
    
if
      equivalenceStep and
      n and e(X)
then
    [
      change e(X) by m(X)
    ].


if 
      equivalenceStep and
      [P1,P2] stated among [o, g, n, h] and
      [P1,P2] are_not [o,g]
then
    [
      change P1 by g,
      change P2 by o
    ].


 
/*  Rules I 
2- locus reduction: here an equation is transformed into 
 *     another using the fact that 2 lines are equals (for 
 *     instance x I and x Tx). it could also be possible to
 *     use cocyclicity but more points are involved (Euler's circle).
 *     For instance: onAngleBisector(P, A, B, C) could be replaced
 *     by onAngleBisector(P, A, Hb, B)if Hb is known.
 *     collinearity (that are not related to exact positions)
 *      ** x H Hx
 *      ** y Mx Hx Tx z
 *      ** x I Tx
 *      ** 
--------------------------------------------------------------------------*/
if 
      vertices(X,Y,Z) and 
      h and h(X) and 
      perpend(X,h(X),Y, Z) as F
then 
    [
      change F by collinear(X, h, h(X))
    ].

      
if 
      vertices(X,Y,Z) and 
      h(X) and e(X) and 
      perpend(X,h(X),Y, Z) as F
then [
      change F by collinear(X, h(X), e(X))
      ].      

      
if 
      vertices(X,Y,Z) and 
      i and t(X) and 
      onAngleBisector(t(X), X, Y, Z) as F
then [
      change F by collinear(X, i, t(X))
      ].

      
/***

recent additions

***/
if 
      vertices(X,Y,Z) and 
      t(X) and t(Y) and 
      onAngleBisector(t(X), X, Y, Z) as F
then [
      change F by onAngleBisector(t(X), X, Y, t(Y))
      ].
      
if 
      vertices(X,Y,Z) and 
      t(X) and t(Z) and 
      onAngleBisector(t(X), X, Y, Z) as F
then [
      change F by onAngleBisector(t(X), X, t(Z), Z)
      ].


if 
      vertices(X,Y,Z) and 
      t(X) and m(Y) and 
      onAngleBisector(t(X), X, Y, Z) as F
then [
      change F by onAngleBisector(t(X), X, Y, m(Y))
      ].
      
if 
      vertices(X,Y,Z) and 
      t(X) and m(Z) and 
      onAngleBisector(t(X), X, Y, Z) as F
then [
      change F by onAngleBisector(t(X), X, m(Z), Z)
      ].
      
if 
      vertices(X,Y,Z) and 
      t(X) and h(Y) and 
      onAngleBisector(t(X), X, Y, Z) as F
then [
      change F by onAngleBisector(t(X), X, Y, h(Y))
      ].
      
if 
      vertices(X,Y,Z) and 
      t(X) and h(Z) and 
      onAngleBisector(t(X), X, Y, Z) as F
then [
      change F by onAngleBisector(t(X), X, h(Z), Z)
      ].     
      
/*
  choosing the equations for N
  if a point among h(X) and m(X) is stated then use it in the equation
  Note 1 : e(X) cannot appear since it would be replaced by m(X) by a previous rule with equivalenceStep
  Note : if two points of this kind are known then the problem is L since n shoukd be on the perpbisector of
         such points
*/
if	
	n and h(X) and
	onPerpendBisector(2*n,a+b,b+c) as F		/* note : if B appears is a statement, then A too   */
then
    [
	change F by onPerpendBisector(2*n,a+b,2*h(X))
    ].

/* ajout 20 juillet 2016   */
if	
	n and m(a) and
	onPerpendBisector(2*n,a+b,b+c) as F	
then
    [
	change F by onPerpendBisector(2*n,a+b,2*m(a))
    ].

if	
	n and m(b) and
	onPerpendBisector(2*n,a+b,a+c) as F	
then
    [
	change F by onPerpendBisector(2*n,a+b,2*m(b))
    ].
    
if	
	n and m(c)
	and onPerpendBisector(2*n,a+b,b+c) as F1	
	and onPerpendBisector(2*n,a+b,a+c) as F2
then
    [
	change F1 by onPerpendBisector(2*n,b+c,2*m(c)),
	change F2 by onPerpendBisector(2*n,a+c,2*m(c))
    ].
  
/*----fin de l'ajout 20 juillet 2016 ----*/

if
	vertices(X,Y,Z) and
	e(X) and h(Y) 
	/* and perpend(X,2*e(X)-X,_,_) as F1     */
	and [P] among [Y,Z] and
        perpend(P,2*e(X)-X,_,_) as F2
then
    [
	/* change F1 by onPerpendBisector(e(X),X,h(Y)), */
	/* the factabove seems redundant                */
	change F2 by collinear(2*e(X)-X, h(Y), Y)
    ]. 


if
	vertices(X,Y,Z) and
	e(X) and o and
	perpend(X,2*e(X)-X,_,_) as F1 and    
	[P] among [Y,Z] and
        perpend(P,2*e(X)-X,_,_) as F2
then
    [
	change F1 by egx(midpoint(Y+Z,2*X), midpoint(2*e(X),2*o)),
	change F2 by egy(midpoint(Y+Z,2*X), midpoint(2*e(X),2*o))
    ].

/* Rules II */

if 
    vertices(X,Y,Z) and 
    h(X) and t(X) and 
    collinear(Y,t(X),Z) as F1 and
    collinear(Y,h(X),Z) as F2
then [
       change F1 by collinear(h(X),Y,t(X)),
       change F2 by collinear(h(X),Z,t(X))
     ].
 
 if 
    vertices(X,Y,Z) and 
    h(X) and m(X) and 
    collinear(Y,h(X),Z) as F1 
then [
       change F1 by collinear(h(X),Y,m(X))
     ].
 
 if 
    vertices(X,Y,Z) and 
    t(X) and m(X) and 
    collinear(Y,t(X),Z) as F1 
then [
       change F1 by collinear(t(X),Y,m(X))
     ].
 

/* Rules III */

/*
specific rule for generating equations for i when m(X) or t(X) or h(X) is stated
Remark : the variable order should be then X,Z,Y
*/

if  
    [P] stated among [m(X), t(X), h(X)] and 
    vertices(X,Y,Z) and
    onAngleBisector(i, a, b, c) as F1 and
    onAngleBisector(i, b, c, a) as F2
then [
       change F1 by onAngleBisector(i, Y, X, P),
       change F2 by onAngleBisector(i, Z, X, P)
      ].


 

 if  
    e(X) and e(Y) and
    perpend(Y,2*e(X)-X,_,X) as F1              /* _ for Z */
then [
       change F1 by collinear(2*e(X)-X,e(Y),Y)
      ].

 if  
    e(X) and e(Y) and
    perpend(_,2*e(X)-X,Y,X) as F1           /* _ for Z  */
then [
       change F1 by collinear(2*e(X)-X,e(Y),Y)
      ].
 /*
 collinear(2*e(A)-A,h(B),B),onlineE(XEAo,YEAo, XHBo, YHBo, XAo, YAo, XBo, YBo)
 */
 
 
/*-------------------------------------- 
inference engine (very simple)
----------------------------------------*/

apply :- if P then G,
         handleLP(P),
         doLG(G),
         /* marked as changed if success */
         fassert(changed(_,P,G)),
         apply.
apply.

handleLP(P) :- not(P = (_ and _)), handleP(P).
handleLP(P and Lp) :- handleP(P), handleLP(Lp).

handleP(T as F) :- call(T), F=T.
handleP(T) :- not(T = (_ as _)), call(T).

doLG([]).
doLG([G|Lg]) :- doG(G), doLG(Lg).

doG(change T by Tb) :- retract(T), assert(Tb).

fassert(changed(_,_,_)) :- changed(equation,_,_), ! .
fassert(changed(_,_,_)) :- changed(equation+equiv,_,_), ! .

fassert(changed(equivalence,P,G)) :- equivalenceStep,
                                    (
                                    changed(_,_,_), !
                                    ; 
                                    assert(changed(equivalence, P,G))
                                    ).

fassert(changed(equation,P,G)) :- 
        not(equivalenceStep),
        (
        changed(equivalence,_,_), !, retract(changed(equivalence,_,_)), assert(changed(equation+equiv,P,G))  
        ;
        assert(changed(equation,P,G))
        ).

L stated among Lp :- L stated, subset(L,Lp).
L among Lp :- not(L = (_ stated)), subset(L,Lp).

[] stated :- write('*************** weird*****************').
[P] stated :- point(P), P.
[P1, P2] stated :- point(P1), P1, point(P2),P2, P1 \== P2.
[P1, P2, P3] stated :- point(P1), P1, point(P2), P2, P1\==P2, point(P3), P3, P3 \== P1, P3\==P2.


P is_not Q :- P \== Q.
L are_not Lp :- not(subset(L,Lp)).
/*------------end engine------------*/
