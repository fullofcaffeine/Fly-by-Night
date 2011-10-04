/* Boot class */
import php.Sys;
import php.Session;
import yaml_crate.YamlHX;
import php.io.File;
import macros.LandingGearMacro;
import macros.RoutesMacro;
import macros.ImportClassesMacro;
import db.DBConnection;
class Takeoff
{
  public static var headers: List<{ value : String, header : String}>;
  public static var path: String;
  public static var params: Hash<String>;
  public static var controller: AeroController;
  
	static function main() {
	  // read configs
		
		
		// initialize variables
		
		/*    trace(php.Sys.environment());*/
		
		// env
#if test
    Settings.set("FBN_ENV", "test");
    Settings.set("ATMOSPHERE", "test"); // alias
#elseif production
    Settings.set("FBN_ENV", "production");
    Settings.set("ATMOSPHERE", "production"); // alias
#else // development
    Settings.set("FBN_ENV", "development");
    Settings.set("ATMOSPHERE", "development"); // alias
#end
    
    // set FBN_ROOT
    Settings.set("FBN_ROOT", Settings.get("DOCUMENT_ROOT").substr(0,Settings.get("DOCUMENT_ROOT").lastIndexOf("deploy")));
/*    Settings.set("FBN_ROOT", Settings.get("DOCUMENT_ROOT")+"/../");*/
    
    // read application config
    FlyByNightMixins._APP_CONFIG = YamlHX.read(File.getContent(Settings.get("FBN_ROOT")+"config/application.yml"));
    
    if(FlyByNightMixins._APP_CONFIG != null){
      Settings.set("FBN_SESSION_ENABLE", FlyByNightMixins.APP_CONFIG(null, "session.enable"));
      if(Settings.get("FBN_SESSION_ENABLE") == "true"){
        Settings.set("FBN_SESSION_NAME", FlyByNightMixins.APP_CONFIG(null,"session.name"));
        Session.setName(Settings.get("FBN_SESSION_NAME"));
        Session.start();
      }
    }
    
		// route request to AeroController, AeroRestController handles the REST
		
		
		// Build/ Instantiate a Request object
		
		headers = php.Web.getClientHeaders();
		path = php.Web.getURI();
		params = php.Web.getParams();
    
		// CHANGE method for params _method 
		var _method = php.Web.getMethod();
    
		var method = switch(_method){
			case "GET" : HTTPVerb.GET;
			case "POST" :
			  if(params.exists("_method")){
			    if(params.get("_method") == "DELETE"){
			      HTTPVerb.DELETE;
		      }else if(params.get("_method") == "PUT"){
		        HTTPVerb.PUT;
		      }
			  }else{
			    HTTPVerb.POST;
			  }
			  
		}
    
		// convert  List<{ value : String, header : String}> to Hash<String>
		
	  LandingGearMacro.stage();
		
		// write paths from routes.yml
		RoutesMacro.write();
		Routes;
		
		// compile classes
    ImportClassesMacro.write();
    macros.ImportClasses;
  
  
/*    throw(path);*/
    
    controller = Route.resolve(path, method, params);
    if(controller.view != null) controller.view.render();
    
    
    /*
                php.Lib.print("<div class='fbn_debug'><ul>");
                php.Lib.print('<li>Request uri : '+ path + '</li>');
                php.Lib.print('<li>Request method : '+ method + '</li>');
                for(h in headers){
                  php.Lib.print('<li>'+ h.header + ' : ' + h.value + '</li>');
                }
                php.Lib.print('</ul><h3>Params</h3><ul>');
                for(k in params.keys()){
                  php.Lib.print('<li>'+ k + ' : ' + params.get(k) + '</li>');
                }
                
                php.Lib.print("</ul><h3>SESSION</h3><p>");
                php.Lib.print("ID: "+Session.getId()+"\n<br />Name: "+Session.getName()+"\n<br />Module: "+Session.getModule()+"\n<br />Save Path: "+Session.getSavePath());
                php.Lib.print("</div>");
                */
    
	  
	  // close any db connections
	  DBConnection.close();
	  
	  // close sessions
	  if(Settings.get("FBN_SESSION_ENABLE") == "true"){
      Session.close();
    }
	}
}