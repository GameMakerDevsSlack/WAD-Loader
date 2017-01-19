///scr_wad_digest_level(wadfile,lumps,ExMy or MAPxx);
// wadfile - file to read from
// lumps   - ds list of data lumps from WAD directory
// mapname - self-exeplanatory - either in ExMy or MAPxx format - depending on the game

var file = argument0,
    lump = argument1,
    map = argument2;

var pos = ds_list_find_index(lump,map);
if pos == -1
{
    return noone;
}
var things = ds_list_create(),
    vertices = ds_list_create(),
    linedefs = ds_list_create();
repeat (10)
{
    var section = lumps[| pos + 3],
        length = lumps[| pos + 2],
        filepos = lumps[| pos + 1];
    switch section
    {
        case "THINGS": 
                file_bin_seek(wad,filepos);
                for (var i=0;i<length/2;i++)
                {
                    things[| i] = file_bin_read_word(wad,2,false);
                }   
            break;
        case "LINEDEFS": 
        
        break;
    }
    pos += 3;
}
var str = "x:" + string(things[| 0]) + "#y:" + string(things[| 1]) + "#a:" + string(things[| 2]);
show_message(str);
