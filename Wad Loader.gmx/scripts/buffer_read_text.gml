///buffer_read_text(file,length)
var str = "";
repeat (argument1)
{
    str += chr(buffer_read(argument0,buffer_u8));
}
return str;
