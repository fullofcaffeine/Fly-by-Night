/*
  TODO: dry run
*/
import neko.Lib;
import neko.Sys;
import neko.FileSystem;
import neko.io.File;
import neko.db.Sqlite;
import neko.db.Connection;
import neko.db.ResultSet;
import yaml_crate.YamlHX;
enum Adapters
{
  sqlite3;
  mysql;
}
class Engage
{
  public static inline var SCHEME_VERSION_TABLE_NAME = "schemes_plotted";
  private static inline function display_help(  ):Void
  {
    Lib.print("Autopilot script 'engage' 
for Fly by Night haXe web framework

Egages all schemes that have not been executed.

Usage : neko ./autopilot/engage.n
");
  }

	public static function main(): Void
	{
		var args = Sys.args();
    var env = "development";
		if(args.length > 0){
		  if(args[0] == "-help" || 
		  args[0] == "-h" || 
		  args[0] == "--help"){
		    display_help();
  		  return;
		  }else{
		    env = args.join("_");
		  }
		}
		
		// check if db config has env set
		if(!FileSystem.exists('./config/database.yml')){
      throw("ERROR! not in a Fly by Night project root directory
or ./config/database.yml config does not exist.");
      return;
    }
    
    // check if config has db setup for env
    var db_config_yml = YamlHX.read(File.getContent('./config/database.yml'));
    if(!db_config_yml.hasNode.resolve(env)){
      throw("ERROR! ./config/database.yml config does not define connection for: "+env);
      return;
    }
    
    var db_config = db_config_yml.node.resolve(env);
    if(!Reflect.hasField(Adapters,db_config.node.adapter.innerData)){
      throw("ERROR! Fly by Night does not support adapter: "+db_config.node.adapter.innerData+"
Please set adapter to one of "+Type.getEnumConstructs(Adapters)+"
Feel free to fork Fly by Night and add support for it.
https://github.com/theRemix/Fly-by-Night");
      return;
    }
    
    var adapter = db_config.node.adapter.innerData;
    var connection:Connection;
    
/*    if(adapter == Adapter.sqlite3.toString()){*/
      if(!db_config.hasNode.database){
        throw("ERROR! 'database' name is not set for sqlite3 adapter.
Fix it! at ./config/database.yml");
        return;
      }
      var database = db_config.node.database.innerData;
      
      connection = Sqlite.open("./plot/"+database);
      
      if(!FileSystem.exists("./plot/"+database)){
        throw("ERROR creating sqlite3 database at ./plot/"+database+"
is the directory ./plot/ writable?");
        return;
      }
      
/*    }else{ // MYSQL
      connection = neko.db.Mysql.connect({ 
          host : "localhost",
          port : 3306,
          database : "MyDatabase",
          user : "root",
          pass : "",
          socket : null
      });
      }
*/
    
    
    var schemes_in_db = connection.request("SELECT name FROM sqlite_master WHERE type='table' AND name='"+SCHEME_VERSION_TABLE_NAME+"'").results();
    
    if(schemes_in_db.length == 0){
      // create the table
      var cc = connection.request("CREATE TABLE IF NOT EXISTS "+SCHEME_VERSION_TABLE_NAME+" (phase VARCHAR(14) NOT NULL UNIQUE)");
    }
    
    schemes_in_db = connection.request("SELECT phase FROM "+SCHEME_VERSION_TABLE_NAME).results();
    
    // check if directory exists
		if(!FileSystem.exists('./plot/schemes/')){
		  connection.close();
      throw("ERROR! not in a Fly by Night project root directory
or ./plot/schemes/ directory does not exist.");
      return;
    }
    
		// compile classes
    ImportClassesMacro.import_schemes();
    ImportSchemes;
    
    var dir_list = FileSystem.readDirectory('./plot/schemes/');
    var phase = "";
    var class_name = "";
    var scheme:IScheme;
    var plotted = false;
    for(scheme_name in dir_list){
      phase = scheme_name.substr(7,14);
      
      plotted = false;
      
      for(s in schemes_in_db){
        if(s.phase == phase){
          plotted = true;
          break;
        }
      }
      
      if(!plotted){
        class_name = scheme_name.substr(0,-3);
        scheme = Type.createInstance(Type.resolveClass(class_name), [connection]);
        Lib.print("\n==  "+class_name+": Running ==");
        scheme.engage();
        connection.request("INSERT INTO schemes_plotted (phase) VALUES ("+phase+") ");
        Lib.print("\n==  "+class_name+": Engaged! ==");
      }
      
    }
    
    connection.close();
    
    Lib.print("\n==  Schemes are all plotted. ==");
    
	}
}