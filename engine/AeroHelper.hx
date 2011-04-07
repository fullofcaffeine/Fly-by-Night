/*
  To see a full list of auto imported classes for all subclasses of AeroHelper
  See RunwayMacros.PREPEND_TO_HELPER 
*/
class AeroHelper
{
  public var controller: AeroController;
  public var yield: String;
  /* if  private var load_helpers: Array<Dynamic>  exists
   each is loaded 
   by HamlHX */
  
  public function new( controller:AeroController )
  {
    this.controller = controller;
  }
}