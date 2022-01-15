
with(geometry):
with(ListTools):
with(StringTools):

# personnal modules
with(Wernick):
with(Common):

read("./getCoordsOfPoints.mpl"):
read("./transform.mpl"):
read("./filterCoords.mpl"):
read("./solveTriangularSystem.mpl"):
read("./equationsOrderForPoints.mpl"):

global gfilename;
global check_real_solvable;

####################################################
#	Auxiliary functions
#

#######################
# is this integer is a power of 2 ?

ispower2:=proc(val)
   local v:=val:
   while type(v,integer) and v > 1 do
       v := v/2;
   od;
   return evalb(v = 1);
end proc:

#######################
#  List difference

difflist:=proc(l1,l2) 
    local set1:={op(l1)}, set2:={op(l2)};
	return [ op(set1 minus set2) ];
end proc:


################################
# filter systems
#   input : a list of systems
#   output : sublist of systems with 6 equations

filterOutIllConditionned:= proc(systems)
	local syst, lr:
	
	lr:=():
	for syst in systems do
		if nops(syst) = 6 then 
			lr:=lr, syst:
		fi
	od:
	
	return [lr]:
end proc: 
	

#############################
# Analyse a system
# recall : 
#	 D : degenerated
#    S : ruler and compass solvable
#    R : redondant, ex : A B Mc
#    L : ill-constrained, ex : A B O  (O lies in the perp. bisector of A B => infinite or none solutions)
#    U : unsolvable
# return : -2(D), -1 (unable to decide), 0 (U), 1(S), 2 (to be confirmed with parameterized system), 3 (R or L)

analyseSystem := proc(tsyst)
	local eq, neq, lv, current_var, nbgalois, afterneq, lunsolvedvar, lsolved_var, deg, solutions:
	global check_real_solvable;

	# should not occur since systems were filtered
	if nops(tsyst) < 6 then return 3 fi;
		
	# get last interesting equation
	neq:=6; # current is 6th
	lunsolvedvar:=Lvar;

	# find first equation with deg > 1
	while (neq > 0 and isUnivariateWithDegree(tsyst[neq], 1, lunsolvedvar)) do 
		# get new var solved 
		lsolved_var:=getlvars(tsyst[neq], lunsolvedvar);

		# remaining var
		lunsolvedvar:=difflist(lunsolvedvar, lsolved_var);
		neq := neq -1;
	od;
	
	# if solvable with only equations of degree 1
	if neq < 1 then return 1; fi;
	
	# else
	eq := tsyst[neq];
	
	# get var in equation
	lv := getlvars(eq, Lvar);
	
#	if (nops(lv) <> 1) then print(tsyst); error "Too much variable" fi;
	if (nops(lv) <> 1) then return -2 fi; # degenerated, for instance [ f(xA,yA), 12] => two equations, 2 unk but ...
	current_var := lv[1];
	
	# get degree
	deg := degree(eq, current_var);
	if deg >= 9 and not ispower2(deg) then return 0; fi;

	# galois
	nbgalois := galois(eq, current_var)[4];
	
	# unconstructible
	if not ispower2(nbgalois) then return 0; fi;
	
	# is it solvable with reals ? 
	if check_real_solvable = true then
		solutions := numericalSolvingTriangular(tsyst, Lvar);
		if  nops(solutions) = 0 then return 2; fi;
	fi;
	
	# solvable
	
	return 1;
	
	
end proc:	
	

###############################
# sum nb vars

sumVars:= proc(system)
	local i, res;
	res:=0;
	
	# for each equation
	for i from 1 to nops(system) do:
	 #   res := res +  nops(getlvars(system[i], Lvar));
		res := res + nops(getlvars(system[i], Lvar)); # *degree(system[i]);
	od;
	return res/6;
end proc:

###############################
# parse string : "Problem Cxxx"


getNumProblem := proc(lwords) 
	local num;
	if nops(lwords) < 2 then
		error "getNumProblem : not enough words %1", lwords;
		return "";
	fi;
	
	num := parse(lwords[2][2..-1]);
	# if connely problem
	if num > 139 then return cat("C", num-139);
	else return cat("W", num);
	fi;
	
