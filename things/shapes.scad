
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
        translate(PI_optical_center * -1) 
        {
            for (i = [0:1])
            {
                translate(PI_mounthole_locs[i]) 
                    cylinder(h=thickness,r=mounthole_out_radius);
            }
        }
        cylinder(h=thickness,r=drawtube_OD/2 + flange_stepsize);
        translate(backplate_cavity[1] + -1 * [1,1]) // Move center to center of board
            cube([backplate_cavity[0][1] + 2,backplate_cavity[0][1] + 2,thickness]);  // Stretch 1 mm beyond CM board cavity on all 4 edges
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
                    cylinder(h=2*(plate_thickness + backplate_thickness),r=PI_mounthole_dia/2 + hole_expansion,center=true);
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
    for (i = [0:1])
    {
        translate([0,i*CM_hole_space[0],0])
            translate(first_rail[1])
                cube(first_rail[0]);
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


include <dimensions.scad>
