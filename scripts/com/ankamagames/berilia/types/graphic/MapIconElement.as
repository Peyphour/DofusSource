package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBase;
   import flash.geom.Rectangle;
   
   public class MapIconElement extends MapDisplayableElement
   {
       
      
      public var legend:String;
      
      public var follow:Boolean;
      
      public var canBeGrouped:Boolean = true;
      
      public var canBeAutoSize:Boolean = true;
      
      public var canBeManuallyRemoved:Boolean = true;
      
      public var allowDuplicate:Boolean;
      
      public var priority:uint;
      
      public var color:int;
      
      private var _boundsRef:TextureBase;
      
      public function MapIconElement(param1:String, param2:int, param3:int, param4:String, param5:TextureBase, param6:int, param7:String, param8:*, param9:Boolean = true, param10:Boolean = false, param11:Boolean = false, param12:uint = 0)
      {
         super(param1,param2,param3,param4,param8,param5);
         this.legend = param7;
         this.canBeManuallyRemoved = param9;
         this.allowDuplicate = param11;
         this.priority = param12;
         this.color = param6;
         _texture.mouseEnabled = param10;
      }
      
      public function get bounds() : Rectangle
      {
         return !!this._boundsRef?this._boundsRef.getStageRect():this.getRealBounds;
      }
      
      public function get getRealBounds() : Rectangle
      {
         return !!_texture?_texture.getStageRect():null;
      }
      
      public function set boundsRef(param1:Texture) : void
      {
         this._boundsRef = param1;
      }
      
      override public function remove() : void
      {
         this._boundsRef = null;
         super.remove();
      }
      
      public function get key() : String
      {
         return x + "_" + y;
      }
   }
}
