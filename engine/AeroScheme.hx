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
class AeroScheme
{

  public static inline var GENERIC_TEMPLATE = "// scheme devised by ./autopilot/devise.n
class %NAME% extends AeroScheme, implements IScheme{
  public function engage():Void
  {
    
  }
  public function abort():Void
  {
    
  }
}";
  public static inline var CREATE_TABLE_TEMPLATE = "// scheme devised by ./autopilot/devise.n
class %NAME% extends AeroScheme, implements IScheme{
  public function engage():Void
  {
    create_table('%TABLENAME%', {
      
    });
  }
  public function abort():Void
  {
    drop_table('%TABLENAME%');
  }
}";

/*  public var exists: Bool;*/

  private var connection: Connection;

  public function new(connection:Connection)
  {
    this.connection = connection;
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
    if(!dont_make_id) columns_array.push("id INTEGER PRIMARY KEY AUTOINCREMENT");
    for(c in columns_yaml.elements){
      columns_array.push(build_column(c));
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
  
  private inline function build_column( f:Fast ):String
  {
    var column_name = f.name;
    var column_type = null;
    if(f.hasNode.type){
      column_type = f.node.type.innerData;
    }else if(!f.elements.hasNext()){
      column_type = f.innerData;
    }
    
    // check if column_type is valid
    if(!Reflect.hasField(SchemeDataType, column_type.toUpperCase())){
      throw "'"+column_type.toUpperCase()+"' is not a valid SchemeDataType.\nSupported data types are "+Type.getEnumConstructs(SchemeDataType);
    }
    
    var not_null:String = (f.hasNode.null && f.node.null.innerData.toLowerCase() == "false")? "NOT NULL " : "";

    var column_default:String = (f.hasNode.resolve("default"))? "DEFAULT '"+f.node.resolve("default").innerData+"' " : "";
    
    //var limit:Int = (f.hasNode.limit)? Std.parseInt(f.node.limit.innerData) : null;
    if(f.hasNode.limit){
      //column_type = column_type+" LIMIT "+f.node.limit.innerData;
      column_type = column_type+"("+f.node.limit.innerData+") ";
    }else if(f.hasNode.precision && f.hasNode.scale){
      column_type = column_type+"("+f.node.precision.innerData+","+f.node.scale.innerData+") ";
    }
    //var precision:Int = (f.hasNode.precision)? Std.parseInt(f.node.precision.innerData) : null;
    //var scale:Int = (f.hasNode.scale)? Std.parseInt(f.node.scale.innerData) : null;
    
    var unique:String = (f.hasNode.unique)? "UNIQUE " : "";
    
    var primary_key:String = (f.hasNode.primary_key)? "PRIMARY KEY " : "";
    
    var auto_increment:String = (f.hasNode.auto_increment)? "AUTOINCRMEENT " : "";
    
    var column = column_name+" "+column_type+" "+primary_key+not_null+auto_increment+unique;
    
    return column;
  }
  
}