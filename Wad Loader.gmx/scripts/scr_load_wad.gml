enum types {
    UltimateDOOM,
    DOOM2
}

var fname = argument0;
wad = buffer_load(fname);

header = buffer_read_text(wad,4);
numlumps = buffer_read_word(wad,4,false);    //DOOM ints are Little Endian
infoOffset = buffer_read_word(wad,4,false);
var size = buffer_get_size(wad);
buffer_seek(wad,buffer_seek_start,infoOffset);

lumps = ds_list_create();

for (var i=0;i<numlumps;i++)
{
    lumps[| i*3]   = buffer_read_word(wad,4,false);         //filepos
    lumps[| i*3+1] = buffer_read_word(wad,4,false);         //size
    lumps[| i*3+2] = buffer_read_text(wad,8);               //name
}
mapType = types.UltimateDOOM;               //ExMy format used in UltDOOM  WADs
if ds_list_find_index(lumps,"MAP01")        //MAPxx format used in DOOM 2  WADs
{
    mapType = types.DOOM2;
}
//read palettes
//Palettes - 16x16 - 256 colours each
var pos = lumps[| ds_list_find_index(lumps,"PLAYPAL")-2];
numPalettes = ( lumps[| ds_list_find_index(lumps,"PLAYPAL")-1]/(768) );
buffer_seek(wad,buffer_seek_start,pos);
paletteColour[numPalettes-1,255] = 0;
for (var i=0;i<numPalettes;i++)
{
    for (var j=0;j<256;j++)     //256 colours in a palette
    {
        var r = buffer_read(wad,buffer_u8),
            g = buffer_read(wad,buffer_u8),
            b = buffer_read(wad,buffer_u8),
            c = make_color_rgb(r,g,b);
            
            paletteColour[i,j] = c;
    }
    show_debug_message("Palette " + string(i) + " completed");
}

var map = scr_wad_digest_level(wad,lumps,"E1M1");
var vertices = map[| 1];
var linedefs = map[| 2];
var divisor = 1;
vertex_format_begin();
vertex_format_add_position();
format = vertex_format_end();
buffer = vertex_create_buffer();
vertex_begin(buffer,format);
for (var i=0;i<ds_list_size(linedefs);i+=7)
{
    cout(vertices[| linedefs[| i  ]],vertices[| linedefs[| i+1]]);
    vertex_position(buffer,vertices[| linedefs[| i  ]]/divisor,vertices[| linedefs[| i  ]]/divisor);
    vertex_position(buffer,vertices[| linedefs[| i+1]]/divisor,vertices[| linedefs[| i+1]]/divisor);
}
copy_list_text(linedefs);
vertex_end(buffer);
