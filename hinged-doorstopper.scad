include <MCAD/units/metric.scad>
use <MCAD/shapes/polyhole.scad>

wall_thickness = 3;
base_length = 40;
arm_thickness = 10;
arm_length = 30;
arm_overturn_angle = 10;

base_dimensions = [base_length, arm_thickness + wall_thickness * 2,
    wall_thickness];
hinge_axle_d = M3 + 0.3;
overall_height = (base_dimensions[2] + wall_thickness + hinge_axle_d / 2 +
    arm_thickness / 2);

$fs = 0.5;
$fa = 1;

module base ()
{
    module place_screwhole ()
    translate ([0, 0, base_dimensions[2] + arm_thickness / 2])
    rotate (90, X)
    children ();

    difference () {
        hull () {
            translate ([0, 0, base_dimensions[2] / 2])
            cube (base_dimensions, center=true);

            place_screwhole ()
            cylinder (d=hinge_axle_d + wall_thickness * 2, h=base_dimensions[1],
                center=true);
        }

        place_screwhole ()
        translate ([0, 0, -base_dimensions[1] / 2 - epsilon])
        polyhole (d=3, h=base_dimensions[1] + epsilon * 2);

        translate ([0, 0, base_dimensions[2] + overall_height / 2])
        cube ([base_length + epsilon * 2, arm_thickness + 0.6,
                overall_height],
            center=true);
    }
}

module arm ()
{
    difference () {
        union () {
            rotate (90, X)
            cylinder (d=arm_thickness, h=arm_thickness, center=true);

            translate ([arm_length / 2, 0, 0])
            cube ([arm_length, arm_thickness, arm_thickness], center=true);
        }

        translate ([0, 0, -arm_thickness / 2])
        rotate (-arm_overturn_angle, Y) {
            translate ([arm_length, 0, -arm_thickness])
            cube ([arm_length * 2, arm_thickness * 2, arm_thickness * 2],
                center=true);

            translate ([arm_length * 2, 0, arm_thickness])
            cube ([arm_length * 2, arm_thickness * 2, arm_thickness * 2],
                center=true);
        }

        rotate (90, X)
        translate ([0, 0, -arm_thickness / 2 - epsilon])
        polyhole (d=hinge_axle_d, h=arm_thickness + epsilon * 2);
    }
}
base ();

translate ([0, 0, base_dimensions[2] + arm_thickness / 2])
rotate (arm_overturn_angle, Y)
arm ();
