package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.AcquaintanceSearch;
   import d2actions.ResetGame;
   import d2enums.ComponentHookList;
   import d2hooks.AcquaintanceSearchError;
   import d2hooks.AcquaintanceServerList;
   import d2hooks.SelectedServerRefused;
   import d2hooks.ServerConnectionStarted;
   import d2hooks.ServerSelectionStart;
   import d2hooks.ServersList;
   import d2hooks.TextureLoadFailed;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class ServerListSelection
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var connecApi:ConnectionApi;
      
      public var soundApi:SoundApi;
      
      public var timeApi:TimeApi;
      
      private var INPUT_SEARCH_DEFAULT_TEXT:String;
      
      private var _currentServer:Object;
      
      private var _serverInfo:Object;
      
      private var _aServers:Array;
      
      private var _aMyCommuServers:Array;
      
      private var _aMyServers:Array;
      
      private var _nNbServers:uint;
      
      private var _aDataServers:Array;
      
      private var _bReload:Boolean = false;
      
      private var _assetsUri:String;
      
      private var _flagUri:String;
      
      private var _popupName:String;
      
      private var _popupInUse:int = 0;
      
      private var _lockSearchTimer:Timer;
      
      private var _clockStart:Number;
      
      private var _aFriendServers:Array;
      
      private var _modeAutochoice:Boolean = false;
      
      private var _gridComponentsList:Dictionary;
      
      public var gd_listServer:Grid;
      
      public var tx_serverPic:Texture;
      
      public var inp_search:Input;
      
      public var btn_friendSearch:ButtonContainer;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var btn_cancel:ButtonContainer;
      
      public var btn_ckboxCommu:ButtonContainer;
      
      public var btn_ckboxMy:ButtonContainer;
      
      public var btn_tabCountry:ButtonContainer;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabState:ButtonContainer;
      
      public var btn_tabPopulation:ButtonContainer;
      
      public var btn_tabType:ButtonContainer;
      
      public var btn_validate:ButtonContainer;
      
      public var btn_autochoice:ButtonContainer;
      
      public function ServerListSelection()
      {
         this._gridComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.soundApi.switchIntroMusic();
         this.btn_cancel.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_autochoice.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_validate.soundId = "-1";
         this.sysApi.addHook(ServersList,this.onServersList);
         this.sysApi.addHook(SelectedServerRefused,this.onSelectedServerRefused);
         this.sysApi.addHook(ServerConnectionStarted,this.onServerConnectionStarted);
         this.sysApi.addHook(AcquaintanceSearchError,this.onAcquaintanceSearchError);
         this.sysApi.addHook(AcquaintanceServerList,this.onAcquaintanceServerList);
         this.sysApi.addHook(TextureLoadFailed,this.onIlluLoadFailed);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_validate,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_validate,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_listServer,ComponentHookList.ON_SELECT_ITEM);
         this.inp_search.maxChars = 300;
         this.INPUT_SEARCH_DEFAULT_TEXT = this.uiApi.getText("ui.sersel.findFriend");
         this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
         this._assetsUri = this.uiApi.me().getConstant("texture");
         this._flagUri = this.uiApi.me().getConstant("flag_uri");
         this.tx_serverPic.dispatchMessages = true;
         if(param1 && param1.servers && param1.servers.length > 0)
         {
            this.onServersList(param1.servers);
         }
         else
         {
            this.onServersList(this.connecApi.getServers());
         }
         this.gd_listServer.focus();
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("serverForm5");
         this.uiApi.unloadUi("serverPopup");
         this.uiApi.unloadUi(this._popupName);
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function updateServerLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(param1)
         {
            if(!this._gridComponentsList[param2.tx_flag.name])
            {
               this.uiApi.addComponentHook(param2.tx_flag,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_flag,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.tx_flag.name] = param1;
            if(!this._gridComponentsList[param2.lbl_infoName.name])
            {
               this.uiApi.addComponentHook(param2.lbl_infoName,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.lbl_infoName,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.lbl_infoName.name] = param1;
            if(!this._gridComponentsList[param2.tx_infoState.name])
            {
               this.uiApi.addComponentHook(param2.tx_infoState,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_infoState,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.tx_infoState.name] = param1;
            if(!this._gridComponentsList[param2.lbl_infoType.name])
            {
               this.uiApi.addComponentHook(param2.lbl_infoType,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.lbl_infoType,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.lbl_infoType.name] = param1;
            if(!this._gridComponentsList[param2.tx_infoType.name])
            {
               this.uiApi.addComponentHook(param2.tx_infoType,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_infoType,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.tx_infoType.name] = param1;
            _loc4_ = this.dataApi.getServer(param1.id);
            if(!_loc4_)
            {
               param2.tx_flag.uri = null;
               param2.tx_infoType.uri = null;
               param2.lbl_infoType.text = "?";
               param2.tx_infoState.uri = null;
               param2.lbl_infoName.text = "?";
               param2.lbl_infoPopulation.text = "?";
            }
            else
            {
               param2.lbl_infoName.text = param1.name + " (" + param1.id + ")";
               if(_loc4_.gameTypeId == 1)
               {
                  param2.tx_infoType.uri = this.uiApi.createUri(this._assetsUri + "onboarding/icon_heroic.png");
               }
               else if(_loc4_.gameTypeId == 4)
               {
                  param2.tx_infoType.uri = this.uiApi.createUri(this._assetsUri + "onboarding/icon_epic.png");
               }
               else
               {
                  param2.tx_infoType.uri = null;
               }
               param2.lbl_infoType.text = _loc4_.gameType.name;
               param2.tx_infoState.uri = this.uiApi.createUri(this.uiApi.me().getConstant("statusIcon_" + param1.status));
               if(param1.completion >= 0)
               {
                  _loc5_ = "p";
                  switch(param1.completion)
                  {
                     case 0:
                        _loc5_ = "truegreen";
                        break;
                     case 1:
                        _loc5_ = "yellow";
                        break;
                     case 2:
                     case 4:
                        _loc5_ = "orange";
                        break;
                     case 3:
                        _loc5_ = "red";
                  }
                  param2.lbl_infoPopulation.cssClass = _loc5_;
                  param2.lbl_infoPopulation.text = _loc4_.population.name;
               }
               else
               {
                  param2.lbl_infoPopulation.cssClass = "p";
                  param2.lbl_infoPopulation.text = "?";
               }
               param2.tx_flag.uri = this.uiApi.createUri(this._flagUri + "flag_" + param1.community.toString() + ".png");
               param2.btn_server.selected = param3;
            }
            if(param2.btn_server.disabled)
            {
               param2.btn_server.disabled = false;
            }
         }
         else
         {
            param2.tx_flag.uri = null;
            param2.tx_infoType.uri = null;
            param2.lbl_infoType.text = "";
            param2.tx_infoState.uri = null;
            param2.lbl_infoName.text = "";
            param2.lbl_infoPopulation.text = "";
            param2.btn_server.selected = false;
            param2.btn_server.disabled = true;
         }
      }
      
      private function validateServerChoice() : void
      {
         var _loc1_:Object = null;
         if(this._aServers && this.gd_listServer.selectedItem && this.gd_listServer.selectedItem.charactersCount < this.gd_listServer.selectedItem.charactersSlots)
         {
            this.soundApi.playSound(SoundTypeEnum.OK_BUTTON);
            this.btn_validate.disabled = true;
            this.btn_autochoice.disabled = true;
            this.btn_cancel.disabled = true;
            this.gd_listServer.disabled = true;
            _loc1_ = this.gd_listServer.selectedItem;
            this.sysApi.sendAction(new d2actions.ServerSelection(_loc1_.id));
         }
      }
      
      private function displayServers() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         if(!this._bReload)
         {
            this._bReload = true;
            for(_loc1_ in this._aServers)
            {
               if(this._aServers[_loc1_].status == 3)
               {
                  this._serverInfo = this._aServers[_loc1_];
                  break;
               }
            }
         }
         else
         {
            this.gd_listServer.autoSelectMode = 0;
         }
         switch(true)
         {
            case Boolean(this.btn_ckboxCommu.selected) && Boolean(this.btn_ckboxMy.selected):
               this._nNbServers = this._aMyServers.length;
               this.createDataprovider(this._aMyServers);
               break;
            case Boolean(!this.btn_ckboxCommu.selected) && Boolean(this.btn_ckboxMy.selected):
               _loc2_ = new Array();
               for(_loc3_ in this._aMyCommuServers)
               {
                  if(this._aMyCommuServers[_loc3_].charactersCount > 0)
                  {
                     _loc2_.push(this._aMyCommuServers[_loc3_]);
                  }
               }
               this._nNbServers = _loc2_.length;
               this.createDataprovider(_loc2_);
               break;
            case Boolean(this.btn_ckboxCommu.selected) && Boolean(!this.btn_ckboxMy.selected):
               this._nNbServers = this._aServers.length;
               this.createDataprovider(this._aServers);
               break;
            case Boolean(!this.btn_ckboxCommu.selected) && Boolean(!this.btn_ckboxMy.selected):
               this._nNbServers = this._aMyCommuServers.length;
               this.createDataprovider(this._aMyCommuServers);
         }
      }
      
      private function createDataprovider(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:Server = null;
         var _loc7_:Server = null;
         var _loc8_:* = undefined;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(this._aFriendServers && this._aFriendServers.length)
            {
               for each(_loc5_ in this._aFriendServers)
               {
                  if(_loc3_.id == _loc5_)
                  {
                     _loc6_ = this.dataApi.getServer(_loc3_.id);
                     _loc2_.push({
                        "id":_loc3_.id,
                        "name":_loc6_.name,
                        "completion":_loc6_.populationId,
                        "community":_loc6_.communityId,
                        "status":_loc3_.status,
                        "type":_loc6_.gameTypeId,
                        "server":_loc6_,
                        "charactersCount":_loc3_.charactersCount,
                        "charactersSlots":_loc3_.charactersSlots
                     });
                  }
               }
            }
            else
            {
               _loc7_ = this.dataApi.getServer(_loc3_.id);
               _loc2_.push({
                  "id":_loc3_.id,
                  "name":_loc7_.name,
                  "completion":_loc7_.populationId,
                  "community":_loc7_.communityId,
                  "status":_loc3_.status,
                  "type":_loc7_.gameTypeId,
                  "server":_loc7_,
                  "charactersCount":_loc3_.charactersCount,
                  "charactersSlots":_loc3_.charactersSlots
               });
            }
         }
         this.gd_listServer.dataProvider = _loc2_;
         _loc4_ = 0;
         if(this._serverInfo)
         {
            for(_loc8_ in _loc2_)
            {
               if(_loc2_[_loc8_].id == this._serverInfo.id)
               {
                  _loc4_ = _loc8_;
               }
            }
            this.gd_listServer.selectedIndex = _loc4_;
         }
      }
      
      private function autochoice() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:Array = new Array();
         this.btn_ckboxCommu.selected = false;
         this.btn_ckboxMy.selected = false;
         this.displayServers();
         this._modeAutochoice = true;
         var _loc2_:Object = this.connecApi.getAutoChosenServer(0);
         if(_loc2_)
         {
            for(_loc3_ in this._aMyCommuServers)
            {
               if(this._aMyCommuServers[_loc3_].id == _loc2_.id)
               {
                  this.gd_listServer.selectedIndex = _loc3_;
               }
            }
         }
         else
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.noServerAvailiable"),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function displaySelectedItem() : void
      {
         this.tx_serverPic.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus_uri") + "server_IlluBg_" + this._serverInfo.id + ".jpg");
         if(this._modeAutochoice)
         {
            if(!this.uiApi.getUi("serverPopup"))
            {
               this.uiApi.loadUi("serverPopup","serverPopup",[this._serverInfo]);
            }
            this._modeAutochoice = false;
         }
         if(this._serverInfo.charactersCount >= this._serverInfo.charactersSlots)
         {
            this.btn_validate.softDisabled = true;
         }
         else
         {
            this.btn_validate.softDisabled = false;
         }
      }
      
      private function startSearch() : void
      {
         var _loc1_:String = this.inp_search.text;
         if(_loc1_ == "")
         {
            this.stopSearch();
         }
         else if(_loc1_.length >= 2 && _loc1_.length <= 30 && !this.btn_friendSearch.disabled)
         {
            this.sysApi.sendAction(new AcquaintanceSearch(_loc1_));
            this.btn_friendSearch.disabled = true;
            this.inp_search.disabled = true;
            this._lockSearchTimer = new Timer(3000,1);
            this._lockSearchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
            this._lockSearchTimer.start();
         }
      }
      
      private function stopSearch() : void
      {
         this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
         this._aFriendServers = new Array();
         this.displayServers();
      }
      
      private function populationSortFunction(param1:Object, param2:Object) : Number
      {
         var _loc3_:Object = this.dataApi.getServer(param1.id);
         var _loc4_:Object = this.dataApi.getServer(param2.id);
         if(_loc3_.populationId < _loc4_.populationId)
         {
            return -1;
         }
         if(_loc3_.populationId == _loc4_.populationId)
         {
            return 0;
         }
         return 1;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_cancel:
               this.sysApi.dispatchHook(ServerSelectionStart,[2,true]);
               break;
            case this.btn_validate:
               this.validateServerChoice();
               break;
            case this.btn_autochoice:
               this.autochoice();
               break;
            case this.btn_friendSearch:
               this.startSearch();
               break;
            case this.btn_closeSearch:
               if(this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
               {
                  this.stopSearch();
               }
               break;
            case this.inp_search:
               if(this.inp_search.text == this.INPUT_SEARCH_DEFAULT_TEXT)
               {
                  this.inp_search.text = "";
               }
               break;
            case this.btn_tabCountry:
               this.gd_listServer.sortOn("community",Array.NUMERIC);
               break;
            case this.btn_tabName:
               this.gd_listServer.sortOn("name",Array.CASEINSENSITIVE);
               break;
            case this.btn_tabState:
               this.gd_listServer.sortOn("status",Array.NUMERIC | Array.DESCENDING);
               break;
            case this.btn_tabPopulation:
               this.gd_listServer.sortOn("completion",Array.NUMERIC);
               break;
            case this.btn_tabType:
               this.gd_listServer.sortOn("type",Array.NUMERIC);
               break;
            case this.btn_ckboxCommu:
               this.displayServers();
               break;
            case this.btn_ckboxMy:
               this.displayServers();
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(this.inp_search.haveFocus)
               {
                  this.startSearch();
               }
               else
               {
                  this.validateServerChoice();
               }
               break;
            case "closeUi":
               if(this.inp_search.haveFocus)
               {
                  this.stopSearch();
               }
         }
         return false;
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc2_:* = "";
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_ckboxCommu:
               _loc2_ = this.uiApi.getText("ui.sersel.showCommunity");
               break;
            case this.btn_ckboxMy:
               _loc2_ = this.uiApi.getText("ui.sersel.showMyServer");
               break;
            case this.inp_search:
               _loc2_ = this.uiApi.getText("ui.sersel.enterAccountName");
               break;
            case this.btn_validate:
               if(this.btn_validate.softDisabled)
               {
                  _loc2_ = this.uiApi.getText("ui.sersel.noSlotOnThisServer");
               }
         }
         if(param1.name.indexOf("tx_flag") == 0)
         {
            _loc5_ = this._gridComponentsList[param1.name];
            if(_loc5_)
            {
               if(_loc5_.server.community)
               {
                  _loc2_ = _loc5_.server.community.name;
               }
               else
               {
                  _loc2_ = _loc5_.community.toString();
               }
            }
         }
         else if(param1.name.indexOf("lbl_infoName") == 0)
         {
            _loc5_ = this._gridComponentsList[param1.name];
            if(_loc5_)
            {
               if(_loc5_.server.comment && _loc5_.server.comment.length > 0)
               {
                  _loc2_ = _loc5_.server.comment;
               }
               if(_loc5_.server.openingDate > 0)
               {
                  if(_loc2_ != "")
                  {
                     _loc2_ = _loc2_ + "\n";
                  }
                  _loc2_ = _loc2_ + (this.uiApi.getText("ui.sersel.date") + this.uiApi.getText("ui.common.colon") + this.timeApi.getDate(_loc5_.server.openingDate,true,true));
               }
            }
         }
         else if(param1.name.indexOf("infoType") != -1)
         {
            _loc5_ = this._gridComponentsList[param1.name];
            if(_loc5_)
            {
               _loc2_ = this.uiApi.getText("ui.server.rules." + _loc5_.type);
            }
         }
         else if(param1.name.indexOf("tx_infoState") == 0)
         {
            _loc5_ = this._gridComponentsList[param1.name];
            if(_loc5_)
            {
               _loc2_ = this.uiApi.me().getConstant("status_" + _loc5_.status);
            }
         }
         if(_loc2_ != "")
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         this._serverInfo = param1.selectedItem;
         if(this._serverInfo)
         {
            this._currentServer = this.dataApi.getServer(this._serverInfo.id);
            this.displaySelectedItem();
            if(param2 == this.sysApi.getEnum("com.ankamagames.berilia.enums.SelectMethodEnum").DOUBLE_CLICK)
            {
               this.validateServerChoice();
            }
         }
      }
      
      private function onServersList(param1:Object) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc2_:* = this._aMyServers == null;
         this._aServers = new Array();
         this._aMyCommuServers = new Array();
         this._aMyServers = new Array();
         var _loc3_:int = this.sysApi.getPlayerManager().communityId;
         for(_loc4_ in param1)
         {
            _loc5_ = this.dataApi.getServer(param1[_loc4_].id);
            if(_loc5_)
            {
               if(_loc5_.communityId == _loc3_ || _loc5_.communityId == 2 || _loc3_ == 2 && _loc5_.communityId == 1)
               {
                  this._aMyCommuServers.push(param1[_loc4_]);
               }
               if(param1[_loc4_].charactersCount > 0)
               {
                  this._aMyServers.push(param1[_loc4_]);
               }
               this._aServers.push(param1[_loc4_]);
            }
            else
            {
               this.sysApi.log(16,"Server " + param1[_loc4_].id + " cannot be found in data files.");
            }
         }
         if(this._aMyCommuServers.length == 0)
         {
            for each(_loc6_ in this._aServers)
            {
               _loc7_ = this.dataApi.getServer(_loc6_.id);
               if(_loc7_ && _loc7_.communityId == 2)
               {
                  this._aMyCommuServers.push(_loc6_);
               }
            }
         }
         this._aServers.sort(this.populationSortFunction);
         this._aMyCommuServers.sort(this.populationSortFunction);
         this._aMyServers.sort(this.populationSortFunction);
         if(_loc2_ && !this._aMyServers.length)
         {
            this.btn_ckboxMy.selected = false;
         }
         this.displayServers();
         this._serverInfo = this.gd_listServer.selectedItem;
         if(this._serverInfo)
         {
            this._currentServer = this.dataApi.getServer(this._serverInfo.id);
            this.displaySelectedItem();
         }
      }
      
      public function onAcquaintanceSearchError(param1:String) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case "no_result":
               _loc2_ = this.uiApi.getText("ui.sersel.searchError." + param1,this.inp_search.text);
               break;
            default:
               _loc2_ = this.uiApi.getText("ui.sersel.searchError." + param1);
         }
         this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),_loc2_,[this.uiApi.getText("ui.common.ok")]);
         this.onTimeOut(null);
      }
      
      public function onAcquaintanceServerList(param1:Object) : void
      {
         var _loc2_:* = undefined;
         this._aFriendServers = new Array();
         for each(_loc2_ in param1)
         {
            this._aFriendServers.push(_loc2_);
         }
         this.displayServers();
         this.onTimeOut(null);
      }
      
      public function onSelectedServerRefused(param1:int, param2:String, param3:Object) : void
      {
         this.btn_validate.disabled = false;
         this.btn_autochoice.disabled = false;
         this.btn_cancel.disabled = false;
         this.gd_listServer.disabled = false;
      }
      
      public function onServerConnectionStarted() : void
      {
         this._clockStart = getTimer();
         this.sysApi.addEventListener(this.onEnterFrame,"time");
      }
      
      public function onTimeOut(param1:TimerEvent) : void
      {
         this.btn_friendSearch.disabled = false;
         this.inp_search.disabled = false;
         this._lockSearchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this._lockSearchTimer.stop();
         this._lockSearchTimer = null;
      }
      
      public function onEnterFrame() : void
      {
         var _loc1_:Number = getTimer();
         var _loc2_:Number = _loc1_ - this._clockStart;
         if(_loc2_ >= 3000 && _loc2_ < 10000)
         {
            if(this._popupInUse != 1)
            {
               this._popupInUse = 1;
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.popup.information"),this.uiApi.getText("ui.popup.currentlyConnecting"),[this.uiApi.getText("ui.common.ok")]);
            }
         }
         else if(_loc2_ >= 10000)
         {
            if(this._popupInUse == 1 && this.uiApi.getUi(this._popupName))
            {
               this.uiApi.unloadUi(this._popupName);
            }
            if(this._popupInUse != 2)
            {
               this._popupInUse = 2;
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.popup.accessDenied.timeout"),[this.uiApi.getText("ui.common.wait"),this.uiApi.getText("ui.common.interrupt")],[this.onPopupWait,this.onPopupInterrupt],this.onPopupWait,this.onPopupInterrupt);
            }
         }
      }
      
      public function onPopupWait() : void
      {
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function onPopupInterrupt() : void
      {
         this.sysApi.sendAction(new ResetGame());
      }
      
      public function onIlluLoadFailed(param1:Object, param2:Object) : void
      {
         if(param1 == this.tx_serverPic)
         {
            param2.cancel = true;
            this.tx_serverPic.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus_uri") + "server_IlluBg_99.jpg");
         }
      }
   }
}
