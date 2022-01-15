with(geometry):

# personnal modules
with(Common):

##############################################
# Procedures provided : getLcoords


#############################################
#
#  Auxiliary procedures
#


# print error message if points of triangle are colinear

msgErrorCheckCol:=proc(pa,pb,pc, str) 
  if AreCollinear(pa, pb,pc) then 
	printf("%s : Are Collinear (%f,%f) (%f,%f) (%f,%f)\n", str, X(pa), Y(pa), X(pb), Y(pb), X(pc), Y(pc));
	# next instruction (Triangle) abort the program :-(
	return true;
  else 
	return false;
  fi;
end proc:

# center of circumcircle

circumcenter:= proc(pa,pb,pc)
  local T, Cir, P;
  
  msgErrorCheckCol(pa,pb,pc,"circumcenter");
  triangle(T, [pa,pb,pc]);
  circumcircle(Cir, T);
  center(P, Cir);
  return P;
end proc:

# center of inner circle

incenter:= proc(pa,pb,pc)
  local T, Cir, P;
  
  msgErrorCheckCol(pa,pb,pc,"incenter");
  triangle(T, [pa,pb,pc]);
  incircle(Cir, T);
  center(P, Cir);
  return P;
end proc:

# altitude

paltitude := proc(pa, pb, pc)
	local T, P, H, L;
	
    msgErrorCheckCol(pa,pb,pc,"paltitude");
	triangle(T, [pa,pb,pc]);
	altitude(H, pa, T);
	line(L, [pb,pc]);
	intersection(P, H, L);
	return P;
end proc:

# foot of bisector angle

pbisect := proc(pa, pb, pc)
	local T, Ba, L, P;

    msgErrorCheckCol(pa,pb,pc,"pbisect");
	triangle(T, [pa,pb,pc]);
	bisector(Ba, pa, T);
	line(L, [pb,pc]);
	intersection(P, Ba, L);
	return P;
end proc:

# Euler center

EulerCenter:=proc(pa,pb,pc)
	local Tabc, Ma, Mb, Mc, Cir, P;

    msgErrorCheckCol(pa,pb,pc,"EulerCenter1");
	midpoint(Ma, pb, pc);
	midpoint(Mb, pa, pc);
	midpoint(Mc, pa, pb);
   
    if msgErrorCheckCol(Ma,Mb,Mc,"EulerCenter2") then 
		printf("From (%f,%f) (%f,%f) (%f,%f)\n", X(pa), Y(pa), X(pb), Y(pb), X(pc), Y(pc));
	fi;
	
	triangle(Tabc, [Ma,Mb,Mc]);
	circumcircle(Cir, Tabc);
    center(P, Cir);
    return P;
end proc:

 ##########################
 # input : 
 #   str : name of point (eg : "Ha")
 #   pa pb pc : vertex of triangle A B C
 # output : point corresponding to str (with float coordinates)

compute:=proc(str, pa, pb, pc) 
   local P, ABC, Paux;

   msgErrorCheckCol(pa,pb,pc,"compute");
   triangle(ABC, [pa,pb,pc]);
   if   str="A" then P:=pa                # A
   elif str="B" then P:=pb                # B
   elif str="C" then P:=pc                # C
   elif str="O" then P:=circumcenter(pa,pb,pc)  # O   
   elif str="Ha" then P:= paltitude(pa, pb, pc) # Ha
   elif str="Hb" then P:= paltitude(pb, pa, pc) # Hb
   elif str="Hc" then P:= paltitude(pc, pa, pb) # Hc
   elif str="H" then orthocenter(P, ABC)        # H
   elif str="Ma" then midpoint(P, pb, pc)    # Ma
   elif str="Mb" then midpoint(P, pa, pc)    # Mb
   elif str="Mc" then midpoint(P, pa, pb)    # Mc
   elif str="G" then centroid(P, ABC)         # G
   elif str="Ta" then P:=pbisect(pa,pb,pc)    # Ta
   elif str="Tb" then P:=pbisect(pb,pa,pc)    # Tb
   elif str="Tc" then P:=pbisect(pc,pa,pb)    # Tc
   elif str="I" then P:=incenter(pa,pb,pc)    # I
   elif str="Ea" then orthocenter(Paux, ABC); midpoint(P, Paux, pa); # Ea
   elif str="Eb" then orthocenter(Paux, ABC); midpoint(P, Paux, pb); # Eb
   elif str="Ec" then orthocenter(Paux, ABC); midpoint(P, Paux, pc); # Ec
   elif str="N" then P:=EulerCenter(pa,pb,pc);   # N center of euler cercle
  end if;
   return P;
end proc:

#############################################
#
#  Main procedure
# 

###############################
# Compute coords for entry points
#   pA, pB, pC : vertex of triangle A B C (with their coordinates)
#   lnames : list of string (eg ["Ha", "I", "A"]
# output : list of 6 points with integer coordinates (A B C + coords for points of lnames)

getLcoords:=proc(pA,pB,pC,lnames, p_ref0, p_ref1)
	local lcoords, ltcoords, str; 
 
    lcoords:=[pA,pB,pC];
    for str in lnames do
		lcoords:=[op(lcoords), compute(str, pA, pB, pC)];
	od:
		
	# new reference
		
	ltcoords := transform(p_ref0, p_ref1, lcoords[4], lcoords[5], lcoords); # lcoords[4] -> p0, lcoords[5] -> p1
	roundPointList(ltcoords);

	return ltcoords;
end proc:


#############################################
#
#  Test 
#     

local test:
test:=false:    # toggle execution

if test then 
	point(pA,0,0);
	point(pB,15,0);
	point(pC,8,5);
	l:=getCoords(pA, pB, pC, "O","Ha","A");
	pdisplay("O", l[1]); 
	pdisplay("Ha", l[2]); 
	pdisplay("A", l[3]);
fi: 

