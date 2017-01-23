package com.ankamagames.atouin.types
{
   import com.ankamagames.jerakine.interfaces.ICustomUnicNameGetter;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class SpriteWrapper extends Sprite implements ICustomUnicNameGetter
   {
       
      
      private var _name:String;
      
      public function SpriteWrapper(param1:DisplayObject, param2:uint)
      {
         super();
         addChild(param1);
         this._name = "mapGfx::" + param2;
      }
      
      public function get customUnicName() : String
      {
         return this._name;
      }
   }
}
