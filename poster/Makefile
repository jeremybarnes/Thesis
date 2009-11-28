poster.ps:	poster.dvi
		dvips -o poster.ps poster.dvi

poster.dvi:	poster.tex poster.eps.prn poster.doc
		latex poster.tex

title.ps:	title.dvi
		dvips -o title.ps title.dvi

title.dvi:	title.tex poster.eps.prn poster.doc
		latex title.tex

