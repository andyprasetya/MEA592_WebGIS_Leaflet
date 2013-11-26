MEA592: WebGIS: Publishing GRASS GIS data using Leaflet
=======================================================

Assignment about publishing data on web using GRASS GIS and Leaflet
JavaScript library for the course *Special Topics Course:*
*Multidimensional Geospatial Modeling*
(http://courses.ncsu.edu/mea592/common/GIST_MEA592005.html).

The main document is ``from_grass_to_leaflet_assignment.rst``.
The slides with basic terminology can be generated
from ``leaflet_basics_lecture.rst``.

HTML files are example or base files for the assignment.
The ``style.css`` file is a file usable as a CSS for HTML
generated from reStructuredText files (``.rst``). This
can be done using ``create_documents.sh`` script (requires
*pandoc* and *LaTeX*).

The repository contains the Leaflet library distribution downloaded
from http://leafletjs.com/ (BSD-style license). It is contained in
the directory ``lib_leaflet``. This simplifies deployment on
some servers (``http`` versus ``https`` issue) and also it can make the
page a bit faster. However, it should be updated with a new release.
