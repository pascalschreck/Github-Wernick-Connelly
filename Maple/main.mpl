
read("./dealProblemsFromFile.mpl"):

######################
#   Main

 # choose a triangle 
point(pA, 0, 0):
point(pB, 20, -13):
point(pC, 17, 8):

 # analyse list
 
 # file is a variable given as argument in command line
file:=convert(file,string):
file:=StringTools[DeleteSpace](file):

if not FileTools[Exists](file) then
	printf("Error : %s : no valid filename\n", file);
	printf("try for instance : maple -q -c \"file:=woutput\" main.mpl \n");
    quit;
fi:

randomize():
dealProblemsFromFile(file, pA, pB, pC);
