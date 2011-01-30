// scheme devised by ./autopilot/devise.n
class Scheme_20110125190521_CreateSomeTable extends AeroScheme, implements IScheme{
  public function engage():Void
  {
    create_table("sometable", { no_id : false },
      '
username:
  type: string
  null: false
  unique
first_name:
  type: string
  default: "Sheldon"
last_name:
  type: string
  default: "Cooper"
counter:
  type: integer
  unique
  autoincrement
age:
  type: integer
  limit: 100
balance:
  type: float
  precision: 8
  scale: 2
address: text
      '
    );
  }
  public function abort():Void
  {
    drop_table("sometable");
  }
}