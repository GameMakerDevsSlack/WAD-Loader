///draw_image_general(sprite,subimg,left,top,width,height,x,y,xscale,yscale,rot,c1,c2,c3,c4,alpha)
gml_pragma("forceinline"); // in YYC, proccessing boost

var _c_subimg = ( floor(argument1) mod argument0[# 1 , 0 ] ) * 3;
draw_background_general(
    argument0[# 6 + _c_subimg , 0 ] , 
    argument0[# 7 + _c_subimg , 0 ] + argument2 ,
    argument0[# 8 + _c_subimg , 0 ] + argument3 ,
    argument4 ,
    argument5 ,
    argument6 ,
    argument7 ,
    argument8 ,
    argument9 ,
    argument10 ,
    argument11 ,
    argument12 ,
    argument13 ,
    argument14 ,
    argument15
);
