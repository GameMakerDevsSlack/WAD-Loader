/// buffer_read_word(file,size,bigend)
//
//  Returns a word value of a given byte-size from an open binary file.
//
//      file        file id of an open binary file, real
//      size        size of the word in bytes, real
//      bigend      true to use big-endian byte order (MSB first), bool
//
/// GMLscripts.com/license
{
    var file,size,bigend,value,i,b;
    file = argument0;
    size = argument1;
    bigend = argument2;
    value = 0;
    for (i=0; i<size; i+=1) {
        b[i] = buffer_read(file,buffer_u8);
    }
    if (bigend) for (i=0; i<size; i+=1) value = value << 8 | b[i];
    else for (i=size-1; i>=0; i-=1) value = value << 8 | b[i];
    return value;
}
