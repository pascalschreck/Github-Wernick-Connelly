
##############################################
# Procedures provided : numericalSolvingTriangular



# solve a triangular system of polynomial equations
#  system is upper triangular : 
#    last equation must contain only one variable
#    first equation may contain all of the variables

#############################################
#
#  Auxiliary procedures
#



#####################
# get list of vars of equation amongst a list of var
# naive approach (I did not find other way)

getvars:=proc(equation, lvars) 
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

#########################
# Remove complex elements from list

# is these numbers are complex
filterOutComplex:=proc(lnb)
	local res, n ;
	
	res := NULL;
	for n in lnb do
		if Im(n) = 0 then res:=res,n; fi;
	od;
	return [res];
end proc:

####################
# delete element from list

ldelete:=proc(l, e) 
	local elt, res;

	res:=NULL;
	for elt in l do
		if elt <> e then res := res,elt; fi;
	od;
	return [res];
	
end proc:


#########################
# Solve triangular system

numericalSolvingTriangular_aux:=proc(leq, lvar, num_eq, lsubs)
	local eq, gvar, var, solutions, s, lnvar, result;
	
	if num_eq = 0 then return lsubs; fi;
	
	eq := leq[num_eq];
#	print(eq);
	gvar := getvars(eq, lvar);
#	print (gvar);
	
	if nops(gvar) > 1 then printf("Weird : more than one var. : "); print(gvar); fi;
	var := gvar[1];
	
	eq:=subs(lsubs,eq);
	solutions := solve(eq);
#	print(solutions);
	solutions := filterOutComplex([solutions]);
#	print(solutions);

	lnvar := ldelete(lvar, var);
#	print(lnvar);
	
	result:=NULL;	# empty sequence
	for s in solutions do 
		result:=result,numericalSolvingTriangular_aux(leq, lnvar, num_eq-1, [op(lsubs), var=s]);
	od;
	
	return result;
end proc:

#############################################
#
#  Main procedure
#     leq : list of polynomial equations (last equation must contains only one var)
#	  lvar : list of var (order of var in lvar does not matter)

numericalSolvingTriangular:=proc(leq,lvar)
	return [numericalSolvingTriangular_aux(leq, lvar, nops(leq), [])];
end proc:

#############################################
#
#  Test 
#     

local test:
test:=false:    # toggle execution

 # solution (2, 3)
if test then 
	eq0:= x^2*y - 12:
    eq1:= 2*y^3 - 54:
    l:= numericalSolvingTriangular([eq0,eq1], [x, y]);
    print(l); 
fi:
