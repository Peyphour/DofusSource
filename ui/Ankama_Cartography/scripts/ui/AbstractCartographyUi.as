package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.MapViewer;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2enums.ComponentHookList;
   import d2enums.EventEnums;
   import d2enums.ShortcutHookListEnum;
   import d2enums.StrataEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.CloseContextMenu;
   import d2hooks.FlagRemoved;
   import d2hooks.KeyUp;
   import d2hooks.RemoveAllFlags;
   import d2hooks.UiLoaded;
   import flash.utils.Dictionary;
   import ui.type.Flag;
   
   public class AbstractCartographyUi
   {
      
      private static const MAX_CUSTOM_FLAGS:int = 6;
      
      protected static var _nbCustomFlags:Array = new Array();
      
      protected static var __currentMapTooltip;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var mapApi:MapApi;
      
      public var menuApi:ContextMenuApi;
      
      public var tooltipApi:TooltipApi;
      
      public var socialApi:SocialApi;
      
      public var bindsApi:BindsApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Cartography")]
      public var modCartography:Object;
      
      public var mapViewer:MapViewer;
      
      public var btn_zoomIn:ButtonContainer;
      
      public var btn_zoomOut:ButtonContainer;
      
      protected var _currentSuperarea:Object;
      
      protected var _currentWorldId:int;
      
      protected var __currentMapElement:Object;
      
      protected var __showMapAreaShape:Boolean = true;
      
      protected var __areaShapeDisplayed:Array;
      
      protected var __lastAreaShape:String = "";
      
      protected var __conquestSubAreasInfos:Object;
      
      protected var __hintCaptions:Dictionary;
      
      protected var __contextMenuIsActive:Boolean;
      
      protected var __lastMx:Number;
      
      protected var __lastMy:Number;
      
      private var _lastSubAreaId:int;
      
      private var _mouseOnMapViewer:Boolean;
      
      private var _zoomValue:Number = 1;
      
      protected var minValue:Number = 0.2;
      
      protected var maxValue:Number = 1;
      
      public function AbstractCartographyUi()
      {
         this.__areaShapeDisplayed = new Array();
         this.__hintCaptions = new Dictionary();
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         if(!__currentMapTooltip)
         {
            __currentMapTooltip = this.uiApi.loadUi("cartographyTooltip","cartographyCurrentMapTooltip",{
               "mapX":0,
               "mapY":0,
               "subAreaId":-1,
               "mapElements":[],
               "mouseOnArrow":this.mapViewer.mouseOnArrow
            },StrataEnum.STRATA_TOOLTIP,null,true);
            __currentMapTooltip.visible = false;
         }
         this._lastSubAreaId = -1;
         this.__contextMenuIsActive = false;
         this.sysApi.addHook(FlagRemoved,this.onFlagRemoved);
         this.uiApi.addComponentHook(this.mapViewer,EventEnums.EVENT_ONRIGHTCLICK);
         this.uiApi.addComponentHook(this.mapViewer,EventEnums.EVENT_ONMAPELEMENTRIGHTCLICK);
         this.uiApi.addComponentHook(this.mapViewer,ComponentHookList.ON_MAP_ELEMENT_ROLL_OVER);
         this.uiApi.addComponentHook(this.mapViewer,ComponentHookList.ON_MAP_ELEMENT_ROLL_OUT);
         this.uiApi.addComponentHook(this.mapViewer,EventEnums.EVENT_ONDOUBLECLICK);
         this.uiApi.addComponentHook(this.mapViewer,EventEnums.EVENT_ONMAPMOVE);
         this.uiApi.addComponentHook(this.mapViewer,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.mapViewer,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.mapViewer,EventEnums.EVENT_ONMAPROLLOVER);
         this.uiApi.addComponentHook(this.mapViewer,EventEnums.EVENT_ONMAPROLLOUT);
         this.uiApi.addComponentHook(this.mapViewer,ComponentHookList.ON_PRESS);
         this.uiApi.addComponentHook(this.btn_zoomIn,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_zoomIn,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_zoomIn,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_zoomOut,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_zoomOut,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_zoomOut,ComponentHookList.ON_ROLL_OUT);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onCloseUi);
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
      }
      
      public function get superAreaId() : int
      {
         if(this._currentSuperarea)
         {
            return this._currentSuperarea.id;
         }
         return -1;
      }
      
      public function get currentWorldId() : int
      {
         return this._currentWorldId;
      }
      
      public function unload() : void
      {
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         var _loc3_:Object = null;
         if(__currentMapTooltip && __currentMapTooltip.visible)
         {
            _loc3_ = this.bindsApi.getShortcutsFromKeyCode(param2);
            if(_loc3_ && _loc3_.name == ShortcutHookListEnum.CAPTURE_SCREEN)
            {
               return;
            }
         }
         this.hideCurrentMapTooltip();
      }
      
      protected function addCustomFlag(param1:int, param2:int) : void
      {
         var _loc4_:Flag = null;
         var _loc6_:Boolean = false;
         this.mapViewer.enabledDrag = true;
         this.mapViewer.useFlagCursor = false;
         var _loc3_:String = "flag_custom_" + param1 + "_" + param2;
         var _loc5_:Array = this.modCartography.getFlags(this._currentWorldId);
         for each(_loc4_ in _loc5_)
         {
            if(_loc4_.id == _loc3_)
            {
               _loc6_ = true;
               break;
            }
         }
         if(!_loc6_)
         {
            if(!_nbCustomFlags[this._currentWorldId])
            {
               _nbCustomFlags[this._currentWorldId] = 1;
            }
            else if(_nbCustomFlags[this._currentWorldId] < MAX_CUSTOM_FLAGS)
            {
               _nbCustomFlags[this._currentWorldId]++;
            }
            else
            {
               return;
            }
         }
         this.sysApi.dispatchHook(AddMapFlag,_loc3_,this.uiApi.getText("ui.cartography.customFlag") + " (" + param1 + "," + param2 + ")",this._currentWorldId,param1,param2,16768256);
      }
      
      protected function addCustomFlagWithRightClick(param1:Number, param2:Number) : void
      {
         this.mapViewer.enabledDrag = false;
         this.addCustomFlag(param1,param2);
      }
      
      protected function createContextMenu(param1:Array = null) : void
      {
         if(!param1)
         {
            param1 = new Array();
         }
         param1.unshift(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.map.removeAllFlags"),this.removeAllFlags,[]));
         param1.unshift(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.map.flag"),this.addCustomFlagWithRightClick,[this.mapViewer.currentMouseMapX,this.mapViewer.currentMouseMapY],_nbCustomFlags[this._currentWorldId] && _nbCustomFlags[this._currentWorldId] >= MAX_CUSTOM_FLAGS));
         this.modContextMenu.createContextMenu(param1,null,this.onContextMenuClose);
      }
      
      public function removeFlag(param1:String) : void
      {
         var _loc2_:Object = this.mapViewer.getMapElement(param1);
         if(_loc2_)
         {
            this.mapViewer.removeMapElement(_loc2_);
         }
      }
      
      private function removeAllFlags() : void
      {
         this.sysApi.dispatchHook(RemoveAllFlags);
      }
      
      protected function getSubAreaFromCoords(param1:int, param2:int) : Array
      {
         var _loc4_:uint = 0;
         var _loc5_:MapPosition = null;
         var _loc6_:SubArea = null;
         var _loc7_:SubArea = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc3_:Object = this.mapApi.getMapIdByCoord(param1,param2);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = this.mapApi.getMapPositionById(_loc4_);
            if(_loc5_.worldMap != -1 && (!_loc6_ || _loc5_.hasPriorityOnWorldmap))
            {
               _loc7_ = _loc5_.subArea;
               if(_loc7_ && _loc7_.worldmap && _loc7_.worldmap.id == this._currentWorldId)
               {
                  _loc6_ = _loc7_;
                  if(_loc5_.name && _loc5_.name.length > 0)
                  {
                     _loc8_ = _loc5_.name;
                  }
                  else
                  {
                     _loc8_ = _loc6_.name;
                  }
               }
            }
         }
         if(_loc6_)
         {
            _loc9_ = [_loc6_,_loc8_];
         }
         return _loc9_;
      }
      
      protected function rollOutMapAreaShape(param1:String) : void
      {
         var _loc2_:Object = this.mapViewer.getMapElement(param1);
         if(_loc2_)
         {
            if(this.__areaShapeDisplayed.indexOf(_loc2_.layer) == -1)
            {
               this.mapViewer.areaShapeColorTransform(_loc2_,100,1,1,1,0);
            }
            else
            {
               this.mapViewer.areaShapeColorTransform(_loc2_,100,1,1,1,1);
            }
         }
      }
      
      protected function rollOverMapAreaShape(param1:String) : void
      {
         var _loc2_:Object = this.mapViewer.getMapElement(param1);
         if(_loc2_)
         {
            if(this.__areaShapeDisplayed.indexOf(_loc2_.layer) == -1)
            {
               this.mapViewer.areaShapeColorTransform(_loc2_,100,1,1,1,1);
            }
            else
            {
               this.mapViewer.areaShapeColorTransform(_loc2_,100,1.2,1.2,1.2,1.5);
            }
         }
      }
      
      protected function onFlagRemoved(param1:String, param2:int) : void
      {
         if(param1.indexOf("flag_custom") != -1 && _nbCustomFlags[param2] && _nbCustomFlags[param2] > 0)
         {
            _nbCustomFlags[param2]--;
         }
         var _loc3_:* = this.uiApi.getUi("cartographyCurrentMapTooltip");
         if(_loc3_ && _loc3_.uiClass.hasElement(param1))
         {
            this.onMapRollOver(null,this.__lastMx,this.__lastMy);
         }
      }
      
      protected function onContextMenuClose() : void
      {
         this.__contextMenuIsActive = false;
      }
      
      public function onPress(param1:Object) : void
      {
         __currentMapTooltip.visible = false;
         if(param1 == this.mapViewer)
         {
            this.sysApi.dispatchHook(CloseContextMenu);
         }
      }
      
      public function onMapMove(param1:Object) : void
      {
         this.zoom = this.mapViewer.zoomFactor;
         this.__currentMapElement = null;
      }
      
      protected function get zoom() : Number
      {
         return this._zoomValue;
      }
      
      protected function set zoom(param1:Number) : void
      {
         this.normalizeValue(param1);
      }
      
      private function normalizeValue(param1:Number = NaN) : void
      {
         var _loc2_:Number = !!isNaN(param1)?Number(this._zoomValue):Number(param1);
         if(this.minValue < this.maxValue)
         {
            if(_loc2_ > this.maxValue)
            {
               _loc2_ = this.maxValue;
            }
            if(_loc2_ < this.minValue)
            {
               _loc2_ = this.minValue;
            }
         }
         else
         {
            if(_loc2_ < this.maxValue)
            {
               _loc2_ = this.maxValue;
            }
            if(_loc2_ > this.minValue)
            {
               _loc2_ = this.minValue;
            }
         }
         if(_loc2_ != this._zoomValue)
         {
            this._zoomValue = _loc2_;
            try
            {
               this.mapViewer.zoom(this._zoomValue);
               return;
            }
            catch(e:Error)
            {
               return;
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_zoomIn:
               this.zoom = this.zoom + (this.mapViewer.maxScale - this.mapViewer.minScale) / 5;
               break;
            case this.btn_zoomOut:
               this.zoom = this.zoom - (this.mapViewer.maxScale - this.mapViewer.minScale) / 5;
         }
      }
      
      public function onCloseUi(param1:String) : Boolean
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
         return true;
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         switch(param1)
         {
            case this.mapViewer:
               if(this.sysApi.hasRight())
               {
                  this.mapApi.movePlayer(this.mapViewer.currentMouseMapX,this.mapViewer.currentMouseMapY);
               }
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         if(param1 == this.mapViewer)
         {
            this.createContextMenu();
            this.__contextMenuIsActive = true;
            this.hideCurrentMapTooltip();
         }
      }
      
      public function onMapElementRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         if(param2.id.indexOf("flag_playerPosition") != -1)
         {
            return;
         }
         _loc3_ = this.menuApi.create(param2,"mapFlag",[this._currentWorldId]);
         if(_loc3_.content.length > 0)
         {
            this.modContextMenu.createContextMenu(_loc3_,null,this.onContextMenuClose);
            this.__contextMenuIsActive = true;
         }
      }
      
      public function onMapElementRollOut(param1:Object, param2:Object) : void
      {
         this.__currentMapElement = null;
         if(this._mouseOnMapViewer)
         {
            this.onMapRollOver(param1,param1.currentMouseMapX,param1.currentMouseMapY);
         }
      }
      
      public function onMapElementRollOver(param1:Object, param2:Object) : void
      {
         if(this.__currentMapElement != param2)
         {
            this.__currentMapElement = param2;
            this.onMapRollOver(param1,param2.x,param2.y);
         }
      }
      
      public function onMapRollOver(param1:Object, param2:int, param3:int, param4:SubArea = null) : void
      {
         var _loc6_:Object = null;
         var _loc8_:String = null;
         var _loc12_:Object = null;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         if(this.__lastMx == param2 && this.__lastMy == param3 || this.uiApi.getMouseDown())
         {
            return;
         }
         this.__lastMx = param2;
         this.__lastMy = param3;
         var _loc5_:Array = [];
         var _loc7_:Object = this.mapViewer.getMapElementsAtCoordinates(param2,param3);
         if(_loc7_.length)
         {
            for each(_loc12_ in _loc7_)
            {
               if(this.mapViewer.isLayerVisible(_loc12_.layer))
               {
                  _loc6_ = _loc12_;
                  _loc5_.push({
                     "element":_loc6_,
                     "text":(!!this.__hintCaptions[_loc6_.id]?this.__hintCaptions[_loc6_.id]:_loc6_.legend)
                  });
               }
            }
         }
         var _loc9_:SubArea = param4;
         var _loc10_:String = !!param4?param4.name:null;
         var _loc11_:Boolean = false;
         if(!_loc9_)
         {
            _loc13_ = this.getSubAreaFromCoords(param2,param3);
            if(_loc13_)
            {
               _loc9_ = _loc13_[0];
               _loc10_ = _loc13_[1];
            }
         }
         if(_loc9_ && _loc9_.worldmap && _loc9_.worldmap.id == this._currentWorldId)
         {
            if(_loc9_.id != this._lastSubAreaId)
            {
               _loc11_ = true;
               this._lastSubAreaId = _loc9_.id;
            }
            _loc14_ = !!param4?"search_shape":"shape";
            _loc8_ = _loc14_ + _loc9_.id;
            if(_loc8_ != this.__lastAreaShape)
            {
               if(this.__showMapAreaShape)
               {
                  this.rollOutMapAreaShape(this.__lastAreaShape);
               }
               this.__lastAreaShape = _loc8_;
               if(this.__showMapAreaShape)
               {
                  this.rollOverMapAreaShape(_loc8_);
               }
            }
         }
         else
         {
            this.rollOutMapAreaShape(this.__lastAreaShape);
            this.__lastAreaShape = "";
         }
         if(!_loc9_ && this._lastSubAreaId != -1)
         {
            _loc11_ = true;
            this._lastSubAreaId = -1;
         }
         this.showCurrentMapTooltip(_loc5_);
      }
      
      public function onMapRollOut(param1:Object) : void
      {
         this.__currentMapElement = null;
         this.hideCurrentMapTooltip();
      }
      
      protected function showCurrentMapTooltip(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(__currentMapTooltip)
         {
            __currentMapTooltip.visible = true;
            __currentMapTooltip.uiClass.update({
               "mapX":this.__lastMx,
               "mapY":this.__lastMy,
               "subAreaId":this._lastSubAreaId,
               "mapElements":param1,
               "mouseOnArrow":this.mapViewer.mouseOnArrow
            });
            _loc2_ = this.uiApi.getVisibleStageBounds();
            _loc3_ = this.mapViewer.currentMapBounds;
            _loc4_ = _loc3_.x + _loc3_.width + 4;
            _loc5_ = _loc3_.y + _loc3_.height + 4;
            if(-_loc2_.x + _loc4_ + __currentMapTooltip.width > _loc2_.width)
            {
               _loc4_ = _loc3_.x - __currentMapTooltip.width;
            }
            if(-_loc2_.y + _loc5_ + __currentMapTooltip.uiClass.totalHeight > _loc2_.height)
            {
               _loc5_ = _loc3_.y - __currentMapTooltip.uiClass.totalHeight;
            }
            __currentMapTooltip.x = _loc4_ < _loc2_.x?_loc2_.x:_loc4_;
            __currentMapTooltip.y = _loc5_ < _loc2_.y?_loc2_.y:_loc5_;
         }
      }
      
      protected function showAreaShape(param1:String, param2:Boolean) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         if(param2)
         {
            _loc3_ = this.mapViewer.getMapElementsByLayer(param1);
            if(this.__areaShapeDisplayed.indexOf(param1) == -1 && _loc3_ && _loc3_.length != 0)
            {
               this.__areaShapeDisplayed.push(param1);
               _loc4_ = _loc3_.length;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  this.mapViewer.areaShapeColorTransform(_loc3_[_loc5_],100,1,1,1,1);
                  _loc5_++;
               }
            }
         }
         else
         {
            _loc3_ = this.mapViewer.getMapElementsByLayer(param1);
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.mapViewer.areaShapeColorTransform(_loc3_[_loc5_],100,1,1,1,0);
               _loc5_++;
            }
         }
      }
      
      protected function hideCurrentMapTooltip() : void
      {
         if(__currentMapTooltip)
         {
            __currentMapTooltip.visible = false;
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         if(param1 == this.mapViewer)
         {
            this._mouseOnMapViewer = false;
            this.__lastMx = Number.NaN;
            this.__lastMy = Number.NaN;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         if(param1 == this.mapViewer)
         {
            this._mouseOnMapViewer = true;
         }
      }
      
      public function onUiLoaded(param1:String) : void
      {
         if(param1 == "Ankama_ContextMenu" && this._mouseOnMapViewer)
         {
            this.__contextMenuIsActive = true;
         }
      }
   }
}
