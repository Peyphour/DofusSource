package com.ankamagames.atouin.types
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.jerakine.entities.behaviours.IDisplayBehavior;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.Shape;
   import flash.geom.Point;
   
   public class FurnitureZoneTile extends Shape implements IDisplayable
   {
       
      
      private var _displayBehaviors:IDisplayBehavior;
      
      private var _displayed:Boolean;
      
      private var _currentCell:Point;
      
      private var _cellId:uint;
      
      public var strata:uint = 10;
      
      public var needFill:Boolean = false;
      
      public var offset:Point;
      
      public function FurnitureZoneTile()
      {
         super();
      }
      
      public function display(param1:uint = 0) : void
      {
         EntitiesDisplayManager.getInstance().displayEntity(this,MapPoint.fromCellId(this._cellId),param1,false);
         this._displayed = true;
         if(this.offset)
         {
            this.x = this.x - this.offset.x;
            this.y = this.y - this.offset.y;
         }
      }
      
      public function draw(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:int) : void
      {
         param5 = param5 * -1;
         graphics.clear();
         if(param5)
         {
            graphics.lineStyle(2,16777215,0.8);
            graphics.moveTo(AtouinConstants.CELL_HALF_WIDTH,0);
            graphics.lineTo(AtouinConstants.CELL_HALF_WIDTH,param5);
            graphics.moveTo(0,AtouinConstants.CELL_HALF_HEIGHT);
            graphics.lineTo(0,param5 + AtouinConstants.CELL_HALF_HEIGHT);
            graphics.moveTo(-AtouinConstants.CELL_HALF_WIDTH,0);
            graphics.lineTo(-AtouinConstants.CELL_HALF_WIDTH,param5);
            graphics.moveTo(AtouinConstants.CELL_HALF_WIDTH,0);
            graphics.lineTo(0,AtouinConstants.CELL_HALF_HEIGHT);
            graphics.lineTo(-AtouinConstants.CELL_HALF_WIDTH,0);
         }
         if(this.needFill)
         {
            graphics.beginFill(16777215,0.8);
         }
         graphics.moveTo(0,param5 - AtouinConstants.CELL_HALF_HEIGHT);
         graphics.lineStyle(2,16777215,!param3 || this.needFill?Number(0.8):Number(0));
         graphics.lineTo(AtouinConstants.CELL_HALF_WIDTH,param5);
         graphics.lineStyle(2,16777215,!param4 || this.needFill?Number(0.8):Number(0));
         graphics.lineTo(0,param5 + AtouinConstants.CELL_HALF_HEIGHT);
         graphics.lineStyle(2,16777215,!param1 || this.needFill?Number(0.8):Number(0));
         graphics.lineTo(-AtouinConstants.CELL_HALF_WIDTH,param5);
         graphics.lineStyle(2,16777215,!param2 || this.needFill?Number(0.8):Number(0));
         graphics.lineTo(0,param5 - AtouinConstants.CELL_HALF_HEIGHT);
         graphics.endFill();
      }
      
      public function remove() : void
      {
         this.offset = null;
         this.needFill = false;
         this._displayed = false;
         EntitiesDisplayManager.getInstance().removeEntity(this);
      }
      
      public function get displayBehaviors() : IDisplayBehavior
      {
         return this._displayBehaviors;
      }
      
      public function set displayBehaviors(param1:IDisplayBehavior) : void
      {
         this._displayBehaviors = param1;
      }
      
      public function get currentCell() : Point
      {
         return this._currentCell;
      }
      
      public function set currentCell(param1:Point) : void
      {
         this._currentCell = param1;
      }
      
      public function get displayed() : Boolean
      {
         return this._displayed;
      }
      
      public function get absoluteBounds() : IRectangle
      {
         return this._displayBehaviors.getAbsoluteBounds(this);
      }
      
      public function get cellId() : uint
      {
         return this._cellId;
      }
      
      public function set cellId(param1:uint) : void
      {
         this._cellId = param1;
      }
   }
}
