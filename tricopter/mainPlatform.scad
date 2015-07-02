/**
 * 
 * Tricopter main platform
 * 
 * Created by Diego Viejo
 */

include<config.scad>
include<../commons/config.scad>

use<../commons/armMount.scad>

lArm = baseLength*0.7;
wArm = (sqrt(1-(lArm/baseLength)*(lArm/baseLength)))*baseWidth;

armRectification = 23;

difference()
{
    union()
    {
        difference()
        {
            oval(w=baseWidth, h=baseLength, height=baseHeight, $fn=70);
            difference()
            {
                translate([0, 0, 4]) oval(w=baseWidth-wallThick, h=baseLength-wallThick, height=baseHeight+4*2);
                
                //unions
                for(i=[1,-1])
                {
                    translate([i*(baseWidth-wallThick), 0, 0]) unionBeam(action="add");
                    translate([0, i*(baseLength-wallThick), 0]) unionBeam(action="add");
                }
                //battery container attaching holes
                for(i=[1,-1]) for(j=[1,-1])
                {
                    translate([i*(baseWidth*0.535), j*baseLength*0.7, 0]) unionBeam(action="add", height=7);
                }
                
                //ends
                translate([-60/2, baseLength*0.89, -1]) cube([60, 20, baseHeight+2]);
                translate([-60/2, -baseLength*0.89-20, -1]) cube([60, 20, baseHeight+2]);
            }
        }
        
        for(i=[1, -1])
        {
            intersection()
            {
                translate([i*(wArm-armRectification),lArm-armRectification,0]) rotate(-i*frontAngle)
                {
                    difference()
                    {
                        linear_extrude(height=baseHeight)  projection() minkowski() {
                            hull() malePart();
                            sphere(4);
                        }
                    }
                }
                oval(w=baseWidth, h=baseLength, height=baseHeight);
            }
        }
        intersection()
        {
            translate([0,-baseLength+armRectification*1.5,0]) rotate(180)
            {
                difference()
                {
                    linear_extrude(height=baseHeight)  projection() minkowski() {
                        hull() malePart();
                        sphere(4);
                    }
                }
            }
            oval(w=baseWidth, h=baseLength, height=baseHeight);
        }
    }
    
    //arms negative
    for(i=[1, -1])
    {
        translate([i*(wArm-armRectification),lArm-armRectification,baseHeight/2]) rotate(-i*frontAngle)
            femalePart();
    }
    translate([0,-baseLength+armRectification*1.5,baseHeight/2]) rotate(180)
        femalePart();
}

module unionBeam(action="add", height=baseHeight)
{
    if(action=="add")
    {
        cylinder(r=5, h=height);
    }
    else if(action=="remove")
    {
        translate([0, 0, -1]) cylinder(r=1.65, h=height+2);
    }
    else if(action=="boltHead") //height>5
    {
        translate([0, 0, -1]) cylinder(r=3.1, h=4.5+1);
        translate([0, 0, 4.8]) cylinder(r=1.65, h=height-4.8-3.3);
    }
    else //nut at height-3
    {
        translate([0, 0, height-3]) cylinder(r=3.15, h=height+2, $fn=6);
    }
}