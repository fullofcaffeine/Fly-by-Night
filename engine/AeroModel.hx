/*
  To see a full list of auto imported classes for all subclasses of AeroModel
  See LandingGearMacro.APPEND_TO_MODEL
  
  
  TODO: add exists() get()
  TODO: add dynamic getters (through macros?) for strings, then use Utils.strip_slashes
  
*/
import php.FileSystem;
import php.db.Object;
import php.db.Manager;
import db.DBConnection;
class AeroModel extends php.db.Object
{
/*  public var name: String;*/
  public var id: Int;
  public static var manager: Dynamic;
  public function new( )
  {
    DBConnection.connection;
/*    name = Type.getClassName(Type.getClass(this)).substr(8); // models.*/
    manager = new Manager(cast Type.resolveClass(Type.getClassName(Type.getClass(this))));
    
    super();
      
  }

  public function save( ):Bool
  {
    DBConnection.connection;
    
    runBeforeSave();
    if(find(Type.getClass(this),this.id) == null){ // new record
      
      // magic columns
      if(Reflect.hasField(Type.getClass(this), "created_at")){
        Reflect.setField(this, "created_at", Date.now());
      }
      if(Reflect.hasField(Type.getClass(this), "updated_at")){
        Reflect.setField(this, "updated_at", Date.now());
      }
      
      this.insert();
      
    }else{
      // magic columns
      if(Reflect.hasField(Type.getClass(this), "updated_at")){
        Reflect.setField(this, "updated_at", Date.now());
      }
      
      this.update();
    }
    runAfterSave();
    
    // TODO FIXME do checks, validations, etc.
    return true;
  }
  public function destroy():Void
  {
    // TODO add before_destroy
    this.delete();
    // TODO add after_destroy
  }
  
  public static inline function all( model:Dynamic, ?conditions:String, ?order:String, ?limit:Int = -1, ?offset:Int = -1):List<Dynamic>
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    var result:List<Dynamic> = new List<Dynamic>();
    var _limit = "";
    if(limit >= 0){
      _limit = "LIMIT "+Std.string(limit);
    }
    var _offset = "";
    if(offset >= 0){
      _offset = "OFFSET "+Std.string(offset);
    }
    var _order = "";
    if(order != null){
      _order = "ORDER BY "+order;
    }
    if(Type.getSuperClass(model) == AeroModel){
      var manager = new Manager(cast Type.resolveClass(class_name));
/*      result = manager.all(false);*/
      result = manager.objects("SELECT * FROM "+Reflect.field(Type.resolveClass(class_name), "TABLE_NAME")+" "+conditions+" "+_order+" "+_limit+" "+_offset, false);
    }
    return result;
  }
  public static inline function find( model:Dynamic, id:Int ):Dynamic
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    var result:Object = null;
    if(Type.getSuperClass(model) == AeroModel){
      
      var manager = new Manager(cast Type.resolveClass(class_name));
      result = manager.get(id);
/*      result = manager.objects("SELECT * FROM posts", false);*/
    }
    return result;
  }
  
  public static inline function destroy_by_id( model:Dynamic, id:Int ):Bool
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    if(Type.getSuperClass(model) == AeroModel){
      
      var manager = new Manager(cast Type.resolveClass(class_name));
      manager.delete({id : id});
    }
    
    return true;
  }
  
  public static inline function count( model:Dynamic, ?conditions:String ):Int
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    var result:Dynamic;
    var count = 0;
    if(Type.getSuperClass(model) == AeroModel){
      var manager = new Manager(cast Type.resolveClass(class_name));
/*      result = manager.all(false);*/
      result = manager.result("SELECT COUNT(*) as `count` FROM "+Reflect.field(Type.resolveClass(class_name), "TABLE_NAME")+" "+conditions);
      count = result.count;
    }
    return count;
  }
  
  public override function toString(  ):String
  {
    var out = Type.getClass(this) + " => {\n";
    var hash = this.toHash();
    for(key in hash.keys()){
      out += "\t"+key+" => "+hash.get(key)+"\n";
    }
    out += "}";
    //return this.toHash().toString();
    return out;
  }
  public inline function toHash(  ):Hash<Dynamic>
  {
    var fields = Lambda.filter(Reflect.fields(this),function(f){ return !StringTools.startsWith(f,"__"); });
    var fields_hash = new Hash<Dynamic>();
    for(field in fields){
      fields_hash.set(field,Reflect.field(this,field));
    }
    return fields_hash;
  }
  
  
  private inline function runBeforeSave():Void
  {
    if(Reflect.hasField(this,"beforeSave")){
      AeroLogger.log("has beforeSave, running filter");
      Reflect.callMethod(this, Reflect.field(this,"beforeSave"), []);
    }
  }
  private inline function runAfterSave():Void
  {
    if(Reflect.hasField(this,"afterSave")){
      AeroLogger.log("has afterSave, running filter");
      Reflect.callMethod(this, Reflect.field(this,"afterSave"), []);
    }
  }
}