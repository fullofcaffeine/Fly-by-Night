class Template
{
  /*
    haml : TemplateType.HAML,
    html : TemplateType.HTML,
    mtt : TemplateType.TEMPLO,
    xml : TemplateType.XML
    
    // future, (not sure if will do)
    js : TemplateType.JAVASCRIPT,
    jq : TemplateType.JQUERY,
    json : TemplateType.JSON,
    flash : TemplateType.FLASH, // bunch of swfs to load, least useful, most cool
  */
  public static var types(get_types, null):Hash<TemplateType>;
  private static inline function get_types():Hash<TemplateType>{
    var h = new Hash<TemplateType>();
    h.set('haml', TemplateType.HAML);
    h.set('html', TemplateType.HTML);
    /*  NOT YET IMPLEMENTED
        h.set('mtt', TemplateType.TEMPLO);
        h.set('xml', TemplateType.XML);*/
    return h;
  }
}