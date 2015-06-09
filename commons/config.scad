/**
 * config.scad
 * 
 * Constants and common methods used for the multi-copter
 * 
 */

//wire openning
wireDiameter = 8;


// suavizar las superficies curvas
//$fs= 1 ; 
//$fa= 1 ; 


///////////// armMount
entryWidth = 50.75/2;
entryHeight = 18.25/2;
entryDepth = 12;

outputWidth = 45/2; //49/2;
outputHeight = 18/2;
outputDepth = 8 +15; //For modelling, this is the position of the further ellipse


armLength = 184; //from the beginning of armMount/malePart to the center of motorMount

//auxiliary method
module oval(w,h, height, center = false) {
 scale([1, h/w, 1]) cylinder(h=height, r=w, center=center);
}


//auxiliary method
module nestedHull()
{
  for(i=[0:$children-2])
    hull()
    {
      children(i);
      children(i+1);
    }
}

//hexer module
hexagon_d = 10;
hexagon_x = 9;
hexagon_y = 5;
hexagon_h = 50; // centered

min_x = - 150;
max_x = 150;
min_y = -100;
max_y = 100;

wall_t = 5;
module hollowify()
difference(convexity=10){
    children(0); 
    linear_extrude(center=true,convexity=10){
        difference(){
            // hexagon array
            for(
                x=[min_x:hexagon_x*2:max_x], 
                y=[min_y:hexagon_y*2:max_y]
            ) translate([x, y, 0]) {
                circle(d=hexagon_d,  center=true, $fn=6);
                translate([hexagon_x, hexagon_y, 0]) circle(d=hexagon_d, center=true, $fn=6);
            }

            minkowski(){
                difference(){
                    translate([min_x, min_y, 0])
                        square([hexagon_x + max_x-min_x, hexagon_y + max_y-min_y]);
                    projection() children(0); 
                }
                circle(r=wall_t);
            }
        }
    }
}
