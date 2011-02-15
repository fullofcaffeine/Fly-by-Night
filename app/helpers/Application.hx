package helpers;
class Application extends AeroHelper
{
  private var load_helpers: Array<Dynamic>;
  public function new( controller:AeroController )
  {
    super(controller);
    load_helpers = [new aero_helpers.Forms(controller)];
  }
}