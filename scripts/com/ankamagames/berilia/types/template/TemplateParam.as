package com.ankamagames.berilia.types.template
{
   public class TemplateParam
   {
       
      
      public var name:String;
      
      public var value:String;
      
      public var defaultValue:String;
      
      public function TemplateParam(param1:String, param2:String = null)
      {
         super();
         this.name = param1;
         this.value = param2;
      }
   }
}
