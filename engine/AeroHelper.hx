/*
  To see a full list of auto imported classes for all subclasses of AeroHelper
  See LandingGearMacro.APPEND_TO_HELPER 
  
  NOTE: #FIX TODO
  on -D nodejs
  if a helper method isn't found, and called from template
  the server will crash and exit out
  
*/
class AeroHelper
{
  public var controller: AeroController;
  public var yield: String;
  /* if  private var load_helpers: Array<Dynamic>  exists
   each is loaded 
   by HamlHX */
  
  public function new( controller:AeroController )
  {
    this.controller = controller;
  }
/*  Type.getInstanceFields(Type.getClass(helper))*/
  public function toString():String{
    var out = "[AeroHelper " + Type.getClassName(Type.getClass(this)) + "] => {\n";
    var fields = Lambda.filter(Type.getInstanceFields(Type.getClass(this)),function(f){ return !StringTools.startsWith(f,"__"); });
    var val = "";
    for(field in fields){
      //val = Std.string(Reflect.field(this,field));
      val = Reflect.field(this,field);
      if(Reflect.isFunction(Reflect.field(this,field))){
        val = Std.string(val).substr(0,Std.string(val).indexOf("{"))+"();";
      }
      out += "\t"+field+" => "+val+"\n";
    }
    out += "}";
    return out;
  }
}