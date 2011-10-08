/*
  validate views
  
  -D views must be set (as well as -D app)
  
  1) go through each route
  2) attempt to render it to html
  3) use validator to validate the result (http://www.totalvalidator.com/)

  if your only target does not output html, it would be pretty pointless to enable -D views

*/
package views;
import haxe.unit.TestCase;
class ViewsRunway extends TestCase
{

  public function new()
  {
    super();
  }
}