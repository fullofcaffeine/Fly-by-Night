class Post extends AeroModel
{
  public static var TABLE_NAME = "posts";
  
  public var title: String;
  public var body: String;
  public function new()
  {
    super();
    
  }
}