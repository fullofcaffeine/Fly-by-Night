import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import haxe.Timer;
import haxe.unit.TestResult;
import haxe.unit.TestStatus;
import neko.Lib;
class RunwayRunner
{
  private var result : TestResult;
	
  public function new()
  {
    Settings.set("FBN_ENV", "runway");
    Settings.set("ATMOSPHERE", "runway"); // alias
    
    result = new TestResult();
    
    Lib.println("\n\n[--- Runway tests starting ---] ("+Utils.getDate()+")");
      
    #if engine
      Lib.println("\n\n[--- Running Engine Tests ---]");
      start_timer();
      runCase(new EngineRunway());
      
      Lib.println("\n\n[--- Engine tests complete ---] "+get_time());
    #end
    #if cargo
      Lib.println("\n\n[--- Inspecting Cargo ---]\n");
      start_timer();
      // for each crate in cargo
      // runCase(new crate_name.Runway());
      
      Lib.println("\n\n[--- Cargo has been inspected ---]"+get_time());
    #end
    #if app
      Lib.println("\n\n[--- Testing Application ---]");
      
      Lib.println("\n\n[--- Unit Tests ---]\n");
      start_timer();
      runCase(new Unit());
      
      Lib.println("\n\n[--- Unit tests complete ---]"+get_time());
      
      Lib.println("\n\n[--- Integration tests ---]\n");
      start_timer();
      runCase(new Integration());
      
      Lib.println("\n\n[--- Integration tests complete ---]"+get_time());
      
      
      #if views
        // see ViewsRunway
        Lib.println("\n\n[--- Validating Views ---]\n");
        start_timer();
        runCase(new ViewsRunway());
        
        
        Lib.println("\n\n[--- Views have been validated ---]"+get_time());
      #end
      
      
      Lib.println("\n\n[--- Application tests complete ---]");
    #end
    
    Lib.println("\n\n[--- Runway tests complete ---] ("+Utils.getDate()+")");
    
    
		Lib.println(result.toString());
  }
  
  private static var timer: Float;
  private static inline function start_timer(  ):Void
  {
    timer = Timer.stamp();
  }
  private static inline function get_time(  ):String
  {
    var now = Timer.stamp();
    var time = Std.int((now-timer)*1000)/1000;
    return Std.string("("+time+" ms)");
  }
  
  function runCase( t:TestCase ) : Void 	{
		var old = haxe.Log.trace;
		haxe.Log.trace = customTrace;

		var cl = Type.getClass(t);
		var fields = Type.getInstanceFields(cl);

		Lib.println( "Class: "+Type.getClassName(cl)+" ");
		for ( f in fields ){
			var fname = f;
			var field = Reflect.field(t, f);
			if ( StringTools.startsWith(fname,"test") && Reflect.isFunction(field) ){
				t.currentTest = new TestStatus();
				t.currentTest.classname = Type.getClassName(cl);
				t.currentTest.method = fname;
				t.setup();

				try {
					Reflect.callMethod(t, field, new Array());

					if( t.currentTest.done ){
						t.currentTest.success = true;
						Lib.println(".");
					}else{
						t.currentTest.success = false;
						t.currentTest.error = "(warning) no assert";
						Lib.println("W");
					}
				}catch ( e : TestStatus ){
					Lib.println("F");
					t.currentTest.backtrace = haxe.Stack.toString(haxe.Stack.exceptionStack());
				}catch ( e : Dynamic ){
					Lib.println("E");
					#if js
					if( e.message != null ){
						t.currentTest.error = "exception thrown : "+e+" ["+e.message+"]";
					}else{
						t.currentTest.error = "exception thrown : "+e;
					}
					#else
					t.currentTest.error = "exception thrown : "+e;
					#end
					t.currentTest.backtrace = haxe.Stack.toString(haxe.Stack.exceptionStack());
				}
				result.add(t.currentTest);
				t.tearDown();
			}
		}

		Lib.println("\n");
		haxe.Log.trace = old;
	}
	
	private static inline function customTrace( v, ?p : haxe.PosInfos ) {
		Lib.println(p.fileName+":"+p.lineNumber+": "+Std.string(v)+"\n");
	}

  public static function main():Void{
    var runwayRunner = new RunwayRunner();
  }
}