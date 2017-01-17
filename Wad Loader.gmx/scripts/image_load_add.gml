///image_load_add(identifier,fname,subimg,xorig,yorig)
if( file_exists( argument1 ) ){
    ds_list_add( __s_l_background , background_add( argument1 , false , false ) , string( argument0 ) , max(argument2,1) , argument3 , argument4 , argument1 );
} else {
    show_error( "Could not load image from location '" + string( argument1 ) + "'" , true );
}
