
with(Wernick);

##############################################
# Procedures provided : bestOrder, getEquations

#################################################

# WARNING : elements in lorder must match functions in lequations

lorder := ["I", "Ta", "Tb", "Tc",
			"N", "H", 
	        "Hb", "Ea", "Eb", "Ec",
	        "Ha", "Hc", "G", "O",
	        "Ma", "Mb", "Mc",
	        "A", "B", "C"]:
	        
lequations := [ Ii, Ta, Tb, Tc, Nn, Hh, Hb, Ea, Eb, Ec, Ha, Hc, Gg, Oo, Ma, Mb, Mc, A, B, C ]:
	

############
# aux proc : search a word in a list

search:=proc(str, lstr)
   local strcmp, ind:
   
   ind := 1:
   for strcmp in lstr do
	    if evalb(strcmp = str) then return ind: fi:
	    ind := ind + 1:
   end do; 
   return -1:
end proc:

#####################################
# input : list of 3 letters (strings)
# output : list of same 3 letters according to order appearance in lorder
# ex : ["A", "Ea", "N"] -> ["N", "Ea", "A"]


bestOrder:=proc(lletters)
	local lres, ind1, ind2, ind3,str1, str2, str3;
	global lorder;
	
	str1 := lletters[1];
	str2 := lletters[2];
	str3 := lletters[3];
#	printf("Best order for : %s %s %s\n", str1, str2, str3);
	ind1 := search(str1, lorder):        
	ind2 := search(str2, lorder):        
	ind3 := search(str3, lorder):   
	
	if ind1 = 0 or ind2 = 0 or ind = 0 then 
		error "in bestOrder : weird, letter not exists amidst %1 %2 %3", str1, str2, str3:
	end if:
	
	# initialize lres with the head element
	if ind1 < ind2 and ind1 < ind3 then 
		lres := [str1];  
		if ind2 < ind3 then lres:=[op(lres), str2, str3]; else lres:=[op(lres), str3, str2]; fi;
	elif ind2 < ind3 then 
		lres := [str2]:
		if ind1 < ind3 then lres:=[op(lres), str1, str3]; else lres:=[op(lres), str3, str1]; fi:
	else lres := [str3]:
		if ind1 < ind2 then lres:=[op(lres), str1, str2]; else lres:=[op(lres), str2, str1]; fi:		
	end if:
end proc:	

if nops(lorder) <> nops(lequations) then 
	error "In bestOrderForPoints : list lorder and lequations do not have same size"
fi;

##############################
# Get equation from name
#    name : string (O, Ha, I, etc.)
#    coords : point

getEquations:=proc(name, coords)
	local x, y, ind:
	global lorder, lequations;
	x := coordinates(coords)[1]:
	y := coordinates(coords)[2]:
	
	ind := search(name, lorder);
	if ind = 0 then error "%1 not found in lorder", name: fi:

	return lequations[ind](x,y):
end proc:

