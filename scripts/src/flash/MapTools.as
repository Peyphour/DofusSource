package src.flash
{
   import flash.geom.Point;
   import haxe.ds.GenericCell_Int;
   import haxe.ds.GenericStack_Int;
   
   public class MapTools
   {
      
      public static var _MAX_X:int = 34;
      
      public static var _MAX_Y:int = 14;
      
      public static var _Y_SHIFT:int = 19;
      
      public static var _X_AXIS:int = 0;
      
      public static var _Y_AXIS:int = 1;
      
      public static var _Z_AXIS:int = 2;
      
      public static var _cached:Boolean = false;
      
      public static var _WIDTH:int = 14;
      
      public static var _DOUBLE_WIDTH:int = MapTools._WIDTH * 2;
      
      public static var _HEIGHT:int = 20;
      
      public static var _CELLCOUNT:int = MapTools._WIDTH * MapTools._HEIGHT * 2;
      
      public static var _INVALID_CELLNUM:int = -1;
      
      public static var _CELLS_ON_LOS_ARRAY:Array = [];
      
      public static var _EMPTY_CELLS_ON_LOS_ARRAY:Array = [];
      
      public static var _CELLPOS:Array = _loc1_;
      
      public static var _POSCELL:Array = _loc1_;
       
      
      public function MapTools()
      {
      }
      
      public static function _getCellNumFromXYCoordinates(param1:int, param2:int) : int
      {
         if(param1 < 0 || param1 >= MapTools._MAX_X || param2 + MapTools._Y_SHIFT < 0 || param2 >= MapTools._MAX_Y)
         {
            return MapTools._INVALID_CELLNUM;
         }
         return int(MapTools._POSCELL[param1][MapTools._Y_SHIFT + param2]);
      }
      
      public static function _getCellNumFromArrayCoordinates(param1:Array) : int
      {
         if(param1 == null)
         {
            return MapTools._INVALID_CELLNUM;
         }
         return int(MapTools._getCellNumFromXYCoordinates(int(param1[0]),int(param1[1])));
      }
      
      public static function _cacheCellsOnLOSData() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = MapTools._CELLCOUNT;
         while(_loc1_ < _loc2_)
         {
            _loc1_++;
            _loc3_ = _loc1_;
            MapTools._CELLS_ON_LOS_ARRAY[_loc3_] = [];
            _loc4_ = 0;
            _loc5_ = MapTools._CELLCOUNT;
            while(_loc4_ < _loc5_)
            {
               _loc4_++;
               _loc6_ = _loc4_;
               MapTools._CELLS_ON_LOS_ARRAY[_loc3_][_loc6_] = MapTools._EMPTY_CELLS_ON_LOS_ARRAY;
            }
         }
         _loc1_ = 0;
         _loc2_ = MapTools._CELLCOUNT;
         while(_loc1_ < _loc2_)
         {
            _loc1_++;
            _loc3_ = _loc1_;
            _loc4_ = 0;
            _loc5_ = MapTools._CELLCOUNT;
            while(_loc4_ < _loc5_)
            {
               _loc4_++;
               _loc6_ = _loc4_;
               MapTools._CELLS_ON_LOS_ARRAY[_loc3_][_loc6_] = MapTools._listToArray(MapTools._createCellsListForCells(_loc3_,_loc6_));
            }
            MapTools._CELLS_ON_LOS_ARRAY[_loc3_][_loc3_] = MapTools._EMPTY_CELLS_ON_LOS_ARRAY;
         }
         MapTools._cached = true;
      }
      
      public static function _listToArray(param1:GenericStack_Int) : Array
      {
         var _loc5_:int = 0;
         if(param1 == null)
         {
            return [];
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:GenericCell_Int = param1.head;
         while(_loc4_ != null)
         {
            _loc5_ = _loc4_.elt;
            _loc4_ = _loc4_.next;
            _loc3_++;
            _loc2_[_loc3_] = _loc5_;
         }
         return _loc2_;
      }
      
      public static function _createCellsListForCells(param1:int, param2:int) : GenericStack_Int
      {
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:* = null as Array;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 1;
         var _loc5_:GenericStack_Int = new GenericStack_Int();
         if(param1 == param2)
         {
            return _loc5_;
         }
         var _loc6_:Array = MapTools._getCoordinatesByRef(param1);
         var _loc7_:Array = MapTools._getCoordinatesByRef(param2);
         if(_loc6_ == null || _loc7_ == null)
         {
            return _loc5_;
         }
         var _loc8_:Array = [];
         _loc8_[_loc3_] = Number(int(_loc6_[MapTools._X_AXIS]) + 0.5);
         _loc8_[_loc4_] = Number(int(_loc6_[MapTools._Y_AXIS]) + 0.5);
         var _loc9_:Array = [];
         _loc9_[_loc3_] = Number(int(_loc7_[MapTools._X_AXIS]) + 0.5);
         _loc9_[_loc4_] = Number(int(_loc7_[MapTools._Y_AXIS]) + 0.5);
         var _loc10_:Array = [];
         _loc10_[_loc3_] = 0;
         _loc10_[_loc4_] = 0;
         var _loc11_:int = 0;
         if(Number(Math.abs(_loc8_[_loc3_] - _loc9_[_loc3_])) == Number(Math.abs(_loc8_[_loc4_] - _loc9_[_loc4_])))
         {
            §§push(Number(Math.abs(_loc8_[_loc3_] - _loc9_[_loc3_])));
            if(!(Number(Math.abs(_loc8_[_loc3_] - _loc9_[_loc3_])) is int))
            {
               throw "Class cast error";
            }
            _loc11_ = §§pop();
            _loc10_[_loc3_] = Number(_loc9_[_loc3_]) > Number(_loc8_[_loc3_])?Number(1):Number(-1);
            _loc10_[_loc4_] = Number(_loc9_[_loc4_]) > Number(_loc8_[_loc4_])?Number(1):Number(-1);
            _loc12_ = 0;
            while(_loc12_ < _loc11_)
            {
               _loc12_++;
               _loc13_ = _loc12_;
               _loc14_ = MapTools._getCellNumFromXYCoordinates(int(Math.floor(Number(Number(_loc8_[_loc3_]) + Number(_loc10_[_loc3_])))),int(Math.floor(Number(Number(_loc8_[_loc4_]) + Number(_loc10_[_loc4_])))));
               _loc5_.head = new GenericCell_Int(_loc14_,_loc5_.head);
               _loc8_[_loc3_] = Number(Number(_loc8_[_loc3_]) + Number(_loc10_[_loc3_]));
               _loc8_[_loc4_] = Number(Number(_loc8_[_loc4_]) + Number(_loc10_[_loc4_]));
            }
         }
         else
         {
            _loc12_ = _loc4_;
            _loc13_ = _loc3_;
            if(Number(Math.abs(_loc8_[_loc3_] - _loc9_[_loc3_])) > Number(Math.abs(_loc8_[_loc4_] - _loc9_[_loc4_])))
            {
               _loc12_ = _loc3_;
               _loc13_ = _loc4_;
            }
            §§push(Number(Math.abs(_loc8_[_loc12_] - _loc9_[_loc12_])));
            if(!(Number(Math.abs(_loc8_[_loc12_] - _loc9_[_loc12_])) is int))
            {
               throw "Class cast error";
            }
            _loc11_ = §§pop();
            _loc10_[_loc12_] = Number(_loc9_[_loc12_]) >= Number(_loc8_[_loc12_])?Number(1):Number(-1);
            _loc10_[_loc13_] = Number(_loc9_[_loc13_]) > Number(_loc8_[_loc13_])?Math.abs(_loc8_[_loc13_] - _loc9_[_loc13_]) / _loc11_:-Math.abs(_loc8_[_loc13_] - _loc9_[_loc13_]) / _loc11_;
            _loc14_ = 0;
            while(_loc14_ < _loc11_)
            {
               _loc14_++;
               _loc15_ = _loc14_;
               _loc16_ = [];
               _loc17_ = int(Math.round(Number(_loc8_[_loc13_] * 10000 + _loc10_[_loc13_] * 5000))) / 10000;
               _loc18_ = int(Math.round(Number(_loc8_[_loc13_] * 10000 + _loc10_[_loc13_] * 15000))) / 10000;
               if(int(Math.floor(_loc17_)) == int(Math.floor(_loc18_)))
               {
                  _loc16_[0] = int(Math.floor(Number(Number(_loc8_[_loc13_]) + Number(_loc10_[_loc13_]))));
                  if(_loc17_ == int(_loc16_[0]) && _loc18_ < int(_loc16_[0]))
                  {
                     _loc16_[0] = int(Math.ceil(Number(Number(_loc8_[_loc13_]) + Number(_loc10_[_loc13_]))));
                  }
                  if(_loc18_ == int(_loc16_[0]) && _loc17_ < int(_loc16_[0]))
                  {
                     _loc16_[0] = int(Math.ceil(Number(Number(_loc8_[_loc13_]) + Number(_loc10_[_loc13_]))));
                  }
               }
               else if(int(Math.ceil(_loc17_)) == int(Math.ceil(_loc18_)))
               {
                  _loc16_[0] = int(Math.ceil(Number(Number(_loc8_[_loc13_]) + Number(_loc10_[_loc13_]))));
                  if(_loc17_ == int(_loc16_[0]) && _loc18_ < int(_loc16_[0]))
                  {
                     _loc16_[0] = int(Math.floor(Number(Number(_loc8_[_loc13_]) + Number(_loc10_[_loc13_]))));
                  }
                  if(_loc18_ == int(_loc16_[0]) && _loc17_ < int(_loc16_[0]))
                  {
                     _loc16_[0] = int(Math.floor(Number(Number(_loc8_[_loc13_]) + Number(_loc10_[_loc13_]))));
                  }
               }
               else
               {
                  _loc16_[0] = int(Math.floor(_loc17_));
                  _loc16_[1] = int(Math.floor(_loc18_));
               }
               _loc19_ = 0;
               while(_loc19_ < int(_loc16_.length))
               {
                  _loc20_ = _loc16_[_loc19_];
                  _loc19_++;
                  if(_loc12_ == _loc3_)
                  {
                     _loc21_ = MapTools._getCellNumFromXYCoordinates(int(Math.floor(Number(Number(_loc8_[_loc3_]) + Number(_loc10_[_loc3_])))),_loc20_);
                  }
                  else
                  {
                     _loc21_ = MapTools._getCellNumFromXYCoordinates(_loc20_,int(Math.floor(Number(Number(_loc8_[_loc4_]) + Number(_loc10_[_loc4_])))));
                  }
                  _loc5_.head = new GenericCell_Int(_loc21_,_loc5_.head);
               }
               _loc8_[_loc3_] = Number(Number(_loc8_[_loc3_]) + Number(_loc10_[_loc3_]));
               _loc8_[_loc4_] = Number(Number(_loc8_[_loc4_]) + Number(_loc10_[_loc4_]));
            }
         }
         return _loc5_;
      }
      
      public static function _getCoordinatesByRef(param1:int) : Array
      {
         if(!MapTools._isCellNumValid(param1))
         {
            return null;
         }
         return MapTools._getCoordinatesByRefUnsafe(param1);
      }
      
      public static function _isCellNumValid(param1:int) : Boolean
      {
         return param1 >= 0 && param1 < MapTools._CELLCOUNT;
      }
      
      public static function _getCoordinatesByRefUnsafe(param1:int) : Array
      {
         return MapTools._CELLPOS[param1];
      }
      
      public static function getLOSCellsVector(param1:int, param2:int) : Vector.<Point>
      {
         return MapTools._cellsListToPointsVector(MapTools._createCellsListForCells(param1,param2));
      }
      
      public static function _cellsListToPointsVector(param1:GenericStack_Int) : Vector.<Point>
      {
         var _loc4_:int = 0;
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:GenericCell_Int = param1.head;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.elt;
            _loc3_ = _loc3_.next;
            _loc2_.push(MapTools._cellToPoint(_loc4_));
         }
         return _loc2_;
      }
      
      public static function _cellToPoint(param1:int) : Point
      {
         var _loc2_:Array = MapTools._getCoordinatesByRef(param1);
         return new Point(int(_loc2_[0]),int(_loc2_[1]));
      }
   }
}
