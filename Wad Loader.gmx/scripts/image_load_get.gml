///image_load_get(identifier)
var _val = temp_sprite_get[? string( argument0 ) ];
if( is_undefined( _val ) ){
    show_error( "A sprite with the identifier '" + string( argument0 ) + "' was not found" , false );
}
ds_map_delete( temp_sprite_get , string( argument0 ) );
// DELETE THE TEMP MAP AFTER IT HAS BEEN EMPTIED
if( ds_map_size( temp_sprite_get ) == 0 ){
    ds_map_destroy( temp_sprite_get );
}
return( _val );