end proc:

###############################
# filters 

NumFiltersList := proc(lnames, ltcoords) 
	local H2, lcur, i;
	
 	# points must not be equal to A, B or C
   H2:=[];
	for i from 1 to nops(ltcoords) do
          lcur:=[];
	  if lnames[i] <> "A" then
	      lcur:=[op(lcur), [xA-X(ltcoords[i]), yA-Y(ltcoords[i])] ];
	  fi;
	  if lnames[i] <> "B" then
	      lcur:=[op(lcur), [xB-X(ltcoords[i]), yB-Y(ltcoords[i])] ];
	  fi;
	  if lnames[i] <> "C" then
	      lcur:=[op(lcur), [xC-X(ltcoords[i]), yC-Y(ltcoords[i])] ];
	  fi;

	  H2:=[op(H2), op(lcur)];
    od;	

	return H2;
end proc:

###############################
# main analysing procedure
#   lwords  : string for specific point (eg ["O", "Ha", "Hb"] )
#   pA, pB, pC : coordinates of vertex of triangle A B C

analyseProblem:=proc(lnames, lfilter_eq, lequations, lvars, pA, pB, pC) 
	local nbw, 
		  system, i, triangular_systems, tsyst, status,
		  input, ranalyse, s:
		  
    local neq, eq, lv, fd, H;
		  
	# global Lvar:
	
		# get system
	system:=op(lequations);
		
	# symbolically solving

    H:=[op(Hw), op(lfilter_eq)];  # Hw is in module Wernick
    print(H);
	triangular_systems := WtfVars([system], lvars, H):

	# filter ill-conditioned systems (system with less than 6 equations)  
	triangular_systems := filterOutIllConditionned(triangular_systems):

	# analyse

	status:=0:
	if nops(triangular_systems) = 0 then # ill conditionned
		 status := 3:
	else 
	    # for all triangular systems 
	    if nops(triangular_systems) > 1 then
#			printf("%d systems \n", nops(triangular_systems));
		fi:
		for tsyst in triangular_systems do
			# get status for current system
			ranalyse := analyseSystem(tsyst);

			# update status 
#			if nops(triangular_systems) > 1 then printf("  %d ", ranalyse); fi;
				 
			if status = 2 and ranalyse = 1 or ranalyse = 2 and status = 1 then 
					status := 1; 
			else  if ranalyse > status then status := ranalyse; fi;
			fi;
		od;
#		 if nops(triangular_systems) > 1 then printf("\n"); fi;
	fi:
	
#	if result = 2 then
#		printf("================ Equation system %d ==============\n", nops([system]));
#		displaySystem([system], Lvar);
#		printf("%s %s %s \n", lnames[1], lnames[2], lnames[3]);
#		printf("    A(%d,%d) B(%d,%d) C(%d,%d) \n", X(pA), Y(pA), X(pB), Y(pB), X(pC), Y(pC));
#		printf("    E1(%d,%d) E2(%d,%d) E3(%d,%d) \n", X(ltcoords[4]), Y(ltcoords[4]), X(ltcoords[5]), Y(ltcoords[5]), X(ltcoords[6]), Y(ltcoords[6]));
#		for tsyst in triangular_systems do
#			displaySystem(tsyst, Lvar);
#		od;
		
#	fi;

# displaySystVar([system], Lvar);
#	printf("deg : %d nbm : %d sumvars : %f  ", degSyst([system]), nbMonomialsSyst([system]), sumVars([system]));

	return status;
		
end proc:

############################
# get coords from statement

prepareStatement := proc(lwords)
	local nbw, lnames, ltcoords;
	
	# get the letters, ex : A B O
	nbw := nops(lwords): 	# nb words on the current line (should be 3 or 4, eg : A Ha I U)

	lwords[1..3];
	lnames := bestOrder(lwords[1..3]);

	# get coords of points 

	ltcoords := getLcoordsAfterFiltering(pA, pB, pC, lnames, true); # true : append changes to log	
	
	ltcoords:=[op(4..6, ltcoords)];	# get only points of the statement
	
	return lnames, ltcoords;
