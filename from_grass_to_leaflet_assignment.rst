Introduction
============

We will do some re-projecting of our data in GRASS GIS,
use some temporal modules but most importantly we will play with a web
page which uses Leaflet JavaScript library.


Visualizing one image
=============================


Required data
-------------

You need a raster map in one of you locations. Here we will use
Jockey's Ridge mapset in GRASS NC location and a ``elev_2008_1m`` map.


Required files
--------------

You need to have file named ``image_page.html`` which we will
change to work better for us.


Create a new location
---------------------

Run GRASS 7 and create a new location.

In the GRASS start window press *Location wizard* button. Then do
the following steps:

* Fill *Project location:* with ``WebPublishing``.
* Press *Next* button.
* Choose *Select EPSG code of spatial reference system*.
* Press *Next* button.
* Enter 3857 or search for Pseudo-Mercator and select it.
* Press *Next* button.
* Select default datum transformation by OK.
* Press *Finish* button.

Then it asks if you want to create a default window now, answer *No*.
Then it asks about creating new mapset, press *Cancel*.
GRASS should now start into the newly created location.


Create an image in the new location
-----------------------------------

First we need to get the region of the map in our location. For this we
can use the ``-g`` flag of ``r.proj`` module and than use the output
as parameters of ``g.region``.

::

    r.proj -g input=elev_2008_1m location=nc_with_JR_2 mapset=Jockeys_Ridge

    g.region n=4270922.09347821 s=4268787.89625643 w=-8420899.5137449 e=-8417871.6944515 rows=1650 cols=2400

With the right region settings we can now re-project (import) the map
from the old location to our new location.

::

    r.proj input=elev_2008_1m location=nc_with_JR_2 mapset=Jockeys_Ridge

The export to PNG image is best done by ``r.out.png`` which uses
the current computational region. The ``-t`` flag ensures that the NULL
cells will be transparent.

::

    r.out.png -t input=elev_2008_1m output=.../jr_elev_2008_1m_EPSG3857.png

Now we need to know the latitude and longitude of our map because we
will need it for the web page. ``r.info`` module gives us a map
extent in projected coordinates which we can project (transform) to
WGS84 latitude and longitude using ``m.proj`` module. The input is
a file with coordinates in order easting, northing (longitude,
latitude). Here we are using unix-like command line syntax to provide
a standard input to the module. In GUI you can put the coordinates
to the box labeled *or enter values interactively*.

::

    r.info map=elev_2008_1m -g
    m.proj -o -d input=- separator=space <<EOF
    -8417871.6944515 4270922.09347821
    -8420899.5137449 4268787.89625643
    EOF

The order of coordinates is important, so make sure that you entered
EN for the first line and WS for the second line. The output is in the
same order and should be::

    -75.61902803 35.96654003
    -75.64622739 35.95095306


Add the image to the web page
-----------------------------

Now we need will add the image to the Leaflet web page.
Put the file ``image_page.html`` to the same directory as
you saved the exported image.

Open the web page in web browser and in the text editor.

Now you need to find the places in the web page to insert the following
lines (this should be easy because some of the lines are actually
already there and you just need to change them).

Insert the file name::

    var imageUrl = 'jr_elev_2008_1m_EPSG3857.png';

The file name should be relative file path to the ``image_page.html``
file, so if they are in the same directory, the file name is enough.

Insert the coordinates::

        var imageBounds = [[35.95095306, -75.61902803],
                           [35.96654003, -75.64622739]];

Note that the coordinates are in the order SE, NW which differs from
the order outputted from ``m.proj`` which is EN, WS (different corners
are used to define the map extent).

Reload the page in the web browser and see the result. If you don't
see anything or you don't see what you expected, you have to open
developer tools in you web browser. In Firefox, go to main menu::

    Tools --> Web Developer --> Toggle tools

In Chrome or Chromium go to main menu::

    Tools --> Developer Tools

In Firefox, there is even a JavaScript editor Scratchpad in::

    Tools --> Web Developer --> Scratchpad

There is a lot of other tools including debugger often build-in in all
web browsers, check the Internet for suggestions if what you learned
so far, is not enough for you.


Improving the web page
----------------------

Now we will edit the ``image_page.html`` web page to something
more than what the existing page provides to us.

