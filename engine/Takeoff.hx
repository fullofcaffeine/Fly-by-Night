/* Boot class */
import php.Sys;
class Takeoff
{

  
	static function main() {
	  // read configs
		
		
		// initialize variables
		
		/*    trace(php.Sys.environment());*/
    
    // set FBN_ROOT
    Settings.set("FBN_ROOT", Settings.get("DOCUMENT_ROOT").substr(0,Settings.get("DOCUMENT_ROOT").lastIndexOf("deploy")));
		
		
		// route request to AeroController, AeroRestController handles the REST
		
		
		// Build/ Instantiate a Request object
		
		var headers = php.Web.getClientHeaders();
		var path = php.Web.getURI();
		var params = php.Web.getParams();
    
		// CHANGE method for params _method 
		var _method = php.Web.getMethod();
		var method = switch(_method){
			case "GET" : HTTPVerb.GET;
			case "POST" : HTTPVerb.POST;
		}
		
    
		// convert  List<{ value : String, header : String}> to Hash<String>
		
	/*  php.Lib.print("<html><body><ul>");
	   php.Lib.print('<li>Request uri : '+ path + '</li>');
	   php.Lib.print('<li>Request method : '+ method + '</li>');
	   for(h in headers){
	     php.Lib.print('<li>'+ h.header + ' : ' + h.value + '</li>');
	   }
	   php.Lib.print('</ul><h2>Params</h2><ul>');
	   for(k in params.keys()){
	     php.Lib.print('<li>'+ k + ' : ' + params.get(k) + '</li>');
	   }
	   
	   
	   php.Lib.print("</ul></body></html>");*/
		  
		
		// compile classes
	  ImportClassesMacro.write();
		ImportClasses;
		
		var controller = Routes.resolve(path, method, params);
		if(controller.view != null) controller.view.render();
	
	}
}