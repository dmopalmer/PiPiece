PiPiece
=======

Electronic eyepiece for telescopes etc. using the Raspberry Pi camera module.

Homepage  
========  
The latest version of this project will be at its homepage  
https://github.com/dmopalmer/PiPiece  


Parts
=====

This is an electronic eyepiece for a telescope or other optical system, built from a Raspberry Pi and its camera module.    (You can currently get a Model A Raspberry Pi and camera module for $40 as a bundle, e.g. <http://www.alliedelec.com/Search/ProductDetail.aspx?SKU=70315057>)  You will also need an SD card with the operating system, power supply, and case for the Raspberry Pi.  For convenience and cordlessness, you can add a USB WiFi dongle and a USB battery.

Print a drawtube and a backplate for the appropriate eyepiece tube size for your telescope.  (Common sizes are 0.965", 1.25", and 2.0".)  Use black filament to reduce internal reflections.  The Makerbot Customizer on Thingiverse did not work correctly, so I have manually generated all part x size permutations.  If you want a different size, look at the {backplate,drawtube}_size.scad files to see how to do it with OpenSCAD.

A couple of small-diameter nuts and bolts hold the two printed parts together and onto the case to make a single solid unit.  (I used #3-48 x 3/4 inch bolts.)  


Assembly Instructions
=====================

http://www.thingiverse.com/thing:181310 has some pictures that might be helpful.

You will probably have to drill out the various holes. On the drawtube component, there are 4 holes for the mounting pins from the backplate, and the relief cavity for the LED on the camera module.  Then clamp the pieces together onto the lid of your Raspberry Pi case, and drill out the mounting screw holes for the appropriate sized bolts you are using.  Cut a slot in the Raspberry Pi case to accomodate the cable.

The spacing between the holes is the same as for the Raspberry Pi version 2 mounting holes, so if you don't want to use a case you can mount the assembly directly to the board using stand-offs.

Carefully remove the lens from the camera module, breaking or scraping away the glue and unscrewing the lens.  The system is now susceptible to dust, so try to keep it clean.

Put everything together, slide it into an eyepiece tube, and try it out.

Focusing and Pointing
======================

The focus is very sensitive and the focal point is probably going to be quite far from what it is with your favorite eyepiece.  Use an eyepiece to focus your telescope on something nearby, then further away, and note which direction you turn the focus knob.  With this imager you will probably have to turn quite a ways in the same direction (well 'beyond infinity') to get it in focus.  A daytime scene is probably the best way to start.  When the system is out of focus, you will probably see nothing but a uniform flat field, apart from the shadows of all the dust that got on the imager.

The field of view is very small due to the size of the imager.  The sensor size is  3.67 x 2.74 mm (2592 x 1944 pixels at 1.4 microns each.)  A 2000 mm focal length telescope (e.g. a Celestron 8) will have a 6.3 x 4.7 arcminute FOV.  (The Moon is 30 arcminutes across.  Venus and Jupiter can get up to ~an arcminute across and Mars half that at the closest points of their orbits.)  Therefore you will want to carefully align your finderscope.

Software
========

You want to turn off the camera LED to prevent light leakage.  Add the following in /boot/config.txt on the Raspberry Pi's SD card:
disable_camera_led=1

If you want to serve the output of raspistill on the web, you can use PiCamServer
https://github.com/dmopalmer/picamserver.git
which is slow in frame rate, but gives you control and lets you play with parameters from your browser (even on iThings, androthings, etc.).

Or if you have mplayer installed on a desktop you can use that for higher rate video:
The following is to serve 3 fps video, with maximum ISO rating, to a desktop at 192.168.0.43:

On the Pi (with raspivid parameters set for 3 Hz frame rate) :
mkfifo /tmp/buffer
raspivid -t 999999 -o  /tmp/buffer -fps 3 -ss 300000 --ISO 800 --exposure night &
nc  192.168.0.43 5001 < /tmp/buffer

On the desktop:
nc -l  5001 | mplayer -fps 3.1 -cache 1024 -

If you also want to record to a file on your local desktop:
nc -l  5001 | tee /tmp/recording.h264 | mplayer -fps 3.1 -cache 1024 -



