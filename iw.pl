/*

    iw.pl 
    for reading and writing statement of Wernick and Connelly corpora
    
*/


reinit :- is_stream(winput), seek(winput,0,bof,_).

init :- open(wproblems,read,_,[alias(winput)]),open(woutput,write,_,[alias(woutput)]).


getStatement :- read_statement(L), translateL(L), setUpStatement.

    
translateL([]).
translateL([P|Lp]) :- translate(P),translateL(Lp).

translate('A') :- (a,!; assert(a)), assert(tbt(a)).
translate('B') :- (b,!; assert(b)), assert(tbt(b)).
translate('C') :- (c,!;assert(c)), assert(tbt(c)).

translate('O') :- (o,!;assert(o)), assert(tbt(o)).

translate('Ma') :- (m(a),!;assert(m(a))), assert(tbt(m(a))).
                   
translate('Mb') :- (m(b),!;assert(m(b))), assert(tbt(m(b))).
                                      
translate('Mc') :- (m(c),!;assert(m(c))), assert(tbt(m(c))).
                   
translate('G') :- (g,!;assert(g)), assert(tbt(g)).
                   
translate('Ha') :- (h(a),!;assert(h(a))), assert(tbt(h(a))).
                   
translate('Hb') :- (h(b),!;assert(h(b))), assert(tbt(h(b))).
                   
translate('Hc') :- (h(c),!;assert(h(c))), assert(tbt(h(c))).

translate('H') :- (h,!;assert(h)), assert(tbt(h)).

translate('Ta') :- (t(a),!;assert(t(a))), assert(tbt(t(a))).

translate('Tb') :- (t(b),!;assert(t(b))), assert(tbt(t(b))).

translate('Tc') :- (t(c),!;assert(t(c))), assert(tbt(t(c))).   
                   
translate('I') :- (i,!;assert(i)), assert(tbt(i)).

translate('Ea') :- (e(a),!;assert(e(a))), assert(tbt(e(a))).

translate('Eb') :- (e(b),!;assert(e(b))), assert(tbt(e(b))).

translate('Ec') :- (e(c),!;assert(e(c))), assert(tbt(e(c))).

translate('N') :- (n,!;assert(n)), assert(tbt(n)).
                
translate(X) :-write('non lu : '),  write(X), nl.
       
       
/*-----------------------------------------------------------------------------------
setUpStatement :-  statementRet([P1,P2,P3]), 
		   assert(equivalenceStep),
		   equivStat([P1,P2,P3],[Q1,Q2,Q3]),
                   retract(P1), retract(P2), retract(P3),
                   retract(equivalenceStep),
                   assert(Q1), assert(Q2), assert(Q3),
                   translateE(Q1), translateE(Q2),translateE(Q3).
--------------------------------------------------------------------------------------*/
                /* trouver l'énoncé équivalent le plus simple */
                /* faire le système d'équations statique adéquat pour e(x) et n */
                
/* main predicate :
statementRet(L) :- setof(X,tbt(X), L), (repeat (retract(tbt(_)), fail; true)), !.

simplifié ici en
*/

statementRet([P1,P2,P3]) :- retract(tbt(P1)), retract(tbt(P2)), retract(tbt(P3)).
statementRet([]).


/*
equivStat(Li,[o,g,P3]) :- intersection(Li,[o,g,h,n], [P1,P2]), substract(Li,[P1,P2],[P3]),!.
equivStat(Li,[m(X),n, P3]) :- not(member(h,Li)), member(e(X),Li), member(n, li), 
                              substract(Li,[e(X),n],[P3]),!.


equivStat([P1,P2,P3],[P1,P2,P3]). /* clause par défaut */
*/

setUpStatement :- assert(equivalenceStep), 
		  apply, 
		  retract(equivalenceStep),
		  eqStep.
		  
eqStep :- setof(X, (point(X), X), L), translateEl(L).

translateEl([]).
translateEl([P|L]) :- translateE(P), translateEl(L). 

translateE(a) :- assert(egx(a,a)), assert(egy(a,a)).
translateE(b) :- assert(egx(b,b)), assert(egy(b,b)).
translateE(c) :- assert(egx(c,c)), assert(egy(c,c)).

translateE(o) :-
                   assert(onPerpendBisector(o, a, b)), 
                   assert(onPerpendBisector(o, a, c)).

