package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.world.Dungeon;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.DungeonPartyFinderPlayer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.DungeonPartyFinderListen;
   import d2actions.PartyInvitation;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.DungeonPartyFinderAvailableDungeons;
   import d2hooks.DungeonPartyFinderRegister;
   import d2hooks.DungeonPartyFinderRoomContent;
   import d2hooks.KeyUp;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class TeamSearch
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var partyApi:PartyApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      private const MAX_CHOSEN_DUNGEONS:uint = 10;
      
      private const FIGHTERS_LEVEL_FILTER_RANGE:uint = 50;
      
      private var _chosenDonjonsList:Array;
      
      private var _donjonsList:Array;
      
      private var _fightersList:Array;
      
      private var _donjonsFilter:Object;
      
      private var _fightersBreedFilter:Object;
      
      private var _fightersLevelFilter:Object;
      
      private var _nCurrentTab:uint = 0;
      
      private var _currentRegisterState:uint = 0;
      
      private var _bDescendingSortDonjons:Boolean = false;
      
      private var _bDescendingSortPlayers:Boolean = false;
      
      private var _addBtnList:Dictionary;
      
      private var _removeBtnList:Dictionary;
      
      private var _delaySendUpdateTimer:Timer;
      
      private var _updateNeeded:Boolean = false;
      
      private var _neverOpenedBefore:Boolean = true;
      
      public var btn_register:ButtonContainer;
      
      public var btn_search:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var ctr_donjons:GraphicContainer;
      
      public var inp_searchDonjon:Input;
      
      public var cbx_level:ComboBox;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabLevel:ButtonContainer;
      
      public var gd_donjons:Grid;
      
      public var ctr_register:GraphicContainer;
      
      public var gd_chosenDonjons:Grid;
      
      public var btn_subscribe:ButtonContainer;
      
      public var btn_lbl_btn_subscribe:Label;
      
      public var ctr_search:GraphicContainer;
      
      public var btn_tabSearchName:ButtonContainer;
      
      public var btn_tabSearchBreed:ButtonContainer;
      
      public var btn_tabSearchLevel:ButtonContainer;
      
      public var gd_fightersSearch:Grid;
      
      public var cbx_levelFighters:ComboBox;
      
      public var cbx_breedFighters:ComboBox;
      
      public var btn_invite:ButtonContainer;
      
      public function TeamSearch()
      {
         this._addBtnList = new Dictionary(true);
         this._removeBtnList = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         var _loc3_:Breed = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.btn_register.soundId = SoundEnum.TAB;
         this.btn_search.soundId = SoundEnum.TAB;
         this.sysApi.addHook(d2hooks.DungeonPartyFinderAvailableDungeons,this.onDungeonPartyFinderAvailableDungeons);
         this.sysApi.addHook(DungeonPartyFinderRoomContent,this.onDungeonPartyFinderRoomContent);
         this.sysApi.addHook(d2hooks.DungeonPartyFinderRegister,this.onDungeonPartyFinderRegister);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addComponentHook(this.btn_register,"onRelease");
         this.uiApi.addComponentHook(this.btn_search,"onRelease");
         this.uiApi.addComponentHook(this.btn_subscribe,"onRelease");
         this.uiApi.addComponentHook(this.btn_invite,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabName,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabLevel,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabSearchBreed,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabSearchLevel,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabSearchName,"onRelease");
         this.uiApi.addComponentHook(this.gd_donjons,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_chosenDonjons,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_fightersSearch,"onSelectItem");
         this.uiApi.addComponentHook(this.cbx_level,"onSelectItem");
         this.uiApi.addComponentHook(this.cbx_breedFighters,"onSelectItem");
         this.uiApi.addComponentHook(this.cbx_levelFighters,"onSelectItem");
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._delaySendUpdateTimer = new Timer(5000);
         this._delaySendUpdateTimer.addEventListener(TimerEvent.TIMER,this.onDelayUpdateTimer);
         this._fightersList = new Array();
         this._donjonsList = new Array();
         this._chosenDonjonsList = new Array();
         this.gd_fightersSearch.dataProvider = new Array();
         var _loc2_:Array = new Array();
         _loc2_.push({
            "label":this.uiApi.getText("ui.common.allBreeds"),
            "value":0
         });
         for each(_loc3_ in this.dataApi.getBreeds())
         {
            _loc2_.push({
               "label":_loc3_.shortName,
               "value":_loc3_.id
            });
         }
         this.cbx_breedFighters.dataProvider = _loc2_;
         this._fightersBreedFilter = _loc2_[0];
         _loc4_ = new Array();
         _loc4_.push({
            "label":this.uiApi.getText("ui.common.allLevels"),
            "value":0
         });
         for each(_loc5_ in [50,100,150,200])
         {
            _loc4_.push({
               "label":_loc5_ - this.FIGHTERS_LEVEL_FILTER_RANGE + 1 + "-" + _loc5_,
               "value":_loc5_
            });
         }
         this.cbx_levelFighters.dataProvider = _loc4_;
         this._fightersLevelFilter = _loc4_[0];
         this.sysApi.sendAction(new d2actions.DungeonPartyFinderAvailableDungeons());
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_register,this.uiApi.me());
         this.btn_register.selected = true;
         this.btn_subscribe.disabled = true;
         this.btn_invite.disabled = true;
         this._nCurrentTab = Party.getInstance().teamSearchTab;
         this.displaySelectedTab(this._nCurrentTab);
         if(this.partyApi.getAllSubscribedDungeons() && this.partyApi.getAllSubscribedDungeons().length > 0)
         {
            _loc6_ = 0;
            for each(_loc7_ in this.partyApi.getAllSubscribedDungeons())
            {
               if(_loc6_ < ProtocolConstantsEnum.MAX_DUNGEON_REGISTER)
               {
                  this._chosenDonjonsList.push(this.dataApi.getDungeon(_loc7_));
               }
               _loc6_++;
            }
            this.onDungeonPartyFinderRegister(true);
         }
         if(this._chosenDonjonsList.length > 0)
         {
            this.btn_subscribe.disabled = false;
         }
         this.gd_chosenDonjons.dataProvider = this._chosenDonjonsList;
      }
      
      public function unload() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Dungeon = null;
         if(this._delaySendUpdateTimer)
         {
            this._delaySendUpdateTimer.removeEventListener(TimerEvent.TIMER,this.onDelayUpdateTimer);
            this._delaySendUpdateTimer.stop();
            this._delaySendUpdateTimer = null;
            if(this._updateNeeded)
            {
               _loc1_ = new Array();
               for each(_loc2_ in this._chosenDonjonsList)
               {
                  _loc1_.push(_loc2_.id);
               }
               this.sysApi.sendAction(new d2actions.DungeonPartyFinderRegister(_loc1_));
            }
            this.sysApi.sendAction(new DungeonPartyFinderListen(0));
         }
      }
      
      private function displaySelectedTab(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               this.ctr_register.visible = true;
               this.ctr_search.visible = false;
               this.btn_register.selected = true;
               break;
            case 1:
               this.ctr_register.visible = false;
               this.ctr_search.visible = true;
               this.btn_search.selected = true;
         }
         if(Party.getInstance().teamSearchTab != param1)
         {
            Party.getInstance().teamSearchTab = param1;
         }
         var _loc2_:int = this.gd_donjons.selectedIndex;
         this.gd_donjons.selectedIndex = -1;
         this.gd_donjons.selectedIndex = _loc2_;
      }
      
      private function filterFighters() : void
      {
         var _loc1_:Array = null;
         var _loc2_:DungeonPartyFinderPlayer = null;
         if(this._fightersBreedFilter && this._fightersLevelFilter)
         {
            _loc1_ = new Array();
            if(this._fightersBreedFilter.value == 0)
            {
               if(this._fightersLevelFilter.value == 0)
               {
                  if(this.gd_fightersSearch.dataProvider != this._fightersList)
                  {
                     _loc1_ = this._fightersList;
                  }
               }
               else
               {
                  for each(_loc2_ in this._fightersList)
                  {
                     if(_loc2_.level <= this._fightersLevelFilter.value && _loc2_.level > this._fightersLevelFilter.value - this.FIGHTERS_LEVEL_FILTER_RANGE)
                     {
                        _loc1_.push(_loc2_);
                     }
                  }
               }
            }
            else if(this._fightersLevelFilter.value == 0)
            {
               for each(_loc2_ in this._fightersList)
               {
                  if(_loc2_.breed == this._fightersBreedFilter.value)
                  {
                     _loc1_.push(_loc2_);
                  }
               }
            }
            else
            {
               for each(_loc2_ in this._fightersList)
               {
                  if(_loc2_.level <= this._fightersLevelFilter.value && _loc2_.level > this._fightersLevelFilter.value - this.FIGHTERS_LEVEL_FILTER_RANGE && _loc2_.breed == this._fightersBreedFilter.value)
                  {
                     _loc1_.push(_loc2_);
                  }
               }
            }
            if(_loc1_.length > 50)
            {
               _loc1_ = _loc1_.slice(0,50);
            }
            this.gd_fightersSearch.dataProvider = _loc1_;
            if(_loc1_.length == 0 || this.gd_fightersSearch.selectedIndex == -1)
            {
               this.btn_invite.disabled = true;
            }
            else
            {
               this.btn_invite.disabled = false;
            }
         }
      }
      
      private function filterDungeons() : void
      {
         var _loc3_:Dungeon = null;
         var _loc1_:String = this.inp_searchDonjon.text;
         var _loc2_:Array = new Array();
         if(this._donjonsFilter.value == 0 && !_loc1_)
         {
            if(this.gd_donjons.dataProvider.length != this._donjonsList.length)
            {
               _loc2_ = this._donjonsList;
            }
            else
            {
               return;
            }
         }
         else
         {
            for each(_loc3_ in this._donjonsList)
            {
               if(_loc3_.optimalPlayerLevel >= this._donjonsFilter.value)
               {
                  if(_loc1_)
                  {
                     if(this.utilApi.noAccent(_loc3_.name).toLowerCase().indexOf(this.utilApi.noAccent(_loc1_).toLowerCase()) != -1)
                     {
                        _loc2_.push(_loc3_);
                     }
                  }
                  else
                  {
                     _loc2_.push(_loc3_);
                  }
               }
            }
         }
         this.gd_donjons.dataProvider = _loc2_;
      }
      
      public function updateDonjonLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._addBtnList[param2.btn_add.name])
         {
            this.uiApi.addComponentHook(param2.btn_add,"onRelease");
            this.uiApi.addComponentHook(param2.btn_add,"onRollOver");
            this.uiApi.addComponentHook(param2.btn_add,"onRollOut");
         }
         this._addBtnList[param2.btn_add.name] = param1;
         if(param1)
         {
            param2.btn_donjon.softDisabled = false;
            param2.btn_donjon.selected = param3;
            if(param3 && this._nCurrentTab == 0)
            {
               param2.btn_add.visible = true;
            }
            else
            {
               param2.btn_add.visible = false;
            }
            if(this._chosenDonjonsList.length >= ProtocolConstantsEnum.MAX_DUNGEON_REGISTER)
            {
               param2.btn_add.disabled = true;
            }
            else
            {
               param2.btn_add.disabled = false;
            }
            param2.lbl_name.text = param1.name;
            param2.lbl_level.text = "" + param1.optimalPlayerLevel;
         }
         else
         {
            param2.btn_add.selected = false;
            param2.btn_add.visible = false;
            param2.lbl_name.text = "";
            param2.lbl_level.text = "";
            param2.btn_donjon.selected = false;
            param2.btn_donjon.softDisabled = true;
         }
      }
      
      public function updateChosenDonjonLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._removeBtnList[param2.btn_remove.name])
         {
            this.uiApi.addComponentHook(param2.btn_remove,"onRelease");
            this.uiApi.addComponentHook(param2.btn_remove,"onRollOver");
            this.uiApi.addComponentHook(param2.btn_remove,"onRollOut");
         }
         this._removeBtnList[param2.btn_remove.name] = param1;
         if(param1)
         {
            param2.btn_donjon.softDisabled = false;
            param2.btn_donjon.selected = param3;
            if(this._currentRegisterState == 0)
            {
               param2.tx_bg.bgAlpha = 0.3;
            }
            else
            {
               param2.tx_bg.bgAlpha = 0;
            }
            param2.lbl_name.text = param1.name;
            param2.lbl_level.text = param1.optimalPlayerLevel;
            param2.btn_remove.visible = true;
         }
         else
         {
            param2.tx_bg.bgAlpha = 0;
            param2.btn_remove.visible = false;
            param2.lbl_name.text = "";
            param2.lbl_level.text = "";
            param2.btn_donjon.selected = false;
            param2.btn_donjon.softDisabled = true;
         }
      }
      
      public function updateFighterLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:* = null;
         if(param1)
         {
            param2.btn_fighter.softDisabled = false;
            param2.btn_fighter.selected = param3;
            _loc4_ = "{player," + param1.playerName + "," + param1.playerId + "::" + param1.playerName + "}";
            param2.lbl_name.text = _loc4_;
            param2.lbl_breed.text = this.dataApi.getBreed(param1.breed).shortName;
            param2.lbl_level.text = param1.level;
         }
         else
         {
            param2.btn_fighter.selected = false;
            param2.btn_fighter.softDisabled = true;
            param2.lbl_name.text = "";
            param2.lbl_breed.text = "";
            param2.lbl_level.text = "";
         }
      }
      
      private function onDungeonPartyFinderAvailableDungeons(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Dungeon = null;
         var _loc9_:Object = null;
         this._donjonsList = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         _loc2_.push({
            "label":this.uiApi.getText("ui.common.allLevels"),
            "value":0
         });
         for each(_loc4_ in param1)
         {
            _loc8_ = this.dataApi.getDungeon(_loc4_);
            this._donjonsList.push(_loc8_);
            if(_loc3_.indexOf(_loc8_.optimalPlayerLevel) == -1)
            {
               _loc3_.push(_loc8_.optimalPlayerLevel);
            }
         }
         this._donjonsList.sortOn("optimalPlayerLevel",Array.NUMERIC);
         _loc3_.sort(Array.NUMERIC);
         for each(_loc5_ in _loc3_)
         {
            _loc2_.push({
               "label":">" + _loc5_,
               "value":_loc5_
            });
         }
         _loc6_ = this.gd_donjons.selectedIndex;
         this.gd_donjons.dataProvider = this._donjonsList;
         this.cbx_level.dataProvider = _loc2_;
         this._donjonsFilter = _loc2_[0];
         _loc7_ = 0;
         if(this._neverOpenedBefore)
         {
            _loc7_ = Party.getInstance().teamSearchDonjon;
            _loc6_ = 0;
            for each(_loc9_ in this.gd_donjons.dataProvider)
            {
               if(_loc9_.id == _loc7_)
               {
                  break;
               }
               _loc6_++;
            }
         }
         this.gd_donjons.selectedIndex = -1;
         this.gd_donjons.selectedIndex = _loc6_;
      }
      
      private function onDungeonPartyFinderRoomContent(param1:Object) : void
      {
         var _loc2_:DungeonPartyFinderPlayer = null;
         this._fightersList = new Array();
         for each(_loc2_ in param1)
         {
            if(_loc2_.playerId != this.playerApi.id())
            {
               this._fightersList.push(_loc2_);
            }
         }
         this.filterFighters();
      }
      
      private function onDungeonPartyFinderRegister(param1:Boolean) : void
      {
         this.btn_subscribe.softDisabled = false;
         this._updateNeeded = false;
         if(param1)
         {
            this._currentRegisterState = 1;
            this.btn_lbl_btn_subscribe.text = this.uiApi.getText("ui.teamSearch.unregistration");
            this.gd_chosenDonjons.dataProvider = this._chosenDonjonsList;
            this.btn_subscribe.disabled = false;
            if(!this._delaySendUpdateTimer.running)
            {
               this._delaySendUpdateTimer.start();
            }
         }
         else
         {
            this._currentRegisterState = 0;
            this.btn_lbl_btn_subscribe.text = this.uiApi.getText("ui.teamSearch.registration");
            this.btn_subscribe.disabled = true;
            this.gd_chosenDonjons.dataProvider = new Array();
            this._chosenDonjonsList = new Array();
         }
      }
      
      public function onDelayUpdateTimer(param1:TimerEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Dungeon = null;
         if(this._updateNeeded)
         {
            this.btn_subscribe.softDisabled = true;
            _loc2_ = new Array();
            for each(_loc3_ in this._chosenDonjonsList)
            {
               _loc2_.push(_loc3_.id);
            }
            this.sysApi.sendAction(new d2actions.DungeonPartyFinderRegister(_loc2_));
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               if(!this.inp_searchDonjon.haveFocus)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Dungeon = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_subscribe:
               if(this.gd_chosenDonjons.dataProvider.length > 0)
               {
                  this.btn_subscribe.softDisabled = true;
                  _loc2_ = new Array();
                  if(this._currentRegisterState == 0)
                  {
                     for each(_loc3_ in this._chosenDonjonsList)
                     {
                        _loc2_.push(_loc3_.id);
                     }
                  }
                  this.sysApi.sendAction(new d2actions.DungeonPartyFinderRegister(_loc2_));
               }
               else if(this._currentRegisterState == 1)
               {
                  this.sysApi.sendAction(new d2actions.DungeonPartyFinderRegister(new Array()));
                  this._delaySendUpdateTimer.reset();
               }
               break;
            case this.btn_invite:
               if(this.gd_fightersSearch.selectedItem)
               {
                  _loc4_ = this.gd_fightersSearch.selectedItem.playerName;
                  this.sysApi.sendAction(new PartyInvitation(_loc4_,this.gd_donjons.selectedItem.id));
               }
               break;
            case this.btn_register:
               if(this._nCurrentTab != 0)
               {
                  this._neverOpenedBefore = false;
                  this._nCurrentTab = 0;
                  this.displaySelectedTab(this._nCurrentTab);
               }
               break;
            case this.btn_search:
               if(this._nCurrentTab != 1)
               {
                  this._neverOpenedBefore = false;
                  this._nCurrentTab = 1;
                  this.displaySelectedTab(this._nCurrentTab);
               }
               break;
            case this.btn_tabLevel:
               if(this._bDescendingSortDonjons)
               {
                  this.gd_donjons.sortOn("optimalPlayerLevel",Array.NUMERIC);
               }
               else
               {
                  this.gd_donjons.sortOn("optimalPlayerLevel",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSortDonjons = !this._bDescendingSortDonjons;
               break;
            case this.btn_tabName:
               if(this._bDescendingSortDonjons)
               {
                  this.gd_donjons.sortOn("name",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_donjons.sortOn("name",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSortDonjons = !this._bDescendingSortDonjons;
               break;
            case this.btn_tabSearchName:
               if(this._bDescendingSortPlayers)
               {
                  this.gd_fightersSearch.sortOn("playerName",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_fightersSearch.sortOn("playerName",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSortPlayers = !this._bDescendingSortPlayers;
               break;
            case this.btn_tabSearchLevel:
               if(this._bDescendingSortPlayers)
               {
                  this.gd_fightersSearch.sortOn("level",Array.NUMERIC);
               }
               else
               {
                  this.gd_fightersSearch.sortOn("level",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSortPlayers = !this._bDescendingSortPlayers;
               break;
            case this.btn_tabSearchBreed:
               if(this._bDescendingSortPlayers)
               {
                  this.gd_fightersSearch.sortOn("breed",Array.NUMERIC);
               }
               else
               {
                  this.gd_fightersSearch.sortOn("breed",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSortPlayers = !this._bDescendingSortPlayers;
               break;
            default:
               if(param1.name.indexOf("btn_add") != -1)
               {
                  if(this._chosenDonjonsList.indexOf(this._addBtnList[param1.name]) == -1 && this._chosenDonjonsList.length < ProtocolConstantsEnum.MAX_DUNGEON_REGISTER)
                  {
                     this._chosenDonjonsList.push(this._addBtnList[param1.name]);
                     this.gd_chosenDonjons.dataProvider = this._chosenDonjonsList;
                     this.btn_subscribe.disabled = false;
                     this._updateNeeded = true;
                     _loc5_ = this.gd_donjons.selectedIndex;
                     this.gd_donjons.selectedIndex = -1;
                     this.gd_donjons.selectedIndex = _loc5_;
                  }
               }
               else if(param1.name.indexOf("btn_remove") != -1)
               {
                  this._chosenDonjonsList.splice(this.gd_chosenDonjons.selectedIndex,1);
                  this.gd_chosenDonjons.dataProvider = this._chosenDonjonsList;
                  if(this._chosenDonjonsList.length == 0)
                  {
                     this.btn_subscribe.disabled = true;
                  }
                  this._updateNeeded = true;
                  _loc6_ = this.gd_donjons.selectedIndex;
                  this.gd_donjons.selectedIndex = -1;
                  this.gd_donjons.selectedIndex = _loc6_;
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         switch(param1)
         {
            case this.gd_donjons:
               if(this.gd_donjons.selectedIndex >= 0)
               {
                  if(!this.gd_donjons.dataProvider[this.gd_donjons.selectedIndex])
                  {
                     break;
                  }
                  _loc4_ = this.gd_donjons.dataProvider[this.gd_donjons.selectedIndex].id;
                  if(this._nCurrentTab == 1)
                  {
                     this.sysApi.sendAction(new DungeonPartyFinderListen(_loc4_));
                  }
                  if(Party.getInstance().teamSearchDonjon != _loc4_)
                  {
                     Party.getInstance().teamSearchDonjon = _loc4_;
                  }
                  this._neverOpenedBefore = false;
               }
               break;
            case this.cbx_level:
               switch(param2)
               {
                  case 0:
                  case 3:
                  case 4:
                  case 8:
                     this._donjonsFilter = this.cbx_level.dataProvider[param1.selectedIndex];
                     this.filterDungeons();
               }
               break;
            case this.cbx_breedFighters:
               switch(param2)
               {
                  case 0:
                  case 3:
                  case 4:
                  case 8:
                     this._fightersBreedFilter = this.cbx_breedFighters.dataProvider[param1.selectedIndex];
                     this.filterFighters();
               }
               break;
            case this.cbx_levelFighters:
               switch(param2)
               {
                  case 0:
                  case 3:
                  case 4:
                  case 8:
                     this._fightersLevelFilter = this.cbx_levelFighters.dataProvider[param1.selectedIndex];
                     this.filterFighters();
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc2_:uint = 7;
         var _loc3_:uint = 1;
         if(param1.name.indexOf("btn_add") != -1)
         {
            _loc4_ = this.uiApi.getText("ui.teamSearch.addDonjon");
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc4_),param1,false,"standard",_loc2_,_loc3_,3,null,null,null,"TextInfo");
         }
         else if(param1.name.indexOf("btn_remove") != -1)
         {
            _loc4_ = this.uiApi.getText("ui.teamSearch.removeDonjon");
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc4_),param1,false,"standard",_loc2_,_loc3_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_searchDonjon.haveFocus)
         {
            this.filterDungeons();
         }
      }
   }
}
