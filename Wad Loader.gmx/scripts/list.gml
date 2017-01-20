///list(item0,item1...)
for (var i=0,l=ds_list_create();i<argument_count;i++)
{
    l[| i] = argument[i];
}
return l;
