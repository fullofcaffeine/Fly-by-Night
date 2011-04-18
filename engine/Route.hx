import yaml_crate.YamlHX;
import haxe.xml.Fast;
import php.io.File;
class Route
{
  public static var _routes_yml:YamlHX;
  public static var routes_yml(get_routes_yml,null): YamlHX;
  private static function get_routes_yml(  ):YamlHX
  {
    if(_routes_yml == null){
      _routes_yml = YamlHX.read(File.getContent(Settings.get("FBN_ROOT")+'config/routes.yml'));
    }
    return _routes_yml;
  }
	public var name: String; // update_foo5
  public var path: String; // foo5/:id
  public var request_uri: String; // foo5/15
  public var controller: String; // foo5
  public var action: String; // update
  public var via: HTTPVerb; // put
  public var params: Hash<String>;
  
/*  public var uri: String; // Routes.name -> /foo/5*/
  
	public function new( name:String, ?path:String, ?request_uri:String, ?controller:String, ?action:String, ?via:HTTPVerb, ?params:Hash<String>)
	{
		this.name = name;
		this.path = (StringTools.startsWith(path, "/"))? path.substr(1) : path;
		this.request_uri = request_uri;
		this.controller = controller;
		this.action = (action == "new")? "make" : action;
		this.via = via;
    this.params = (params != null)? params : new Hash<String>();
    processParams();
	}
	
	/*public inline function getURIfromName( name:String, params:Hash<String> ):String
	 {
	   var uri = "";
	   for(e in routes_yml.elements){
	     if(e.name == "map" && e.hasNode.name && e.node.name.innerData == "name"){ // check if name exists in routes.yml
	       if(e.hasNode.uri){
	         uri = e.node.uri.innerData;
	         break;
	       }else{
	         throw "Route named '"+name+"' does not have a uri set in ./config/routes.yml";
	       }
	     }else if(e.name == "rest"){ // look in restful routes
	       if(name == Utils.pluralize(e.innerData)){ // index
	         uri = "/"+Utils.pluralize(e.innerData);
	         break;
	       }else if(name == e.innerData){ // show
	         uri = "/"+e.innerData+"/"+params.get("id");
	         break;
	        }else if(name == "new_"+e.innerData){ // new
	          uri = "/"+e.innerData+"/new";
	          break;
	        }else if(name == "create_"+e.innerData){ // create
	          uri = "/"+e.innerData;
	          break;
	        }else if(name == "edit_"+e.innerData){ // edit
	          uri = "/"+e.innerData+"/"+params.get("id")+"/edit";
	          break;
	        }else if(name == "update_"+e.innerData){ // update
	          uri = "/"+e.innerData+"/"+params.get("id");
	          break;
	        }else if(name == "destroy_"+e.innerData){ // destroy
	          uri = "/"+e.innerData+"/"+params.get("id")+"/destroy";
	          break;
	        }
	     }
	   }
	   return uri;
	 }*/
	
	private inline function processParams(  ):Void
	{
	  var request_segments = this.request_uri.split("/");
	  var path_segments = this.path.split("/");
	  for(i in 0...path_segments.length){
	    if(StringTools.startsWith(path_segments[i], ":")){
	      params.set(path_segments[i].substr(1), request_segments[i]);
	    }
	  }
	}
	
	public inline function toString(  ):String
	{
	  return Type.getClassName(Type.getClass(this)) + " : " + 
	    "\n\tName: "+ name +
	    "\n\tPath: "+ path + 
	    "\n\tRequest URI: " + request_uri +
	    "\n\tController: " + controller +
	    "\n\tAction: " + action +
	    "\n\tVia: " + via +
	    "\n\tParams: \n\t\t" + params.toString();
	}
	
	/*public static inline function named( name:Routes ):Route
	 {
	   return new Route(name);
	 }*/
	
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
		var route_path:String = "";
    
    if(path == "" && 
      try{ (routes_yml.get("root").length > 0); }catch(e:Dynamic){ false; } ){
        route = new Route("root", "", path, routes_yml.get("root"),"index",_method,params);
        return dispatch(route);
    }else{
      // find route
      for (e in routes_yml.elements ){
        route_path = "";
        if(e.hasNode.path){
          route_path = e.node.path.innerData;
          if(StringTools.startsWith(route_path,"/")){
            route_path = route_path.substr(1);
          }
        }
        if(e.name == "map"){
          if(pathMatchesRoute(path.split("/"),route_path.split("/"))){
            if(e.hasNode.via && e.node.via.innerData == Std.string(method)){
              route = mapToRoute(e, path, method, params);
              break;
            }
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
	  if(request_uri_segments.length != path_segments.length) return false;
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
	
	private static inline function mapToRoute( f:Fast, request_uri:String, method:HTTPVerb, params:Hash<String> ):Route
	{
    return new Route( f.node.name.innerData, f.node.path.innerData, request_uri, f.node.controller.innerData, f.node.action.innerData, method, params);
	}
	
	private static inline function mapToRestfulRoute( route_name:String, request_uri:String, method:HTTPVerb, params:Hash<String> ):RestfulRoute
	{
	  return new RestfulRoute( route_name, request_uri, method, params);
	}
	  
	public static function dispatch(route:Route):AeroController
	{
    var controller:AeroController = Type.createInstance(Type.resolveClass("controllers."+Utils.toCamelCase(route.controller)),[route.action,route.params,route]);
    if(AeroController.runBeforeFilters(controller)){
      
      if(Reflect.hasField(controller, controller.action)){
        Reflect.callMethod(
          controller,
          Reflect.field(controller,controller.action),
          []);
/*          [route.params]);*/
      }else{
        throw "ERROR! Controller: "+controller+"Does not have Action: "+controller.action;
      }
    }else{ // fail pail during before filters
      
      throw "oops, before filters has fail. "+Reflect.field(Type.getClass(controller), "before_all");
    }
	  return controller;
	    
	  /*var controller = Type.createInstance(Type.resolveClass("controllers."+Utils.toCamelCase(route.controller)),[route.action,route.params]);
      Reflect.callMethod(
        Type.resolveClass("controllers."+controller),
        Reflect.field(controller,route.action),
        [route.params]);
      return cast(controller, AeroController);*/
	}
}