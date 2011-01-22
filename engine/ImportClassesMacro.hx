import haxe.macro.Expr;
class ImportClassesMacro {
  @:macro public static function write() : Expr {
    var controller_files = neko.FileSystem.readDirectory("./app/controllers/");
    var controllers = new Array<String>();
    for(controller_file_name in controller_files){
      controllers.push("import controllers."+controller_file_name.substr(0,controller_file_name.indexOf(".hx"))+";");
    }
    var imploded = controllers.join("\n");
    imploded += "\nclass ImportClasses{}";

    var file = neko.io.File.write("./engine/ImportClasses.hx", false);
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