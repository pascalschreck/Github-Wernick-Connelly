with(ListTools):
with(geometry):

Common := module()

# misc 
export X, Y, pdisplay, roundPointList:

# polynomial systems
export getlvars, isUnivariateWithDegree, displaySystem:


option package; 

##########################################
#
#	Misc procedures
#


##################################
# get X and Y from coordinates

X:=proc(p) coordinates(p)[1]; end proc:
Y:=proc(p) coordinates(p)[2]; end proc:

##################################
# display point
#   str : string, name of point
#   p : coordinates 

pdisplay:=proc(str, p) 
	printf("%s %f %f\n", str, coordinates(p)[1], coordinates(p)[2]);
end proc:

#############################################
# round coords of points in list (mutable)
#    round a list of points (coordinates rounded to the nearest integer)
roundPointList:=proc(l)
	local lr, coords, st, p;
	for p in l do
		coords := coordinates(p);
		point(p, round(coords[1]), round(coords[2])); 
	od:
end proc :

##########################################
#
#	Procedures for system of equations
#

#################################
# get sublist of vars of equation amongst a list of var
#   naive approach (I did not find other way)
#   ex : getlvars([x^2*y, x-5], [x,y,z]) returns [x, y]

getlvars:=proc(equation, lvars) 
	local eq, v, lr:
	
	lr:=():
	eq := expand(equation);
	for v in lvars do:
		if evalb(coeffs(eq, [v]) = eq) = false then 
			lr:=lr, v
		fi:
	od:
	return [lr]:
end proc:

####################
# return true if equation is a univariate polynomial a*x^deg with x in lvar

isUnivariateWithDegree:=proc(equation, deg, lvar) 
	local lv;
	
	lv := getlvars(equation, lvar);
	if (nops(lv) <> 1) then return false; fi;
	
	return evalb(degree(equation, lv[1]) = deg);
end proc: 

############################
# display system 

displaySystem := proc(leq, lvars)
	local i, eq, lv;

	i:= 1;
	for eq in leq do
		printf("    Eq %d ", i); i:= i+1;
		lv := getlvars(eq, lvars);
		print(lv);
		print(eq);
	od;
end proc:


end module:

savelib('Common');
