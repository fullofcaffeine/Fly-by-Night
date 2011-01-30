import haxe.macro.Expr;
class ImportClassesMacro {
  @:macro public static function write() : Expr {
    var controller_files = neko.FileSystem.readDirectory("./app/controllers/");
    var controllers = new Array<String>();
    for(controller_file_name in controller_files){
      controllers.push("import controllers."+controller_file_name.substr(0,-3)+";");
    }
    
    var helper_files = neko.FileSystem.readDirectory("./app/helpers/");
    var helpers = new Array<String>();
    for(helper_file_name in helper_files){
      helpers.push("import helpers."+helper_file_name.substr(0,-3)+";");
    }
    
    var imploded = controllers.join("\n")+"\n";
    imploded += helpers.join("\n");
    imploded += "\nclass ImportClasses{}";

    var file = neko.io.File.write("./engine/ImportClasses.hx", false);
    file.writeString(imploded);
    file.close();
    

    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() };
  }
  
  // used only by ./autopilot/engage.n and ./autopilot/abort.n
  @:macro public static function import_schemes() : Expr {
    var scheme_files = neko.FileSystem.readDirectory("./plot/schemes/");
    var schemes = new Array<String>();
    for(scheme_file_name in scheme_files){
      schemes.push("import "+scheme_file_name.substr(0,-3)+";");
    }
    
    var imploded = schemes.join("\n");
    imploded += "\nclass ImportSchemes{}";

    var file = neko.io.File.write("./plot/ImportSchemes.hx", false);
    file.writeString(imploded);
    file.close();
    

    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() };
  }
  
/*    @:macro public static function import_list() : Expr {
      var controller_files = neko.FileSystem.readDirectory("./app/controllers/");
      var controllers = new Array<String>();
      for(controller_file_name in controller_files){
        controllers.push("import controllers."+controller_file_name.substr(0,controller_file_name.indexOf(".hx"))+";");
      }
      var imploded = controllers.join("\n");
      //trace(imploded);
      return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() };
    }*/
}