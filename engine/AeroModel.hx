import php.FileSystem;
import php.db.Object;
class AeroModel extends db.Object
{
  public var name: String;
  public function new( )
  {
    name = Type.getClassName(Type.getClass(this)).substr(8); // models.
    
  }
}