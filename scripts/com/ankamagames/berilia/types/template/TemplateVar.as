package com.ankamagames.berilia.types.template
{
   public class TemplateVar
   {
       
      
      public var name:String;
      
      public var value;
      
      public function TemplateVar(param1:String, param2:* = null)
      {
         super();
         this.name = param1;
         this.value = param2;
      }
      
      public function clone() : TemplateVar
      {
         var _loc1_:TemplateVar = new TemplateVar(this.name);
         _loc1_.value = this.value;
         return _loc1_;
      }
   }
}
