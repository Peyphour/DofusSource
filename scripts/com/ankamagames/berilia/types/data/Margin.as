package com.ankamagames.berilia.types.data
{
   public class Margin
   {
       
      
      public var left:int;
      
      public var right:int;
      
      public var top:int;
      
      public var bottom:int;
      
      public function Margin(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.setTo(param1,param2,param3,param4);
      }
      
      public function setTo(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0) : void
      {
         this.left = param1;
         this.right = param2;
         this.top = param3;
         this.bottom = param4;
      }
   }
}
