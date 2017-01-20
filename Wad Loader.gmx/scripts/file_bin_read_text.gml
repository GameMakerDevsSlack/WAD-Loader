///file_bin_read_text(file,length)
var str = "";
repeat (argument1)
{
    str += chr(file_bin_read_byte(argument0));
}
return str;
