import sys.io.File;
class AeroLogger
{
  public static inline function log( obj:Dynamic, ?p : haxe.PosInfos ):Void
  {
    var fname = Settings.get("FBN_ROOT")+"/blackbox/"+Settings.get("FBN_ENV")+".log";
    
    // open file for writing
    var fout = File.append(fname, false);

    // write something
    fout.writeString(p.fileName+":"+p.lineNumber+" : " + obj.toString()+"\n");
    fout.close();

  }
}