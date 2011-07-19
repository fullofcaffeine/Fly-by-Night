/*
  To see a full list of auto imported classes for all subclasses of AeroModel
  See RunwayMacros.PREPEND_TO_MODEL
*/
import php.FileSystem;
import php.db.Object;
import php.db.Manager;
import db.DBConnection;
class AeroModel extends php.db.Object
{
  public var id: Int;
  public function new( )
  {
    DBConnection.connection;
/*    name = Type.getClassName(Type.getClass(this)).substr(8); // models.*/
    __manager__ = new Manager(cast Type.resolveClass(Type.getClassName(Type.getClass(this))));
    
    super();
      
  }

  public function save( ):Bool
  {
    DBConnection.connection;
    
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
    
    // TODO FIXME do checks, validations, etc.
    return true;
  }
  
  public static inline function destroy( model:Dynamic, id:Int ):Bool
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    if(Type.getSuperClass(model) == AeroModel){
      
      var manager = new Manager(cast Type.resolveClass(class_name));
      manager.delete({id : id});
    }
    
    return true;
  }
  
  public static inline function all( model:Dynamic, ?conditions:String, ?order:String ):List<Dynamic>
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    var result:List<Dynamic> = new List<Dynamic>();
    if(Type.getSuperClass(model) == AeroModel){
      var manager = new Manager(cast Type.resolveClass(class_name));
/*      result = manager.all(false);*/
      result = manager.objects("SELECT * FROM "+Reflect.field(Type.resolveClass(class_name), "TABLE_NAME")+" "+conditions+" "+order, false);
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
  
}