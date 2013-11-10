PiPiece
=======

Electronic eyepiece for telescopes etc. using the Raspberry Pi camera module.


Assembly Instructions
=====================

Print a drawtube and a backplate for the appropriate eyepiece tube size for your telescope.  (Common sizes are 0.965", 1.25", and 2.0".)  Use black filament ot reduct internal reflections.

You will probably have to drill out the various holes. On the drawtube component, 4 holes for the mounting pins from the backplate, and the relief hole for the LED on the camera module.  Then clamp the pieces together onto the lid of your Raspberry Pi case, and drill out the mounting screw holes for the appropriate sized bolts you are using.  (I used #3-48 x 3/4 inch bolts.)  Cut a slot in the Raspberry Pi case to accomodate the cable.

The spacing between the holes is the same as for the Raspberry Pi version 2 mounting holes, so if you don't want to use a case you can mount the assembly directly to the board using stand-offs.

Carefully remove the lens from the camera module, breaking or scraping away the glue and unscrewing the lens.  The system is now susceptible to dust, so try to keep it clean.

Put everything together, slide it into an eyepiece tube, and try it out.

Focussing and Pointing
======================

The focus is very sensitive and the focal point is probably going to be quite far from what it is with your favorite eyepiece.  Use an eyepiece to focus your telescope on something nearby, then further away, and note which direction you turn the focus knob.  With this imager you will probably have to turn quite a ways in the same direction (well 'beyond infinity') to get it in focus.  A daytime scene is probably the best way to start.  When the system is out of focus, you will probably see nothing but a uniform flat field, apart from the shadows of all the dust that got on the imager.

The field of view is very small due to the size of the imager.  The sensor size is  3.67 x 2.74 mm (2592 x 1944 pixels at 1.4 microns each.)  A 2000 mm focal length telescope (e.g. a Celestron 8) will have a 6.3 x 4.7 arcminute FOV.  (The Moon is 30 arcminutes across.  Venus and Jupiter can get up to ~an arcminute across and Mars half that at the closest points of their orbits.)  Therefore you will want to carefully align your finderscope.

Software
========

You want to turn off the camera LED to prevent light leakage.  Add the following in /boot/config.txt
disable_camera_led=1
