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

perc = 0.55;

difference()
{
    union()
    {
        difference()
        {
            intersection()
            {
                ellipsoid(w = baseWidth, h=baseLength);
                translate([-200, -200, 0]) cube([400, 400, baseWidth*perc]);
            }
    
            intersection()
            {
                ellipsoid(w = baseWidth-1.75, h=baseLength-1);
                translate([-200, -200, -1]) cube([400, 400, 1+(baseWidth-1.75)*perc]);
            }
        
        }
    
        intersection()
        {
            difference()
            {
                union()
                {
                    translate([-(openningLength+6)/2, -(openningWidth+6)/2, 0]) 
                        cube([openningLength+6, openningWidth+6, baseWidth*perc]);
                    translate([-baseWidth-5, -1, 0])
                        cube([baseWidth*2+10, 2, 10]);
                }
                translate([-openningLength/2, -openningWidth/2, -1]) 
                    cube([openningLength, openningWidth, 2+baseWidth*perc]);

                hull()
                {
                    translate([-(openningLength+6)/2-10/2, -2, 0]) rotate([-90, 0, 0])
                        cylinder(d=10, h=4);
                    translate([-(baseWidth-1.75)+10/2+0.5, -2, 0]) rotate([-90, 0, 0])
                        cylinder(d=10, h=4);
                }
                mirror([1,0,0])
                hull()
                {
                    translate([-(openningLength+6)/2-10/2, -2, 0]) rotate([-90, 0, 0])
                        cylinder(d=10, h=4);
                    translate([-(baseWidth-1.75)+10/2+0.5, -2, 0]) rotate([-90, 0, 0])
                        cylinder(d=10, h=4);
                }

                //from Obijuan's cabinets 
                for(j=[1:3]) for(i=[-2:2-((j+1)%2)])
                {
                    translate([i*15+(15/2)*((j+1)%2), -(openningWidth+20)/2, 10*j]) rotate([-90, 0, 0])
                        cylinder(d=10, h=(openningWidth+20), $fn=4);
                }
                for(j=[2:3]) for(i=[-2:2-((j+1)%2)])
                {
                    translate([-(openningLength+20)/2, i*17+(17/2)*((j+1)%2), 10*j-4]) rotate([0, 90, 0])
                        cylinder(d=10, h=(openningLength+20), $fn=4);
                }
            }
            ellipsoid(w = baseWidth, h=baseLength);
        }
        
        //GPS support
        translate([0, -baseLength/2+10, 0])
        {
            translate([0, 0, baseWidth*perc]) cylinder(d=8, h=2);
            for(i=[0, 90]) translate([0, 0, (baseWidth-1.75)*perc]) rotate(i)
            hull()
            {
                translate([0-4/2, -4/2, 0]) cube([4,4,2.5]);
                translate([-15-4/2, -4/2, 0]) cube([4,4,1]);
                translate([15-4/2, -4/2, 0]) cube([4,4,1]);
            }
        }
        
        //Text - TODO: automatic centering
        text1="Open Multi Copter";
        text2="Quad Prototype";
        translate([43, 5, baseWidth*perc-0.2]) rotate(180)
            write(text1, h=7.5, t=1,space=1);
        translate([38, 20, baseWidth*perc-0.2]) rotate(180)
            write(text2, h=8, t=1,space=1);
    
    }
    for(i=[1,-1]) 
    {
        *for (j=[1,-1])
        {
            translate([i*(openningLength+10)/2, j*90/2, -1]) cylinder(r1=7, r2=0, h=10);
        }
        translate([-1-(openningLength+60)/2, i*40/2, 5]) rotate([0, 90, 0]) 
            cylinder(r=1.7, h=2+openningLength+60, $fn=20);
        translate([-1-(openningLength+60)/2, i*40/2, 12]) rotate([0, 90, 0]) 
            cylinder(r=1.7, h=2+openningLength+60, $fn=20);
                }
            
    
    //holes for GPS
    translate([0, -baseLength/2+10, 0])
    {
        translate([0, 0, (baseWidth-1.75)*perc +0.3]) cylinder(d=3.25, h=5);
        for(i=[45, 135, 225, 315])
            translate([0, 0, (baseWidth-1.75)*perc  +0.3])
                rotate(i)
                    translate([10, 0, 0]) hull()
                    {
                        translate([3.25, 0, 0]) cylinder(r=2.15, h=5);
                        translate([-3.25, 0, 0]) cylinder(r=2.15, h=5);
                    }
    }
    //Antenna openning
    hull()
    {
        #translate([20, -baseLength+15, 5]) rotate([90, 0, 0]) cylinder(d=11.5, h=20);
        translate([20, -baseLength+15, -3]) rotate([90, 0, 0]) cylinder(d=11.5, h=20);
    }
}

*for(i=[-1, 1]) for(j=[-1,1])
    translate([i*(baseWidth+10), j*20, 0]) rotate(90)
grip();


*translate([0, 0, -baseHeight])
import("../output/mainPlatformPart2.stl");

gripLength = 14 + 5 + 3;
module grip()
{
    difference()
    {
        union()
        {
            translate([-gripLength/2, -8/2, 0]) cube([gripLength, 8, 3.5]);
            
            intersection()
            {
                translate([gripLength/2-2.8, -8/2, 0]) cube([2.8, 8, 4]);
                translate([gripLength/2-5, -8/2, 0.75]) rotate([0, 30, 0]) cube([13, 8, 4]);
            }
        }
        //holes and nuts
        translate([gripLength/2-3-4-5, 0, 2.3]) cylinder(r=1.7, h=5, $fn=12);
        translate([gripLength/2-3-4-12, 0, 2.3]) cylinder(r=1.7, h=5, $fn=12);
        translate([gripLength/2-3-4-5, 0, -1]) rotate(30) cylinder(r=3.15, h=3, $fn=6);
        translate([gripLength/2-3-4-12, 0, -1]) rotate(30) cylinder(r=3.15, h=3, $fn=6);
        
        translate([gripLength/2-2.8-5, -10/2, 2.75-1]) cube([5, 10, 2+1]);
    }
}

