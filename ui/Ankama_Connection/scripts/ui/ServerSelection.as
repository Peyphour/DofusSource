package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.ServerStatusEnum;
   import d2enums.StatesEnum;
   import d2hooks.SelectedServerFailed;
   import d2hooks.SelectedServerRefused;
   import d2hooks.ServerSelectionStart;
   import d2hooks.ServersList;
   import d2hooks.TextureLoadFailed;
   import flash.utils.Dictionary;
   
   public class ServerSelection
   {
      
      private static const NB_SERVER_SLOTS:uint = 5;
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      public var connecApi:ConnectionApi;
      
      private var _aServers:Array;
      
      private var _currentIndex:uint = 0;
      
      private var _srvButtonList:Dictionary;
      
      private var _cbServers:Array;
      
      private var _waitingForServer:int = -1;
      
      private var _xCtrChars:int;
      
      private var _yCtrChars:int;
      
      private var _assetsUri:String;
      
      private var _charSlotEmptyUri:Object;
      
      private var _charSlotFullUri:Object;
      
      public var gd_listServer:Grid;
      
      public var cb_servers:ComboBox;
      
      public var bgcb_servers:TextureBitmap;
      
      public var btn_validate:ButtonContainer;
      
      public var btn_create:ButtonContainer;
      
      public var btn_arrowLeft:ButtonContainer;
      
      public var btn_arrowRight:ButtonContainer;
      
      public function ServerSelection()
      {
         this._srvButtonList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.btn_create.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_validate.soundId = "-1";
         this.sysApi.addHook(ServersList,this.onServersList);
         this.sysApi.addHook(SelectedServerRefused,this.onSelectedServerRefused);
         this.sysApi.addHook(SelectedServerFailed,this.onSelectedServerFailed);
         this.sysApi.addHook(TextureLoadFailed,this.onIlluLoadFailed);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addComponentHook(this.gd_listServer,"onSelectItem");
         this._xCtrChars = this.uiApi.me().getConstant("ctr_chars_x");
         this._yCtrChars = this.uiApi.me().getConstant("ctr_chars_y");
         this._assetsUri = this.uiApi.me().getConstant("texture");
         this._charSlotEmptyUri = this.uiApi.createUri(this.uiApi.me().getConstant("characterSlotEmpty_uri"));
         this._charSlotFullUri = this.uiApi.createUri(this.uiApi.me().getConstant("characterSlotFull_uri"));
         if(this.sysApi.hasRight())
         {
            this.cb_servers.visible = true;
            this.bgcb_servers.visible = true;
         }
         this.onServersList();
         this.gd_listServer.focus();
      }
      
      private function validateServerChoice() : void
      {
         var _loc1_:int = 0;
         if(this._aServers && this.gd_listServer.selectedItem)
         {
            this.soundApi.playSound(SoundTypeEnum.OK_BUTTON);
            this.btn_validate.disabled = true;
            this.btn_create.disabled = true;
            if(this._waitingForServer != -1)
            {
               _loc1_ = this._waitingForServer;
            }
            else
            {
               _loc1_ = this.gd_listServer.selectedItem.id;
            }
            this.sysApi.sendAction(new d2actions.ServerSelection(_loc1_));
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_create:
               this.sysApi.dispatchHook(ServerSelectionStart,[2,true]);
               break;
            case this.btn_validate:
               this.serverSelected();
               break;
            case this.btn_arrowLeft:
               if(this._currentIndex > 0)
               {
                  this._currentIndex--;
                  if(this._currentIndex == 0)
                  {
                     this.btn_arrowLeft.disabled = true;
                  }
                  this.btn_arrowRight.disabled = false;
                  this.gd_listServer.dataProvider = this._aServers.slice(this._currentIndex,this._currentIndex + NB_SERVER_SLOTS);
               }
               break;
            case this.btn_arrowRight:
               if(this._currentIndex <= this._aServers.length - NB_SERVER_SLOTS)
               {
                  this._currentIndex++;
                  if(this._currentIndex == this._aServers.length - NB_SERVER_SLOTS)
                  {
                     this.btn_arrowRight.disabled = true;
                  }
                  this.btn_arrowLeft.disabled = false;
                  this.gd_listServer.dataProvider = this._aServers.slice(this._currentIndex,this._currentIndex + NB_SERVER_SLOTS);
               }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               this.serverSelected();
         }
         return false;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 != SelectMethodEnum.AUTO && param2 != SelectMethodEnum.WHEEL && param2 != SelectMethodEnum.SEARCH && param2 != SelectMethodEnum.FIRST_ITEM && param2 != SelectMethodEnum.LAST_ITEM && param2 != SelectMethodEnum.UP_ARROW && param2 != SelectMethodEnum.DOWN_ARROW && param2 != SelectMethodEnum.LEFT_ARROW && param2 != SelectMethodEnum.RIGHT_ARROW && param1 == this.cb_servers && this.cb_servers.value.id != 0)
         {
            this.soundApi.playSound(SoundTypeEnum.OK_BUTTON);
            this.btn_validate.disabled = true;
            this.btn_create.disabled = true;
            this.sysApi.sendAction(new d2actions.ServerSelection(this.cb_servers.value.id));
         }
         else if(param1 != this.cb_servers && param1.selectedItem)
         {
            if(param2 == this.sysApi.getEnum("com.ankamagames.berilia.enums.SelectMethodEnum").DOUBLE_CLICK)
            {
               this.serverSelected();
            }
         }
      }
      
      private function serverSelected() : void
      {
         if(this.gd_listServer.selectedItem)
         {
            switch(this.gd_listServer.selectedItem.status)
            {
               case ServerStatusEnum.STARTING:
               case ServerStatusEnum.OFFLINE:
               case ServerStatusEnum.SAVING:
               case ServerStatusEnum.NOJOIN:
               case ServerStatusEnum.STOPING:
               case ServerStatusEnum.FULL:
                  this.btn_validate.disabled = false;
                  this.btn_create.disabled = true;
                  this._waitingForServer = this.gd_listServer.selectedItem.id;
                  this.gd_listServer.updateItems();
                  break;
               default:
                  this._waitingForServer = -1;
                  this.validateServerChoice();
            }
         }
      }
      
      public function updateServerLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1)
         {
            _loc4_ = this.dataApi.getServer(param1.id);
            if(!_loc4_)
            {
               param2.tx_illu.uri = null;
               param2.tx_status.uri = null;
               param2.tx_type.uri = null;
               param2.gd_nbCharacters.dataProvider = new Array();
               param2.lbl_name.text = "";
               param2.lbl_nbCharacters.text = "";
               param2.lbl_status.text = "";
               param2.tx_waitingIllu.visible = false;
               param2.ctr_server.visible = false;
            }
            else
            {
               this._srvButtonList[param2.btn_server.name] = param1;
               this.uiApi.addComponentHook(param2.btn_server,"onRollOver");
               this.uiApi.addComponentHook(param2.btn_server,"onRollOut");
               param2.tx_illu.dispatchMessages = true;
               param2.tx_illu.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus_uri") + "server_IlluNormal_" + param1.id + ".png");
               param2.tx_illu.finalized = true;
               if(this._waitingForServer == param1.id)
               {
                  param2.tx_waitingIllu.visible = true;
               }
               else
               {
                  param2.tx_waitingIllu.visible = false;
               }
               param2.lbl_name.text = _loc4_.name;
               param2.tx_status.uri = this.uiApi.createUri(this.uiApi.me().getConstant("statusIcon_" + param1.status));
               param2.lbl_status.text = this.uiApi.me().getConstant("status_" + param1.status);
               if(param1.charactersSlots > 5)
               {
                  param2.ctr_nbCharacters.visible = false;
                  param2.lbl_nbCharacters.text = param1.charactersCount + "/" + param1.charactersSlots;
               }
               else
               {
                  _loc5_ = 0;
                  _loc6_ = 0;
                  param2.ctr_nbCharacters.visible = true;
                  param2.tx_nbChar0.visible = false;
                  param2.tx_nbChar1.visible = false;
                  param2.tx_nbChar2.visible = false;
                  param2.tx_nbChar3.visible = false;
                  param2.tx_nbChar4.visible = false;
                  _loc6_ = 0;
                  while(_loc6_ < param1.charactersCount)
                  {
                     _loc5_++;
                     param2["tx_nbChar" + _loc6_].visible = true;
                     param2["tx_nbChar" + _loc6_].uri = this._charSlotFullUri;
                     param2["tx_nbChar" + _loc6_].alpha = 1;
                     param2["tx_nbChar" + _loc6_].finalize();
                     _loc6_++;
                  }
                  while(_loc6_ < param1.charactersSlots)
                  {
                     _loc5_++;
                     param2["tx_nbChar" + _loc6_].visible = true;
                     param2["tx_nbChar" + _loc6_].uri = this._charSlotEmptyUri;
                     param2["tx_nbChar" + _loc6_].alpha = 0.5;
                     param2["tx_nbChar" + _loc6_].finalize();
                     _loc6_++;
                  }
                  _loc7_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     param2["tx_nbChar" + _loc6_].x = _loc6_ * param2.tx_nbChar0.width;
                     _loc7_ = _loc7_ + param2.tx_nbChar0.width;
                     _loc6_++;
                  }
                  param2.ctr_nbCharacters.x = (param2.ctr_nbCharacters.width - _loc7_) / 2 + this._xCtrChars;
                  param2.ctr_nbCharacters.y = this._yCtrChars;
                  param2.lbl_nbCharacters.text = "";
               }
               if(_loc4_.gameTypeId == 1)
               {
                  param2.tx_type.uri = this.uiApi.createUri(this._assetsUri + "onboarding/icon_heroic.png");
               }
               else if(_loc4_.gameTypeId == 4)
               {
                  param2.tx_type.uri = this.uiApi.createUri(this._assetsUri + "onboarding/icon_epic.png");
               }
               else
               {
                  param2.tx_type.uri = null;
               }
               param2.btn_server.selected = param3;
               param2.btn_server.state = !!param3?StatesEnum.STATE_SELECTED:StatesEnum.STATE_NORMAL;
            }
         }
         else
         {
            param2.ctr_server.visible = false;
         }
      }
      
      public function onIlluLoadFailed(param1:Object, param2:Object) : void
      {
         param2.cancel = true;
         if(param1.name.indexOf("tx_illu") != -1)
         {
            param1.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus_uri") + "server_IlluNormal_99.png");
         }
      }
      
      private function onServersList(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Server = null;
         var _loc4_:Object = null;
         this._aServers = new Array();
         this._cbServers = new Array();
         this._cbServers.push({
            "label":this.uiApi.getText("ui.sersel.title"),
            "id":0,
            "order":"a"
         });
         for each(_loc2_ in this.connecApi.getUsedServers())
         {
            if(this._waitingForServer != -1 && _loc2_.id == this._waitingForServer && _loc2_.status == ServerStatusEnum.ONLINE)
            {
               this.validateServerChoice();
            }
            _loc3_ = this.dataApi.getServer(_loc2_.id);
            if(_loc3_)
            {
               this._aServers.push(_loc2_);
               _loc4_ = {
                  "label":_loc3_.name,
                  "id":_loc2_.id,
                  "order":_loc3_.name
               };
               this._cbServers.push(_loc4_);
            }
            else
            {
               this.sysApi.log(16,"Server " + _loc2_.id + " not found in data files.");
            }
         }
         this._aServers.sortOn("date",Array.DESCENDING | Array.NUMERIC);
         this._cbServers.sortOn("order",Array.CASEINSENSITIVE);
         this.cb_servers.dataProvider = this._cbServers;
         this.cb_servers.selectedIndex = 0;
         if(this._aServers.length <= NB_SERVER_SLOTS)
         {
            this.btn_arrowLeft.disabled = true;
            this.btn_arrowRight.disabled = true;
            this._currentIndex = 0;
            this.gd_listServer.dataProvider = this._aServers;
         }
         else
         {
            if(this._currentIndex + NB_SERVER_SLOTS > this._aServers.length)
            {
               this._currentIndex = this._aServers.length - NB_SERVER_SLOTS;
            }
            if(this._currentIndex == 0)
            {
               this.btn_arrowLeft.disabled = true;
               this.btn_arrowRight.disabled = false;
            }
            if(this._currentIndex == this._aServers.length - NB_SERVER_SLOTS)
            {
               this.btn_arrowLeft.disabled = false;
               this.btn_arrowRight.disabled = true;
            }
            this.gd_listServer.dataProvider = this._aServers.slice(this._currentIndex,this._currentIndex + NB_SERVER_SLOTS);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(this._srvButtonList[param1.name].id == this._waitingForServer)
         {
            _loc2_ = this.uiApi.getText("ui.sersel.waitForServerTooltip");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectedServerRefused(param1:int, param2:String, param3:Object) : void
      {
         this.btn_validate.disabled = false;
         this.btn_create.disabled = false;
         this.cb_servers.value = this._cbServers[0];
      }
      
      public function onSelectedServerFailed() : void
      {
         this.btn_validate.disabled = false;
         this.btn_create.disabled = false;
         this.cb_servers.value = this._cbServers[0];
      }
   }
}
