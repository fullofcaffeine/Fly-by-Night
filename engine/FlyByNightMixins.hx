import yaml_crate.YamlHX;
class FlyByNightMixins
{
  public static var _APP_CONFIG: YamlHX;
  public static inline function APP_CONFIG(obj:Dynamic, key:String):String{
    return _APP_CONFIG.get(key);
  }
  
}