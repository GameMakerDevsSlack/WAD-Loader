var str = "";
for (var i=0, size = ds_list_size(argument0);i<size;i++)
{
    str += string(argument0[| i]);
    if (i+1) < size
    {
        str += ",";
    }
}
clipboard_set_text(str);
