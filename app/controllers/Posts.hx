package controllers;
import AeroController;
class Posts extends controllers.Application
{
	public function index( ):Void
	{
    content.set("content", "Hello Posts INDEX");
	}
	public function show( params:Hash<String> ):Void
	{
	  content.set("content", "Hello Posts SHOW "+params.get("id"));
	}
}