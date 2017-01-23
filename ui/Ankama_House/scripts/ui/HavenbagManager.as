package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.houses.HavenbagTheme;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalInformations;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.HavenbagClear;
   import d2actions.HavenbagEditMode;
   import d2actions.HavenbagExit;
   import d2actions.HavenbagFurnitureSelected;
   import d2actions.HavenbagReset;
   import d2actions.HavenbagRoomSelected;
   import d2actions.HavenbagSave;
   import d2actions.HavenbagThemeSelected;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.DropStart;
   import d2hooks.HavenbagAvailableRoomsUpdate;
   import d2hooks.HavenbagAvailableThemesUpdate;
   import d2hooks.HavenbagExitEditMode;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class HavenbagManager
   {
      
      private static const BANNER_HEIGHT:uint = 141;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var dataApi:DataApi;
      
      public var configApi:ConfigApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _inMyOwnHavenbag:Boolean;
      
      private var _furnitures:Object;
      
      private var _furnituresLayer0:Array;
      
      private var _furnituresLayer1:Array;
      
      private var _furnituresLayer2:Array;
      
      private var _availableRooms:uint;
      
      private var _currentRoomIndex:uint;
      
      private var _currentRoomThemeId:int;
      
      private var _availableThemes:Array;
      
      private var _ownerInfos:CharacterMinimalInformations;
      
      private var _ctrEditCurrentPosition:Point;
      
      private var _ctrEditLastPosition:Point;
      
      private var _themeFiltersForFurnitures:Dictionary;
      
      private var _groupByTheme:Boolean;
      
      private var _currentFurnitureType:int;
      
      public var tx_help:Texture;
      
      public var tx_title_bar_ctr_edit:TextureBitmap;
      
      public var ctr_edit:GraphicContainer;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_searchFilter:ButtonContainer;
      
      public var btn_editClear:ButtonContainer;
      
      public var btn_editReset:ButtonContainer;
      
      public var btn_save:ButtonContainer;
      
      public var gd_furnitures:Grid;
      
      public function HavenbagManager()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc3_:HavenbagTheme = null;
         var _loc4_:int = 0;
         this.ctr_edit.visible = false;
         this.uiApi.addComponentHook(this.gd_furnitures,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_furnitures,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_furnitures,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_editClear,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_editClear,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_editReset,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_editReset,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_save,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_save,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this.sysApi.addHook(HavenbagExitEditMode,this.onHavenbagExitEditMode);
         this.sysApi.addHook(HavenbagAvailableRoomsUpdate,this.onHavenbagAvailableRoomsUpdate);
         this.sysApi.addHook(HavenbagAvailableThemesUpdate,this.onHavenbagAvailableThemesUpdate);
         this.sysApi.addHook(DropStart,this.onDropStart);
         var _loc2_:Point = this.configApi.getConfigProperty("dofus","havenbagEditPosition");
         if(!_loc2_)
         {
            _loc2_ = new Point(this.ctr_edit.x,this.ctr_edit.y);
         }
         else if(_loc2_)
         {
            this.ctr_edit.x = _loc2_.x;
            this.ctr_edit.y = _loc2_.y;
         }
         this.tx_title_bar_ctr_edit.mouseEnabled = true;
         this.tx_title_bar_ctr_edit.buttonMode = this.tx_title_bar_ctr_edit.useHandCursor = true;
         this._ctrEditCurrentPosition = _loc2_.clone();
         this._ctrEditLastPosition = this._ctrEditCurrentPosition.clone();
         this._currentRoomIndex = param1.currentRoomId;
         this._availableRooms = param1.availableRooms;
         this._currentRoomThemeId = param1.currentRoomThemeId;
         this._ownerInfos = param1.ownerInfos;
         this._inMyOwnHavenbag = this._ownerInfos.id == this.playerApi.id();
         this._themeFiltersForFurnitures = new Dictionary();
         this._availableThemes = new Array();
         for each(_loc4_ in param1.availableThemes)
         {
            _loc3_ = this.dataApi.getHavenbagTheme(_loc4_);
            if(_loc3_)
            {
               this._availableThemes.push({
                  "id":_loc4_,
                  "name":_loc3_.name
               });
               this._themeFiltersForFurnitures[_loc4_] = true;
            }
         }
         this._availableThemes.sortOn("name",Array.CASEINSENSITIVE);
         this._furnitures = this.dataApi.getHavenbagFurnitures();
         this.gd_furnitures.renderer.dropValidatorFunction = this.dropValidatorFalse;
         this.updateFurnituresLists();
      }
      
      public function dropValidatorFalse(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return false;
      }
      
      public function unload() : void
      {
      }
      
      private function onDropStart(param1:Object) : void
      {
         if(param1.getUi() == this.uiApi.me())
         {
            this.gd_furnitures.selectedIndex = -1;
            this.gd_furnitures.selectedIndex = this.gd_furnitures.getItemIndex(param1);
            this.sysApi.sendAction(new HavenbagFurnitureSelected(param1.data.typeId));
         }
      }
      
      public function selectFurnitureType(param1:int) : void
      {
         this.gd_furnitures.dataProvider = this["_furnituresLayer" + param1];
         this.gd_furnitures.selectedIndex = -1;
         switch(param1)
         {
            case 0:
               this.lbl_title.text = this.uiApi.getText("ui.havenbag.layer.floors");
               break;
            case 1:
               this.lbl_title.text = this.uiApi.getText("ui.havenbag.layer.supports");
               break;
            case 2:
               this.lbl_title.text = this.uiApi.getText("ui.havenbag.layer.objects");
         }
         this._currentFurnitureType = param1;
      }
      
      private function updateFurnituresLists() : void
      {
         this._furnituresLayer0 = new Array();
         this._furnituresLayer1 = new Array();
         this._furnituresLayer2 = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this._furnitures.length)
         {
            if(this._themeFiltersForFurnitures[this._furnitures[_loc1_].themeId])
            {
               if(this._furnitures[_loc1_].layerId == 0)
               {
                  this._furnituresLayer0.push(this.dataApi.getHavenbagFurnitureWrapper(this._furnitures[_loc1_].typeId));
               }
               else if(this._furnitures[_loc1_].layerId == 1)
               {
                  this._furnituresLayer1.push(this.dataApi.getHavenbagFurnitureWrapper(this._furnitures[_loc1_].typeId));
               }
               else if(this._furnitures[_loc1_].layerId == 2)
               {
                  this._furnituresLayer2.push(this.dataApi.getHavenbagFurnitureWrapper(this._furnitures[_loc1_].typeId));
               }
            }
            _loc1_++;
         }
         if(this._groupByTheme)
         {
            this._furnituresLayer0.sortOn(["themeId","order"],[Array.NUMERIC,Array.NUMERIC]);
            this._furnituresLayer1.sortOn(["themeId","order"],[Array.NUMERIC,Array.NUMERIC]);
            this._furnituresLayer2.sortOn(["themeId","order"],[Array.NUMERIC,Array.NUMERIC]);
         }
         else
         {
            this._furnituresLayer0.sortOn("order",Array.NUMERIC);
            this._furnituresLayer1.sortOn("order",Array.NUMERIC);
            this._furnituresLayer2.sortOn("order",Array.NUMERIC);
         }
         this.gd_furnitures.dataProvider = this["_furnituresLayer" + this._currentFurnitureType];
         this.gd_furnitures.selectedIndex = -1;
      }
      
      private function toggleEditionWindow(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1)
         {
            this.uiApi.getUi("havenbagFurnituresTypes").getElement("mainCtr").visible = true;
            this.ctr_edit.visible = true;
            _loc2_ = this.sysApi.getData("havenbagHelpTooltip");
            if(!_loc2_ || _loc2_ < 3)
            {
               _loc3_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.havenbag.help"));
               this.uiApi.showTooltip(_loc3_,this.tx_help,true,"standard",7,1,3,null,null,null,"TextInfo");
               this.sysApi.setData("havenbagHelpTooltip",!_loc2_?1:_loc2_ + 1);
            }
         }
         else
         {
            this.uiApi.getUi("havenbagFurnituresTypes").getElement("mainCtr").visible = false;
            this.ctr_edit.visible = false;
         }
         this.sysApi.sendAction(new HavenbagEditMode(param1));
      }
      
      private function changeRoom(param1:int) : void
      {
         if(param1 != this._currentRoomIndex)
         {
            this.sysApi.sendAction(new HavenbagRoomSelected(param1));
         }
      }
      
      private function changeTheme(param1:uint) : void
      {
         var themeId:uint = param1;
         if(themeId != this._currentRoomThemeId)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.havenbag.themeChange.popup"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[function():void
            {
               onPopupChangeTheme(themeId);
            },this.onPopupClose],function():void
            {
               onPopupChangeTheme(themeId);
            },this.onPopupClose);
         }
      }
      
      private function onPopupChangeTheme(param1:uint) : void
      {
         this.sysApi.sendAction(new HavenbagThemeSelected(param1));
      }
      
      private function quit() : void
      {
         this.sysApi.sendAction(new HavenbagExit());
      }
      
      private function filterFurnituresByThemes(param1:int) : void
      {
         this._themeFiltersForFurnitures[param1] = !this._themeFiltersForFurnitures[param1];
         this.updateFurnituresLists();
      }
      
      private function groupFurnituresByTheme() : void
      {
         this._groupByTheme = !this._groupByTheme;
         this.updateFurnituresLists();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI && this.ctr_edit.visible)
         {
            this.toggleEditionWindow(false);
            return true;
         }
         return false;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = this.gd_furnitures.selectedItem;
         if(!_loc4_)
         {
            return;
         }
         switch(param2)
         {
            case SelectMethodEnum.CLICK:
               this.sysApi.sendAction(new HavenbagFurnitureSelected(_loc4_.typeId));
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Boolean = false;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         this.modCommon.closeAllMenu();
         var _loc2_:Array = new Array();
         switch(param1)
         {
            case "btn_havenbag":
               if(this.playerApi.isInExchange())
               {
                  return;
               }
               _loc4_ = new Array();
               _loc5_ = new Array();
               _loc6_ = new Array();
               for each(_loc3_ in this._availableThemes)
               {
                  _loc7_ = false;
                  if(_loc3_.id == this._currentRoomThemeId)
                  {
                     _loc7_ = true;
                  }
                  _loc9_ = _loc3_.name;
                  if(this.sysApi.getPlayerManager().hasRights)
                  {
                     _loc9_ = _loc9_ + (" (id " + _loc3_.id + ")");
                  }
                  _loc5_.push(this.modContextMenu.createContextMenuItemObject(_loc9_,this.changeTheme,[_loc3_.id],false,null,_loc7_));
               }
               _loc10_ = 0;
               while(_loc10_ < this._availableRooms)
               {
                  _loc7_ = false;
                  if(_loc10_ == this._currentRoomIndex)
                  {
                     _loc7_ = true;
                  }
                  _loc6_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.havenbag.room") + " " + (_loc10_ + 1),this.changeRoom,[_loc10_],false,null,_loc7_));
                  _loc10_++;
               }
               if(this._inMyOwnHavenbag)
               {
                  _loc4_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.havenbag.myHavenbag")));
               }
               else
               {
                  _loc4_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.havenbag.havenbagOf",this._ownerInfos.name)));
               }
               if(this._inMyOwnHavenbag)
               {
                  _loc4_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.havenbag.editMode"),this.toggleEditionWindow,[true],false));
                  _loc4_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.havenbag.themeChoice"),null,null,_loc5_.length <= 1,_loc5_));
                  _loc4_.push(this.modContextMenu.createContextMenuSeparatorObject());
               }
               _loc4_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.havenbag.goToAnotherRoom"),null,null,false,_loc6_));
               this.modContextMenu.createContextMenu(_loc4_);
               if(this.ctr_edit.visible)
               {
                  this.toggleEditionWindow(false);
               }
               break;
            case this.btn_searchFilter:
               _loc8_ = new Array();
               _loc8_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.havenbag.group")));
               _loc8_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.havenbag.groupByTheme"),this.groupFurnituresByTheme,null,false,null,this._groupByTheme,true));
               _loc8_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.havenbag.filterByThemes")));
               for each(_loc3_ in this._availableThemes)
               {
                  _loc8_.push(this.modContextMenu.createContextMenuItemObject(_loc3_.name,this.filterFurnituresByThemes,[_loc3_.id],false,null,this._themeFiltersForFurnitures[_loc3_.id],false));
               }
               this.modContextMenu.createContextMenu(_loc8_);
               break;
            case this.btn_editClear:
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.havenbag.clear.popup"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onPopupClear,this.onPopupClose],this.onPopupClear,this.onPopupClose);
               break;
            case this.btn_editReset:
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.havenbag.reset.popup"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onPopupReset,this.onPopupClose],this.onPopupReset,this.onPopupClose);
               break;
            case this.btn_save:
               this.sysApi.sendAction(new HavenbagSave());
               break;
            case this.btn_close:
               this.toggleEditionWindow(false);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_editClear:
               _loc2_ = this.uiApi.getText("ui.havenbag.clear.info");
               break;
            case this.btn_editReset:
               _loc2_ = this.uiApi.getText("ui.havenbag.reset.info");
               break;
            case this.btn_save:
               _loc2_ = this.uiApi.getText("ui.havenbag.save.info");
               break;
            case this.btn_searchFilter:
               _loc2_ = this.uiApi.getText("ui.havenbag.filter.info");
               break;
            case this.tx_help:
               _loc2_ = this.uiApi.getText("ui.havenbag.help");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(param2.data && this.sysApi.getPlayerManager().hasRights)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo("--- DEBUG ---" + "\ntypeId: " + param2.data.typeId + "\nthemeId: " + param2.data.themeId + "\nelementId: " + param2.data.elementId + "\ngfxId: " + param2.data.element.gfxId + "\nisStackable: " + param2.data.isStackable + "\nblocksMovement: " + param2.data.blocksMovement + "\ncolor: " + (param2.data.color == int.MAX_VALUE?"null":param2.data.color) + "\nsize: " + param2.data.cellsWidth + "x" + param2.data.cellsHeight),param2.container,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPLEFT,0,null,null,null,"DebugInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onHavenbagAvailableRoomsUpdate(param1:uint) : void
      {
         this._availableRooms = param1;
      }
      
      private function onHavenbagAvailableThemesUpdate(param1:*) : void
      {
         var _loc2_:HavenbagTheme = null;
         var _loc3_:int = 0;
         this._themeFiltersForFurnitures = new Dictionary();
         this._availableThemes = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_ = this.dataApi.getHavenbagTheme(_loc3_);
            if(_loc2_)
            {
               this._themeFiltersForFurnitures[_loc3_] = true;
               this._availableThemes.push({
                  "id":_loc3_,
                  "name":_loc2_.name
               });
            }
         }
         this._availableThemes.sortOn("name",Array.CASEINSENSITIVE);
         this._furnitures = this.dataApi.getHavenbagFurnitures();
         this.updateFurnituresLists();
      }
      
      public function onHavenbagExitEditMode() : void
      {
         this.uiApi.getUi("havenbagFurnituresTypes").getElement("mainCtr").visible = false;
         this.ctr_edit.visible = false;
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onPopupClear() : void
      {
         this.sysApi.sendAction(new HavenbagClear());
      }
      
      public function onPopupReset() : void
      {
         this.sysApi.sendAction(new HavenbagReset());
      }
   }
}
