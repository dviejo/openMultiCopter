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


// batWidth = bat1_Width;
// batLength = bat1_Length;
// batHeight = bat1_Height;

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
                oval(w=batWidth/2+18, h=batLength/2+26, height=batHeight+10, $fn=80);
                scale([1,1,2.5])ellipsoid(w=batWidth/2+18, h=batLength/2+38);
            }
            //clearance for battery connection
            translate([-batWidth, -batLength/2, 0]) cube([20, batLength/2+20, 20]);
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
            translate([batWidth*0.75,0,4+11/2]) rotate([0, 90, 0]) cylinder(d1=25, d2=11,h=10);
            translate([-100,-100,0]) cube([200,200,100]);
        }
    }
    
    translate([-(batWidth+4)/2, -batLength/2, 4]) cube([batWidth+4, batLength+20, batHeight+1]);
    translate([-(batWidth-4)/2, -batLength/2, -1]) cube([batWidth-4, batLength+30, 12]);
    translate([-(batWidth+4)/2, batLength/2-1, 4]) cube([batWidth+4, 30, batHeight+10]);
    //battery container's attaching holes
    #for(i=[1,-1]) for(j=[1,-1])
    {
        translate([i*(baseWidth*0.535), j*baseLength*0.7, -1]) 
            cylinder(r=1.7, h=10+1);
    }

    intersection()
    {
        translate([0,0,4]) oval(w=batWidth/2+15, h=batLength/2+23, height=batHeight+1-4);
        scale([1,1,2.5])ellipsoid(w=batWidth/2+15, h=batLength/2+35);
    }
    
    hull()
    {
        translate([0, -baseLength*0.75, -1]) cylinder(d=20, h=4+2);
        translate([-(batWidth-4)/2, -batLength/2, -1]) cube([batWidth-4,2,4+2]);
    }
    //clearance for battery connection
    hull()
    {
        translate([-batWidth-1, -batLength/2+3, 4]) cube([20, batLength/2+20-6, 20-6]);
        translate([0, -baseLength*0.75, 4]) cylinder(d=20, h=20-6);
        translate([0, baseLength*0.95, 4]) cylinder(d=20, h=20-6);
    }

    //pixhawk safety button
    translate([batWidth*0.75+1,0,4+11/2]) rotate([0, 90, 0]) cylinder(d=8.25, h=12);
    translate([0, -1, -1]) cube([batWidth,2,4+11/2+2]);
}

*%translate([0, 0, 0]) rotate([180,0,0])
import("../output/mainPlatformPart1.stl");