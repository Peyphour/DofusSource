package com.ankamagames.berilia.types.data
{
   public class TextTooltipInfo
   {
       
      
      public var content:String;
      
      public var css:String;
      
      public var cssClass:String;
      
      public var maxWidth:int;
      
      public var bgCornerRadius:int = 0;
      
      public var checkSuperposition:Boolean;
      
      public var cellId:int = -1;
      
      public function TextTooltipInfo(param1:String, param2:String = null, param3:String = null, param4:int = 400, param5:Boolean = false, param6:int = -1)
      {
         super();
         this.content = param1;
         this.css = param2;
         if(param3)
         {
            this.cssClass = param3;
         }
         else
         {
            this.cssClass = "text";
         }
         this.maxWidth = param4;
         this.checkSuperposition = param5;
         this.cellId = param6;
      }
   }
}
