enum types {
    UltimateDOOM,
    DOOM2
}

var fname = argument0;
wad = file_bin_open(fname, 0);

header = "";
repeat (4)
{
    header += chr(file_bin_read_byte(wad));
}  
numlumps = file_bin_read_word(wad,4,false);    //DOOM ints are Little Endian
infoOffset = file_bin_read_word(wad,4,false);
var size = file_bin_size(wad);
file_bin_seek(wad,infoOffset);

lumps = ds_list_create();

for (var i=0;i<numlumps;i++)
{
    lumps[| i*3]   = file_bin_read_word(wad,4,false);       //filepos
    lumps[| i*3+1] = file_bin_read_word(wad,4,false);       //size
    lumps[| i*3+2] = "";
    repeat (8)
    {
        lumps[| i*3+2] += chr(file_bin_read_byte(wad));     //name
    }
}
mapType = types.UltimateDOOM;               //ExMy format used in UltDOOM  WADs
if ds_list_find_index(lumps,"MAP01")        //MAPxx format used in DOOM 2  WADs
{
    mapType = types.DOOM2;
}
copy_list_text(lumps);
//read palettes
//Palettes - 16x16 - 256 colours each
var pos = lumps[| ds_list_find_index(lumps,"PLAYPAL")-2];
numPalettes = ( lumps[| ds_list_find_index(lumps,"PLAYPAL")-1]/(768) );
file_bin_seek(wad,pos);
paletteColour[numPalettes-1,255] = 0;
palettes[numPalettes] = 0;
for (var i=0;i<numPalettes;i++)
{
    palettes[i] = surface_create(16,16);
    surface_set_target(palettes[i]);
    for (var j=0;j<256;j++)     //256 colours in a palette
    {
        var r = file_bin_read_byte(wad),
            g = file_bin_read_byte(wad),
            b = file_bin_read_byte(wad),
            c = make_color_rgb(r,g,b),
            xx= floor(j/16),
            yy= j mod 16;
            
            paletteColour[i,j] = c;
            draw_set_color(c);
            draw_point(xx,yy);
    }
    surface_reset_target();
    paletteBuffer[i] = buffer_create(1024,buffer_grow,1);
    buffer_get_surface(paletteBuffer[i],palettes[i],0,0,0);
    show_debug_message("Palette " + string(i) + " completed");
}
scr_wad_digest_level(wad,lumps,"E1M1")
