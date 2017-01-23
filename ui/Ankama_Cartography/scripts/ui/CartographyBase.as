package ui
{
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.datacenter.world.HintCategory;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildHouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.types.game.house.AccountHouseInformations;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockContentInformations;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.GuildGetInformations;
   import d2actions.PlaySound;
   import d2actions.PrismsListRegister;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.GuildInformationsTypeEnum;
   import d2enums.HintPriorityEnum;
   import d2enums.PrismListenEnum;
   import d2enums.PrismStateEnum;
   import d2hooks.FocusChange;
   import d2hooks.GuildHouseAdd;
   import d2hooks.GuildHouseRemoved;
   import d2hooks.GuildHousesUpdate;
   import d2hooks.GuildInformationsFarms;
   import d2hooks.GuildPaddockAdd;
   import d2hooks.GuildPaddockRemoved;
   import d2hooks.GuildTaxCollectorAdd;
   import d2hooks.GuildTaxCollectorRemoved;
   import d2hooks.MapHintsFilter;
   import d2hooks.MouseShiftClick;
   import d2hooks.OpenDareSearch;
   import d2hooks.PrismsList;
   import d2hooks.PrismsListUpdate;
   import d2hooks.RemoveMapFlag;
   import d2hooks.TaxCollectorListUpdate;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import ui.type.Flag;
   
   public class CartographyBase extends AbstractCartographyUi
   {
      
      public static const MODE_MOVE:String = "move";
      
      public static const MODE_FLAG:String = "flag";
      
      protected static const NO_PRISM_AREAS:String = "noPrismAreas";
      
      protected static const NORMAL_AREAS:String = "normalAreas";
      
      protected static const WEAKENED_AREAS:String = "weakenedAreas";
      
      protected static const VULNERABLE_AREAS:String = "vulnerableAreas";
      
      protected static const VILLAGES_AREAS:String = "villagesAreas";
      
      protected static const CAPTURABLE_AREAS:String = "capturableAreas";
      
      protected static const SABOTAGED_AREAS:String = "sabotagedAreas";
      
      protected static const WORLD_OF_AMAKNA:int = 1;
      
      protected static const WORLD_OF_INCARNAM:int = 2;
      
      protected static const FRIGOST_III:int = 12;
      
      protected static const MAP_TYPE_SUPERAREA:uint = 0;
      
      protected static const MAP_TYPE_SUBAREA:uint = 1;
      
      protected static var gridDisplayed:Boolean = false;
      
      protected static var templeDisplayed:Boolean = true;
      
      protected static var bidHouseDisplayed:Boolean = true;
      
      protected static var craftHouseDisplayed:Boolean = true;
      
      protected static var miscDisplayed:Boolean = true;
      
      protected static var conquestDisplayed:Boolean = true;
      
      protected static var dungeonDisplayed:Boolean = true;
      
      protected static var privateDisplayed:Boolean = true;
      
      private static var MAP_PRESET:Array = new Array();
      
      private static var _lastWorldId:int = -1;
      
      private static var _lastMapId:int = -1;
       
      
      public var soundApi:SoundApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var configApi:ConfigApi;
      
      public var utilApi:UtilApi;
      
      public var timeApi:TimeApi;
      
      protected var __mapMode:String = "move";
      
      protected var __iconScale:Number;
      
      protected var __minZoom:Number;
      
      protected var __playerPos:Object;
      
      protected var __startWorldMapInfo:Object;
      
      protected var __worldMapInfo:Object;
      
      protected var __hintCategoryFiltersList:Array;
      
      protected var __layersToShow:Array;
      
      protected var __allAreas:Object;
      
      protected var __capturableAreas:Object;
      
      protected var __sabotagedAreas:Object;
      
      protected var __noPrismAreas:Object;
      
      protected var __normalAreas:Object;
      
      protected var __weakenedAreas:Object;
      
      protected var __vulnerableAreas:Object;
      
      protected var __villagesAreas:Object;
      
      protected var __subAreaList:Object;
      
      protected var __switchingMapUi:Boolean;
      
      protected var __lastSubArea:SubArea;
      
      protected var __subAreaTooltipPosition:Point;
      
      protected var __displaySubAreaToolTip:Boolean = true;
      
      protected var __animatedPlayerPosition:Boolean = true;
      
      private var _flags:Object;
      
      private var _currentSubarea:Object;
      
      private var _textCss:String;
      
      private var _allianceEmblemsLoaded:Boolean;
      
      private var _waitingForSocialUpdate:int;
      
      private var _mapChanged:Boolean;
      
      protected var _openMapNextFrame:Boolean = false;
      
      private var _myAlliance:AllianceWrapper;
      
      protected var __hintIconsRootPath:String;
      
      public function CartographyBase()
      {
         this.__hintCategoryFiltersList = new Array();
         this.__subAreaTooltipPosition = new Point();
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         super.main(param1);
         this.__hintIconsRootPath = sysApi.getConfigEntry("config.gfx.path") + "icons/hintsShadow/";
         this.__switchingMapUi = param1.switchingMapUi;
         uiApi.addComponentHook(mapViewer,ComponentHookList.ON_RELEASE);
         sysApi.addHook(GuildInformationsFarms,this.onGuildInformationsFarms);
         sysApi.addHook(GuildHousesUpdate,this.onGuildHousesUpdate);
         sysApi.addHook(TaxCollectorListUpdate,this.onTaxCollectorListUpdate);
         sysApi.addHook(MapHintsFilter,this.onMapHintsFilter);
         sysApi.addHook(GuildPaddockAdd,this.onGuildPaddockAdd);
         sysApi.addHook(GuildPaddockRemoved,this.onGuildPaddockRemoved);
         sysApi.addHook(GuildTaxCollectorAdd,this.onGuildTaxCollectorAdd);
         sysApi.addHook(GuildTaxCollectorRemoved,this.onGuildTaxCollectorRemoved);
         sysApi.addHook(GuildHouseAdd,this.onGuildHouseAdd);
         sysApi.addHook(GuildHouseRemoved,this.onGuildHouseRemoved);
         sysApi.addHook(RemoveMapFlag,this.onRemoveMapFlag);
         sysApi.addHook(PrismsList,this.onPrismsListInformation);
         sysApi.addHook(PrismsListUpdate,this.onPrismsInfoUpdate);
         sysApi.addHook(FocusChange,this.onFocusChange);
         sysApi.addHook(MouseShiftClick,this.onMouseShiftClick);
         gridDisplayed = sysApi.getData("ShowMapGrid",DataStoreEnum.BIND_ACCOUNT);
         this.loadMapFilters(this.__hintCategoryFiltersList,"mapFilters");
         this._textCss = uiApi.me().getConstant("css") + "normal.css";
         this.__playerPos = param1.currentMap;
         this._flags = param1.flags;
         var _loc2_:Object = this.playerApi.currentSubArea();
         if(!_loc2_.hasCustomWorldMap)
         {
            this.__startWorldMapInfo = _loc2_.area.superArea.worldmap;
         }
         else
         {
            this.__startWorldMapInfo = _loc2_.worldmap;
         }
         this.openPlayerCurrentMap();
      }
      
      public function addFlag(param1:String, param2:String, param3:int, param4:int, param5:int = -1, param6:Boolean = true, param7:Boolean = true, param8:Boolean = true, param9:Boolean = false) : void
      {
         var _loc10_:* = null;
         var _loc11_:Rectangle = null;
         if(param6)
         {
            sysApi.sendAction(new PlaySound("16039"));
         }
         var _loc12_:uint = HintPriorityEnum.FLAGS;
         switch(param1)
         {
            case "flag_playerPosition":
               _loc10_ = !!this.__animatedPlayerPosition?sysApi.getConfigEntry("config.gfx.path") + "icons/assets.swf|myPosition":this.__hintIconsRootPath + "character.png";
               _loc12_ = HintPriorityEnum.PLAYER;
               break;
            case "Phoenix":
               _loc10_ = this.__hintIconsRootPath + "phoenix.png";
               break;
            default:
               _loc10_ = this.__hintIconsRootPath + "flag.png";
         }
         var _loc13_:Object = mapViewer.addIcon("layer_8",param1,_loc10_,param3,param4,this.__iconScale,param2,true,param5,true,param8,_loc11_,true,param9,_loc12_);
         if(_loc13_ && param7)
         {
            this.updateMap();
         }
      }
      
      public function updateFlag(param1:String, param2:int, param3:int, param4:String) : Boolean
      {
         var _loc5_:Object = mapViewer.getMapElement(param1);
         if(_loc5_)
         {
            _loc5_.x = param2;
            _loc5_.y = param3;
            _loc5_.legend = param4;
            this.updateMap();
            return true;
         }
         return false;
      }
      
      override public function unload() : void
      {
         super.unload();
         if(!sysApi.getOption("cacheMapEnabled","dofus"))
         {
            _currentWorldId = -1;
         }
         this.saveMapFilters(this.__hintCategoryFiltersList,"mapFilters");
         this.saveCurrentMapPreset();
         sysApi.sendAction(new PrismsListRegister("Cartography",PrismListenEnum.PRISM_LISTEN_NONE));
      }
      
      protected function openPlayerCurrentMap() : void
      {
         var _loc1_:Object = this.playerApi.currentSubArea();
         if(!_loc1_.hasCustomWorldMap)
         {
            this.openNewMap(_loc1_.area.superArea.worldmap,MAP_TYPE_SUPERAREA,_loc1_.area.superArea);
         }
         else
         {
            this.openNewMap(_loc1_.worldmap,MAP_TYPE_SUBAREA,_loc1_);
         }
      }
      
      protected function openNewMap(param1:Object, param2:uint, param3:Object, param4:Boolean = false) : Boolean
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:MapPreset = null;
         var _loc11_:Number = NaN;
         if(!param4 && param1.id == _currentWorldId)
         {
            return false;
         }
         switch(param2)
         {
            case MAP_TYPE_SUPERAREA:
               this._currentSubarea = null;
               _currentSuperarea = param3;
               break;
            case MAP_TYPE_SUBAREA:
               this._currentSubarea = param3;
               _currentSuperarea = param3.area.superArea;
         }
         var _loc5_:uint = this._currentSubarea != null && this._currentSubarea.customWorldMap.length > 0?uint(this._currentSubarea.customWorldMap[0]):uint(param1.id);
         if(_currentWorldId != 0 && _loc5_ != _currentWorldId)
         {
            this._flags = modCartography.getFlags(_loc5_);
         }
         this._mapChanged = _lastWorldId != -1 && _loc5_ != _lastWorldId;
         _lastWorldId = _currentWorldId = _loc5_;
         this.__worldMapInfo = param1;
         mapViewer.origineX = param1.origineX;
         mapViewer.origineY = param1.origineY;
         mapViewer.mapWidth = param1.mapWidth;
         mapViewer.mapHeight = param1.mapHeight;
         mapViewer.minScale = param1.minScale;
         mapViewer.maxScale = param1.maxScale;
         if(MAP_PRESET[_currentWorldId])
         {
            _loc10_ = MAP_PRESET[_currentWorldId];
            mapViewer.startScale = _loc10_.zoomFactor;
         }
         else
         {
            mapViewer.startScale = param1.startScale;
         }
         var _loc6_:* = sysApi.getConfigEntry("config.gfx.path.maps") + _loc5_ + "/";
         mapViewer.removeAllMap();
         this.__minZoom = NaN;
         for each(_loc7_ in param1.zoom)
         {
            _loc11_ = parseFloat(_loc7_);
            if(isNaN(this.__minZoom))
            {
               this.__minZoom = _loc11_;
            }
            else if(_loc11_ < this.__minZoom)
            {
               this.__minZoom = _loc11_;
            }
            mapViewer.addMap(_loc11_,_loc6_ + _loc7_ + "/",param1.totalWidth,param1.totalHeight,250,250);
         }
         mapViewer.minScale = this.__minZoom;
         mapViewer.startScale = Number(mapViewer.startScale.toFixed(2));
         _loc9_ = mapViewer.zoomLevels.length;
         if(mapViewer.zoomLevels.indexOf(mapViewer.startScale) == -1)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               if(mapViewer.startScale < mapViewer.zoomLevels[_loc8_])
               {
                  if(_loc8_ == 0)
                  {
                     mapViewer.startScale = mapViewer.zoomLevels[_loc8_];
                  }
                  else
                  {
                     mapViewer.startScale = mapViewer.zoomLevels[_loc8_ - 1];
                  }
                  break;
               }
               _loc8_++;
            }
         }
         mapViewer.finalize();
         this.__iconScale = Math.min(param1.mapWidth / 31.5,3);
         this.initMap();
         return true;
      }
      
      protected function initMap() : void
      {
         var _loc2_:String = null;
         var _loc3_:Hint = null;
         var _loc4_:String = null;
         var _loc6_:* = null;
         var _loc7_:Boolean = false;
         var _loc13_:AccountHouseInformations = null;
         var _loc14_:Boolean = false;
         var _loc15_:Flag = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         mapViewer.showGrid = gridDisplayed;
         mapViewer.autoSizeIcon = true;
         minValue = mapViewer.maxScale;
         maxValue = mapViewer.minScale;
         zoom = mapViewer.startScale;
         mapViewer.addLayer(NO_PRISM_AREAS);
         mapViewer.addLayer(NORMAL_AREAS);
         mapViewer.addLayer(WEAKENED_AREAS);
         mapViewer.addLayer(VULNERABLE_AREAS);
         mapViewer.addLayer(VILLAGES_AREAS);
         mapViewer.addLayer(CAPTURABLE_AREAS);
         mapViewer.addLayer(SABOTAGED_AREAS);
         this.__subAreaList = mapApi.getAllSubArea();
         var _loc1_:Object = mapApi.getHints();
         this.__layersToShow = new Array();
         var _loc5_:* = " (" + uiApi.getText("ui.common.short.level") + " ";
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.worldMapId == _currentWorldId)
            {
               _loc2_ = "layer_" + _loc3_.categoryId;
               if(!this.__layersToShow[_loc2_])
               {
                  this.__layersToShow[_loc2_] = true;
                  mapViewer.addLayer(_loc2_);
               }
               _loc4_ = _loc3_.name;
               if(_loc3_.level)
               {
                  _loc4_ = _loc4_ + (_loc5_ + _loc3_.level + ")");
               }
               mapViewer.addIcon(_loc2_,"hint_" + _loc3_.id,this.__hintIconsRootPath + _loc3_.gfx + ".png",_loc3_.x,_loc3_.y,this.__iconScale,_loc4_,false,-1,true,true,null,true,false,_loc3_.priority);
            }
         }
         mapViewer.addLayer("layer_5");
         this.__layersToShow["layer_5"] = true;
         mapViewer.addLayer("layer_7");
         this.__layersToShow["layer_7"] = !this.isDungeonMap();
         mapViewer.addLayer("layer_8");
         this.__layersToShow["layer_8"] = true;
         for(_loc6_ in this.__hintCategoryFiltersList)
         {
            _loc2_ = "layer_" + _loc6_;
            _loc14_ = !!this.__layersToShow[_loc2_]?Boolean(this.__hintCategoryFiltersList[_loc6_]):false;
            mapViewer.showLayer(_loc2_,_loc14_);
         }
         _loc7_ = !this.__switchingMapUi && !this._mapChanged?Boolean(this.restoreCurrentMapPreset()):false;
         _lastMapId = this.playerApi.currentMap().mapId;
         var _loc8_:Object = mapViewer.getMapElementsByLayer("layer_8");
         var _loc9_:int = _loc8_.length;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            mapViewer.removeMapElement(_loc8_[_loc10_]);
            _loc10_++;
         }
         if(this._flags)
         {
            _nbCustomFlags[_currentWorldId] = 0;
            for each(_loc15_ in this._flags)
            {
               this.addFlag(_loc15_.id,_loc15_.legend,_loc15_.position.x,_loc15_.position.y,_loc15_.color,false,false,_loc15_.canBeManuallyRemoved,_loc15_.allowDuplicate);
               _nbCustomFlags[_currentWorldId]++;
            }
         }
         var _loc11_:Object = this.playerApi.getPlayerHouses();
         var _loc12_:int = 0;
         for each(_loc13_ in _loc11_)
         {
            if(this.dataApi.getSubArea(_loc13_.subAreaId).area.superAreaId == superAreaId)
            {
               _loc16_ = {
                  "x":_loc13_.worldX,
                  "y":_loc13_.worldY
               };
               __hintCaptions["myHouse_" + _loc12_] = uiApi.getText("ui.common.myHouse");
               mapViewer.addIcon("layer_7","myHouse_" + _loc12_,this.__hintIconsRootPath + "1000.png",_loc13_.worldX,_loc13_.worldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.PLAYER_POSSESSIONS);
               _loc12_++;
            }
         }
         if(_currentWorldId == WORLD_OF_INCARNAM)
         {
            this.addSubAreasShapes();
         }
         if(this.__playerPos)
         {
            _loc17_ = this.playerApi.currentSubArea();
            if(_loc17_.area.superArea.id == _currentSuperarea.id)
            {
               if(!mapViewer.getMapElement("flag_playerPosition") && (!this._currentSubarea || _loc17_.id == this._currentSubarea.id))
               {
                  this.addFlag("flag_playerPosition",uiApi.getText("ui.cartography.yourposition"),this.__playerPos.outdoorX,this.__playerPos.outdoorY,-1,false,false,false);
               }
               _loc18_ = mapViewer.mapBounds;
               if(!(_loc18_.left > this.__playerPos.outdoorX || _loc18_.right < this.__playerPos.outdoorX || _loc18_.bottom < this.__playerPos.outdoorY || _loc18_.top > this.__playerPos.outdoorY) && mapViewer.zoomFactor >= this.__minZoom)
               {
                  if(!_loc7_)
                  {
                     mapViewer.moveTo(this.__playerPos.outdoorX,this.__playerPos.outdoorY);
                  }
               }
               else if(!_loc7_)
               {
                  mapViewer.moveTo(this.__worldMapInfo.centerX,this.__worldMapInfo.centerY);
               }
            }
            else if(!_loc7_)
            {
               mapViewer.moveTo(this.__worldMapInfo.centerX,this.__worldMapInfo.centerY);
            }
         }
         else if(!_loc7_)
         {
            mapViewer.moveTo(this.__worldMapInfo.centerX,this.__worldMapInfo.centerY);
         }
         if(socialApi.hasGuild())
         {
            this._waitingForSocialUpdate++;
            sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_TAX_COLLECTOR_GUILD_ONLY));
            if(socialApi.guildHousesUpdateNeeded() && (!socialApi.getGuildHouses() || socialApi.getGuildHouses().length == 0))
            {
               this._waitingForSocialUpdate++;
               sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_HOUSES));
            }
            else
            {
               this.onGuildHousesUpdate();
            }
            if(!socialApi.getGuildPaddocks() || socialApi.getGuildPaddocks().length == 0)
            {
               this._waitingForSocialUpdate++;
               sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_PADDOCKS));
            }
            else
            {
               this.onGuildInformationsFarms();
            }
         }
         else
         {
            this.updateMap();
         }
      }
      
      protected function addSubAreasShapes() : void
      {
         var _loc1_:Object = null;
         this.__noPrismAreas = {"children":[]};
         for each(_loc1_ in this.__subAreaList)
         {
            if(_loc1_.displayOnWorldMap && _loc1_.worldmap && !mapViewer.getMapElement("shape" + _loc1_.id))
            {
               if(_loc1_.worldmap.id == _currentWorldId)
               {
                  mapViewer.addAreaShape(NO_PRISM_AREAS,"shape" + _loc1_.id,mapApi.getSubAreaShape(_loc1_.id),3355443,0.2,1096297,0.2);
               }
               this.__noPrismAreas.children.push({"data":_loc1_});
            }
         }
      }
      
      protected function saveCurrentMapPreset() : void
      {
         if(this.__worldMapInfo)
         {
            MAP_PRESET[_currentWorldId] = new MapPreset(mapViewer.mapPixelPosition,mapViewer.zoomFactor);
         }
      }
      
      override protected function addCustomFlag(param1:int, param2:int) : void
      {
         super.addCustomFlag(param1,param2);
         this.__mapMode = MODE_MOVE;
      }
      
      override protected function addCustomFlagWithRightClick(param1:Number, param2:Number) : void
      {
         this.__mapMode = MODE_FLAG;
         super.addCustomFlagWithRightClick(param1,param2);
      }
      
      protected function updatePrismIcon(param1:PrismSubAreaWrapper) : void
      {
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc8_:ItemWrapper = null;
         var _loc9_:ObjectItem = null;
         var _loc2_:SubArea = this.dataApi.getSubArea(param1.subAreaId);
         var _loc3_:String = "prism_" + param1.subAreaId;
         var _loc4_:* = mapViewer.getMapElement(_loc3_);
         if(param1.mapId != -1 && _loc2_.worldmap && _loc2_.worldmap.id == _currentWorldId && (param1.alliance || this._myAlliance))
         {
            _loc5_ = modCartography.getPrismStateInfo(param1.state);
            _loc6_ = "";
            _loc7_ = "";
            switch(param1.state)
            {
               case PrismStateEnum.PRISM_STATE_NORMAL:
                  _loc6_ = uiApi.getText("ui.prism.vulnerabilityHour") + " :";
                  break;
               case PrismStateEnum.PRISM_STATE_WEAKENED:
               case PrismStateEnum.PRISM_STATE_SABOTAGED:
                  _loc6_ = uiApi.getText("ui.prism.startVulnerability") + uiApi.getText("ui.common.colon") + this.timeApi.getDate(param1.nextVulnerabilityDate * 1000);
            }
            if(param1.state == PrismStateEnum.PRISM_STATE_NORMAL || param1.state == PrismStateEnum.PRISM_STATE_WEAKENED || param1.state == PrismStateEnum.PRISM_STATE_SABOTAGED)
            {
               _loc6_ = _loc6_ + (" " + param1.vulnerabilityHourString);
            }
            if(this._myAlliance && param1.alliance.allianceId == this._myAlliance.allianceId && param1.modulesObjects && param1.modulesObjects.length > 0)
            {
               for each(_loc9_ in param1.modulesObjects)
               {
                  _loc8_ = this.dataApi.getItemWrapper(_loc9_.objectGID,0,0,1);
                  _loc7_ = _loc7_ + (_loc8_.name + "\n");
               }
               _loc7_ = _loc7_.substr(0,_loc7_.length - 1);
            }
            __hintCaptions["prism_" + param1.subAreaId] = _loc5_.text;
            if(_loc6_.length > 0)
            {
               __hintCaptions["prism_" + param1.subAreaId] = __hintCaptions["prism_" + param1.subAreaId] + (" <i>( " + _loc6_ + " )</i>");
            }
            if(_loc7_.length > 0)
            {
               __hintCaptions["prism_" + param1.subAreaId] = __hintCaptions["prism_" + param1.subAreaId] + (" <i>( " + _loc7_ + " )</i>");
            }
            if(_loc4_)
            {
               mapViewer.removeMapElement(_loc4_);
            }
            mapViewer.addIcon("layer_5",_loc3_,this.__hintIconsRootPath + _loc5_.icon + ".png",param1.worldX,param1.worldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.CONQUEST);
         }
         else if(param1.mapId == -1 && _loc4_)
         {
            mapViewer.removeMapElement(_loc4_);
         }
      }
      
      protected function updatePrismAndSubareaStatus(param1:PrismSubAreaWrapper, param2:Boolean = true) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:AllianceWrapper = null;
         var _loc11_:uint = 0;
         var _loc3_:SubArea = mapApi.getSubArea(param1.subAreaId);
         if(!_loc3_ || !_loc3_.name || !_loc3_.worldmap || _loc3_.worldmap.id != _currentWorldId)
         {
            return;
         }
         if(param2)
         {
            _loc4_ = {
               "label":_loc3_.name,
               "parent":this.__allAreas,
               "type":"subarea",
               "data":_loc3_
            };
            this.addConquestItem(this.__allAreas,_loc4_);
         }
         var _loc7_:Number = 0.6;
         var _loc8_:Number = 0.4;
         if(param1.mapId != -1 || param1.alliance)
         {
            _loc10_ = !param1.alliance?this._myAlliance:param1.alliance;
            if(_loc4_ && this._myAlliance && this._myAlliance.allianceId == _loc10_.allianceId)
            {
               _loc4_.css = this._textCss;
               _loc4_.cssClass = "bonus";
            }
            _loc6_ = _loc5_ = _loc10_.backEmblem.color;
            _loc11_ = param1.mapId != -1?uint(param1.state):uint(PrismStateEnum.PRISM_STATE_NORMAL);
            switch(_loc11_)
            {
               case PrismStateEnum.PRISM_STATE_INVULNERABLE:
               case PrismStateEnum.PRISM_STATE_NORMAL:
                  _loc9_ = NORMAL_AREAS;
                  if(_loc4_)
                  {
                     this.addConquestItem(this.__normalAreas,_loc4_);
                  }
                  break;
               case PrismStateEnum.PRISM_STATE_WEAKENED:
                  _loc9_ = WEAKENED_AREAS;
                  if(_loc4_)
                  {
                     _loc4_.vulnerabilityDate = param1.nextVulnerabilityDate;
                     _loc4_.label = _loc4_.label + (" - " + param1.vulnerabilityHourString);
                     this.addConquestItem(this.__weakenedAreas,_loc4_);
                  }
                  break;
               case PrismStateEnum.PRISM_STATE_SABOTAGED:
                  _loc9_ = SABOTAGED_AREAS;
                  if(_loc4_)
                  {
                     _loc4_.vulnerabilityDate = param1.nextVulnerabilityDate;
                     _loc4_.label = _loc4_.label + (" - " + param1.vulnerabilityHourString);
                     this.addConquestItem(this.__sabotagedAreas,_loc4_);
                  }
                  break;
               case PrismStateEnum.PRISM_STATE_VULNERABLE:
                  _loc9_ = VULNERABLE_AREAS;
                  if(_loc4_)
                  {
                     this.addConquestItem(this.__vulnerableAreas,_loc4_);
                  }
            }
         }
         else
         {
            _loc9_ = CAPTURABLE_AREAS;
            _loc6_ = _loc5_ = 1096297;
            if(_loc4_)
            {
               this.addConquestItem(this.__capturableAreas,_loc4_);
            }
         }
         mapViewer.addAreaShape(_loc9_,"shape" + param1.subAreaId,mapApi.getSubAreaShape(param1.subAreaId),_loc5_,_loc7_,_loc6_,_loc8_);
      }
      
      protected function addConquestItem(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         if(param1)
         {
            _loc4_ = true;
            for each(_loc3_ in param1.children)
            {
               if(_loc3_.data.id == param2.data.id)
               {
                  param1.children[param1.children.indexOf(_loc3_)] = param2;
                  _loc4_ = false;
                  break;
               }
            }
            if(_loc4_)
            {
               param1.children.push(param2);
            }
            param2.parent = param1;
         }
      }
      
      protected function loadMapFilters(param1:Array, param2:String) : void
      {
         var _loc5_:HintCategory = null;
         var _loc3_:int = this.configApi.getConfigProperty("dofus",param2);
         var _loc4_:Object = this.dataApi.getHintCategories();
         for each(_loc5_ in _loc4_)
         {
            param1[_loc5_.id] = _loc3_ & Math.pow(2,_loc5_.id);
         }
      }
      
      protected function saveMapFilters(param1:Array, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         for(_loc4_ in param1)
         {
            if(param1[_loc4_])
            {
               _loc3_ = _loc3_ + Math.pow(2,int(_loc4_));
            }
         }
         this.configApi.setConfigProperty("dofus",param2,_loc3_);
      }
      
      protected function getSubAreaTooltipPosition() : Point
      {
         return this.__subAreaTooltipPosition;
      }
      
      public function onFocusChange(param1:Object) : void
      {
         if(param1 && param1 != mapViewer && param1 != uiApi.getUi("cartographyCurrentMapTooltip") && !(mapViewer as Object).contains(param1))
         {
            rollOutMapAreaShape(__lastAreaShape);
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         super.onRelease(param1);
         switch(param1)
         {
            case mapViewer:
               if(this.__mapMode == MODE_FLAG)
               {
                  this.addCustomFlag(mapViewer.currentMouseMapX,mapViewer.currentMouseMapY);
               }
         }
      }
      
      override public function onMapRollOver(param1:Object, param2:int, param3:int, param4:SubArea = null) : void
      {
         var _loc7_:AllianceWrapper = null;
         var _loc8_:Array = null;
         var _loc9_:PrismSubAreaWrapper = null;
         var _loc10_:* = undefined;
         super.onMapRollOver(param1,param2,param3,param4);
         var _loc5_:SubArea = param4;
         var _loc6_:String = !!param4?param4.name:null;
         if(!_loc5_)
         {
            _loc8_ = getSubAreaFromCoords(param2,param3);
            if(_loc8_)
            {
               _loc5_ = _loc8_[0];
               _loc6_ = _loc8_[1];
            }
         }
         this.__lastSubArea = _loc5_;
         if(!_loc5_)
         {
            return;
         }
         if(_loc5_ && _loc5_.worldmap && _loc5_.worldmap.id == _currentWorldId)
         {
            _loc9_ = __conquestSubAreasInfos && !param4?__conquestSubAreasInfos[_loc5_.id]:null;
            if(_loc9_ && (_loc9_.mapId != -1 || _loc9_.alliance))
            {
               _loc7_ = !_loc9_.alliance?socialApi.getAlliance():_loc9_.alliance;
            }
         }
         if(this.__displaySubAreaToolTip)
         {
            _loc10_ = uiApi.getUi("tooltip_cartographyCurrentSubArea");
            if(!_loc10_)
            {
               uiApi.showTooltip({
                  "mapX":param2,
                  "mapY":param3,
                  "mapElementText":null,
                  "subArea":_loc5_,
                  "subAreaLevel":(!!_loc5_?_loc5_.level:0),
                  "alliance":_loc7_,
                  "updatePositionFunction":this.updateSubAreaTooltipPosition
               },new Rectangle(),false,"cartographyCurrentSubArea",0,0,0,"cartography",null,null,"cartographyCurrentSubArea");
            }
            else
            {
               tooltipApi.update("cartographyCurrentSubArea","subAreaInfo",param2,param3,null,_loc5_,!!_loc5_?_loc5_.level:0,_loc7_);
               this.updateSubAreaTooltipPosition();
            }
         }
      }
      
      override public function onMapRollOut(param1:Object) : void
      {
         super.onMapRollOut(param1);
         rollOutMapAreaShape(__lastAreaShape);
         if(this.__displaySubAreaToolTip)
         {
            uiApi.unloadUi("tooltip_cartographyCurrentSubArea");
         }
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         super.onRollOver(param1);
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case mapViewer:
               if(this.__mapMode == MODE_FLAG)
               {
                  if(!mapViewer.useFlagCursor)
                  {
                     mapViewer.useFlagCursor = true;
                  }
               }
               else if(mapViewer.useFlagCursor)
               {
                  mapViewer.useFlagCursor = false;
               }
               return;
            default:
               if(_loc2_)
               {
                  uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
               }
               return;
         }
      }
      
      override public function onRollOut(param1:Object) : void
      {
         super.onRollOut(param1);
         switch(param1)
         {
            case mapViewer:
               if(this.__mapMode == MODE_FLAG)
               {
                  mapViewer.useFlagCursor = false;
               }
               return;
            default:
               uiApi.hideTooltip();
               return;
         }
      }
      
      private function onGuildInformationsFarms() : void
      {
         var _loc5_:PaddockContentInformations = null;
         var _loc6_:* = undefined;
         var _loc1_:Object = mapViewer.getMapElementsByLayer("layer_7");
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc1_[_loc3_].id.indexOf("guildPaddock_") == 0)
            {
               mapViewer.removeMapElement(_loc1_[_loc3_]);
            }
            _loc3_++;
         }
         var _loc4_:Object = socialApi.getGuildPaddocks();
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = this.dataApi.getSubArea(_loc5_.subAreaId);
            if(_loc6_ && _loc6_.area.superAreaId == superAreaId)
            {
               __hintCaptions["guildPaddock_" + _loc5_.paddockId] = uiApi.processText(uiApi.getText("ui.guild.paddock",_loc5_.maxOutdoorMount),"",_loc5_.maxOutdoorMount == 1);
               mapViewer.addIcon("layer_7","guildPaddock_" + _loc5_.paddockId,this.__hintIconsRootPath + "1002.png",_loc5_.worldX,_loc5_.worldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.PLAYER_POSSESSIONS);
            }
         }
         if(this._waitingForSocialUpdate <= 1)
         {
            this._waitingForSocialUpdate = 0;
            this.updateMap();
         }
         else
         {
            this._waitingForSocialUpdate--;
         }
      }
      
      private function onGuildPaddockAdd(param1:PaddockContentInformations) : void
      {
         if(this.dataApi.getSubArea(param1.subAreaId).area.superAreaId == superAreaId)
         {
            __hintCaptions["guildPaddock_" + param1.paddockId] = uiApi.processText(uiApi.getText("ui.guild.paddock",param1.maxOutdoorMount),"",param1.maxOutdoorMount == 1);
            mapViewer.addIcon("layer_7","guildPaddock_" + param1.paddockId,this.__hintIconsRootPath + "1002.png",param1.worldX,param1.worldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.PLAYER_POSSESSIONS);
            this.updateMap();
         }
      }
      
      private function onGuildPaddockRemoved(param1:uint) : void
      {
         var _loc2_:Object = mapViewer.getMapElementsByLayer("layer_7");
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_].id.indexOf("guildPaddock_" + param1) == 0)
            {
               mapViewer.removeMapElement(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         this.updateMap();
      }
      
      private function onGuildHousesUpdate() : void
      {
         var _loc5_:GuildHouseWrapper = null;
         var _loc1_:Object = socialApi.getGuildHouses();
         var _loc2_:Object = mapViewer.getMapElementsByLayer("layer_7");
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_].id.indexOf("guildHouse_") == 0)
            {
               mapViewer.removeMapElement(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         for each(_loc5_ in _loc1_)
         {
            if(this.dataApi.getSubArea(_loc5_.subareaId).area.superAreaId == superAreaId)
            {
               __hintCaptions["guildHouse_" + _loc5_.houseId] = uiApi.getText("ui.common.guildHouse") + uiApi.getText("ui.common.colon") + _loc5_.houseName;
               mapViewer.addIcon("layer_7","guildHouse_" + _loc5_.houseId,this.__hintIconsRootPath + "1001.png",_loc5_.worldX,_loc5_.worldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.PLAYER_POSSESSIONS);
            }
         }
         if(this._waitingForSocialUpdate <= 1)
         {
            this._waitingForSocialUpdate = 0;
            this.updateMap();
         }
         else
         {
            this._waitingForSocialUpdate--;
         }
      }
      
      private function onGuildHouseAdd(param1:GuildHouseWrapper) : void
      {
         if(this.dataApi.getSubArea(param1.subareaId).area.superAreaId == superAreaId)
         {
            __hintCaptions["guildHouse_" + param1.houseId] = uiApi.getText("ui.common.guildHouse") + uiApi.getText("ui.common.colon") + param1.houseName;
            mapViewer.addIcon("layer_7","guildHouse_" + param1.houseId,this.__hintIconsRootPath + "1001.png",param1.worldX,param1.worldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.PLAYER_POSSESSIONS);
            this.updateMap();
         }
      }
      
      private function onGuildHouseRemoved(param1:uint) : void
      {
         var _loc2_:Object = socialApi.getGuildHouses();
         var _loc3_:Object = mapViewer.getMapElementsByLayer("layer_7");
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_[_loc5_].id.indexOf("guildHouse_" + param1) == 0)
            {
               mapViewer.removeMapElement(_loc3_[_loc5_]);
            }
            _loc5_++;
         }
         this.updateMap();
      }
      
      protected function onTaxCollectorListUpdate() : void
      {
         var _loc6_:TaxCollectorWrapper = null;
         var _loc1_:* = sysApi.getCurrentServer().gameTypeId == 1;
         var _loc2_:Object = mapViewer.getMapElementsByLayer("layer_7");
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_].id.indexOf("guildPony_") == 0)
            {
               mapViewer.removeMapElement(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         var _loc5_:Object = socialApi.getTaxCollectors();
         for each(_loc6_ in _loc5_)
         {
            if(this.dataApi.getSubArea(_loc6_.subareaId).area.superAreaId == superAreaId)
            {
               if(!_loc1_)
               {
                  __hintCaptions["guildPony_" + _loc6_.uniqueId] = uiApi.getText("ui.guild.taxCollectorFullInformations",_loc6_.firstName,_loc6_.lastName,_loc6_.additionalInformation.collectorCallerName,_loc6_.kamas,_loc6_.pods,_loc6_.itemsValue,_loc6_.experience);
               }
               else if(_loc6_.pods > 0)
               {
                  __hintCaptions["guildPony_" + _loc6_.uniqueId] = uiApi.getText("ui.guild.taxCollectorHardcoreInformations.full",_loc6_.firstName,_loc6_.lastName,_loc6_.additionalInformation.collectorCallerName,_loc6_.pods,_loc6_.itemsValue);
               }
               else
               {
                  __hintCaptions["guildPony_" + _loc6_.uniqueId] = uiApi.getText("ui.guild.taxCollectorHardcoreInformations.empty",_loc6_.firstName,_loc6_.lastName,_loc6_.additionalInformation.collectorCallerName);
               }
               mapViewer.addIcon("layer_7","guildPony_" + _loc6_.uniqueId,this.__hintIconsRootPath + "1003.png",_loc6_.mapWorldX,_loc6_.mapWorldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.PLAYER_POSSESSIONS);
            }
         }
         if(this._waitingForSocialUpdate <= 1)
         {
            this._waitingForSocialUpdate = 0;
            this.updateMap();
         }
         else
         {
            this._waitingForSocialUpdate--;
         }
      }
      
      private function onGuildTaxCollectorAdd(param1:TaxCollectorWrapper) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.dataApi.getSubArea(param1.subareaId).area.superAreaId == superAreaId)
         {
            _loc2_ = param1.firstName;
            _loc3_ = param1.lastName;
            __hintCaptions["guildPony_" + param1.uniqueId] = uiApi.getText("ui.guild.taxCollectorFullInformations",_loc2_,_loc3_,param1.additionalInformation.collectorCallerName,param1.kamas,param1.pods,param1.itemsValue,param1.experience);
            mapViewer.addIcon("layer_7","guildPony_" + param1.uniqueId,this.__hintIconsRootPath + "1003.png",param1.mapWorldX,param1.mapWorldY,this.__iconScale,null,false,-1,true,true,null,true,false,HintPriorityEnum.PLAYER_POSSESSIONS);
            this.updateMap();
         }
      }
      
      private function onGuildTaxCollectorRemoved(param1:uint) : void
      {
         var _loc2_:Object = mapViewer.getMapElementsByLayer("layer_7");
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_].id.indexOf("guildPony_" + param1) == 0)
            {
               mapViewer.removeMapElement(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         this.updateMap();
      }
      
      private function onRemoveMapFlag(param1:String, param2:int) : void
      {
         if(param1 == "flag_playerPosition")
         {
            removeFlag(param1);
         }
      }
      
      protected function onMapHintsFilter(param1:int, param2:Boolean, param3:Boolean) : void
      {
         if(!param3)
         {
            this.__hintCategoryFiltersList[param1] = param2;
            mapViewer.showLayer("layer_" + param1,param2);
            this.updateMap();
         }
      }
      
      protected function onPrismsListInformation(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc7_:PrismSubAreaWrapper = null;
         this._myAlliance = socialApi.getAlliance();
         var _loc4_:Object = mapViewer.getMapElementsByLayer("layer_5");
         var _loc5_:int = _loc4_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            mapViewer.removeMapElement(_loc4_[_loc6_]);
            _loc6_++;
         }
         __conquestSubAreasInfos = param1;
         for each(_loc7_ in param1)
         {
            this.updatePrismIcon(_loc7_);
            if(!this.__allAreas)
            {
               this.updatePrismAndSubareaStatus(_loc7_,false);
            }
         }
         this.__normalAreas = {
            "label":uiApi.getText("ui.prism.cartography.normal"),
            "children":[],
            "expend":false,
            "type":"areaShape",
            "layer":NORMAL_AREAS
         };
         this.__weakenedAreas = {
            "label":uiApi.getText("ui.prism.cartography.weakened"),
            "children":[],
            "expend":false,
            "type":"areaShape",
            "layer":WEAKENED_AREAS
         };
         this.__vulnerableAreas = {
            "label":uiApi.getText("ui.prism.cartography.vulnerable"),
            "children":[],
            "expend":false,
            "type":"areaShape",
            "layer":VULNERABLE_AREAS
         };
         this.__capturableAreas = {
            "label":uiApi.getText("ui.pvp.conquestCapturableAreas"),
            "children":[],
            "expend":false,
            "type":"areaShape",
            "layer":CAPTURABLE_AREAS
         };
         this.__sabotagedAreas = {
            "label":uiApi.getText("ui.prism.cartography.sabotaged"),
            "children":[],
            "expend":false,
            "type":"areaShape",
            "layer":SABOTAGED_AREAS
         };
         this.addSubAreasShapes();
         this.updateMap();
         if(this.__allAreas)
         {
            this.__allAreas = null;
         }
      }
      
      protected function onPrismsInfoUpdate(param1:Object) : void
      {
         var _loc2_:PrismSubAreaWrapper = null;
         var _loc3_:int = 0;
         this._myAlliance = socialApi.getAlliance();
         for each(_loc3_ in param1)
         {
            _loc2_ = socialApi.getPrismSubAreaById(_loc3_);
            this.updatePrismIcon(_loc2_);
            this.updatePrismAndSubareaStatus(_loc2_);
         }
         this.updateMap();
      }
      
      public function onMouseShiftClick(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:Object = null;
         if(param1.data == mapViewer)
         {
            _loc2_ = !!param1.params.element?!!__hintCaptions[param1.params.element.id]?__hintCaptions[param1.params.element.id]:param1.params.element.legend:"";
            if(_loc2_.length)
            {
               _loc2_ = _loc2_.split("\n").join(" ") + " ";
            }
            _loc3_ = {
               "x":param1.params.x,
               "y":param1.params.y,
               "worldMapId":this.playerApi.currentSubArea().worldmap.id,
               "elementName":_loc2_
            };
            sysApi.dispatchHook(MouseShiftClick,{
               "data":"Map",
               "params":_loc3_
            });
         }
      }
      
      private function restoreCurrentMapPreset() : Boolean
      {
         var _loc1_:MapPreset = MAP_PRESET[_currentWorldId];
         if(!_loc1_)
         {
            return false;
         }
         if(_lastMapId != -1 && _lastMapId != this.playerApi.currentMap().mapId)
         {
            zoom = mapViewer.mapScale = _loc1_.zoomFactor;
            return false;
         }
         mapViewer.moveToPixel(_loc1_.mapPixelPosition.x,_loc1_.mapPixelPosition.y,_loc1_.zoomFactor);
         zoom = mapViewer.zoomFactor;
         return true;
      }
      
      private function isDungeonMap() : Boolean
      {
         return _currentWorldId != WORLD_OF_INCARNAM && _currentWorldId != WORLD_OF_AMAKNA && _currentWorldId != FRIGOST_III;
      }
      
      private function updateSubAreaTooltipPosition() : void
      {
         var _loc2_:Point = null;
         var _loc1_:Object = uiApi.getUi("tooltip_cartographyCurrentSubArea");
         if(_loc1_)
         {
            _loc1_.visible = this.__lastSubArea != null;
            _loc2_ = this.getSubAreaTooltipPosition();
            _loc1_.x = _loc2_.x;
            _loc1_.y = _loc2_.y;
         }
      }
      
      protected function updateMap() : void
      {
         mapViewer.updateMapElements();
      }
      
      protected function toggleHints() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = !mapViewer.allLayersVisible;
         for(_loc2_ in this.__hintCategoryFiltersList)
         {
            this.__hintCategoryFiltersList[_loc2_] = _loc1_;
         }
         mapViewer.showAllLayers(_loc1_);
      }
      
      protected function insertMapCoordinates(param1:int, param2:int, param3:Object) : void
      {
         this.onMouseShiftClick({
            "data":mapViewer,
            "params":{
               "x":param1,
               "y":param2,
               "element":param3
            }
         });
      }
      
      override protected function createContextMenu(param1:Array = null) : void
      {
         var _loc3_:uint = 0;
         if(!param1)
         {
            param1 = new Array();
         }
         param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.chat.insertCoordinates"),this.insertMapCoordinates,[mapViewer.currentMouseMapX,mapViewer.currentMouseMapY,__currentMapElement]));
         param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.cartography.centerOnPlayer"),this.centerOnPlayer));
         param1.unshift(modContextMenu.createContextMenuSeparatorObject());
         param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.map.toggleAllHints"),this.toggleHints));
         var _loc2_:Array = getSubAreaFromCoords(mapViewer.currentMouseMapX,mapViewer.currentMouseMapY);
         if(_loc2_ && _loc2_[0])
         {
            _loc3_ = socialApi.getTotalDaresInSubArea(_loc2_[0].id);
            if(_loc3_)
            {
               param1.push(modContextMenu.createContextMenuSeparatorObject());
               param1.push(modContextMenu.createContextMenuItemObject(uiApi.processText(uiApi.getText("ui.social.dare.totalAvailable",_loc3_),"",_loc3_ == 1),this.listDaresInSubArea,[_loc2_[1]]));
            }
         }
         super.createContextMenu(param1);
      }
      
      protected function showHints(param1:Array) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            mapViewer.showLayer("layer_" + _loc2_,param1[_loc2_]);
         }
      }
      
      private function listDaresInSubArea(param1:String) : void
      {
         sysApi.dispatchHook(OpenDareSearch,param1,"searchFilterSubArea");
      }
      
      private function centerOnPlayer() : void
      {
         mapViewer.moveTo(this.__playerPos.outdoorX,this.__playerPos.outdoorY);
      }
   }
}

class MapPreset
{
    
   
   public var mapPixelPosition:Object;
   
   public var zoomFactor:Number;
   
   function MapPreset(param1:Object, param2:Number)
   {
      super();
      this.mapPixelPosition = param1;
      this.zoomFactor = param2;
   }
}
