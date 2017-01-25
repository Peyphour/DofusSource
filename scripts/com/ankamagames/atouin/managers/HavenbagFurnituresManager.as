package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.enums.HavenbagLayersEnum;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.renderers.FurnitureZoneRenderer;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.IFurniture;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.types.miscs.HavenbagPackedInfos;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class HavenbagFurnituresManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HavenbagFurnituresManager));
      
      public static const SELECTION_FURNITURE:String = "furnitureZoneSelection";
      
      private static var _self:HavenbagFurnituresManager;
       
      
      private var _furnituresById:Dictionary;
      
      private var _furnituresByCellId:Dictionary;
      
      private var _furnituresOnPreviewedCells:Array;
      
      private var _previewedFurniture:IFurniture;
      
      private var _walkableSupportYOffsetByCellId:Dictionary;
      
      public function HavenbagFurnituresManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : HavenbagFurnituresManager is a singleton class and shoulnd\'t be instancied directly!");
         }
         this._furnituresById = new Dictionary();
         this._furnituresByCellId = new Dictionary();
         this._walkableSupportYOffsetByCellId = new Dictionary();
         this._furnituresOnPreviewedCells = new Array();
      }
      
      public static function getInstance() : HavenbagFurnituresManager
      {
         if(!_self)
         {
            _self = new HavenbagFurnituresManager();
         }
         return _self;
      }
      
      public function addFurniture(param1:IFurniture) : void
      {
         var _loc2_:GraphicCell = null;
         var _loc3_:MapPoint = null;
         var _loc4_:int = 0;
         if(!DataMapProvider.getInstance().cellByIdIsHavenbagCell(param1.position.cellId))
         {
            return;
         }
         this._previewedFurniture = null;
         this._furnituresOnPreviewedCells.length = 0;
         this._furnituresById[param1.id] = param1;
         for each(_loc3_ in param1.cells)
         {
            if(this._furnituresByCellId[_loc3_.cellId] == null)
            {
               this._furnituresByCellId[_loc3_.cellId] = new Vector.<IFurniture>(3,true);
            }
            else
            {
               if(this._furnituresByCellId[_loc3_.cellId][param1.layerId])
               {
                  this.removeFurniture(this._furnituresByCellId[_loc3_.cellId][param1.layerId].id);
               }
               _loc4_ = param1.layerId;
               while(_loc4_ < this._furnituresByCellId[_loc3_.cellId].length)
               {
                  if(this._furnituresByCellId[_loc3_.cellId][_loc4_])
                  {
                     if(!param1.isStackable)
                     {
                        this.removeFurniture(this._furnituresByCellId[_loc3_.cellId][_loc4_].id);
                     }
                     else if(param1.layerId == HavenbagLayersEnum.SUPPORT && this._furnituresByCellId[_loc3_.cellId][_loc4_].layerId == HavenbagLayersEnum.OBJECT)
                     {
                        this.displayFurniture(this._furnituresByCellId[_loc3_.cellId][_loc4_],Vector.<IFurniture>([null,param1,this._furnituresByCellId[_loc3_.cellId][_loc4_]]));
                     }
                  }
                  _loc4_++;
               }
            }
            _loc2_ = InteractiveCellManager.getInstance().getCell(_loc3_.cellId);
            if(_loc2_ && (param1.canWalkTo() || param1.canWalkThrough()) && param1.elementHeight > 0)
            {
               this._walkableSupportYOffsetByCellId[_loc3_.cellId] = param1.elementHeight;
               InteractiveCellManager.getInstance().updateCellElevation(_loc3_.cellId,param1.elementHeight);
            }
            this._furnituresByCellId[_loc3_.cellId][param1.layerId] = param1;
            this.updateFurnituresY(_loc3_.cellId);
         }
         this.displayFurniture(param1);
      }
      
      public function removeFurniture(param1:Number) : void
      {
         var _loc3_:GraphicCell = null;
         var _loc4_:MapPoint = null;
         var _loc5_:Boolean = false;
         var _loc6_:IFurniture = null;
         var _loc2_:IFurniture = this._furnituresById[param1];
         if(!_loc2_)
         {
            _log.error("Failed to remove furniture with id " + param1 + ", wasn\'t found furnitures list");
            return;
         }
         delete this._furnituresById[_loc2_.id];
         for each(_loc4_ in _loc2_.cells)
         {
            this._furnituresByCellId[_loc4_.cellId][_loc2_.layerId] = null;
            _loc5_ = true;
            for each(_loc6_ in this._furnituresByCellId[_loc4_.cellId])
            {
               if(_loc6_)
               {
                  _loc5_ = false;
                  break;
               }
            }
            if(_loc5_)
            {
               InteractiveCellManager.getInstance().updateCell(_loc4_.cellId,true);
            }
            this.updateFurnituresY(_loc4_.cellId);
            _loc3_ = InteractiveCellManager.getInstance().getCell(_loc4_.cellId);
            if(_loc3_ && (_loc2_.canWalkTo() || _loc2_.canWalkThrough()) && _loc2_.elementHeight > 0 && _loc3_.y < _loc3_.initialElevation)
            {
               InteractiveCellManager.getInstance().updateCellElevation(_loc4_.cellId,0);
               this._walkableSupportYOffsetByCellId[_loc4_.cellId] = 0;
            }
         }
         _loc2_.destroy();
      }
      
      public function removeFurnituresOnCell(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this._furnituresByCellId[param1])
         {
            _loc2_ = 0;
            while(_loc2_ < this._furnituresByCellId[param1].length)
            {
               if(this._furnituresByCellId[param1][_loc2_])
               {
                  this.removeFurniture(this._furnituresByCellId[param1][_loc2_].id);
               }
               _loc2_++;
            }
         }
      }
      
      public function removeAllFurnitures() : void
      {
         var _loc1_:GraphicCell = null;
         var _loc2_:IFurniture = null;
         for each(_loc2_ in this._furnituresById)
         {
            _loc1_ = InteractiveCellManager.getInstance().getCell(_loc2_.position.cellId);
            if(_loc1_ && (_loc2_.canWalkTo() || _loc2_.canWalkThrough()) && _loc2_.elementHeight > 0 && _loc1_.y < _loc1_.initialElevation)
            {
               InteractiveCellManager.getInstance().updateCellElevation(_loc2_.position.cellId,0);
            }
            _loc2_.destroy();
         }
         this._furnituresById = new Dictionary();
         this._furnituresByCellId = new Dictionary();
         this._walkableSupportYOffsetByCellId = new Dictionary();
      }
      
      public function previewFurniture(param1:IFurniture) : void
      {
         var _loc3_:MapPoint = null;
         var _loc4_:IFurniture = null;
         var _loc5_:int = 0;
         var _loc6_:MapPoint = null;
         var _loc7_:IFurniture = null;
         var _loc8_:Vector.<MapPoint> = null;
         var _loc10_:Vector.<MapPoint> = null;
         var _loc11_:IFurniture = null;
         var _loc12_:int = 0;
         this._previewedFurniture = param1;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in this._previewedFurniture.cells)
         {
            _loc2_[_loc3_.cellId] = _loc3_;
         }
         if(this._furnituresByCellId[this._previewedFurniture.position.cellId] && this._furnituresByCellId[this._previewedFurniture.position.cellId][this._previewedFurniture.layerId])
         {
            _loc10_ = this._furnituresByCellId[this._previewedFurniture.position.cellId][this._previewedFurniture.layerId].cells;
            for each(_loc3_ in _loc10_)
            {
               _loc2_[_loc3_.cellId] = _loc3_;
            }
         }
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = _loc3_.cellId;
            if(this._furnituresByCellId[_loc5_])
            {
               _loc12_ = 0;
               while(_loc12_ < this._furnituresByCellId[_loc5_].length)
               {
                  if(this._furnituresByCellId[_loc5_][_loc12_] && (this._furnituresByCellId[_loc5_][_loc12_].cells.length == 1 || this._previewedFurniture.position.cellId == this._furnituresByCellId[_loc5_][_loc12_].position.cellId))
                  {
                     this._furnituresByCellId[_loc5_][_loc12_].remove();
                  }
                  if(_loc12_ == HavenbagLayersEnum.SUPPORT && this._previewedFurniture.layerId == HavenbagLayersEnum.OBJECT)
                  {
                     _loc7_ = this._furnituresByCellId[_loc5_][_loc12_];
                  }
                  _loc12_++;
               }
            }
            this._furnituresOnPreviewedCells[_loc5_] = new Vector.<IFurniture>(3,true);
            _loc12_ = 0;
            while(_loc12_ < this._furnituresOnPreviewedCells[_loc5_].length)
            {
               _loc11_ = null;
               if(_loc12_ == this._previewedFurniture.layerId && this.isFurnitureOnCellId(this._previewedFurniture,_loc5_))
               {
                  _loc11_ = this._previewedFurniture;
               }
               else if(_loc12_ != this._previewedFurniture.layerId && (this._furnituresByCellId[_loc5_] && this._furnituresByCellId[_loc5_][_loc12_]))
               {
                  _loc11_ = this._furnituresByCellId[_loc5_][_loc12_];
               }
               if(_loc12_ <= this._previewedFurniture.layerId)
               {
                  this._furnituresOnPreviewedCells[_loc5_][_loc12_] = _loc11_;
               }
               else if(!this._furnituresOnPreviewedCells[_loc5_][_loc12_ - 1] || this._furnituresOnPreviewedCells[_loc5_][_loc12_ - 1].isStackable)
               {
                  this._furnituresOnPreviewedCells[_loc5_][_loc12_] = _loc11_;
               }
               _loc12_++;
            }
            _loc12_ = 0;
            while(_loc12_ < this._furnituresOnPreviewedCells[_loc5_].length)
            {
               if(this._furnituresOnPreviewedCells[_loc5_][_loc12_] && (this._furnituresOnPreviewedCells[_loc5_][_loc12_].cells.length == 1 || this._previewedFurniture.position.cellId == this._furnituresOnPreviewedCells[_loc5_][_loc12_].position.cellId))
               {
                  this.displayFurniture(this._furnituresOnPreviewedCells[_loc5_][_loc12_],this._furnituresOnPreviewedCells[_loc5_]);
               }
               _loc12_++;
            }
            this.updateFurnituresY(_loc5_,this._furnituresOnPreviewedCells[_loc5_]);
         }
         _loc8_ = !!_loc7_?_loc7_.cells:this._previewedFurniture.cells;
         var _loc9_:uint = !!_loc7_?uint(_loc7_.elementHeight):uint(0);
         this.displayPreviewSelection(_loc8_,_loc9_);
      }
      
      public function cancelPreviewFurniture(param1:IFurniture) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Selection = SelectionManager.getInstance().getSelection(SELECTION_FURNITURE);
         if(_loc2_)
         {
            _loc2_.remove();
         }
         if(!this._furnituresOnPreviewedCells.length)
         {
            return;
         }
         for(_loc3_ in this._furnituresOnPreviewedCells)
         {
            _loc4_ = parseInt(_loc3_);
            if(this._furnituresOnPreviewedCells[_loc4_])
            {
               _loc5_ = 0;
               while(_loc5_ < this._furnituresOnPreviewedCells[_loc4_].length)
               {
                  if(this._furnituresOnPreviewedCells[_loc4_][_loc5_] && (this._furnituresOnPreviewedCells[_loc4_][_loc5_].cells.length == 1 || this._previewedFurniture.position.cellId == this._furnituresOnPreviewedCells[_loc4_][_loc5_].position.cellId))
                  {
                     this._furnituresOnPreviewedCells[_loc4_][_loc5_].remove();
                  }
                  _loc5_++;
               }
               if(this._furnituresByCellId[_loc4_])
               {
                  _loc5_ = 0;
                  while(_loc5_ < this._furnituresByCellId[_loc4_].length)
                  {
                     if(this._furnituresByCellId[_loc4_][_loc5_] && (this._furnituresByCellId[_loc4_][_loc5_].cells.length == 1 || this._previewedFurniture.position.cellId == this._furnituresByCellId[_loc4_][_loc5_].position.cellId))
                     {
                        this.displayFurniture(this._furnituresByCellId[_loc4_][_loc5_]);
                     }
                     _loc5_++;
                  }
               }
               this.updateFurnituresY(_loc4_);
            }
         }
         this._previewedFurniture = null;
         this._furnituresOnPreviewedCells.length = 0;
      }
      
      public function getFurnituresOnCellId(param1:int) : Vector.<IFurniture>
      {
         return this._furnituresByCellId[param1];
      }
      
      public function getFurnitureById(param1:Number) : IFurniture
      {
         return this._furnituresById[param1];
      }
      
      public function enableMouseEvents() : void
      {
         var _loc1_:IFurniture = null;
         var _loc2_:MapPoint = null;
         for each(_loc1_ in this._furnituresById)
         {
            _loc1_.addEventListeners();
            for each(_loc2_ in _loc1_.cells)
            {
               InteractiveCellManager.getInstance().updateCell(_loc2_.cellId,false);
            }
         }
      }
      
      public function disableMouseEvents() : void
      {
         var _loc1_:IFurniture = null;
         for each(_loc1_ in this._furnituresById)
         {
            _loc1_.removeEventListeners();
         }
      }
      
      public function allowMovOnFurnitureCells() : void
      {
         var _loc1_:* = undefined;
         DataMapProvider.getInstance().resetUpdatedCell();
         for(_loc1_ in this._furnituresByCellId)
         {
            DataMapProvider.getInstance().updateCellMovLov(_loc1_,true);
         }
      }
      
      public function updateMovOnFurnitureCells() : void
      {
         var _loc1_:Vector.<IFurniture> = null;
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         DataMapProvider.getInstance().resetUpdatedCell();
         InteractiveCellManager.getInstance().resetHavenbagCellsVisibility();
         for(_loc3_ in this._furnituresByCellId)
         {
            _loc1_ = this._furnituresByCellId[_loc3_];
            _loc2_ = true;
            _loc4_ = 0;
            while(_loc4_ < _loc1_.length)
            {
               if(_loc1_[_loc4_] && _loc1_[_loc4_].canWalkThrough() == false)
               {
                  _loc2_ = false;
                  break;
               }
               _loc4_++;
            }
            InteractiveCellManager.getInstance().updateCell(_loc3_,_loc2_);
         }
      }
      
      public function restore(param1:Vector.<IFurniture> = null) : void
      {
         var _loc3_:IFurniture = null;
         var _loc2_:* = !!param1?param1:this._furnituresById;
         for each(_loc3_ in _loc2_)
         {
            this.addFurniture(_loc3_);
         }
         this.enableMouseEvents();
         this.updateMovOnFurnitureCells();
      }
      
      public function pack() : HavenbagPackedInfos
      {
         var _loc2_:IFurniture = null;
         var _loc1_:HavenbagPackedInfos = new HavenbagPackedInfos();
         for each(_loc2_ in this._furnituresById)
         {
            _loc1_.furnitureTypeIds.push(_loc2_.typeId);
            _loc1_.furnitureCellIds.push(_loc2_.position.cellId);
            _loc1_.furnitureOrientations.push(_loc2_.orientation);
         }
         return _loc1_;
      }
      
      public function sortFloorFurnitures(param1:DisplayObject, param2:Sprite) : void
      {
         var f:IEntity = null;
         var cellId:* = undefined;
         var index:int = 0;
         var entity:DisplayObject = param1;
         var cellSprite:Sprite = param2;
         var floorFurnitureCells:Vector.<IEntity> = new Vector.<IEntity>();
         for(cellId in this._furnituresByCellId)
         {
            f = this._furnituresByCellId[cellId][HavenbagLayersEnum.FLOOR] as IEntity;
            if(f)
            {
               floorFurnitureCells.push(f);
            }
         }
         index = floorFurnitureCells.indexOf(entity as IEntity);
         if(index == -1)
         {
            floorFurnitureCells.push(entity as IEntity);
         }
         floorFurnitureCells.sort(function compare(param1:IEntity, param2:IEntity):Number
         {
            if(param1.position.cellId < param2.position.cellId)
            {
               return -1;
            }
            if(param1.position.cellId > param2.position.cellId)
            {
               return 1;
            }
            return 0;
         });
         index = floorFurnitureCells.indexOf(entity as IEntity);
         cellSprite.parent.addChildAt(entity,index);
         if((cellSprite as GraphicCell).initialElevation > 0)
         {
            entity.y = entity.y - (cellSprite.y - (cellSprite as GraphicCell).initialElevation);
         }
      }
      
      private function displayFurniture(param1:IFurniture, param2:Vector.<IFurniture> = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MapPoint = null;
         var _loc8_:MapPoint = null;
         var _loc3_:int = param1.position.cellId;
         var _loc4_:Vector.<IFurniture> = param2 == null?this._furnituresByCellId[_loc3_]:param2;
         if(param1.layerId == HavenbagLayersEnum.OBJECT && _loc4_ && _loc4_[HavenbagLayersEnum.SUPPORT] && _loc4_[HavenbagLayersEnum.SUPPORT].cells.length > 1)
         {
            _loc5_ = AtouinConstants.MAP_CELLS_COUNT + 1;
            _loc6_ = -1;
            for each(_loc7_ in _loc4_[HavenbagLayersEnum.SUPPORT].cells)
            {
               if(_loc7_.cellId > _loc6_)
               {
                  _loc6_ = _loc7_.cellId;
               }
               if(_loc7_.cellId < _loc5_)
               {
                  _loc5_ = _loc7_.cellId;
               }
            }
            if(_loc3_ != _loc6_)
            {
               _loc8_ = MapPoint.fromCellId(_loc3_);
               param1.position = MapPoint.fromCellId(_loc6_);
               param1.remove();
               param1.display(PlacementStrataEnums.STRATA_FURNITURE_ITEM + (_loc3_ - _loc5_));
               param1.offsetPosition = _loc8_;
            }
            else
            {
               param1.offsetPosition = param1.position;
               param1.display(PlacementStrataEnums.STRATA_FURNITURE_ITEM + (_loc3_ - _loc5_));
            }
         }
         else
         {
            param1.offsetPosition = param1.position;
            param1.display();
         }
      }
      
      private function displayPreviewSelection(param1:Vector.<MapPoint>, param2:uint) : void
      {
         var _loc4_:MapPoint = null;
         var _loc5_:Selection = null;
         var _loc3_:Vector.<uint> = new Vector.<uint>();
         for each(_loc4_ in param1)
         {
            _loc3_.push(_loc4_.cellId);
         }
         _loc5_ = SelectionManager.getInstance().getSelection(SELECTION_FURNITURE);
         if(!_loc5_)
         {
            _loc5_ = new Selection();
            _loc5_.color = new Color(15395562);
            _loc5_.renderer = new FurnitureZoneRenderer(this._previewedFurniture.strata - 1);
            _loc5_.zone = new Custom(_loc3_);
            (_loc5_.renderer as FurnitureZoneRenderer).height = param2;
            SelectionManager.getInstance().addSelection(_loc5_,SELECTION_FURNITURE);
         }
         else
         {
            _loc5_.zone = new Custom(_loc3_);
            (_loc5_.renderer as FurnitureZoneRenderer).strata = this._previewedFurniture.strata - 1;
            (_loc5_.renderer as FurnitureZoneRenderer).height = param2;
            SelectionManager.getInstance().update(SELECTION_FURNITURE);
         }
      }
      
      private function isFurnitureOnCellId(param1:IFurniture, param2:int) : Boolean
      {
         var _loc3_:Vector.<MapPoint> = param1.cells;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].cellId == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function updateFurnituresY(param1:int, param2:Vector.<IFurniture> = null) : void
      {
         var _loc3_:Vector.<IFurniture> = param2 == null?this._furnituresByCellId[param1]:param2;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = 0;
         if(this._walkableSupportYOffsetByCellId[param1])
         {
            _loc4_ = this._walkableSupportYOffsetByCellId[param1];
         }
         if(_loc4_ == 0)
         {
            if(_loc3_[HavenbagLayersEnum.FLOOR])
            {
               _loc3_[HavenbagLayersEnum.FLOOR].updateContentY(0,param1);
            }
            if(_loc3_[HavenbagLayersEnum.SUPPORT])
            {
               _loc3_[HavenbagLayersEnum.SUPPORT].updateContentY(0);
            }
            if(_loc3_[HavenbagLayersEnum.OBJECT])
            {
               if(_loc3_[HavenbagLayersEnum.SUPPORT])
               {
                  _loc3_[HavenbagLayersEnum.OBJECT].updateContentY(_loc3_[HavenbagLayersEnum.SUPPORT].elementHeight);
               }
               else
               {
                  _loc3_[HavenbagLayersEnum.OBJECT].updateContentY();
               }
            }
         }
         else
         {
            if(_loc3_[HavenbagLayersEnum.SUPPORT])
            {
               _loc3_[HavenbagLayersEnum.SUPPORT].updateContentY(-_loc4_);
            }
            if(_loc3_[HavenbagLayersEnum.OBJECT])
            {
               if(_loc3_[HavenbagLayersEnum.SUPPORT])
               {
                  _loc3_[HavenbagLayersEnum.OBJECT].updateContentY(_loc3_[HavenbagLayersEnum.SUPPORT].elementHeight - _loc4_);
               }
               else
               {
                  _loc3_[HavenbagLayersEnum.OBJECT].updateContentY(-_loc4_);
               }
            }
         }
      }
   }
}
