/**
 * Test models for my first quad copter
 *
 * Created by Diego Viejo 
 * 09/May/2015
 *
 */

//oval(w=10, h=5, height=2);
step = 1;
nestedHull()
{
for(i = [0: step: step*10])
    translate([0, 0, i*i])
        oval(w=10+i, h=6, height=0.1);
}

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