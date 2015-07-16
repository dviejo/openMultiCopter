/**
 * 
 * Tricopter main platform
 * 
 * Created by Diego Viejo
 */

include<config.scad>
include<../commons/config.scad>

use<../commons/armMount.scad>
use<../commons/copterArm.scad>

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
                    translate([i*((sqrt(1-0.75*0.75))*baseWidth-wallThick), -(baseLength*0.75-wallThick), 0]) unionBeam(action="add");
                    translate([i*(baseWidth-wallThick), 0, 0]) unionBeam(action="add");
                }
                translate([0, (baseLength-wallThick), 0]) unionBeam(action="add");
                
                //battery container attaching holes
                for(i=[1,-1]) 
                {
                    translate([i*((sqrt(1-0.825*0.825))*baseWidth-1.5*wallThick), 
                              -(baseLength*0.825-wallThick), 0]) 
                        unionBeam(action="add", height=7);
                    translate([i*((sqrt(1-0.875*0.875))*baseWidth-1.5*wallThick), (baseLength*0.875-wallThick), 0]) 
                        unionBeam(action="add", height=7);
                }
                
                //end
                translate([-60/2, baseLength*0.89, -1]) cube([60, 20, baseHeight+2]);
            }
        }
        
        //front arms
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
        //rear arm 
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
        
        translate([0, -baseLength*0.125, 0]) mainElectronics(action="add");
        
        translate([0, 0, baseHeight-5]) 
            hollowify() difference()
            {
                oval(w=baseWidth-wallThick, h=baseLength-wallThick, height=5);
                
                translate([-openningLength/2, -openningWidth/2-baseLength*0.125, -1])
                    cube([openningLength, openningWidth, 5+2]);
                translate([-openningLength/2, openningWidth/2-baseLength*0.125+17, -1])
                    cube([openningLength, 10, 5+2]);
            }

    } //union end
    
    //arms negative
    for(i=[1, -1])
    {
        translate([i*(wArm-armRectification),lArm-armRectification,baseHeight/2]) rotate(-i*frontAngle)
            femalePart();
    }
    translate([0,-baseLength+armRectification*1.5,baseHeight/2]) rotate(180)
        femalePart();

    //unions
    for(i=[1,-1])
    {
        translate([i*((sqrt(1-0.75*0.75))*baseWidth-wallThick), -(baseLength*0.75-wallThick), 0]) unionBeam(action="boltHead");
        translate([i*((sqrt(1-0.75*0.75))*baseWidth-wallThick), -(baseLength*0.75-wallThick), 0]) unionBeam(action="nut");
        
        translate([i*(baseWidth-wallThick), 0, 0]) unionBeam(action="boltHead");
        translate([i*(baseWidth-wallThick), 0, 0]) unionBeam(action="nut");
    }
    translate([0, (baseLength-wallThick), 0]) unionBeam(action="boltHead");
    translate([0, (baseLength-wallThick), 0]) unionBeam(action="nut");

    translate([0, -baseLength*0.125, 0]) mainElectronics(action="remove");

    //base holes for comunicating with the battery container
    translate([0, baseLength*0.75, -1]) rotate(90) oval(w=12, h=15, height=4+2); 
    
    //electric conections board
    translate([0, -baseLength*0.125, 0]) rotate(45) 
    {   
        translate([-50.5/2, -50.5/2, 1])  cube([50.5,50.5,6]);
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*45/2, j*45/2, -1]) cylinder(r=1.65, h=4+2);
        translate([-37/2, -37/2, -1]) cube([37,37, 5]);
    }

}

    %for(i=[1, -1])
    {
        translate([i*(wArm-armRectification),lArm-armRectification,baseHeight/2]) rotate(-i*frontAngle)
            import("../stl/copterArm.stl");
    }
    %translate([0,-baseLength+armRectification*1.5,baseHeight/2]) rotate(180)
        import("../stl/copterArm.stl");

        
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