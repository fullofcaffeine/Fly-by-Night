package engine;
/* Boot class */
class Takeoff
{
	static function main() {
		
		// read configs
		
		
		// initialize variables
		
		
		// route request to controller, AeroController handles the REST
		
		var params = php.Web.getParams();
		var name = params.exists('name') ? params.get('name') : 'world';
		
		controllers.Landing.index();
		
	
	}
}