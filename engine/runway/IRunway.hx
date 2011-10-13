package runway;
interface IRunway
{
  public var currentTest : Status;
  public function beforeAll() : Void;
  public function beforeEach() : Void;
	public function afterEach() : Void;
	public function afterAll() : Void;
}