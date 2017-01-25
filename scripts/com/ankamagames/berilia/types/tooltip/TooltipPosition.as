package com.ankamagames.berilia.types.tooltip
{
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   
   public class TooltipPosition
   {
       
      
      private var _tooltip:UiRootContainer;
      
      private var _target:IRectangle;
      
      private var _cellId:uint;
      
      private var _rect:Rectangle2;
      
      private var _originalX:Number;
      
      private var _originalY:Number;
      
      private var _offsetRect:IRectangle;
      
      public function TooltipPosition(param1:UiRootContainer, param2:IRectangle, param3:uint, param4:IRectangle = null)
      {
         super();
         this._tooltip = param1;
         this._target = param2;
         this._cellId = param3;
         this._rect = new Rectangle2(this._tooltip.x,this._tooltip.y,this._tooltip.width,this._tooltip.height);
         this._originalX = this._tooltip.x;
         this._originalY = this._tooltip.y;
         this._offsetRect = param4;
      }
      
      public function get tooltip() : UiRootContainer
      {
         return this._tooltip;
      }
      
      public function get target() : IRectangle
      {
         return this._target;
      }
      
      public function set target(param1:IRectangle) : void
      {
         this._target = param1;
      }
      
      public function get cellId() : uint
      {
         return this._cellId;
      }
      
      public function get mapRow() : int
      {
         return this._cellId / 14;
      }
      
      public function get y() : Number
      {
         return this._tooltip.y + (!!this._offsetRect?this._offsetRect.y:0);
      }
      
      public function get x() : Number
      {
         return this._tooltip.x + (!!this._offsetRect?this._offsetRect.x:0);
      }
      
      public function set y(param1:Number) : void
      {
         this._tooltip.y = param1;
      }
      
      public function set x(param1:Number) : void
      {
         this._tooltip.x = param1;
      }
      
      public function get height() : Number
      {
         return this._tooltip.height + (!!this._offsetRect?this._offsetRect.height:0);
      }
      
      public function get width() : Number
      {
         return this._tooltip.width + (!!this._offsetRect?this._offsetRect.width:0);
      }
      
      public function get rect() : Rectangle2
      {
         this._rect.y = this.y;
         this._rect.x = this.x;
         this._rect.width = this.width;
         this._rect.height = this.height;
         return this._rect;
      }
      
      public function get originalX() : Number
      {
         return this._originalX;
      }
      
      public function get originalY() : Number
      {
         return this._originalY;
      }
      
      public function get offsetRect() : IRectangle
      {
         return this._offsetRect;
      }
   }
}
