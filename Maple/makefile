
all :
	@echo "choose a target : modules|one"

one : 
	@maple -q -c "file:=../woutput" main.mpl
	
modules :
	@echo -n "Create module : Wernick ... "
	@maple -q ../source_wernick_lib.mpl && echo "Done"
