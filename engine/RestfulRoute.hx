class RestfulRoute extends Route
{

	public function new(name:String, request_uri:String, method:HTTPVerb, ?params:Hash<String> )
	{
	  var request_segments = request_uri.split("/");
	  var path = name;
	  var action = "index";
	  switch(request_segments.length){
	    case 1:
	      //path = name;
	      if(method == HTTPVerb.GET){
	        // default
	      }else if(method == HTTPVerb.POST){
	        action = "create";
        }else{
          throw "UNKNOWN ROUTE"; // TODO better message
        }
	    case 2:
	      if(request_segments[1] == "new"){
	        path += "/new";
	        action = "make";
	      }else{
	        path += "/:id";
	        if(method == HTTPVerb.DELETE){
	          action = "destroy";
	        }else if(method == HTTPVerb.PUT){
	          action = "update";
	        }else if(method == HTTPVerb.GET){
	          action = "show";
	        }else{
	          throw "UNKNOWN ROUTE"; // TODO better message
	        }
	      }
	    case 3:
	      if(request_segments[1] == "edit"){
	        path += "/:id/edit";
	        action = "edit";
        }else{
          throw "UNKNOWN ROUTE"; // TODO better message
        }
	  }
	  
		super(name, path, request_uri, name, action, method, params);
	}
}