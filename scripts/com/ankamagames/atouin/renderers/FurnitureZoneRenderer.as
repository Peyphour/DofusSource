package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.FurnitureZoneTile;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public class FurnitureZoneRenderer implements IZoneRenderer
   {
       
      
      private var _aZoneTile:Vector.<FurnitureZoneTile>;
      
      private var _aCellTile:Vector.<uint>;
      
      private var _visible:Boolean;
      
      public var strata:uint;
      
      public var height:int = 0;
      
      public function FurnitureZoneRenderer(param1:uint = 10, param2:Boolean = true)
      {
         super();
         this._aZoneTile = new Vector.<FurnitureZoneTile>();
         this._aCellTile = new Vector.<uint>();
         this._visible = param2;
         this.strata = param1;
      }
      
      public function render(param1:Vector.<uint>, param2:Color, param3:DataMapContainer, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc7_:FurnitureZoneTile = null;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:MapPoint = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:uint = 0;
         var _loc17_:GraphicCell = null;
         var _loc18_:GraphicCell = null;
         var _loc19_:Point = null;
         var _loc20_:MapPoint = null;
         this._aZoneTile.length = param1.length;
         this._aCellTile.length = param1.length;
         var _loc6_:int = -1;
         if(this.strata == PlacementStrataEnums.STRATA_FURNITURE_ITEM - 1 && param1.length > 1)
         {
            for each(_loc9_ in param1)
            {
               if(_loc9_ > _loc6_)
               {
                  _loc6_ = _loc9_;
               }
            }
         }
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            if(!this._aZoneTile[_loc8_])
            {
               this._aZoneTile[_loc8_] = _loc7_ = new FurnitureZoneTile();
               _loc7_.strata = this.strata;
               _loc7_.visible = this._visible;
               _loc7_.filters = [new ColorMatrixFilter([0,0,0,0,param2.red,0,0,0,0,param2.green,0,0,0,0,param2.blue,0,0,0,0.7,0])];
            }
            this._aCellTile[_loc8_] = param1[_loc8_];
            _loc10_ = param1[_loc8_];
            _loc11_ = MapPoint.fromCellId(_loc10_);
            this._aZoneTile[_loc8_].cellId = _loc10_;
            this._aZoneTile[_loc8_].needFill = this.height != 0;
            if(_loc6_ != -1)
            {
               this._aZoneTile[_loc8_].cellId = _loc6_;
               if(_loc10_ != _loc6_)
               {
                  _loc17_ = InteractiveCellManager.getInstance().getCell(_loc10_);
                  _loc18_ = InteractiveCellManager.getInstance().getCell(_loc6_);
                  _loc19_ = new Point(_loc18_.x - _loc17_.x,_loc18_.y - _loc17_.y);
                  this._aZoneTile[_loc8_].offset = _loc19_;
               }
            }
            _loc12_ = false;
            _loc13_ = false;
            _loc14_ = false;
            _loc15_ = false;
            for each(_loc16_ in param1)
            {
               if(_loc16_ != _loc10_)
               {
                  _loc20_ = MapPoint.fromCellId(_loc16_);
                  if(_loc20_.x == _loc11_.x)
                  {
                     if(_loc20_.y == _loc11_.y - 1)
                     {
                        _loc12_ = true;
                     }
                     else if(_loc20_.y == _loc11_.y + 1)
                     {
                        _loc13_ = true;
                     }
                  }
                  else if(_loc20_.y == _loc11_.y)
                  {
                     if(_loc20_.x == _loc11_.x - 1)
                     {
                        _loc14_ = true;
                     }
                     else if(_loc20_.x == _loc11_.x + 1)
                     {
                        _loc15_ = true;
                     }
                  }
               }
            }
            this._aZoneTile[_loc8_].draw(_loc12_,_loc14_,_loc13_,_loc15_,this.height);
            this._aZoneTile[_loc8_].display(this.strata);
            if(_loc6_ != -1)
            {
               this._aZoneTile[_loc8_].cellId = _loc10_;
            }
            _loc8_++;
         }
         while(_loc8_ < this._aZoneTile.length)
         {
            if(this._aZoneTile[_loc8_])
            {
               this._aZoneTile[_loc8_].remove();
            }
            _loc8_++;
         }
      }
      
      public function remove(param1:Vector.<uint>, param2:DataMapContainer) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_[param1[_loc4_]] = true;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this._aCellTile.length)
         {
            if(_loc3_[this._aCellTile[_loc4_]])
            {
               if(this._aZoneTile[_loc4_])
               {
                  this._aZoneTile[_loc4_].remove();
               }
               delete this._aZoneTile[_loc4_];
               delete this._aCellTile[_loc4_];
            }
            _loc4_++;
         }
      }
   }
}
