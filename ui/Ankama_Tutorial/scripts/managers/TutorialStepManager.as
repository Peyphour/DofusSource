package managers
{
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ShortcutWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.QuestObjectiveValidation;
   import d2hooks.CancelCastSpell;
   import d2hooks.CastSpellMode;
   import d2hooks.CurrentMap;
   import d2hooks.DropEnd;
   import d2hooks.DropStart;
   import d2hooks.EquipmentObjectMove;
   import d2hooks.FightResultClosed;
   import d2hooks.FightSpellCast;
   import d2hooks.GameEntityDisposition;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightStart;
   import d2hooks.GameFightStarting;
   import d2hooks.GameFightTurnEnd;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.NpcDialogRepliesVisible;
   import d2hooks.PlayerFightMove;
   import d2hooks.PlayerMove;
   import d2hooks.StopableSoundEnded;
   import d2hooks.StorageFilterUpdated;
   import d2hooks.UiLoaded;
   import d2hooks.UiUnloaded;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class TutorialStepManager
   {
      
      private static var _self:TutorialStepManager;
      
      private static var _watchedComponents:Object = null;
      
      private static var _fightWatchedComponents:Object = null;
      
      private static var _disabledShortcuts:Object = {
         "cac":false,
         "s1":false,
         "s2":false,
         "s3":false,
         "s4":false,
         "s5":false,
         "s6":false,
         "s7":false,
         "s8":false,
         "s9":false,
         "s10":false,
         "s11":false,
         "s12":false,
         "s13":false,
         "s14":false,
         "s15":false,
         "s16":false,
         "s17":false,
         "s18":false,
         "s19":false,
         "s20":false,
         "skipTurn":false,
         "bannerSpellsTab":false,
         "bannerItemsTab":false,
         "bannerEmotesTab":false,
         "bannerPreviousTab":false,
         "bannerNextTab":false,
         "flagCurrentMap":false,
         "openInventory":false,
         "openBookSpell":false,
         "openBookQuest":false,
         "openBookAlignment":false,
         "openBookJob":false,
         "openWorldMap":false,
         "openSocialFriends":false,
         "openSocialGuild":false,
         "openSocialAlliance":false,
         "openSocialSpouse":false,
         "openCharacterSheet":false,
         "openMount":false,
         "openWebBrowser":false,
         "openTeamSearch":false,
         "openPvpArena":false,
         "openSell":false,
         "openAlmanax":false,
         "openAchievement":false,
         "openTitle":false,
         "openBestiary":false,
         "openHavenbag":false,
         "showAllNames":false,
         "showEntitiesTooltips":false,
         "toggleRide":false,
         "pageItem1":false,
         "pageItem2":false,
         "pageItem3":false,
         "pageItem4":false,
         "pageItem5":false,
         "pageItemDown":false,
         "pageItemUp":false
      };
      
      private static var _dropItem:Object;
      
      private static const DELAY_BEFORE_HIGHLIGHT_SHORT:uint = 5000;
      
      private static const DELAY_BEFORE_HIGHLIGHT_LONG:uint = 10000;
       
      
      private var _bannerMenuUiClass:Object;
      
      private var _actionBarUiClass:Object;
      
      private var _currentStepNumber:int = -1;
      
      private var _playingDialogue:String;
      
      private var _nextDialogue:Array;
      
      private var _playedDialogue:Array;
      
      private var _mustPlayAudioDialogue:Boolean;
      
      private var _introStepTimer:Timer;
      
      private var _quest:Object;
      
      private var _disabled:Boolean = false;
      
      public var doneIntroStep:Boolean = false;
      
      public function TutorialStepManager()
      {
         super();
         Api.system.addHook(EquipmentObjectMove,this.onEquipmentObjectMove);
         Api.system.addHook(GameFightStarting,this.onGameFightStarting);
         Api.system.addHook(GameFightStart,this.onGameFightStart);
         Api.system.addHook(GameEntityDisposition,this.onGameEntityDisposition);
         Api.system.addHook(PlayerFightMove,this.onPlayerFightMove);
         Api.system.addHook(FightSpellCast,this.onFightSpellCast);
         Api.system.addHook(GameFightTurnEnd,this.onGameFightTurnEnd);
         Api.system.addHook(PlayerMove,this.onPlayerMove);
         Api.system.addHook(UiLoaded,this.onUiLoaded);
         Api.system.addHook(UiUnloaded,this.onUiUnloaded);
         Api.system.addHook(StorageFilterUpdated,this.onStorageFilterUpdated);
         Api.system.addHook(MapComplementaryInformationsData,this.onMapComplementaryInformationsData);
         Api.system.addHook(DropStart,this.onDropStart);
         Api.system.addHook(DropEnd,this.onDropEnd);
         Api.system.addHook(CastSpellMode,this.onCastSpellMode);
         Api.system.addHook(CancelCastSpell,this.onCancelCastSpell);
         Api.system.addHook(GameFightEnd,this.onGameFightEnd);
         Api.system.addHook(StopableSoundEnded,this.onSoundEnded);
         Api.system.addHook(CurrentMap,this.onMapChange);
         Api.system.addHook(NpcDialogRepliesVisible,this.onNpcDialogRepliesVisible);
         Api.system.addHook(FightResultClosed,this.onFightResultClosed);
         this._quest = Api.data.getQuest(TutorialConstants.QUEST_TUTORIAL_ID);
         this._playedDialogue = new Array();
         var _loc1_:* = Api.system.getData(Api.player.getPlayedCharacterInfo().id + "doneIntroStep");
         if(_loc1_)
         {
            this.doneIntroStep = _loc1_;
         }
         this._mustPlayAudioDialogue = Api.system.getCurrentLanguage() == "fr" && Api.sound.updaterAvailable() && Api.system.hasAir() && Api.sound.isSoundMainClient();
         this._disabled = true;
      }
      
      public static function initStepManager() : void
      {
         _self = new TutorialStepManager();
      }
      
      public static function getInstance() : TutorialStepManager
      {
         if(_self == null)
         {
            initStepManager();
         }
         return _self;
      }
      
      public function get preloaded() : Boolean
      {
         return _watchedComponents != null && _fightWatchedComponents != null;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         this._disabled = param1;
         if(param1)
         {
            this.unsetAllDisabled();
         }
         else
         {
            this.redoSteps();
         }
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      private function onPlayerMove() : void
      {
         if(!this.disabled)
         {
            if(this._currentStepNumber == TutorialConstants.TUTORIAL_STEP_ROLEPLAY_MOVE)
            {
               this.validateCurrentStep();
            }
         }
      }
      
      private function onGameFightEnd(param1:Object) : void
      {
         if(!this.disabled)
         {
            Api.highlight.stop();
         }
      }
      
      private function onEquipmentObjectMove(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ITEM:
                  if(param1)
                  {
                     this.validateCurrentStep();
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ALL_ITEMS:
                  _loc3_ = 0;
                  _loc4_ = false;
                  for each(_loc5_ in Api.storage.getViewContent("equipment"))
                  {
                     if(_loc5_)
                     {
                        if(TutorialConstants.TUTORIAL_RINGS_POSITIONS.indexOf(_loc5_.position) != -1)
                        {
                           _loc4_ = true;
                        }
                        else if(TutorialConstants.TUTORIAL_ITEMS_POSITIONS.indexOf(_loc5_.position) != -1)
                        {
                           _loc3_++;
                        }
                     }
                  }
                  if(_loc3_ == TutorialConstants.TUTORIAL_ITEMS_POSITIONS.length && _loc4_)
                  {
                     this.validateCurrentStep();
                  }
            }
         }
      }
      
      private function onGameFightStarting(param1:uint) : void
      {
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_STARTING_A_FIGHT:
                  this.validateCurrentStep();
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIND_BOSS:
                  this.validateCurrentStep();
            }
         }
      }
      
      private function onGameEntityDisposition(param1:Object, param2:uint, param3:uint) : void
      {
         if(!this.disabled)
         {
            if(this._currentStepNumber == TutorialConstants.TUTORIAL_STEP_FIGHT_LOCATION)
            {
               this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_FIGHT_LOCATION__START_FIGHT);
            }
         }
      }
      
      private function onGameFightStart() : void
      {
         if(!this.disabled)
         {
            if(this._currentStepNumber < TutorialConstants.TUTORIAL_STEP_FIGHT_CAST_SPELL)
            {
               _watchedComponents["SpellsBanner"].disabled = true;
            }
            if(this._currentStepNumber == TutorialConstants.TUTORIAL_STEP_FIGHT_LOCATION)
            {
               this.validateCurrentStep();
            }
         }
      }
      
      private function onPlayerFightMove() : void
      {
         if(!this.disabled)
         {
            if(this._currentStepNumber == TutorialConstants.TUTORIAL_STEP_FIGHT_MOVE)
            {
               this.validateCurrentStep();
            }
         }
      }
      
      private function onFightSpellCast() : void
      {
         if(!this.disabled)
         {
            if(this._currentStepNumber == TutorialConstants.TUTORIAL_STEP_FIGHT_CAST_SPELL)
            {
               this.validateCurrentStep();
            }
         }
      }
      
      private function onGameFightTurnEnd(param1:Number) : void
      {
         if(!this.disabled)
         {
            if(this._currentStepNumber == TutorialConstants.TUTORIAL_STEP_FIGHT_SKIP_TURN)
            {
               if(param1 == Api.player.id())
               {
                  this.validateCurrentStep();
               }
            }
         }
      }
      
      private function onUiLoaded(param1:String) : void
      {
         var _loc2_:Object = null;
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_TALK:
                  if(param1 == "npcDialog")
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_TALK__SHOW_RESPONSE);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_SUCCESS_QUEST:
                  if(param1 == "npcDialog")
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__SHOW_RESPONSE);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_START_QUEST:
                  if(param1 == "npcDialog")
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__SHOW_RESPONSE);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ITEM:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     _loc2_ = Api.ui.getUi(param1);
                     if(_loc2_ && _loc2_.uiClass.categoryFilter != 0)
                     {
                        this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_TAB);
                     }
                     else
                     {
                        this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_EQUIPEMENT);
                     }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_CHANGE_MAP:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_CHANGE_MAP__SHOW_MAP_TRANSITION);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIND_BOSS:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_TRANSITION);
                  }
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ALL_ITEMS:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     _loc2_ = Api.ui.getUi(param1);
                     if(_loc2_)
                     {
                        _loc2_.uiClass.categoryFilter = 0;
                     }
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_EQUIPEMENT);
                  }
            }
         }
      }
      
      private function onUiUnloaded(param1:String) : void
      {
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_TALK:
                  if(param1 == "npcDialog")
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_TALK__SHOW_NPC);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_SUCCESS_QUEST:
                  if(param1 == "npcDialog")
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__SHOW_NPC);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_START_QUEST:
                  if(param1 == "npcDialog")
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__SHOW_NPC);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ITEM:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__OPEN_CHARACTER_SHEET);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ALL_ITEMS:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_CHARACTER_SHEET);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_CHANGE_MAP:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_CHANGE_MAP__SHOW_MAP_TRANSITION);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIND_BOSS:
                  if(param1 == UIEnum.STORAGE_UI)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_TRANSITION);
                  }
                  break;
               case TutorialConstants.TUTORIAL_INTRO_DIALOGUE:
                  if(param1 == UIEnum.CINEMATIC)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_INTRO_DIALOGUE);
                  }
            }
         }
      }
      
      public function onFightResultClosed() : void
      {
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_START_QUEST:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__SHOW_NPC);
                  break;
               case TutorialConstants.TUTORIAL_STEP_SUCCESS_QUEST:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__SHOW_NPC);
            }
         }
      }
      
      public function onMapComplementaryInformationsData(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_TALK:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_TALK__SHOW_NPC);
                  break;
               case TutorialConstants.TUTORIAL_STEP_STARTING_A_FIGHT:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_STARTING_A_FIGHT__SHOW_MONSTER);
                  break;
               case TutorialConstants.TUTORIAL_STEP_START_QUEST:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__CLOSE_FIGHT_RESULT);
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIND_BOSS:
                  if(param1.mapId == TutorialConstants.TUTORIAL_MAP_ID_THIRD_BEFORE_FIGHT)
                  {
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_BOSS);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_SUCCESS_QUEST:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__CLOSE_FIGHT_RESULT);
            }
         }
      }
      
      public function onMapChange(param1:uint) : void
      {
         if(this._playingDialogue)
         {
            Api.sound.stopStopablesoundById(this._playingDialogue);
         }
      }
      
      public function onDropStart(param1:Object) : void
      {
         if(!this.disabled && param1.data)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ITEM:
                  if(param1.data is ItemWrapper)
                  {
                     _dropItem = param1.data;
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_TARGET);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ALL_ITEMS:
                  if(param1.data is ItemWrapper)
                  {
                     _dropItem = param1.data;
                     this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_EQUIPEMENT_TARGET);
                  }
            }
         }
      }
      
      public function onDropEnd(param1:Object) : void
      {
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ITEM:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_EQUIPEMENT);
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ALL_ITEMS:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_EQUIPEMENT);
            }
         }
      }
      
      public function onCastSpellMode(param1:Object) : void
      {
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_FIGHT_CAST_SPELL:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_FIGHT_CAST_SPELL__SHOW_TARGET);
            }
         }
      }
      
      public function onCancelCastSpell(param1:Object) : void
      {
         if(!this.disabled)
         {
            switch(this._currentStepNumber)
            {
               case TutorialConstants.TUTORIAL_STEP_FIGHT_CAST_SPELL:
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_FIGHT_CAST_SPELL__SHOW_SPELL);
            }
         }
      }
      
      public function onStorageFilterUpdated(param1:Object, param2:int) : void
      {
         switch(this._currentStepNumber)
         {
            case TutorialConstants.TUTORIAL_STEP_EQUIP_ITEM:
               if(param2 == 0)
               {
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_EQUIPEMENT);
               }
               else
               {
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_TAB);
               }
               break;
            case TutorialConstants.TUTORIAL_STEP_EQUIP_ALL_ITEMS:
               if(param2 == 0)
               {
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_EQUIPEMENT);
               }
               else
               {
                  this.refreshStep(TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_TAB);
               }
         }
      }
      
      private function onSoundEnded(param1:String) : void
      {
         if(param1 == TutorialConstants.TUTORIAL_AUDIO_DIALOG_INTRO)
         {
            this.jumpToStep(TutorialConstants.TUTORIAL_STEP_ROLEPLAY_MOVE);
            this._introStepTimer.stop();
         }
         if(this._playingDialogue && this._playingDialogue == param1)
         {
            this._playingDialogue = null;
         }
         if(this._nextDialogue)
         {
            this.playDialog(this._nextDialogue[0],this._nextDialogue[1]);
         }
      }
      
      private function onNpcDialogRepliesVisible(param1:Boolean) : void
      {
         if(!this.disabled)
         {
            Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_LONG);
            Api.highlight.highlightUi("npcDialog","btn_rep0",7,1,5,true);
         }
      }
      
      public function preload() : void
      {
         this.loadWatchedComponents();
         this.loadFightWatchedComponents();
      }
      
      public function loadWatchedComponents() : void
      {
         var _loc1_:* = Api.ui.getUi("bannerMenu");
         var _loc2_:* = Api.ui.getUi("bannerActionBar");
         if(!_loc1_ || !_loc2_)
         {
            return;
         }
         this._bannerMenuUiClass = _loc1_.uiClass;
         this._actionBarUiClass = _loc2_.uiClass;
         _watchedComponents = new Dictionary();
         _watchedComponents["SpellsBanner"] = this._actionBarUiClass.gd_spellitemotes;
         _watchedComponents["InventoryButton"] = this._bannerMenuUiClass.ID_BTN_BAG;
         _watchedComponents["GrimoireButton"] = this._bannerMenuUiClass.ID_BTN_SPELL;
         _watchedComponents["QuestButton"] = this._bannerMenuUiClass.ID_BTN_BOOK;
         if(this._bannerMenuUiClass.btn_more_slot)
         {
            _watchedComponents["MoreBtnButton"] = this._bannerMenuUiClass.btn_more_slot;
         }
         _watchedComponents["MoreBtnCtr"] = this._bannerMenuUiClass.ctr_moreBtn;
         _watchedComponents["SpellTab"] = this._actionBarUiClass.btn_tabSpells;
         _watchedComponents["InventoryTab"] = this._actionBarUiClass.btn_tabItems;
         this.checkComponents(_watchedComponents);
      }
      
      public function loadFightWatchedComponents() : void
      {
         var _loc1_:* = Api.ui.getUi(UIEnum.BANNER);
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Object = _loc1_.uiClass;
         _fightWatchedComponents = new Dictionary();
         _fightWatchedComponents["SkipTurnButton"] = _loc2_.btn_readyOrSkip;
         _fightWatchedComponents["ReadyButton"] = _loc2_.btn_readyOrSkip;
         _fightWatchedComponents["LeaveButton"] = _loc2_.btn_leave;
         _fightWatchedComponents["HelpButton"] = _loc2_.btn_requestHelp;
         _fightWatchedComponents["AllowJoinFightButton"] = _loc2_.btn_lockFight;
         _fightWatchedComponents["AllowJoinFightPartyButton"] = _loc2_.btn_lockParty;
         _fightWatchedComponents["InvisibleModeButton"] = _loc2_.btn_tacticMode;
         _fightWatchedComponents["AllowSpectatorButton"] = _loc2_.btn_noSpectator;
         _fightWatchedComponents["ShowCellButton"] = _loc2_.btn_pointCell;
         this.checkComponents(_fightWatchedComponents);
      }
      
      public function unsetAllDisabled() : void
      {
         this.setWatchedElementsDisabled(false);
         this.setFightWatchedElementsDisabled(false);
         this._bannerMenuUiClass.checkAllBtnActivationState(false);
      }
      
      public function onFakeStepTimerEnd(param1:TimerEvent) : void
      {
         if(this._playingDialogue)
         {
            Api.sound.stopStopablesoundById(this._playingDialogue);
            this._playingDialogue = null;
         }
         this.jumpToStep(TutorialConstants.TUTORIAL_STEP_ROLEPLAY_MOVE);
         param1.target.removeEventListener(TimerEvent.TIMER,this.onFakeStepTimerEnd);
      }
      
      public function prepareStep(param1:uint, param2:uint = 0, param3:Boolean = false) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:uint = 0;
         var _loc14_:Object = null;
         this._currentStepNumber = param1;
         var _loc4_:Object = Api.ui.getUi(UIEnum.TUTORIAL_UI);
         this.moveTutorialUiDefault();
         Api.highlight.stop();
         if(!this.disabled)
         {
            switch(param1)
            {
               case TutorialConstants.TUTORIAL_INTRO_DIALOGUE:
                  this.setWatchedElementsDisabled(true);
                  _loc5_ = Api.ui.getUi(UIEnum.CINEMATIC);
                  if(param3 && !_loc5_)
                  {
                     this.doneIntroStep = true;
                     Api.system.setData(Api.player.getPlayedCharacterInfo().id + "doneIntroStep",true);
                     _loc4_.visible = false;
                     Api.roleplay.showNpcBubble(TutorialConstants.TUTORIAL_PNJ_ID,Api.ui.getText("ui.tutorial.dialog.jorisBubble"));
                     if(this._mustPlayAudioDialogue && Api.sound.soundsAreActivated())
                     {
                        this.playDialog(TutorialConstants.TUTORIAL_AUDIO_DIALOG_INTRO);
                        _loc7_ = 10000;
                     }
                     else
                     {
                        _loc7_ = 3000;
                     }
                     this._introStepTimer = new Timer(_loc7_);
                     this._introStepTimer.addEventListener(TimerEvent.TIMER,this.onFakeStepTimerEnd);
                     this._introStepTimer.start();
                     Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque2");
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_ROLEPLAY_MOVE:
                  _loc4_.visible = true;
                  this.setWatchedElementsDisabled(true);
                  if(param3)
                  {
                     this.playDialog("1499802");
                     Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                     Api.highlight.highlightAbsolute(new Rectangle(TutorialConstants.ROLEPLAY_MOVE_DESTINATION_X,TutorialConstants.ROLEPLAY_MOVE_DESTINATION_Y),0,0,0,true);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_TALK:
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_TALK__LOADING_MAP:
                        Api.modMenu.getMenuMaker("npc").maker.disabled = false;
                     case TutorialConstants.TUTORIAL_SUB_STEP_TALK__SHOW_NPC:
                        if(param3)
                        {
                           this.playDialog("1499803",true);
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque1");
                           Api.highlight.highlightNpc(TutorialConstants.TUTORIAL_PNJ_ID,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_TALK__SHOW_RESPONSE:
                        if(param3)
                        {
                           this.playDialog("1499804");
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ITEM:
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__OPEN_CHARACTER_SHEET:
                        this._bannerMenuUiClass.setDisabledBtn(_watchedComponents["InventoryButton"],false);
                        this.setShortcutDisabled("openInventory",false);
                        _loc8_ = this._bannerMenuUiClass.getSlotByBtnId(_watchedComponents["InventoryButton"]).getStageRect();
                        if(param3)
                        {
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque6");
                           this.playDialog("1499808");
                           Api.highlight.highlightAbsolute(new Rectangle(_loc8_.x,_loc8_.y,_loc8_.width,_loc8_.height),1,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_TAB:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           Api.highlight.highlightUi(UIEnum.STORAGE_UI,"btnEquipable",0,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_EQUIPEMENT:
                        this.moveTutorialUiLeft();
                        _loc9_ = Api.ui.getUi(UIEnum.STORAGE_UI);
                        if(param3)
                        {
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                           Api.highlight.highlightUi(UIEnum.STORAGE_UI,"grid",0,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ITEM__SHOW_TARGET:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           Api.highlight.highlightUi(UIEnum.STORAGE_UI,"slot_2",5,0,5,true);
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_CHANGE_MAP:
                  if(!Api.ui.getUi(UIEnum.STORAGE_UI))
                  {
                     param2 = TutorialConstants.TUTORIAL_SUB_STEP_CHANGE_MAP__SHOW_MAP_TRANSITION;
                  }
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_CHANGE_MAP__CLOSE_CHARACTER_SHEET:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           Api.highlight.highlightUi(UIEnum.STORAGE_UI,"btn_close",7,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_CHANGE_MAP__SHOW_MAP_TRANSITION:
                        if(param3)
                        {
                           this.playDialog("1499810");
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque8");
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_LONG);
                           Api.highlight.highlightMapTransition(TutorialConstants.TUTORIAL_MAP_ID_FIRST,TutorialConstants.CHANGE_MAP_TRANSITION_ORIENTATION,TutorialConstants.CHANGE_MAP_TRANSITION_POSITION,false,0,true);
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_STARTING_A_FIGHT:
                  this.setFightWatchedElementsDisabled(true);
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_STARTING_A_FIGHT__LOADING_MAP:
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_STARTING_A_FIGHT__SHOW_MONSTER:
                        if(param3)
                        {
                           this.playDialog("1499812");
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque4");
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                           Api.highlight.highlightMonster(TutorialConstants.TUTORIAL_MONSTER_ID_POUTCH,true);
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIGHT_LOCATION:
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIGHT_LOCATION__SHOW_CELL:
                        if(param3)
                        {
                           this.playDialog("1499813",true);
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_LONG);
                           Api.highlight.highlightCell(TutorialConstants.FIGHT_LOCATION_TARGET_CELLS,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIGHT_LOCATION__START_FIGHT:
                        this.setShortcutDisabled("skipTurn",false);
                        _fightWatchedComponents["ReadyButton"].disabled = false;
                        Api.modMenu.getMenuMaker("player").maker.disabled = false;
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIGHT_MOVE:
                  _fightWatchedComponents["ReadyButton"].disabled = false;
                  if(Api.player.isInFight() && param3)
                  {
                     _loc10_ = -1;
                     _loc11_ = Api.fight.getFighterInformations(Api.player.id());
                     if(_loc11_)
                     {
                        this.playDialog("1499814",true);
                        _loc10_ = TutorialConstants.FIGHT_MOVE_TARGET_CELLS[_loc11_.currentCell];
                        Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                        Api.highlight.highlightCell([_loc10_],true);
                     }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIGHT_CAST_SPELL:
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIGHT_CAST_SPELL__SHOW_SPELL:
                        if(Api.player.isInFight() && param3)
                        {
                           this.playDialog("1499815",true);
                           Api.highlight.highlightUi("bannerActionBar","gd_spellitemotes|item1");
                        }
                        _fightWatchedComponents["SkipTurnButton"].disabled = false;
                        this.setShortcutDisabled("skipTurn",false);
                        _watchedComponents["SpellsBanner"].disabled = false;
                        this.setShortcutDisabled("cac",false);
                        this.setShortcutDisabled("s1",false);
                        this.setShortcutDisabled("s2",false);
                        this.setShortcutDisabled("s3",false);
                        this.setShortcutDisabled("s4",false);
                        this.setShortcutDisabled("s5",false);
                        this.setShortcutDisabled("s6",false);
                        this.setShortcutDisabled("s7",false);
                        this.setShortcutDisabled("s8",false);
                        this.setShortcutDisabled("s9",false);
                        this.setShortcutDisabled("s10",false);
                        this.setShortcutDisabled("s11",false);
                        this.setShortcutDisabled("s12",false);
                        this.setShortcutDisabled("s13",false);
                        this.setShortcutDisabled("s14",false);
                        this.setShortcutDisabled("s15",false);
                        this.setShortcutDisabled("s16",false);
                        this.setShortcutDisabled("s17",false);
                        this.setShortcutDisabled("s18",false);
                        this.setShortcutDisabled("s19",false);
                        this.setShortcutDisabled("s20",false);
                        this.setShortcutDisabled("pageItem1",false);
                        this.setShortcutDisabled("pageItem2",false);
                        this.setShortcutDisabled("pageItem3",false);
                        this.setShortcutDisabled("pageItem4",false);
                        this.setShortcutDisabled("pageItem5",false);
                        this.setShortcutDisabled("pageItemDown",false);
                        this.setShortcutDisabled("pageItemUp",false);
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIGHT_CAST_SPELL__SHOW_TARGET:
                        if(param3)
                        {
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                           Api.highlight.highlightMonster(TutorialConstants.TUTORIAL_MONSTER_ID_POUTCH,true);
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIGHT_SKIP_TURN:
                  if(Api.player.isInFight() && param3)
                  {
                     this.playDialog("1499817");
                     Api.highlight.highlightUi(UIEnum.BANNER,"btn_readyOrSkip",0,0,5,true);
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIGHT_WIN:
                  if(param3)
                  {
                     this.playDialog("1499818");
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_START_QUEST:
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__LOADING_MAP:
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__CLOSE_FIGHT_RESULT:
                        if(param3)
                        {
                           Api.highlight.highlightUi(UIEnum.FIGHT_RESULT,"btn_close2",7,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__SHOW_NPC:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque5");
                           this.playDialog("1499819",true);
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                           Api.highlight.highlightNpc(TutorialConstants.TUTORIAL_PNJ_ID,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_START_QUEST__SHOW_RESPONSE:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           this.playDialog("1499822");
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_EQUIP_ALL_ITEMS:
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_CHARACTER_SHEET:
                        this._bannerMenuUiClass.setDisabledBtn(_watchedComponents["GrimoireButton"],false);
                        this._bannerMenuUiClass.setDisabledBtn(_watchedComponents["QuestButton"],false);
                        this.setShortcutDisabled("openBook",false);
                        this.setShortcutDisabled("openBookSpell",false);
                        this.setShortcutDisabled("openBookQuest",false);
                        _loc12_ = this._bannerMenuUiClass.getSlotByBtnId(_watchedComponents["InventoryButton"]).getStageRect();
                        if(param3)
                        {
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimStatique");
                           this.playDialog("1499823");
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                           Api.highlight.highlightAbsolute(new Rectangle(_loc12_.x,_loc12_.y,_loc12_.width,_loc12_.height),1,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_TAB:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           Api.highlight.highlightUi(UIEnum.STORAGE_UI,"btnEquipable",0,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_EQUIPEMENT:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                           Api.highlight.highlightUi(UIEnum.STORAGE_UI,"grid",0,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_EQUIP_ALL_ITEMS__SHOW_EQUIPEMENT_TARGET:
                        this.moveTutorialUiLeft();
                        if(param3 && _dropItem)
                        {
                           _loc13_ = this.getItemSuperType(_dropItem);
                           _loc14_ = Api.storage.itemSuperTypeToServerPosition(_loc13_);
                           if(_loc14_[0] != null)
                           {
                              Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_SHORT);
                              Api.highlight.highlightUi(UIEnum.STORAGE_UI,"slot_" + _loc14_[0],5,0,5,true);
                           }
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_FIND_BOSS:
                  _loc6_ = Api.player.currentMap();
                  if(param2 == TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__CLOSE_CHARACTER_SHEET && !Api.ui.getUi(UIEnum.STORAGE_UI))
                  {
                     param2 = TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_TRANSITION;
                  }
                  if(param2 == TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_TRANSITION && _loc6_.mapId == TutorialConstants.TUTORIAL_MAP_ID_THIRD_BEFORE_FIGHT)
                  {
                     param2 = TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_BOSS;
                  }
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__CLOSE_CHARACTER_SHEET:
                        this.moveTutorialUiLeft();
                        if(param3)
                        {
                           Api.highlight.highlightUi(UIEnum.STORAGE_UI,"btn_close",7,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_TRANSITION:
                        if(_loc6_.mapId == TutorialConstants.TUTORIAL_MAP_ID_SECOND_AFTER_FIGHT)
                        {
                           if(param3)
                           {
                              this.playDialog("1499824");
                              Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque8");
                              Api.highlight.setDisplayDelay(DELAY_BEFORE_HIGHLIGHT_LONG);
                              Api.highlight.highlightMapTransition(TutorialConstants.TUTORIAL_MAP_ID_SECOND_AFTER_FIGHT,TutorialConstants.FIND_BOSS_TRANSITION_ORIENTATION,TutorialConstants.FIND_BOSS_TRANSITION_POSITION,false,0,true);
                           }
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__LOADING_MAP:
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_FIND_BOSS__SHOW_BOSS:
                        if(_loc6_.mapId == TutorialConstants.TUTORIAL_MAP_ID_THIRD_BEFORE_FIGHT)
                        {
                           if(param3)
                           {
                              Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque7");
                              this.playDialog("1499825");
                              Api.highlight.highlightMonster(TutorialConstants.TUTORIAL_MONSTER_ID_BOSS,true);
                           }
                        }
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_KILL_BOSS:
                  if(param3)
                  {
                     this.playDialog("1499828");
                     Api.highlight.forceArrowPosition("banner","tx_timeFrame",new Point(640,880));
                  }
                  break;
               case TutorialConstants.TUTORIAL_STEP_SUCCESS_QUEST:
                  switch(param2)
                  {
                     case TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__LOADING_MAP:
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__CLOSE_FIGHT_RESULT:
                        if(param3)
                        {
                           Api.highlight.highlightUi(UIEnum.FIGHT_RESULT,"btn_close2",7,0,5,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__SHOW_NPC:
                        if(param3)
                        {
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque5");
                           this.playDialog("1499826",true);
                           Api.highlight.highlightNpc(TutorialConstants.TUTORIAL_PNJ_ID,true);
                        }
                        break;
                     case TutorialConstants.TUTORIAL_SUB_STEP_SUCCESS_QUEST__SHOW_RESPONSE:
                        if(param3)
                        {
                           Api.roleplay.playEntityAnimation(TutorialConstants.TUTORIAL_PNJ_ID,"AnimAttaque7");
                           this.playDialog("1499827");
                        }
                  }
            }
         }
      }
      
      public function redoSteps() : void
      {
         var _loc1_:uint = 0;
         if(this._currentStepNumber != -1)
         {
            _loc1_ = this._currentStepNumber;
            this._currentStepNumber = 0;
            this.jumpToStep(_loc1_);
         }
      }
      
      public function jumpToStep(param1:uint) : void
      {
         if(this._currentStepNumber == -1)
         {
            this._currentStepNumber = 0;
         }
         var _loc2_:uint = this._currentStepNumber;
         while(_loc2_ <= param1)
         {
            this.prepareStep(_loc2_,0,_loc2_ == param1);
            _loc2_++;
         }
      }
      
      private function moveTutorialUiDefault() : void
      {
         var _loc1_:Object = Api.ui.getUi(UIEnum.TUTORIAL_UI);
         if(_loc1_)
         {
            _loc1_.uiClass.moveDefault();
         }
      }
      
      private function moveTutorialUiLeft() : void
      {
         var _loc1_:Object = Api.ui.getUi(UIEnum.TUTORIAL_UI);
         if(_loc1_)
         {
            _loc1_.uiClass.moveLeft();
         }
      }
      
      private function validateCurrentStep() : void
      {
         var _loc1_:uint = 0;
         if(this._currentStepNumber != -1)
         {
            for each(_loc1_ in this._quest.steps[this._currentStepNumber - 1].objectiveIds)
            {
               Api.system.sendAction(new QuestObjectiveValidation(this._quest.id,_loc1_));
            }
         }
      }
      
      private function refreshStep(param1:uint) : void
      {
         if(this._currentStepNumber != -1)
         {
            this.prepareStep(this._currentStepNumber,param1,true);
         }
      }
      
      private function setComponentsDisabled(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_ && _loc3_.hasOwnProperty("disabled"))
            {
               _loc3_.disabled = param2;
            }
         }
         if(param1 === _watchedComponents)
         {
            this._bannerMenuUiClass.setDisabledBtns(param2);
         }
      }
      
      private function checkComponents(param1:Object) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            if(param1[_loc2_] == null)
            {
               throw new Error("Unable to find component : " + _loc2_);
            }
         }
      }
      
      private function setWatchedElementsDisabled(param1:Boolean) : void
      {
         Api.modMenu.getMenuMaker("world").maker.disabled = param1;
         Api.modMenu.getMenuMaker("player").maker.disabled = param1;
         Api.modMenu.getMenuMaker("npc").maker.disabled = param1;
         Api.modMenu.getMenuMaker("item").maker.disabled = param1;
         this.setComponentsDisabled(_watchedComponents,param1);
         this.setShortcutsDisabled(param1);
      }
      
      private function setFightWatchedElementsDisabled(param1:Boolean) : void
      {
         this.setComponentsDisabled(_fightWatchedComponents,param1);
      }
      
      private function setShortcutsDisabled(param1:Boolean) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in _disabledShortcuts)
         {
            this.setShortcutDisabled(_loc2_,param1);
         }
      }
      
      private function setShortcutDisabled(param1:String, param2:Boolean) : void
      {
         var _loc3_:Bind = Api.binds.getShortcutBind(param1,true);
         if(_loc3_)
         {
            Api.binds.setBindDisabled(_loc3_,param2);
            _disabledShortcuts[param1] = param2;
         }
      }
      
      private function getItemSuperType(param1:Object) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:ItemType = null;
         if(param1.isLivingObject || param1.isWrapperObject)
         {
            _loc2_ = 0;
            if(param1.isLivingObject)
            {
               _loc2_ = param1.livingObjectCategory;
            }
            else
            {
               _loc2_ = param1.wrapperObjectCategory;
            }
            _loc3_ = Api.data.getItemType(_loc2_);
            if(_loc3_)
            {
               return _loc3_.superTypeId;
            }
            return 0;
         }
         if(param1 is ItemWrapper)
         {
            return (param1 as ItemWrapper).type.superTypeId;
         }
         if(param1 is ShortcutWrapper)
         {
            if((param1 as ShortcutWrapper).type == 0)
            {
               return (param1 as ShortcutWrapper).realItem.type.superTypeId;
            }
         }
         return 0;
      }
      
      private function playDialog(param1:String, param2:Boolean = false) : void
      {
         if(!this._mustPlayAudioDialogue)
         {
            return;
         }
         if(param2 && this._playedDialogue.indexOf(param1) != -1)
         {
            return;
         }
         if(this._playingDialogue)
         {
            Api.sound.stopStopablesoundById(this._playingDialogue);
            if(!this._nextDialogue && this._playingDialogue != param1)
            {
               this._nextDialogue = [param1,param2];
            }
            return;
         }
         this._playingDialogue = param1;
         if(this._nextDialogue && this._nextDialogue[0] == param1)
         {
            this._nextDialogue = null;
         }
         this._playedDialogue.push(param1);
         Api.sound.playStopablesoundById(param1);
      }
      
      public function get playingDialogue() : String
      {
         return this._playingDialogue;
      }
   }
}
