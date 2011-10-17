/*
  To see a full list of auto imported classes for all subclasses of AeroController
  See LandingGearMacro.APPEND_TO_CONTROLLER 
*/
#if php
import php.FileSystem;
import php.Web;
#elseif neko
import neko.FileSystem;
import neko.Web;
#end
class AeroController
{
  public var name: String;
  public var view: AeroView;
  public var action: String;
  public var content: Hash<Dynamic>;
  public var helper: AeroHelper;
  public var params: Hash<String>;
  public var obj_params: Hash<String>;
  public var route: Route;
  
  public function new( action:String, params:Hash<String>, ?route:Route = null )
  {
    this.route = route;
    name = Type.getClassName(Type.getClass(this)).substr(12); // controller.
    this.action = action;
    content = new Hash<Dynamic>();
    this.params = params;
    var default_obj_name = Utils.singularize(Utils.to_underscore(name).toLowerCase());
    obj_params = getObjParams(default_obj_name);
    
    if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/helpers/"+name+".hx")){
      helper = Type.createInstance(Type.resolveClass("helpers."+name),[this]);
    }else if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/helpers/Application.hx")){
      helper = Type.createInstance(Type.resolveClass("helpers.Application"),[this]);
    }else{
      helper = new AeroHelper(this);
    }
    
    if(action != "create" && action != "update" && action != "destroy")
      view = new AeroView(this);
  }
  
  private inline function getParam( obj:String, key:String ):String
  {
    var val = "";
	  var keys = Web.getParamValues(obj+"_keys");
	  var vals = Web.getParamValues(obj);
	  
	  if(keys != null && vals != null){
	    var l = keys.length;
  	  for(i in 0...l){
  	    if(keys[i] == key){
  	      val = vals[i];
  	      break;
  	    }
  	  }
	  }
	  return val;
  }
  
  private static inline function getObjParams( obj:String ): Hash<String>
	{
	  var h = new Hash<String>();
	  var keys = Web.getParamValues(obj+"_keys");
	  var vals = Web.getParamValues(obj);
	  if(keys != null && vals != null){
	    var l = keys.length;
  	  for(i in 0...l){
  	    h.set(keys[i], vals[i]);
  	  }
	  }
	  return h;
	}

  private inline function redirect_to(url:String):Void
  {
    Web.redirect(url);
  }
  private inline function render(named_route:Routes):Void
  {
    /*var controller = Route.resolve(path, method, params);
        if(controller.view != null) controller.view.render();*/
  }


  /*
	
	  If any filter returns false, the action requested will not run
	  
	*/
	public static inline function runBeforeFilters( controller:Dynamic ):Bool
	{
	  var positive_return = true;
	  var this_class = Type.getClass(controller);
	  
	  if(Std.is(controller, AeroController)){
	    
	    // first run this controller's AirFilters
	    if(Reflect.hasField(this_class, "before_filter")){
  	    var filter:AirFilter = Reflect.field(this_class, "before_filter");
  /*      throw filter.except;*/

        for(action in filter.actions){
          if(positive_return){
            if(filter.except != null && Lambda.has(filter.except, controller.action) ){
              continue;
            }
            if(filter.only != null && !Lambda.has(filter.only, controller.action )){
              continue;
            }
            if(Reflect.callMethod(controller, action, [])){
              continue;
            }else{
              positive_return = false;
              break;
            }
          }
        }

      }
  	  
	    // next traverse parent classes until AirFilters (TODO change this behavior when they are instance members)
	    
	    var parent_class = Type.getSuperClass(this_class);
	    while(parent_class != null && parent_class != AeroController){
	      
	      if(Reflect.hasField(parent_class, "before_filter")){
    	    var filter:AirFilter = Reflect.field(parent_class, "before_filter");
    /*      throw filter.except;*/

          for(action in filter.actions){
            if(positive_return){
              if(filter.except != null && Lambda.has(filter.except, controller.action) ){
                continue;
              }
              if(filter.only != null && !Lambda.has(filter.only, controller.action )){
                continue;
              }
              if(Reflect.callMethod(controller, action, [])){
                continue;
              }else{
                positive_return = false;
                break;
              }
            }
          }

        }
        
	      parent_class = Type.getSuperClass(parent_class);
	    }
	    
	    return positive_return;
	    
	  }else{
	    throw "Cannot run AirFilters on class that does not subclass AeroController";
	    return false;
	  }
  }
}