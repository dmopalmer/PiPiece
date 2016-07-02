// PiPiece
// Eyepiece for Raspberry Pi Camera Module on a telescope
// The latest version of these files will be at
// <https://github.com/dmopalmer/PiPiece>
//
// David Palmer
// dmopalmer at gmail.com
// Distributed under GPL version 2
// <http://www.gnu.org/licenses/gpl-2.0.html>

// Designed to use customizer at thingiverse
// <http://www.makerbot.com/blog/2013/01/23/openscad-design-tips-how-to-make-a-customizable-thing/>

// Diameter of drawtube (inside diameter of eyepiece holder tube) in inches
Drawtube_OD_inches = 1.25; // [0.965,1.25,2.0]

// Part
part = "drawtube"; // [backplate:Back Plate, drawtube:Drawtube, both:Both parts]

// Customizer only looks for variables up to the first module.
module stop_customizer(){}

Drawtube_OD_inches_used = (Drawtube_OD_inches_explicit==undef) ? Drawtube_OD_inches : Drawtube_OD_inches_explicit;
part_used = (part_explicit==undef) ? part : part_explicit;

echo("Using Drawtube_OD_inches = ",Drawtube_OD_inches," and part = ",part);
print_part();

module print_part()
{
    if (part_used == "backplate") {
        backplate();
    } else if (part_used == "drawtube") {
        drawtube_assembly();
    } else if (part_used == "both") {
        translate([0,50,backplate_thickness]) backplate();
        drawtube_assembly();
    }
}

// The camera board by my measurement is 25.10 mm wide, 24.22 mm top-bottom

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

drawtube_OD = 25.4 * Drawtube_OD_inches_used; // Popular sizes for telescopes are 0.965", 1.25", 2.0"
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


// SHAPES

// Centered on z axis with cyl symmetry, going from  Z=[0,length]
module drawtube_and_flange()
{
    difference() {
        union() {
            cylinder(h=drawtube_length+flange_parfocal,r=drawtube_OD/2,center=0);
            cylinder(h=flange_parfocal,r=drawtube_OD/2 + flange_stepsize,center=0);
        }
        cylinder(h=2.1*(drawtube_length+flange_parfocal),r=drawtube_OD/2-drawtube_wall,center=1);
    }
}


module baffles()
{
    intersection()
    {
        for ( z = [flange_parfocal:baffle_spacing:drawtube_length+flange_parfocal ])
        {
            difference() 
            {
                translate([0,0,z+baffle_thickness]) cylinder(h=baffle_cone_height,r1=drawtube_OD/2,r2=0.1);
                translate([0,0,z                 ]) cylinder(h=baffle_cone_height,r1=drawtube_OD/2,r2=0.1);
            }
        }
        cylinder(h=drawtube_length+flange_parfocal,r=drawtube_OD/2,center=0);
    }
}
 

// Keepout space for camera module
// Oriented centered on the lens, facing +Z, cable out -X, top surface at Z=0
module CM_keepout()
{
    // Light cone keepout
    nose_ID = drawtube_OD - 2*drawtube_wall;
    lightcone_height = (nose_ID - (2 + CMOS_diagonal) ) * optics_f_ratio;
    rotate([0,0,90])
    {
        union()
        {
            // Cube of camera
            translate([-CM_camera_square[0]/2,-CM_camera_square[1]/2,0])
                cube(CM_camera_square);
            translate(CM_top_connector[1]) cube(CM_top_connector[0]);
            
            // Enlarged space for version 2 of the camera module
           translate([-10,5,-1]) cube([6,6,5])

            // camera and connector on top
            translate(CM_optical_center * -1)
                translate(CM_LED_location)
                    resize(CM_LED_hollow_size) sphere();
            
            cylinder(h = lightcone_height, r1 = CMOS_diagonal, r2= nose_ID/2);
        }
    }
}
 
