import yaml_crate.YamlHX;
import haxe.xml.Fast;
import php.io.File;
class Routes
{


	public static function resolve( path:String, ?_method:HTTPVerb, ?params:Hash<String> ):AeroController
	{
		var method = (_method == null)? HTTPVerb.GET : _method;
		// remove leading and trailing slash
		if(StringTools.startsWith(path,"/")) path = path.substr(1);
		if(StringTools.endsWith(path,"/")) path = path.substr(0,path.length-1);
		
		// check routing table
		// read routes yaml config
		// cache it (production) ??
		// resolve path
		
		var route:Route = null;

    var routes_yml = YamlHX.read(File.getContent(Settings.get("FBN_ROOT")+'config/routes.yml'));
    if(path == "" && 
      try{ (routes_yml.get("root").length > 0); }catch(e:Dynamic){ false; } ){
        route = new Route("root", "", path, routes_yml.get("root"),"index",_method,params);
        return dispatch(route);
    }else{
      // find route
      for (e in routes_yml.elements ){
        if(e.name == "map"){
          if(pathMatchesRoute(path.split("/"),e.node.path.innerData.split("/"))){
            route = mapToRoute(e, path, params);
            break;
          }
          
        }else if(e.name == "rest"){
          if(pathMatchesRestfulRoute(path.split("/"),e.innerData.toLowerCase())){
            route = mapToRestfulRoute(e.innerData.toLowerCase(), path, method, params);
            break;
          }
        }
        
      }
      
      // else use default
      if(route == null){
        //route = routes_yml.node.default_route.innerData;
      }
      
      return dispatch(route);
    }
	}
	
	private static function pathMatchesRoute( request_uri_segments:Array<String>, path_segments:Array<String> ):Bool
	{
	  // var r : EReg = ~/[:(a-zA-Z0-9_)+]/;
	  for(i in 0...request_uri_segments.length){
	    if(!StringTools.startsWith(path_segments[i], ":")){
	      if(path_segments[i] != request_uri_segments[i]){
	        return false;
	      }
	    }
	  }
	  return true;
	}
	private static inline function pathMatchesRestfulRoute( request_uri_segments:Array<String>, resource_name:String ):Bool
	{
	  return request_uri_segments[0] == resource_name;
	}
	
	private static inline function mapToRoute( f:Fast, request_uri:String, params:Hash<String> ):Route
	{
    return new Route( f.node.name.innerData, f.node.path.innerData, request_uri, f.node.controller.innerData, f.node.action.innerData, Reflect.field(HTTPVerb, f.node.via.innerData), params);
	}
	
	private static inline function mapToRestfulRoute( route_name:String, request_uri:String, method:HTTPVerb, params:Hash<String> ):RestfulRoute
	{
	  return new RestfulRoute( route_name, request_uri, method, params);
	}
	
	public static function dispatch(route:Route):AeroController
	{
    var controller = Type.createInstance(Type.resolveClass("controllers."+Utils.toCamelCase(route.controller)),[route.action]);
	  Reflect.callMethod(
	    Type.resolveClass("controllers."+controller),
	    Reflect.field(controller,route.action),
	    [route.params]);
	  return cast(controller, AeroController);
	}
	
}