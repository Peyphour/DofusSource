package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.QuestListRequest;
   import d2enums.BuildTypeEnum;
   import d2hooks.CurrentMap;
   import d2hooks.IntroductionCinematicEnd;
   import d2hooks.IntroductionCinematicStart;
   import d2hooks.Notification;
   import d2hooks.NotificationReset;
   import d2hooks.QuestListUpdated;
   import d2hooks.QuestValidated;
   import d2hooks.RefreshTips;
   import d2hooks.UiLoaded;
   import flash.display.Sprite;
   import managers.AdvancedTutorialStepManager;
   import managers.TutorialStepManager;
   import ui.TipsUi;
   import ui.TutorialUi;
   
   public class Tutorial extends Sprite
   {
       
      
      private var include_TipsUi:TipsUi;
      
      private var include_TutorialUi:TutorialUi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modMenu:Object;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var questApi:QuestApi;
      
      public var dataApi:DataApi;
      
      public var mapApi:MapApi;
      
      public var highlightApi:HighlightApi;
      
      public var fightApi:FightApi;
      
      public var storageApi:StorageApi;
      
      public var bindsApi:BindsApi;
      
      public var soundApi:SoundApi;
      
      public var roleplayApi:RoleplayApi;
      
      public const SUPERAREA_INCARNAM:uint = 3;
      
      public const MAP_REFERENCE_TUTORIAL:uint = 12;
      
      public const MAX_CHARACTER_LEVEL_FOR_TUTORIAL:uint = 14;
      
      private var _subArea:Object;
      
      private var _showTutorial:Boolean = false;
      
      private var _questListUpdated:Boolean = false;
      
      private var _disableTutorial:Boolean = false;
      
      public function Tutorial()
      {
         super();
      }
      
      public function main() : void
      {
         Api.ui = this.uiApi;
         Api.system = this.sysApi;
         Api.modMenu = this.modMenu;
         Api.player = this.playerApi;
         Api.data = this.dataApi;
         Api.highlight = this.highlightApi;
         Api.fight = this.fightApi;
         Api.storage = this.storageApi;
         Api.binds = this.bindsApi;
         Api.quest = this.questApi;
         Api.sound = this.soundApi;
         Api.roleplay = this.roleplayApi;
         this.sysApi.createHook("RefreshTips");
         this.sysApi.addHook(Notification,this.onNotification);
         this.sysApi.addHook(NotificationReset,this.resetTips);
         this.sysApi.addHook(RefreshTips,this.onRefreshTips);
         this.sysApi.addHook(CurrentMap,this.onCurrentMap);
         this.sysApi.addHook(QuestListUpdated,this.onQuestListUpdated);
         this.sysApi.addHook(QuestValidated,this.onQuestValidated);
         this.sysApi.addHook(IntroductionCinematicStart,this.onIntroductionCinematicStart);
         this.sysApi.addHook(IntroductionCinematicEnd,this.onIntroductionCinematicEnd);
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         if(this.sysApi.getBuildType() == BuildTypeEnum.INTERNAL)
         {
            this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         }
      }
      
      public function unload() : void
      {
         if(AdvancedTutorialStepManager.getInstance(false) != null)
         {
            AdvancedTutorialStepManager.getInstance().destroy();
         }
      }
      
      private function onRefreshTips(... rest) : void
      {
         if(!this.uiApi.getUi("tips"))
         {
            this.uiApi.loadUi("tips","tips",[],3) as TipsUi;
         }
         else
         {
            this.uiApi.getUi("tips").uiClass.checkQuietMode();
         }
      }
      
      private function resetTips(... rest) : void
      {
         var _loc2_:Object = this.questApi.getNotificationList();
         if(_loc2_)
         {
            this.uiApi.getUi("tips").uiClass.resetTips(_loc2_);
         }
         this.onRefreshTips();
      }
      
      private function onNotification(param1:Object) : void
      {
         if(!this.uiApi.getUi("tips"))
         {
            this.uiApi.loadUi("tips","tips",[param1],3);
         }
      }
      
      private function onUiLoaded(param1:String) : void
      {
         if(param1 == "bannerActionBar" && this.sysApi.getBuildType() == BuildTypeEnum.INTERNAL)
         {
            TutorialStepManager.getInstance().preload();
            if(this.uiApi.getUi("chat") && this.uiApi.getUi("tips"))
            {
               this.sysApi.removeHook(UiLoaded);
            }
         }
         if(param1 == "chat")
         {
            this.onRefreshTips();
            if(!this.sysApi.getBuildType() == BuildTypeEnum.INTERNAL || this.uiApi.getUi("bannerActionBar"))
            {
               this.sysApi.removeHook(UiLoaded);
            }
         }
      }
      
      private function onCurrentMap(param1:uint) : void
      {
         this._subArea = this.mapApi.subAreaByMapId(param1);
         if(this._subArea && this._subArea.id == 536)
         {
            if(this.uiApi.getUi(UIEnum.TUTORIAL_UI))
            {
               if(!this.uiApi.getUi(UIEnum.TUTORIAL_UI).uiClass.visible)
               {
                  this.uiApi.getUi(UIEnum.TUTORIAL_UI).uiClass.displayTutorial();
               }
            }
            else
            {
               this.uiApi.loadUi(UIEnum.TUTORIAL_UI,UIEnum.TUTORIAL_UI,[true]);
            }
         }
         else if(this._subArea && this._subArea.area.superArea.id == this.SUPERAREA_INCARNAM)
         {
            if(this.uiApi.getUi(UIEnum.TUTORIAL_UI))
            {
               if(this.uiApi.getUi(UIEnum.TUTORIAL_UI).uiClass.visible)
               {
                  this.uiApi.getUi(UIEnum.TUTORIAL_UI).uiClass.closeTutorial();
               }
            }
            else
            {
               this.showTutorialInIncarnam();
            }
         }
         else if(this.uiApi.getUi(UIEnum.TUTORIAL_UI))
         {
            this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
         }
         if(TutorialAdvancedConstants.MAP_IDS.indexOf(param1) != -1)
         {
            AdvancedTutorialStepManager.getInstance().currentMapId = param1;
         }
         else
         {
            AdvancedTutorialStepManager.getInstance().destroy();
         }
      }
      
      private function onQuestListUpdated() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:Object = this.questApi.getCompletedQuests();
         this._questListUpdated = true;
         this._showTutorial = true;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ == TutorialConstants.QUEST_TUTORIAL_ID)
            {
               this._showTutorial = false;
               if(this.uiApi.getUi(UIEnum.TUTORIAL_UI))
               {
                  this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
               }
            }
         }
         this.showTutorialInIncarnam();
      }
      
      private function onQuestValidated(param1:int) : void
      {
         if(param1 == TutorialConstants.QUEST_TUTORIAL_ID)
         {
            this._questListUpdated = true;
            this._showTutorial = false;
            if(this.uiApi.getUi(UIEnum.TUTORIAL_UI))
            {
               this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
            }
         }
      }
      
      private function showTutorialInIncarnam() : void
      {
         if(this._questListUpdated)
         {
            if(this._showTutorial && this._subArea && this._subArea.area.superArea.id == this.SUPERAREA_INCARNAM && !this.uiApi.getUi(UIEnum.TUTORIAL_UI) && !this._disableTutorial)
            {
               this.uiApi.loadUi(UIEnum.TUTORIAL_UI,UIEnum.TUTORIAL_UI,[false]);
            }
         }
         else
         {
            this.sysApi.sendAction(new QuestListRequest());
         }
      }
      
      private function onIntroductionCinematicEnd() : void
      {
         this._disableTutorial = false;
         this.onCurrentMap(TutorialConstants.TUTORIAL_MAP_ID_FIRST);
      }
      
      private function onIntroductionCinematicStart() : void
      {
         if(this.uiApi.getUi(UIEnum.TUTORIAL_UI))
         {
            this.uiApi.unloadUi(UIEnum.TUTORIAL_UI);
         }
         this._disableTutorial = true;
      }
   }
}
