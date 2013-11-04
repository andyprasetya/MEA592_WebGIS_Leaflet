HTML
====

* the page content

::

    <p>Jockey's Ridge elevation created in
    <a href="http://grass.osgeo.org/">GRASS GIS</a>.


XHTML
-----

* strict XML


HTML5
-----

* new version of HTML (new tags)
* the thing to be used
* usually means also CSS and JavaScript
* can also be expressed as XHTML


CSS
===

* the page style

::

    em {
        font-weight: normal;
        font-style: italic;
    }

::

    html, body, #map {
        height: 100%;
    }


JavaScript
==========

* the behavior of the page

::

    // create image overlay layers
    var imageLayersTitles = new Array();

    for(var i = 0; i < layerInfos.length; i += 1) {
        layerInfo = layerInfos[i];
        imageLayersTitles.push(layerInfo.title);
    }


jQuery and jQuery UI
====================

* very famous JavaScript libraries

::

    $(function() {
        $( "#next" )
            .button()
            .click(function( event ) {
                nextImageLayer();
                event.preventDefault();
            });
    });


Leaflet
=======

* JavaScript library for interactive maps
* simpler alternative to OpenLayers

::

    var osmLayer = L.tileLayer(
        'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
        {
            minZoom: 1,
            maxZoom: 18,
            attribution: '&copy; OpenStreetMap...'
        }
    );

