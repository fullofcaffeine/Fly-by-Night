/*
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

all test classes in /runway/ should extend Runway
/engine/Runway.hx contains additional methods used by tests in /runway/ directory

by default, always include a test class in /runway named "RunwayRoutes.hx" which will that all paths in /config/routes.yml have their controller.actions created

/engine/RunwayRunner.hx runs the tests


would it be better to run RunwayRunner in Takeoff.main ?
or to use RunwayRunner.main and include Takeoff in engine tests


anything that is testable, has a Runway.hx class file in it.
for engine, this is that file. /engine/Runway.hx

for crates, if tests exist, they are in the file named Runway.hx which extends haxe.unit.TestCase
ex. for haml_crate, the test class is /cargo/haml_crate/Runway.hx

*/
import haxe.unit.TestCase;
class Runway extends TestCase
{

  public function new()
  {
    super();
  }
}