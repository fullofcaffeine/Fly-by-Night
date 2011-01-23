class Route
{
	public var name: String; // update_foo5
  public var path: String; // foo5/:id
  public var request_uri: String; // foo5/15
  public var controller: String; // foo5
  public var action: String; // update
  public var via: HTTPVerb; // put
  public var params: Hash<String>;
	public function new( name:String, path:String, request_uri:String, controller:String, action:String, via:HTTPVerb, ?params:Hash<String> = null )
	{
		this.name = name;
		this.path = if(StringTools.startsWith(path, "/")) path.substr(1) else path;
		this.request_uri = request_uri;
		this.controller = controller;
		this.action = action;
		this.via = via;
    this.params = (params != null)? params : new Hash<String>();
    processParams();
	}
	private inline function processParams(  ):Void
	{
	  var request_segments = this.request_uri.split("/");
	  var path_segments = this.path.split("/");
	  for(i in 0...path_segments.length){
	    if(StringTools.startsWith(path_segments[i], ":")){
	      params.set(path_segments[i].substr(1), request_segments[i]);
	    }
	  }
	}
}