package controllers;
import AeroController;
class Posts extends controllers.Application
{
	public function index( ):Void
	{
    content.set("content", "Hello Posts INDEX");
	}
	public function show( ):Void
	{
	  content.set("content", "Hello Posts SHOW "+params.get("id"));
	}
	
  public function make():Void{ }
  
  public function create( ):Void
  {
    trace(obj_params);
  }
  
}