TEXFILES 	= $(wildcard *.tex)
EPSFILES 	= $(wildcard figures/*.eps)
EPSGFILES 	= $(wildcard figures/*.epsg)
STYFILES	= $(wildcard *.sty)

bibliography	= ../Bibliography/biblio.bib

TEX_INCLUDES	= commands.tex

.DUMMY :	all

all:		thesis.ps

# Cancel the old implicit rule which screws things around
%.dvi:		%.tex

# This rule generates a tex file that will generate a document with a
# single chapter (rather than the whole thing)
%-input.tex:	Makefile start-doc.tex end-doc.tex
		cat start-doc.tex > $@
		echo "\include{$(subst -input.tex, ,$@)}" >> $@
		cat end-doc.tex >> $@

# This rule is so that we can make a document that consists of a single
# chapter, rather than the whole thing
%.dvi:		%-input.tex %.tex $(tex_includes) $(STYFILES)
		make -C figures all
		latex $<
		-bibtex $(basename $<)
#		sed 's/([{]part[}].*)[{]([0-9]+)\}/\1\{\}/' thesis.toc
		latex $<
		latex $<
		mv $(subst .tex,.dvi,$<) $@

# The thesis is special, so we make it with a special command
thesis.dvi:	$(TEXFILES) $(BIBLIOGRAPHY) $(STYFILES)
		make -C figures
		latex thesis.tex
		bibtex thesis
		latex thesis.tex
		latex thesis.tex

# Make a DVI file into a postscript one
%.ps:		%.dvi
		dvips -o $@ $<


.DUMMY: 	clean

# Remove all of our files that can be generated from others
clean:
		make -C figures clean
		-rm *~ *.aux *.toc *.log *.dvi *.ps *.lot *.lof *.bbl *.blg \
			*.input.tex *.todo
