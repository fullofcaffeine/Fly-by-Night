#if nodejs
package nodejs;
class Session
{

  public function new()
  {
    
  }
  public static function set( key:String, val:String ):Void
  {
    throw("nodejs.Session.set() has not been implemented yet.");
  }
  public static function get( key:String ):String
  {
    throw("nodejs.Session.get() has not been implemented yet.");
    return 'nodejs.Session.get() has not been creted yet!';
  }
  public static function exists( key:String ):Bool
  {
    throw("nodejs.Session.exists() has not been implemented yet.");
    return false;
  }
}
#end