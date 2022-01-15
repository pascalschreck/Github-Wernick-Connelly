/*

    ow.pl 
    for writing statement of Wernick and Connelly corpora into the form 
    of equation system
    
*/

/* tools */

displayStatement :- 
		write('*** original statement :'), nl,
		(statementRet([P1,P2,P3]), write(P1), write(' '), write(P2), write(' '), write(P3) ; true), nl,
		write('*** equivalent statement : '), nl,
		dpl([a,b,c,o, m(a), m(b), m(c), g, h(a), h(b), h(c), h, t(a), t(b), t(c), i, e(a), e(b), e(c), n]),
		nl, write('*** equations '), nl,
		eqDisplayl([ 
			  egx/2,
			  egy/2,
			  midpointx/3,
			  midpointy/3,
			  isobarx/4,
			  isobary/4,
			  perpend/4,
			  collinear/3,
			  onAngleBisector/4,
			  onPerpendBisector/3  
			  ]).
	
dp(X) :- X, write(X), write(' '); true.
dpl([]).
dpl([X|L]) :- dp(X), dpl(L).

eqDisplayl([]).
eqDisplayl([P|L]) :- eqDisplay(P), eqDisplayl(L).

eqDisplay(P/N) :- mkList(N, Args), T =..[P|Args], !, searchAndDisplay(T).

searchAndDisplay(T) :- T, write(T),nl, fail.
searchAndDisplay(_).


displayStatement(Out) :- 
		write(Out,'*** original statement :'), nl(Out),
		(statementRet([P1,P2,P3]), write(Out,P1), write(Out,' '), write(Out,P2), write(Out,' '), write(Out,P3) ; true), 
		nl(Out),
		write(Out,'*** equivalent statement : '), nl(Out),
		dpl(Out,[a,b,c,o, m(a), m(b), m(c), g, h(a), h(b), h(c), h, t(a), t(b), t(c), i, e(a), e(b), e(c), n]),
		nl(Out),
		(changed(E,P,G), write(Out,changed(E,P,G)) ; not(changed(_,_,_)), write(Out,'unchanged')),
		nl(Out), write(Out,'*** equations '), nl(Out),
		eqDisplayl(Out,
		         [ 
			  egx/2,
			  egy/2,
			  midpointx/3,
			  midpointy/3,
			  isobarx/4,
			  isobary/4,
			  perpend/4,
			  collinear/3,
			  onAngleBisector/4,
			  onPerpendBisector/3  
			  ]).
	
dp(Out,X) :- X, equivO(X,Xo), write(Out,Xo), write(Out,' '); true.
dpl(_,[]).
dpl(Out,[X|L]) :- dp(Out,X), dpl(Out,L).

eqDisplayl(_,[]).
eqDisplayl(Out,[P|L]) :- eqDisplay(Out,P), eqDisplayl(Out,L).

eqDisplay(Out,P/N) :- mkList(N, Args), T =..[P|Args], !, searchAndDisplay(Out,T).

mkList(N,[]) :- N =< 0.
mkList(N,[_|L]) :- NN is N-1, mkList(NN,L).

searchAndDisplay(Out,T) :- T, translateO(T,To), write(Out,To),nl(Out), fail.
searchAndDisplay(_,_).


listingl([]).
listingl([P|L]) :- listing(P), listingl(L).

retractStatement :-
    pointRetractl([a,b,c,o, m(a), m(b), m(c), g, h(a), h(b), h(c), h, t(a), t(b), t(c), i, e(a), e(b), e(c), n]),
    statementRet(_),
    eqRetractl([ 
			  egx/2,
			  egy/2,
			  midpointx/3,
			  midpointy/3,
			  isobarx/4,
			  isobary/4,
			  perpend/4,
			  collinear/3,
			  onAngleBisector/4,
			  onPerpendBisector/3,
			  changed/3
		]
		).

pointRetractS(X) :- retractall(X);true.

pointRetractl([]).
pointRetractl([X|L]) :- pointRetractS(X), pointRetractl(L).

eqRetractl([]).
eqRetractl([P|L]) :- eqRetractS(P), eqRetractl(L).

eqRetractS(P/N) :- mkList(N, Args), T =..[P|Args], !, (retractall(T); true).



equivO(h(a),'Ha'):-!.
equivO(h(b),'Hb'):-!.
equivO(h(c),'Hc'):-!.
equivO(m(a),'Ma'):-!.
equivO(m(b),'Mb'):-!.
equivO(m(c),'Mc'):-!.
equivO(t(a),'Ta'):-!.
equivO(t(b),'Tb'):-!.
equivO(t(c),'Tc'):-!.
equivO(e(a),'Ea'):-!.
equivO(e(b),'Eb'):-!.
equivO(e(c),'Ec'):-!.
equivO(a,'A'):-!.
equivO(b,'B'):-!.
equivO(c,'C'):-!.
equivO(o,'O'):-!.
equivO(g,'G'):-!.
equivO(i,'I'):-!.
equivO(n,'N'):-!.
equivO(h,'H'):-!.
/* equivO(N,N) :- write('**** Warning (equiv0) : '), write(N), nl. */


