
// Diameter of drawtube (inide diameter of eyepiece holder tube) in inches
Drawtube_OD_inches = 1.25;  [0.965,1.25,2.0]

// The camera board by my measurement is 25.10 mm wide, 24.22 mm tope-bottom

// Camera module board dimensions
// These are for the version 1.3 board.
// This is a combination of my caliper measurements and 
// <http://www.raspberrypi-spy.co.uk/2013/05/pi-camera-module-mechanical-dimensions/>

hole_expansion = 0.5;   // Extra radius on holes
// CM -- Camera Module
// Origin is lower left corner looking into lens with cable out the bottom
// We later rotate([0,0,90]) to put the cable out to +x in the Pi board coordinates (USB-side direction)
CM_size = [25.1, 24.22,0];   // My caliper measurement
CM_hole_dia = 2.0;  // Diameter of mounting hole
CM_hole_space = [21.0, 12.5];
CM_hole_zero = [(CM_size[0] - CM_hole_space[0])/2, 9.5];
CM_optical_center = [CM_size[0]/2, 8.5];    // Lens is not well-registered
CM_board_thick_z = 1.0; // Measured as 0.87 exclusive of components
CM_board_and_connector_thick_z = 3.52; // From top of board to back of connector by calipers
CM_LED_location = [20,19];  // Where the LED is
CM_LED_hollow_size = [4,4,3];   // size of hollow to surround LED
CM_LED_dome_size = [5,5,4];     // Size of outside of dome around LED
CM_camera_square = [8,8,4] + [2,2,0];   // Including 2 mm of slop in X,Y   
CM_top_connector = [[10,20,3],[-5,-5,-0.2]];    // Keepout box

CMOS_diagonal = 1.4e-3 * sqrt(pow(2592,2) + pow(1944,2));

// Raspberry Pi rev 2 mounting holes
// http://www.raspberrypi.org/wp-content/uploads/2012/12/Raspberry-Pi-Mounting-Hole-Template.png
// Looking down on the component/connector side of the board, with the USB port to the right
// and the origin at the lower left, the board size is 
PI_board_size = [85,56];
PI_mounthole_locs = [[25.5,18],[80,43.5]];
PI_mounthole_dia = 2.9;

PI_optical_center = [55, 25];   // Where you want to place the central axis of the optical system
                                // Note that there is interference between the [25.5, 18] mounting hole
                                // and the camera board if you try to center it on the board center

drawtube_OD = 25.4 * Drawtube_OD_inches; // Popular sizes for telescopes are 0.965", 1.25", 2.0"
drawtube_length = 20.0;     // Length of drawtube beyond flange (part that extends into nosepiece)
drawtube_wall = 1.5;
flange_parfocal = 4.5;      // How far behind the end of the eyepiece tube to put the board plane
flange_stepsize = 4.0;      // How much the tube steps out to the side to seat on flange

mounthole_out_radius = 5;   // How far from the center of mount holes to the edge of the plate
mounthole_washer_radius = 3.0;  // How much clearance to leave around the top of the mounting hole for washer and screw head

CM_hole_extra_length = 4;   // How long to extend the CM mounting holes into the drawtube assembly

 // Baseplate that goes against the front of the CM circuit board
plate_thickness = 2.5;

optics_f_ratio = 5.0;       // How much clearance to leave the baffles so they don't cut off the incoming light cone

// Each baffle is a conical shell that fills the drawtube, pointing 
// away from the detector, but cut away so the detector can see everything 
// within the f_ratio light path
baffle_thickness = 0.5; // Vertical thickness
baffle_spacing = 5;     // Vertical spacing (not perpendicular)
baffle_cone_height = drawtube_OD * tan(60)/2;   //slope of cone is 60 degrees 

// Plate in which the module is embedded
// the bottom of the plate is at z=-backplate_thickness and the top at z=0
// The coordinate system is the same as for the drawtube
backplate_thickness = 5;

backplate_cavity = [[36,30,4.1],[-17.5, -15, -4]];
// Where you feed out the cable
backplate_slot = [[4,20,2*backplate_thickness],[14.5,-10,-1.5*backplate_thickness]];

first_rail = [[19,3,backplate_thickness-CM_board_thick_z],[-18,-12,-backplate_thickness]];