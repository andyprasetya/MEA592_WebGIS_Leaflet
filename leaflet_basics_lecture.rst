HTML
====

XHTML
-----

HTML5
-----

JavaScript
==========

CSS
===

jQuery
======

Leaflet
=======



Appendix: How this document was written
=======================================


Generate LaTeX Beamer file from ``.rst``::

    pandoc --from=rst --to=beamer --output=leaflet_basics.tex 
    leaflet_basics.rst

Compile ``.tex`` file using LaTeX and produce PDF::

    pdflatex -interaction=nonstopmode leaflet_basics.tex 

Links
-----

* http://docutils.sourceforge.net/rst.html
* http://johnmacfarlane.net/pandoc/


