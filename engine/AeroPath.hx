class AeroPath
{
  public static function path( route:Routes, ?params:Hash<String> ):String
	{
	  var name = Std.string(route);
	  var uri = "";
	  var path = "";
	  if(route == Routes.root){
	    uri = "/";
	  }else{
  	  for(e in Route.routes_yml.elements){
  	    if(e.name == "map" && e.hasNode.name && e.node.name.innerData == name){ // check if name exists in routes.yml
  	      if(e.hasNode.uri){
  	        uri = e.node.uri.innerData;
  	        break;
  	      }else if(e.hasNode.path){
  	        path = e.node.path.innerData;
  	        var segments = path.split("/");
  	        for(segment in segments){
  	          if(StringTools.startsWith(segment, ":")){
  	            if(params.exists(segment.substr(1))){
  	              uri += "/"+params.get(segment.substr(1));
  	            }else{
  	              throw "Path '"+path+"' is missing param '"+segment+"'";
  	            }
  	          }else{
  	            uri += "/"+segment;
  	          }
  	        }
  	        while(StringTools.startsWith(uri,"//")){ // extra ugly cleanup, can remove if the for loop above is written better
  	          uri = uri.substr(1);
  	        }
            break;        
  	      }else{
  	        throw "Route named '"+name+"' does not have a uri set in ./config/routes.yml";
  	      }
  	    }else if(e.name == "rest"){ // look in restful routes
  	      var resource_name = Utils.singularize(e.innerData.toLowerCase());
          var id = (params != null && params.exists("id"))? params.get("id") : null;
          if(name == Utils.pluralize(resource_name)){ // index
  	        uri = "/"+Utils.pluralize(resource_name);
  	        break;
  	      }else if(name == resource_name){ // show
  	        uri = "/"+Utils.pluralize(resource_name)+"/"+id;
  	        break;
          }else if(name == "new_"+resource_name){ // new
            uri = "/"+Utils.pluralize(resource_name)+"/new";
            break;
          }else if(name == "create_"+resource_name){ // create
            uri = "/"+Utils.pluralize(resource_name);
            break;
          }else if(name == "edit_"+resource_name){ // edit
            uri = "/"+Utils.pluralize(resource_name)+"/"+id+"/edit";
            break;
          }else if(name == "update_"+resource_name){ // update
            uri = "/"+Utils.pluralize(resource_name)+"/"+id;
            break;
          }else if(name == "destroy_"+resource_name){ // destroy
            uri = "/"+Utils.pluralize(resource_name)+"/"+id+"/destroy";
            break;
          }
  	    }
  	  }
	  }
	  return uri;
	}
}