end proc:


############################
# display result

displayResult := proc(num_line, num_problem, lwords, status)
	local nbw, input, str_result;
	
	nbw := nops(lwords);
	# display status
	printf("%d (line %d) : %s %s %s ", num_problem, num_line, lwords[1], lwords[2], lwords[3]);
	
	if   status = 0 then str_result := "U";
	elif status = 1 then str_result := "S";
	elif status = 2 then str_result := "param"; 
	else str_result := "R/L";
	fi;
		
	if nbw = 4 then 
		input:=lwords[4]:
		if input = "S" and status = 1 then 
			printf("\t input : S \t output : S\n");
		elif (input = "L" or input = "R") and status = 3 then 
			printf("\t input : R or L \t output : R or L\n");
		elif input = "U" and status = 0 then 
			printf("\t input : U \t output : U\n");
		else printf("\t input : %s \t output : %s \t Weird\n", input, str_result);
		fi:
	else printf("\t input : nothing, \t output : %s", str_result); 
	fi: 
	printf("\n");
end proc:

##############################
# return string for display status

status2String := proc(status) 
	local str_result;
	
	if   status = 0 then str_result := "U";
	elif status = 1 then str_result := "S";
	elif status = 2 then str_result := "param"; 
	else str_result := "R/L";
	fi;

	return str_result;
end proc;

##############################
# Restore coords

restoreCoords:=proc(p, xp, yp) 
	coordinates(p)[1] := xp;
	coordinates(p)[2] := yp;
end proc:


###########################
#  Explode instruction


getFctParam := proc(instruction_string)
	local fct_name, list_param, lcur;
	
	lcur := Split(instruction_string, "(");
	if nops(lcur) <> 2 then printf("Syntax error : %s\n", instruction_string); end if;
	
	fct_name := lcur[1];
	lcur := Split(lcur[2], ")");

	if nops(lcur) <> 2 then printf("Syntax error : %s\n", instruction_string); end if;
	list_param := Split(lcur[1], ",");
	
	return fct_name, list_param;
	
end proc:

###########################
#

substituteVar := proc(v, pointNames, pointCoords)
	local p, comp, pname, index, coord, var;
	
	var := Trim(v);
	
	# x or y
	if evalb(var[1] = "x") = true then comp := 1; 
	elif evalb(var[1] = "y") = true then comp := 2;
	else printf("x/y error in %s\n", var); return var;
	end if;
	
	# find the point
	pname := SubString(var,2..-1); # -1 : last
	index:=1;
	for p in pointNames while evalb(p = pname) = false do
		index := index+1;
	od;

	if index <= nops(pointNames) then
		return convert(coordinates(pointCoords[index])[comp], string);
	else 
		return var;
	fi;
	
end proc:
###########################
# return a string with substitution made in input eq string

getEquationFromString := proc(line, pointNames, pointCoords)
	local sparam, lparam, fname, var;
	
	fname, lparam := getFctParam(line);
	sparam := ();
	for var in lparam do
		sparam := sparam,substituteVar(var, pointNames, pointCoords);
	od;
	
	return cat(fname,"(", Join([sparam],",") , ")");
end proc:

##############################
#  Read problems from file : call procedure analyseProblem for each problem
# 	  filename : string 
# 	  pA pB pC : coordinates for vertex of triangle

