///image_load_finish()

var _l_image      = __s_group[| 0 ];
var _l_background = __s_group[| 1 ];

draw_enable_alphablend( false );

// SORT THEIR IMAGES BY THEIR SIZE
for( var n = 0; n < ds_list_size( __s_l_background ); n += 6 ){
    var _size = ( ( background_get_width( __s_l_background[| n ] ) div __s_l_background[| n + 2 ] ) + background_get_height( __s_l_background[| n ] ) ) / 2;
    if( ds_list_size( __s_l_back_sorted ) > 0 ){
        for( var i = 0; i < ds_list_size( __s_l_back_sorted ); i += 7 ){
            if( _size > __s_l_back_sorted[| i ] ){
ds_list_insert( __s_l_back_sorted , i , __s_l_background[| n + 5 ] ); // FNAME
                ds_list_insert( __s_l_back_sorted , i , __s_l_background[| n + 4 ] ); // YORIG
                ds_list_insert( __s_l_back_sorted , i , __s_l_background[| n + 3 ] ); // XORIG
                ds_list_insert( __s_l_back_sorted , i , __s_l_background[| n + 2 ] ); // SUBIMG
                ds_list_insert( __s_l_back_sorted , i , __s_l_background[| n + 1 ] ); // IDENTIFIER
                ds_list_insert( __s_l_back_sorted , i , __s_l_background[| n ] );     // ID
                ds_list_insert( __s_l_back_sorted , i , _size );
                break;
            } else if( i == ds_list_size( __s_l_back_sorted ) - 7 ){
                ds_list_add( __s_l_back_sorted , 
                    _size ,                      // SIZE
                    __s_l_background[| n ] ,     // ID
                    __s_l_background[| n + 1 ] , // IDENTIFIER
                    __s_l_background[| n + 2 ] , // SUBIMG
                    __s_l_background[| n + 3 ] , // XORIG
                    __s_l_background[| n + 4 ] , // YORIG
__s_l_background[| n + 5 ]   // FNAME
                );
                break;
            }
        }
    } else {
        ds_list_add( __s_l_back_sorted , 
            _size ,                      // SIZE
            __s_l_background[| n ] ,     // ID
            __s_l_background[| n + 1 ] , // IDENTIFIER
            __s_l_background[| n + 2 ] , // SUBIMG
            __s_l_background[| n + 3 ] , // XORIG
            __s_l_background[| n + 4 ] , // YORIG
__s_l_background[| n + 5 ]   // FNAME
        );
    }
}



// CREATE THE DATA STRUCTURES NECESSARY FOR ADDING THE SPRITES ON THE TEXTURE PAGE
temp_sprite_get = ds_map_create();

var _l_areas = ds_list_create();
var _l_trash = ds_list_create();
ds_list_add( _l_areas , 0 , 0 , __s_tex_width , __s_tex_height );

var _l_texpage = ds_list_create();
var _back = background_create_colour( __s_tex_width , __s_tex_height , c_black );
ds_list_add( _l_texpage , 
    surface_create( __s_tex_width , __s_tex_height ) , 
    _back
);

surface_set_target( _l_texpage[| ds_list_size( _l_texpage ) - 2 ] );
draw_clear_alpha( 0,0 ); // this can be removed
var _bck = -1;

