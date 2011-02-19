package controllers;
import AeroController;
import models.Post;
using AeroModel;

class Posts extends controllers.Application
{
	public function index( ):Void
	{

/*    trace(Type.typeof(AeroModel));*/
    Post.find("hello");
    
    content.set("content", "Hello Posts INDEX");
    
	}
	public function show( ):Void
	{
	  content.set("content", "Hello Posts SHOW "+params.get("id"));
	}
	
  public function make():Void{ }
  
  public function create( ):Void
  {
    var post = new Post();
    post.title = obj_params.get("title");
    post.body = obj_params.get("body");
    post.insert();
    
    trace(post);
  }
  
}