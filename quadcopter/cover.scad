/**
 * cover.scad
 * quadcopter cover. It has to hold GPS module
 * 
 * Created by Diego Viejo on 09/Jun/2015
 * 
 */

include<config.scad>
include<../commons/config.scad>


module ellipsoid(w,h, center = false) {
 scale([1, h/w, 0.8]) sphere(r=w, $fn=60);
}

union()
{
    difference()
    {
        intersection()
        {
            ellipsoid(w = baseWidth, h=baseLength);
            translate([-200, -200, 0]) cube([400, 400, baseWidth*0.7]);
        }
    
        intersection()
        {
            ellipsoid(w = baseWidth-1, h=baseLength-1);
            translate([-200, -200, -1]) cube([400, 400, 1+(baseWidth-1)*0.7]);
        }
    }
    
    intersection()
    {
        difference()
        {
            translate([-107/2, -90/2, 0]) cube([107, 90, baseWidth*0.7]);
            translate([-97/2, -80/2, -1]) cube([97, 80, 2+baseWidth*0.7]);
            
            for(i=[1,-1]) 
            {
                for (j=[1,-1])
                {
                    translate([i*107/2, j*90/2, -1]) cylinder(r1=7, r2=0, h=10);
                }
                translate([i*40/2, -1-90/2, 5]) rotate([-90, 0, 0]) cylinder(r=1.65, h=2+90);
                translate([i*40/2, -1-90/2, 11]) rotate([-90, 0, 0]) cylinder(r=1.65, h=2+90);
            }
            
        }
        ellipsoid(w = baseWidth, h=baseLength);
    }
    
}

for(i=[-1, 1]) for(j=[-1,1])
    translate([i*(baseWidth+10), j*20, 0]) rotate(90)
grip();

gripLength = 14 + 4 + 3;
module grip()
{
    difference()
    {
        union()
        {
            translate([-gripLength/2, -8/2, 0]) cube([gripLength, 8, 2.5]);
            
            intersection()
            {
                translate([gripLength/2-2.8, -8/2, 0]) cube([2.8, 8, 4]);
                translate([gripLength/2-5, -8/2, 0.75]) rotate([0, 30, 0]) cube([13, 8, 4]);
            }
        }
        translate([gripLength/2-3-4-5, 0, 1.8]) cylinder(r=1.7, h=5, $fn=12);
        translate([gripLength/2-3-4-11, 0, 1.8]) cylinder(r=1.7, h=5, $fn=12);
        translate([gripLength/2-3-4-5, 0, -1]) rotate(30) cylinder(r=3, h=1.5, $fn=6);
        translate([gripLength/2-3-4-11, 0, -1]) rotate(30) cylinder(r=3, h=1.5, $fn=6);
        
        translate([gripLength/2-2.8-5, -10/2, 2.5-1]) cube([5, 10, 1+1]);
    }
}

armRectification = -17;
*translate([0, 0, -baseHeight])
{
//    import("../output/mainPlatformPart1.stl");
    import("../output/mainPlatformPart2.stl");
}

*translate([0, 10, 0])
for(i=[45, -45])
    rotate(i) translate([0,baseWidth+armRectification,-baseHeight/2]) import("../stl/copterArm.stl");
*translate([0, -10, 0])
for(i=[135, -135])
    rotate(i) translate([0,baseWidth+armRectification,-baseHeight/2]) import("../stl/copterArm.stl");
