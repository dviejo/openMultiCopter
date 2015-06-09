/**
 * MainPlatform for a quadcopter
 * 
 * Created by Diego Viejo
 * 28/May/2015
 * 
 */

include<config.scad>
include<../commons/config.scad>

use<../commons/armMount.scad>
use<../commons/copterArm.scad>


//This value pulls copter arms to the center of the platform
armRectification = -17;


difference()
{
    union()
    {
        difference()
        {
            oval(w=baseWidth, h=baseLength, height=baseHeight);
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
            }
        }
        for(i=[45, -45])
        {
            intersection()
            {
                translate([0, 10, 0]) rotate(i) translate([0,baseWidth+armRectification,0])
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
        for(i=[135, -135])
        {
            intersection()
            {
                translate([0, -10, 0]) rotate(i) translate([0,baseWidth+armRectification,0])
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
        
        mainElectronics(action="add");
        
        translate([0, 0, baseHeight-4]) 
            hollowify() difference()
            {
                oval(w=baseWidth-wallThick, h=baseLength-wallThick, height=4);
                translate([-97/2, -80/2, -1]) cube([97, 80, 6]);            }
    }

    
    translate([0, 10, 0])
    for(i=[45, -45])
        rotate(i) translate([0,baseWidth+armRectification,baseHeight/2])
            femalePart();
    translate([0, -10, 0])
    for(i=[135, -135])
        rotate(i) translate([0,baseWidth+armRectification,baseHeight/2])
            femalePart();

    //unions
    for(i=[1,-1])
    {
        translate([i*(baseWidth-wallThick), 0, 0]) unionBeam(action="boltHead");
        translate([0, i*(baseLength-wallThick), 0]) unionBeam(action="boltHead");
        translate([i*(baseWidth-wallThick), 0, 0]) unionBeam(action="nut");
        translate([0, i*(baseLength-wallThick), 0]) unionBeam(action="nut");
    }
    mainElectronics(action="remove");
    
    //base holes for connecting the battery
    for(i=[1, -1])
        translate([0, i*baseLength*0.75, -1]) cylinder(d=20, h=4+2);
    
    //battery container attaching holes
    for(i=[1,-1]) for(j=[1,-1])
    {
        translate([i*(baseWidth*0.535), j*baseLength*0.7, 0]) 
            unionBeam(action="remove", height=7);
        translate([i*(baseWidth*0.535), j*baseLength*0.7, 0]) 
            unionBeam(action="nut", height=7);
    }
    
    

    //Uncomment next line to get the lower half
    //translate([-300, -300, baseHeight/2]) cube([600,600,100]);
    //Uncomment next line to get the upper half
    //translate([-300, -300, -1]) cube([600,600,baseHeight/2+1]);
}


translate([0, 10, 0])
for(i=[45, -45])
    rotate(i) translate([0,baseWidth+armRectification,baseHeight/2]) import("../stl/copterArm.stl");
translate([0, -10, 0])
for(i=[135, -135])
    rotate(i) translate([0,baseWidth+armRectification,baseHeight/2]) import("../stl/copterArm.stl");

module mainElectronics(action = "add")
{
    for(i=[-1,1])
    {
        for(j=[-1,1])
        {
            translate([i*monimacHolesHeight/2, j*monimacHolesWidth/2,0]) unionBeam(action=action, height=5);
        }
    }
    *color("grey") translate([-monimacLength/2, -monimacWidth/2, 6]) cube([monimacLength, monimacWidth, 3]);
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
        translate([0, 0, -1]) cylinder(r=3, h=4+1);
        translate([0, 0, 4.3]) cylinder(r=1.65, h=height+2);
    }
    else //nut at height-2.5
    {
        translate([0, 0, height-2.5]) cylinder(r=3.15, h=height+2, $fn=6);
    }
}