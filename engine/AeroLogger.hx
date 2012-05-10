import sys.io.File;
class AeroLogger
{
  public static inline function log( obj:Dynamic, ?p : haxe.PosInfos ):Void
  {
    writeToLog(Utils.getDate()+" LOG: "+p.fileName+":"+p.lineNumber+" : " + Std.string(obj)+"\n");
  }
  public static inline function warn( obj:Dynamic, ?p : haxe.PosInfos ):Void
  {
    writeToLog(Utils.getDate()+" WARNING: "+p.fileName+":"+p.lineNumber+" : " + Std.string(obj)+"\n");
  }
  public static inline function error( obj:Dynamic, ?p : haxe.PosInfos ):Void
  {
    writeToLog(Utils.getDate()+" ERROR: "+p.fileName+":"+p.lineNumber+" : " + Std.string(obj)+"\n");
  }
  private static inline function writeToLog(log:String):Void{
    var fname = Settings.get("FBN_ROOT")+"/blackbox/"+Settings.get("FBN_ENV")+".log";
    
    // open file for writing
    var fout = File.append(fname, false);

    // write something
    fout.writeString(log);
    fout.close();
  }
}