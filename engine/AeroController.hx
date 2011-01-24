import php.FileSystem;
class AeroController
{
  public var name: String;
  public var view: AeroView;
  public var action: String;
  public var content: Hash<Dynamic>;
  public var helper: AeroHelper;
  
  public function new( action:String )
  {
    name = Type.getClassName(Type.getClass(this)).substr(12); // controller.
    this.action = action;
    content = new Hash<Dynamic>();
    
    if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/helpers/"+name+".hx")){
      helper = Type.createInstance(Type.resolveClass("helpers."+name),[this]);
    }else if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/helpers/Application.hx")){
      helper = Type.createInstance(Type.resolveClass("helpers.Application"),[this]);
    }else{
      helper = new AeroHelper(this);
    }
    
    view = new AeroView(this);
  }

  
}