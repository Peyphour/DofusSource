package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.AddIgnored;
   import d2actions.ExchangeAccept;
   import d2actions.ExchangeRefuse;
   import d2hooks.CloseInventory;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeRequestCharacterFromMe;
   import d2hooks.ExchangeRequestCharacterToMe;
   import d2hooks.ExchangeStartOkNpcTrade;
   import d2hooks.ExchangeStarted;
   import d2hooks.OpenInventory;
   import d2hooks.UiUnloaded;
   import flash.display.Sprite;
   import ui.ExchangeNPCUi;
   import ui.ExchangeUi;
   
   public class Exchange extends Sprite
   {
       
      
      protected var exchangeUi:ExchangeUi = null;
      
      protected var exchangeNPCUi:ExchangeNPCUi = null;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var socialApi:SocialApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var playerApi:PlayedCharacterApi;
      
      public var storageApi:StorageApi;
      
      private var _playerName:String;
      
      private var _ignoreName:String;
      
      private var _popupName:String;
      
      private var _waitStorageUnloadData:Object;
      
      public function Exchange()
      {
         super();
      }
      
      public function main() : void
      {
         this.sysApi.addHook(ExchangeRequestCharacterFromMe,this.onExchangeRequestCharacterFromMe);
         this.sysApi.addHook(ExchangeRequestCharacterToMe,this.onExchangeRequestCharacterToMe);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.sysApi.addHook(ExchangeStarted,this.onExchangeStarted);
         this.sysApi.addHook(CloseInventory,this.onCloseInventory);
         this.sysApi.addHook(ExchangeStartOkNpcTrade,this.onExchangeStartOkNpcTrade);
      }
      
      private function onCloseInventory() : void
      {
         if(this.uiApi.getUi(UIEnum.EXCHANGE_UI))
         {
            this.uiApi.unloadUi(UIEnum.EXCHANGE_UI);
         }
      }
      
      private function onExchangeStarted(param1:String, param2:String, param3:Object, param4:Object, param5:int, param6:int, param7:int, param8:int, param9:Number) : void
      {
         if(this.uiApi.getUi(UIEnum.STORAGE_UI))
         {
            this._waitStorageUnloadData = new Object();
            this._waitStorageUnloadData.pSourceName = param1;
            this._waitStorageUnloadData.pTargetName = param2;
            this._waitStorageUnloadData.pSourceLook = param3;
            this._waitStorageUnloadData.pTargetLook = param4;
            this._waitStorageUnloadData.pSourceCurrentPods = param5;
            this._waitStorageUnloadData.pTargetCurrentPods = param6;
            this._waitStorageUnloadData.pSourceMaxPods = param7;
            this._waitStorageUnloadData.pTargetMaxPods = param8;
            this._waitStorageUnloadData.otherId = param9;
            this.sysApi.addHook(UiUnloaded,this.onUiUnloaded);
            this.uiApi.unloadUi(UIEnum.STORAGE_UI);
         }
         else
         {
            this.loadExchangeUi(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         }
      }
      
      private function onUiUnloaded(param1:String) : void
      {
         if(param1 == UIEnum.STORAGE_UI)
         {
            if(this._waitStorageUnloadData)
            {
               this.loadExchangeUi(this._waitStorageUnloadData.pSourceName,this._waitStorageUnloadData.pTargetName,this._waitStorageUnloadData.pSourceLook,this._waitStorageUnloadData.pTargetLook,this._waitStorageUnloadData.pSourceCurrentPods,this._waitStorageUnloadData.pTargetCurrentPods,this._waitStorageUnloadData.pSourceMaxPods,this._waitStorageUnloadData.pTargetMaxPods,this._waitStorageUnloadData.otherId);
               this._waitStorageUnloadData = null;
               this.sysApi.removeHook(UiUnloaded);
            }
         }
      }
      
      private function loadExchangeUi(param1:String, param2:String, param3:Object, param4:Object, param5:int, param6:int, param7:int, param8:int, param9:Number) : void
      {
         if(this._playerName == param1)
         {
            this.uiApi.unloadUi(this._popupName);
         }
         if(this.uiApi.getUi(UIEnum.STORAGE_UI))
         {
            this.sysApi.log(8,"L\'interface de stocage aurait du avoir été préalablement déchargé.");
            return;
         }
         this.uiApi.loadUi(UIEnum.EXCHANGE_UI,UIEnum.EXCHANGE_UI,{
            "sourceName":param1,
            "targetName":param2,
            "sourceLook":param3,
            "targetLook":param4,
            "sourceCurrentPods":param5,
            "targetCurrentPods":param6,
            "sourceMaxPods":param7,
            "targetMaxPods":param8,
            "otherId":param9
         });
         this.sysApi.dispatchHook(d2hooks.OpenInventory,"exchange");
      }
      
      protected function showUi() : void
      {
         this.uiApi.loadUi(UIEnum.EXCHANGE_UI,UIEnum.EXCHANGE_UI);
      }
      
      protected function onExchangeRequestCharacterFromMe(param1:String, param2:String) : void
      {
         this._playerName = param1;
         this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.exchange.requestInProgress"),this.uiApi.getText("ui.exchange.requestInProgress"),[this.uiApi.getText("ui.common.cancel")],[this.sendActionExchangeRefuse],null,this.sendActionExchangeRefuse);
      }
      
      protected function onExchangeRequestCharacterToMe(param1:String, param2:String) : void
      {
         this._playerName = param1;
         this._ignoreName = param2;
         this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.exchange.exchangeRequest"),this.uiApi.getText("ui.exchange.resquestMessage",param2),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no"),this.uiApi.getText("ui.common.ignore")],[this.sendActionExchangeAccept,this.sendActionExchangeRefuse,this.sendActionIgnore],this.sendActionExchangeAccept,this.sendActionExchangeRefuse);
      }
      
      protected function onExchangeLeave(param1:Boolean) : void
      {
         this.sysApi.enableWorldInteraction();
         if(!param1 && this.uiApi.getUi(this._popupName))
         {
            this.uiApi.unloadUi(this._popupName);
         }
      }
      
      private function onExchangeStartOkNpcTrade(param1:uint, param2:String, param3:String, param4:Object, param5:Object) : void
      {
         this.sysApi.disableWorldInteraction();
         this.uiApi.loadUi(UIEnum.EXCHANGE_NPC_UI,UIEnum.EXCHANGE_NPC_UI,{
            "sourceName":param2,
            "targetName":param3,
            "sourceLook":param4,
            "targetLook":param5
         });
         this.sysApi.sendAction(new d2actions.OpenInventory("exchangeNpc"));
      }
      
      private function sendActionExchangeAccept() : void
      {
         this.sysApi.sendAction(new ExchangeAccept());
      }
      
      private function sendActionExchangeRefuse() : void
      {
         this.sysApi.sendAction(new ExchangeRefuse());
      }
      
      private function sendActionIgnore() : void
      {
         this.sysApi.sendAction(new ExchangeRefuse());
         this.sysApi.sendAction(new AddIgnored(this._ignoreName));
      }
   }
}
