include <MCAD/units/metric.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>

wall_thickness = 5;
base_length = 40;
arm_thickness = 10;
arm_length = 30;
arm_overturn_angle = 10;

base_dimensions = [base_length, arm_thickness + wall_thickness * 2,
    wall_thickness];
screw_d = M3;
hinge_axle_d = screw_d + 0.3;
overall_height = (base_dimensions[2] + wall_thickness + hinge_axle_d / 2 +
    arm_thickness / 2);

mode = "plater";              //"assembly" for assembly, "plater" for plater

$fs = 0.5;
$fa = 1;

module base ()
{
    module place_screwhole ()
    translate ([0, 0, base_dimensions[2] + arm_thickness / 2])
    rotate (-90, X)
    children ();

    difference () {
        hull () {
            translate ([0, 0, base_dimensions[2] / 2])
            cube (base_dimensions, center=true);

            place_screwhole ()
            cylinder (d=arm_thickness, h=base_dimensions[1],
                center=true);
        }

        place_screwhole ()
        translate ([0, 0, -base_dimensions[1] / 2 - epsilon])
        polyhole (d=hinge_axle_d, h=base_dimensions[1] + epsilon * 2);

        translate ([0, 0, base_dimensions[2] + overall_height / 2])
        cube ([base_length + epsilon * 2, arm_thickness + 0.6,
                overall_height],
            center=true);

        place_screwhole ()
        translate ([0, 0, base_dimensions[1] / 2 - 0.6 * hinge_axle_d])
        polyhole (d=hinge_axle_d * 2, h=wall_thickness);

        place_screwhole ()
        translate ([0, 0, -base_dimensions[1] / 2 - epsilon * 2])
        nutHole (size=screw_d, tolerance=0.1);
    }
}

module arm ()
{
    difference () {
        rotate (arm_overturn_angle, Y)
        union () {
            rotate (90, X)
            cylinder (d=arm_thickness, h=arm_thickness, center=true);

            translate ([arm_length / 2 + arm_thickness / 2, 0, 0])
            cube ([arm_length + arm_thickness, arm_thickness, arm_thickness], center=true);
        }

        translate ([0, 0, -arm_thickness / 2])
        translate ([arm_length, 0, -arm_thickness])
        cube ([arm_length * 2, arm_thickness * 2, arm_thickness * 2],
            center=true);

        translate ([arm_length * 2, 0, 0])
        cube ([arm_length * 2, arm_thickness * 2, arm_thickness * 2],
            center=true);

        rotate (90, X)
        translate ([0, 0, -arm_thickness / 2 - epsilon * 2])
        polyhole (d=hinge_axle_d, h=arm_thickness + epsilon * 4);
    }
}

if (mode == "assembly") {
    base ();

    translate ([0, 0, base_dimensions[2] + arm_thickness / 2])
    arm ();
} else if (mode == "plater") {
    base ();

    translate ([0, base_dimensions[1] + 2, arm_thickness / 2])
    rotate (90, X)
    arm ();
}
