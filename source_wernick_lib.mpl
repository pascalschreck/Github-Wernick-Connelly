Wernick := module () 
export 
	norm2, powLine, onLine, prodScalV, dotProd, onb, onmed, midp1, midp2, ibar1, ibar2, filterLsLc, mpr, perpend,
	A, B, C, Ma, Mb, Mc, Oo, Gg, Ha, Hb, Hc, Hh, Ta, Tb, Tc, Ii, Ea, Eb, Ec, Nn, xA, yA, xB, yB, xC, yC, Rw,
	Hw, Wtf, Wt, defFig, drawFig, num, A1, A2, B1, B2, 
	C1, C2, Lvar, perpendE, onlineE, onPerpendBisectorN, trikX, trikY, N1, N2, WtfVars;
 	
# 
#
#
local 
	onbaux, testnull, testSc, testSl, 
	 Ma1, Ma2, Mb1, Mb2, Mc1, Mc2, O1, O2, G1, G2, 
	Ha1, Ha2, Hb1, Hb2, Hc1, Hc2, H1, H2, Ta1, Ta2, Tb1, Tb2, Tc1, Tc2, 
	I1, I2; 

option package; 

# euclidean norm to the square of vect(ab) 
norm2 := proc (xa, ya, xb, yb)  return (xa-xb)^2+(ya-yb)^2 end proc; 

# polynomial in (x,y) associated to  line (ab)
powLine := proc (x, y, xa, ya, xb, yb)  return (x-xa)*(yb-ya)+(y-ya)*(xa-xb) end proc; 

# point (x,y) on line (ab)
onLine := proc (x, y, xa, ya, xb, yb)  return (x-xa)*(yb-ya)+(y-ya)*(xa-xb) end proc; 

#dot product 
prodScalV := proc (xU, yU, xV, yV)  return xU*xV+yU*yV end proc; 
dotProd  := proc (xU, yU, xV, yV)  return xU*xV+yU*yV end proc; 
perpend  := proc(xM,yM,xP,yP,xQ,yQ,xT,yT) return prodScalV(xP-xM,yP-yM,xT-xQ,yT-yQ) end proc;


# specific equations for Ex
# used for external input
# perpend(S,2*e(A)-A,B,C),perpendE(XEAo,YEAo,XSo,YSo,XAo,YAo,XBo,YBo,XCo,YCo)
perpendE := proc(XEA,YEA,XS,YS,XA,YA,XB,YB,XC,YC) 
		return perpend(XS, YS, 2*XEA - XA, 2*YEA - YA, XB, YB, XC, YC)
	    end proc;

# collinear(2*e(A)-A,h(B),B),onlineE(XEAo,YEAo, XHBo, YHBo, XAo, YAo, XBo, YBo)
# caution!!!! XEA, YEA, XHB and YHB should be numerical values
onlineE := proc(XEA,YEA, XHB, YHB, XA, YA, XB, YB)
		onLine(2*XEA-XA, 2*YEA-YA, XHB, YHB, XB, YB)
	   end proc;

# sepcific equation for N
# onPerpendBisector(2*n,A+B,2*h(P))
onPerpendBisectorN := proc(xN,yN,XHP,YHP,XA,YA,XB,YB)
			onmed(2*xN,2*yN, XA + XB, YA + YB, 2*XHP, 2*YHP)
		      end proc;

#specific equations for Ex
# caution!!! xO, yO, XEA, and YEA should have numeric values
# egx(midpoint(B+C,2*A),midpoint(2*e(A),2*o)), trikX(XEAo,YEAo,xO,yO, XAo, YAo, XBo, YBo, XCo, YCo)
trikX := proc(XEA,YEA,xO,yO, XA, YA, XB, YB, XC, YC)
		 XB+XC + 2*XA - (2*XEA + 2*xO)
        end proc;

trikY := proc(XEA,YEA,xO,yO, XA, YA, XB, YB, XC, YC)
		 YB+YC + 2*YA - (2*YEA + 2*yO)
        end proc;


#on bisectors (including degenerate case): auxiliary function
onbaux := proc (x, y, xS, yS, xM, yM, xN, yN) 
			return powLine(x, y, xS, yS, xM, yM)^2*norm2(xS, yS, xN, yN)
					-powLine(x, y, xS, yS, xN, yN)^2*norm2(xS, yS, xM, yM) 
		end proc; 
		