module CM_mountholes()
{   
    rotate([0,0,90]) translate(CM_optical_center * -1)
    {
        for ( i = [0:1])
        {
            for (j=[0:1])
            {
                translate([CM_hole_zero[0] + i*CM_hole_space[0], CM_hole_zero[1] + j*CM_hole_space[1], 0])
                    cylinder(h=2*CM_hole_extra_length, r=CM_hole_dia/2 + hole_expansion, center=true);
            }
        }
    }
}

module CM_mountpins()
{   
    rotate([0,0,90]) translate(CM_optical_center * -1)
    {
        for ( i = [0:1])
        {
            for (j=[0:1])
            {
                translate([CM_hole_zero[0] + i*CM_hole_space[0], CM_hole_zero[1] + j*CM_hole_space[1], -backplate_thickness])
                    cylinder(h=backplate_thickness+plate_thickness, r=CM_hole_dia/2, center=false);
            }
        }
    }
}

// Slab for either the front or back plate, with the given thickness
// z in range [0,thickness], optical axis centered at [0,0,z]
// No holes included
module plate_slab(thickness)
{
    hull() 
    {
        // Fit the mounting holes and a margin aroudn them
        translate(PI_optical_center * -1) 
        {
            for (i = [0:1])
            {
                translate(PI_mounthole_locs[i]) 
                    cylinder(h=thickness,r=mounthole_out_radius);
            }
        }
        // And also fit camera module cavity expanded by 1 mm
        translate([backplate_cavity[1][0] - 1, backplate_cavity[1][1] - 1, 0])
            cube([backplate_cavity[0][0] + 2,backplate_cavity[0][1] + 2,thickness]);  // Stretch 1 mm beyond CM board cavity on all 4 edges
        // Fit the flange for the drawtube
        cylinder(h=thickness,r=drawtube_OD/2 + flange_stepsize);
    }
}


module PI_mount_screw_keepout()
{
    // mount screw and Washer keepouts
    translate(PI_optical_center * -1) 
    {
        for (i = [0:1])
        {
            translate(PI_mounthole_locs[i])
            {
                union()
                {
                    cylinder(h=2*(plate_thickness + backplate_thickness),
                            r=PI_mounthole_dia/2 + hole_expansion,center=true);
                    translate([0,0,plate_thickness - 0.1])
                        cylinder(h=2*plate_thickness+flange_parfocal,r=mounthole_washer_radius);
                }
                    
                    
            }            
        }
    }
}

module frontplate()
{
    union()
    {
        
        difference() {
            plate_slab(plate_thickness);
            for (i = [0:1])
            {
                translate(PI_mounthole_locs[i] - PI_optical_center) 
                    cylinder(h=3*plate_thickness,r=PI_mounthole_dia/2 + hole_expansion,center=true);
            }
        }
        // LED dome positive space
        difference()
        {
            rotate([0,0,90]) 
                translate(CM_optical_center * -1 + CM_LED_location)
                    resize(CM_LED_dome_size) sphere();
            translate([-50,-50,-100]) cube([100,100,100]);
        }
    }
}

module backplate()
{
    difference()
    {
        translate([0,0,-backplate_thickness]) plate_slab(backplate_thickness);
        PI_mount_screw_keepout();
        translate(backplate_cavity[1]) cube(backplate_cavity[0]);
        translate(backplate_slot[1]) cube(backplate_slot[0]);
    }
    CM_mountpins();
    difference ()
    {
        for (i = [0:1])
        {
            translate([0,i*CM_hole_space[0],0])
                translate(first_rail[1])
                    cube(first_rail[0]);
        }
        // Space for components on module version 2
        translate([-10,-13,first_rail[1][2]])
            cube([6,27,8]);
    }
}

module drawtube_assembly()
{
    difference() {
        union() {
            drawtube_and_flange();
            frontplate();
            // baffles();
        }
        PI_mount_screw_keepout();
        CM_mountholes();
        CM_keepout();
    }
}

