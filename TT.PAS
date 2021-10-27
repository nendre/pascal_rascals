Uses App;
type myapp = object(TApplication)
             end;
var qw:myapp;
Begin
 qw.init;
 qw.Dosshell;
 qw.done;
End.