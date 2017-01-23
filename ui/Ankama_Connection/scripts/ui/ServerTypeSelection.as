package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.GameServerTypeEnum;
   import d2enums.SoundTypeEnum;
   import d2hooks.SelectedServerRefused;
   import d2hooks.ServerSelectionStart;
   import d2hooks.UiUnloaded;
   
   public class ServerTypeSelection
   {
       
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      public var connecApi:ConnectionApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _isSuscribed:Boolean = true;
      
      private var _availableSlotsByServerType:Object;
      
      private var _selectedServerType:uint = 0;
      
      public var btn_mychoice:ButtonContainer;
      
      public var btn_cancel:ButtonContainer;
      
      public var btn_validate:ButtonContainer;
      
      public var ctr_cancel:GraphicContainer;
      
      public var btn_infoEpic:ButtonContainer;
      
      public var btn_infosClassic:ButtonContainer;
      
      public var btn_infosHeroic:ButtonContainer;
      
      public var btn_epicMode:ButtonContainer;
      
      public var btn_classicMode:ButtonContainer;
      
      public var btn_heroicMode:ButtonContainer;
      
      public function ServerTypeSelection()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:* = undefined;
         this.uiApi.addComponentHook(this.btn_infoEpic,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_infosClassic,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_infosHeroic,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_infoEpic,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_infosClassic,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_infosHeroic,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_epicMode,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_epicMode,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_epicMode,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_classicMode,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_classicMode,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_classicMode,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_heroicMode,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_heroicMode,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_heroicMode,ComponentHookList.ON_ROLL_OUT);
         this.btn_epicMode.handCursor = true;
         this.btn_classicMode.handCursor = true;
         this.btn_heroicMode.handCursor = true;
         this.uiApi.setRadioGroupSelectedItem("modeGroup",this.btn_classicMode,this.uiApi.me());
         this.btn_classicMode.selected = true;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.btn_validate.soundId = "-1";
         this.btn_cancel.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_mychoice.soundId = SoundEnum.CANCEL_BUTTON;
         this.sysApi.addHook(SelectedServerRefused,this.onSelectedServerRefused);
         this.sysApi.addHook(UiUnloaded,this.onUiUnloaded);
         if(this.sysApi.getPlayerManager().subscriptionEndDate <= 0 && !this.sysApi.getPlayerManager().hasRights)
         {
            this._isSuscribed = false;
            this.btn_heroicMode.softDisabled = true;
         }
         if(this.sysApi.getPlayerManager().serversList.length <= 0)
         {
            this.ctr_cancel.visible = false;
         }
         if(this.sysApi.isInForcedGuestMode())
         {
            _loc2_ = this.connecApi.getAutoChosenServer(GameServerTypeEnum.SERVER_TYPE_CLASSICAL);
            if(_loc2_)
            {
               this.sysApi.sendAction(new d2actions.ServerSelection(_loc2_.id));
               this.btn_mychoice.disabled = true;
            }
         }
         this._availableSlotsByServerType = this.connecApi.getAvailableSlotsByServerType();
         if(this._availableSlotsByServerType[GameServerTypeEnum.SERVER_TYPE_CLASSICAL] == 0)
         {
            this.btn_classicMode.softDisabled = true;
         }
         if(this._availableSlotsByServerType[GameServerTypeEnum.SERVER_TYPE_HARDCORE] == 0)
         {
            this.btn_heroicMode.softDisabled = true;
         }
         if(this._availableSlotsByServerType[GameServerTypeEnum.SERVER_TYPE_EPIC] == 0)
         {
            this.btn_epicMode.softDisabled = true;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_mychoice:
               this.sysApi.dispatchHook(ServerSelectionStart,[1,Connection.waitingForCreation]);
               break;
            case this.btn_cancel:
               this.sysApi.dispatchHook(ServerSelectionStart,[0,false]);
               break;
            case this.btn_classicMode:
               this._selectedServerType = GameServerTypeEnum.SERVER_TYPE_CLASSICAL;
               break;
            case this.btn_heroicMode:
               this._selectedServerType = GameServerTypeEnum.SERVER_TYPE_HARDCORE;
               break;
            case this.btn_epicMode:
               this._selectedServerType = GameServerTypeEnum.SERVER_TYPE_EPIC;
               break;
            case this.btn_validate:
               _loc2_ = this.connecApi.getAutoChosenServer(this._selectedServerType);
               if(_loc2_)
               {
                  if(this.sysApi.getBuildType() >= BuildTypeEnum.INTERNAL && !this.uiApi.getUi("serverPopup"))
                  {
                     this.uiApi.loadUi("serverPopup","serverPopup",[_loc2_]);
                  }
                  else
                  {
                     this.sysApi.sendAction(new d2actions.ServerSelection(_loc2_.id));
                  }
                  this.btn_validate.disabled = true;
                  this.btn_mychoice.disabled = true;
                  this.btn_cancel.disabled = true;
               }
               else
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.noServerAvailiable"),[this.uiApi.getText("ui.common.ok")]);
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_classicMode:
               if(this.btn_classicMode.softDisabled)
               {
                  _loc2_ = this.uiApi.getText("ui.sersel.noSlotOnThisServerType");
               }
               break;
            case this.btn_heroicMode:
               if(this.btn_heroicMode.softDisabled)
               {
                  if(this._availableSlotsByServerType[GameServerTypeEnum.SERVER_TYPE_HARDCORE] == 0)
                  {
                     _loc2_ = this.uiApi.getText("ui.sersel.noSlotOnThisServerType");
                  }
                  else
                  {
                     _loc2_ = this.uiApi.getText("ui.sersel.sucriberOnly");
                  }
               }
               break;
            case this.btn_epicMode:
               if(this.btn_epicMode.softDisabled)
               {
                  _loc2_ = this.uiApi.getText("ui.sersel.noSlotOnThisServerType");
               }
               break;
            case this.btn_infosClassic:
               _loc2_ = this.uiApi.getText("ui.server.rules.0");
               break;
            case this.btn_infosHeroic:
               _loc2_ = this.uiApi.getText("ui.server.rules.1");
               break;
            case this.btn_infoEpic:
               _loc2_ = this.uiApi.getText("ui.server.rules.4");
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
      
      public function onSelectedServerRefused(param1:int, param2:String, param3:Object) : void
      {
         this.btn_mychoice.disabled = false;
         this.enableButtons();
      }
      
      private function onUiUnloaded(param1:String) : void
      {
         if(param1 == "serverPopup")
         {
            this.btn_mychoice.disabled = false;
            this.enableButtons();
         }
      }
      
      private function enableButtons() : void
      {
         if(this._isSuscribed)
         {
            this.btn_heroicMode.softDisabled = false;
         }
         this.btn_epicMode.softDisabled = false;
         this.btn_classicMode.softDisabled = false;
         this.btn_cancel.disabled = false;
         this.btn_validate.disabled = false;
      }
   }
}