#on bisectors
onb := proc (x, y, xS, yS, xM, yM, xN, yN) 
		local q; 
		divide(onbaux(x, y, xS, yS, xM, yM, xN, yN), xM*yN-xM*yS-xN*yM+xN*yS+xS*yM-xS*yN, q); 
		return q
	  end proc; 

#on perpendicular bisector
onmed := proc (x, y, xM, yM, xN, yN) 
		   return norm2(x, y, xM, yM)-norm2(x, y, xN, yN) 
		end proc; 
# midpoint
midp1 := proc (x, y, xM, yM, xN, yN)  return 2*x-xM-xN end proc; 
midp2 := proc (x, y, xM, yM, xN, yN)  return 2*y-yM-yN end proc; 

# isobarycenter (center of gravity)
ibar1 := proc (x, y, xM, yM, xN, yN, xP, yP)  return 3*x-xM-xN-xP end proc; 
ibar2 := proc (x, y, xM, yM, xN, yN, xP, yP)  return 3*y-yM-yN-yP end proc; 

# conversion r=0 to true
testnull := proc (r) return `if`(r = 0, true, false) end proc; 

#
# filtering degenerate systems
# filter1 : check if all polynomials in SCond belongs to the ideal <Sys>
testSc := proc (Sys, SCond, R) 
			local p, c, test, r;
			test := true;
			for c in SCond while test do
				r := RegularChains[SparsePseudoRemainder](c, Sys, R); 
				test := test and testnull(r) 
			end do; 
			return test 
		end proc; 
	 
# filter2: check if one set of conditions in LScond belongs to <Sys>
testSl := proc (Sys, LScond, R) 
			local SCond, found; 
			found := false; 
			for SCond in LScond while not found do 
				found := testSc(Sys, SCond, R) 
			end do; 
			return found 
		end proc; 
		
# filter3: apply testSI to the list of systems LSys
filterLsLc := proc (LSys, LScond, R)
			local Lr, Sys; 
			Lr := [];
			for Sys in LSys do 
			   if not testSl(Sys, LScond, R) then 
				  Lr := [op(Lr), Sys] 
			   end if 
			 end do; 
			 return Lr 
		   end proc; 
#	
# printing of a system
#
mpr := proc (s)
	   local p; 
	   for p in s do 
		   printf(" ---------------------- ");
		   print(p) 
		end do 
	  end proc; 
	  
# 
# hard coded equations for each coordinate
# of the Wernick's characteristic points of a triangle
#
# point A
A1 := proc (x, y)  return xA-x end proc; 
A2 := proc (x, y)  return yA-y end proc; 

#point B
B1 := proc (x, y)  return xB-x end proc; 
B2 := proc (x, y)  return yB-y end proc; 

#point C
C1 := proc (x, y)  return xC-x end proc; 
C2 := proc (x, y)  return yC-y end proc; 

#midpoint of [BC]
Ma1 := proc (xMa, yMa)  return midp1(xMa, yMa, xB, yB, xC, yC) end proc; 
Ma2 := proc (xMa, yMa)  return midp2(xMa, yMa, xB, yB, xC, yC) end proc; 

#midpoint of [AC]
Mb1 := proc (xMb, yMb)  return midp1(xMb, yMb, xA, yA, xC, yC) end proc; 
Mb2 := proc (xMb, yMb)  return midp2(xMb, yMb, xA, yA, xC, yC) end proc; 

#midpoint of [AB]
Mc1 := proc (xMc, yMc)  return midp1(xMc, yMc, xA, yA, xB, yB) end proc; 
Mc2 := proc (xMc, yMc)  return midp2(xMc, yMc, xA, yA, xB, yB) end proc; 

# circumcenter
O1 := proc (xO, yO)  return onmed(xO, yO, xA, yA, xB, yB) end proc; 
O2 := proc (xO, yO)  return onmed(xO, yO, xA, yA, xC, yC) end proc; 

# isobarycenter
G1 := proc (xG, yG)  return ibar1(xG, yG, xA, yA, xB, yB, xC, yC) end proc; 
G2 := proc (xG, yG)  return ibar2(xG, yG, xA, yA, xB, yB, xC, yC) end proc; 

