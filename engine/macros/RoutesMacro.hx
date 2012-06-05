package macros;
import yaml_crate.YamlHX;
import haxe.macro.Expr;
class RoutesMacro {
  private static var names: Array<String>;
  
  @:macro public static function write() : Expr {
    var imploded = "";
    if(neko.FileSystem.exists('./config/routes.yml')){
      // check if config has db setup for env
      var routes_yml = YamlHX.read(neko.io.File.getContent('./config/routes.yml'));
      names = new Array<String>();
      var name:String;
      // find route
      for (e in routes_yml.elements ){
        if(e.name == "map"){
          if(e.hasNode.name)
            names_push(e.node.name.innerData);
        }else if(e.name == "rest"){
          name = Std.string(Utils.singularize(Utils.to_underscore(e.innerData))).toLowerCase();
          names_push(Utils.pluralize(name));
          names_push(name);
          names_push("new_"+name);
          names_push("create_"+name);
          names_push("edit_"+name);
          names_push("update_"+name);
          names_push("destroy_"+name);
        }
      }
      
      imploded = "enum Routes{\nroot;\n"+names.join(";\n")+";\n}";


      var file = neko.io.File.write("./engine/Routes.hx", false);
      file.writeString(imploded);
      file.close();
    }
    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() };
  }
  
  private static inline function names_push( name:String ):Void
  {
    if(!Lambda.has(names, name)){
      names.push(name);
    }
  }
 
}