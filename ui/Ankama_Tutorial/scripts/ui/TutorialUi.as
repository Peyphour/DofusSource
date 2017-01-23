package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.GuidedModeQuitRequest;
   import d2actions.GuidedModeReturnRequest;
   import d2actions.QuestInfosRequest;
   import d2enums.ComponentHookList;
   import d2hooks.DocumentReadingBegin;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeShopStockStarted;
   import d2hooks.ExchangeStartOkCraft;
   import d2hooks.ExchangeStartOkHumanVendor;
   import d2hooks.ExchangeStartOkNpcShop;
   import d2hooks.ExchangeStartOkNpcTrade;
   import d2hooks.ExchangeStarted;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightJoin;
   import d2hooks.GameRolePlayPlayerLifeStatus;
   import d2hooks.LeaveDialog;
   import d2hooks.NpcDialogCreation;
   import d2hooks.QuestInfosUpdated;
   import d2hooks.QuestStarted;
   import d2hooks.QuestStepValidated;
   import d2hooks.RewardableAchievementsVisible;
   import d2hooks.ShowObjectLinked;
   import d2hooks.SlideComplete;
   import d2hooks.TeleportDestinationList;
   import d2hooks.UiLoaded;
   import flash.events.TimerEvent;
   import managers.TutorialStepManager;
   
   public class TutorialUi
   {
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var menuApi:ContextMenuApi;
      
      public var questApi:QuestApi;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var ctr_joinTutorial:GraphicContainer;
      
      public var ctr_quest:GraphicContainer;
      
      public var ctr_reward:GraphicContainer;
      
      public var lbl_stepName:Label;
      
      public var lbl_expRewardValue:Label;
      
      public var tx_expRewardIcon:TextureBitmap;
      
      public var slot_reward1:Slot;
      
      public var texta_description:Label;
      
      public var pb_progressBar:ProgressBar;
      
      public var btn_close_ctr_quest:ButtonContainer;
      
      public var btn_joinTutorial:ButtonContainer;
      
      public var tx_stepImage:Texture;
      
      private var _iconTexture:Texture;
      
      private var _tutorialManager:Object;
      
      private var _questInfo:Object;
      
      private var _quest:Object;
      
      private var _currentStepNumber:uint;
      
      private var _tipsUiClass:Object = null;
      
      private var _heightBackground:int;
      
      private var _yReward:int;
      
      private var _yProgress:int;
      
      private var _popupName:String;
      
      private var _unloading:Boolean = false;
      
      public function TutorialUi()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(QuestStarted,this.onQuestStarted);
         this.sysApi.addHook(QuestStepValidated,this.onQuestStepValidated);
         this.sysApi.addHook(QuestInfosUpdated,this.onQuestInfosUpdated);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.sysApi.addHook(ExchangeStarted,this.onExchangeStarted);
         this.sysApi.addHook(ExchangeStartOkHumanVendor,this.onExchangeStartOkHumanVendor);
         this.sysApi.addHook(ExchangeShopStockStarted,this.onExchangeShopStockStarted);
         this.sysApi.addHook(ExchangeStartOkNpcTrade,this.onExchangeStartOkNpcTrade);
         this.sysApi.addHook(GameRolePlayPlayerLifeStatus,this.onGameRolePlayPlayerLifeStatus);
         this.sysApi.addHook(TeleportDestinationList,this.onTeleportDestinationList);
         this.sysApi.addHook(ExchangeStartOkCraft,this.onExchangeStartOkCraft);
         this.sysApi.addHook(ExchangeStartOkNpcShop,this.onExchangeStartOkNpcShop);
         this.sysApi.addHook(DocumentReadingBegin,this.onDocumentReadingBegin);
         this.sysApi.addHook(NpcDialogCreation,this.onNpcDialogCreation);
         this.sysApi.addHook(LeaveDialog,this.onLeaveDialog);
         this.sysApi.addHook(SlideComplete,this.onSlideComplete);
         if(this.uiApi.getUi("tips"))
         {
            this._tipsUiClass = this.uiApi.getUi("tips").uiClass;
         }
         else
         {
            this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         }
         this._heightBackground = this.uiApi.me().getConstant("height_background");
         this._yReward = this.uiApi.me().getConstant("y_reward");
         this._yProgress = this.uiApi.me().getConstant("y_progress");
         this._tutorialManager = TutorialStepManager.getInstance();
         this._tutorialManager.disabled = false;
         if(!this._tutorialManager.preloaded)
         {
            this._tutorialManager.preload();
         }
         this.uiApi.addComponentHook(this.slot_reward1,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.slot_reward1,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.slot_reward1,ComponentHookList.ON_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.slot_reward1,ComponentHookList.ON_RELEASE);
         this._iconTexture = this.uiApi.createComponent("Texture") as Texture;
         this._iconTexture.width = this.slot_reward1.icon.width;
         this._iconTexture.height = this.slot_reward1.icon.height;
         this.uiApi.addChild(this.uiApi.getUi(UIEnum.BANNER),this._iconTexture);
         if(param1[0])
         {
            this.displayTutorial(false);
         }
         else
         {
            this.closeTutorial();
         }
         this.moveDefault();
      }
      
      public function get tutorialDisabled() : Boolean
      {
         return this._tutorialManager.disabled;
      }
      
      public function get quest() : Object
      {
         if(!this._quest)
         {
            this._quest = this.dataApi.getQuest(TutorialConstants.QUEST_TUTORIAL_ID);
         }
         return this._quest;
      }
      
      public function unload() : void
      {
         this._unloading = true;
         if(this._tutorialManager && !this._tutorialManager.disabled)
         {
            this._tutorialManager.disabled = true;
         }
         var _loc1_:Object = this.getTipsUi();
         if(_loc1_)
         {
            _loc1_.activate();
         }
         if(this.sysApi && this.questApi && this.questApi.getRewardableAchievements() && this.questApi.getRewardableAchievements().length > 0)
         {
            this.sysApi.dispatchHook(RewardableAchievementsVisible,true);
         }
         if(Api.highlight)
         {
            Api.highlight.stop();
         }
         this.uiApi.removeChild(this.uiApi.getUi(UIEnum.BANNER),this._iconTexture);
         this.uiApi.unloadUi(this._popupName);
      }
      
      public function onQuestStarted(param1:uint) : void
      {
         if(param1 == TutorialConstants.QUEST_TUTORIAL_ID)
         {
            this.sysApi.sendAction(new QuestInfosRequest(TutorialConstants.QUEST_TUTORIAL_ID));
         }
      }
      
      public function moveLeft() : void
      {
         this.ctr_quest.x = 5;
         this.ctr_quest.y = 15;
      }
      
      public function moveDefault() : void
      {
         this.ctr_quest.x = 850;
         this.ctr_quest.y = 15;
      }
      
      private function onQuestInfosUpdated(param1:uint, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         if(param1 == TutorialConstants.QUEST_TUTORIAL_ID && param2 && this._tutorialManager.disabled == false)
         {
            if(this.questApi.getRewardableAchievements() && this.questApi.getRewardableAchievements().length > 0)
            {
               this.sysApi.dispatchHook(RewardableAchievementsVisible,false);
            }
            this._questInfo = this.questApi.getQuestInformations(param1);
            this._quest = this.dataApi.getQuest(this._questInfo.questId);
            this._currentStepNumber = 0;
            for each(_loc3_ in this.quest.stepIds)
            {
               if(_loc3_ == this._questInfo.stepId)
               {
                  break;
               }
               this._currentStepNumber++;
            }
            if(param1 == 489 && !this._tutorialManager.doneIntroStep)
            {
               this._tutorialManager.jumpToStep(0);
            }
            else
            {
               this._tutorialManager.jumpToStep(this._currentStepNumber + 1);
            }
            this.setStep(this._currentStepNumber);
            this.ctr_quest.visible = this.visible;
         }
      }
      
      private function onQuestStepValidated(param1:uint, param2:uint) : void
      {
         if(param1 == TutorialConstants.QUEST_TUTORIAL_ID)
         {
            this._currentStepNumber++;
            this.setStep(this._currentStepNumber);
            this._tutorialManager.jumpToStep(this._currentStepNumber + 1);
         }
      }
      
      private function onSlideComplete(param1:GraphicContainer) : void
      {
         param1.visible = false;
      }
      
      private function onAnimBagTimer(param1:TimerEvent) : void
      {
         param1.target.stop;
         var _loc2_:Object = this.uiApi.getUi("bannerMenu").uiClass;
         var _loc3_:Texture = _loc2_.getSlotByBtnId(3).icon;
         _loc3_.playOnce = true;
         _loc3_.gotoAndPlay = 10;
      }
      
      private function onUiLoaded(param1:String) : void
      {
         var _loc2_:Object = null;
         if(param1 == "tips" && !this._tutorialManager.disabled)
         {
            _loc2_ = this.getTipsUi();
            if(_loc2_)
            {
               _loc2_.deactivate();
            }
         }
         this.sysApi.dispatchHook(RewardableAchievementsVisible,false);
      }
      
      private function setStep(param1:int) : void
      {
         var _loc7_:Object = null;
         var _loc2_:Object = this.quest.stepIds;
         var _loc3_:uint = _loc2_[param1];
         var _loc4_:Object = this.dataApi.getQuestStep(_loc3_);
         this.lbl_stepName.text = _loc4_.name;
         this.texta_description.text = _loc4_.description;
         this.tx_stepImage.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus") + "tutorial/illu_tuto_" + (param1 + 1) + ".png");
         var _loc5_:int = this.texta_description.textHeight + 10;
         this.ctr_quest.height = this._heightBackground + _loc5_;
         this.ctr_reward.y = this.texta_description.y + 5 + _loc5_;
         if(this._iconTexture)
         {
            this._iconTexture.y = this.ctr_quest.y + (this._yReward + this.texta_description.textHeight + 10) + this.slot_reward1.y;
         }
         var _loc6_:int = _loc2_.length;
         this.pb_progressBar.value = param1 / _loc6_;
         if(_loc4_.experienceReward > 0)
         {
            this.lbl_expRewardValue.text = _loc4_.experienceReward;
            this.lbl_expRewardValue.visible = true;
            this.tx_expRewardIcon.visible = true;
         }
         else
         {
            this.lbl_expRewardValue.visible = false;
            this.tx_expRewardIcon.visible = false;
         }
         if(_loc4_.itemsReward && _loc4_.itemsReward.length > 0)
         {
            this.slot_reward1.visible = true;
            _loc7_ = this.dataApi.getItemWrapper(_loc4_.itemsReward[0][0]);
            this.slot_reward1.data = _loc7_;
         }
         else
         {
            this.slot_reward1.visible = false;
            this.slot_reward1.data = null;
         }
         this.uiApi.me().render();
      }
      
      public function onRollOver(param1:Object) : void
      {
         switch(param1)
         {
            case this.slot_reward1:
               if(param1.data)
               {
                  this.uiApi.showTooltip(param1.data,param1,false,"standard",0,2,3,null,null,{
                     "showEffects":true,
                     "header":true,
                     "averagePrice":false
                  },"ItemInfo" + param1.data.objectGID);
               }
               break;
            case this.btn_joinTutorial:
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.tutorial.joinTutorialTooltip")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
               break;
            case this.btn_close_ctr_quest:
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.tutorial.leaveTutorialTooltip")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == this.slot_reward1)
         {
            _loc2_ = param1.data;
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_joinTutorial:
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.tutorial.tutorial"),this.uiApi.getText("ui.tutorial.joinTutorialPopup"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onJoinTutorial,this.nullFunction],this.onJoinTutorial,this.nullFunction);
               break;
            case this.btn_close_ctr_quest:
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.tutorial.tutorial"),this.uiApi.getText("ui.tutorial.closeTutorialPopup"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onCloseTutorial,this.nullFunction],this.onCloseTutorial,this.nullFunction);
               break;
            case this.slot_reward1:
               if(!this.sysApi.getOption("displayTooltips","dofus"))
               {
                  this.sysApi.dispatchHook(ShowObjectLinked,this.slot_reward1.data);
               }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            this.uiApi.showTooltip(param2.data,param2.container,false,"standard",8,0,0,"itemName",null,{
               "showEffects":true,
               "header":true
            },"ItemInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onJoinTutorial() : void
      {
         if(this._unloading)
         {
            return;
         }
         this.sysApi.sendAction(new GuidedModeReturnRequest());
         this.sysApi.dispatchHook(RewardableAchievementsVisible,false);
      }
      
      public function onCloseTutorial() : void
      {
         if(this._unloading)
         {
            return;
         }
         this.sysApi.sendAction(new GuidedModeQuitRequest());
         if(this.questApi.getRewardableAchievements().length > 0)
         {
            this.sysApi.dispatchHook(RewardableAchievementsVisible,true);
         }
         if(this._tutorialManager.playingDialogue)
         {
            Api.sound.stopStopablesoundById(this._tutorialManager.playingDialogue);
         }
      }
      
      public function displayTutorial(param1:Boolean = true) : void
      {
         this.sysApi.sendAction(new QuestInfosRequest(TutorialConstants.QUEST_TUTORIAL_ID));
         this.ctr_joinTutorial.visible = false;
         this.ctr_quest.visible = param1;
         this._tutorialManager.disabled = false;
         var _loc2_:Object = this.getTipsUi();
         if(_loc2_)
         {
            _loc2_.deactivate();
         }
      }
      
      public function get visible() : Boolean
      {
         return !this._tutorialManager.disabled;
      }
      
      public function closeTutorial() : void
      {
         this.ctr_quest.visible = false;
         this.ctr_joinTutorial.visible = true;
         this._tutorialManager.disabled = true;
         var _loc1_:Object = this.getTipsUi();
         if(_loc1_)
         {
            _loc1_.activate();
         }
         Api.highlight.stop();
      }
      
      private function getTipsUi() : Object
      {
         var _loc1_:Object = this.uiApi.getUi("tips");
         if(_loc1_)
         {
            this._tipsUiClass = _loc1_.uiClass;
            if(this._tipsUiClass)
            {
               return this._tipsUiClass;
            }
         }
         return null;
      }
      
      public function nullFunction() : void
      {
      }
      
      public function onGameFightJoin(param1:Boolean, param2:Boolean, param3:Boolean, param4:int, param5:int, param6:Boolean) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.visible = false;
         }
         this.btn_close_ctr_quest.disabled = true;
      }
      
      public function onGameFightEnd(param1:Object) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.visible = true;
         }
         this.btn_close_ctr_quest.disabled = false;
      }
      
      public function onNpcDialogCreation(param1:int, param2:int, param3:Object) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      public function onLeaveDialog() : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = false;
         }
      }
      
      private function onExchangeStarted(param1:String, param2:String, param3:Object, param4:Object, param5:int, param6:int, param7:int, param8:int, param9:Number) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onExchangeLeave(param1:Boolean) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = false;
         }
      }
      
      private function onExchangeStartOkHumanVendor(param1:String, param2:Object, param3:Object) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onExchangeShopStockStarted(param1:Object) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onExchangeStartOkNpcShop(param1:int, param2:Object, param3:Object, param4:int) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onExchangeStartOkNpcTrade(param1:uint, param2:String, param3:String, param4:Object, param5:Object) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onDocumentReadingBegin(param1:uint) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onTeleportDestinationList(param1:Object, param2:uint) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onExchangeStartOkCraft(param1:uint) : void
      {
         if(this._tutorialManager.disabled)
         {
            this.ctr_joinTutorial.disabled = true;
         }
      }
      
      private function onGameRolePlayPlayerLifeStatus(param1:uint, param2:uint) : void
      {
         if(param2 == 0)
         {
            switch(param1)
            {
               case 0:
                  if(this._tutorialManager.disabled)
                  {
                     this.ctr_joinTutorial.disabled = false;
                  }
                  break;
               case 1:
                  if(this._tutorialManager.disabled)
                  {
                     this.ctr_joinTutorial.disabled = true;
                  }
                  break;
               case 2:
                  if(this._tutorialManager.disabled)
                  {
                     this.ctr_joinTutorial.disabled = true;
                  }
            }
         }
      }
   }
}
