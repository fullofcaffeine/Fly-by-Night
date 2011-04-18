import php.Session;
class Sessions extends controllers.Application
{
	public function login():Void{
    if(
      obj_params.get("username") == "admin" &&
      obj_params.get("password") == "admin"
    ){
      Session.set("user","admin");
      redirect_to( Routes.root.path() );
    }else{
      if(route.via == HTTPVerb.POST){
        content.set("status","Tell your boss Johnny don't like dead mooses.");
      }else{
        content.set("status","What's the secret password?");
      }
    }
  }
	public function logout( ):Void
  {
    if(Session.exists("user")){
      Session.remove("user");
    }
    redirect_to( Routes.root.path() );
  }
	
}