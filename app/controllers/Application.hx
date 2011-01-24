package controllers;
class Application extends AeroController
{
  public function new( action:String )
  {
    super(action);
    
    var page = new Hash<Dynamic>();
    page.set("title","Fly By Night");
    content.set("page", page);
  }
}