

##############################################
# Procedures provided : setLog, setLogPrefix, getLcoordsAfterFiltering


#  Changes of coords could be reported in a log file
global glogfilename, glogprefix;

###########################
#  Auxiliary procedures

# Dot product 

pscal:=proc(p1,p2, p3, p4)
	local xv1,yv1,xv2,yv2;
	xv1:=X(p2)-X(p1);
	yv1:=Y(p2)-Y(p1);
	xv2:=X(p4)-X(p3);
	yv2:=Y(p4)-Y(p3);
	return xv1*xv2 + yv1*yv2;
end proc:

# Cross product

pvect:=proc(p1,p2, p3, p4)
	local xv1,yv1,xv2,yv2;
	xv1:=X(p2)-X(p1);
	yv1:=Y(p2)-Y(p1);
	xv2:=X(p4)-X(p3);
	yv2:=Y(p4)-Y(p3);
	return xv1*yv2 - yv1*xv2;
end proc:
	
###########################
# Filters for entry points

 # are p1 and p2 equals ? (same point)
 
areCoincident:=proc(p1,p2)
	return evalb(coordinates(p1) = coordinates(p2));
end proc:

 # colinearity
 
areColinear:=proc(p1, p2, p3)
	return evalb(pvect(p1,p2,p1,p3) = 0);
end proc:

 # perpendicular

isRightAngle:=proc(p1, p2, p3)
	return evalb(pscal(p1,p2,p1,p3) = 0) or evalb(pscal(p2,p1,p2,p3) = 0) or evalb(pscal(p3,p1,p3,p2) = 0) ;
end proc:

#############################
#   input : list lp, f a binary boolean function
#   output : true if f(lp[i], lp[j) = true for some (i,j) 

check2ParamFunction:=proc(lp, f) 
	local res, b, i, j;
	
	res:= false;
	for i from 1 to nops(lp)-1 do
		for j from i+1 to nops(lp) do 
			res:= res or f(lp[i], lp[j]);
		od;
	od;
		
	return res;
end proc:

#############################
#  current number of filters

getFilterNumbers:=proc() return 5; end proc:

#############
#  filterPoints : check some situations (colinearity, right angle, ...)
#     input :  lfiter : boolean list of active filters (false : not active, true : active)
#			   lABC : list of 3 points A B C (the genuine triangle)
#			   lP1P2P3 : points of the statement 
#			   luniq : list of A B C P1 P2 P3 but with only one occurence of each (because P1 could be A for instance)
#     output : list of test (eg [true, false, false,...] means first test (coincident point) is true : there are some coincident points)

filterPoints:=proc(lfilter, lABC, lP1P2P3, luniq) 
	local sresult, num;
	local pA,pB,pC,pE1,pE2,pE3;
	
	pA := lABC[1]; 	   pB := lABC[2]; 	  pC := lABC[3];
	pE1 := lP1P2P3[1]; pE2 := lP1P2P3[2]; pE3 := lP1P2P3[3]; 
	
	sresult:=NULL;
	num:=1;
	# if 2 coincident points
	 # if filter is active and ...
	if lfilter[num] and check2ParamFunction(luniq, areCoincident) then 
		 sresult:=sresult, true; 
	else sresult:=sresult,false;
	fi;
	
	# if aligned points
	num:=num+1;
	if lfilter[num] and areColinear(pA,pB,pC) then 
		 sresult:=sresult, true; 
	else sresult:=sresult,false;
	fi;
	
	num:=num+1;
	if lfilter[num] and areColinear(pE1,pE2,pE3) then 
		 sresult:=sresult, true; 
	else sresult:=sresult,false;
	fi;
	
	# if right angle
	num:=num+1;
	if lfilter[num] and isRightAngle(pA,pB,pC) then 
		 sresult:=sresult, true; 
	else sresult:=sresult,false;
	fi;
	
	num:=num+1;
	if lfilter[num] and isRightAngle(pE1, pE2, pE3) then 
		 sresult:=sresult, true; 
	else sresult:=sresult,false;
	fi;
	
	return [sresult];
