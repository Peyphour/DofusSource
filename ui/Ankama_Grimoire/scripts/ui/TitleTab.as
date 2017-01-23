package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.OrnamentSelectRequest;
   import d2actions.TitleSelectRequest;
   import d2actions.TitlesAndOrnamentsListRequest;
   import d2enums.AggressableStatusEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.StrataEnum;
   import d2hooks.FocusChange;
   import d2hooks.KeyUp;
   import d2hooks.OpenBook;
   import d2hooks.OrnamentUpdated;
   import d2hooks.OrnamentsListUpdated;
   import d2hooks.TitleUpdated;
   import d2hooks.TitlesListUpdated;
   
   public class TitleTab
   {
      
      public static const TAB_TITLE:uint = 0;
      
      public static const TAB_ORNAMENT:uint = 1;
      
      public static const TOOLTIP_CHARA:String = "tooltipCharacter";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var tooltipApi:TooltipApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _noneText:String;
      
      private var _nCurrentTab:int = -1;
      
      private var _titleIdAtStart:int;
      
      private var _ornamentIdAtStart:int;
      
      private var _titleId:int;
      
      private var _ornamentId:int;
      
      private var _allTitles:Array;
      
      private var _myTitles:Array;
      
      private var _myTitlesIds:Array;
      
      private var _dataTitles:Object;
      
      private var _allOrnaments:Array;
      
      private var _myOrnaments:Array;
      
      private var _myOrnamentsIds:Array;
      
      private var _dataOrnaments:Object;
      
      private var _searchCriteria:String;
      
      private var _showAll:Boolean = false;
      
      private var _tooltipInfos:Object;
      
      private var _waitingForTitlesMsg:Boolean;
      
      private var _waitingForOrnsMsg:Boolean;
      
      private var _waitingForTooltipUpdate:Boolean;
      
      private var _param:Object;
      
      private var _wingsOut:Boolean = false;
      
      private var _direction:int = 2;
      
      private var _focusOnSearch:Boolean = false;
      
      public var ctr_search:GraphicContainer;
      
      public var tx_warning:Texture;
      
      public var gd_titles:Grid;
      
      public var gd_orns:Grid;
      
      public var inp_search:Input;
      
      public var ed_chara:EntityDisplayer;
      
      public var btn_title:ButtonContainer;
      
      public var btn_ornament:ButtonContainer;
      
      public var btn_reset:ButtonContainer;
      
      public var btn_save:ButtonContainer;
      
      public var btn_resetSearch:ButtonContainer;
      
      public var btn_showAll:ButtonContainer;
      
      public var btn_leftArrow:ButtonContainer;
      
      public var btn_rightArrow:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public function TitleTab()
      {
         this._allTitles = new Array();
         this._myTitles = new Array();
         this._myTitlesIds = new Array();
         this._allOrnaments = new Array();
         this._myOrnaments = new Array();
         this._myOrnamentsIds = new Array();
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(TitlesListUpdated,this.onTitlesListUpdated);
         this.sysApi.addHook(OrnamentsListUpdated,this.onOrnamentsListUpdated);
         this.sysApi.addHook(TitleUpdated,this.onTitleUpdated);
         this.sysApi.addHook(OrnamentUpdated,this.onOrnamentUpdated);
         this.sysApi.addHook(OpenBook,this.onOpenTitle);
         this.uiApi.addComponentHook(this.gd_titles,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_orns,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ed_chara,ComponentHookList.ON_ENTITY_READY);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.sysApi.addHook(FocusChange,this.onFocusChange);
         this.uiApi.addShortcutHook("closeUi",this.onShortCut);
         this._noneText = this.uiApi.getText("ui.common.none");
         this.inp_search.text = this.getSearchText();
         this._dataTitles = this.dataApi.getTitles();
         this._dataOrnaments = this.dataApi.getOrnaments();
         this.btn_save.disabled = true;
         this.tx_warning.visible = false;
         this._showAll = this.sysApi.getData("showAllTitlesAndOrnaments");
         this.btn_showAll.selected = this._showAll;
         this._param = param1;
         if(!this.playerApi.titlesOrnamentsAskedBefore())
         {
            this._waitingForOrnsMsg = true;
            this._waitingForTitlesMsg = true;
            this.sysApi.sendAction(new TitlesAndOrnamentsListRequest());
         }
         else
         {
            _loc2_ = this.playerApi.getTitle();
            if(_loc2_)
            {
               this._titleIdAtStart = _loc2_.id;
               this._titleId = this._titleIdAtStart;
            }
            _loc3_ = this.playerApi.getOrnament();
            if(_loc3_)
            {
               this._ornamentIdAtStart = _loc3_.id;
               this._ornamentId = this._ornamentIdAtStart;
            }
            _loc4_ = this.playerApi.getKnownTitles();
            _loc5_ = this.playerApi.getKnownOrnaments();
            this._waitingForOrnsMsg = true;
            if(_loc4_ && _loc4_.length > 0)
            {
               this.onTitlesListUpdated(_loc4_);
            }
            else
            {
               this.onTitlesListUpdated(new Array());
            }
            if(_loc5_ && _loc5_.length > 0)
            {
               this.onOrnamentsListUpdated(_loc5_);
            }
            else
            {
               this.onOrnamentsListUpdated(new Array());
            }
         }
         if(this._param && this._param.id && !this._param.idIsTitle || (!this._param || !this._param.id) && Grimoire.getInstance().titleCurrentTab == 1)
         {
            this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_ornament,this.uiApi.me());
            this.btn_ornament.selected = true;
            this.onRelease(this.btn_ornament);
         }
         else
         {
            this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_title,this.uiApi.me());
            this.btn_title.selected = true;
            this.onRelease(this.btn_title);
         }
         this.ed_chara.direction = this._direction;
         this.ed_chara.look = this.playerApi.getPlayedCharacterInfo().entityLook;
         this.ctr_search.visible = true;
         if(!this._waitingForOrnsMsg && !this._waitingForTitlesMsg)
         {
            this.displayTooltip(true,true);
            if(this._param && this._param.id)
            {
               this.onOpenTitle("titleTab",{
                  "forceOpen":true,
                  "id":this._param.id,
                  "idIsTitle":this._param.idIsTitle
               });
            }
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip(TOOLTIP_CHARA);
      }
      
      public function updateTitle(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_name.text = param1.name;
            if(this._showAll && param1.id != 0 && this._myTitlesIds.indexOf(param1.id) == -1)
            {
               param2.lbl_name.cssClass = "p4";
            }
            else
            {
               param2.lbl_name.cssClass = "p";
            }
            param2.btn_title.selected = param3;
            param2.btn_title.visible = true;
         }
         else
         {
            param2.lbl_name.text = "";
            param2.btn_title.selected = false;
            param2.btn_title.visible = false;
         }
      }
      
      public function updateOrnament(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_name.text = param1.name;
            if(this._showAll && param1.id != 0 && this._myOrnamentsIds.indexOf(param1.id) == -1)
            {
               param2.lbl_name.cssClass = "p4";
            }
            else
            {
               param2.lbl_name.cssClass = "p";
            }
            if(param1.id > 0)
            {
               param2.tx_picto.uri = this.uiApi.createUri(this.uiApi.me().getConstant("ornamentIconPath") + param1.iconId + ".png");
               param2.tx_slot.visible = true;
            }
            else
            {
               param2.tx_picto.uri = null;
               param2.tx_slot.visible = false;
            }
            param2.btn_orn.selected = param3;
            param2.btn_orn.visible = true;
            if(this._wingsOut)
            {
               param2.btn_orn.mouseEnabled = false;
               param2.btn_orn.mouseChildren = false;
               param2.tx_picto.disabled = true;
            }
            else
            {
               param2.btn_orn.mouseEnabled = true;
               param2.btn_orn.mouseChildren = true;
               param2.tx_picto.disabled = false;
            }
         }
         else
         {
            param2.lbl_name.text = "";
            param2.tx_slot.visible = false;
            param2.btn_orn.selected = false;
            param2.btn_orn.visible = false;
            param2.btn_orn.disabled = false;
         }
      }
      
      private function openSelectedTab(param1:int) : void
      {
         if(this._nCurrentTab == param1)
         {
            return;
         }
         this._nCurrentTab = param1;
         Grimoire.getInstance().titleCurrentTab = this._nCurrentTab;
         if(this._nCurrentTab == TAB_TITLE)
         {
            this.gd_titles.visible = true;
            this.gd_orns.visible = false;
         }
         else if(this._nCurrentTab == TAB_ORNAMENT)
         {
            this.gd_titles.visible = false;
            this.gd_orns.visible = true;
         }
         this.inp_search.text = this.getSearchText();
      }
      
      private function updateGrid(param1:int = 0, param2:Boolean = false) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Title = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Ornament = null;
         if(this._nCurrentTab == TAB_TITLE || param2 && param1 == TAB_TITLE)
         {
            _loc3_ = new Array();
            if(!this._searchCriteria)
            {
               _loc3_.push({
                  "id":0,
                  "name":this._noneText
               });
            }
            if(this._showAll)
            {
               _loc4_ = this._allTitles;
            }
            else
            {
               _loc4_ = this._myTitles;
            }
            for each(_loc5_ in _loc4_)
            {
               if(!this._searchCriteria || this._searchCriteria && this.utilApi.noAccent(_loc5_.name).toLowerCase().indexOf(this.utilApi.noAccent(this._searchCriteria)) != -1)
               {
                  _loc3_.push(_loc5_);
               }
            }
            this.gd_titles.dataProvider = _loc3_;
            this.selectMineInGrid();
         }
         else if(this._nCurrentTab == TAB_ORNAMENT || param2 && param1 == TAB_ORNAMENT)
         {
            _loc6_ = new Array();
            if(!this._searchCriteria)
            {
               _loc6_.push({
                  "id":0,
                  "name":this._noneText
               });
            }
            if(this._showAll)
            {
               _loc7_ = this._allOrnaments;
            }
            else
            {
               _loc7_ = this._myOrnaments;
            }
            for each(_loc8_ in _loc7_)
            {
               if(!this._searchCriteria || this.utilApi.noAccent(_loc8_.name).toLowerCase().indexOf(this.utilApi.noAccent(this._searchCriteria)) != -1)
               {
                  _loc6_.push(_loc8_);
               }
            }
            this.gd_orns.dataProvider = _loc6_;
            this.selectMineInGrid();
         }
      }
      
      private function updateCategories() : void
      {
      }
      
      private function displayTooltip(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc6_:Title = null;
         var _loc7_:int = 0;
         var _loc8_:Ornament = null;
         if(this.ed_chara.width == 0)
         {
            return;
         }
         this.checkSaveButton();
         if(!this._tooltipInfos || this._tooltipInfos.titleColor == null)
         {
            _loc4_ = this.playerApi.getEntityTooltipInfos();
            if(_loc4_)
            {
               this._tooltipInfos = {
                  "titleName":_loc4_.titleName,
                  "titleColor":_loc4_.titleColor,
                  "ornamentAssetId":_loc4_.ornamentAssetId,
                  "wingsEffect":_loc4_.wingsEffect,
                  "infos":_loc4_.infos
               };
            }
            else
            {
               this._tooltipInfos = {
                  "titleName":"",
                  "titleColor":"",
                  "ornamentAssetId":0,
                  "wingsEffect":0,
                  "infos":{"name":this.playerApi.getPlayedCharacterInfo().name}
               };
            }
            if(this.playerApi.characteristics().alignmentInfos && (this.playerApi.characteristics().alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE || this.playerApi.characteristics().alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_NON_AGGRESSABLE))
            {
               this.tx_warning.visible = true;
               this._wingsOut = true;
            }
            else
            {
               this.tx_warning.visible = false;
               this._wingsOut = false;
            }
         }
         if(param1)
         {
            _loc5_ = "";
            if(this._titleId > 0)
            {
               _loc6_ = this.dataApi.getTitle(this._titleId);
               if(_loc6_)
               {
                  _loc5_ = "« " + _loc6_.name + " »";
               }
            }
            else
            {
               _loc5_ = "";
            }
            this._tooltipInfos.titleName = _loc5_;
         }
         if(param2)
         {
            _loc7_ = 0;
            if(this._ornamentId > 0)
            {
               _loc8_ = this.dataApi.getOrnament(this._ornamentId);
               _loc7_ = _loc8_.assetId;
            }
            this._tooltipInfos.ornamentAssetId = _loc7_;
         }
         var _loc3_:* = this.ed_chara["getBounds"](this.uiApi.me());
         this.uiApi.hideTooltip(TOOLTIP_CHARA);
         this.uiApi.showTooltip(this._tooltipInfos,_loc3_,false,TOOLTIP_CHARA,7,1,20,"player",null,null,null,false,StrataEnum.STRATA_MEDIUM,1.5);
      }
      
      private function checkSaveButton() : void
      {
         if(this.playerApi.isInFight() || (this._titleId == this._titleIdAtStart || this._titleId > 0 && this._myTitlesIds.indexOf(this._titleId) == -1) && (this._ornamentId == this._ornamentIdAtStart || this._ornamentId > 0 && this._myOrnamentsIds.indexOf(this._ornamentId) == -1))
         {
            this.btn_save.disabled = true;
         }
         else
         {
            this.btn_save.disabled = false;
         }
      }
      
      private function selectMineInGrid() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:int = 0;
         if(this._nCurrentTab == TAB_TITLE)
         {
            for each(_loc3_ in this.gd_titles.dataProvider)
            {
               if(_loc3_.id == this._titleId)
               {
                  _loc2_ = true;
                  break;
               }
               _loc1_++;
            }
            if(!_loc2_)
            {
               _loc1_ = 0;
            }
            this.gd_titles.selectedIndex = _loc1_;
         }
         else
         {
            for each(_loc4_ in this.gd_orns.dataProvider)
            {
               if(_loc4_.id == this._ornamentId)
               {
                  _loc2_ = true;
                  break;
               }
               _loc1_++;
            }
            if(!_loc2_)
            {
               _loc1_ = 0;
            }
            this.gd_orns.selectedIndex = _loc1_;
         }
      }
      
      private function wheelChara(param1:int) : void
      {
         this._direction = (this._direction + param1 + 8) % 8;
         this.ed_chara.direction = this._direction;
      }
      
      public function onRelease(param1:Object) : void
      {
         this._focusOnSearch = false;
         switch(param1)
         {
            case this.btn_title:
               this.openSelectedTab(TAB_TITLE);
               this.updateGrid();
               break;
            case this.btn_ornament:
               this.openSelectedTab(TAB_ORNAMENT);
               this.updateGrid();
               break;
            case this.btn_resetSearch:
               this._searchCriteria = null;
               this.inp_search.text = this.getSearchText();
               this.updateGrid();
               break;
            case this.btn_reset:
               this._titleId = this._titleIdAtStart;
               this._ornamentId = this._ornamentIdAtStart;
               this.checkSaveButton();
               this.displayTooltip(true,true);
               this.selectMineInGrid();
               break;
            case this.btn_save:
               if(this._titleId != this._titleIdAtStart)
               {
                  this.sysApi.sendAction(new TitleSelectRequest(this._titleId));
               }
               if(this._ornamentId != this._ornamentIdAtStart)
               {
                  this.sysApi.sendAction(new OrnamentSelectRequest(this._ornamentId));
               }
               break;
            case this.btn_showAll:
               this._showAll = this.btn_showAll.selected;
               this.sysApi.setData("showAllTitlesAndOrnaments",this._showAll);
               this.updateGrid();
               break;
            case this.btn_leftArrow:
               this.wheelChara(1);
               break;
            case this.btn_rightArrow:
               this.wheelChara(-1);
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.inp_search:
               if(this.getSearchText() == this.inp_search.text)
               {
                  this.inp_search.text = "";
               }
               this._focusOnSearch = true;
         }
         if(param1 != this.inp_search && this.inp_search && this.inp_search.text.length == 0)
         {
            this.inp_search.text = this.getSearchText();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         switch(param1)
         {
            case this.inp_search:
               _loc2_ = this.getSearchText();
               break;
            case this.tx_warning:
               _loc2_ = this.uiApi.getText("ui.ornament.warningWings");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2 != GridItemSelectMethodEnum.AUTO)
         {
            switch(param1)
            {
               case this.gd_titles:
                  _loc4_ = param1.selectedItem.id;
                  if(_loc4_ != this._titleId || this._waitingForTooltipUpdate)
                  {
                     this._waitingForTooltipUpdate = false;
                     this._titleId = _loc4_;
                     this.displayTooltip(true,false);
                  }
                  break;
               case this.gd_orns:
                  _loc5_ = param1.selectedItem.id;
                  if(_loc5_ != this._ornamentId || this._waitingForTooltipUpdate)
                  {
                     this._waitingForTooltipUpdate = false;
                     this._ornamentId = _loc5_;
                     this.displayTooltip(false,true);
                  }
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
      }
      
      public function onEntityReady(param1:Object) : void
      {
         if(param1 == this.ed_chara && !this._waitingForOrnsMsg && !this._waitingForTitlesMsg)
         {
            this.displayTooltip();
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.ctr_search.visible && this.inp_search.haveFocus)
         {
            if(this.inp_search.text.length > 2)
            {
               this._searchCriteria = this.inp_search.text.toLowerCase();
               this.updateGrid();
            }
            else
            {
               if(this._searchCriteria)
               {
                  this._searchCriteria = null;
               }
               if(this._nCurrentTab == TAB_TITLE)
               {
                  this.gd_titles.dataProvider = new Array();
               }
               else if(this._nCurrentTab == TAB_ORNAMENT)
               {
                  this.updateGrid();
               }
            }
         }
      }
      
      public function onFocusChange(param1:Object) : void
      {
         if(param1 && param1 != this.inp_search && this._focusOnSearch)
         {
            this.onRelease(null);
         }
      }
      
      public function onTitleUpdated(param1:int) : void
      {
         this._titleIdAtStart = param1;
         this._titleId = this._titleIdAtStart;
         this.checkSaveButton();
      }
      
      public function onOrnamentUpdated(param1:int) : void
      {
         this._ornamentIdAtStart = param1;
         this._ornamentId = this._ornamentIdAtStart;
         this.checkSaveButton();
      }
      
      public function onTitlesListUpdated(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Title = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         this._myTitlesIds = new Array();
         this._myTitles = new Array();
         for each(_loc2_ in param1)
         {
            this._myTitlesIds.push(_loc2_);
            this._myTitles.push(this.dataApi.getTitle(_loc2_));
         }
         for each(_loc3_ in this._dataTitles)
         {
            if(_loc3_.visible || this._myTitlesIds.indexOf(_loc3_.id) != -1)
            {
               this._allTitles.push(_loc3_);
            }
         }
         this._waitingForTitlesMsg = false;
         if(!this._waitingForOrnsMsg)
         {
            _loc4_ = this.playerApi.getTitle();
            if(_loc4_)
            {
               this._titleIdAtStart = _loc4_.id;
               this._titleId = this._titleIdAtStart;
            }
            _loc5_ = this.playerApi.getOrnament();
            if(_loc5_)
            {
               this._ornamentIdAtStart = _loc5_.id;
               this._ornamentId = this._ornamentIdAtStart;
            }
            this.updateGrid(TAB_TITLE,true);
            this.displayTooltip(true,true);
            if(this._param && this._param.id)
            {
               this.onOpenTitle("titleTab",{
                  "forceOpen":true,
                  "id":this._param.id,
                  "idIsTitle":this._param.idIsTitle
               });
            }
         }
      }
      
      public function onOrnamentsListUpdated(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Ornament = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         for each(_loc2_ in param1)
         {
            if(this._myOrnamentsIds.indexOf(_loc2_) == -1)
            {
               this._myOrnamentsIds.push(_loc2_);
               this._myOrnaments.push(this.dataApi.getOrnament(_loc2_));
            }
         }
         this._myOrnaments.sortOn("order",Array.NUMERIC);
         for each(_loc3_ in this._dataOrnaments)
         {
            if(_loc3_.visible || this._myOrnamentsIds.indexOf(_loc3_.id) != -1)
            {
               this._allOrnaments.push(_loc3_);
            }
         }
         this._allOrnaments.sortOn("order",Array.NUMERIC);
         this._waitingForOrnsMsg = false;
         if(!this._waitingForTitlesMsg)
         {
            _loc4_ = this.playerApi.getTitle();
            if(_loc4_)
            {
               this._titleIdAtStart = _loc4_.id;
               this._titleId = this._titleIdAtStart;
            }
            _loc5_ = this.playerApi.getOrnament();
            if(_loc5_)
            {
               this._ornamentIdAtStart = _loc5_.id;
               this._ornamentId = this._ornamentIdAtStart;
            }
            this.updateGrid(TAB_ORNAMENT,true);
            this.displayTooltip(true,true);
            if(this._param && this._param.id)
            {
               this.onOpenTitle("titleTab",{
                  "forceOpen":true,
                  "id":this._param.id,
                  "idIsTitle":this._param.idIsTitle
               });
            }
         }
      }
      
      private function onOpenTitle(param1:String = null, param2:Object = null) : void
      {
         var _loc3_:int = 0;
         if(param1 == "titleTab" && param2 && param2.forceOpen)
         {
            _loc3_ = 0;
            if(param2.idIsTitle)
            {
               this.btn_title.selected = true;
               this.openSelectedTab(TAB_TITLE);
               this._titleId = param2.id;
            }
            else
            {
               this.btn_ornament.selected = true;
               this.openSelectedTab(TAB_ORNAMENT);
               this._ornamentId = param2.id;
            }
            this._waitingForTooltipUpdate = true;
            this.updateGrid();
         }
      }
      
      private function getSearchText() : *
      {
         if(this._nCurrentTab == TAB_ORNAMENT)
         {
            return this.uiApi.getText("ui.ornament.ornamentsearch");
         }
         return this.uiApi.getText("ui.ornament.titlesearch");
      }
   }
}
