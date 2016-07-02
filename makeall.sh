#! /usr/bin/env bash
#for part in backplate drawtube ; do
#    for size in 0.965 1.25 2.0 ; do
#        size_underscore=$(echo -n $size | tr '.' '_')
#        echo openscad -D Drawtube_OD_inches_explicit=$size -D part_explicit=$part things/pipiece.scad -o things/${part}_${size_underscore}.stl
#    done
#done

cd $(dirname $0)/things
for f in *_*_*.scad ; do
    openscad ${f} -o $(basename $f .scad).stl
done
