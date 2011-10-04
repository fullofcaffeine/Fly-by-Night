package helpers;using AeroModel; using AeroPath; using FlyByNightMixins;/*LandingGear*/
class Posts extends Application
{
  public function list_posts( posts:List<models.Post> ):String
  {
    var output = "<ul>";
    for(post in posts){
      output += "<li><strong>"+post.title+"</strong><p>"+post.body+"</p></li>";
    }
    output += "</ul>";
    return output;
  }
}