Add a new base layer::

    // create MapQuest layer
    var mapquestUrl = 'http://oatile{s}.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.png';
    var subDomains = '1234';
    var mapquestAttrib = 'Imagery &copy; <a href="http://open.mapquest.co.uk" target="_blank">MapQuest</a>';
    var mapquest = new L.TileLayer(mapquestUrl, {maxZoom: 18, attribution: mapquestAttrib, subdomains: subDomains});

Create two layers with different opacities::

    var imageLayer10 = L.imageOverlay(imageUrl, imageBounds, {opacity: 1.0});
    var imageLayer05 = L.imageOverlay(imageUrl, imageBounds, {opacity: 0.5});

Decide which layer should be visible at the beginning::

    var map = L.map('map', {
         center: imageCenter,
         zoom: 14,
         layers: [osmLayer, imageLayer10]
     });

Create lists of all layers (base layers and overlays)::

    var baseLayers = {
        "Open Street Map": osmLayer,
        "MapQuest imagery": mapquest
    };

     var overlayLayers = {
         "Opaque elevation": imageLayer10,
         "Transparent elevation": imageLayer05
     };

Create a layer control with all layers::

    var layerControl = L.control.layers(baseLayers, overlayLayers);


Visualizing a time series using r.out.leaflet
=============================================

Required data
-------------

You need a time series of raster maps in one of you locations. Here we
will use Jockey's Ridge mapset in GRASS NC location and elevation maps
for several years.


Required files
--------------

You need a file named ``animation_page.html`` delivered with this
assignment. You also need to create a directory named ``data`` at the
same place where ``animation_page.html`` file is.

Moreover, we need two Python files ``r.out.png.location.py`` and
``r.out.leaflet.py`` which we will use to export our maps. Depending
on you system and how you obtained these two files you will need to
change the ``r.out.leaflet`` module call::

    r.out.leaflet ...

to something like this::

    python r.out.leaflet.py ...

or even this::

    absolute/path/to/python r.out.leaflet.py ...


Register maps into the temporal database
----------------------------------------

Run GRASS 7 in you old Jockey's Ridge location.

Create a spatio-temporal raster dataset from your Jockey's Ridge
elevation maps if you haven't done so. Start by creating a dataset::

    t.create output=js_elev temporaltype=relative semantictype=mean \
             title="Jockeys Ridge elevation" \
             description="Jockeys Ridge degital elevation model for the years 1974-2009"

Get the list of of you maps::

    g.mlist type=rast pattern="elev_be_19.._1m$" sep=, -em
    g.mlist type=rast pattern="elev_200._1m$" sep=, -em

Here we are using ``g.mlist`` and regular expressions (``-e`` flag) but
you can also use standard ``g.list``. Just note that you need the maps
including their mapsets.

Now register maps into the temporal database and assign to the temporal
dataset::

    t.register input=js_elev@Jockeys_Ridge file=- unit=years separator=, <<EOF
    elev_be_1974_1m@Jockeys_Ridge,1974
    elev_be_1995_1m@Jockeys_Ridge,1995
    elev_be_1998_1m@Jockeys_Ridge,1998
    elev_2001_1m@Jockeys_Ridge,2001
    elev_2007_1m@Jockeys_Ridge,2007
    elev_2008_1m@Jockeys_Ridge,2008
    elev_2009_1m@Jockeys_Ridge,2009
    EOF

Here again we are using unix-like syntax to provide standard input for a
module instead of using a file. In GUI you can just use a field labeled
*or enter values interactively*.


Export of the temporal dataset
------------------------------

Now you can use ``r.out.leaflet`` module to automatically export
spatio-temporal dataset in the way which is acceptable by the prepared
web page ``animation_page.html``. Currently the
``r.out.leaflet`` module supports only a spatio-temporal raster dataset,
so we don't have to think about any other options and use our Jockey's
Ridge temporal dataset. However, for start we might want to use the
``where`` option which allows us to limit the time extent of exported
maps. Finally, we need to set the output directory into which the module
will output all data.

::

    r.out.leaflet strds=js_elev@Jockeys_Ridge where="start_time > 2005" \
                  output=.../leaflet/data

