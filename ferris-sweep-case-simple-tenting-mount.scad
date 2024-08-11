tenting_angle = 15; // degrees
base_thickness = 2;
support_base_thickness = 0.001;
support_base_width = 6;
wall_thickness = 2;
wall_height = 6;
clearance = 0.2;

/* Hidden */
file_name = "./Sweep_Case_Left_NO_TRRS_Breakout_8mm_Bumpon.stl";

module case() {
    translate([
        -10 + clearance + wall_thickness,
        104 + clearance + wall_thickness,
        0
    ])
    import(file_name);
}

//module bumpons() {
//    difference() {
//        offset(delta = -1) projection() case();
//        projection()
//        intersection() {
//            case();
//            cube([120, 100, 0.1]);
//        }
//    }
//}

module base_plate() {
    linear_extrude(base_thickness)
    projection()
    rotate([0, -tenting_angle, 0])
    linear_extrude(0.0001)
    offset(delta = clearance + wall_thickness)
    projection()
    case();
}

module support() {
    module support_base() {
        linear_extrude(support_base_thickness)
        difference() {
            offset(delta = clearance + wall_thickness)
            projection() case();
            
            offset(delta = -support_base_width)
            projection() case();
        }
    }

    module support_walls() {
        linear_extrude(support_base_thickness + wall_height)
        difference() {
            offset(delta = clearance + wall_thickness)
            projection() case();
            
            offset(delta = clearance)
            projection() case();
        }
    }
    
    module cutters() {
//        cutter_height = 1.05 * (wall_height + support_base_thickness);
//        
//        translate([90, 20, 0])
//        cube([30, 55, cutter_height]);
//        
//        translate([100, 20, 0])
//        rotate([0, 0, -25])
//        cube([20, 20, cutter_height]);
//        
//        translate([10, 0, 0])
//        cube([70, 30, cutter_height]);
//        
//        translate([65, 10, 0])
//        rotate([0, 0, -25])
//        cube([20, 20, cutter_height]);
//        
//        translate([65, 90, 0])
//        rotate([0, 0, -15])
//        cube([20, 20, cutter_height]);
//        
//        translate([15, 70, 0])
//        rotate([0, 0, 30])
//        cube([20, 20, cutter_height]);
//        
//        translate([20, 80, 0])
//        cube([60, 30, cutter_height]);
    }
    
    translate([0, 0, base_thickness])
    union() {
        translate([0, 0, support_base_thickness])
        rotate([0, -tenting_angle, 0])
        difference() {
            union() {
                support_base();
                support_walls();
            }
            translate([0, 0, -0.01]) cutters();
        }

        difference() {
            linear_extrude()
            projection()
            rotate([0, -tenting_angle, 0])
            difference() {
                linear_extrude(0.0001)
                projection()
                support_base();
                translate([0, 0, -0.01]) cutters();
            }
            
            translate([0, 0, support_base_thickness])
            rotate([0, -tenting_angle, 0])
            linear_extrude()
            offset(delta = 100)
            projection()
            support_base();
        }
    }
}

base_plate();
support();