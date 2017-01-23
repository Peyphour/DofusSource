package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.internalDatacenter.taxi.TeleportDestinationWrapper;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.LeaveDialogRequest;
   import d2actions.TeleportRequest;
   import d2actions.ZaapRespawnSaveRequest;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.SoundTypeEnum;
   import d2enums.StatesEnum;
   import d2enums.TeleporterTypeEnum;
   import d2enums.UISoundEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.KeyUp;
   import d2hooks.LeaveDialog;
   import d2hooks.TeleportDestinationList;
   import flash.utils.Dictionary;
   
   public class ZaapSelection
   {
       
      
      private var INPUT_SEARCH_DEFAULT_TEXT:String;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var rpApi:RoleplayApi;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      public var utilApi:UtilApi;
      
      public var mapApi:MapApi;
      
      public var configApi:ConfigApi;
      
      private var _teleportType:uint;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _componentsList:Dictionary;
      
      protected var _favoriteZaap:Array;
      
      protected var _fullZaapList:Array;
      
      protected var _tab1List:Array;
      
      protected var _tab2List:Array;
      
      protected var _tab3List:Array;
      
      protected var _currentdataProvider:Array;
      
      protected var _currentSortCriteria:String = "name";
      
      protected var _currentZaapName:String;
      
      protected var _uriEmptyStar:Object;
      
      protected var _uriYellowStar:Object;
      
      public var lbl_title:Label;
      
      public var lbl_availableKamasNb:Label;
      
      public var lbl_noDestination:Label;
      
      public var tx_currentRespawn:Texture;
      
      public var gd_zaap:Grid;
      
      public var btn_validate:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_tabSpawn:ButtonContainer;
      
      public var btn_tabDest:ButtonContainer;
      
      public var btn_tabCoord:ButtonContainer;
      
      public var btn_tabCost:ButtonContainer;
      
      public var btn_resetSearch:ButtonContainer;
      
      public var btn_tab1:ButtonContainer;
      
      public var btn_tab2:ButtonContainer;
      
      public var btn_tab3:ButtonContainer;
      
      public var tx_fav:Texture;
      
      public var btn_showUnknowZaap:ButtonContainer;
      
      public var lbl_btn_tab1:Label;
      
      public var lbl_btn_tab2:Label;
      
      public var lbl_btn_tab3:Label;
      
      public var btn_save:ButtonContainer;
      
      public var inp_search:Input;
      
      public function ZaapSelection()
      {
         this._componentsList = new Dictionary(false);
         super();
      }
      
      public function main(param1:Array) : void
      {
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.btn_validate.soundId = UISoundEnum.OK_BUTTON;
         this.btn_close.soundId = UISoundEnum.CANCEL_BUTTON;
         this.btn_tab1.soundId = UISoundEnum.TAB;
         this.btn_tab2.soundId = UISoundEnum.TAB;
         this.btn_tab3.soundId = UISoundEnum.TAB;
         this.sysApi.addHook(TeleportDestinationList,this.onTeleportDestinationList);
         this.sysApi.addHook(LeaveDialog,this.onLeaveDialog);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addComponentHook(this.gd_zaap,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.tx_fav,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_fav,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_fav,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_save,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_save,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_currentRespawn,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_currentRespawn,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this._teleportType = param1[1];
         if(this._teleportType != TeleporterTypeEnum.TELEPORTER_SUBWAY)
         {
            this.btn_tab3.visible = false;
            this.btn_tab1.soundId = UISoundEnum.TAB;
            this.btn_tab2.soundId = UISoundEnum.TAB;
            this.lbl_btn_tab1.text = this.uiApi.getText("ui.zaap.zaap");
            this.lbl_btn_tab2.text = this.uiApi.getText("ui.zaap.prism");
         }
         this.btn_showUnknowZaap.visible = true;
         this.tx_fav.handCursor = true;
         this.btn_showUnknowZaap.selected = this.sysApi.getData("showUnknowZaap");
         this.lbl_availableKamasNb.text = this.utilApi.kamasToString(this.playerApi.characteristics().kamas,"");
         this.INPUT_SEARCH_DEFAULT_TEXT = this.uiApi.getText("ui.zaap.searchDestination");
         this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
         this._uriEmptyStar = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "zaap/" + "icon_star_normal.png");
         this._uriYellowStar = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "zaap/" + "icon_star_selected.png");
         this._favoriteZaap = this.sysApi.getData("favoriteZap");
         this.onZaapList(param1[0]);
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
      }
      
      public function updateZaapLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            if(!this._componentsList[param2.btn_zaapCoord.name])
            {
               this.uiApi.addComponentHook(param2.btn_zaapCoord,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.lbl_zaapCoord,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.lbl_zaapCoord,ComponentHookList.ON_ROLL_OUT);
            }
            if(!this._componentsList[param2.btn_favoritZap.name])
            {
               this.uiApi.addComponentHook(param2.btn_favoritZap,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.btn_favoritZap,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.btn_favoritZap,ComponentHookList.ON_ROLL_OUT);
            }
            this._componentsList[param2.btn_zaapCoord.name] = param1;
            this._componentsList[param2.btn_favoritZap.name] = param1;
            param2.tx_favoritZap.visible = true;
            param2.tx_zaapCost.visible = true;
            param2.lbl_zaapName.text = param1.name;
            param2.lbl_zaapCost.text = this.utilApi.kamasToString(param1.cost,"");
            param2.lbl_zaapCoord.text = "(" + param1.coord + ")";
            if(this._favoriteZaap && this._favoriteZaap.indexOf(param1.name) != -1)
            {
               param2.tx_favoritZap.uri = this._uriYellowStar;
            }
            else
            {
               param2.tx_favoritZap.uri = this._uriEmptyStar;
            }
            if(param1.known)
            {
               if(param1.spawn)
               {
                  param2.lbl_zaapName.cssClass = "green";
                  if(this.playerApi.characteristics().kamas < param1.cost)
                  {
                     param2.lbl_zaapCost.cssClass = "redright";
                  }
                  else
                  {
                     param2.lbl_zaapCost.cssClass = "right";
                  }
               }
               else if(this.playerApi.characteristics().kamas < param1.cost)
               {
                  param2.lbl_zaapName.cssClass = "disabled";
                  param2.lbl_zaapCoord.cssClass = "disabledcenter";
                  param2.lbl_zaapCost.cssClass = "redright";
               }
               else
               {
                  param2.lbl_zaapName.cssClass = "p";
                  param2.lbl_zaapCoord.cssClass = "greencenter";
                  param2.lbl_zaapCost.cssClass = "right";
               }
               param2.btn_favoritZap.visible = true;
               param2.tx_zaapCost.visible = true;
               param2.btn_favoritZap.disabled = false;
            }
            else
            {
               param2.lbl_zaapName.cssClass = "disabled";
               param2.lbl_zaapCoord.cssClass = "disabledcenter";
               param2.lbl_zaapCost.cssClass = "disabledright";
               param2.lbl_zaapCost.text = "--";
               param2.tx_zaapCost.visible = false;
               param2.btn_favoritZap.visible = false;
            }
            param2.btn_zaap.disabled = false;
            param2.btn_zaapCoord.disabled = false;
            param2.btn_zaap.selected = param3;
            param2.btn_zaapCoord.selected = param3;
            param2.btn_favoritZap.selected = param3;
            param2.btn_zaap.state = !!param3?StatesEnum.STATE_SELECTED:StatesEnum.STATE_NORMAL;
         }
         else
         {
            param2.lbl_zaapName.text = "";
            param2.lbl_zaapCost.text = "";
            param2.lbl_zaapCoord.text = "";
            param2.tx_favoritZap.visible = false;
            param2.btn_zaap.selected = false;
            param2.btn_zaap.disabled = true;
            param2.btn_zaapCoord.disabled = true;
            param2.btn_favoritZap.disabled = true;
            param2.tx_zaapCost.visible = false;
         }
      }
      
      private function validateZaapChoice() : void
      {
         var _loc1_:TeleportDestinationWrapper = this.gd_zaap.selectedItem;
         if(!_loc1_)
         {
            return;
         }
         this.sysApi.sendAction(new TeleportRequest(_loc1_.destinationType,_loc1_.mapId,_loc1_.cost));
      }
      
      private function sortZaapiByNameWithoutAccent(param1:TeleportDestinationWrapper, param2:TeleportDestinationWrapper) : Number
      {
         var _loc3_:String = this.utilApi.noAccent(param1.name);
         var _loc4_:String = this.utilApi.noAccent(param2.name);
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      private function sortArrayByCoord(param1:TeleportDestinationWrapper, param2:TeleportDestinationWrapper) : Number
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Array = param1.coord.split(",");
         var _loc4_:Array = param2.coord.split(",");
         var _loc5_:int = parseInt(_loc3_[0]);
         var _loc6_:int = parseInt(_loc4_[0]);
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         _loc7_ = parseInt(_loc3_[1]);
         _loc8_ = parseInt(_loc4_[1]);
         if(_loc7_ > _loc8_)
         {
            return 1;
         }
         if(_loc7_ < _loc8_)
         {
            return -1;
         }
         return 0;
      }
      
      protected function sortZaap(param1:*, param2:String) : Array
      {
         var _loc6_:TeleportDestinationWrapper = null;
         this._currentSortCriteria = param2;
         if(!this._favoriteZaap)
         {
            this._favoriteZaap = new Array();
         }
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         for each(_loc6_ in param1)
         {
            if(_loc6_.known)
            {
               if(this._favoriteZaap.indexOf(_loc6_.name) != -1 && _loc6_.known)
               {
                  _loc3_.push(_loc6_);
               }
               else
               {
                  _loc4_.push(_loc6_);
               }
            }
            else
            {
               _loc5_.push(_loc6_);
            }
         }
         if(param2 == "name")
         {
            if(this._bDescendingSort)
            {
               _loc3_.sort(this.sortZaapiByNameWithoutAccent,Array.DESCENDING);
               _loc4_.sort(this.sortZaapiByNameWithoutAccent,Array.DESCENDING);
               if(this.btn_showUnknowZaap.selected)
               {
                  _loc5_.sort(this.sortZaapiByNameWithoutAccent,Array.DESCENDING);
               }
            }
            else
            {
               _loc3_.sort(this.sortZaapiByNameWithoutAccent);
               _loc4_.sort(this.sortZaapiByNameWithoutAccent);
               if(this.btn_showUnknowZaap.selected)
               {
                  _loc5_.sort(this.sortZaapiByNameWithoutAccent);
               }
            }
         }
         else if(param2 == "coord")
         {
            if(this._bDescendingSort)
            {
               _loc3_.sort(this.sortArrayByCoord,Array.DESCENDING);
               _loc4_.sort(this.sortArrayByCoord,Array.DESCENDING);
               if(this.btn_showUnknowZaap.selected)
               {
                  _loc5_.sort(this.sortArrayByCoord,Array.DESCENDING);
               }
            }
            else
            {
               _loc3_.sort(this.sortArrayByCoord);
               _loc4_.sort(this.sortArrayByCoord);
               if(this.btn_showUnknowZaap.selected)
               {
                  _loc5_.sort(this.sortArrayByCoord);
               }
            }
         }
         else if(this._bDescendingSort)
         {
            _loc3_.sortOn(param2,Array.NUMERIC | Array.DESCENDING);
            _loc4_.sortOn(param2,Array.NUMERIC | Array.DESCENDING);
            if(this.btn_showUnknowZaap.selected)
            {
               _loc5_.sortOn(param2,Array.NUMERIC | Array.DESCENDING);
            }
         }
         else
         {
            _loc3_.sortOn(param2,Array.NUMERIC);
            _loc4_.sortOn(param2,Array.NUMERIC);
            if(this.btn_showUnknowZaap.selected)
            {
               _loc5_.sortOn(param2,Array.NUMERIC);
            }
         }
         if(this.btn_showUnknowZaap.selected)
         {
            _loc4_ = _loc4_.concat(_loc5_);
         }
         return _loc3_.concat(_loc4_);
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:MapPosition = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         if(param1.name.indexOf("btn_zaapCoord") != -1)
         {
            _loc2_ = this.dataApi.getMapInfo(this._componentsList[param1.name].mapId);
            if(this._teleportType == TeleporterTypeEnum.TELEPORTER_ZAAP)
            {
               _loc3_ = this.uiApi.getText("ui.zaap.zaap");
            }
            else if(this._teleportType == TeleporterTypeEnum.TELEPORTER_PRISM)
            {
               _loc3_ = this.uiApi.getText("ui.zaap.prism");
            }
            else if(this._teleportType == TeleporterTypeEnum.TELEPORTER_SUBWAY)
            {
               _loc3_ = this.uiApi.getText("ui.zaap.zaapi");
            }
            _loc3_ = _loc3_ + (" - " + this._componentsList[param1.name].name + " (" + this._componentsList[param1.name].coord + ")");
            this.sysApi.dispatchHook(AddMapFlag,"flag_teleportPoint",_loc3_,_loc2_.worldMap,_loc2_.posX,_loc2_.posY,8969710);
         }
         else if(param1.name.indexOf("btn_favoritZap") != -1)
         {
            this.addRemoveFavoritZaap(this._componentsList[param1.name]);
         }
         else
         {
            switch(param1)
            {
               case this.btn_tab1:
                  this.gd_zaap.dataProvider = this.sortZaap(this._tab1List,this._currentSortCriteria);
                  this._currentdataProvider = this._tab1List.concat();
                  if(this._teleportType == TeleporterTypeEnum.TELEPORTER_ZAAP)
                  {
                     this.btn_save.visible = true;
                  }
                  if(this.btn_save.softDisabled)
                  {
                     this.tx_currentRespawn.visible = true;
                  }
                  break;
               case this.btn_tab2:
                  this.gd_zaap.dataProvider = this.gd_zaap.dataProvider = this.sortZaap(this._tab2List,this._currentSortCriteria);
                  this._currentdataProvider = this._tab2List.concat();
                  this.btn_save.visible = false;
                  this.tx_currentRespawn.visible = false;
                  break;
               case this.btn_tab3:
                  this.gd_zaap.dataProvider = this.gd_zaap.dataProvider = this.sortZaap(this._tab3List,this._currentSortCriteria);
                  this._currentdataProvider = this._tab3List.concat();
                  this.btn_save.visible = false;
                  this.tx_currentRespawn.visible = false;
                  break;
               case this.tx_fav:
                  for each(_loc4_ in this._fullZaapList)
                  {
                     if(_loc4_.name == this._currentZaapName)
                     {
                        this.addRemoveFavoritZaap(_loc4_);
                        break;
                     }
                  }
                  break;
               case this.btn_save:
                  this.sysApi.sendAction(new ZaapRespawnSaveRequest());
                  break;
               case this.btn_validate:
                  this.validateZaapChoice();
                  break;
               case this.btn_close:
                  this.sysApi.sendAction(new LeaveDialogRequest());
                  break;
               case this.btn_tabSpawn:
                  if(this._currentSortCriteria == "spawn")
                  {
                     this._bDescendingSort = !this._bDescendingSort;
                  }
                  this.gd_zaap.dataProvider = this.sortZaap(this.gd_zaap.dataProvider,"spawn");
                  break;
               case this.btn_tabDest:
                  if(this._currentSortCriteria == "name")
                  {
                     this._bDescendingSort = !this._bDescendingSort;
                  }
                  this.gd_zaap.dataProvider = this.sortZaap(this.gd_zaap.dataProvider,"name");
                  break;
               case this.btn_tabCoord:
                  if(this._currentSortCriteria == "coord")
                  {
                     this._bDescendingSort = !this._bDescendingSort;
                  }
                  this.gd_zaap.dataProvider = this.sortZaap(this.gd_zaap.dataProvider,"coord");
                  break;
               case this.btn_tabCost:
                  if(this._currentSortCriteria == "cost")
                  {
                     this._bDescendingSort = !this._bDescendingSort;
                  }
                  this.gd_zaap.dataProvider = this.sortZaap(this.gd_zaap.dataProvider,"cost");
                  break;
               case this.btn_showUnknowZaap:
                  this.sysApi.setData("showUnknowZaap",this.btn_showUnknowZaap.selected);
                  this.gd_zaap.dataProvider = this.sortZaap(this._currentdataProvider,this._currentSortCriteria);
                  break;
               case this.btn_resetSearch:
                  if(this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
                  {
                     this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
                     this.gd_zaap.dataProvider = this.sortZaap(this._currentdataProvider,this._currentSortCriteria);
                  }
                  break;
               case this.inp_search:
                  if(this.inp_search.text == this.INPUT_SEARCH_DEFAULT_TEXT)
                  {
                     this.inp_search.text = "";
                  }
            }
         }
      }
      
      protected function addRemoveFavoritZaap(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(!this._favoriteZaap)
         {
            this._favoriteZaap = new Array();
         }
         if(this._favoriteZaap.indexOf(param1.name) == -1)
         {
            for each(_loc2_ in this._fullZaapList)
            {
               if(_loc2_.coord == param1.coord && this._favoriteZaap.indexOf(_loc2_.name) == -1)
               {
                  this._favoriteZaap.push(_loc2_.name);
               }
            }
         }
         else
         {
            for each(_loc2_ in this._fullZaapList)
            {
               if(_loc2_.coord == param1.coord)
               {
                  this._favoriteZaap.splice(this._favoriteZaap.indexOf(_loc2_.name,1));
               }
            }
         }
         this.sysApi.setData("favoriteZap",this._favoriteZaap.concat());
         if(this._favoriteZaap.indexOf(this._currentZaapName) != -1)
         {
            this.tx_fav.uri = this._uriYellowStar;
         }
         else
         {
            this.tx_fav.uri = this._uriEmptyStar;
         }
         this.gd_zaap.dataProvider = this.sortZaap(this.gd_zaap.dataProvider,"name");
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 7;
         var _loc4_:int = 1;
         var _loc5_:int = 3;
         if(param1.name.indexOf("lbl_zaapCoord") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.tooltip.questMarker");
         }
         else if(param1.name.indexOf("btn_favoritZap") != -1)
         {
            if(this._favoriteZaap && this._favoriteZaap.indexOf(this._componentsList[param1.name].name) != -1)
            {
               _loc2_ = this.uiApi.getText("ui.zaap.deleteFavoritTooltip");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.zaap.addFavoritTooltip");
            }
         }
         else if(param1 == this.tx_fav)
         {
            if(this._favoriteZaap && this._favoriteZaap.indexOf(this._currentZaapName) != -1)
            {
               _loc2_ = this.uiApi.getText("ui.zaap.deleteFavoritTooltip");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.zaap.addFavoritTooltip");
            }
         }
         else if(param1 == this.btn_save)
         {
            if(this._teleportType == TeleporterTypeEnum.TELEPORTER_HAVENBAG || this.playerApi.isInHavenbag())
            {
               _loc2_ = this.uiApi.getText("ui.zaap.saveInHavenbag");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.zaap.saveAsRespawn");
            }
         }
         else if(param1 == this.tx_currentRespawn)
         {
            _loc2_ = this.uiApi.getText("ui.zaap.respawn");
         }
         else if(param1 == this.lbl_availableKamasNb)
         {
            _loc2_ = this.uiApi.getText("ui.storage.ownedKamas");
            _loc3_ = LocationEnum.POINT_BOTTOMRIGHT;
            _loc4_ = LocationEnum.POINT_TOPRIGHT;
            _loc5_ = 0;
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,_loc5_,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:TeleportDestinationWrapper = null;
         if(this.inp_search.haveFocus && this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
         {
            _loc3_ = new Array();
            _loc4_ = this.utilApi.noAccent(this.inp_search.text).toLowerCase();
            for each(_loc5_ in this._currentdataProvider)
            {
               if(this.utilApi.noAccent(_loc5_.name).toLowerCase().indexOf(_loc4_) != -1)
               {
                  _loc3_.push(_loc5_);
               }
            }
            this.gd_zaap.dataProvider = this.sortZaap(_loc3_,this._currentSortCriteria);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               this.validateZaapChoice();
               return true;
            case "closeUi":
               this.sysApi.sendAction(new LeaveDialogRequest());
               return true;
            default:
               return false;
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 == this.sysApi.getEnum("com.ankamagames.berilia.enums.SelectMethodEnum").DOUBLE_CLICK)
         {
            this.validateZaapChoice();
         }
      }
      
      public function onTeleportDestinationList(param1:Object, param2:uint) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:TeleportDestinationWrapper = null;
         this._tab1List = new Array();
         this._tab2List = new Array();
         this._tab3List = new Array();
         this.tx_currentRespawn.visible = false;
         this.btn_save.softDisabled = false;
         if(param1.length != 0)
         {
            for(_loc3_ in param1)
            {
               if(param1[_loc3_].mapId != this.playerApi.currentMap().mapId)
               {
                  if(param1[_loc3_].destinationType == TeleporterTypeEnum.TELEPORTER_ZAAP)
                  {
                     this._tab1List.push(param1[_loc3_]);
                  }
                  else if(param1[_loc3_].destinationType == TeleporterTypeEnum.TELEPORTER_PRISM)
                  {
                     this._tab2List.push(param1[_loc3_]);
                  }
               }
               else
               {
                  this._teleportType = param1[_loc3_].destinationType;
                  if(param1[_loc3_].spawn)
                  {
                     this.tx_currentRespawn.visible = true;
                     this.btn_save.softDisabled = true;
                  }
               }
            }
            for each(_loc4_ in this.dataApi.getUnknowZaaps(this._tab1List))
            {
               if(_loc4_.mapId != this.playerApi.currentMap().mapId)
               {
                  this._tab1List.push(_loc4_);
               }
            }
            if(this.btn_tab1.selected)
            {
               this.gd_zaap.dataProvider = this.sortZaap(this._tab1List,this._currentSortCriteria);
               this._currentdataProvider = this._tab1List.concat();
            }
            else if(this.btn_tab2.selected)
            {
               this.gd_zaap.dataProvider = this.sortZaap(this._tab2List,this._currentSortCriteria);
               this._currentdataProvider = this._tab2List.concat();
            }
            else if(this.btn_tab3.selected)
            {
               this.gd_zaap.dataProvider = this.sortZaap(this._tab3List,this._currentSortCriteria);
               this._currentdataProvider = this._tab3List.concat();
            }
            this.gd_zaap.visible = true;
            this.lbl_noDestination.visible = false;
         }
         else
         {
            this.gd_zaap.visible = false;
            this.lbl_noDestination.visible = true;
            if(this.rpApi.getSpawnMap() == this.playerApi.currentMap().mapId)
            {
               this.tx_currentRespawn.visible = true;
               this.btn_save.softDisabled = true;
            }
         }
         if(this._teleportType == TeleporterTypeEnum.TELEPORTER_HAVENBAG || this.playerApi.isInHavenbag())
         {
            this.btn_save.softDisabled = true;
            this.tx_fav.visible = false;
         }
      }
      
      public function onZaapList(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:TeleportDestinationWrapper = null;
         this._tab1List = new Array();
         this._tab2List = new Array();
         this._tab3List = new Array();
         this._fullZaapList = new Array();
         this.tx_currentRespawn.visible = false;
         this.btn_save.softDisabled = false;
         this.btn_save.visible = false;
         if(param1.length != 0)
         {
            for(_loc2_ in param1)
            {
               this._fullZaapList.push(param1[_loc2_]);
               if(param1[_loc2_].mapId != this.playerApi.currentMap().mapId)
               {
                  if(param1[_loc2_].destinationType == TeleporterTypeEnum.TELEPORTER_ZAAP)
                  {
                     this._tab1List.push(param1[_loc2_]);
                  }
                  else if(param1[_loc2_].destinationType == TeleporterTypeEnum.TELEPORTER_PRISM)
                  {
                     this._tab2List.push(param1[_loc2_]);
                  }
               }
               else
               {
                  this._teleportType = param1[_loc2_].destinationType;
                  this._currentZaapName = param1[_loc2_].name;
                  if(param1[_loc2_].spawn)
                  {
                     this.tx_currentRespawn.visible = true;
                     this.btn_save.softDisabled = true;
                  }
               }
            }
            if(this._favoriteZaap && this._favoriteZaap.indexOf(this._currentZaapName) != -1)
            {
               this.tx_fav.uri = this._uriYellowStar;
            }
            else
            {
               this.tx_fav.uri = this._uriEmptyStar;
            }
            for each(_loc3_ in this.dataApi.getUnknowZaaps(this._tab1List))
            {
               if(_loc3_.mapId != this.playerApi.currentMap().mapId)
               {
                  this._tab1List.push(_loc3_);
               }
            }
            this.btn_tab1.disabled = false;
            if(this._tab2List.length == 0)
            {
               this.btn_tab2.disabled = true;
            }
            else
            {
               this.btn_tab2.disabled = false;
            }
            if(this._tab3List.length == 0)
            {
               this.btn_tab3.disabled = true;
            }
            else
            {
               this.btn_tab3.disabled = false;
            }
            if(this._teleportType == TeleporterTypeEnum.TELEPORTER_ZAAP)
            {
               this.lbl_title.text = this.uiApi.getText("ui.zaap.zaap") + " - " + this.playerApi.currentSubArea().name;
               this.btn_save.visible = true;
            }
            else if(this._teleportType == TeleporterTypeEnum.TELEPORTER_PRISM)
            {
               this.lbl_title.text = this.uiApi.getText("ui.zaap.prism") + " - " + this.playerApi.currentSubArea().name;
               this.btn_save.visible = false;
            }
            if(!this.btn_tab1.disabled && this.btn_tab1.visible && (this._teleportType != TeleporterTypeEnum.TELEPORTER_PRISM || this.btn_tab2.disabled))
            {
               this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_tab1,this.uiApi.me());
               this.btn_tab1.selected = true;
               this.gd_zaap.dataProvider = this.sortZaap(this._tab1List,"name");
               this._currentdataProvider = this._tab1List.concat();
            }
            else if(!this.btn_tab2.disabled && this.btn_tab2.visible)
            {
               this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_tab2,this.uiApi.me());
               this.btn_tab2.selected = true;
               this.gd_zaap.dataProvider = this.sortZaap(this._tab2List,"name");
               this._currentdataProvider = this._tab2List.concat();
            }
            else if(!this.btn_tab3.disabled && this.btn_tab3.visible)
            {
               this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_tab3,this.uiApi.me());
               this.btn_tab3.selected = true;
               this.gd_zaap.dataProvider = this.sortZaap(this._tab3List,"name");
               this._currentdataProvider = this._tab3List.concat();
            }
            this.gd_zaap.visible = true;
            this.lbl_noDestination.visible = false;
         }
         else
         {
            this.gd_zaap.visible = false;
            this.lbl_noDestination.visible = true;
            if(this.rpApi.getSpawnMap() == this.playerApi.currentMap().mapId)
            {
               this.tx_currentRespawn.visible = true;
               this.btn_save.softDisabled = true;
            }
         }
         if(this._teleportType == TeleporterTypeEnum.TELEPORTER_HAVENBAG || this.playerApi.isInHavenbag())
         {
            this.btn_save.softDisabled = true;
            this.tx_fav.visible = false;
         }
      }
      
      public function onLeaveDialog() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
   }
}
