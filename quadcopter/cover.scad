/**
 * cover.scad
 * quadcopter cover. It has to hold GPS module
 * 
 * Created by Diego Viejo on 09/Jun/2015
 * 
 */

include<config.scad>
include<../commons/config.scad>
include<../extras/Write.scad>


module ellipsoid(w,h, center = false) {
 scale([1, h/w, 0.8]) sphere(r=w, $fn=60);
}

difference()
{
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
                translate([-(openningLength+10)/2, -(openningWidth+10)/2, 0]) 
                    cube([openningLength+10, openningWidth+10, baseWidth*0.7]);
                translate([-openningLength/2, -openningWidth/2, -1]) 
                    cube([openningLength, openningWidth, 2+baseWidth*0.7]);

                //from Obijuan's cabinets 
                for(j=[1:4]) for(i=[-2:2-((j+1)%2)])
                {
                    translate([i*15+(15/2)*((j+1)%2), -(openningWidth+20)/2, 10*j]) rotate([-90, 0, 0])
                        cylinder(d=10, h=(openningWidth+20), $fn=4);
                }
                for(j=[2:4]) for(i=[-2:2-((j+1)%2)])
                {
                    translate([-(openningLength+20)/2, i*17+(17/2)*((j+1)%2), 10*j-4]) rotate([0, 90, 0])
                        cylinder(d=10, h=(openningLength+20), $fn=4);
                }
            }
            ellipsoid(w = baseWidth, h=baseLength);
        }
        
        //GPS support
        translate([0, -baseLength/4, baseWidth*0.7]) cylinder(d=8, h=2);
        for(i=[0, 90]) 
            translate([0, -baseLength/4, (baseWidth-1)*0.7]) rotate(i)
            hull()
            {
                translate([0-4/2, -4/2, 0]) cube([4,4,2.5]);
                translate([-15-4/2, -4/2, 0]) cube([4,4,1]);
                translate([15-4/2, -4/2, 0]) cube([4,4,1]);
            }
            
        //Text - TODO: automatic centering
        text1="Open Multi Copter";
        text2="Quad Prototype";
        translate([30, 0, baseWidth*0.7-0.2]) rotate(180)
            write(text1, h=5, t=1,space=1);
        translate([25, 10, baseWidth*0.7-0.2]) rotate(180)
            write(text2, h=5, t=1,space=1);
    
    }
    for(i=[1,-1]) 
    {
        *for (j=[1,-1])
        {
            translate([i*(openningLength+10)/2, j*90/2, -1]) cylinder(r1=7, r2=0, h=10);
        }
        translate([-1-(openningLength+60)/2, i*40/2, 5]) rotate([0, 90, 0]) 
            cylinder(r=1.7, h=2+openningLength+60, $fn=20);
        translate([-1-(openningLength+60)/2, i*40/2, 11]) rotate([0, 90, 0]) 
            cylinder(r=1.7, h=2+openningLength+60, $fn=20);
                }
            
    
    //holes for GPS
    translate([0, -baseLength/4, (baseWidth-1)*0.7 +0.3]) cylinder(d=3.25, h=5);
    for(i=[45, 135, 225, 315])
        translate([0, -baseLength/4, (baseWidth-1)*0.7  +0.3])
            rotate(i)
                translate([10, 0, 0]) hull()
                {
                    translate([3.25, 0, 0]) cylinder(r=2.15, h=5);
                    translate([-3.25, 0, 0]) cylinder(r=2.15, h=5);
                }
    //Antenna openning
    translate([28, -baseLength+15, 0]) scale([0.7, 1, 1]) rotate([90, 0, 0]) cylinder(d=12, h=20);
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
        //holes and nuts
        translate([gripLength/2-3-4-5, 0, 1.3]) cylinder(r=1.7, h=5, $fn=12);
        translate([gripLength/2-3-4-11, 0, 1.3]) cylinder(r=1.7, h=5, $fn=12);
        translate([gripLength/2-3-4-5, 0, -1]) rotate(30) cylinder(r=3.15, h=2, $fn=6);
        translate([gripLength/2-3-4-11, 0, -1]) rotate(30) cylinder(r=3.15, h=2, $fn=6);
        
        translate([gripLength/2-2.8-5, -10/2, 2.5-1]) cube([5, 10, 1+1]);
    }
}

