import models.Post;

class Posts extends controllers.Application
{
	public function index( ):Void
	{
    var posts = Post.all();
    content.set("posts", posts);
    content.set("content", "Showing "+posts.length+" posts.");
    
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