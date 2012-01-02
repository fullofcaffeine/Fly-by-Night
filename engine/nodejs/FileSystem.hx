#if nodejs
package nodejs;
import js.Node;
class FileSystem
{
  public static inline function exists( path:String ):Bool
  {
    return Node.path.existsSync(path);
  }
}
#end