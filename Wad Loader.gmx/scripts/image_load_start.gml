///image_load_start(group,tex_page_width,tex_page_height,tex_offset)
if( !ds_map_exists( global.m_ex_image , argument0 ) ){
    show_error( "Unknown image group '" + string( argument0 ) + "'" , true );
}
__s_group      = global.m_ex_image[? argument0 ];
__s_tex_width  = argument1; // TEXTURE PAGE WIDTH
__s_tex_height = argument2; // TEXTURE PAGE HEIGHT
__s_tex_offset = argument3; // SPRITE OFFSET ON THE TEXTURE PAGE

// LIST THAT WILL STORE THE UNSORTED LOADING SPRITE DATA
__s_l_background    = ds_list_create();
// LIST THAT WILL STORE THE SORTED LOADING SPRITE DATA
__s_l_back_sorted   = ds_list_create();
// LIST THAT WILL STORE THE 3D LOADING SPRITE DATA
__s_l_background_3d = ds_list_create();
