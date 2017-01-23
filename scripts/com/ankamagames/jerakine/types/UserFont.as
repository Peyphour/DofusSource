package com.ankamagames.jerakine.types
{
   public class UserFont
   {
      
      public static const FONT_SIZE_NO_MAX:uint = 0;
      
      public static const FONT_SHARPNESS_MIN:int = -400;
      
      public static const FONT_SHARPNESS_NORMAL:int = 0;
      
      public static const FONT_SHARPNESS_MAX:int = 400;
       
      
      public var realName:String;
      
      public var className:String;
      
      public var sizeMultiplicator:Number;
      
      public var url:String;
      
      public var embedAsCff:Boolean;
      
      public var maxSize:uint = 0;
      
      public var sharpness:int = 0;
      
      public var antialiasingType:String = "advanced";
      
      public var verticalOffset:Number = 0.0;
      
      public var letterSpacing:Number = 0.0;
      
      public function UserFont(param1:String, param2:String, param3:Number, param4:String, param5:Boolean, param6:uint, param7:int, param8:Number, param9:Number)
      {
         super();
         this.realName = param1;
         this.className = param2;
         this.sizeMultiplicator = !!isNaN(param3)?Number(0):Number(param3);
         this.url = param4;
         this.embedAsCff = param5;
         this.maxSize = param6;
         this.sharpness = param7;
         this.verticalOffset = !!isNaN(param8)?Number(0):Number(param8);
         this.letterSpacing = !!isNaN(param9)?Number(0):Number(param9);
      }
   }
}
