/**
 * copterArm.scad
 * 
 * Created by Diego Viejo
 * 19/May/2015
 * 
 */

include<config.scad>

use<motorMount.scad>

use<armMount.scad>

//laze();

copterArm(part=1);


ESCStart = 32; //distance from the beginning of the arm
//Setup you ESC parameters here. Just check that the hole for it is big enough to hold it
ESCLength = 90;
ESCHeight = 10;
ESCWidth = 27;


/**
 * module copterArm
 * 
 * Creates a copter arm with compartments for ESC and brushless motor.
 * For printing it is halved. It uses 2mm. diam. beams and zip ties for stick the two 
 * parts together.
 * 
 * @param part. 0: hole arm. 1: left part. 2: right part.
 * 
 */
module copterArm(part = 0, length = armLength)
difference()
{
union()
{
    malePart();

    translate([0, length, 0]) rotate(-90) motorMount(action="add");

    rotate([-90,0,0]) union()
    {
        hull()
        {
            translate([0, 0, entryDepth + outputDepth - 0.1])
                oval(w=outputWidth, h=outputHeight, height=0.1);

            translate([0, 0, length-44-20])
                oval(w=32/2+10*10/100, h=outputHeight, height=1);
        }
    
        for(i=[-10:0])
        {
            hull()
            {
                translate([0, 0, length-44+i*2])
                    oval(w=32/2+i*i/100, h=outputHeight, height=0.5);
                translate([0, 0, length-44+(i+1)*2])
                    oval(w=32/2+(i+1)*(i+1)/100, h=outputHeight, height=0.5);
            }
        }
    
        for(i=[0:29])
        {
            hull()
            {
                translate([0, 0, length-44+i])
                    oval(w=32/2+i*i/100, h=outputHeight, height=1);
                translate([0, 0, length-44+i+1])
                    oval(w=32/2+(i+1)*(i+1)/100, h=outputHeight, height=1);
            }
        }
    
        hull()
        {
            translate([0, 0, length-44+30])
                oval(w=32/2+30*30/100, h=outputHeight, height=1);
        
            translate([0, 0, length]) 
            {
                translate([31, 19.5, 20]) rotate([-75, 0, 0]) rotate([0,90,35])
                    translate([20, 20*20/27, 0]) scale([1.0, 1.0, 1.35]) sphere(r=8);
                mirror([1,0,0])
                translate([31, 19.5, 20]) rotate([-75, 0, 0]) rotate([0,90,35])
                    translate([20, 20*20/27, 0]) scale([1.0, 1.0, 1.35]) sphere(r=8);
            }
        }

        //landing Gear
        translate([0, 0, length]) 
            u();
    }

} //end union
    //motor mount holes
    translate([0, length, 0]) rotate(-90) motorMount(action="remove");
    
    //main hole
    rotate([-90,0,0]) cylinder(d = wireDiameter, h=length);
    
    // zip ties
    rotate([-90,0,0])
    {
        translate([0, 0, outputDepth+3]) laze(w = outputWidth*0.8, h=outputHeight*0.8);

        translate([0, 0, length-55]) laze(w = (30/2+6*6/100)*0.8, h=outputHeight*0.8);

        translate([0, 0, length-28]) laze(w = (30/2+16*16/100)*0.8, h=outputHeight*0.8);
    }
    //ESC Holder
    rotate([-90,0,0]) 
    {
        translate([-ESCWidth/2, -ESCHeight/2, ESCStart]) cube([ESCWidth, ESCHeight, ESCLength]);
        //cooling windows as sugested by Sicherlich Nicht
            translate([3, -15, ESCStart+ESCLength*0.8]) rotate([-20,0,0]) cube([7, 15, 7]);
            translate([3, -15, ESCStart+ESCLength*0.5]) rotate([-20,0,0]) cube([7, 15, 7]);
            translate([3, -15, ESCStart+ESCLength*0.2]) rotate([-20,0,0]) cube([7, 15, 7]);
            translate([-7-3, -15, ESCStart+ESCLength*0.8]) rotate([-20,0,0]) cube([7, 15, 7]);
            translate([-7-3, -15, ESCStart+ESCLength*0.5]) rotate([-20,0,0]) cube([7, 15, 7]);
            translate([-7-3, -15, ESCStart+ESCLength*0.2]) rotate([-20,0,0]) cube([7, 15, 7]);
    }
    
    //union beams
    for(i=[-1,1]) translate([0, 0, outputHeight*0.7*i])
    rotate([-90,0,0]) 
    {
        translate([0, 0, outputDepth]) rotate([0, 90, 0]) translate([0,0,-15/2]) cylinder(d=1.95, h=15);
        translate([0, 0, length-59]) rotate([0, 90, 0]) translate([0,0,-15/2]) cylinder(d=1.95, h=15);
        translate([0, 0, length-40]) rotate([0, 90, 0]) translate([0,0,-15/2]) cylinder(d=1.95, h=15);
    }
    
    //bolt for the landing gear union
    rotate([-90,0,0]) 
    {
        translate([-30/2, 75, 166.5]) rotate([0,90,0]) cylinder(r=1.65, h=25);
        translate([-30/2, 75, 166.5]) rotate([0,90,0]) cylinder(r=3.25, h=10);
    }    
    
    if(part==1)
        translate([0, -1, -90]) cube([100, length+40, 180]);
    else if(part==2)
        mirror([1,0,0]) translate([0, -1, -90]) cube([100, length+40, 180]);
} //end difference


*color("red")
translate([0, 106.4, -36.3]) 
    rotate([0, 90, 0]) rotate(-90) 
        import("../stl/OpenRC_Quad_Alpha_Arm_Part_1.stl");


sep = 31;
module u()
union() {
    translate([sep, 19.5, 20])
    rotate([-75, 0, 0])
    rotate([0,90,35])
    for(x=[-40:1:20])
    {
        hull()
        {
            translate([x, x*x/27, 0]) scale([1.0, 1.0, 1.35]) sphere(r=8);
            translate([x+1, (x+1)*(x+1)/27, 0]) scale([1.0, 1.0, 1.35])sphere(r=8);
        }
    }
    
    //mirror
    mirror([1,0,0])
    translate([sep, 19.5, 20])
    rotate([-75, 0, 0])
    rotate([0,90,35])
    for(x=[-40:1:20])
    {
        hull()
        {
            translate([x, x*x/27, 0]) scale([1.0, 1.0, 1.35]) sphere(r=8);
            translate([x+1, (x+1)*(x+1)/27, 0]) scale([1.0, 1.0, 1.35])sphere(r=8);
        }
    }

}

module laze(w=10, h=8, width=3.5)
{
    extra=2;
    union()
    {
        difference()
        {
            oval(w=w, h=h, height = width);
            translate([0, 0, -1]) oval(w=w-1.75, h=h-1.75, height = width+2);
            translate([-w-1, 0.1, -1]) cube([2*w+2, h+1, width+2]);
        }

        difference()
        {
            translate([extra, 0, 0]) oval(w=w+extra, h=h, height = width);
            translate([extra, 0, -1]) oval(w=w+extra-1.75, h=h-1.75, height = width+2);
            translate([-w-1, -h-1.1, -1]) cube([3*w+2, h+1, width+2]);
            translate([w, -h, -1]) cube([3*w+2, 2*h+1, width+2]);
        }
        translate([w-1.85, -1, 0]) rotate(-15) cube([1.75, 7.5, width]);
    
        translate([w-3.5, 3.65, -2]) rotate(-15) cube([10, 4, width+4]);
    }
    
}