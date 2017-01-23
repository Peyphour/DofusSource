package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.MapReference;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.SuperArea;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.managers.FlagManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.dofus.types.entities.SearchResult;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class MapApi implements IApi
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapApi));
      
      private static const HINT_SEARCH_TYPE:uint = 1;
      
      private static const SUBAREA_SEARCH_TYPE:uint = 2;
      
      private static const MONSTER_SEARCH_TYPE:uint = 3;
      
      private static const ITEM_SEARCH_TYPE:uint = 4;
      
      private static const HINT_GROUP_SEARCH_TYPE:uint = 5;
       
      
      private var _currentUi:UiRootContainer;
      
      private var _searchResult:SearchResult;
      
      private var _hasResultsInOtherWorldMap:Boolean;
      
      private var _searchHints:Dictionary;
      
      private var _search:String;
      
      public function MapApi()
      {
         this._searchResult = new SearchResult();
         this._searchHints = new Dictionary(true);
         super();
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(param1:UiRootContainer) : void
      {
         if(!this._currentUi)
         {
            this._currentUi = param1;
         }
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._currentUi = null;
      }
      
      [Untrusted]
      public function getCurrentSubArea() : SubArea
      {
         var _loc1_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(_loc1_)
         {
            return SubArea.getSubAreaById(_loc1_.currentSubAreaId);
         }
         return null;
      }
      
      [Untrusted]
      public function getCurrentWorldMap() : WorldMap
      {
         if(PlayedCharacterManager.getInstance().currentWorldMap)
         {
            return PlayedCharacterManager.getInstance().currentWorldMap;
         }
         return null;
      }
      
      [Untrusted]
      public function getAllSuperArea() : Array
      {
         return SuperArea.getAllSuperArea();
      }
      
      [Untrusted]
      public function getAllArea() : Array
      {
         return Area.getAllArea();
      }
      
      [Untrusted]
      public function getAllSubArea() : Array
      {
         return SubArea.getAllSubArea();
      }
      
      [Untrusted]
      public function getSubArea(param1:uint) : SubArea
      {
         return SubArea.getSubAreaById(param1);
      }
      
      [Untrusted]
      public function getSubAreaMapIds(param1:uint) : Vector.<uint>
      {
         return SubArea.getSubAreaById(param1).mapIds;
      }
      
      [Untrusted]
      public function getSubAreaCenter(param1:uint) : Point
      {
         return SubArea.getSubAreaById(param1).center;
      }
      
      [Untrusted]
      public function getWorldPoint(param1:uint) : WorldPoint
      {
         return WorldPoint.fromMapId(param1);
      }
      
      [Untrusted]
      public function getMapCoords(param1:uint) : Point
      {
         var _loc2_:MapPosition = MapPosition.getMapPositionById(param1);
         return new Point(_loc2_.posX,_loc2_.posY);
      }
      
      [Untrusted]
      public function getSubAreaShape(param1:uint) : Vector.<int>
      {
         var _loc2_:SubArea = SubArea.getSubAreaById(param1);
         if(_loc2_)
         {
            return _loc2_.shape;
         }
         return null;
      }
      
      [Untrusted]
      public function getMapShape(param1:int, param2:int) : Vector.<int>
      {
         var _loc3_:Vector.<int> = new Vector.<int>();
         _loc3_.push(11000 + param1,11000 + param2,param1,param2,param1 + 1,param2,param1 + 1,param2 + 1,param1,param2 + 1,param1,param2);
         return _loc3_;
      }
      
      [Untrusted]
      public function getHints() : Array
      {
         return Hint.getHints();
      }
      
      [Untrusted]
      public function subAreaByMapId(param1:uint) : SubArea
      {
         return SubArea.getSubAreaByMapId(param1);
      }
      
      [Untrusted]
      public function getMapIdByCoord(param1:int, param2:int) : Vector.<int>
      {
         return MapPosition.getMapIdByCoord(param1,param2);
      }
      
      [Untrusted]
      public function getMapPositionById(param1:uint) : MapPosition
      {
         return MapPosition.getMapPositionById(param1);
      }
      
      [Untrusted]
      public function intersects(param1:Object, param2:Object) : Boolean
      {
         if(!param1 || !param2)
         {
            return false;
         }
         var _loc3_:Rectangle = Rectangle(param1);
         var _loc4_:Rectangle = Rectangle(param2);
         if(_loc3_ && _loc4_)
         {
            return _loc3_.intersects(_loc4_);
         }
         return false;
      }
      
      [Trusted]
      public function movePlayer(param1:int, param2:int, param3:int = -1) : void
      {
         var _loc6_:WorldPoint = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc13_:uint = 0;
         var _loc14_:MapPosition = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:int = 0;
         var _loc18_:UiRootContainer = null;
         if(!PlayerManager.getInstance().hasRights)
         {
            return;
         }
         var _loc4_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         var _loc5_:Vector.<int> = MapPosition.getMapIdByCoord(param1,param2);
         if(_loc5_)
         {
            _loc7_ = param3 == -1?uint(PlayedCharacterManager.getInstance().currentMap.worldId):uint(param3);
            _loc8_ = PlayedCharacterManager.getInstance().currentSubArea.area.superArea.id;
            _loc9_ = PlayedCharacterManager.getInstance().currentSubArea.area.id;
            _loc10_ = PlayedCharacterManager.getInstance().currentSubArea.id;
            _loc11_ = MapPosition.getMapPositionById(PlayedCharacterManager.getInstance().currentMap.mapId).outdoor;
            _loc12_ = [];
            for each(_loc13_ in _loc5_)
            {
               _loc14_ = MapPosition.getMapPositionById(_loc13_);
               _loc15_ = 0;
               _loc16_ = WorldPoint.fromMapId(_loc14_.id).worldId;
               switch(_loc16_)
               {
                  case 0:
                     _loc15_ = 40;
                     break;
                  case 3:
                     _loc15_ = 30;
                     break;
                  case 2:
                     _loc15_ = 20;
                     break;
                  case 1:
                     _loc15_ = 10;
               }
               _loc17_ = this.getCurrentWorldMap().id;
               _loc18_ = Berilia.getInstance().getUi("cartographyUi");
               if(!_loc18_)
               {
                  _loc18_ = Berilia.getInstance().getUi("cartographyPopup");
               }
               if(_loc18_)
               {
                  _loc17_ = _loc18_.uiClass.currentWorldId;
               }
               if(_loc14_.subArea && _loc14_.subArea.worldmap && _loc14_.subArea.worldmap.id == _loc17_)
               {
                  _loc15_ = _loc15_ + 100000;
               }
               if(_loc14_.hasPriorityOnWorldmap)
               {
                  _loc15_ = _loc15_ + 10000;
               }
               if(_loc14_.outdoor == _loc11_)
               {
                  _loc15_++;
               }
               if(_loc14_.subArea && _loc14_.subArea.id == _loc10_)
               {
                  _loc15_ = _loc15_ + 100;
               }
               if(_loc14_.subArea && _loc14_.subArea.area && _loc14_.subArea.area.id == _loc9_)
               {
                  _loc15_ = _loc15_ + 50;
               }
               if(_loc14_.subArea && _loc14_.subArea.area && _loc14_.subArea.area.superArea && _loc14_.subArea.area.superArea.id == _loc8_)
               {
                  _loc15_ = _loc15_ + 25;
               }
               if(_loc16_ == _loc7_)
               {
                  _loc15_ = _loc15_ + 100;
               }
               _loc12_.push({
                  "id":_loc13_,
                  "order":_loc15_
               });
            }
            if(_loc12_.length)
            {
               _loc12_.sortOn(["order","id"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
               _loc4_.initAdminQuietCommandMessage("moveto " + _loc12_.pop().id);
            }
            else
            {
               _loc4_.initAdminQuietCommandMessage("moveto " + param1 + "," + param2);
            }
         }
         else
         {
            _loc4_.initAdminQuietCommandMessage("moveto " + param1 + "," + param2);
         }
         ConnectionsHandler.getConnection().send(_loc4_);
      }
      
      [Trusted]
      public function movePlayerOnMapId(param1:uint) : void
      {
         var _loc2_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc2_.initAdminQuietCommandMessage("moveto " + param1);
         if(PlayerManager.getInstance().hasRights)
         {
            ConnectionsHandler.getConnection().send(_loc2_);
         }
      }
      
      [Untrusted]
      public function getMapReference(param1:uint) : Object
      {
         return MapReference.getMapReferenceById(param1);
      }
      
      [Untrusted]
      public function getPhoenixsMaps() : Array
      {
         return FlagManager.getInstance().phoenixs;
      }
      
      [Trusted]
      public function isInIncarnam() : Boolean
      {
         return this.getCurrentSubArea().areaId == 45;
      }
      
      [Untrusted]
      public function getSearchAllResults(param1:String) : Object
      {
         var _loc3_:Array = null;
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         if(!DataApi.isStaticCartographyInit)
         {
            this._currentUi.uiClass.dataApi.initStaticCartographyData();
         }
         var _loc2_:Array = [];
         var _loc4_:Array = [];
         for(_loc5_ in this._searchHints)
         {
            delete this._searchHints[_loc5_];
         }
         this._hasResultsInOtherWorldMap = false;
         this._search = param1;
         _loc6_ = StringUtils.noAccent(param1).toLowerCase();
         _loc3_ = this.getResults(Hint,HINT_SEARCH_TYPE,_loc6_);
         _loc4_.push({
            "content":_loc3_,
            "minLevenshteinDist":this.minProp("levenshteinDist",_loc3_) / _loc3_.length
         });
         _loc3_ = this.getResults(SubArea,SUBAREA_SEARCH_TYPE,_loc6_);
         _loc4_.push({
            "content":_loc3_,
            "minLevenshteinDist":this.minProp("levenshteinDist",_loc3_) / _loc3_.length
         });
         _loc3_ = this.getResults(Monster,MONSTER_SEARCH_TYPE,_loc6_);
         _loc4_.push({
            "content":_loc3_,
            "minLevenshteinDist":this.minProp("levenshteinDist",_loc3_) / _loc3_.length
         });
         _loc3_ = this.getResults(Item,ITEM_SEARCH_TYPE,_loc6_);
         _loc4_.push({
            "content":_loc3_,
            "minLevenshteinDist":this.minProp("levenshteinDist",_loc3_) / _loc3_.length
         });
         _loc4_ = _loc4_.sortOn("minLevenshteinDist",Array.NUMERIC);
         for each(_loc7_ in _loc4_)
         {
            _loc2_ = _loc2_.concat(_loc7_.content);
         }
         return {
            "results":_loc2_,
            "hasResultsInOtherWorldMap":this._hasResultsInOtherWorldMap,
            "searchHints":this._searchHints
         };
      }
      
      private function getResults(param1:Class, param2:uint, param3:String) : Array
      {
         var _loc5_:Object = null;
         var _loc7_:int = 0;
         var _loc4_:Array = [];
         var _loc6_:Vector.<int> = this.queryString(param1,"undiatricalName",param3);
         for each(_loc7_ in _loc6_)
         {
            _loc5_ = this.getSearchResultEntry(_loc7_,param2,param3);
            if(_loc5_)
            {
               _loc5_.levenshteinDist = this.levenshtein(_loc5_.data.undiatricalName,param3);
               _loc4_.push(_loc5_);
            }
         }
         _loc4_ = _loc4_.sortOn("levenshteinDist",Array.NUMERIC);
         return _loc4_;
      }
      
      private function minProp(param1:String, param2:Array) : int
      {
         var _loc4_:* = undefined;
         var _loc3_:int = -1;
         for each(_loc4_ in param2)
         {
            if(_loc3_ == -1 || _loc4_[param1] < _loc3_)
            {
               _loc3_ = _loc4_[param1];
            }
         }
         return _loc3_;
      }
      
      private function levenshtein(param1:String, param2:String) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!param1)
         {
            return param2.length;
         }
         var _loc3_:Array = [];
         _loc5_ = 0;
         while(_loc5_ <= param1.length)
         {
            _loc3_[_loc5_] = [];
            _loc6_ = 0;
            while(_loc6_ <= param2.length)
            {
               if(_loc5_ != 0)
               {
                  _loc3_[_loc5_].push(0);
               }
               else
               {
                  _loc3_[_loc5_].push(_loc6_);
               }
               _loc6_++;
            }
            _loc3_[_loc5_][0] = _loc5_;
            _loc5_++;
         }
         _loc5_ = 1;
         while(_loc5_ <= param1.length)
         {
            _loc6_ = 1;
            while(_loc6_ <= param2.length)
            {
               if(param1.charAt(_loc5_ - 1) == param2.charAt(_loc6_ - 1))
               {
                  _loc4_ = 0;
               }
               else
               {
                  _loc4_ = 1;
               }
               _loc3_[_loc5_][_loc6_] = Math.min(_loc3_[_loc5_ - 1][_loc6_] + 1,_loc3_[_loc5_][_loc6_ - 1] + 1,_loc3_[_loc5_ - 1][_loc6_ - 1] + _loc4_);
               _loc6_++;
            }
            _loc5_++;
         }
         return _loc3_[param1.length][param2.length];
      }
      
      private function queryString(param1:Class, param2:String, param3:String) : Vector.<int>
      {
         var _loc5_:Dictionary = null;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc4_:Vector.<int> = new Vector.<int>();
         switch(param1)
         {
            case Hint:
               _loc5_ = DataApi.allHints;
               break;
            case SubArea:
               _loc5_ = DataApi.allSubAreas;
               break;
            case Monster:
               _loc5_ = DataApi.allMonsters;
               break;
            case Item:
               _loc5_ = DataApi.allItems;
         }
         var _loc6_:Array = StringUtils.noAccent(param3).toLowerCase().split(" ");
         for each(_loc7_ in _loc5_)
         {
            _loc8_ = 0;
            _loc9_ = [];
            _loc10_ = _loc7_[param2].split(" ");
            for each(_loc11_ in _loc6_)
            {
               for each(_loc12_ in _loc10_)
               {
                  if(_loc9_.indexOf(_loc11_) == -1 && _loc12_.indexOf(_loc11_) != -1)
                  {
                     _loc8_++;
                     _loc9_.push(_loc11_);
                  }
               }
            }
            if(_loc8_ >= _loc6_.length)
            {
               _loc4_.push(_loc7_.id);
            }
         }
         return _loc4_;
      }
      
      private function getSearchResultEntry(param1:int, param2:uint, param3:String) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:SearchResult = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Hint = null;
         var _loc17_:SubArea = null;
         var _loc18_:Monster = null;
         var _loc19_:Vector.<int> = null;
         var _loc20_:Item = null;
         var _loc21_:Vector.<int> = null;
         var _loc22_:Vector.<int> = null;
         var _loc23_:String = null;
         var _loc24_:Hint = null;
         var _loc6_:* = "";
         switch(param2)
         {
            case HINT_SEARCH_TYPE:
               _loc16_ = DataApi.allHints[param1];
               if(!_loc16_)
               {
                  return null;
               }
               if(_loc16_.worldMapId != this.getCurrentWorldMap().id)
               {
                  this._hasResultsInOtherWorldMap = true;
                  return null;
               }
               _loc4_ = {};
               _loc4_.data = _loc16_;
               if(_loc16_.categoryId == 6)
               {
                  _loc4_.uri = this._currentUi.getConstant("texture") + "windowIcon/icon__0022_Groupe.png";
               }
               else
               {
                  _loc4_.uri = this._currentUi.getConstant("hintIcons") + _loc16_.gfx + ".png";
               }
               break;
            case SUBAREA_SEARCH_TYPE:
               _loc17_ = DataApi.allSubAreas[param1];
               if(DataApi.dungeonsBySubArea[_loc17_.id] || !this.isValidSubArea(_loc17_))
               {
                  return null;
               }
               if(_loc17_.worldmap.id != this.getCurrentWorldMap().id)
               {
                  this._hasResultsInOtherWorldMap = true;
                  return null;
               }
               _loc4_ = {};
               _loc4_.data = _loc17_;
               _loc4_.uri = this._currentUi.getConstant("texture") + "windowIcon/icon__0025_Geoposition.png";
               _loc6_ = " (" + _loc17_.area.name + ")";
               break;
            case MONSTER_SEARCH_TYPE:
               _loc18_ = DataApi.allMonsters[param1];
               _loc5_ = this.getMonsterValidSubAreas(_loc18_);
               _loc19_ = _loc5_.resultData;
               if(_loc5_.resultCode == SearchResult.VALID_PARTIAL)
               {
                  this._hasResultsInOtherWorldMap = true;
               }
               if(!_loc19_)
               {
                  return null;
               }
               _loc4_ = {};
               _loc4_.data = _loc18_;
               _loc4_.subAreasIds = _loc19_;
               _loc4_.uri = this._currentUi.getConstant("texture") + "windowIcon/icon__0020_Bestiaire.png";
               break;
            case ITEM_SEARCH_TYPE:
               _loc20_ = DataApi.allItems[param1];
               if(!_loc20_)
               {
                  return null;
               }
               if(_loc20_.dropMonsterIds.length > 0)
               {
                  _loc5_ = this.getItemValidSubAreas(_loc20_);
                  _loc21_ = _loc5_.resultData;
                  if(_loc5_.resultCode == SearchResult.VALID_PARTIAL)
                  {
                     this._hasResultsInOtherWorldMap = true;
                  }
               }
               if(_loc20_.resourcesBySubarea.length > 0)
               {
                  _loc5_ = this.getResourceItemValidSubAreaIds(_loc20_);
                  _loc22_ = _loc5_.resultData;
                  if(_loc5_.resultCode == SearchResult.VALID_PARTIAL)
                  {
                     this._hasResultsInOtherWorldMap = true;
                  }
               }
               if(!_loc21_ && !_loc22_)
               {
                  return null;
               }
               _loc4_ = {};
               _loc4_.data = _loc20_;
               _loc4_.subAreasIds = _loc21_;
               _loc4_.resourceSubAreaIds = _loc22_;
               _loc4_.uri = this._currentUi.getConstant("texture") + "windowIcon/icon__0027_Inventaire.png";
               if(_loc20_.type.superTypeId == 14)
               {
                  _loc4_.typeUri = this._currentUi.getConstant("texture") + "success/success_cat_6.png";
               }
               else if(_loc22_)
               {
                  _loc4_.typeUri = this._currentUi.getConstant("texture") + "success/success_cat_5.png";
               }
               break;
         }
         _loc4_.type = param2;
         _loc4_.name = _loc4_.data.name;
         var _loc7_:String = _loc4_.name.toLowerCase();
         var _loc8_:String = _loc4_.name;
         var _loc11_:int = _loc8_.length;
         var _loc12_:int = param3.length;
         _loc9_ = 0;
         while(_loc9_ < _loc11_)
         {
            _loc13_ = StringUtils.noAccent(_loc7_.substring(_loc9_,_loc9_ + _loc12_));
            if(_loc13_ == param3)
            {
               _loc14_ = _loc9_ + _loc15_ * 7;
               _loc10_ = _loc14_ + _loc12_;
               _loc8_ = _loc8_.substring(0,_loc14_) + "<b>" + _loc8_.substring(_loc14_,_loc10_) + "</b>" + _loc8_.substring(_loc10_);
               _loc15_++;
            }
            _loc9_++;
         }
         _loc4_.label = _loc8_ + _loc6_;
         if(_loc4_.type == HINT_SEARCH_TYPE)
         {
            _loc23_ = StringUtils.noAccent(_loc7_);
            if(!this._searchHints[_loc23_])
            {
               this._searchHints[_loc23_] = _loc4_;
            }
            else
            {
               if(this._searchHints[_loc23_].data is Hint)
               {
                  this._searchHints[_loc23_].type = HINT_GROUP_SEARCH_TYPE;
                  _loc24_ = this._searchHints[_loc23_].data;
                  this._searchHints[_loc23_].data = [];
                  this._searchHints[_loc23_].data.push(_loc24_);
               }
               this._searchHints[_loc23_].data.push(_loc4_.data);
               return null;
            }
         }
         return _loc4_;
      }
      
      private function isValidSubArea(param1:SubArea) : Boolean
      {
         return DataApi.dungeonsBySubArea[param1.id] || DataApi.hintsBySubArea[param1.id] || param1.displayOnWorldMap && param1.shape.length > 0;
      }
      
      private function getMonsterValidSubAreas(param1:Monster) : SearchResult
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:SubArea = null;
         var _loc4_:uint = 0;
         var _loc5_:int = SearchResult.VALID_ALL;
         if(param1.subareas.length > 0)
         {
            for each(_loc4_ in param1.subareas)
            {
               _loc3_ = DataApi.allSubAreas[_loc4_];
               if(this.isValidSubArea(_loc3_))
               {
                  if(_loc3_.worldmap.id == this.getCurrentWorldMap().id)
                  {
                     if(!_loc2_)
                     {
                        _loc2_ = new Vector.<int>(0);
                     }
                     _loc2_.push(_loc3_.id);
                  }
                  else
                  {
                     _loc5_ = SearchResult.VALID_PARTIAL;
                  }
               }
            }
         }
         this._searchResult.resultData = _loc2_;
         this._searchResult.resultCode = !_loc2_ && _loc5_ != SearchResult.VALID_PARTIAL?int(SearchResult.VALID_NONE):int(_loc5_);
         return this._searchResult;
      }
      
      private function getItemValidSubAreas(param1:Item) : SearchResult
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:Monster = null;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:SearchResult = null;
         var _loc7_:int = SearchResult.VALID_ALL;
         for each(_loc4_ in param1.dropMonsterIds)
         {
            _loc3_ = DataApi.allMonsters[_loc4_];
            _loc6_ = this.getMonsterValidSubAreas(_loc3_);
            _loc5_ = _loc6_.resultData;
            if(_loc5_)
            {
               if(!_loc2_)
               {
                  _loc2_ = new Vector.<int>(0);
               }
               if(_loc2_.indexOf(_loc4_) == -1)
               {
                  _loc2_.push(_loc4_);
                  _loc2_.push(_loc5_.length);
                  _loc2_ = _loc2_.concat(_loc5_);
               }
            }
            if(_loc6_.resultCode == SearchResult.VALID_PARTIAL)
            {
               _loc7_ = SearchResult.VALID_PARTIAL;
            }
         }
         this._searchResult.resultData = _loc2_;
         this._searchResult.resultCode = !_loc2_ && _loc7_ != SearchResult.VALID_PARTIAL?int(SearchResult.VALID_NONE):int(_loc7_);
         return this._searchResult;
      }
      
      private function getResourceItemValidSubAreaIds(param1:Item) : SearchResult
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:Object = null;
         var _loc4_:SubArea = null;
         var _loc5_:int = SearchResult.VALID_ALL;
         for each(_loc3_ in param1.resourcesBySubarea)
         {
            _loc4_ = DataApi.allSubAreas[_loc3_[0]];
            if(this.isValidSubArea(_loc4_))
            {
               if(_loc4_.worldmap.id == this.getCurrentWorldMap().id)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = new Vector.<int>(0);
                  }
                  _loc2_.push(_loc3_[0]);
                  _loc2_.push(_loc3_[1]);
               }
               else
               {
                  _loc5_ = SearchResult.VALID_PARTIAL;
               }
            }
         }
         this._searchResult.resultData = _loc2_;
         this._searchResult.resultCode = !_loc2_ && _loc5_ != SearchResult.VALID_PARTIAL?int(SearchResult.VALID_NONE):int(_loc5_);
         return this._searchResult;
      }
   }
}
