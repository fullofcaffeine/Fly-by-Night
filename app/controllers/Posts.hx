package controllers;
import AeroController;
class Posts extends AeroController
{
	public static function index( ):Void
	{
    php.Lib.print('Hello ' + 'Posts INDEX' + '!');

	}
	public static function show( params:Hash<String> ):Void
	{
	  php.Lib.print('Hello ' + 'SHOW Posts ' + params.get("id") + '!');
	}
}