import yaml_crate.YamlHX;
import php.io.File;
import php.FileSystem;
import php.db.Connection;
import php.db.Sqlite;
import php.db.Mysql;
import php.db.Manager;
class DBConnection
{
  private static var _connection:Connection;
  public static var connection(get_connection,set_connection):Connection;
  private static function get_connection():Connection{ 
    if (_connection == null){
      var env = Settings.get("FBN_ENV");
      // check if db config has env set
  		if(!FileSystem.exists(Settings.get('FBN_ROOT')+'./config/database.yml')){
        throw("ERROR! ./config/database.yml config file does not exist.");
        return null;
      }

      // check if config has db setup for env
      var db_config_yml = YamlHX.read(File.getContent(Settings.get('FBN_ROOT')+'./config/database.yml'));
      if(!db_config_yml.hasNode.resolve(env)){
        throw("ERROR! ./config/database.yml config does not define connection for: "+env);
        return null;
      }

      var db_config = db_config_yml.node.resolve(env);
      if(!Reflect.hasField(DBAdapters,db_config.node.adapter.innerData)){
        throw("ERROR! Fly by Night does not support adapter: "+db_config.node.adapter.innerData+"
  Please set adapter to one of "+Type.getEnumConstructs(DBAdapters)+"
  Feel free to fork Fly by Night and add support for it.
  https://github.com/theRemix/Fly-by-Night");
        return null;
      }

      var adapter = db_config.node.adapter.innerData;

  /*    if(adapter == Adapter.sqlite3.toString()){*/
        if(!db_config.hasNode.database){
          throw("ERROR! 'database' name is not set for sqlite3 adapter.
  Fix it! at ./config/database.yml");
          return null;
        }
        var database = db_config.node.database.innerData;

        _connection = Sqlite.open(Settings.get('FBN_ROOT')+"./plot/"+database);
        /*
        cnx = Mysql.connect({ 
            host : "localhost",
            port : 3306,
            database : "MyDatabase",
            user : "root",
            pass : "",
            socket : null
        });
        */

        if(!FileSystem.exists(Settings.get('FBN_ROOT')+"./plot/"+database)){
          throw("ERROR creating sqlite3 database at ./plot/"+database+"
  is the directory ./plot/ writable?");
          return null;
        }
        
        
        Manager.cnx = _connection;
        Manager.initialize();
        
    }
    return _connection; }
  private static function set_connection( val:Connection ):Connection{ _connection = val; return _connection; }
  
  /*public function new()
    {
      
    }*/
  public static function close(  ):Void
  {
    if(_connection != null){
      Manager.cleanup();
      _connection.close();
    }
    
  }
}