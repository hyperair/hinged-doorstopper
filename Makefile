all: hinged-doorstopper.stl

%.stl: %.scad
	openscad -o $@ $<
