/**
 * Battery compartment
 * 
 * Created by Diego Viejo
 * 17/Jun/2015
 * 
 */

include<config.scad>
include<../commons/config.scad>

//turnigy  2.2mAh 3S 25C
bat1_Width = 35;
bat1_Length = 108;
bat1_Height = 25;

//RCInnovations 6000mAh 3S 30C

bat2_Width = 44;
bat2_Length = 138;
bat2_Height = 33;

//Turnigy 5000mAh 3S 25C
bat3_Width = 50;
bat3_Length = 142;
bat3_Height = 20;



//Change next three lines to match your battery's specs. 
batWidth = bat2_Width;
batLength = bat2_Length;
batHeight = bat2_Height;

difference()
{
    union()
    {
        hull()
        {
            intersection()
            {
                oval(w=batWidth/2+18, h=batLength/2+30, height=batHeight+10, $fn=80);
                scale([1,1,2.5])ellipsoid(w=batWidth/2+18, h=batLength/2+38);
            }
            //clearance for battery connection
            //TODO This cube's height has to be related to battery's o,r at least, be ensured not to be taller
            translate([-batWidth+5, -batLength/2+1, 0]) cube([20, batLength, 30]);
        }
        
        for(i=[1,-1]) for(j=[1,-1])
        hull()
        {
            translate([i*(baseWidth*0.535), j*baseLength*0.7, 0]) 
                cylinder(d=15, h=2.5);
            translate([i*(baseWidth*0.25), j*baseLength*0.55, 0]) 
                cylinder(d=40, h=2.5);
        }
        //pixhawk safety button
        intersection()
        {
            translate([0,-batLength/2-30-3,4+11/2]) rotate([-90, 0, 0]) cylinder(d2=27, d1=11.5,h=10);
            translate([-batWidth,-batLength,0]) cube([2*batWidth,2*batLength,100]);
        }
    }
    
    translate([-(batWidth+4)/2, -batLength/2, 4]) cube([batWidth+4, batLength+35, batHeight+1]);
    translate([-(batWidth-4)/2, -batLength/2, -1]) cube([batWidth-4, batLength+30, 12]);
    translate([-(batWidth+4)/2, batLength/2-1, 4]) cube([batWidth+4, 100, batHeight+10]);
    //battery container's attaching holes
    for(i=[1,-1]) for(j=[1,-1])
    {
        translate([i*(baseWidth*0.535), j*baseLength*0.7, -1]) 
            cylinder(r=1.7, h=10+1);
        translate([i*(baseWidth*0.535), j*baseLength*0.7, 2.5]) 
            cylinder(r=4, h=batHeight+15);
    }

    intersection()
    {
        translate([0,0,4]) oval(w=batWidth/2+15, h=batLength/2+23, height=batHeight+1-4);
        scale([1,1,2.5])ellipsoid(w=batWidth/2+15, h=batLength/2+35);
    }
    
    hull()
    {
        translate([0, -baseLength*0.775, -1]) rotate(90) oval(w=12, h=15, height=4+2);
        translate([-(batWidth-4)/2, -batLength/2, -1]) cube([batWidth-4,2,4+2]);
    }
    //clearance for battery connection
    translate([-batWidth+5-1, -batLength/2+3, 4]) cube([20, batLength-6, 25-6]);
    hull()
    {
        translate([-batWidth+5+5, -batLength/2+3, 4]) cube([20-5, batLength-6, 25-6]);
        translate([0, -baseLength*0.775, 4]) rotate(90) oval(w=12, h=15, height=batHeight-3);
        translate([-7, baseLength*0.75, 4]) cylinder(d=20, h=batHeight-5);
    }

    //pixhawk safety button
    translate([0, -batLength/2-30-4,4+11/2]) rotate([-90, 0, 0]) cylinder(d=8.5, h=12);
    translate([-1, -batLength, -1]) cube([2,batLength,4+11/2+2]);
}

*%translate([0, 0, 0]) rotate([180,0,0])
import("../output/mainPlatformPart1.stl");