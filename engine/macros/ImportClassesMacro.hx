package macros;
import haxe.macro.Expr;
class ImportClassesMacro {
  @:macro public static function write() : Expr {
    var controller_files = neko.FileSystem.readDirectory("./app/controllers/");
    var controllers = new Array<String>();
    for(controller_file_name in controller_files){
      if(!StringTools.startsWith(controller_file_name, ".")){
        controllers.push("import controllers."+controller_file_name.substr(0,-3)+";");
      }
    }
    
    var model_files = neko.FileSystem.readDirectory("./app/models/");
    var models = new Array<String>();
    for(model_file_name in model_files){
      if(!StringTools.startsWith(model_file_name, ".")){
        models.push("import models."+model_file_name.substr(0,-3)+";");
      }
    }
    
    var helper_files = neko.FileSystem.readDirectory("./app/helpers/");
    var helpers = new Array<String>();
    for(helper_file_name in helper_files){
      if(!StringTools.startsWith(helper_file_name, ".")){
        helpers.push("import helpers."+helper_file_name.substr(0,-3)+";");
      }
    }
    
    var imploded = "package macros;\n"+
    models.join("\n")+"\n"+
    controllers.join("\n")+"\n"+
    helpers.join("\n") +
    "\nclass ImportClasses{}";

    var file = neko.io.File.write("./engine/macros/ImportClasses.hx", false);
    file.writeString(imploded);
    file.close();
    

    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() };
  }
  
  // used only by ./autopilot/engage.n and ./autopilot/abort.n
  @:macro public static function import_schemes() : Expr {
    var scheme_files = neko.FileSystem.readDirectory("./plot/schemes/");
    var schemes = new Array<String>();
    for(scheme_file_name in scheme_files){
      if(!StringTools.startsWith(scheme_file_name, ".")){
        schemes.push("import "+scheme_file_name.substr(0,-3)+";");
      }
    }
    
    var imploded = schemes.join("\n");
    imploded += "\nclass ImportSchemes{}";

    var file = neko.io.File.write("./plot/ImportSchemes.hx", false);
    file.writeString(imploded);
    file.close();
    

    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() };
  }
  
  @:macro public static function compileRunwayClasses() : Expr
	{
	  var imports = new Array<String>();
	  #if engine
	    var engine_test_classes = neko.FileSystem.readDirectory("./engine/runway/engine");
      for(engine_test_class in engine_test_classes){
        if(!StringTools.startsWith(engine_test_class, ".")){
          imports.push("import runway.engine."+engine_test_class.substr(0,-3)+";");
        }
      }
	  #end
	  #if cargo
	  var cargo_test_classes = neko.FileSystem.readDirectory("./cargo");
	  for(crate_name in cargo_test_classes){
      if(!StringTools.startsWith(crate_name, ".")){
        if(neko.FileSystem.exists("./"+crate_name+"/Runway.hx")){
           imports.push("import "+crate_name+".Runway;");
        }
      }
    }
	  #end
	  
	  #if app
      var unit_test_classes = neko.FileSystem.readDirectory("./runway/unit");
      for(unit_test_class in unit_test_classes){
        if(!StringTools.startsWith(unit_test_class, ".")){
          imports.push("import unit."+unit_test_class.substr(0,-3)+";");
        }
      }
      var integration_test_classes = neko.FileSystem.readDirectory("./runway/integration");
      for(integration_test_class in integration_test_classes){
        if(!StringTools.startsWith(integration_test_class, ".")){
          imports.push("import integration."+integration_test_class.substr(0,-3)+";");
        }
      }
      #if views
        var views_test_classes = neko.FileSystem.readDirectory("./runway/views");
        for(views_test_class in views_test_classes){
          if(!StringTools.startsWith(views_test_class, ".")){
            imports.push("import views."+views_test_class.substr(0,-3)+";");
          }
        }
      #end
    #end
    
    var imploded = "package runway;\n"+imports.join("\n")+"\nclass ImportRunways{}";

    var file = neko.io.File.write("./engine/runway/ImportRunways.hx", false);
    file.writeString(imploded);
    file.close();
    
    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() }
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