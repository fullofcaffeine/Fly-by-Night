import neko.Sys;
import neko.Lib;
import neko.FileSystem;
import Utils;

enum SchemeOption
{
  GENERIC;
  CREATE;
}

class Devise
{
  private static inline var commands = ["scheme"];
  private static inline function display_help(  ):Void
  {
    Lib.print("Autopilot script 'devise' 
for Fly by Night haXe web framework

Usage : neko ./autopilot/devise.n [command] [options]

Commands :
  
  help : prints this help message

  scheme : database alteration script
    Options : scheme name
    Example : neko ./autopilot/devise.n scheme add phone to users
    Creates : ./plot/schemes/Scheme_20110124163005_AddPhoneToUsers.hx
    
  scheme create : creates a new table
    Options : table name
    Example : neko ./autopilot/devise.n scheme create users
    Creates : ./plot/schemes/Scheme_20110124163010_CreateUsers.hx
    
");
  }

	public static function main(): Void
	{
		var args = Sys.args();
    
		if(args.length == 0){
		  display_help();
		  return;
		}
		
    var command = args[0];
    
    if(commands.remove(command)){
      if(args.length < 2){
        display_help();
        Lib.print("ERROR! option: 'scheme name' required for devising new scheme.");
        return;
      }else{
        args.shift();
        devise_new_scheme(args);
      }
      
    }else{
      display_help();
      if(command != "-h" && command != "help" && command != "-help" && command != "--help" )
        Lib.print("ERROR! command: '"+command+"' was caught by the feds.");
      return;
    }
	}
	
	private static function devise_new_scheme( args:Array<String> ):Void
	{
	  var scheme_template:String;
	  var option:SchemeOption;
	  var tablename:String = "";
	  if(args[0].toLowerCase() == "create"){
	    tablename = args.join("");
	    scheme_template = AeroScheme.CREATE_TABLE_TEMPLATE;
	    option = SchemeOption.CREATE;
	  }else{
	    scheme_template = AeroScheme.GENERIC_TEMPLATE;
	    option = SchemeOption.GENERIC;
	  }
	  if(args.length == 0){
	    display_help();
      Lib.print("ERROR! option: 'table name' required for scheme create.");
	    return;
	  }
	  var timestamp = Utils.timestamp();
	  var scheme_class_name = "Scheme_"+timestamp+"_"+Utils.toCamelCase(args.join("_"));
	  var schemes_dir = "./plot/schemes/";
	  if(FileSystem.exists(schemes_dir) && FileSystem.isDirectory(schemes_dir)){
	    var file = neko.io.File.write(schemes_dir+scheme_class_name+".hx", false);
	    scheme_template = StringTools.replace(scheme_template,"%NAME%",scheme_class_name);
	    if(option == SchemeOption.CREATE){
	      scheme_template = StringTools.replace(scheme_template,"%TABLENAME%",tablename.substr(6));
	    }
      file.writeString(scheme_template);
      file.close();
      
	    Lib.print(Utils.SUCCESS_CODES[Std.random(Utils.SUCCESS_CODES.length-1)]+"
Wrote "+schemes_dir+scheme_class_name+".hx
Roger that. Alert the agents.");
	    
	  }else{
	    Lib.print("ERROR! not in a Fly by Night project root directory
or ./plot/schemes/ directory does not exist!");
	  }
	}
	
}