/*
  To see a full list of auto imported classes for all subclasses of AeroModel
  See RunwayMacros.PREPEND_TO_MODEL
*/
import php.FileSystem;
import php.db.Object;
import php.db.Manager;
class AeroModel extends php.db.Object
{
/*  public var name: String;*/
  public var manager: Dynamic;
  public function new( )
  {
    DBConnection.connection;
/*    name = Type.getClassName(Type.getClass(this)).substr(8); // models.*/
    manager = new Manager(cast Type.resolveClass(Type.getClassName(Type.getClass(this))));
    
    super();
      
  }

  public function save( ):Bool
  {
    return true;
  }
  
  public function destroy( ):Bool
  {
    return true;
  }
  
  public static inline function all( model:Dynamic, ?conditions:String ):List<Dynamic>
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    var result:List<Dynamic> = new List<Dynamic>();
    if(Type.getSuperClass(model) == AeroModel){
      
      var manager = new Manager(cast Type.resolveClass(class_name));
      result = manager.all(false);
/*      result = manager.objects("SELECT * FROM posts", false);*/
    }
    return result;
  }
  public static inline function find( model:Dynamic, s:String ):Void
  {
    trace(model + " : " + s);
  }
  
}