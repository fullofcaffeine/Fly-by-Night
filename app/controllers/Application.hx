class Application extends AeroController
{
  public function new( action:String, params:Hash<String> )
  {
    super(action,params);
    
    var page = new Hash<Dynamic>();
    page.set("title", APP_CONFIG("site_title"));
    content.set("page", page);
  }
}