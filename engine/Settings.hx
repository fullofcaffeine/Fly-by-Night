/* store all settings in environment variables */
#if php
  import php.Sys;
#elseif neko
  import neko.Sys;
#end
class Settings
{
  #if (!php && !neko)
    private static var settings:Hash<String>;
    private static function getSettings():Hash<String>{
      if(settings==null){
        settings = new Hash<String>();
      }
      return settings;
    }
  #end
  public static function get(s:String):String
  {

    #if (php || neko)
		  return Sys.getEnv(s);
		#else
		  return getSettings().get(s);
		#end
		
  }
  public static function set( s:String, v:String ):String
  {
    #if (php || neko)
		  Sys.putEnv(s, v);
		#else
		  getSettings().set(s,v);
		#end
		
    return v;
  }
}