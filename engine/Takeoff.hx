/* Boot class */
import php.Sys;
import php.Session;
import php.io.File;
import yaml_crate.YamlHX;
class Takeoff
{

  
	static function main() {
	  // read configs
		
		
		// initialize variables
		
		/*    trace(php.Sys.environment());*/
		
		// env
#if test
    Settings.set("FBN_ENV", "test");
#elseif production
    Settings.set("FBN_ENV", "production");
#else // development
    Settings.set("FBN_ENV", "development");
#end
    
    // set FBN_ROOT
    Settings.set("FBN_ROOT", Settings.get("DOCUMENT_ROOT").substr(0,Settings.get("DOCUMENT_ROOT").lastIndexOf("deploy")));
    
    // read application config
    var app_yml = YamlHX.read(File.getContent(Settings.get("FBN_ROOT")+"config/application.yml"));
    
    if(app_yml != null){
      if(Settings.set("FBN_SESSION_ENABLE", app_yml.get("session.enable")) == "true"){
        Settings.set("FBN_SESSION_PREFIX", app_yml.get("session.prefix"));
        Session.start();
      }
    }
    
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
		  
		RunwayMacro.stage();
		
		// write paths from routes.yml
		RoutesMacro.write();
		Routes;
		
		// compile classes
    ImportClassesMacro.write();
    ImportClasses;
  
  
    var controller = Route.resolve(path, method, params);
    if(controller.view != null) controller.view.render();
    
    RunwayMacro.restore();
	  
	  // close any db connections
	  DBConnection.close();
	  
	  // close sessions
	  if(Settings.get("FBN_SESSION_ENABLE") == "true"){
      Session.close();
    }
	}
}