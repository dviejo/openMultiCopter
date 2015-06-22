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
use<../Electronics/pixhawk.scad>


//This value pulls copter arms to the center of the platform
armRectification = -14.5;


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
        
        //arms positive
        for(i=[45, -45])
        {
            intersection()
            {
                rotate(i) translate([0,baseWidth+armRectification,0])
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
                rotate(i) translate([0,baseWidth+armRectification,0])
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
        
        translate([0, baseLength*0.225, 0]) mainElectronics(action="add");
        
        translate([0, 0, baseHeight-5]) 
            hollowify() difference()
            {
                oval(w=baseWidth-wallThick, h=baseLength-wallThick, height=5);
                
                translate([-openningLength/2, -openningWidth/2+baseLength*0.225, -1])
                    cube([openningLength, openningWidth, 5+2]);
                translate([-openningLength/2, -openningWidth/2+baseLength*0.225-15, -1])
                    cube([openningLength, 10, 5+2]);
                translate([-openningLength/2, -baseLength*0.6, -1])
                    cube([openningLength, 5, 5+2]);
            }
    }

    //arms negative
    for(i=[45, -45])
        rotate(i) translate([0,baseWidth+armRectification,baseHeight/2])
            femalePart();
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
    
    translate([0, baseLength*0.225, 0]) mainElectronics(action="remove");
    
    //base holes for comunicating with the battery container
    for(i=[1, -1])
        translate([0, i*baseLength*0.7, -1]) rotate(90) oval(w=12, h=15, height=4+2); //cylinder(d=20, h=4+2);
    
    //battery container's attaching holes
    for(i=[1,-1]) for(j=[1,-1])
    {
        translate([i*(baseWidth*0.535), j*baseLength*0.7, 0]) 
            unionBeam(action="remove", height=7);
        translate([i*(baseWidth*0.535), j*baseLength*0.7, 0]) 
            unionBeam(action="nut", height=7);
    }
    
    //electric conections board
    translate([0, baseLength*0.225, 0]) rotate(45) 
    {   
        translate([-50.5/2, -50.5/2, 1])  cube([50.5,50.5,6]);
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*45/2, j*45/2, -1]) cylinder(r=1.65, h=4+2);
        translate([-37/2, -37/2, -1]) cube([37,37, 5]);
    }
    
    //conections for top cover
    lAux = baseLength*0.98;
    wAux = (sqrt(1-(lAux/baseLength)*(lAux/baseLength)))*baseWidth;
    for(i=[1,-1])
    {
        translate([i*(wAux-5),i*(lAux-5),-1]) cylinder(d=6.5, h=baseHeight-3+1);
        translate([i*(wAux-5),i*(lAux-5),baseHeight-3+0.3]) cylinder(d=3.15, h=baseHeight-3+1);
    }
    

    //Uncomment next line to get the lower half
    //translate([-300, -300, baseHeight/2]) cube([600,600,100]);
    //Uncomment next line to get the upper half
    //translate([-300, -300, -1]) cube([600,600,baseHeight/2+1]);
}


*translate([0, 0, 24]) rotate(90) pixhawk();

*translate([0, 10, 0])
for(i=[45, -45])
    rotate(i) translate([0,baseWidth+armRectification,baseHeight/2]) import("../stl/copterArm.stl");
*translate([0, -10, 0])
for(i=[135, -135])
    rotate(i) translate([0,baseWidth+armRectification,baseHeight/2]) import("../stl/copterArm.stl");

*translate([0, 0, baseHeight]) import("../stl/cover.stl");


module mainElectronics(action = "add")
{
    for(i=[-1,1])
    {
        for(j=[-1,1])
        {
            translate([i*monimacHolesHeight/2, j*monimacHolesWidth/2,0]) 
                unionBeam(action=action, height=12);
        }
    }
*    color("grey") translate([-57/2, -84/2, 12]) cube([57, 84, 3]);
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
        translate([0, 0, height-3]) cylinder(r=3.25, h=height+2, $fn=6);
    }
}