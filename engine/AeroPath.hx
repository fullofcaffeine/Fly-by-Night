class AeroPath
{
  public static function path( route:Routes, ?params:Hash<String> ):String
	{
	  var name = Std.string(route);
	  var uri = "";
	  for(e in Route.routes_yml.elements){
	    if(e.name == "map" && e.hasNode.name && e.node.name.innerData == "name"){ // check if name exists in routes.yml
	      if(e.hasNode.uri){
	        uri = e.node.uri.innerData;
	        break;
	      /*}else if(e.hasNode.path && e.node.path.innerData == path){
	               uri = e.node.uri.innerData; // TODO FIX, should map to correct url with params
	               break;
	             */
	      }else{
	        throw "Route named '"+name+"' does not have a uri set in ./config/routes.yml";
	      }
	    }else if(e.name == "rest"){ // look in restful routes
        var resource_name = e.innerData.toLowerCase();
        var id = (params != null && params.exists("id"))? params.get("id") : null;
	      if(name == Utils.pluralize(resource_name)){ // index
	        uri = "/"+Utils.pluralize(resource_name);
	        break;
	      }else if(name == resource_name){ // show
	        uri = "/"+resource_name+"/"+id;
	        break;
        }else if(name == "new_"+resource_name){ // new
          uri = "/"+resource_name+"/new";
          break;
        }else if(name == "create_"+resource_name){ // create
          uri = "/"+resource_name;
          break;
        }else if(name == "edit_"+resource_name){ // edit
          uri = "/"+resource_name+"/"+id+"/edit";
          break;
        }else if(name == "update_"+resource_name){ // update
          uri = "/"+resource_name+"/"+id;
          break;
        }else if(name == "destroy_"+resource_name){ // destroy
          uri = "/"+resource_name+"/"+id+"/destroy";
          break;
        }
	    }
	  }
	  return uri;
	}
}