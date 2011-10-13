/*
  compiles out to ./runway/test.n
  application tests will be in ./runway/ directory
  integration tests will be in ./runway/integration/ directory
  unit tests will be in  ./runway/unit/ directory
  views validations will be in ./runway/views/ directory
  cargo will be in ../cargo/[crate name]/Runway.hx
  the ./runway/test.n file logs output to ./blackbox/runway.log
  the ./runway/test.n file gets deleted after execution


  engine is tested in /engine/runway/Engine.hx

  /engine/Takeoff.hx will include conditional compiles set from build.hxml
    - test_engine
    - test_cargo (all crates)
    - test_app (all test files in /runway)
    adds these to RunwayRunner.hx test suites
    #if test_engine
    RunwayRunner.suites.push(RunwayRunner.engine);
    #end
  
  /autopilot/runway script to perform tests for a specified suite
    - engine
    - cargo (all crates)
    - crate_name
    - app
  ex: /autopilot/runway test app
  if Reflect.hasField(RunwayRunner, String.toUpper(arg))
  else check crate name
  
  
  crates are testable. if tests exist, they are in the file named Runway.hx
  ex. for haml_crate, the test class is /cargo/haml_crate/Runway.hx
  crate_name.Runway implements runway.IRunway

*/
/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package runway;
import haxe.Timer;
import neko.Lib;
import neko.FileSystem;
import haxe.macro.Expr;
import haxe.rtti.Meta;
import logger.TerminalColor;
using logger.TerminalColors;
class Runner
{
  private static inline var DATE_FORMAT = "%B %d, %I:%M:%S %p";
  private var result : Result;
	
