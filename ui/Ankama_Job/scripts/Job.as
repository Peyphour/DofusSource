package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.AddIgnored;
   import d2actions.ExchangeAccept;
   import d2actions.ExchangeRefuse;
   import d2enums.ExchangeTypeEnum;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeMultiCraftRequest;
   import d2hooks.ExchangeStartOkCraft;
   import d2hooks.ExchangeStartOkJobIndex;
   import d2hooks.ExchangeStartOkMultiCraft;
   import d2hooks.ExchangeStartOkRecycleTrade;
   import d2hooks.ExchangeStartOkRunesTrade;
   import d2hooks.JobsExpOtherPlayerUpdated;
   import d2hooks.OpenInventory;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import ui.CheckCraft;
   import ui.Craft;
   import ui.CraftCoop;
   import ui.CrafterForm;
   import ui.CrafterList;
   import ui.Decraft;
   import ui.JobLevelUp;
   import ui.Recycle;
   import ui.RuneMaker;
   import ui.SmithMagic;
   import ui.SmithMagicCoop;
   
   public class Job extends Sprite
   {
      
      private static var _self:Job;
       
      
      protected var craft:Craft;
      
      protected var decraft:Decraft;
      
      protected var crafterForm:CrafterForm;
      
      protected var crafterList:CrafterList;
      
      protected var craftCoop:CraftCoop;
      
      protected var smithMagic:SmithMagic;
      
      protected var smithMagicCoop:SmithMagicCoop;
      
      protected var jobLevelUp:ui.JobLevelUp;
      
      protected var checkCraft:CheckCraft;
      
      protected var runeMaker:RuneMaker;
      
      protected var recycle:Recycle;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var jobsApi:JobsApi;
      
      public var socialApi:SocialApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var storageApi:StorageApi;
      
      private var _popupName:String;
      
      private var _ignoreName:String;
      
      private var _mageLog:Array;
      
      private var _jobExpByPlayerId:Dictionary;
      
      public function Job()
      {
         this._mageLog = new Array();
         this._jobExpByPlayerId = new Dictionary();
         super();
      }
      
      public static function getInstance() : Job
      {
         return _self;
      }
      
      public function main() : void
      {
         _self = this;
         this.sysApi.addHook(ExchangeStartOkCraft,this.onExchangeStartOkCraft);
         this.sysApi.addHook(ExchangeStartOkMultiCraft,this.onExchangeStartOkMultiCraft);
         this.sysApi.addHook(ExchangeMultiCraftRequest,this.onExchangeMultiCraftRequest);
         this.sysApi.addHook(ExchangeStartOkJobIndex,this.onExchangeStartOkJobIndex);
         this.sysApi.addHook(ExchangeStartOkRunesTrade,this.onExchangeStartOkRunesTrade);
         this.sysApi.addHook(ExchangeStartOkRecycleTrade,this.onExchangeStartOkRecycleTrade);
         this.sysApi.addHook(JobsExpOtherPlayerUpdated,this.onJobsExpOtherPlayerUpdated);
         this.sysApi.addHook(d2hooks.JobLevelUp,this.onJobLevelUp);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
      }
      
      public function get mageLog() : Array
      {
         return this._mageLog;
      }
      
      public function addToMageLog(param1:Object) : void
      {
         this._mageLog.push(param1);
      }
      
      public function removeMageLogFirstLine() : void
      {
         this._mageLog.splice(0,1);
      }
      
      private function onExchangeStartOkCraft(param1:uint) : void
      {
         this.sysApi.disableWorldInteraction();
         var _loc2_:Object = this.jobsApi.getSkillFromId(param1);
         if(_loc2_.isForgemagus || _loc2_.modifiableItemTypeIds.length > 0)
         {
            if(!this.uiApi.getUi(UIEnum.SMITH_MAGIC))
            {
               this.uiApi.loadUi(UIEnum.SMITH_MAGIC,UIEnum.SMITH_MAGIC,{"skillId":param1});
            }
            this.sysApi.dispatchHook(OpenInventory,"smithMagic");
         }
         else if(param1 == 181)
         {
            this.uiApi.loadUi(UIEnum.RUNE_MAKER,UIEnum.RUNE_MAKER);
            this.sysApi.dispatchHook(OpenInventory,"decraft");
         }
         else
         {
            if(!this.uiApi.getUi(UIEnum.CRAFT))
            {
               this.uiApi.loadUi(UIEnum.CRAFT,UIEnum.CRAFT,{"skillId":param1});
            }
            this.sysApi.dispatchHook(OpenInventory,"craft");
         }
      }
      
      private function onExchangeStartOkMultiCraft(param1:int, param2:Object, param3:Object) : void
      {
         var _loc5_:Object = null;
         this.sysApi.disableWorldInteraction();
         var _loc4_:Object = this.jobsApi.getSkillFromId(param1);
         if(this.uiApi.getUi(this._popupName))
         {
            this.uiApi.unloadUi(this._popupName);
         }
         if(_loc4_.isForgemagus)
         {
            if(!this.uiApi.getUi(UIEnum.SMITH_MAGIC_COOP))
            {
               this.uiApi.loadUi(UIEnum.SMITH_MAGIC_COOP,UIEnum.SMITH_MAGIC,{
                  "skillId":param1,
                  "crafterInfos":param2,
                  "customerInfos":param3
               });
            }
            _loc5_ = this.playerApi.getPlayedCharacterInfo();
            this.sysApi.dispatchHook(OpenInventory,"smithMagicCoop");
         }
         else
         {
            if(!this.uiApi.getUi(UIEnum.CRAFT_COOP))
            {
               this.uiApi.loadUi(UIEnum.CRAFT_COOP,UIEnum.CRAFT,{
                  "skillId":param1,
                  "crafterInfos":param2,
                  "customerInfos":param3,
                  "jobExperience":this._jobExpByPlayerId[param2.id]
               });
            }
            this.sysApi.dispatchHook(OpenInventory,"craft");
         }
      }
      
      private function onExchangeMultiCraftRequest(param1:int, param2:String, param3:Number) : void
      {
         var _loc4_:Object = this.playerApi.getPlayedCharacterInfo();
         if(param3 == _loc4_.id)
         {
            this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.exchange"),this.uiApi.getText("ui.craft.waitForCraftClient",param2),[this.uiApi.getText("ui.common.cancel")],[this.sendActionCraftRefuse],null,this.sendActionCraftRefuse);
         }
         else
         {
            this._ignoreName = param2;
            if(param1 == ExchangeTypeEnum.MULTICRAFT_CUSTOMER)
            {
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.exchange"),this.uiApi.getText("ui.craft.CrafterAskCustomer",param2),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no"),this.uiApi.getText("ui.common.ignore")],[this.sendActionCraftAccept,this.sendActionCraftRefuse,this.sendActionIgnore],this.sendActionCraftAccept,this.sendActionCraftRefuse);
            }
            else if(param1 == ExchangeTypeEnum.MULTICRAFT_CRAFTER)
            {
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.exchange"),this.uiApi.getText("ui.craft.CustomerAskCrafter",param2),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no"),this.uiApi.getText("ui.common.ignore")],[this.sendActionCraftAccept,this.sendActionCraftRefuse,this.sendActionIgnore],this.sendActionCraftAccept,this.sendActionCraftRefuse);
            }
         }
      }
      
      private function onJobLevelUp(param1:uint, param2:String, param3:uint) : void
      {
         if(!this.uiApi.getUi("jobLevelUp"))
         {
            this.uiApi.loadUi("jobLevelUp","jobLevelUp",{
               "jobName":param2,
               "newLevel":param3
            });
         }
         else
         {
            this.uiApi.getUi("jobLevelUp").uiClass.onJobLevelUp(param1,param2,param3);
         }
      }
      
      private function onExchangeLeave(param1:Boolean) : void
      {
         if(this.uiApi.getUi(this._popupName))
         {
            this.uiApi.unloadUi(this._popupName);
         }
      }
      
      private function sendActionCraftAccept() : void
      {
         this.sysApi.sendAction(new ExchangeAccept());
      }
      
      private function sendActionCraftRefuse() : void
      {
         this.sysApi.sendAction(new ExchangeRefuse());
      }
      
      private function sendActionIgnore() : void
      {
         this.sysApi.sendAction(new ExchangeRefuse());
         this.sysApi.sendAction(new AddIgnored(this._ignoreName));
      }
      
      public function onExchangeStartOkJobIndex(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         this.uiApi.loadUi("crafterList","crafterList",_loc2_);
      }
      
      public function onExchangeStartOkRunesTrade() : void
      {
         this.uiApi.loadUi(UIEnum.RUNE_MAKER,UIEnum.RUNE_MAKER);
         this.sysApi.dispatchHook(OpenInventory,"decraft");
      }
      
      public function onExchangeStartOkRecycleTrade(param1:uint, param2:uint) : void
      {
         this.uiApi.loadUi(UIEnum.RECYCLE,UIEnum.RECYCLE,[param1,param2]);
         this.sysApi.dispatchHook(OpenInventory,"decraft");
      }
      
      protected function onJobsExpOtherPlayerUpdated(param1:Number, param2:Object) : void
      {
         this._jobExpByPlayerId[param1] = param2;
      }
   }
}
