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


module motorMount(action="add") 
translate([0, 0, -(motorPlatformHeight + motorPlatformWidth + wireDiameter/2)])
{
    if(action == "add")
    {
        nestedHull()
        {
            cylinder(d=motorOuterDiam-1, h=0.1);
            translate([0, 0, motorPlatformHeight]) cylinder(d=motorOuterDiam+2, h=motorPlatformWidth);
            translate([0, 0, motorHeight-0.1]) cylinder(d=motorOuterDiam-1, h=0.1);
        }
    }
    else
    {
        
        translate([0, 0, -1]) cylinder(d=motorInnerDiam, h=1+motorPlatformHeight);
        translate([0, 0, motorPlatformHeight + motorPlatformWidth]) cylinder(d=motorInnerDiam, h=motorHeight);
        
        //Motor axle if exists
        cylinder(d=motorAxleDiam, h=motorHeight, $fn=20);
        
        //Bottom clearance
        translate([0, 0, motorPlatformHeight+ motorPlatformWidth-bottomClearanceHeight]) 
            cylinder(d=bottomClearanceDiam, h=motorHeight, $fn=20);
        
        //Mounting holes
        for(i=[1:2:8])
        {
            rotate(45*i) hull()
            {
                translate([0, 6, 0]) cylinder(d=3+0.15, h=motorHeight, $fn=20);
                translate([0, 12, 0]) cylinder(d=3+0.15, h=motorHeight, $fn=20);
            }
        }
        
        //wire openning
        translate([motorInnerDiam/2-1, 0, motorPlatformHeight + motorPlatformWidth + wireDiameter/2]) rotate([0, 90, 0]) cylinder(d2=wireDiameter, d1=wireDiameter+2, h=(motorOuterDiam-motorInnerDiam)/2+2);
        
        translate([motorInnerDiam/2-1, 0, motorPlatformHeight + motorPlatformWidth + wireDiameter/2]) rotate([0, 90, 180]) cylinder(d2=wireDiameter, d1=wireDiameter+2, h=(motorOuterDiam-motorInnerDiam)/2+2);
    }
}

difference()
{
    motorMount(action="add");
    motorMount(action="remove");
}
