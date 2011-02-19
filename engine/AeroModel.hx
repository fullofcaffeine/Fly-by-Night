/*
  To see a full list of auto imported classes for all subclasses of AeroModel
  See RunwayMacros.PREPEND_TO_MODEL
*/
import php.FileSystem;
import php.db.Object;
import php.db.Manager;
class AeroModel extends php.db.Object
{
/*  public static var manager = new Manager(Type.getClass(this));*/
  
/*  public var name: String;*/
  public function new( )
  {
/*    name = Type.getClassName(Type.getClass(this)).substr(8); // models.*/

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
  
  public static inline function find( model:Dynamic, s:String ):Void
  {//, s:String
    trace(model + " : " + s);
  }
  
}