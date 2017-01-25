package com.ankamagames.atouin.types
{
   import flash.display.Sprite;
   
   public class FrustumShape extends Sprite
   {
       
      
      private var _direction:uint;
      
      public function FrustumShape(param1:uint)
      {
         super();
         this._direction = param1;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
   }
}
