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

      var adapter = Reflect.field(DBAdapters,db_config.node.adapter.innerData);
      
      if(adapter == DBAdapters.sqlite3){
        if(!db_config.hasNode.database){
          throw("ERROR! 'database' name is not set for sqlite3 adapter.
  Fix it! at ./config/database.yml");
          return null;
        }
        var database = db_config.node.database.innerData;

        _connection = Sqlite.open(Settings.get('FBN_ROOT')+"./plot/"+database);
      
        if(!FileSystem.exists(Settings.get('FBN_ROOT')+"./plot/"+database)){
          throw("ERROR creating sqlite3 database at ./plot/"+database+"
  is the directory ./plot/ writable?");
          return null;
        }
      }else{ // MYSQL
        var _host = (db_config.hasNode.host)? db_config.node.host.innerData : "";
        var _port = (db_config.hasNode.port)? Std.parseInt(db_config.node.port.innerData) : 3306;
        var _database = (db_config.hasNode.database)? db_config.node.database.innerData : "";
        var _user = (db_config.hasNode.user)? db_config.node.user.innerData : "";
        var _pass = (db_config.hasNode.pass)? db_config.node.pass.innerData : "";
        var _socket = (db_config.hasNode.socket)? db_config.node.socket.innerData : "";
        _connection = Mysql.connect({ 
            host : _host,
            port : _port,
            database : _database,
            user : _user,
            pass : _pass,
            socket : _socket
        });
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