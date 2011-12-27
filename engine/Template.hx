class Template
{
  /*
    haml : TemplateType.HAML,
    mtt : TemplateType.TEMPLO,
    xml : TemplateType.XML
  */
  public static var types(get_types, null):Hash<TemplateType>;
  private static inline function get_types():Hash<TemplateType>{
    var h = new Hash<TemplateType>();
    h.set('haml', TemplateType.HAML);
/*  NOT YET IMPLEMENTED
    h.set('mtt', TemplateType.TEMPLO);
    h.set('xml', TemplateType.XML);*/
    return h;
  }
}