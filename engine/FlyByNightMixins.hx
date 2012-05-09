import yaml_crate.YamlHX;
class FlyByNightMixins
{
  public static var _APP_CONFIG: YamlHX;
  public static inline function APP_CONFIG(obj:Dynamic, key:String):String{
    return _APP_CONFIG.get(key);
  }
  
  public static inline function inspect(obj:Dynamic, ?p : haxe.PosInfos ):Void{
    // should do deeptrace
    // AeroLogger.log(haxe.Stack.callStack()[haxe.Stack.callStack().length-1].FilePos + " : " + obj.toString());
    AeroLogger.log(obj.toString(), p);
  }
}