while( ds_list_size( __s_l_back_sorted ) > 0 ){ // LOOP THROUGH THE SPRITES AND ADD THEM TO THE TEXTURE PAGE WHERE POSSIBLE
    _bck = __s_l_back_sorted[| 1 ];
    
    var spr_number = __s_l_back_sorted[| 3 ];
    var subimg_w = background_get_width( _bck ) div spr_number;
    var _image_drawn = false;
    var _image_maindata_added = false;
    for( var i = 0; i < __s_l_back_sorted[| 3 ]; i++ ){
        var _min_area_size = $10000000000000;
        var _min_area_id   = -1;
        for( var n = 0; n < ds_list_size( _l_areas ); n += 4 ){
            if( subimg_w <= _l_areas[| n + 2 ] and background_get_height( _bck ) <= _l_areas[| n + 3 ] ){
                if( ( ( _l_areas[| n + 2 ] + _l_areas[| n + 3 ] ) / 2 ) < _min_area_size ){
                    _min_area_size = ( _l_areas[| n + 2 ] + _l_areas[| n + 3 ] ) / 2;
                    _min_area_id = n;
                }
            }
        }
        
        // DRAW THE IMAGES ON THE TEXTURE PAGE
        if( _min_area_id != -1 ){
            n = _min_area_id;
            draw_background_part( _bck , i * subimg_w  , 0 , subimg_w , background_get_height( _bck ) , _l_areas[| n ] , _l_areas[| n + 1 ] );
            _image_drawn = true;
            
            if( !_image_maindata_added ){
                // CREATE THE GRID FOR THE IMAGE DATA
                var _g_image = ds_grid_create( 7 + __s_l_back_sorted[| 3 ] * 3 , 1 );
                ds_list_add( _l_image , _g_image );
                var _pos = 0;
                // ADD THE IDENTIFIER TO THE MAP, THE USER WILL GRAB THE SPRITE ID FROM THIS MAP
                ds_map_add( temp_sprite_get , __s_l_back_sorted[| 2 ] , _g_image );
                // ADD THE MAIN DATA OF THE SPRITE TO THE SPRITE DATA STRUCTURE
                _g_image[# _pos , 0 ] = __s_l_back_sorted[| 2 ]; _pos++;       // IDENTIFIER
                _g_image[# _pos , 0 ] = __s_l_back_sorted[| 3 ]; _pos++;       // SUBIMAGE
                _g_image[# _pos , 0 ] = subimg_w; _pos++;                      // SUBIMAGE WIDTH
                _g_image[# _pos , 0 ] = background_get_height( _bck ); _pos++; // SUBIMAGE HEIGHT
                _g_image[# _pos , 0 ] = __s_l_back_sorted[| 4 ]; _pos++;       // XORIGIN
                _g_image[# _pos , 0 ] = __s_l_back_sorted[| 5 ]; _pos++;       // YORIGIN
                _image_maindata_added = true;
            }
            
            // ADD THE SUBIMAGE OF THE SPRITE TO THE SPRITE DATA STRUCTURE
            _g_image[# _pos , 0 ] = _back; _pos++;              // BACKGROUND
            _g_image[# _pos , 0 ] = _l_areas[| n ]; _pos++;     // X
            _g_image[# _pos , 0 ] = _l_areas[| n + 1 ]; _pos++; // Y
            
            if( i == __s_l_back_sorted[| 3 ] - 1 ){
                _g_image[# _pos , 0 ] = __s_l_back_sorted[| 6 ]; // FNAME
            }

            // ADD THE NEW EMPTY AREAS TO THE AREA LIST
            if( background_get_height( _bck ) < _l_areas[| n + 3 ] ){              // Y                                          W                           H
                ds_list_add( _l_areas , _l_areas[| n ] , _l_areas[| n + 1 ] + background_get_height( _bck ) + __s_tex_offset , _l_areas[| n + 2 ] , _l_areas[| n + 3 ] - background_get_height( _bck ) - __s_tex_offset );
            }
            if( subimg_w < _l_areas[| n + 2 ] ){ // X                                 Y                                          W                           H
                ds_list_add( _l_areas , _l_areas[| n ] + subimg_w + __s_tex_offset , _l_areas[| n + 1 ] , _l_areas[| n + 2 ] - subimg_w - __s_tex_offset , background_get_height( _bck ) );
            }
            
            // REMOVE THE CURRENT AREA FROM THE AREA LIST
            repeat( 4 )
                ds_list_delete( _l_areas , n );
        } else {
            show_debug_message( "Warning: Not enough room on the texturepage, creating another one, this might slow down the game" );
            
            ds_list_clear( _l_areas );
            ds_list_add( _l_areas , 0 , 0 , __s_tex_width , __s_tex_height );
            
            _back = background_create_colour( __s_tex_width , __s_tex_height , c_black );
            ds_list_add( _l_texpage , surface_create( __s_tex_width , __s_tex_height ) , _back);
            surface_reset_target();
            surface_set_target( _l_texpage[| ds_list_size( _l_texpage ) - 2 ] );
            draw_clear_alpha( 0,0 );
            
            i--;
        }
    }
    
    if( ds_list_size( _l_areas ) == 0 ){
        show_debug_message( "Warning: Something went wrong, creating another texturepage" );
        
        ds_list_clear( _l_areas );
        ds_list_add( _l_areas , 0 , 0 , __s_tex_width , __s_tex_height );
        
        _back = background_create_colour( __s_tex_width , __s_tex_height , c_black );
        ds_list_add( _l_texpage , surface_create( __s_tex_width , __s_tex_height ) , _back );
        surface_reset_target();
        surface_set_target( _l_texpage[| ds_list_size( _l_texpage ) - 2 ] );
    }
    if( _image_drawn ){
        repeat( 7 ){
            ds_list_delete( __s_l_back_sorted , 0 );
        }
        ds_list_add( _l_trash , _bck );
    }
}
surface_reset_target();

// Clear memory
for( var n = 0; n < ds_list_size( _l_trash ); n++ ){
    background_delete( _l_trash[| n ] );
}
// CREATE THE BACKGROUND (TEXTUREPAGE)
for( var n = 0; n < ds_list_size( _l_texpage ); n += 2 ){
    var _back_temp = background_create_from_surface( _l_texpage[| n ] , 0 , 0 , surface_get_width( _l_texpage[| n ] ) , surface_get_height( _l_texpage[| n ] ) , false , false );
    background_assign( _l_texpage[| n + 1 ] , _back_temp );
    ds_list_add( _l_background , _l_texpage[| n + 1 ] );
    background_delete( _back_temp );
    surface_free( _l_texpage[| n ] );
}


// 3D specific images.
while( ds_list_size( __s_l_background_3d ) > 0 ){
    var _back       = __s_l_background_3d[| 0 ];
    var _identifier = __s_l_background_3d[| 1 ];
    var _subimg     = __s_l_background_3d[| 2 ];
    var _xorig      = __s_l_background_3d[| 3 ];
    var _yorig      = __s_l_background_3d[| 4 ];
    var _w          = floor( background_get_width( _back ) / _subimg );
    var _surface    = surface_create( _w , background_get_height( _back ) );
    
    var _g_image = ds_grid_create( 7 + _subimg * 3 , 1 );
    ds_list_add( _l_image , _g_image );
    var _pos = 0;
    _g_image[# _pos , 0 ] = _identifier; _pos++;                    // IDENTIFIER
    _g_image[# _pos , 0 ] = _subimg; _pos++;                        // SUBIMAGE
    _g_image[# _pos , 0 ] = _w; _pos++;                             // SUBIMAGE WIDTH
    _g_image[# _pos , 0 ] = background_get_height( _back ); _pos++; // SUBIMAGE HEIGHT
    _g_image[# _pos , 0 ] = _xorig; _pos++;                         // XORIGIN
    _g_image[# _pos , 0 ] = _yorig; _pos++;                         // YORIGIN
    
    for( var n = 0; n < _subimg; n++ ){
        surface_set_target( _surface );
        draw_clear_alpha( 0 , 0 );
        draw_background_part( _back , n * _w , 0 , n * _w + _w , background_get_height( _back ) , 0 , 0 );
        surface_reset_target();
        var _back_subimg = background_create_from_surface( _surface , 0 , 0 , _w , background_get_height( _back ) , false , false );
        ds_list_add( _l_background , _back_subimg );
        _g_image[# _pos , 0 ] = _back_subimg; _pos++; // BACKGROUND
        _g_image[# _pos , 0 ] = 0; _pos++;            // X
        _g_image[# _pos , 0 ] = 0; _pos++;            // Y
    }
    _g_image[# ds_grid_width( _g_image ) - 1 , 0 ] = __s_l_background_3d[| 5 ];
    
    ds_map_add( temp_sprite_get , _identifier , _g_image );
    surface_free( _surface );
    background_delete( _back );
    
    repeat( 6 ){
        ds_list_delete( __s_l_background_3d , 0 );
    }
}
draw_enable_alphablend( true );

// Clear memory
ds_list_destroy( _l_areas );
ds_list_destroy( __s_l_back_sorted );
ds_list_destroy( __s_l_background );
ds_list_destroy( __s_l_background_3d );
ds_list_destroy( _l_trash );
ds_list_destroy( _l_texpage );    
