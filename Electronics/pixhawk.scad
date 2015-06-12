/**
 * Electronic devices for pixhawk https://pixhawk.org
 * 
 * Created by Diego Viejo
 * 
 */

//pixhawk();
telemetry();

//82x44x15
module pixhawk()

{
    translate([-82/2, -44/2, 0])
    union()
    {
        difference()
        {
            color([0.2, 0.2, 0.2]) cube([82, 44, 15]);
        
            color([0.2, 0.2, 0.2]) translate([0, 0, 13]) rotate([-45, 0, 0]) translate([-1, -15, 0])
                cube([82+2,15, 15]);
            color([0.2, 0.2, 0.2]) translate([0, 44, 13]) rotate([45, 0, 0]) translate([-1, 0, 0]) 
                cube([82+2,15, 15]);
            color([0.2, 0.2, 0.2]) translate([0, 0, 13]) rotate([0, 45, 0]) translate([-15, -1, 0]) 
                cube([15,44+2, 15]);
            color([0.2, 0.2, 0.2]) translate([82, 0, 13]) rotate([0, -45, 0]) translate([0, -1, 0]) 
                cube([15,44+2, 15]);
        
            color([0.2, 0.2, 0.2]) translate([-1, 1.5, 1.5]) cube([1+7.2, 44 - 1.5*2, 8]);
        
        }
        for(j=[1:3]) for(i=[1:16])
        {
            translate([0, 2.56*i, 2.56*j]) rotate([0, 90, 0]) cylinder(d=0.75, h=7.5);
        }
    }
}

//telemetry
//43.2x25.7x11 + antenna: hor 9.5x29.5 vert d1=9.5 d2=7.5 l=86
module telemetry()
color([0.2, 0.2, 0.2]) union()
{
    hull()
    {
        translate([2, 2, 0]) cylinder(r=2, h=11);
        translate([43.2-2, 2, 0]) cylinder(r=2, h=11);
        translate([2, 25.7-2, 0]) cylinder(r=2, h=11);
        translate([43.2-2, 25.7-2, 0]) cylinder(r=2, h=11);
    }
    
    translate([43.2-0.1, 6.5, 11/2]) rotate([0, 90, 0]) cylinder(d=9.5, h=29.5);
    
    hull()
    {
        translate([43.2+29.5, 6.5, (11-9.5)/2]) cylinder(d1=9.5, h=2);
        translate([43.2+29.5, 6.5, (11-9.5)/2+86-7.5/2]) sphere(d=7.5);
    }
}