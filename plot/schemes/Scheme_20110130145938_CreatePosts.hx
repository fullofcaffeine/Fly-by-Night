// scheme devised by ./autopilot/devise.n
class Scheme_20110130145938_CreatePosts extends AeroScheme, implements IScheme{
  public function engage():Void
  {
    create_table('posts', null,
'title: string
body: text
timestamps
'
    );
  }
  public function abort():Void
  {
    drop_table('posts');
  }
}