  public function new()
  {
    Settings.set("FBN_ENV", "runway");
    Settings.set("ATMOSPHERE", "runway"); // alias
    
    Runner.compileRunwayClasses();
    ImportRunways;
    
    result = new Result();
    
    print("\n[+++ Runway tests starting +++] ("+get_date()+")",TerminalColor.LIGHT_GRAY);
      
    #if engine
      print("\n[+++ Running Engine Tests +++]\n",TerminalColor.LIGHT_GRAY);
      start_timer();
      runCase(Type.createInstance(Type.resolveClass("runway.Engine"),[]));

      print("[--- Engine tests complete ---] "+get_time(),TerminalColor.LIGHT_GRAY);
    #end
    #if cargo
      print("\n[+++ Inspecting Cargo +++]\n",TerminalColor.LIGHT_GRAY);
      start_timer();
      
      var crate_names = FileSystem.readDirectory("./cargo");
      for(crate_name in crate_names){
        if(!StringTools.startsWith(crate_name, ".")){
          if(FileSystem.exists("./"+crate_name+"/Runway.hx")){
             runCase(Type.createInstance(Type.resolveClass(crate_name+".Runway"),[]));
            
          }
        }
      }
      
      print("\n[--- Cargo has been inspected ---]"+get_time(),TerminalColor.LIGHT_GRAY);
    #end
    #if app
      print("\n[+++ Testing Application +++]",TerminalColor.LIGHT_GRAY);
      
      print("\n[+++ Unit Tests +++]\n",TerminalColor.LIGHT_GRAY);
      start_timer();
      
      var unit_test_classes = FileSystem.readDirectory("./runway/unit");
      for(unit_test_class in unit_test_classes){
        if(!StringTools.startsWith(unit_test_class, ".")){
 runCase(Type.createInstance(Type.resolveClass("unit."+unit_test_class.substr(0,-3)),[]));
        }
      }
      
      print("\n[--- Unit tests complete ---]"+get_time(),TerminalColor.LIGHT_GRAY);
      
      print("\n[+++ Integration tests +++]\n",TerminalColor.LIGHT_GRAY);
      start_timer();
      
      var integration_test_classes = FileSystem.readDirectory("./runway/integration");
      for(integration_test_class in integration_test_classes){
        if(!StringTools.startsWith("integration."+integration_test_class, ".")){
          runCase(Type.createInstance(Type.resolveClass("integration."+integration_test_class.substr(0,-3)),[]));
        }
      }
      
      print("\n[--- Integration tests complete ---]"+get_time(),TerminalColor.LIGHT_GRAY);
      
      
      #if views
        // see ViewsRunway
        print("\n[+++ Validating Views +++]\n",TerminalColor.LIGHT_GRAY);
        start_timer();
        
        var views_test_classes = FileSystem.readDirectory("./runway/views");
        for(views_test_class in views_test_classes){
          if(!StringTools.startsWith("views."+views_test_class, ".")){
            runCase(Type.createInstance(Type.resolveClass(views_test_class.substr(0,-3)),[]));
          }
        }
        
        
        print("\n[--- Views have been validated ---]"+get_time(),TerminalColor.LIGHT_GRAY);
      #end
      
      
      print("\n[--- Application tests complete ---]",TerminalColor.LIGHT_GRAY);
    #end
    
    print("\n[--- Runway tests complete ---] ("+get_date()+")\n",TerminalColor.LIGHT_GRAY);
    
    
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
  private static inline function get_date(  ):String
  {
    return DateTools.format(Date.now(), DATE_FORMAT);
  }
  
  private function runCase( t:IRunway ) : Void 	{
		var old = haxe.Log.trace;
		haxe.Log.trace = customTrace;

		var cl = Type.getClass(t);
		var fields = Type.getInstanceFields(cl);

    print("Describing "+Type.getClassName(cl)+"\n", TerminalColor.LIGHT_CYAN);
    t.beforeAll();
		for ( f in fields ){
			var fname = f;
			var field = Reflect.field(t, f);
			var metas = Reflect.field(Meta.getFields(cl),fname);
			if ( Reflect.isFunction(field) &&
			  (
			    StringTools.startsWith(fname,"it") // unit tests
			    ||
			    (metas != null && // integration tests
			    (metas.route != null || 
			    (metas.controller != null && metas.action))
			    )
			  )){
				t.currentTest = new Status();
				t.currentTest.classname = Type.getClassName(cl);
				t.currentTest.method = fname;
				t.beforeEach();

				try {
					Reflect.callMethod(t, field, new Array());

					if( t.currentTest.done ){
						t.currentTest.success = true;
						print(t.currentTest, TerminalColor.LIGHT_GREEN);
					}else{
						t.currentTest.success = false;
						t.currentTest.pending = true;
						print(t.currentTest, TerminalColor.YELLOW);
						
					}
				}catch ( e : Status ){
					print(t.currentTest, TerminalColor.RED); // REDBG_WHITE
					t.currentTest.backtrace = haxe.Stack.toString(haxe.Stack.exceptionStack());
				}catch ( e : Dynamic ){
					Lib.println("E");
					t.currentTest.error = "exception thrown : "+e;
					t.currentTest.backtrace = haxe.Stack.toString(haxe.Stack.exceptionStack());
				}
				result.add(t.currentTest);
				t.afterEach();
			}
		}
    t.afterAll();
		Lib.println("\n");
		haxe.Log.trace = old;
	}
	
	private static inline function customTrace( v, ?p : haxe.PosInfos ) {
		Lib.println(p.fileName+":"+p.lineNumber+": "+Std.string(v)+"\n");
	}
	
	public static inline function print( v:Dynamic, ?color:TerminalColor ):Void
	{
	  #if color
	    Lib.print(color.value()+v+TerminalColor.DEFAULT_COLOR.value());
	  #else
	    Lib.print(v);
	  #end
	}
	

  public static function main():Void{
    var runner = new Runner();
  }
  
  @:macro public static function compileRunwayClasses() : Expr
	{
	  var imports = new Array<String>();
	  #if engine
	    imports.push("import runway.Engine;");
	  #end
	  #if cargo
	  var cargo_test_classes = neko.FileSystem.readDirectory("./cargo");
	  for(crate_name in cargo_test_classes){
      if(!StringTools.startsWith(crate_name, ".")){
        if(FileSystem.exists("./"+crate_name+"/Runway.hx")){
           imports.push("import "+crate_name+".Runway;");
        }
      }
    }
	  #end
	  
	  #if app
      var unit_test_classes = FileSystem.readDirectory("./runway/unit");
      for(unit_test_class in unit_test_classes){
        if(!StringTools.startsWith(unit_test_class, ".")){
          imports.push("import unit."+unit_test_class.substr(0,-3)+";");
        }
      }
      var integration_test_classes = FileSystem.readDirectory("./runway/integration");
      for(integration_test_class in integration_test_classes){
        if(!StringTools.startsWith("integration."+integration_test_class, ".")){
          imports.push("import integration."+integration_test_class.substr(0,-3)+";");
        }
      }
      #if views
        var views_test_classes = FileSystem.readDirectory("./runway/views");
        for(views_test_class in views_test_classes){
          if(!StringTools.startsWith("views."+views_test_class, ".")){
            imports.push("import views."+views_test_class.substr(0,-3)+";");
          }
        }
      #end
    #end
    
    var imploded = "package runway;\n"+imports.join("\n")+"\nclass ImportRunways{}";

    var file = neko.io.File.write("./engine/runway/ImportRunways.hx", false);
    file.writeString(imploded);
    file.close();
    
    return { expr : EConst(CString(imploded)), pos : haxe.macro.Context.currentPos() }
	}
	
}