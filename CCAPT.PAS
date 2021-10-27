var f:file;
    p:pointer;
begin
assign(f,'image');
rewrite(f,1);
p:=ptr($9000,0);
blockwrite(f,p^,64768);
close(f);
end.
