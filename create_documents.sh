#!/bin/bash

pandoc --from=rst --to=html --toc --css=style.css --output=from_grass_to_leaflet_assignment.html from_grass_to_leaflet_assignment.rst

pandoc --from=rst --to=html --toc --css=style.css --output=leaflet_basics_lecture.html leaflet_basics_lecture.rst

pandoc --from=rst --to=beamer --standalone --output=leaflet_basics_lecture.tex leaflet_basics_lecture.rst
pdflatex -interaction=batchmode leaflet_basics_lecture
pdflatex -interaction=batchmode leaflet_basics_lecture
