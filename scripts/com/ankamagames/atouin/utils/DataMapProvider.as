package com.ankamagames.atouin.utils
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IObstacle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class DataMapProvider implements IDataMapProvider
   {
      
      private static const TOLERANCE_ELEVATION:int = 11;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DataMapProvider));
      
      private static var _self:DataMapProvider;
      
      private static var _playerClass:Class;
       
      
      public var isInFight:Boolean;
      
      public var obstaclesCells:Vector.<uint>;
      
      private var _updatedCell:Dictionary;
      
      private var _specialEffects:Dictionary;
      
      public function DataMapProvider()
      {
         this.obstaclesCells = new Vector.<uint>(0);
         this._updatedCell = new Dictionary();
         this._specialEffects = new Dictionary();
         super();
      }
      
      public static function getInstance() : DataMapProvider
      {
         if(!_self)
         {
            throw new SingletonError("Init function wasn\'t call");
         }
         return _self;
      }
      
      public static function init(param1:Class) : void
      {
         _playerClass = param1;
         if(!_self)
         {
            _self = new DataMapProvider();
         }
      }
      
      public function pointLos(param1:int, param2:int, param3:Boolean = true) : Boolean
      {
         var _loc6_:Array = null;
         var _loc7_:IObstacle = null;
         var _loc4_:uint = MapPoint.fromCoords(param1,param2).cellId;
         var _loc5_:Boolean = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc4_]).los;
         if(this._updatedCell[_loc4_] != null)
         {
            _loc5_ = this._updatedCell[_loc4_];
         }
         if(!param3)
         {
            _loc6_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc4_,IObstacle);
            if(_loc6_.length)
            {
               for each(_loc7_ in _loc6_)
               {
                  if(!IObstacle(_loc7_).canSeeThrough())
                  {
                     return false;
                  }
               }
            }
         }
         return _loc5_;
      }
      
      public function farmCell(param1:int, param2:int) : Boolean
      {
         var _loc3_:uint = MapPoint.fromCoords(param1,param2).cellId;
         return CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc3_]).farmCell;
      }
      
      public function cellByIdIsHavenbagCell(param1:int) : Boolean
      {
         return CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1]).havenbagCell;
      }
      
      public function cellByCoordsIsHavenbagCell(param1:int, param2:int) : Boolean
      {
         var _loc3_:uint = MapPoint.fromCoords(param1,param2).cellId;
         return CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc3_]).havenbagCell;
      }
      
      public function isChangeZone(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:CellData = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1]);
         var _loc4_:CellData = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param2]);
         var _loc5_:int = Math.abs(Math.abs(_loc3_.floor) - Math.abs(_loc4_.floor));
         if(_loc3_.moveZone != _loc4_.moveZone && _loc5_ == 0)
         {
            return true;
         }
         return false;
      }
      
      public function pointMov(param1:int, param2:int, param3:Boolean = true, param4:int = -1, param5:int = -1, param6:Boolean = true) : Boolean
      {
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:CellData = null;
         var _loc10_:Boolean = false;
         var _loc11_:CellData = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:IObstacle = null;
         if(MapPoint.isInMap(param1,param2))
         {
            _loc7_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.isUsingNewMovementSystem;
            _loc8_ = MapPoint.fromCoords(param1,param2).cellId;
            _loc9_ = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc8_]);
            _loc10_ = _loc9_.mov && (!this.isInFight || !_loc9_.nonWalkableDuringFight);
            if(this._updatedCell[_loc8_] != null)
            {
               _loc10_ = this._updatedCell[_loc8_];
            }
            if(_loc10_ && _loc7_ && param4 != -1 && param4 != _loc8_)
            {
               _loc11_ = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param4]);
               _loc12_ = Math.abs(Math.abs(_loc9_.floor) - Math.abs(_loc11_.floor));
               if(_loc11_.moveZone != _loc9_.moveZone && _loc12_ > 0 || _loc11_.moveZone == _loc9_.moveZone && _loc9_.moveZone == 0 && _loc12_ > TOLERANCE_ELEVATION)
               {
                  _loc10_ = false;
               }
            }
            if(!param3)
            {
               _loc13_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc8_,IObstacle);
               if(_loc13_.length)
               {
                  for each(_loc14_ in _loc13_)
                  {
                     if(!(param5 == _loc8_ && _loc14_.canWalkTo()))
                     {
                        if(!_loc14_.canWalkThrough())
                        {
                           return false;
                        }
                     }
                  }
               }
               else if(param6 && (this.obstaclesCells.indexOf(_loc8_) != -1 && _loc8_ != param5))
               {
                  return false;
               }
            }
         }
         else
         {
            _loc10_ = false;
         }
         return _loc10_;
      }
      
      public function pointCanStop(param1:int, param2:int, param3:Boolean = true) : Boolean
      {
         var _loc4_:uint = MapPoint.fromCoords(param1,param2).cellId;
         var _loc5_:CellData = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc4_]);
         return this.pointMov(param1,param2,param3) && (this.isInFight || !_loc5_.nonWalkableDuringRP);
      }
      
      public function pointWeight(param1:int, param2:int, param3:Boolean = true) : Number
      {
         var _loc6_:IEntity = null;
         var _loc4_:Number = 1;
         var _loc5_:int = this.getCellSpeed(MapPoint.fromCoords(param1,param2).cellId);
         if(param3)
         {
            if(_loc5_ >= 0)
            {
               _loc4_ = _loc4_ + (5 - _loc5_);
            }
            else
            {
               _loc4_ = _loc4_ + (11 + Math.abs(_loc5_));
            }
            _loc6_ = EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2),_playerClass);
            if(_loc6_ && !_loc6_["allowMovementThrough"])
            {
               _loc4_ = 20;
            }
         }
         else
         {
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2),_playerClass) != null)
            {
               _loc4_ = _loc4_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1 + 1,param2),_playerClass) != null)
            {
               _loc4_ = _loc4_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2 + 1),_playerClass) != null)
            {
               _loc4_ = _loc4_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1 - 1,param2),_playerClass) != null)
            {
               _loc4_ = _loc4_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2 - 1),_playerClass) != null)
            {
               _loc4_ = _loc4_ + 0.3;
            }
            if((this.pointSpecialEffects(param1,param2) & 2) == 2)
            {
               _loc4_ = _loc4_ + 0.2;
            }
         }
         return _loc4_;
      }
      
      public function getCellSpeed(param1:uint) : int
      {
         return (MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1] as CellData).speed;
      }
      
      public function pointSpecialEffects(param1:int, param2:int) : uint
      {
         var _loc3_:uint = MapPoint.fromCoords(param1,param2).cellId;
         if(this._specialEffects[_loc3_])
         {
            return this._specialEffects[_loc3_];
         }
         return 0;
      }
      
      public function get width() : int
      {
         return AtouinConstants.MAP_HEIGHT + AtouinConstants.MAP_WIDTH - 2;
      }
      
      public function get height() : int
      {
         return AtouinConstants.MAP_HEIGHT + AtouinConstants.MAP_WIDTH - 1;
      }
      
      public function hasEntity(param1:int, param2:int) : Boolean
      {
         var _loc4_:IObstacle = null;
         var _loc3_:Array = EntitiesManager.getInstance().getEntitiesOnCell(MapPoint.fromCoords(param1,param2).cellId,IObstacle);
         if(_loc3_.length)
         {
            for each(_loc4_ in _loc3_)
            {
               if(!IObstacle(_loc4_).canWalkTo())
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function updateCellMovLov(param1:uint, param2:Boolean) : void
      {
         this._updatedCell[param1] = param2;
      }
      
      public function resetUpdatedCell() : void
      {
         this._updatedCell = new Dictionary();
      }
      
      public function setSpecialEffects(param1:uint, param2:uint) : void
      {
         this._specialEffects[param1] = param2;
      }
      
      public function resetSpecialEffects() : void
      {
         this._specialEffects = new Dictionary();
      }
   }
}