# feet of the altitudes
# from point A
Ha1 := proc (xHa, yHa)  return prodScalV(xA-xHa, yA-yHa, xC-xB, yC-yB) end proc; 
Ha2 := proc (xHa, yHa)  return onLine(xHa, yHa, xB, yB, xC, yC) end proc; 

# from point B
Hb1 := proc (xHb, yHb)  return prodScalV(xB-xHb, yB-yHb, xC-xA, yC-yA) end proc; 
Hb2 := proc (xHb, yHb)  return onLine(xHb, yHb, xA, yA, xC, yC) end proc; 

#from point C
Hc1 := proc (xHc, yHc)  return prodScalV(xC-xHc, yC-yHc, xA-xB, yA-yB) end proc; 
Hc2 := proc (xHc, yHc)  return onLine(xHc, yHc, xB, yB, xA, yA) end proc; 

# orthocenter
H1 := proc (xH, yH)  return prodScalV(xA-xH, yA-yH, xB-xC, yB-yC) end proc; 
H2 := proc (xH, yH)  return prodScalV(xB-xH, yB-yH, xC-xA, yC-yA) end proc; 

# "feet" of the inner bisectors
# that is intersection of the inner bisector from one vertex to the opposite side
# from point A
Ta1 := proc (xTa, yTa)  return onb(xTa, yTa, xA, yA, xB, yB, xC, yC) end proc; 
Ta2 := proc (xTa, yTa)  return onLine(xTa, yTa, xB, yB, xC, yC) end proc; 

# from point B
Tb1 := proc (xTb, yTb)  return onb(xTb, yTb, xB, yB, xA, yA, xC, yC) end proc; 
Tb2 := proc (xTb, yTb)  return onLine(xTb, yTb, xA, yA, xC, yC) end proc; 

# from point C
Tc1 := proc (xTc, yTc)  return onb(xTc, yTc, xC, yC, xA, yA, xB, yB) end proc; 
Tc2 := proc (xTc, yTc)  return onLine(xTc, yTc, xA, yA, xB, yB) end proc; 

# center of the inscribed circle
I1 := proc (xI, yI)  return onb(xI, yI, xA, yA, xB, yB, xC, yC) end proc; 
I2 := proc (xI, yI)  return onb(xI, yI, xB, yB, xA, yA, xC, yC) end proc; 

# center of the Euler circle
N1 := proc (xN, yN)  return onmed(2*xN, 2*yN, xA+xB, yA+yB, xA+xC, yA+yC) end proc; 
N2 := proc (xN, yN)  return onmed(2*xN, 2*yN, xA+xB, yA+yB, xB+xC, yB+yC) end proc; 

# pair of equations for each point
A := proc (x, y)  A1(x, y), A2(x, y) end proc; 
B := proc (x, y)  B1(x, y), B2(x, y) end proc; 
C := proc (x, y)  C1(x, y), C2(x, y) end proc; 
Ma := proc (x, y)  Ma1(x, y), Ma2(x, y) end proc; 
Mb := proc (x, y)  Mb1(x, y), Mb2(x, y) end proc; 
Mc := proc (x, y)  Mc1(x, y), Mc2(x, y) end proc; 
Oo := proc (x, y)  O1(x, y), O2(x, y) end proc; 
Gg := proc (x, y)  G1(x, y), G2(x, y) end proc; 
Ha := proc (x, y)  Ha1(x, y), Ha2(x, y) end proc; 
Hb := proc (x, y)  Hb1(x, y), Hb2(x, y) end proc; 
Hc := proc (x, y)  Hc1(x, y), Hc2(x, y) end proc; 
Hh := proc (x, y)  H1(x, y), H2(x, y) end proc; 
Ta := proc (x, y)  Ta1(x, y), Ta2(x, y) end proc; 
Tb := proc (x, y)  Tb1(x, y), Tb2(x, y) end proc; 
Tc := proc (x, y)  Tc1(x, y), Tc2(x, y) end proc; 
Ii := proc (x, y)  I1(x, y), I2(x, y) end proc; 
Ea := proc (x, y) return Hh(2*x- xA, 2*y- yA) end proc; 
Eb := proc (x, y) return Hh(2*x- xB, 2*y- yB) end proc; 
Ec := proc (x, y) return Hh(2*x- xC, 2*y- yC) end proc; 
Nn := proc (x, y) return N1(x, y), N2(x, y) end proc; 

