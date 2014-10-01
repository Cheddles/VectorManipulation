//class Arrow{
//  
//  int[] colour = new int[3];  // RBG values for the arrow
//  int lineThickness;  // line weight for the arrow
//  
//  Arrow(int red, int green, int blue, int weight){
//    colour[0]=red;
//    colour[1]=green;
//    colour[2]=blue;
//    lineThickness=weight;
//  }
//  
//  void display(int x1, int y1, int x2, int y2){
//    float angle=atan(float(y2-y1)/float(x2-x1));
//    if (x2<x1) angle=angle+PI;
//    float len = pow(pow(x2-x1,2)+pow(y2-y1,2),0.5);
//    strokeWeight(lineThickness);
//    stroke(colour[0], colour[1], colour[2]);
//    pushMatrix();
//      translate(x1, y1);
//      rotate(angle);
//      line(0,0,len, 0);
//      line(len, 0, len - min(10, len/3), -min(10,len/3));
//      line(len, 0, len - min(10, len/3), min(10,len/3));
//    popMatrix();
//    // display the value
//
//  }
//  
//}
