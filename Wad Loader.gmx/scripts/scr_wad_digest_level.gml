///scr_wad_digest_level(wadfile,lumps,mapname);
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
var things     = ds_list_create(),
    vertices   = ds_list_create(),
    linedefs   = ds_list_create(),
    sidedefs   = ds_list_create(),
    vertices   = ds_list_create(),
    segments   = ds_list_create(),
    subsectors = ds_list_create(),
    nodes      = ds_list_create(),
    sectors    = ds_list_create(),
    reject     = ds_list_create(),
    blockmap   = ds_list_create(),
    sectorNum = 0;
repeat (10)
{
    var section = lumps[| pos + 3],
        length = lumps[| pos + 2],
        filepos = lumps[| pos + 1];
    buffer_seek(wad,buffer_seek_start,filepos);
    switch section
    {
        case "THINGS": 
            for (var i=0;i<length/2;i++)
            {
                things[| i] = buffer_read_word(wad,2,false);
            }   
            break;
        case "LINEDEFS": 
            for (var i=0;i<length/(14/2);i++)
            {
                linedefs[| i] = buffer_read_word(wad,2,false);
            }
        break;
        case "SIDEDEFS":
            for (var i=0;i<length/30;i++)
            {
                sidedefs[| i  ] = buffer_read_word(wad,2,false);    //Tex X
                sidedefs[| i+1] = buffer_read_word(wad,2,false);    //Tex Y
                sidedefs[| i+2] = buffer_read_text(wad,8);          //UpperName
                sidedefs[| i+3] = buffer_read_text(wad,8);          //LowerName
                sidedefs[| i+4] = buffer_read_text(wad,8);          //MiddleName
                sidedefs[| i+5] = buffer_read_word(wad,2,false);    //Sector Number
            }
        break;
        case "VERTEXES": 
            for (var i=0;i<length/2;i++)
            {
                vertices[| i] = buffer_read_word(wad,2,false);
            }
        break;
        case "SEGS": 
            for (var i=0;i<length/2;i++)
            {
                segments[| i] = buffer_read_word(wad,2,false);
            }
        break;
        case "SSECTORS":
            for (var i=0;i<length/2;i++)
            {
                subsectors[| i] = buffer_read_word(wad,2,false);
            }
        break;
        case "NODES": 
            for (var i=0;i<length/2;i++)
            {
                nodes[| i] = buffer_read_word(wad,2,false);
            }
        break;
        case "SECTORS":
            for (var i=0;i<length/26;i++)
            {
                nodes[| i]   = buffer_read_word(wad,2,false);   //floor height
                nodes[| i+1] = buffer_read_word(wad,2,false);   //ceil height
                nodes[| i+2] = buffer_read_text(wad,8);         //floor texture
                nodes[| i+3] = buffer_read_text(wad,8);         //ceil texture
                nodes[| i+4]   = buffer_read_word(wad,2,false);   //light level
                nodes[| i+5]   = buffer_read_word(wad,2,false);   //type
                nodes[| i+6]   = buffer_read_word(wad,2,false);   //tag num
            }
            sectorLength = length/26;
        break;
        case "REJECT": 
            
        break;
        case "BLOCKMAP": 
            for (var i=0;i<length/2;i++)
            {
                blockmap[| i] = buffer_read_word(wad,2,false);
            }
        break;
    }
    pos += 3;
}
var str = "x:" + string(things[| 0]) + "#y:" + string(things[| 1]) + "#a:" + string(things[| 2]);
return list(things,vertices,linedefs,sidedefs,vertices,segments,subsectors,nodes,sectors,reject,blockmap);
//show_message(str);
