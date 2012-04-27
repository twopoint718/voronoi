Voronoi Diagrams
================
Quoth the Wikipedia:
> In mathematics, a Voronoi diagram is a special kind of decomposition of a
> given space, e.g., a metric space, determined by distances to a specified
> family of objects (subsets) in the space. These objects are usually called
> the sites or the generators (but other names are used, such as "seeds") and
> to each such object one associates a corresponding Voronoi cell, namely the
> set of all points in the given space whose distance to the given object is
> not greater than their distance to the other objects.

This code generates some pretty*ish* Vornoi diagrams.  The hideous colors are
on me :)

Compile
-------
    ghc --make voronoi -O2

Configure
---------
Edit `points.txt` to describe the *sites* of the diagram, and then edit
`dims.txt` for the dimensions of the diagram.

Run
---
    ./voronoi > output.ppm

The output is in the [Netpbm format](https://en.wikipedia.org/wiki/Netpbm_format#PPM_example)

License
-------
This code is under the GNU GPLv3.  If you want it available under something
different, let's chat :)
