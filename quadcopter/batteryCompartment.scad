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
        intersection()
        {
            translate([0,0,batHeight/3+5]) scale([1,1,1.5]) ellipsoid(w=batWidth/2+15, h=batLength/2+30);
            translate([-50, -100, 0]) cube([100, 200, batHeight+5+5]);
        }
        
        
        %translate([-batWidth/2, -batLength/2, 5]) cube([batWidth, batLength, batHeight]);
    }
    
    //battery container's attaching holes
    #for(i=[1,-1]) for(j=[1,-1])
    {
        translate([i*(baseWidth*0.535), j*baseLength*0.7, -1]) 
            cylinder(r=1.7, h=10+1);
    }
    
}