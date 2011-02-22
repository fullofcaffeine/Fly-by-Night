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
class Engage
{
  public static inline var SCHEME_VERSION_TABLE_NAME = "schemes_plotted";
  private static inline function display_help(  ):Void
  {
    Lib.print("Autopilot script 'engage' 
for Fly by Night haXe web framework

Egages all schemes that have not been executed.

Default Environment is 'development' 

Usage:    neko ./autopilot/engage.n
Same as:  neko ./autopilot/engage.n development
Other:    neko ./autopilot/engage.n production

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
    if(!Reflect.hasField(DBAdapters,db_config.node.adapter.innerData)){
      throw("ERROR! Fly by Night does not support adapter: "+db_config.node.adapter.innerData+"
Please set adapter to one of "+Type.getEnumConstructs(DBAdapters)+"
Feel free to fork Fly by Night and add support for it.
https://github.com/theRemix/Fly-by-Night");
      return;
    }
    
    var adapter = Reflect.field(DBAdapters,db_config.node.adapter.innerData);
    var connection:Connection;
    var _database:String = "";
    
    if(adapter == DBAdapters.sqlite3){
      if(!db_config.hasNode.database){
        throw("ERROR! 'database' name is not set for sqlite3 adapter.
Fix it! at ./config/database.yml");
        return;
      }
      var database = db_config.node.database.innerData + ".sqlite3";
      
      connection = Sqlite.open("./plot/"+database);
      
      if(!FileSystem.exists("./plot/"+database)){
        throw("ERROR creating sqlite3 database at ./plot/"+database+"
is the directory ./plot/ writable?");
        return;
      }
      
    }else{ // MYSQL
      var _host = (db_config.hasNode.host)? db_config.node.host.innerData : "";
      var _port = (db_config.hasNode.port)? Std.parseInt(db_config.node.port.innerData) : 3306;
      _database = (db_config.hasNode.database)? db_config.node.database.innerData : "";
      var _user = (db_config.hasNode.user)? db_config.node.user.innerData : "";
      var _pass = (db_config.hasNode.pass)? db_config.node.pass.innerData : "";
      var _socket = (db_config.hasNode.socket)? db_config.node.socket.innerData : "";
      connection = neko.db.Mysql.connect({ 
          host : _host,
          port : _port,
          database : _database,
          user : _user,
          pass : _pass,
          socket : _socket
      });
    }


    if(connection != null){
    
      var schemes_in_db:List<Dynamic>;
      if(adapter == DBAdapters.sqlite3){
        schemes_in_db = connection.request("SELECT name FROM sqlite_master WHERE type='table' AND name='"+SCHEME_VERSION_TABLE_NAME+"'").results();
      }else{ // mysql
        schemes_in_db = connection.request("SHOW Tables IN "+_database+" WHERE Tables_in_"+_database+" = '"+SCHEME_VERSION_TABLE_NAME+"';").results();
      }
    
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
          scheme = Type.createInstance(Type.resolveClass(class_name), [connection, adapter]);
          Lib.print("\n==  "+class_name+": Running ==");
          scheme.engage();
          connection.request("INSERT INTO schemes_plotted (phase) VALUES ("+phase+") ");
          Lib.print("\n==  "+class_name+": Engaged! ==");
        }
      
      }
    
      connection.close();
    
      Lib.print("\n==  Schemes are all plotted. ==");
    }else{
      Lib.print("\n==  Error creating a connection to db. ==");
    }
	}
}