dealProblemsFromFile:=proc(filename, pA, pB, pC) 
	local file, line, nbwords, status, num_line, lwords, sequation, seq_subst, lequations, lstring_equations, lgenericvarnames,
			lparam, ps1, ps2, ps3, timeout;
	local xpa,ypa,xpb,ypb,xpc,ypc;
	local lparampoints;
	
	local state; # 0 : num_pb, 1 : orig pb, 2 : equi pb, 3 : equations, 4 : solve now
	local str_pb, str_orig_pb, lnames, ltcoords, t1,t2;
	
	global gfilename, check_real_solvable;
	
	# open file with problems
	file := fopen(filename,READ,TEXT);
	gfilename:=filename;
	
	# set log file (for change coords of A B C) 
	setLog("logfile.txt");
	setLogPrefix("");

	# save coordinates
	xpa := coordinates(pA)[1]; ypa := coordinates(pA)[2]; 
	xpb := coordinates(pB)[1]; ypb := coordinates(pB)[2]; 
	xpc := coordinates(pC)[1]; ypc := coordinates(pC)[2]; 

	# prepare list of generic points for constructibility checking
	lparam := [a,b];
	lparampoints := [point(pp0,0,0), point(pp1,1,0), point(pp2,a,b)];

	# for each line
	num_line:=0;		 

	line := "dummy";
	state := 0;
	while (line <> 0) do
		line := readline(file);
		if line = 0 then next; fi; # if end of file

		# remove blanks
		line := Trim(line);  
		num_line:=num_line+1;
		
		# split words
		lwords := Words(line);
		
		# if not comment
		if evalb(line[1] = "#") = true or  evalb(line = "") =  true or
		   evalb(line[1..2] = "**") = true then
		   	next;
		fi;
		
		if evalb(line[1..2] = "--") = true then # new problem
			state := 4;  # => solve now
		fi;
		
		# normal cases
		
		if state = 0 then
			lstring_equations :=[];
			str_pb := getNumProblem(lwords);
			state := 1;
		elif state = 1 then
			str_orig_pb := line;
			state := 2;
		elif state = 2 then
			if nops(lwords) >= 3 then 
				lnames, ltcoords := prepareStatement(lwords);
				ps1 := lwords[1]; ps2 := lwords[2]; ps3 := lwords[3];
			fi;
			state := 3;
		elif state = 3 then
			lstring_equations := [op(lstring_equations), line];
		elif state = 4 then 
			# get equations
			lequations := [];
			for sequation in lstring_equations do
				seq_subst := getEquationFromString(sequation, lnames, ltcoords);
				lequations := [ op(lequations), eval(parse(seq_subst))];
			od;
			
			# solve
			if nops(lequations) = 6 then 
				timeout := false;
				t1 := time();
				check_real_solvable := true;
				try 
					status := timelimit(3600,analyseProblem(lnames, NumFiltersList(lnames, ltcoords), lequations, Lvar, pA, pB, pC));
				catch "time expired":
					printf("%s : too much time\n", str_pb);
					timeout := true;
				end try;

				restoreCoords(pA, xpa, ypa); restoreCoords(pB, xpb, ypb); restoreCoords(pC, xpc, ypc);
			
				if timeout = false then
					t2 := time();
					printf("%s : %s -> %s %s %s    status : %s    time : %f sec\n", str_pb, str_orig_pb, ps1, ps2, ps3, status2String(status), t2-t1);
				fi;
				
				if status = 1 and timeout = false then   # check constructibility
					lequations := [];
					for sequation in lstring_equations do
						seq_subst := getEquationFromString(sequation, lnames, lparampoints);
						lequations := [op(lequations) , eval(parse(seq_subst))];
					od;
					timeout := false;
					check_real_solvable := false;
					t1 := time();
					try 
						status := timelimit(3600,analyseProblem(lnames, NumFiltersList(lnames, lparampoints), lequations, [op(Lvar),op(lparam)], pA, pB, pC));
					catch "time expired":
						printf("    Generically : too much time\n", str_pb);
						timeout := true;
					end try;

					restoreCoords(pA, xpa, ypa); restoreCoords(pB, xpb, ypb); restoreCoords(pC, xpc, ypc);
			
					if timeout = false then
						t2 := time();
						if status = 1 then printf("	Generically constructible     time : %f sec\n", t2-t1);
						else printf("Weird : not generically constructible    time : %f sec\n", t2-t1); 
						fi;
					fi;
				 fi;
			else 
				printf("%s : %d equations \n", str_pb, nops(lequations));
			fi;
			state :=0;
	    else  error "unknown state during parsing %1", state
		fi;
	od;
	close(file);
end proc:
