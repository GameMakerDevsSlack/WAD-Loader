///draw_list(x,y,list,sep,w);
var str = "";
for (var i=0, size = ds_list_size(argument2);i<size;i++)
{
    str += string(argument2[| i]);
    if (i+1) < size
    {
        str += ", "
    }
}draw_text_ext(argument0,argument1,str,argument3,argument4);
