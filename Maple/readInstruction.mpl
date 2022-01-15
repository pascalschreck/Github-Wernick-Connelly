#############################
# pour lancer : restart; read("readInstruction.mpl");

# with(Wernick);
with (geometry):
with(ListTools):
with(StringTools):

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

substituteVar := proc(var, pointNames, pointCoords)
	local p, comp, pname, index, coord;
	
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
#

getEquationFromString := proc(line, pointNames, pointCoords)
	local sparam, lparam, fname, var;
	
	fname, lparam := getFctParam(line);
	sparam := ();
	for var in lparam do
		sparam := sparam,substituteVar(var, pointNames, pointCoords);
	od;
	
	return cat(fname,"(", Join([sparam],",") , ")");
end proc:

###########################
#

getEquationsFormFile:=proc(filename, pointNames, pointCoords) 
	local file, line, num_line, fname, lparam, sequation, lequations;
	
	file := fopen(filename,READ,TEXT);
	lequations := [];
	line := readline(file);
	while (line <> 0) do
		# remove blanks
		line := Trim(line);  
		num_line:=num_line+1;
		if evalb(line[1] = "#") = true or evalb(line = "") = true then 
			line := readline(file);
			next;
		end if;
		print (line);

#		printf("fonction : %s ; param : ",fname); print(lparam);
		sequation := getEquationFromString(line, pointNames, pointCoords);
		lequations := [ parse(sequation), op(lequations) ];
		
		line := readline(file);
		
	end do;
	close(file);
	return lequations;
end proc:

lnames:=["H","A","N"];
lp := [point(H,1,2), point(A, 3,4), point(N, 5,6)]:
leq := getEquationsFormFile("instructions.txt", lnames, lp):
print (leq):