end proc:


############################
# display filter

strFilter:=proc(num)
	if num=1 then return "Two coincident points";
	elif num = 2 then return "A B C aligned"; 
	elif num = 3 then return "Statement points aligned"; 
	elif num = 4 then return "A B C right angle";
	elif num = 5 then return "Statement points right angle"; 
	else return "unknown filter"; 
	fi;
end proc:



############################
# Some auxiliary procedures

allFalse:=proc(lst) 
	local i, res;
	res:=false;
	for i from 1 to nops(lst) do
		res:= res or lst[i];
	od;
	
	return (not res);
end proc:

andList:=proc(l1,l2) 
	local i, res;
	res:=NULL;
	
	for i from 1 to nops(l1) do
		res := res, (l1[i] and l2[i]);
	od;
	
	return [res];
	
end proc:

############################
# change_coord : change one coordinate of a  point
#   input : 
#		p : the point whose one coordinates is to be changed
#		range : coord is added to a value in [-range; range]
#		which_coord : 1:x, 2:y, 0:x or y
#   output : point p

change_coord:=proc(p, range:=50, which_coords:=0) # which_coords : O : random, 1 : x, 2 : y
	local randnb;
	local xy; # 1 : change x, 2 : change y
	
	# choose not nul number
	randnb:=rand(-range..range)(); while evalb(randnb = 0) do randnb:=rand(-range..range)(); od;

	if which_coords = 0  then 
		xy:=rand(1..2)(); 
	fi;

	if xy = 1 then 
		 coordinates(p)[1] := X(p)+randnb;
	else coordinates(p)[2] := Y(p)+randnb;
	fi;

	return p;
end proc:

##############################
# Log management 

setLog:=proc(filename) 
	global glogfilename;
	glogfilename:=filename;  
end proc:

setLogPrefix:=proc(log_prefix) 
	global glogprefix;
	glogprefix:=log_prefix; 
end proc:




#############################
# Main procedure for choosing coords
# input : pA pB pC : point of triangle
#         lnames : list of 3 strings (eg "Ha", ...)
#		  logOuput : true if changes must be reported in log file
# output : list of coords for the 6 points, A B C + 3 points of the statement

getLcoordsAfterFiltering:=proc(pA, pB, pC, lnames, logOutput:=false) 
	local ltcoords, lr;
	local i, num_point, ok;
	local nb_filters, stat_list, active_filters_list, nb_tests_cur, nb_max_tests;
	local change_made, fd;
	local xmin, xmax, ymin, ymax;
	local lABC, lP1P2P3, luniq;
	local p_ref0, p_ref1;
	global glogfilename;

#	printf("From A(%d,%d) B(%d,%d) C(%d,%d) \n", X(pA), Y(pA), X(pB), Y(pB), X(pC), Y(pC));

#	printf("Enter filtering\n");

	# new reference
	point(p_ref0, 0, 0);
	point(p_ref1, 7273, 0);

	ltcoords := getLcoords(pA, pB, pC, lnames, p_ref0, p_ref1);
	
	# looking for problems in selection
	
	nb_filters := getFilterNumbers();
	stat_list:=[seq(true, i=1..nb_filters)];
	active_filters_list:=[seq(true, i=1..nb_filters)];
	
	nb_max_tests:=12;
	nb_tests_cur := nb_max_tests;
	change_made:=false;
	
#	printf("Avant %s :  pA (%d, %d), pB(%d, %d), pC(%d, %d)\n", glogprefix, 
#			X(pA), Y(pA), X(pB), Y(pB), X(pC), Y(pC));

	lABC   :=[ltcoords[1], ltcoords[2], ltcoords[3]];
	lP1P2P3:=[ltcoords[4], ltcoords[5], ltcoords[6]];
	luniq:=[op(lABC)];
	for i from 1 to 3 do
		if lnames[i] <> "A" and lnames[i] <> "B" and lnames[i] <> "C" then
			luniq:=[op(luniq), ltcoords[i+3]];
		fi;
	od;
				
	lr:=filterPoints(active_filters_list, lABC, lP1P2P3, luniq); 

	while not allFalse(lr) do	
