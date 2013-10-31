// camera module draw tube that slides into the telescope nosepiece.
// Front surface of circuit board is 
include <dimensions.scad>

$fs=0.25;

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
    rotate([0,0,-90])
    {
        union()
        {
            // Cube of camera
            translate([-CM_camera_square[0]/2,-CM_camera_square[1]/2,0])
                cube(CM_camera_square);
            translate(CM_top_connector[1]) cube(CM_top_connector[0]);

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
    rotate([0,0,-90]) translate(CM_optical_center * -1)
    {
        for ( i = [0:1])
        {
            for (j=[0:1])
            {
                translate([CM_hole_zero[0] + i*CM_hole_space[0], CM_hole_zero[1] + j*CM_hole_space[1], 0])
                    cylinder(h=2*CM_hole_extra_length, r=CM_hole_dia/2, center=true);
            }
        }
    }
}

module plate()
{
    union()
    {
        translate(PI_board_size * -0.5) {
            difference() {
                hull() {
                    for (i = [0:1])
                    {
                        translate(PI_mounthole_locs[i]) 
                            cylinder(h=plate_thickness,r=mounthole_out_radius);
                    }
                    translate(PI_board_size * 0.5)
                        cylinder(h=plate_thickness,r=drawtube_OD/2 + flange_stepsize);
                    translate(PI_board_size * 0.5) // Move center to center of board
                        rotate([0,0,-90]) 
                            translate(CM_optical_center * -1 + [1,1])   // Stretch 1 mm beyond CM board on all 4 edges
                                cube([CM_size[0]+2,CM_size[1]+2,plate_thickness]);
                }
                for (i = [0:1])
                {
                    translate(PI_mounthole_locs[i]) 
                        cylinder(h=3*plate_thickness,r=PI_mounthole_dia/2,center=true);
                }
            }
        }
        // LED dome positive space
        difference()
        {
            rotate([0,0,-90]) 
                translate(CM_optical_center * -1 + CM_LED_location)
                    resize(CM_LED_dome_size) sphere();
            translate([-50,-50,-100]) cube([100,100,100]);
        }
    }
}

module drawtube_assembly()
{
    difference() {
        union() {
            drawtube_and_flange();
            plate();
            // baffles();
        }
        CM_mountholes();
        CM_keepout();
    }
}

render(convexity=5) drawtube_assembly();
//render(convexity=5) baffles();
