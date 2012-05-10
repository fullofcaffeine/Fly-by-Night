package macros;
import yaml_crate.YamlHX;
import haxe.macro.Expr;
class RoutesMacro {
  @:macro public static function write() : Expr {
    var imploded = "";
    if(neko.FileSystem.exists('./config/routes.yml')){
      // check if config has db setup for env
      var routes_yml = YamlHX.read(neko.io.File.getContent('./config/routes.yml'));
      var names = new Array<String>();
      var name:String;
      // find route
      for (e in routes_yml.elements ){
        if(e.name == "map"){
          if(e.hasNode.name)
            names.push(e.node.name.innerData);
        }else if(e.name == "rest"){
          name = Std.string(Utils.singularize(Utils.to_underscore(e.innerData))).toLowerCase();
          names.push(Utils.pluralize(name));
          names.push(name);
          names.push("new_"+name);
          names.push("create_"+name);
          names.push("edit_"+name);
          names.push("update_"+name);
          names.push("destroy_"+name);
        }
      }
      
      imploded = "enum Routes{\nroot;\n"+names.join(";\n")+";\n}";


      var file = neko.io.File.write("./engine/Routes.hx", false);
      file.writeString(imploded);
      file.close();
    }
    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() };
  }
 
}