If everything is as we expected we can export the whole temporal
dataset::

    r.out.leaflet strds=js_elev@Jockeys_Ridge output=.../leaflet/data

Once we provided needed data (exported images and a metadata file which
was also exported), the ``animation_page.html`` web page will take
care of the rest. So, the only thing we need to do is to open this page
in a web browser. You can now distribute the ``animation_page.html``
file together with ``data`` directory and it will work on local
machines and also placed on server.


Appendix: Alternative ways to determine the map LL extent
=========================================================

Use ``g.region`` in the new location dedicated for exporting::

    g.region -lg

The SE and NW corners should be directly usable for Leaflet page, e.g.::

    se_long=-75.61902249
    se_lat=35.95094856
    nw_long=-75.64623293
    nw_lat=35.96654453

Alternatively, we can use ``r.info`` and ``m.proj`` in the old
location and get for example this numbers::

    914500 251000
    912100 249350

    -75.61902230 35.96581101
    -75.64623312 35.95168195

However, when writing this text, I was getting different results than
when using ``r.info`` and ``m.proj`` in the location for exporting
which give a numbers which were working well (image was placed
properly).


Appendix: Alternative ways to export map as an image
====================================================

It is also possible to export an image using Map display window which
has the great advantage of combining different raster and vector layers
together. The disadvantages are that the NULL values and places without
vector features are not transparent and that it is not scriptable (you
can only use GUI). However, it might be possible to add the transparency
afterwards using GIMP, ImageMagic or other graphical program. But
nothing is easier that ImageMagic magic, so::

    convert jr_2008-white_bg.png -transparent white jr_2008-tr.png

Remember to set your Map display background to white or other color
which does not conflict with colors of you maps (you must than change
the ImageMagic command). Also remember that the extent you need to put
into the Leaflet page as image bounds is now extent of the display not
the one of the map or computational region.

The other possibility is to use ``r.out.gdal`` which also does not
support transparency. But it might support that in the future as well as
the Map display can, so I would not abandon these options completely.


Appendix: Using commands provided in this assignment
====================================================

Here we are using commands spitted on several lines using backslash
``\`` at the end of line, e.g.::

    r.out.leaflet strds=js_elev@Jockeys_Ridge where="start_time > 2005" \
                  output=.../leaflet/data

This works well in the command line on Unix-like systems, however it
does not work for *Command console* in GRASS Layer Manager. You have
to join the lines and delete backslashes if you are not using the
command line on Unix-like systems.

When the module gets some file as an input and in the same time accepts
also standard input instead of file (e.g. ``input=-``) we are providing
the standard input by using ``<<EOF`` syntax::

    m.proj -o -d input=- separator=space <<EOF
    -8417871.6944515 4270922.09347821
    -8420899.5137449 4268787.89625643
    EOF

Again, this works well in the command line on Unix-like systems and
does not work in GRASS *Command console*. You need to use the large
input box in GRASS module form or to create a file and provide the name
of this file if you are not using the command line on Unix-like systems.


Appendix: Publishing online map through Google Drive
====================================================
This will allow you to publish your leaflet map by adding your files to Google
Drive and then you can even display it on your course Google site. 

1. Create a new folder on Google Drive and make it public (*Public on the web*).
2. Upload your files to this folder, your main html file should be called ``index.html``.
3. When you are in this folder (in Google Drive), copy the long hash name (something like ``0B7CQoT4YE2mMV2VkeXlQSUs0LUd``) and put it after ``https://googledrive.com/host/``, this is now the URL of your map.
4. If everything works, when you display the URL in a browser, you should see the leaflet map.

Adding your map to your course Google Site:

1. Start editing the page.
2. Go to *Insert* -> *More Gadgets* -> choose iframe (the second one) -> *Select* -> insert the URL and optionally set size, title -> *OK*
3. The possible result is https://sites.google.com/a/ncsu.edu/petrasova_mea582fall2013/home/leaflet

Troubleshooting
---------------
If the map URL is not working for you, make sure you have downloaded the ``lib_leaflet``
and changed the links in the code to link to this library.
Also check that all jquery links start with ``//`` and not with ``http://``.
These changes are now reflected in the code (so you can look how it should look like),
but you might have downloaded the code before the change.
These links are needed in order to make the links accessible from https protocols (used by Google Drive).

