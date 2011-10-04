package controllers;using AeroModel; using AeroPath; using FlyByNightMixins;/*LandingGear*/
import php.Session;
class Application extends AeroController
{
	public static var before_filter:AirFilter = {
    actions : ["check_authorized"],
    except : ["login","logout"],
    only : null
  };
  public inline function check_authorized():Bool
  {
		if(!Session.exists("user")){
			redirect_to(Routes.login.path());
    }
    return true;
  }
  /*public inline function check_authorized():Bool
    {
      if(Session.exists("user")){
        
      }else{
        action = "login";
      }
      return true;
    }*/
  
  public function new( action:String, params:Hash<String>, ?route:Route = null )
  {
    super(action,params,route);
    
    var page = new Hash<Dynamic>();
    page.set("title", APP_CONFIG("site_title"));
    content.set("page", page);
  }
}