Lvar:=[xA, yA, xB, yB, xC, yC];

Rw := RegularChains[PolynomialRing]([xA, yA, xB, yB, xC, yC]); 
Hw := [[xB-xC, yB-yC], [xA-xB, yA-yB], [xA-xC, yA-yC]]; 

#
# Wernick under triangular form (and also, deep thought about maple)
#
Wtf := proc (F, R, H) 
		local tr, tr1, st; 
		tr := RegularChains[Triangularize](F, R); 
		tr1 := filterLsLc(tr, H, R); 
		st := map(RegularChains[Equations], tr1, R); 
		return st 
	 end proc; 
	 
Wt := proc (F) return Wtf(F, Rw, Hw) end proc; 

WtfVars := proc(F, L, H)
	local Rcur;
	Rcur :=  RegularChains[PolynomialRing](L);
	return Wtf(F, Rcur, H);
end proc;

# search for a given variable "vx" in a list (li) of equations vx=something
num := proc (li, vx) 
		local i, v, p; 
		i := 1; 
		v := 0; 
		for p in li while v = 0 do 
			if evalb(op(p)[1] = vx) then v := i end if; 
			i := i+1 
		end do; 
		return v 
	  end proc; 

# get the coordinates of all the characteristic points corresponding to a solution
# encoded in the liste li = [xA = ..., yA= ..., xB=.. ]
# the order of the varables xa, yA, ... may vary because we use num() procedure
defFig := proc (li) 
			local x, y, pA, pB, pC; 
			 x := num(li, xA); y := num(li, yA); 
			pA := geometry[point]('PA', op(li[x])[2], op(li[y])[2]); 
			x := num(li, xB); y := num(li, yB); 
			pB := geometry[point]('PB', op(li[x])[2], op(li[y])[2]); 
			x := num(li, xC); 
			y := num(li, yC); 
			pC := geometry[point]('PC', op(li[x])[2], op(li[y])[2]); 
			geometry[triangle](T, [pA, pB, pC]); 
			geometry[altitude](hA, pA, T, nHa); 
			geometry[altitude](hB, pB, T, nHb); 
			geometry[altitude](hC, pC, T, nHc); 
			geometry[bisector](bA, pA, T, Ba); 
			geometry[bisector](bB, pB, T, Bb); 
			geometry[bisector](bC, pC, T, Bc); 
			geometry[median](mA, pA, T, iA); 
			geometry[median](mB, pB, T, iB); 
			geometry[median](mC, pC, T, iC); 
			geometry[circumcircle](CC, T, 'centername' = nO); 
			return [pA, pB, pC, T, hA, hB, hC, bA, bB, bC, mA, mB, mC, CC] 
		end proc; 
		
# drawing a figure 	corresponding to a solution encoded in li
drawFig := proc (li) 
			local x, y, pA, pB, pC; 
			 x := num(li, xA); y := num(li, yA); 
			geometry[point](pA, op(li[x])[2], op(li[y])[2]); 
			x := num(li, xB); y := num(li, yB); 
			geometry[point](pB, op(li[x])[2], op(li[y])[2]); 
			x := num(li, xC); y := num(li, yC); 
			geometry[point](pC, op(li[x])[2], op(li[y])[2]); 
			geometry[triangle](T, [pA, pB, pC]); 
			geometry[altitude](hA, pA, T, nHa);
			geometry[altitude](hB, pB, T, nHb); 
			geometry[altitude](hC, pC, T, nHc); 
			geometry[bisector](bA, pA, T, Ba); 
			geometry[bisector](bB, pB, T, Bb); 
			geometry[bisector](bC, pC, T, Bc);
			geometry[median](mA, pA, T, iA); 
			geometry[median](mB, pB, T, iB); 
			geometry[median](mC, pC, T, iC); 
			geometry[circumcircle](CC, T, 'centername' = nO); 
			geometry[EulerCircle](EC, T, 'centername' = oM); 
			geometry[draw]([pA, pB, pC, T(color = black, thickness = 1), hA(color = black), hB(color = black), hC(color = black), bA(color = blue), bB(color = blue), bC(color = blue), mA(color = green), mB(color = green), mC(color = green), CC(color = pink, linestyle = dot, thickness = 1), nO(color = red), EC, oM], axes = normal, printtext = true) 
		end proc 

end module;
savelib('Wernick');
