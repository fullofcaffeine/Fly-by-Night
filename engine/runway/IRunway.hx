package runway;
interface IRunway
{
  public var currentTest : Status;
  public function setup() : Void;
	public function tearDown() : Void;
}