#		print(stat_list);
#		print(lr);
#		print(nb_tests_cur);

		stat_list := andList(stat_list, lr);
		nb_tests_cur:=nb_tests_cur-1;
		
		# if some filters are always true 4 times in a row : change A B C
		
		if nb_tests_cur > 0 and nb_tests_cur mod (nb_max_tests/3) = 0 then 
			xmin:=min(coordinates(pA)[1], coordinates(pB)[1], coordinates(pC)[1]);
			xmax:=max(coordinates(pA)[1], coordinates(pB)[1], coordinates(pC)[1]);
			ymin:=min(coordinates(pA)[2], coordinates(pB)[2], coordinates(pC)[2]);
			ymax:=max(coordinates(pA)[2], coordinates(pB)[2], coordinates(pC)[2]);
			coordinates(pA)[1] := rand(xmin..xmax)();
			coordinates(pA)[2] := rand(ymin..ymax)();
			coordinates(pB)[1] := rand(xmin..xmax)();
			coordinates(pB)[2] := rand(ymin..ymax)();
			coordinates(pC)[1] := rand(xmin..xmax)();
			coordinates(pC)[2] := rand(ymin..ymax)();
		fi;

		
		# if some filters always failed then remove them
		if nb_tests_cur = 0 then   # 
			nb_tests_cur:= nb_max_tests;
			for i from 1 to nb_filters do
				if stat_list[i] = true then 
					active_filters_list[i]:=false;  # remove filter
#		printf("Remove filter : %s\n", strFilter(i));

				fi;
				stat_list[i] := true;	# reinit stat_list
			od;
		fi;

	
		# choose point to change
		
		ok:= false;
		while not ok do
#			printf("  4\n");
#printf("Avant pA (%d, %d), pB(%d, %d), pC(%d, %d)\n", X(pA), Y(pA), X(pB), Y(pB), X(pC), Y(pC));
			num_point := rand(1..3)();  # choose a coord randomly (x or y)
			if   num_point = 1 then change_coord(pA);
			elif num_point = 2 then change_coord(pB);
			else change_coord(pC);
			fi;
			
#printf("Apres pA (%d, %d), pB(%d, %d), pC(%d, %d)\n", X(pA), Y(pA), X(pB), Y(pB), X(pC), Y(pC));
			
			ok:= not areColinear(pA,pB,pC);
		od;
		
		change_made:=true;
#				printf("To A(%d,%d) B(%d,%d) C(%d,%d) \n", X(pA), Y(pA), X(pB), Y(pB), X(pC), Y(pC));

				
		# compute new coords for entry points
		
		ltcoords := getLcoords(pA, pB, pC, lnames, p_ref0, p_ref1);
		lABC   :=[ltcoords[1], ltcoords[2], ltcoords[3]];
		lP1P2P3:=[ltcoords[4], ltcoords[5], ltcoords[6]];
		luniq:=[op(lABC)];
		for i from 1 to 3 do
			if lnames[i] <> "A" and lnames[i] <> "B" and lnames[i] <> "C" then
				luniq:=[op(luniq), ltcoords[i+3]];
			fi;
		od;
		lr:=filterPoints(active_filters_list, lABC, lP1P2P3, luniq); 

	od;	

	# if output in file
	if logOutput and change_made and glogfilename <> "" then
		fd:=fopen(glogfilename, APPEND);
		fprintf(fd, "%s : %s %s %s : pA (%d, %d), pB(%d, %d), pC(%d, %d)\n", glogprefix, lnames[1], lnames[2],lnames[3], X(pA), Y(pA), X(pB), Y(pB), X(pC), Y(pC));
		fclose(fd);
	fi;
	
	#	printf("Final A(%d,%d) B(%d,%d) C(%d,%d) \n", X(ltcoords[1]), Y(ltcoords[1]), X(ltcoords[2]), Y(ltcoords[2]), X(ltcoords[3]), Y(ltcoords[3]));

#	printf("Exit filtering\n");

	return ltcoords;
end proc:
