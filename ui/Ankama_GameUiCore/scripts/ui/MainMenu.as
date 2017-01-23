package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.internalDatacenter.connection.BasicCharacterWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SecurityApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ChangeCharacter;
   import d2actions.ChangeServer;
   import d2actions.DirectSelectionCharacter;
   import d2actions.QuitGame;
   import d2actions.ResetGame;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.ServerStatusEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightJoin;
   import d2hooks.OpenWebService;
   import d2hooks.ServerStatusUpdate;
   
   public class MainMenu
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var fightApi:FightApi;
      
      public var timeApi:TimeApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      public var securityApi:SecurityApi;
      
      private var _charsNames:Array;
      
      private var _characters:Array;
      
      private var _serversNames:Array;
      
      private var _servers:Array;
      
      private var _charPopupName:String;
      
      private var _serverPopupName:String;
      
      private var _isSafe:Boolean = false;
      
      public var btnClose:ButtonContainer;
      
      public var btnOptions:ButtonContainer;
      
      public var btnChangeCharacter:ButtonContainer;
      
      public var btnChangeServer:ButtonContainer;
      
      public var btnDisconnect:ButtonContainer;
      
      public var btnQuitGame:ButtonContainer;
      
      public var btnCancel:ButtonContainer;
      
      public var cb_characters:ComboBox;
      
      public var cb_servers:ComboBox;
      
      public var bgcb_characters:TextureBitmap;
      
      public var bgcb_servers:TextureBitmap;
      
      public var tx_safe:Texture;
      
      public var btn_subscribe:ButtonContainer;
      
      public var lbl_abo:Label;
      
      public var tx_hourglass:Texture;
      
      public function MainMenu()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:BasicCharacterWrapper = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(this.sysApi.isStreaming())
         {
            this.btnQuitGame.visible = false;
            this.btnChangeCharacter.y = this.btnChangeCharacter.y + 8;
            this.cb_characters.y = this.cb_characters.y - 4;
            this.bgcb_characters.y = this.bgcb_characters.y + 8;
            this.cb_servers.y = this.cb_servers.y - 38;
            this.bgcb_servers.y = this.bgcb_servers.y + 16;
            this.btnChangeServer.y = this.btnChangeServer.y + 16;
            this.btnDisconnect.y = this.btnDisconnect.y + 24;
         }
         this.soundApi.playSound(SoundTypeEnum.OPTIONS_OPEN);
         this.btnOptions.soundId = SoundEnum.SPEC_BUTTON;
         this.btnChangeCharacter.soundId = SoundEnum.SPEC_BUTTON;
         this.btnChangeServer.soundId = SoundEnum.SPEC_BUTTON;
         this.btnDisconnect.soundId = SoundEnum.SPEC_BUTTON;
         this.btnCancel.soundId = SoundEnum.CANCEL_BUTTON;
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(ServerStatusUpdate,this.onServerStatusUpdate);
         this.uiApi.addComponentHook(this.lbl_abo,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_abo,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.cb_characters,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_servers,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.tx_hourglass,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_hourglass,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_safe,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_safe,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_safe,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut);
         this.updateCharacterChangeAvailability();
         this.btnChangeServer.disabled = this.sysApi.isFightContext() && !this.fightApi.isSpectator();
         this.cb_servers.disabled = this.sysApi.isFightContext() && !this.fightApi.isSpectator();
         if(this.sysApi.getPlayerManager().isSafe)
         {
            this._isSafe = true;
            this.tx_safe.gotoAndStop = 2;
         }
         else if(this.securityApi.SecureModeisActive())
         {
            this.tx_safe.gotoAndStop = 3;
         }
         else
         {
            this.tx_safe.gotoAndStop = 1;
            this.tx_safe.handCursor = true;
         }
         if(this.sysApi.getPlayerManager().subscriptionEndDate == 0)
         {
            if(this.sysApi.getPlayerManager().hasRights)
            {
               this.lbl_abo.text = this.uiApi.getText("ui.common.admin");
            }
            else
            {
               this.lbl_abo.text = this.uiApi.getText("ui.common.non_subscriber");
            }
         }
         else if(this.sysApi.getPlayerManager().subscriptionEndDate < 2051222400000)
         {
            this.lbl_abo.text = this.uiApi.getText("ui.connection.subscriberUntil",this.timeApi.getDate(this.sysApi.getPlayerManager().subscriptionEndDate,true,true) + " " + this.timeApi.getClock(this.sysApi.getPlayerManager().subscriptionEndDate,true,true));
         }
         else
         {
            this.lbl_abo.text = this.uiApi.getText("ui.common.infiniteSubscription");
         }
         this.cb_characters.useKeyboard = false;
         this.cb_servers.useKeyboard = false;
         if(this.sysApi.getPlayerManager().charactersList && this.sysApi.getPlayerManager().charactersList.length > 1)
         {
            this._charsNames = new Array();
            this._characters = new Array();
            for each(_loc2_ in this.sysApi.getPlayerManager().charactersList)
            {
               if(_loc2_.id != this.playerApi.id() || this.sysApi.getPlayerManager().hasRights)
               {
                  _loc3_ = _loc2_.name + " (" + _loc2_.breed.shortName + " ";
                  if(_loc2_.level > ProtocolConstantsEnum.MAX_LEVEL)
                  {
                     _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.prestige") + (_loc2_.level - ProtocolConstantsEnum.MAX_LEVEL) + ")");
                  }
                  else
                  {
                     _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.level") + _loc2_.level + ")");
                  }
                  this._charsNames.push(_loc3_);
                  this._characters.push(_loc2_);
               }
            }
            this.cb_characters.dataProvider = this._charsNames;
         }
         else
         {
            this.cb_characters.disabled = true;
         }
         if(this.sysApi.getPlayerManager().serversList && this.sysApi.getPlayerManager().serversList.length > 1)
         {
            this._serversNames = new Array();
            this._servers = new Array();
            for each(_loc4_ in this.sysApi.getPlayerManager().serversList)
            {
               if(_loc4_ != this.sysApi.getCurrentServer().id)
               {
                  this._serversNames.push(this.dataApi.getServer(_loc4_).name);
                  this._servers.push(_loc4_);
               }
            }
            this.cb_servers.dataProvider = this._serversNames;
         }
         else
         {
            this.cb_servers.disabled = true;
         }
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.OPTIONS_CLOSE);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btnOptions:
               this.modCommon.openOptionMenu(false,"performance");
               break;
            case this.btnChangeCharacter:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.confirm"),this.uiApi.getText("ui.common.confirmChangeCharacter"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmChangeCharacter,this.onCancel],this.onConfirmChangeCharacter,this.onCancel);
               break;
            case this.btnChangeServer:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.confirm"),this.uiApi.getText("ui.connection.confirmChangeServer"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmChangeServer,this.onCancel],this.onConfirmChangeServer,this.onCancel);
               break;
            case this.btnDisconnect:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.confirm"),this.uiApi.getText("ui.common.confirmDisconnect"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmDisconnect,this.onCancel],this.onConfirmDisconnect,this.onCancel);
               break;
            case this.btnQuitGame:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.confirm"),this.uiApi.getText("ui.common.confirmQuitGame"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmQuitGame,this.onCancel],this.onConfirmQuitGame,this.onCancel);
               break;
            case this.btnCancel:
            case this.btnClose:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_subscribe:
               if(this.sysApi.isSteamEmbed())
               {
                  this.sysApi.dispatchHook(OpenWebService,"webShop",{"categoryId":544});
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.sysApi.goToUrl(this.uiApi.getText("ui.link.subscribe"));
               }
               break;
            case this.tx_safe:
               if(!this._isSafe)
               {
                  this.sysApi.goToUrl(this.uiApi.getText("ui.link.secure"));
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 == SelectMethodEnum.CLICK || param2 == SelectMethodEnum.MANUAL || param2 == SelectMethodEnum.DOUBLE_CLICK)
         {
            switch(param1)
            {
               case this.cb_characters:
                  if(!this._charPopupName)
                  {
                     this._charPopupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.confirm"),this.uiApi.getText("ui.connection.confirmDirectCharacter",this._charsNames[this.cb_characters.selectedIndex]),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmCharacterDirectSelection,this.onCancel],this.onConfirmCharacterDirectSelection,this.onCancel);
                  }
                  break;
               case this.cb_servers:
                  if(!this._serverPopupName)
                  {
                     this._serverPopupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.confirm"),this.uiApi.getText("ui.connection.confirmDirectServer",this._serversNames[this.cb_servers.selectedIndex]),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmServerDirectSelection,this.onCancel],this.onConfirmServerDirectSelection,this.onCancel);
                  }
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.lbl_abo:
               if(this.sysApi.getPlayerManager().subscriptionEndDate > 0)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.header.subscriptionEndDate")),param1,false,"standard",2,8,0,null,null,null,"TextInfo");
               }
               return;
            case this.tx_hourglass:
               _loc2_ = this.uiApi.getText("ui.common.serverstatus.saving");
               break;
            case this.tx_safe:
               if(this._isSafe)
               {
                  _loc2_ = this.uiApi.getText("ui.information.safeAccount");
               }
               else if(this.securityApi.SecureModeisActive())
               {
                  _loc2_ = this.uiApi.getText("ui.information.safeRestrictedAccount");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.information.noSafeAccount");
               }
         }
         if(_loc2_ && _loc2_ != "")
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",LocationEnum.POINT_RIGHT,LocationEnum.POINT_LEFT,0,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onConfirmCharacterDirectSelection() : void
      {
         this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
         this.sysApi.sendAction(new DirectSelectionCharacter(this.sysApi.getCurrentServer().id,this._characters[this.cb_characters.selectedIndex].id));
      }
      
      private function onConfirmServerDirectSelection() : void
      {
         this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
         this.sysApi.sendAction(new ChangeCharacter(this._servers[this.cb_servers.selectedIndex]));
      }
      
      private function onConfirmChangeCharacter() : void
      {
         this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
         this.sysApi.sendAction(new ChangeCharacter(this.sysApi.getCurrentServer().id));
      }
      
      private function onConfirmChangeServer() : void
      {
         this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
         this.sysApi.sendAction(new ChangeServer());
      }
      
      private function onConfirmDisconnect() : void
      {
         this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
         this.sysApi.sendAction(new ResetGame());
      }
      
      private function onConfirmQuitGame() : void
      {
         this.sysApi.sendAction(new QuitGame());
      }
      
      private function updateCharacterChangeAvailability() : void
      {
         var _loc1_:Boolean = this.sysApi.isFightContext() && !this.fightApi.isSpectator();
         var _loc2_:* = this.sysApi.getServerStatus() == ServerStatusEnum.SAVING;
         this.cb_characters.disabled = this.btnChangeCharacter.disabled = _loc1_ || _loc2_;
         this.tx_hourglass.visible = !!_loc1_?false:Boolean(_loc2_);
      }
      
      private function onCancel() : void
      {
         this._charPopupName = null;
         this._serverPopupName = null;
      }
      
      public function onGameFightJoin(... rest) : void
      {
         this.btnChangeCharacter.disabled = true;
         this.btnChangeServer.disabled = true;
         this.cb_characters.disabled = true;
         this.cb_servers.disabled = true;
      }
      
      public function onGameFightEnd(... rest) : void
      {
         this.btnChangeCharacter.disabled = false;
         this.btnChangeServer.disabled = false;
         this.cb_characters.disabled = false;
         this.cb_servers.disabled = false;
      }
      
      public function onServerStatusUpdate(param1:uint) : void
      {
         this.updateCharacterChangeAvailability();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         if(param1 == ShortcutHookListEnum.VALID_UI)
         {
         }
         return false;
      }
   }
}
