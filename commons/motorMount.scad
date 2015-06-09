/**
 * motorMount.scad
 * 
 * Common piece for holding a brushless motor
 * 
 * Created by Diego Viejo after the idea of OpenRC copter from Daniel Noree
 * 21/May/2015
 * 
 */

include<config.scad>

outerDiam = 37;
innerDiam = 32;

height = 26;

platformHeight = 7;
platformWidth = 3.75;

axleDiam = 3.75;
bottomClearanceDiam = 8;
bottomClearanceHeight = 2;

//wire openning
wireDiameter = 8;

module motorMount(action="add") 
translate([0, 0, -(platformHeight + platformWidth + wireDiameter/2)])
{
    if(action == "add")
    {
//        cylinder(d=outerDiam, h=height);
        nestedHull()
        {
            cylinder(d=outerDiam-1, h=0.1);
            translate([0, 0, platformHeight]) cylinder(d=outerDiam+2, h=platformWidth);
            translate([0, 0, height-0.1]) cylinder(d=outerDiam-1, h=0.1);
        }
    }
    else
    {
        
        translate([0, 0, -1]) cylinder(d=innerDiam, h=1+platformHeight);
        translate([0, 0, platformHeight + platformWidth]) cylinder(d=innerDiam, h=height);
        
        //Motor axle if exists
        cylinder(d=axleDiam, h=height, $fn=20);
        
        //Bottom clearance
        translate([0, 0, platformHeight+ platformWidth-bottomClearanceHeight]) 
            cylinder(d=bottomClearanceDiam, h=height, $fn=20);
        
        //Mounting holes
        for(i=[1:2:8])
        {
            rotate(45*i) hull()
            {
                translate([0, 6, 0]) cylinder(d=3+0.15, h=height, $fn=20);
                translate([0, 12, 0]) cylinder(d=3+0.15, h=height, $fn=20);
            }
        }
        
        //wire openning
        translate([innerDiam/2-1, 0, platformHeight + platformWidth + wireDiameter/2]) rotate([0, 90, 0]) cylinder(d2=wireDiameter, d1=wireDiameter+2, h=(outerDiam-innerDiam)/2+2);
        
        translate([innerDiam/2-1, 0, platformHeight + platformWidth + wireDiameter/2]) rotate([0, 90, 180]) cylinder(d2=wireDiameter, d1=wireDiameter+2, h=(outerDiam-innerDiam)/2+2);
    }
}

difference()
{
    motorMount(action="add");
    motorMount(action="remove");
}