translateE(m(a)) :-
                   assert(midpointx(m(a),b,c)), 
                   assert(midpointy(m(a),b,c)).
                   
translateE(m(b)) :- 
                   assert(midpointx(m(b),c,a)), 
                   assert(midpointy(m(b),c,a)).
                   
translateE(m(c)) :- 
                   assert(midpointx(m(c),a,b)), 
                   assert(midpointy(m(c),a,b)).
                   
translateE(g) :- 
                   assert(isobarx(g, a, b, c)), 
                   assert(isobary(g, a, b, c)).
                   
translateE(h(a)) :- 
                   assert(perpend(a,h(a), b, c)), 
                   assert(collinear(b, h(a), c)).
                   
translateE(h(b)) :- 
                   assert(perpend(b,h(b), a, c)), 
                   assert(collinear(a, h(b),c)).
                   
translateE(h(c)) :- 
                   assert(perpend(c,h(c), a, b)), 
                   assert(collinear(a, h(c), b)).

translateE(h) :- 
                   assert(perpend(a, h, b, c)), 
                   assert(perpend(b, h, a, c)). 

translateE(t(a)) :- 
                   assert(onAngleBisector(t(a), a, b, c)), 
                   assert(collinear(b, t(a), c)).

translateE(t(b)) :- 
                   assert(onAngleBisector(t(b), b , c, a)), 
                   assert(collinear(a, t(b), c)).

translateE(t(c)) :- 
                   assert(onAngleBisector(t(c), c , a, b)), 
                   assert(collinear(a, t(c), b)).     
                   
translateE(i) :- 
                  assert(onAngleBisector(i, a, b, c)),
                  assert(onAngleBisector(i, b, c, a)).
                  
/*------------------------------------------------------------------------------*
*    for the new points integrated in Connely corpus
*    it is more difficult to put a "static" or "absolute" definition
*    for the following points.
*    For instance, 
*     * if nor h, nor hx nor hy nor hz are given the following
*                   definition for Ea (resp. Eb or Ec) is neutral since it
*                   "re"-define h. But if h is given, the definition should
*                   be e(a) = midpoint(a,h)
*     * n is the circumcenter of the nine point circle ... here we chose three
*       of them. They seem to be the simplest ones, but if say h(a) is given
*       it would be better to use it !
*
*-------------------------------------------------------------------------------*/
 

translateE(e(a)) :- 				      /* not(h) is assumed at this stage    	*/
	          assert(perpend(a,2*e(a)-a,b,c)),    /* 2*e(a)-a = h                         	*/
                  assert(perpend(b,2*e(a)-a,c,a)).



translateE(e(b)) :- 				      /* not(h) is assumed			*/
                  assert(perpend(b,2*e(b)-b,c,a)),
                  assert(perpend(c,2*e(b)-b,a,b)).
                  

translateE(e(c)) :- 				      /* not(h),				*/
                  assert(perpend(c,2*e(c)-c,a,b)),
                  assert(perpend(a,2*e(c)-c,b,c)).
                  

translateE(n) :- 
                  assert(onPerpendBisector(2*n,a+b,a+c)),   /* circumcenter of m(a)m(b)m(c)     */
                  assert(onPerpendBisector(2*n,a+b,b+c)).   



/*------------------------------------------------------------------*
*       read_statement : low-level input
*       read 3 points and one status character from stream winput
*
*
*
*--------------------------------------------------------------------*/
                  
read_statement(L) :- read_point(P1), 
                    P1 \== end_of_file,
                     read_point(P2),
                     P2 \== end_of_file,
                     read_point(P3), 
                     P3 \== end_of_file,
                     read_stat(S),
                     S \== end_of_file,
                     L=[P1,P2,P3,S]
                     .
read_statement([]).

read_point(M) :- elimSp(C), 
                C \== -1,
                 get0(winput,C2), 
                C2 \== -1,
                 (C2==32,!, name(M,[C])
                ; 
                  name(M,[C,C2])).

read_point(end_of_file).

read_stat(S) :- elimSp(C), C \== -1, (C==10, !, S = 'X' ; name(S,[C]), !, elimSp(10)).

read_stat(end_of_file).

elimSp(C) :- repeat, get0(winput,C), C\==32, !. 


/*--------------------------------------------------------------------------*
*
*
*
*
*
*----------------------------------------------------------------------------*/
