package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.managers.HavenbagFurnituresManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.MapContainerRollOutMessage;
   import com.ankamagames.atouin.messages.MapContainerRollOverMessage;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.IFurniture;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOutMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOverMessage;
   import com.ankamagames.dofus.types.entities.HavenbagFurnitureSprite;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   
   public class HavenbagFurnitureDragFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HavenbagFurnitureDragFrame));
      
      private static const FORBIDDEN_CURSOR:Class = HavenbagFurnitureDragFrame_FORBIDDEN_CURSOR;
       
      
      private var _havenbagFrame:HavenbagFrame;
      
      private var _furniture:HavenbagFurnitureSprite;
      
      private var _mouseIsDown:Boolean;
      
      private var _InteractiveCellManager_click:Boolean;
      
      private var _InteractiveCellManager_over:Boolean;
      
      private var _InteractiveCellManager_out:Boolean;
      
      private var _cursorData:LinkedCursorData;
      
      private var _draggedFurnitureCursorData:LinkedCursorData;
      
      private var _moveOnly:Boolean;
      
      public function HavenbagFurnitureDragFrame(param1:uint, param2:uint, param3:HavenbagFrame, param4:Boolean = false)
      {
         super();
         this._havenbagFrame = param3;
         this._furniture = new HavenbagFurnitureSprite(param1);
         this._furniture.orientation = param2;
         this._moveOnly = param4;
         this._cursorData = new LinkedCursorData();
         this._cursorData.sprite = new FORBIDDEN_CURSOR();
         this._cursorData.offset = new Point(-20,-20);
      }
      
      public function get furniture() : HavenbagFurnitureSprite
      {
         return this._furniture;
      }
      
      public function pushed() : Boolean
      {
         this._mouseIsDown = false;
         LinkedCursorSpriteManager.getInstance().addItem("furnitureNotAllowedCursor",this._cursorData);
         this._cursorData.sprite.visible = false;
         this._InteractiveCellManager_click = InteractiveCellManager.getInstance().cellClickEnabled;
         this._InteractiveCellManager_over = InteractiveCellManager.getInstance().cellOverEnabled;
         this._InteractiveCellManager_out = InteractiveCellManager.getInstance().cellOutEnabled;
         InteractiveCellManager.getInstance().setInteraction(true,true,true,true,true);
         this._draggedFurnitureCursorData = LinkedCursorSpriteManager.getInstance().getItem(Slot.DRAG_AND_DROP_CURSOR_NAME);
         HavenbagFurnituresManager.getInstance().disableMouseEvents();
         return true;
      }
      
      public function pulled() : Boolean
      {
         LinkedCursorSpriteManager.getInstance().removeItem("furnitureNotAllowedCursor");
         InteractiveCellManager.getInstance().setInteraction(this._InteractiveCellManager_click,this._InteractiveCellManager_over,this._InteractiveCellManager_out);
         this._draggedFurnitureCursorData = null;
         this._furniture.remove();
         if(this._havenbagFrame.isInEditMode)
         {
            HavenbagFurnituresManager.getInstance().enableMouseEvents();
         }
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GraphicCell = null;
         var _loc3_:CellOverMessage = null;
         var _loc4_:MouseClickMessage = null;
         var _loc5_:KeyboardKeyUpMessage = null;
         switch(true)
         {
            case param1 is CellOverMessage:
               _loc3_ = param1 as CellOverMessage;
               if(this._mouseIsDown)
               {
                  this.onCellPointed(this.havenbagCellValidator(_loc3_.cellId) && this.furnitureCellValidator(_loc3_.cellId),_loc3_.cellId,false);
               }
               else
               {
                  this.refreshTarget(_loc3_.cellId);
               }
               return true;
            case param1 is CellOutMessage:
               this.refreshTarget(-1);
               return true;
            case param1 is CellClickMessage:
               return true;
            case param1 is MouseClickMessage:
               _loc4_ = param1 as MouseClickMessage;
               if(_loc4_.target is GraphicCell || _loc4_.target is IEntity)
               {
                  return false;
               }
               this.onCellPointed(false,-1);
               return false;
            case param1 is MouseDownMessage:
               _loc2_ = MouseDownMessage(param1).target as GraphicCell;
               if(_loc2_)
               {
                  this._mouseIsDown = true;
                  this.onCellPointed(this.havenbagCellValidator(_loc2_.cellId) && this.furnitureCellValidator(_loc2_.cellId),_loc2_.cellId,false);
               }
               return false;
            case param1 is MouseUpMessage:
               this._mouseIsDown = false;
               _loc2_ = MouseUpMessage(param1).target as GraphicCell;
               if(_loc2_)
               {
                  this.onCellPointed(this.havenbagCellValidator(_loc2_.cellId) && this.furnitureCellValidator(_loc2_.cellId),_loc2_.cellId,false);
               }
               else if(this._draggedFurnitureCursorData)
               {
                  this.clear();
               }
               return false;
            case param1 is MapContainerRollOutMessage:
               this._cursorData.sprite.visible = false;
               if(this._draggedFurnitureCursorData)
               {
                  this._draggedFurnitureCursorData.sprite.visible = true;
               }
               this._furniture.remove();
               return false;
            case param1 is MapContainerRollOverMessage:
               this._cursorData.sprite.visible = true;
               if(this._draggedFurnitureCursorData)
               {
                  this._draggedFurnitureCursorData.sprite.visible = false;
               }
               return false;
            case param1 is KeyboardKeyUpMessage:
               _loc5_ = param1 as KeyboardKeyUpMessage;
               if(_loc5_.keyboardEvent.keyCode == Keyboard.SHIFT)
               {
                  this._furniture.orientation++;
                  if(this._furniture.cellsWidth != this._furniture.cellsHeight)
                  {
                     HavenbagFurnituresManager.getInstance().cancelPreviewFurniture(this._furniture);
                     this.refreshTarget(this._furniture.position.cellId,false);
                  }
               }
               return false;
            case param1 is InteractiveElementMouseOverMessage:
            case param1 is InteractiveElementMouseOutMessage:
               return true;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.ULTIMATE_HIGHEST_DEPTH_OF_DOOM;
      }
      
      public function clear() : void
      {
         this._havenbagFrame.clearFurnitureDragFrame();
         HavenbagFurnituresManager.getInstance().cancelPreviewFurniture(this._furniture);
         Kernel.getWorker().removeFrame(this);
      }
      
      private function onCellPointed(param1:Boolean, param2:int, param3:Boolean = true) : void
      {
         var _loc4_:HavenbagFurnitureSprite = null;
         if(param1)
         {
            _loc4_ = new HavenbagFurnitureSprite(this._furniture.typeId);
            _loc4_.position.cellId = param2;
            _loc4_.orientation = this._furniture.orientation;
            HavenbagFurnituresManager.getInstance().cancelPreviewFurniture(this._furniture);
            HavenbagFurnituresManager.getInstance().addFurniture(_loc4_);
         }
         if(param3 || this._moveOnly)
         {
            this._havenbagFrame.clearFurnitureDragFrame();
            Kernel.getWorker().removeFrame(this);
         }
      }
      
      private function refreshTarget(param1:int, param2:Boolean = true) : void
      {
         if(param1 != -1 && this.havenbagCellValidator(param1))
         {
            if(this.furnitureCellValidator(param1))
            {
               HavenbagFurnituresManager.getInstance().previewFurniture(this._furniture);
            }
         }
         else if(param2)
         {
            HavenbagFurnituresManager.getInstance().cancelPreviewFurniture(this._furniture);
         }
      }
      
      private function havenbagCellValidator(param1:int) : Boolean
      {
         var _loc6_:int = 0;
         this._furniture.position = MapPoint.fromCellId(param1);
         var _loc2_:CellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1];
         var _loc3_:Boolean = DataMapProvider.getInstance().cellByIdIsHavenbagCell(param1);
         var _loc4_:Vector.<MapPoint> = this._furniture.cells;
         var _loc5_:int = _loc2_.floor;
         if(_loc3_ && _loc4_.length > 1)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(_loc4_[_loc6_].cellId != param1)
               {
                  _loc2_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc4_[_loc6_].cellId];
                  if(!_loc2_ || _loc2_.floor != _loc5_)
                  {
                     _loc3_ = false;
                     this._furniture.displayAsError();
                     break;
                  }
                  _loc3_ = DataMapProvider.getInstance().cellByIdIsHavenbagCell(_loc4_[_loc6_].cellId);
                  if(!_loc3_)
                  {
                     this._furniture.displayAsError();
                     break;
                  }
               }
               _loc6_++;
            }
         }
         this._cursorData.sprite.visible = !_loc3_;
         return _loc3_;
      }
      
      private function furnitureCellValidator(param1:int) : Boolean
      {
         var _loc5_:MapPoint = null;
         var _loc6_:Vector.<IFurniture> = null;
         var _loc7_:int = 0;
         this._furniture.position = MapPoint.fromCellId(param1);
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = true;
         var _loc4_:Vector.<MapPoint> = this._furniture.cells;
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = HavenbagFurnituresManager.getInstance().getFurnituresOnCellId(_loc5_.cellId);
            if(_loc6_)
            {
               if(_loc6_[this._furniture.layerId])
               {
                  if(_loc6_[this._furniture.layerId].position.cellId == param1)
                  {
                     if(this._furniture.typeId == _loc6_[this._furniture.layerId].typeId && this._furniture.orientation == _loc6_[this._furniture.layerId].orientation)
                     {
                        this._furniture.remove();
                        _loc2_ = true;
                        _loc3_ = false;
                        break;
                     }
                     if(this._furniture.cellsWidth <= _loc6_[this._furniture.layerId].cellsWidth && this._furniture.cellsHeight <= _loc6_[this._furniture.layerId].cellsHeight)
                     {
                        break;
                     }
                     continue;
                  }
                  _loc3_ = false;
                  break;
               }
               _loc7_ = 0;
               while(_loc7_ < this._furniture.layerId)
               {
                  if(_loc6_[_loc7_] && !_loc6_[_loc7_].isStackable)
                  {
                     _loc3_ = false;
                     _loc2_ = true;
                     break;
                  }
                  _loc7_++;
               }
               if(!_loc3_)
               {
                  break;
               }
            }
         }
         if(!_loc3_ && !_loc2_)
         {
            this._furniture.displayAsError();
         }
         if(this._draggedFurnitureCursorData)
         {
            this._draggedFurnitureCursorData.sprite.visible = false;
         }
         return _loc3_;
      }
   }
}