translateO(egx(a,a),'A1'(xA,yA)):- !.
translateO(egx(b,b),'B1'(xB,yB)):- !.
translateO(egx(c,c),'C1'(xC,yC)):- !.
translateO(egy(a,a),'A2'(xA,yA)):- !.
translateO(egy(b,b),'B2'(xB,yB)):- !.
translateO(egy(c,c),'C2'(xC,yC)):- !.
translateO(midpointx(M,P1,P2), midp1(XMo,YMo,XP1o,YP1o,XP2o,YP2o)):- 
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),!.
translateO(midpointy(M,P1,P2), midp2(XMo,YMo,XP1o,YP1o,XP2o,YP2o)):- 
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),!.	
translateO(onPerpendBisector(M,P1,P2),onmed(XMo,YMo,XP1o,YP1o,XP2o,YP2o)):-
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),!.	
translateO(isobarx(M,P1,P2,P3),ibar1(XMo,YMo,XP1o,YP1o,XP2o,YP2o,XP3o,YP3o)):-
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),
	equivO(P3,P3o), coord(P3o,XP3o,YP3o),!.	
translateO(isobary(M,P1,P2,P3),ibar2(XMo,YMo,XP1o,YP1o,XP2o,YP2o,XP3o,YP3o)):-
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),
	equivO(P3,P3o), coord(P3o,XP3o,YP3o),!.		
translateO(perpend(M,P1,P2,P3),perpend(XMo,YMo,XP1o,YP1o,XP2o,YP2o,XP3o,YP3o)):-
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),
	equivO(P3,P3o), coord(P3o,XP3o,YP3o),!.	
translateO(collinear(M,P1,P2),onLine(XMo,YMo,XP1o,YP1o,XP2o,YP2o)):-
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),!.	
translateO(onAngleBisector(M,P1,P2,P3),onb(XMo,YMo,XP1o,YP1o,XP2o,YP2o,XP3o,YP3o)):-
	equivO(M,Mo), coord(Mo,XMo,YMo),
	equivO(P1,P1o), coord(P1o,XP1o,YP1o),
	equivO(P2,P2o), coord(P2o,XP2o,YP2o),
	equivO(P3,P3o), coord(P3o,XP3o,YP3o),!.
/* specific cases */
/* definition of N */
translateO(onPerpendBisector(2*n,a+b,a+c),'N1'(xN,yN)):- !.
translateO(onPerpendBisector(2*n,a+b,b+c),'N2'(xN,yN)):- !.
/* definition of Ex */
translateO(perpend(A,2*e(A)-A,B,C),perpend(XEAo,YEAo,XAo,YAo,XBo,YBo,XCo,YCo)) :- 
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),
	equivO(C,Co), coord(Co, XCo, YCo),
	equivO(e(A),EAo), coord(EAo, XEAo, YEAo),!.

translateO(perpend(S,2*e(A)-A,B,C),perpendE(XEAo,YEAo,XSo,YSo,XAo,YAo,XBo,YBo,XCo,YCo)) :- 
	equivO(S,So), coord(So, XSo, YSo),
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),
	equivO(C,Co), coord(Co, XCo, YCo),
	equivO(e(A),EAo), coord(EAo, XEAo, YEAo),!.

/* collinear(2*e(a)-a,h(b),b) */
translateO(collinear(2*e(A)-A,h(B),B),onlineE(XEAo,YEAo, XHBo, YHBo, XAo, YAo, XBo, YBo)) :-
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),
	equivO(h(B),HBo), coord(HBo, XHBo, YHBo),
	equivO(e(A),EAo), coord(EAo, XEAo, YEAo),!.
	
translateO(collinear(2*e(A)-A,e(B),B),onlineE(XEAo,YEAo, XEBo, YEBo, XAo, YAo, XBo, YBo)) :-
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),
	equivO(e(B),EBo), coord(EBo, XEBo, YEBo),
	equivO(e(A),EAo), coord(EAo, XEAo, YEAo),!.
	
/* pour N */
translateO(onPerpendBisector(2*n,A+B,2*h(P)), onPerpendBisectorN(xN,yN,XHPo,YHPo,XAo,YAo,XBo,YBo)) :-
	equivO(h(P),HPo), coord(HPo, XHPo, YHPo),
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),!.
/* la clause suivante a été ajoutée le 20 juillet 2016 */	
translateO(onPerpendBisector(2*n,A+B,2*m(P)), onPerpendBisectorN(xN,yN,XMPo,YMPo,XAo,YAo,XBo,YBo)) :-
	equivO(m(P),MPo), coord(MPo, XMPo, YMPo),
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),!.
/* ... */
/*  egx(midpoint(b+c,2*a),midpoint(2*e(a),2*o)) */
translateO(egx(midpoint(B+C,2*A),midpoint(2*e(A),2*o)), trikX(XEAo,YEAo,xO,yO, XAo, YAo, XBo, YBo, XCo, YCo)) :-
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),
	equivO(C,Co), coord(Co, XCo, YCo),
	equivO(e(A),EAo), coord(EAo, XEAo, YEAo),!.

translateO(egy(midpoint(B+C,2*A),midpoint(2*e(A),2*o)), trikY(XEAo,YEAo,xO,yO, XAo, YAo, XBo, YBo, XCo, YCo)) :-
	equivO(A,Ao), coord(Ao, XAo, YAo),
	equivO(B,Bo), coord(Bo, XBo, YBo),
	equivO(C,Co), coord(Co, XCo, YCo),
	equivO(e(A),EAo), coord(EAo, XEAo, YEAo),!.


translateO(T,T):- write("Warning (translateO) : "), write(T), write("\n").


coord(Mo,XMo,YMo) :- atom(Mo), atom_concat(x,Mo,XMo), atom_concat(y,Mo,YMo).

/*-------------------------------------------------------------------------*
*
*
*
*
*
*----------------------------------------------------------------------------*/

writeStatement :- displayStatement(woutput), flush_output(woutput).
clearStatement :- retractStatement.
