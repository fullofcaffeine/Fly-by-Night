/*
  To see a full list of auto imported classes for all subclasses of AeroHelper
  See RunwayMacros.PREPEND_TO_HELPER 
*/
class AeroHelper
{
  public var controller: AeroController;
  public var yield: String;
  
  public function new( controller:AeroController )
  {
    this.controller = controller;
  }
}