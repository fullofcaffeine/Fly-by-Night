#if nodejs
package nodejs;
import js.Node;
class File
{
  public static inline function getContent( path:String ):String
  {
    return Node.fs.readFileSync(path);
  }
}
#end