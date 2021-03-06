/*
  Scheme Column Options
  name : String;
  type : Type;
  default : Dynamic;
  null : Bool;
  limit : Int;
  precision : Int;
  scale : Int;
}

*/
import neko.db.Connection;
import neko.FileSystem;
import neko.io.File;
import yaml_crate.YamlHX;
import haxe.xml.Fast;
import neko.Lib;
import db.DBAdapters;
class AeroScheme
{

  public static inline var GENERIC_TEMPLATE = "// scheme devised by ./autopilot/devise
class %NAME% extends AeroScheme, implements IScheme{
  public function engage():Void
  {
    
  }
  public function abort():Void
  {
    
  }
}";
  public static inline var CREATE_TABLE_TEMPLATE = "// scheme devised by ./autopilot/devise
class %NAME% extends AeroScheme, implements IScheme{
  public function engage():Void
  {
    create_table('%TABLENAME%', null, 
'
column_name: type
timestamps
'      
    });
  }
  public function abort():Void
  {
    drop_table('%TABLENAME%');
  }
}";

  private static inline var CREATED_AT_TIMESTAMP_COLUMN = "created_at DATETIME";
  private static inline var UPDATED_AT_TIMESTAMP_COLUMN = "updated_at DATETIME";
  private var connection: Connection;
  private var db_adapter: DBAdapters;

  public function new(connection:Connection, db_adapter:DBAdapters)
  {
    this.connection = connection;
    this.db_adapter = db_adapter;
  }
  
  private inline function create_table( tablename:String, options:Dynamic, yaml_str:String ):Void
  {
    Lib.print("\n --  Creating Table: "+tablename+" --");
    // check if table exists, throw error if it does
    
    
    // options
    var dont_make_id = (options != null && options.no_id != null && options.no_id == true);
    
    
    // columns
    var columns_yaml = YamlHX.read(yaml_str);
    var columns_array = new Array<String>();
    if(!dont_make_id){
      if(db_adapter == DBAdapters.sqlite3)
        columns_array.push("id INTEGER PRIMARY KEY AUTOINCREMENT");
      else
        columns_array.push("id INTEGER PRIMARY KEY AUTO_INCREMENT");
    }
    for(c in columns_yaml.elements){
      if(c.name.toLowerCase() == "timestamps"){
        columns_array.push(CREATED_AT_TIMESTAMP_COLUMN);
        columns_array.push(UPDATED_AT_TIMESTAMP_COLUMN);
      }else{
        columns_array.push(build_column(c));
      }
    }
    var columns = columns_array.join(", ");

    // query
    var q = "CREATE TABLE IF NOT EXISTS "+tablename+" ("+columns+")";

    connection.request(q);
    Lib.print("\n -- Success! "+tablename+" created! --");
  }
  private inline function drop_table( tablename:String ):Void
  {
    
  }
  
  private inline function add_column( tablename:String, yaml_str:String  ):Void
  {
    // check if table exists, throw error if it does
    
    var column_yaml = YamlHX.read(yaml_str);
    var q = "";
    for(c in column_yaml.elements){ // should just be one
      Lib.print("\n --  Adding Column '"+c.name+"' to '"+tablename+"' --");

      // query
      q = "ALTER TABLE "+tablename+" ADD COLUMN "+build_column(c);
    }
    
    connection.request(q);
    Lib.print("\n -- Success! "+tablename+" created! --");
  }
  
  private  function build_column( f:Fast ):String
  {
    var column_name = "`"+f.name+"`";
    var column_type = "";
    if(f.hasNode.type){
      column_type = f.node.type.innerData;
    }else if(!f.elements.hasNext()){
      column_type = f.innerData;
    }
    
    // check if column_type is valid
    if(column_type == ""){
      throw "Data Type for '"+column_name+"' is Blank!.\nSupported data types are "+Type.getEnumConstructs(SchemeDataType);
    }else if(!Reflect.hasField(SchemeDataType, column_type.toUpperCase())){
      throw "'"+column_type.toUpperCase()+"' is not a valid SchemeDataType.\nSupported data types are "+Type.getEnumConstructs(SchemeDataType);
    }
    
    if(column_type.toUpperCase() == "STRING" && db_adapter == DBAdapters.mysql){
      column_type = "VARCHAR";
    }
    
    var not_null:String = (f.hasNode.null && f.node.null.innerData.toLowerCase() == "false")? "NOT NULL " : "";

    var column_default:String = (f.hasNode.resolve("default"))? "DEFAULT '"+f.node.resolve("default").innerData+"' " : "";
    
    //var limit:Int = (f.hasNode.limit)? Std.parseInt(f.node.limit.innerData) : null;
    if(f.hasNode.limit){
      //column_type = column_type+" LIMIT "+f.node.limit.innerData;
      column_type = column_type+"("+f.node.limit.innerData+") ";
    }else if(f.hasNode.precision && f.hasNode.scale){
      column_type = column_type+"("+f.node.precision.innerData+","+f.node.scale.innerData+") ";
    }else if(column_type == "VARCHAR" && db_adapter == DBAdapters.mysql){
      column_type = column_type+"(255)";
    }
    //var precision:Int = (f.hasNode.precision)? Std.parseInt(f.node.precision.innerData) : null;
    //var scale:Int = (f.hasNode.scale)? Std.parseInt(f.node.scale.innerData) : null;
    
    var unique:String = (f.hasNode.unique)? "UNIQUE " : "";
    
    var primary_key:String = (f.hasNode.primary_key)? "PRIMARY KEY " : "";
    
    var auto_increment:String;
    if(f.hasNode.auto_increment){
      if(db_adapter == DBAdapters.sqlite3)
        auto_increment = "AUTOINCREMENT ";
      else
        auto_increment = "AUTO_INCREMENT ";
    }else{
      auto_increment = "";
    }
    
    var column = column_name+" "+column_type+" "+primary_key+not_null+auto_increment+unique;
    
    return column;
  }
  
}