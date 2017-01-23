package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.Dungeon;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.PlaySound;
   import d2enums.DataStoreEnum;
   import d2enums.HintPriorityEnum;
   import d2hooks.FlagAdded;
   import flash.geom.Point;
   import ui.type.Flag;
   
   public class CartographyPopup extends AbstractCartographyUi
   {
      
      private static const HINTS_LAYER:String = "Hints";
      
      private static const AREAS_SHAPES_LAYER:String = "AreasShapes";
      
      private static const FLAGS_LAYER:String = "Flags";
      
      private static const DUNGEONS_LAYER:String = "Dungeons";
       
      
      public var soundApi:SoundApi;
      
      public var dataApi:DataApi;
      
      public var popCtr:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var lbl_subtitle:Label;
      
      public var tx_background:Texture;
      
      public var btn_grid:ButtonContainer;
      
      private var _selectedSubArea:SubArea;
      
      private var _flagUri:String;
      
      private var _iconsUri:String;
      
      private var _dungeons:Array;
      
      private var _notVisible:Vector.<int>;
      
      private var _addingFlag:Boolean;
      
      private var _currentWorldMap:WorldMap;
      
      private var _gridDisplayed:Boolean;
      
      public function CartographyPopup()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         super.main(param1);
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_close.soundId = SoundEnum.WINDOW_CLOSE;
         this.popCtr.getUi().showModalContainer = true;
         this.lbl_title.text = param1.title;
         if(param1.subtitle)
         {
            this.lbl_subtitle.text = param1.subtitle;
         }
         this.popCtr.height = mapViewer.height + 105;
         this.popCtr.width = mapViewer.width + 35;
         this._flagUri = sysApi.getConfigEntry("config.gfx.path") + "icons/assets.swf|flag0";
         this._iconsUri = uiApi.me().getConstant("icons_uri") + "/hints/";
         this._dungeons = new Array();
         this._notVisible = new Vector.<int>();
         uiApi.addComponentHook(this.btn_grid,"onRollOver");
         uiApi.addComponentHook(this.btn_grid,"onRollOut");
         uiApi.addComponentHook(mapViewer,"onRelease");
         sysApi.addHook(FlagAdded,this.onFlagAdded);
         this.initMap(param1.selectedSubareaId,param1.subareaIds);
         this._gridDisplayed = sysApi.getData("ShowMapGrid",DataStoreEnum.BIND_ACCOUNT);
         mapViewer.showGrid = this._gridDisplayed;
         this.btn_grid.selected = this._gridDisplayed;
      }
      
      private function initMap(param1:int, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Hint = null;
         var _loc10_:Array = null;
         var _loc11_:Flag = null;
         var _loc12_:Object = null;
         var _loc13_:Boolean = false;
         this._selectedSubArea = mapApi.getSubArea(param1);
         if(this._selectedSubArea.hasCustomWorldMap)
         {
            _loc13_ = true;
            for each(_loc4_ in param2)
            {
               _loc3_ = this.dataApi.getSubArea(_loc4_);
               if(_loc3_.worldmap)
               {
                  if(_loc3_.hasCustomWorldMap && _loc3_.worldmap.id != this._selectedSubArea.worldmap.id)
                  {
                     _loc13_ = false;
                     break;
                  }
               }
            }
            if(_loc13_)
            {
               this._currentWorldMap = this._selectedSubArea.worldmap;
            }
            else
            {
               this._currentWorldMap = this._selectedSubArea.area.superArea.worldmap;
            }
         }
         else
         {
            this._currentWorldMap = this._selectedSubArea.area.superArea.worldmap;
         }
         if(!this._currentWorldMap)
         {
            return;
         }
         _currentSuperarea = this._selectedSubArea.area.superArea;
         _currentWorldId = this._currentWorldMap.id;
         mapViewer.autoSizeIcon = true;
         mapViewer.origineX = this._currentWorldMap.origineX;
         mapViewer.origineY = this._currentWorldMap.origineY;
         mapViewer.mapWidth = this._currentWorldMap.mapWidth;
         mapViewer.mapHeight = this._currentWorldMap.mapHeight;
         mapViewer.minScale = this._currentWorldMap.minScale;
         mapViewer.maxScale = this._currentWorldMap.maxScale;
         mapViewer.startScale = this._currentWorldMap.minScale;
         mapViewer.removeAllMap();
         for each(_loc5_ in this._currentWorldMap.zoom)
         {
            mapViewer.addMap(parseFloat(_loc5_),uiApi.me().getConstant("maps_uri") + this._currentWorldMap.id + "/" + _loc5_ + "/",this._currentWorldMap.totalWidth,this._currentWorldMap.totalHeight,250,250);
         }
         mapViewer.finalize();
         mapViewer.addLayer(AREAS_SHAPES_LAYER);
         mapViewer.showLayer(AREAS_SHAPES_LAYER,true);
         mapViewer.addLayer(HINTS_LAYER);
         mapViewer.showLayer(HINTS_LAYER,true);
         mapViewer.addLayer(DUNGEONS_LAYER);
         mapViewer.showLayer(DUNGEONS_LAYER,true);
         mapViewer.addLayer(FLAGS_LAYER);
         mapViewer.showLayer(FLAGS_LAYER,true);
         if(this.isDungeon(this._selectedSubArea.id) == -1)
         {
            mapViewer.addAreaShape(AREAS_SHAPES_LAYER,"shape_" + this._selectedSubArea.id,mapApi.getSubAreaShape(this._selectedSubArea.id),16711680,0.5,16711680,0.5);
         }
         this.addSubAreaPositionFlag(this._selectedSubArea.id,16711680);
         if(param2)
         {
            for each(_loc4_ in param2)
            {
               if(_loc4_ != this._selectedSubArea.id)
               {
                  if(this.isDungeon(_loc4_) == -1)
                  {
                     mapViewer.addAreaShape(AREAS_SHAPES_LAYER,"shape_" + _loc4_,mapApi.getSubAreaShape(_loc4_),16711680,0.3,16711680,0.3);
                  }
                  this.addSubAreaPositionFlag(_loc4_,16711680);
               }
            }
         }
         var _loc6_:Object = mapViewer.getMapElementsByLayer(AREAS_SHAPES_LAYER);
         for each(_loc7_ in _loc6_)
         {
            mapViewer.areaShapeColorTransform(_loc7_,100,1,1,1,1);
         }
         _loc8_ = mapApi.getHints();
         for each(_loc9_ in _loc8_)
         {
            if(!(_loc9_.worldMapId != this._selectedSubArea.worldmap.id || _loc9_.categoryId != 9))
            {
               switch(_loc9_.gfx)
               {
                  case 410:
                  case 412:
                  case 413:
                  case 433:
                  case 900:
                     mapViewer.addIcon(HINTS_LAYER,"hint_" + _loc9_.id,this._iconsUri + _loc9_.gfx + ".png",_loc9_.x,_loc9_.y,1,_loc9_.name,false,-1,true,true,null,true,false,HintPriorityEnum.TRANSPORTS);
                  default:
                     mapViewer.addIcon(HINTS_LAYER,"hint_" + _loc9_.id,this._iconsUri + _loc9_.gfx + ".png",_loc9_.x,_loc9_.y,1,_loc9_.name,false,-1,true,true,null,true,false,HintPriorityEnum.TRANSPORTS);
               }
            }
         }
         _loc10_ = modCartography.getFlags(this._currentWorldMap.id);
         for each(_loc11_ in _loc10_)
         {
            if(_loc11_.id.indexOf("flag_custom") != -1 && !mapViewer.getMapElement(_loc11_.id))
            {
               addCustomFlag(_loc11_.position.x,_loc11_.position.y);
            }
         }
         mapViewer.onMapElementsUpdated = this.onMapElementsUpdated;
         mapViewer.updateMapElements();
         _loc12_ = this.getSubAreaCenter(this._selectedSubArea.id);
         if(_loc12_)
         {
            mapViewer.moveTo(_loc12_.x,_loc12_.y);
         }
      }
      
      private function onMapElementsUpdated() : void
      {
         zoom = mapViewer.minScale;
      }
      
      private function addFlag(param1:int, param2:int, param3:String, param4:String = null, param5:Number = 1, param6:String = null, param7:int = -1, param8:Boolean = true) : void
      {
         mapViewer.addIcon(FLAGS_LAYER,param3,param4,param1,param2,param5,param6,true,param7,true,param8,null,true,false,HintPriorityEnum.FLAGS);
      }
      
      private function addSubAreaPositionFlag(param1:int, param2:int) : void
      {
         var _loc5_:String = null;
         var _loc3_:SubArea = mapApi.getSubArea(param1);
         if(!_loc3_.worldmap || _loc3_.worldmap.id != currentWorldId)
         {
            return;
         }
         var _loc4_:Object = this.getSubAreaCenter(param1);
         if(_loc4_)
         {
            if(!this._dungeons[param1])
            {
               if(this._notVisible.indexOf(param1) != -1)
               {
                  _loc5_ = this._flagUri;
               }
               this.addFlag(_loc4_.x,_loc4_.y,"flag_" + param1,_loc5_,2,_loc3_.area.name + " - " + _loc3_.name,param2);
            }
            else
            {
               mapViewer.addIcon(DUNGEONS_LAYER,"dungeon_" + param1,this._iconsUri + "422.png",_loc4_.x,_loc4_.y,1,_loc3_.name,true,-1,true,true,null,true,false,HintPriorityEnum.FLAGS);
            }
         }
      }
      
      private function isDungeon(param1:int) : int
      {
         var _loc3_:MapPosition = null;
         var _loc5_:Object = null;
         var _loc6_:MapPosition = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:SubArea = this.dataApi.getSubArea(param1);
         var _loc4_:Object = this.dataApi.getDungeons();
         _loc7_ = this.dataApi.queryEquals(Dungeon,"mapIds",_loc2_.mapIds);
         if(_loc7_.length > 0)
         {
            _loc5_ = this.dataApi.getDungeon(_loc7_[0]);
            if(_loc5_.mapIds.length == _loc2_.mapIds.length)
            {
               this._dungeons[param1] = _loc7_[0];
               return _loc7_[0];
            }
            _loc4_ = [_loc5_];
         }
         for each(_loc5_ in _loc4_)
         {
            _loc9_ = 0;
            if(_loc5_.mapIds.length > _loc2_.mapIds.length)
            {
               for each(_loc8_ in _loc2_.mapIds)
               {
                  if(_loc5_.mapIds.indexOf(_loc8_) != -1)
                  {
                     _loc9_++;
                  }
               }
               if(_loc9_ == _loc2_.mapIds.length)
               {
                  this._dungeons[param1] = _loc5_.id;
                  return _loc5_.id;
               }
            }
            else
            {
               for each(_loc8_ in _loc5_.mapIds)
               {
                  if(_loc2_.mapIds.indexOf(_loc8_) != -1)
                  {
                     _loc9_++;
                  }
               }
               if(_loc9_ == _loc5_.mapIds.length)
               {
                  this._dungeons[param1] = _loc5_.id;
                  return _loc5_.id;
               }
            }
            _loc6_ = mapApi.getMapPositionById(_loc5_.entranceMapId);
            if(_loc6_)
            {
               for each(_loc8_ in _loc2_.mapIds)
               {
                  _loc3_ = mapApi.getMapPositionById(_loc8_);
                  if(_loc3_ && (_loc3_.posX != _loc6_.posX || _loc3_.posY != _loc6_.posY))
                  {
                     return -1;
                  }
               }
               this._dungeons[param1] = _loc5_.id;
               return _loc5_.id;
            }
         }
         return -1;
      }
      
      private function getSubAreaCenter(param1:int) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:MapPosition = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:MapPosition = null;
         if(this._dungeons[param1])
         {
            _loc3_ = this.dataApi.getDungeon(this._dungeons[param1]);
            _loc4_ = mapApi.getMapPositionById(_loc3_.entranceMapId);
            return new Point(_loc4_.posX,_loc4_.posY);
         }
         var _loc2_:Object = mapApi.getSubAreaCenter(param1);
         if(!_loc2_)
         {
            _loc5_ = mapApi.getSubArea(param1);
            for each(_loc6_ in _loc5_.mapIds)
            {
               _loc7_ = mapApi.getMapPositionById(_loc6_);
               if(_loc7_)
               {
                  this._notVisible.push(param1);
                  return new Point(_loc7_.posX,_loc7_.posY);
               }
            }
            return null;
         }
         return _loc2_;
      }
      
      private function onFlagAdded(param1:String, param2:int, param3:int, param4:int, param5:int, param6:String, param7:Boolean = true, param8:Boolean = false) : void
      {
         sysApi.sendAction(new PlaySound("16039"));
         if(param1.indexOf("flag_custom") != -1 && !mapViewer.getMapElement(param1))
         {
            mapViewer.addIcon(FLAGS_LAYER,param1,this._flagUri,param3,param4,1,param6,true,param5,true,param7,null,true,false,HintPriorityEnum.FLAGS);
         }
         mapViewer.updateMapElements();
      }
      
      override protected function onFlagRemoved(param1:String, param2:int) : void
      {
         super.onFlagRemoved(param1,param2);
         removeFlag(param1);
      }
      
      override public function unload() : void
      {
         super.unload();
      }
      
      override public function onMapElementRightClick(param1:Object, param2:Object) : void
      {
         if(param2.id.indexOf("flag_custom") != -1)
         {
            super.onMapElementRightClick(param1,param2);
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         super.onRelease(param1);
         switch(param1)
         {
            case this.btn_close:
               uiApi.unloadUi(uiApi.me().name);
               break;
            case this.btn_grid:
               this._gridDisplayed = !sysApi.getData("ShowMapGrid",DataStoreEnum.BIND_ACCOUNT);
               sysApi.setData("ShowMapGrid",this._gridDisplayed,DataStoreEnum.BIND_ACCOUNT);
               mapViewer.showGrid = this._gridDisplayed;
               this.btn_grid.selected = this._gridDisplayed;
               break;
            case mapViewer:
               if(this._addingFlag)
               {
                  addCustomFlag(mapViewer.currentMouseMapX,mapViewer.currentMouseMapY);
               }
         }
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         super.onRollOver(param1);
         switch(param1)
         {
            case mapViewer:
               if(!mapViewer.useFlagCursor && this._addingFlag)
               {
                  mapViewer.useFlagCursor = true;
               }
               break;
            case this.btn_grid:
               _loc2_ = uiApi.getText("ui.option.displayGrid");
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      override public function onRollOut(param1:Object) : void
      {
         super.onRollOut(param1);
         if(param1 == mapViewer)
         {
            if(this._addingFlag)
            {
               mapViewer.useFlagCursor = false;
            }
         }
         else
         {
            uiApi.hideTooltip();
         }
      }
   }
}
