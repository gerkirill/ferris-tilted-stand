tenting_angle = 0; // degrees, I think optimal for me is 4
base_thickness = 0.4;// was 2
support_base_thickness = 0.6; // 0.001 for tenting
support_base_width = 60; // was 6
wall_thickness = 2; // I think optimal for me is 2
wall_height = 4;// I think optimal for me is 8.4
clearance = 0.6;
makeCutters = false;
auxCutoutDiameter = 10;

/* Hidden */
file_name = "./new-contour3.svg";
module case() {
    translate([
        0 + clearance + wall_thickness,
        20 + clearance + wall_thickness,
        0
    ])
    // this line is only for svg
    linear_extrude(base_thickness)
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

module screwHole() {
    difference() {
        cylinder(h=2+support_base_thickness, d=5.4, center=false, $fn=50);
        cylinder(h=2+support_base_thickness, d=1.4, center=false, $fn=50);
    }
    
}

module screwHoles() {
    // bottom left
    translate([
        0 + clearance + wall_thickness + 21.5,
        19 + clearance + wall_thickness + 15.5,
        0
    ])
    screwHole();
    // top left
    translate([
        0 + clearance + wall_thickness + 16.5,
        78 + clearance + wall_thickness + 4,
        0
    ])
    screwHole();
    // bottom right
    translate([
        0 + clearance + wall_thickness + 103.2,
        19 + clearance + wall_thickness + 3.5,
        0
    ])
    screwHole();
    // top right
    translate([
        0 + clearance + wall_thickness + 77.5,
        19 + clearance + wall_thickness + 72.5,
        0
    ])
    screwHole();
}

module base_plate() {
    rotate([0, -tenting_angle, 0])
    screwHoles();
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
    
    module aux_cutout() {
        translate([
            110 + clearance + wall_thickness,
            30 + clearance + wall_thickness,
            auxCutoutDiameter / 2
        ])
        union() {
            translate([0, 0, auxCutoutDiameter / 2])
            cube(size = [30, auxCutoutDiameter, auxCutoutDiameter], center = true);
            rotate([0, 90, 0])
            cylinder(h=30, d=auxCutoutDiameter, center=true);
        }
    }

    module support_walls() {
        difference() {
            linear_extrude(support_base_thickness + wall_height)
            difference() {
                offset(delta = clearance + wall_thickness)
                projection() case();
                
                offset(delta = clearance)
                projection() case();
            };
            aux_cutout();
        }
    }
    
    module cutters() {
        cutter_height = 1.05 * (wall_height + support_base_thickness);
        
        translate([90, 20, 0])
        cube([30, 55, cutter_height]);
        
        translate([100, 20, 0])
        rotate([0, 0, -25])
        cube([20, 20, cutter_height]);
        
        translate([10, 0, 0])
        cube([70, 30, cutter_height]);
        
        translate([65, 10, 0])
        rotate([0, 0, -25])
        cube([20, 20, cutter_height]);
        
        translate([65, 90, 0])
        rotate([0, 0, -15])
        cube([20, 20, cutter_height]);
        
        translate([15, 70, 0])
        rotate([0, 0, 30])
        cube([20, 20, cutter_height]);
        
        translate([20, 80, 0])
        cube([60, 30, cutter_height]);
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
            if (makeCutters) {
                translate([0, 0, -0.01]) cutters();
            }
        }

        difference() {
            linear_extrude()
            projection()
            rotate([0, -tenting_angle, 0])
            difference() {
                linear_extrude(0.0001)
                projection()
                support_base();
                if (makeCutters) {
                    translate([0, 0, -0.01]) cutters();
                }
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

//projection(cut=true)
//translate([0, 0, -5])
union() {
    base_plate();
    support();
}
