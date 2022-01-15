with(geometry):

# personnal modules
with(Common):

#############################################
#
#  Auxiliary procedures
#

#####################
# Transform a point : translation + rotation around center + homothety from center
# 1. translation : Pt = p+tseg
# 2. rotation :    Pr = rotate Pt (around center, angle_rot)
# 3. homothety :   Ph = homothety Pr (center, hom_ratio)

ptransform:=proc(p, tseg, angle_rot, hom_ratio, center)
	local Pt, Pr, Ph;
#	pdisplay("p : ", p);
	translation(Pt, p, tseg); 
#	pdisplay("tra : ", Pt);
	rotation(Pr, Pt, angle_rot, 'counterclockwise', center);
#	pdisplay("center : ", center);
#	printf("angle : %f\n", angle_rot);
#	pdisplay("Pr : ", Pr);
	homothety(Ph, Pr, hom_ratio, center);
#	printf("%f %f \n\n", coordinates(Ph)[1], coordinates(Ph)[2]);
	return Ph;
end proc:

##############
# angle
# return angle between segment [pa1, pb1] and segment [pa2, pb2]

angle:=proc(pa1,pb1,pa2,pb2)
	local xa1,ya1,xb1,yb1,xa2,ya2,xb2,yb2, pnorm,cang,sang,ang;
	local xv1,yv1,xv2,yv2;
	
	xa1:=coordinates(pa1)[1]: ya1:=coordinates(pa1)[2];
	xb1:=coordinates(pb1)[1]: yb1:=coordinates(pb1)[2]; 
	xa2:=coordinates(pa2)[1]: ya2:=coordinates(pa2)[2]; 
	xb2:=coordinates(pb2)[1]: yb2:=coordinates(pb2)[2]; 
	
	xv1 := xb1-xa1:  yv1 := yb1-ya1;
	xv2 := xb2-xa2:  yv2 := yb2-ya2;
#	printf("ang xv : %f %f %f %f\n", xv1, yv1, xv2, yv2);
	pnorm := distance(pa1,pb1)*distance(pa2,pb2);
#	printf("n: %f\n", pnorm);
	if pnorm <> 0 then 
		cang:= (xv1*xv2 + yv1*yv2)/pnorm;
		sang:=(xv1*yv2 - xv2*yv1)/pnorm;
	else cang:= 1.; sang:= 0.; 				# angle = 0
	fi;
	
#	printf("a: %.20f s : %f\n", cang, sang);

	ang := arccos(cang);
#	printf("ang: %f \n", ang);

	if evalf(sang) < 0 then 
		ang := - ang;
	fi;
#	printf("ang : %f (%f deg)\n", ang, (ang/Pi)*180);
	return ang;
end proc:

#############################################
#
#  Main procedure
#

#############
# transform a list of points
# l is the list of points
# transformation applied is a similarity such that 
#    segment [pa1, pb1] is transformed into segment [pa2, pb2]

transform:= proc(pa1, pb1, pa2, pb2, l)
	local angle_rot, hom_ratio, ptransf, lr, p, dist;
	
	# translation
	dsegment(tseg, pa2, pa1);
	
#	pdisplay("pa1 : ", pa1):
#	pdisplay("pb1 : ", pb1):
#	pdisplay("pa2 : ", pa2):
#	pdisplay("pb2 : ", pb2):
	
	# homothety/rotation
	
		# if coincident points (could happen) => only translation (ie angle=0, homo = 1)
	dist:= distance(pa2,pb2);
	if dist = 0 then 
		# printf("In transform : same points : %d %d, %d %d\n", coordinates(pa2)[1], coordinates(pa2)[2], coordinates(pb2)[1], coordinates(pb2)[2]);  
		angle_rot := 0.;
		hom_ratio := 1.;
	else 
		# rotation
		angle_rot:= angle(pa2, pb2, pa1, pb1);
	#	printf("ang : %f (%f deg)\n", angle_rot, (angle_rot/Pi)*180);
		# homothetie
		hom_ratio:= distance(pa1, pb1)/distance(pa2,pb2);
	fi;

	# apply on each point of l
	lr:=[];
	for p in l do
		ptransf := ptransform(p, tseg, angle_rot, hom_ratio, pa1);
		lr:=[op(lr), ptransf];
	end do;
	
	return lr;
end proc:


# test

#############################################
#
#  Test 
#     

local test:
test:=false:    # toggle execution

if test then 
	point(pA, 10,11);
	point(pB, 15,11);
	point(pC, 12,14.5);

	point(p0, 0, 0);
	point(p1, 5, 0);
	lt := transform(p0, p1, pA, pB, [pA,pB,pC]);
	detail(lt);
	roundPointList(lt);	
	detail(lt);
fi:

