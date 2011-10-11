package integration;
class Posts extends runway.Integration
{

  @route("GET '/posts'") function it_returns_all_posts_to_content(  )
  {
    assertTrue(false);
    /*
      Post.should_receive(:all)
      and_return(posts)
      
      posts_controller.index();
    */
  }
  
  // identical to doing @route("GET '/posts/1'")
  @controller("PostsController") @action("index") @params({id : 1}) function it_returns_a_single_post(  )
  {
    /*
      Post.should_receive(:find)
      with("id" => 1)
      and_return(post)
      
      posts_controller.show({id:1});
    */
  }
  
  public function hello(){}
  
  
  @route("POST '/posts'") function it_creates_a_new_post(  )
  {
    /*
      Post.should_receive(:new)
      with("text" => "a quick brown fox")
      and_return(post)
      
      
      @message.should_receive(:save)
      
      post :create
    */
  }
  
  @route("PUT '/posts/1'") function it_upates_an_existing_post(  )
  {
    /*
      Post.should_receive(:find)
      with(1)
      and_return(post)
      
      
      post.should_receive(:save)
      and_return(success)
      
      post :update
    */
  }
  
  
}
