package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.ZoneTile;
   import com.ankamagames.atouin.utils.IFightZoneRenderer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import flash.utils.getQualifiedClassName;
   
   public class ZoneDARenderer implements IFightZoneRenderer
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ZoneDARenderer));
      
      private static var zoneTileCache:Array = new Array();
       
      
      protected var _cells:Vector.<uint>;
      
      protected var _aZoneTile:Array;
      
      protected var _aCellTile:Array;
      
      private var _alpha:Number = 0.7;
      
      protected var _fixedStrata:Boolean;
      
      protected var _strata:uint;
      
      private var _currentStrata:uint = 0;
      
      private var _showFarmCell:Boolean = true;
      
      public function ZoneDARenderer(param1:uint = 0, param2:Number = 1, param3:Boolean = false)
      {
         super();
         this._aZoneTile = new Array();
         this._aCellTile = new Array();
         this._strata = param1;
         this._fixedStrata = param3;
         this.currentStrata = !this._fixedStrata && Atouin.getInstance().options.transparentOverlayMode?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(this._strata);
         this._alpha = param2;
      }
      
      private static function getZoneTile() : ZoneTile
      {
         if(zoneTileCache.length)
         {
            return zoneTileCache.shift();
         }
         return new ZoneTile();
      }
      
      private static function destroyZoneTile(param1:ZoneTile) : void
      {
         param1.remove();
         zoneTileCache.push(param1);
      }
      
      public function get showFarmCell() : Boolean
      {
         return this._showFarmCell;
      }
      
      public function set showFarmCell(param1:Boolean) : void
      {
         this._showFarmCell = param1;
      }
      
      public function get currentStrata() : uint
      {
         return this._currentStrata;
      }
      
      public function set currentStrata(param1:uint) : void
      {
         this._currentStrata = param1;
      }
      
      public function render(param1:Vector.<uint>, param2:Color, param3:DataMapContainer, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:ZoneTile = null;
         var _loc9_:CellData = null;
         this._cells = param1;
         var _loc8_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc9_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1[_loc6_]];
            if(!(!this.showFarmCell && _loc9_.farmCell))
            {
               _loc7_ = this._aZoneTile[_loc6_];
               if(!_loc7_)
               {
                  _loc7_ = getZoneTile();
                  this._aZoneTile[_loc6_] = _loc7_;
                  _loc7_.strata = this.currentStrata;
               }
               this._aCellTile[_loc6_] = param1[_loc6_];
               _loc7_.cellId = param1[_loc6_];
               _loc7_.text = this.getText(_loc6_);
               _loc7_.color = param2;
               if(param5 || EntitiesDisplayManager.getInstance()._dStrataRef[_loc7_] != this.currentStrata)
               {
                  _loc7_.strata = EntitiesDisplayManager.getInstance()._dStrataRef[_loc7_] = this.currentStrata;
               }
               _loc7_.display();
               _loc7_.alpha = this._alpha;
            }
            _loc6_++;
         }
         while(_loc6_ < _loc8_)
         {
            _loc7_ = this._aZoneTile[_loc6_];
            if(_loc7_)
            {
               destroyZoneTile(_loc7_);
            }
            _loc6_++;
         }
      }
      
      protected function getText(param1:int) : String
      {
         return null;
      }
      
      public function remove(param1:Vector.<uint>, param2:DataMapContainer) : void
      {
         var _loc4_:int = 0;
         var _loc8_:ZoneTile = null;
         if(!param1)
         {
            return;
         }
         var _loc3_:int = 0;
         var _loc5_:Array = new Array();
         var _loc6_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc5_[param1[_loc4_]] = true;
            _loc4_++;
         }
         _loc6_ = this._aCellTile.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            if(_loc5_[this._aCellTile[_loc7_]])
            {
               _loc3_++;
               _loc8_ = this._aZoneTile[_loc7_];
               if(_loc8_)
               {
                  destroyZoneTile(_loc8_);
               }
               this._aCellTile.splice(_loc7_,1);
               this._aZoneTile.splice(_loc7_,1);
               _loc7_--;
               _loc6_--;
            }
            _loc7_++;
         }
      }
      
      public function get fixedStrata() : Boolean
      {
         return this._fixedStrata;
      }
      
      public function set fixedStrata(param1:Boolean) : void
      {
         this._fixedStrata = param1;
      }
      
      public function restoreStrata() : void
      {
         this.currentStrata = this._strata;
      }
   }
}
