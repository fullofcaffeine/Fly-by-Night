/*
  To see a full list of auto imported classes for all subclasses of AeroController
  See RunwayMacros.PREPEND_TO_CONTROLLER 
*/
import php.FileSystem;
import php.Web;
class AeroController
{
  public var name: String;
  public var view: AeroView;
  public var action: String;
  public var content: Hash<Dynamic>;
  public var helper: AeroHelper;
  public var params: Hash<String>;
  public var obj_params: Hash<String>;
  
  public function new( action:String, params:Hash<String> )
  {
    name = Type.getClassName(Type.getClass(this)).substr(12); // controller.
    this.action = action;
    content = new Hash<Dynamic>();
    this.params = params;
    var default_obj_name = Utils.singularize(name.toLowerCase());
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
	  var keys = php.Web.getParamValues(obj+"_keys");
	  var vals = php.Web.getParamValues(obj);
	  
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
	  var keys = php.Web.getParamValues(obj+"_keys");
	  var vals = php.Web.getParamValues(obj);
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

}