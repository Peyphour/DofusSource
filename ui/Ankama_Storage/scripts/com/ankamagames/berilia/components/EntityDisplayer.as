package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EntityDisplayer extends GraphicContainer
   {
       
      
      public function EntityDisplayer()
      {
         super();
      }
      
      public function get yOffset() : int
      {
         return new int();
      }
      
      public function set yOffset(param1:int) : void
      {
      }
      
      public function get xOffset() : int
      {
         return new int();
      }
      
      public function set xOffset(param1:int) : void
      {
      }
      
      public function get entityScale() : Number
      {
         return new Number();
      }
      
      public function set entityScale(param1:Number) : void
      {
      }
      
      public function get useFade() : Boolean
      {
         return new Boolean();
      }
      
      public function set useFade(param1:Boolean) : void
      {
      }
      
      public function get clearSubEntities() : Boolean
      {
         return new Boolean();
      }
      
      public function set clearSubEntities(param1:Boolean) : void
      {
      }
      
      public function get clearAuras() : Boolean
      {
         return new Boolean();
      }
      
      public function set clearAuras(param1:Boolean) : void
      {
      }
      
      public function get withoutMount() : Boolean
      {
         return new Boolean();
      }
      
      public function set withoutMount(param1:Boolean) : void
      {
      }
      
      public function get maskRect() : String
      {
         return new String();
      }
      
      public function set maskRect(param1:String) : void
      {
      }
      
      public function set look(param1:*) : void
      {
      }
      
      public function get look() : Object
      {
         return null;
      }
      
      public function set direction(param1:uint) : void
      {
      }
      
      public function get direction() : uint
      {
         return 0;
      }
      
      public function set animation(param1:String) : void
      {
      }
      
      public function get animation() : String
      {
         return null;
      }
      
      public function set gotoAndStop(param1:int) : void
      {
      }
      
      public function get autoSize() : Boolean
      {
         return false;
      }
      
      public function set view(param1:String) : void
      {
      }
      
      public function get useCache() : Boolean
      {
         return false;
      }
      
      public function set useCache(param1:Boolean) : void
      {
      }
      
      public function set fixedWidth(param1:Number) : void
      {
      }
      
      public function set fixedHeight(param1:Number) : void
      {
      }
      
      public function get characterReady() : Boolean
      {
         return false;
      }
      
      public function update() : void
      {
      }
      
      public function updateMask() : void
      {
      }
      
      public function updateScaleAndOffsets() : void
      {
      }
      
      public function setAnimationAndDirection(param1:String, param2:uint) : void
      {
      }
      
      public function equipCharacter(param1:Array, param2:int = 0) : void
      {
      }
      
      public function getSlotPosition(param1:String) : Point
      {
         return null;
      }
      
      public function getSlotBounds(param1:String) : Rectangle
      {
         return null;
      }
      
      public function getEntityBounds() : Rectangle
      {
         return null;
      }
      
      public function getEntityOrigin() : Point
      {
         return null;
      }
      
      public function setColor(param1:uint, param2:uint) : void
      {
      }
      
      public function resetColor(param1:uint) : void
      {
      }
      
      public function destroyCurrentEntity() : void
      {
      }
   }
}
