/* Boot class */
#if php
  import php.Sys;
  import php.Session;
  import php.io.File;
  import php.Web;
#elseif neko
  import neko.Web;
#elseif nodejs
  import js.Node;
#end

  import yaml_crate.YamlHX;
  import macros.LandingGearMacro;
  import macros.RoutesMacro;
  import macros.ImportClassesMacro;
  import db.DBConnection;

class Takeoff
{
  public static var headers: List<{ value : String, header : String}>;
  public static var path: String;
  public static var params: Hash<String>;
  public static var controller: Dynamic; // AeroController;
  
/*  #if nodejs
    public static var url_parts: NodeUrlObj;
  #end*/
  
	static function main() {
	  // read configs
		
		
		// initialize variables
		
		/*    trace(php.Sys.environment());*/
		
		// env   
#if production
    Settings.set("FBN_ENV", "production");
    Settings.set("ATMOSPHERE", "production"); // alias
#else // development
    Settings.set("FBN_ENV", "development");
    Settings.set("ATMOSPHERE", "development"); // alias
#end
    
    // set FBN_ROOT
    #if php
      Settings.set("FBN_ROOT", Settings.get("DOCUMENT_ROOT").substr(0,Settings.get("DOCUMENT_ROOT").lastIndexOf("deploy")));
    #elseif nodejs
    
      Settings.set("DOCUMENT_ROOT", untyped(__dirname)+"/" );
      Settings.set("FBN_ROOT", Settings.get("DOCUMENT_ROOT").substr(0,Settings.get("DOCUMENT_ROOT").lastIndexOf("server")));
    
    #end
    
    // read application config
    #if nodejs
      Node.fs.readFile(Settings.get("FBN_ROOT")+"config/application.yml", function(err, data){
/*        if(err != null){ throw err; }*/
        FlyByNightMixins._APP_CONFIG = YamlHX.read(data);
      });
    #else
      FlyByNightMixins._APP_CONFIG = YamlHX.read(File.getContent(Settings.get("FBN_ROOT")+"config/application.yml"));
    #end
    enable_sessions();
    
    LandingGearMacro.stage();

		// write paths from routes.yml
		RoutesMacro.write();
		Routes;

		// compile classes
    ImportClassesMacro.write();
    macros.ImportClasses;
    
    
		
#if nodejs
  
    var dbpool = DBConnection.connection;
  
    var server = Node.net.createServer(function(nodeSocket) {
      nodeSocket.addListener(NodeC.EVENT_STREAM_CONNECT,function(data) {
        trace("got connection");
        trace( data );
        //nodeSocket.write("hello\r\n");
      });
      
      nodeSocket.addListener(NodeC.EVENT_STREAM_DATA,function(data) {
        
        headers = null; //req.headers;
    		path = ""; //req.url;
    		params = new Hash<String>();
    		var url_parts:NodeUrlObj;

    		// CHANGE method for params _method 
    		var _method = null; //req.method;

    		var method:HTTPVerb = null;
    		switch(_method){
    			case "GET" : 
    			  method = HTTPVerb.GET;
    			  url_parts = Node.url.parse(path/*req.url*/,true); // params
            //console.log(params);

    			case "POST" :
    			  if(params.exists("_method")){
    			    if(params.get("_method") == "DELETE"){
    			      method = HTTPVerb.DELETE;
    		      }else if(params.get("_method") == "PUT"){
    		        method = HTTPVerb.PUT;
    		      }
    			  }else{
    			    method = HTTPVerb.POST;
    			  }
            var body='';
  			    nodeSocket.addListener(NodeC.EVENT_STREAM_DATA,function(data) {
              body +=data;
            });
            nodeSocket.addListener(NodeC.EVENT_STREAM_END,function(data){
              params =  Node.queryString.parse(body);
              //console.log(params);
            });
    		}





        // route request to AeroController, AeroRestController handles the REST
        controller = Route.resolve(path, method, params);
        controller.res = nodeSocket;
        
        if(controller.view != null) controller.view.render();

          // c.write(d);
          //connectMongo(pool);

        
        
        
        /*nodeSocket.write("DATA");
                nodeSocket.write(data);
                nodeSocket.end("done writing");*/
        nodeSocket.end();
      });

    });

    server.listen(5000,"localhost");
    
#else
		

		// Build a Request object
		
		headers = Web.getClientHeaders();
		path = Web.getURI();
		params = Web.getParams();
    
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
		
		// route request to AeroController, AeroRestController handles the REST
		controller = Route.resolve(path, method, params);
    if(controller.view != null) controller.view.render();
    
    // close any db connections
	  DBConnection.close();
	  
#end

		
/*    throw(path);*/
    
    
    
    
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
    
  
	  
	  
	  // close sessions
	  #if !nodejs
  	  if(Settings.get("FBN_SESSION_ENABLE") == "true"){
        Session.close();
      }
    #end
	}
	
	private static inline function enable_sessions(  ):Void
	{
	  #if !nodejs
  	  if(FlyByNightMixins._APP_CONFIG != null){
        Settings.set("FBN_SESSION_ENABLE", FlyByNightMixins.APP_CONFIG(null, "session.enable"));
        if(Settings.get("FBN_SESSION_ENABLE") == "true"){
          Settings.set("FBN_SESSION_NAME", FlyByNightMixins.APP_CONFIG(null,"session.name"));
          Session.setName(Settings.get("FBN_SESSION_NAME"));
          Session.start();
        }
      }
    #end
	}
}