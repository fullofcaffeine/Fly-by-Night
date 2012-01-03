package models;using AeroModel; using FlyByNightMixins;/*LandingGear*/
class Post extends AeroModel, implements haxe.rtti.Infos
{
  #if nodejs
	static var _indexOn :Array<{name:String, filter:Dynamic->Dynamic}> = [
		{name :"a",filter :function(el :Dynamic) {
			return el.a; }
		}
	];
	#end
  
  // public var _id :String;
  // public var id:String; // last 4 of _id, reroll if exists
  public var title: String;
  public var body: String;
  public function new()
  {
    title = "Default Title";
    super();
  }
  
  public override function toString () :String
	{
		return "[Post _id=" + _id + ", id=" + id + ", title=" + title + ", body=" + body + "]";
	}
}