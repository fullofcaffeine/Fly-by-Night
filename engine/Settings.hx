/* store all settings in environment variables */
import php.Sys;
class Settings
{

  public static function get(s:String):String
  {
		return Sys.getEnv(s);
  }
  public static function set( s:String, v:String ):String
  {
    Sys.putEnv(s, v);
    return s;
  }
}