package ui
{
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import d2actions.OpenCurrentFight;
   import d2hooks.AddMapFlag;
   import d2hooks.HighlightInteractiveElements;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.MapFightCount;
   import d2hooks.ShowEntitiesTooltips;
   
   public class BannerMap extends CartographyBase
   {
      
      private static var _nFightCount:uint = 0;
      
      private static var _shortcutColor:String;
       
      
      public var tx_separator:TextureBitmap;
      
      public var btn_showEntitiesTooltips:ButtonContainer;
      
      public var btn_highlightInteractiveElements:ButtonContainer;
      
      public var btn_viewFights:ButtonContainer;
      
      public var mainCtr:GraphicContainer;
      
      private var _entitiesTooltipsVisible:Boolean;
      
      private var _interactiveElementsHighlighted:Boolean;
      
      private var _centerOnPlayer:Boolean = true;
      
      private var _hintCategoryNames:Array;
      
      private var _hintCategoryFiltersList:Array;
      
      public function BannerMap()
      {
         this._hintCategoryFiltersList = new Array();
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         this._hintCategoryNames = [uiApi.getText("ui.map.temple"),uiApi.getText("ui.map.bidHouse"),uiApi.getText("ui.map.craftHouse"),uiApi.getText("ui.common.misc"),uiApi.getText("ui.map.conquest"),uiApi.getText("ui.map.dungeon"),uiApi.getText("ui.common.possessions"),uiApi.getText("ui.cartography.flags"),uiApi.getText("ui.cartography.transport")];
         var _loc2_:int = 0;
         while(_loc2_ < this._hintCategoryNames.length)
         {
            this._hintCategoryFiltersList[_loc2_ + 1] = true;
            _loc2_++;
         }
         __animatedPlayerPosition = false;
         __displaySubAreaToolTip = false;
         mapViewer.finalized = false;
         mapViewer.gridLineThickness = 1;
         super.main(param1);
         gridDisplayed = true;
         uiApi.addComponentHook(this.btn_showEntitiesTooltips,"onPress");
         uiApi.addComponentHook(this.btn_showEntitiesTooltips,"onMouseUp");
         uiApi.addComponentHook(this.btn_showEntitiesTooltips,"onRollOver");
         uiApi.addComponentHook(this.btn_showEntitiesTooltips,"onRollOut");
         uiApi.addComponentHook(this.btn_highlightInteractiveElements,"onPress");
         uiApi.addComponentHook(this.btn_highlightInteractiveElements,"onMouseUp");
         uiApi.addComponentHook(this.btn_highlightInteractiveElements,"onRollOver");
         uiApi.addComponentHook(this.btn_highlightInteractiveElements,"onRollOut");
         uiApi.addComponentHook(this.btn_viewFights,"onRollOver");
         uiApi.addComponentHook(this.btn_viewFights,"onRollOut");
         sysApi.addHook(MapComplementaryInformationsData,this.onMapComplementaryInformationsData);
         sysApi.addHook(d2hooks.ShowEntitiesTooltips,this.onShowEntitiesTooltips);
         sysApi.addHook(d2hooks.HighlightInteractiveElements,this.onHighlightInteractiveElements);
         sysApi.addHook(MapFightCount,this.onMapFightCount);
         uiApi.addShortcutHook("flagCurrentMap",this.onShortcut);
         this.btn_viewFights.softDisabled = _nFightCount == 0;
      }
      
      public function hide() : void
      {
         this.mainCtr.visible = false;
      }
      
      public function show() : void
      {
         this.mainCtr.visible = true;
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_viewFights:
               if(!uiApi.getUi(UIEnum.SPECTATOR_UI))
               {
                  if(_nFightCount > 0)
                  {
                     sysApi.sendAction(new OpenCurrentFight());
                  }
               }
               else
               {
                  uiApi.unloadUi(UIEnum.SPECTATOR_UI);
               }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:MapPosition = null;
         var _loc3_:String = null;
         switch(param1)
         {
            case "flagCurrentMap":
               _loc2_ = dataApi.getMapInfo(playerApi.currentMap().mapId);
               _loc3_ = "flag_custom_" + _loc2_.posX + "_" + _loc2_.posY;
               sysApi.dispatchHook(AddMapFlag,_loc3_,uiApi.getText("ui.cartography.customFlag") + " (" + _loc2_.posX + "," + _loc2_.posY + ")",_loc2_.worldMap,_loc2_.posX,_loc2_.posY,16768256,true);
               return true;
            default:
               return false;
         }
      }
      
      override public function onCloseUi(param1:String) : Boolean
      {
         return false;
      }
      
      override public function onPress(param1:Object) : void
      {
         super.onPress(param1);
         switch(param1)
         {
            case this.btn_showEntitiesTooltips:
               if(!this._entitiesTooltipsVisible)
               {
                  sysApi.sendAction(new d2actions.ShowEntitiesTooltips(false));
               }
               break;
            case this.btn_highlightInteractiveElements:
               if(!this._interactiveElementsHighlighted)
               {
                  sysApi.sendAction(new d2actions.HighlightInteractiveElements(false));
               }
         }
      }
      
      public function onMouseUp(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_showEntitiesTooltips:
               if(this._entitiesTooltipsVisible)
               {
                  sysApi.sendAction(new d2actions.ShowEntitiesTooltips(false));
               }
               break;
            case this.btn_highlightInteractiveElements:
               if(this._interactiveElementsHighlighted)
               {
                  sysApi.sendAction(new d2actions.HighlightInteractiveElements(false));
               }
         }
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         if(!this.mainCtr.visible)
         {
            return;
         }
         super.onRollOver(param1);
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:String = null;
         switch(param1)
         {
            case this.btn_showEntitiesTooltips:
               _loc6_ = "ui.option.entitiesTooltips.hold";
               _loc5_ = bindsApi.getShortcutBindStr("showEntitiesTooltips");
               break;
            case this.btn_highlightInteractiveElements:
               _loc6_ = "ui.option.highlightInteractiveElements.hold";
               _loc5_ = bindsApi.getShortcutBindStr("highlightInteractiveElements");
               break;
            case this.btn_viewFights:
               _loc2_ = uiApi.getText("ui.fightsOnMap",_nFightCount);
               _loc2_ = uiApi.processText(_loc2_,"m",_nFightCount < 2);
         }
         if(_loc2_ || _loc6_)
         {
            if(_loc5_)
            {
               if(!_shortcutColor)
               {
                  _shortcutColor = sysApi.getConfigEntry("colors.shortcut");
                  _shortcutColor = _shortcutColor.replace("0x","#");
               }
               if(_loc2_)
               {
                  _loc7_ = uiApi.textTooltipInfo(_loc2_ + " <font color=\'" + _shortcutColor + "\'>(" + _loc5_ + ")</font>");
               }
               else if(_loc6_)
               {
                  _loc7_ = uiApi.textTooltipInfo(uiApi.getText(_loc6_,"<font color=\'" + _shortcutColor + "\'>(" + _loc5_ + ")</font>"));
               }
            }
            else
            {
               _loc7_ = uiApi.textTooltipInfo(_loc2_);
            }
            uiApi.showTooltip(_loc7_,param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      override public function onRollOut(param1:Object) : void
      {
         if(!this.mainCtr.visible)
         {
            return;
         }
         super.onRollOut(param1);
      }
      
      override public function onMapRollOver(param1:Object, param2:int, param3:int, param4:SubArea = null) : void
      {
         if(!this.mainCtr.visible)
         {
            return;
         }
         super.onMapRollOver(param1,param2,param3,param4);
      }
      
      override public function onMapRollOut(param1:Object) : void
      {
         if(!this.mainCtr.visible)
         {
            return;
         }
         super.onMapRollOut(param1);
      }
      
      override public function onMapElementRollOut(param1:Object, param2:Object) : void
      {
         if(!this.mainCtr.visible)
         {
            return;
         }
         super.onMapElementRollOut(param1,param2);
      }
      
      override public function onMapElementRollOver(param1:Object, param2:Object) : void
      {
         if(!this.mainCtr.visible)
         {
            return;
         }
         super.onMapElementRollOver(param1,param2);
      }
      
      override protected function createContextMenu(param1:Array = null) : void
      {
         if(!param1)
         {
            param1 = new Array();
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this._hintCategoryNames.length)
         {
            _loc2_.push(modContextMenu.createContextMenuItemObject(this._hintCategoryNames[_loc3_],this.showFilter,[_loc3_ + 1],false,null,this._hintCategoryFiltersList[_loc3_ + 1],false));
            _loc3_++;
         }
         param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.map.mapFilters"),null,null,false,_loc2_));
         super.createContextMenu(param1);
      }
      
      private function showFilter(param1:uint) : void
      {
         this._hintCategoryFiltersList[param1] = !this._hintCategoryFiltersList[param1];
         showHints(this._hintCategoryFiltersList);
         mapViewer.updateMapElements();
      }
      
      private function onMapComplementaryInformationsData(param1:WorldPoint, param2:int, param3:Boolean) : void
      {
         var _loc7_:* = undefined;
         var _loc4_:Boolean = false;
         var _loc5_:* = dataApi.getSubArea(param2);
         if(_loc5_)
         {
            _loc7_ = _loc5_.worldmap;
            if(_loc7_ && _loc7_.id != _currentWorldId)
            {
               __switchingMapUi = false;
               if(!_loc5_.hasCustomWorldMap)
               {
                  openNewMap(_loc5_.area.superArea.worldmap,MAP_TYPE_SUPERAREA,_loc5_.area.superArea);
               }
               else
               {
                  openNewMap(_loc5_.worldmap,MAP_TYPE_SUBAREA,_loc5_);
               }
               _loc4_ = true;
            }
         }
         var _loc6_:WorldPointWrapper = playerApi.currentMap();
         if(this._centerOnPlayer || _loc4_ || (_loc6_.outdoorX != __playerPos.outdoorX || _loc6_.outdoorY != __playerPos.outdoorY))
         {
            this._centerOnPlayer = false;
            __playerPos = playerApi.currentMap();
            removeFlag("flag_playerPosition");
            addFlag("flag_playerPosition",uiApi.getText("ui.cartography.yourposition"),__playerPos.outdoorX,__playerPos.outdoorY,39423,false,true,false);
            mapViewer.moveTo(__playerPos.outdoorX,__playerPos.outdoorY);
         }
      }
      
      private function onShowEntitiesTooltips(param1:Boolean) : void
      {
         this._entitiesTooltipsVisible = this.btn_showEntitiesTooltips.selected = param1;
      }
      
      private function onHighlightInteractiveElements(param1:Boolean) : void
      {
         this._interactiveElementsHighlighted = this.btn_highlightInteractiveElements.selected = param1;
      }
      
      private function onMapFightCount(param1:uint) : void
      {
         _nFightCount = param1;
         this.btn_viewFights.softDisabled = _nFightCount == 0;
      }
   }
}
