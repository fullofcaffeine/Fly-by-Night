/*
  TDD can be applied here for new and custom features of the core Fly By Night engine.
  
*/
package runway.engine;
using AeroPath;
class AeroPath_ extends runway.Unit
{
  
  public override function beforeAll(  ):Void
  {
    // a test_route is added to Routes.hx enum for -D runway
    // need to add the test_route to routes.yml
    if(neko.FileSystem.exists('./config/routes.yml')){
      var routes_yml = neko.io.File.getContent('./config/routes.yml');
      if(routes_yml.indexOf("\nmap:\n  name: test_route_path\n  path: test_path/:id\n  via: GET\nmap:\n  name: test_route_url\n  uri: /test_url\n  via: GET") < 0){
        routes_yml += "\nmap:\n  name: test_route_path\n  path: test_path/:id\n  via: GET\nmap:\n  name: test_route_url\n  uri: /test_url\n  via: GET";
        var routes_file = neko.io.File.write("./config/routes.yml", false);
        routes_file.writeString(routes_yml);
        routes_file.close();
      }
    }
    
  }
  public override function afterAll(  ):Void
  {
    // need to restore original routes.yml file
    if(neko.FileSystem.exists('./config/routes.yml')){
      var routes_yml = neko.io.File.getContent('./config/routes.yml');
      var test_route_index = routes_yml.indexOf("\nmap:\n  name: test_route_path\n  path: test_path/:id\n  via: GET\nmap:\n  name: test_route_url\n  uri: /test_url\n  via: GET");
      if(test_route_index >= 0){
        routes_yml = routes_yml.substr(0,test_route_index);
        var routes_file = neko.io.File.write("./config/routes.yml", false);
        routes_file.writeString(routes_yml);
        routes_file.close();
      }
    }
  }
  
  public function it_creates_urls_from_route(){
    assertEquals("/test_url", AeroPath.path(Routes.test_route_url));
  }
  
  public function it_creates_urls_from_route_with_using(){
    assertEquals("/test_url", Routes.test_route_url.path());
  }
  
  public function it_creates_paths_with_params(){
    var params = new Hash<String>();
    params.set("id", "21");
    assertEquals("/test_path/21", AeroPath.path(Routes.test_route_path, params));
  }
  
  public function it_creates_paths_with_using_and_params(){
    var params = new Hash<String>();
    params.set("id", "21");
    assertEquals("/test_path/21", Routes.test_route_path.path(params));
  }
  
}
