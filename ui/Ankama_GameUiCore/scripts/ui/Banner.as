package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.StateContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDate;
   import com.ankamagames.dofus.datacenter.items.IncarnationLevel;
   import com.ankamagames.dofus.internalDatacenter.fight.FighterInformations;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.network.types.game.character.CharacterBasicMinimalInformations;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SecurityApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.CaptureScreen;
   import d2actions.CaptureScreenWithoutUI;
   import d2actions.ChatTextOutput;
   import d2actions.GameContextQuit;
   import d2actions.GameFightReady;
   import d2actions.GameFightTurnFinish;
   import d2actions.HighlightInteractiveElements;
   import d2actions.QuestListRequest;
   import d2actions.ShowAllNames;
   import d2actions.ShowEntitiesTooltips;
   import d2actions.ShowMountsInFight;
   import d2actions.ToggleDematerialization;
   import d2actions.ToggleHelpWanted;
   import d2actions.ToggleLockFight;
   import d2actions.ToggleLockParty;
   import d2actions.TogglePointCell;
   import d2actions.ToggleWitnessForbidden;
   import d2enums.BuildTypeEnum;
   import d2enums.CharacterInventoryPositionEnum;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.FightEventEnum;
   import d2enums.FightTypeEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ArenaFighterLeave;
   import d2hooks.CharacterStatsList;
   import d2hooks.ChatFocus;
   import d2hooks.DematerializationChanged;
   import d2hooks.EquipmentObjectMove;
   import d2hooks.FightEvent;
   import d2hooks.GameFightTurnEnd;
   import d2hooks.GameFightTurnStart;
   import d2hooks.GuildInformationsGeneral;
   import d2hooks.InventoryWeight;
   import d2hooks.JobsExpUpdated;
   import d2hooks.MountSet;
   import d2hooks.MountUnSet;
   import d2hooks.NotReadyToFight;
   import d2hooks.ObjectModified;
   import d2hooks.OpenFeed;
   import d2hooks.OptionHelpWanted;
   import d2hooks.OptionLockFight;
   import d2hooks.OptionLockParty;
   import d2hooks.OptionWitnessForbidden;
   import d2hooks.PartyJoin;
   import d2hooks.PartyLeave;
   import d2hooks.ReadyToFight;
   import d2hooks.RemindTurn;
   import d2hooks.ShowCell;
   import d2hooks.ShowTacticMode;
   import d2hooks.SlaveStatsList;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import ui.enums.ContextEnum;
   
   public class Banner extends ContextAwareUi
   {
      
      private static var LOCKET_ARTWORK:uint = 0;
      
      private static var LOCKET_SPRITE:uint = 1;
      
      private static var LOCKET_CLOCK:uint = 3;
      
      private static var HP_1_LINE_DISPLAY:uint = 0;
      
      private static var HP_2_LINES_DISPLAY:uint = 1;
      
      private static var HP_PERCENT_DISPLAY:uint = 2;
      
      private static var XP_GAUGE:uint = 0;
      
      private static var GUILD_GAUGE:uint = 1;
      
      private static var MOUNT_GAUGE:uint = 2;
      
      private static var INCARNATION_GAUGE:uint = 3;
      
      private static var HONOUR_GAUGE:uint = 4;
      
      private static var POD_GAUGE:uint = 5;
      
      private static var ENERGY_GAUGE:uint = 6;
      
      private static var JOB_GAUGE:uint = 7;
      
      private static const PROGRESS_BAR_COLORS:Array = [3863295,8651007,7139557,8764671,16749568,6340149,13383470,16541681];
      
      private static const NB_GAUGE:uint = 7;
       
      
      public var bindsApi:BindsApi;
      
      public var uiApi:UiApi;
      
      public var timeApi:TimeApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var inventoryApi:InventoryApi;
      
      public var socialApi:SocialApi;
      
      public var fightApi:FightApi;
      
      public var jobsApi:JobsApi;
      
      public var menuApi:ContextMenuApi;
      
      public var securityApi:SecurityApi;
      
      public var partyApi:PartyApi;
      
      public var rpApi:RoleplayApi;
      
      public var utilApi:UtilApi;
      
      public var highlightApi:HighlightApi;
      
      public var soundApi:SoundApi;
      
      public var tooltipApi:TooltipApi;
      
      public var configApi:ConfigApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Cartography")]
      public var modCartography:Object;
      
      private var _turnDuration:uint;
      
      private var _turnElapsedTime:uint;
      
      private var _clockStart:uint;
      
      private var _lifepointMode:uint = 0;
      
      private var _currentPdv:uint;
      
      private var _totalPdv:uint;
      
      private var _percentPdv:uint;
      
      private var _roundPercent:uint;
      
      private var _roundLevel:uint;
      
      private var _roundRemainingValue:Number;
      
      private var _roundGaugeType:uint = 0;
      
      private var _bIsReady:Boolean = false;
      
      private var _bIsSpectator:Boolean = false;
      
      private var _bCellPointed:Boolean = false;
      
      private var _nPa:int;
      
      private var _nPm:int;
      
      private var _currentShieldPoints:int;
      
      private var _lookingForMyGuildPlz:Boolean = false;
      
      private var _jobsByIndex:Array;
      
      private var _spectatorCloseLastRequest:uint = 0;
      
      private var _spectatorCloseLastRequestTime:uint = 1500;
      
      private var _arenaFightLeaver:CharacterBasicMinimalInformations;
      
      private var _btn_help_originalX:Number;
      
      private var _btn_help_originalY:Number;
      
      private var _currentTurnEntityId:Number;
      
      private var _timeFxInitialX:int;
      
      private var _shortcutColor:String;
      
      private var _defaultTimeColor:uint;
      
      private var _hurryTimeColor:uint;
      
      private var _readyTxt:String;
      
      private var _skipTurnTxt:String;
      
      public var mainCtr:GraphicContainer;
      
      public var subUiCtr:GraphicContainer;
      
      public var spectatorUiCtr:GraphicContainer;
      
      public var lbl_pa:Label;
      
      public var lbl_pm:Label;
      
      public var lbl_pdv:Label;
      
      public var lbl_pdvTop:Label;
      
      public var lbl_pdvBottom:Label;
      
      public var tx_hp_separator:TextureBitmap;
      
      public var tx_background:TextureBitmap;
      
      public var tx_tabsBg:TextureBitmap;
      
      public var btn_leave:ButtonContainer;
      
      public var btn_lockFight:ButtonContainer;
      
      public var btn_creatureMode:ButtonContainer;
      
      public var btn_lockParty:ButtonContainer;
      
      public var btn_pointCell:ButtonContainer;
      
      public var btn_requestHelp:ButtonContainer;
      
      public var btn_noSpectator:ButtonContainer;
      
      public var btn_tacticMode:ButtonContainer;
      
      public var fightGroup:StateContainer;
      
      public var tx_apBg:Texture;
      
      public var tx_mpBg:Texture;
      
      public var tx_hpBg:Texture;
      
      public var tx_hp:Texture;
      
      public var tx_shield:Texture;
      
      public var mask_hp:GraphicContainer;
      
      public var tx_timeFx:Texture;
      
      public var tx_decoration:Texture;
      
      public var pb_xp:ProgressBar;
      
      public var pb_time:ProgressBar;
      
      public var pb_time2:Texture;
      
      public var fightCtr:GraphicContainer;
      
      public var btn_readyOrSkip:ButtonContainer;
      
      public var btn_lbl_btn_readyOrSkip:Label;
      
      public var actionBarCtr:GraphicContainer;
      
      private var _tacticModeActivated:Boolean = false;
      
      private var _pokemonModeActivated:Boolean = false;
      
      private var _paTimer:Timer;
      
      private var _pmTimer:Timer;
      
      public function Banner()
      {
         this._jobsByIndex = new Array();
         this._paTimer = new Timer(200);
         this._pmTimer = new Timer(200);
         super();
      }
      
      override public function main(param1:Array) : void
      {
         var _loc4_:GuildWrapper = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         super.main(param1);
         this._defaultTimeColor = sysApi.getConfigEntry("colors.progressbar.yellow");
         this._hurryTimeColor = sysApi.getConfigEntry("colors.progressbar.red");
         this.pb_time.barColor = this._defaultTimeColor;
         this.mask_hp.width = this.tx_hpBg.width;
         this.tx_hp.mask = this.mask_hp;
         this._timeFxInitialX = this.tx_timeFx.x;
         sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         sysApi.addHook(SlaveStatsList,this.onSlaveStatsList);
         sysApi.addHook(d2hooks.ShowTacticMode,this.onShowTacticMode);
         sysApi.addHook(DematerializationChanged,this.onDematerializationChanged);
         sysApi.addHook(FightEvent,this.onFightEvent);
         sysApi.addHook(ArenaFighterLeave,this.onArenaFighterLeave);
         sysApi.addHook(GameFightTurnEnd,this.onGameFightTurnEnd);
         sysApi.addHook(GameFightTurnStart,this.onGameFightTurnStart);
         sysApi.addHook(ReadyToFight,this.onReadyToFight);
         sysApi.addHook(NotReadyToFight,this.onNotReadyToFight);
         sysApi.addHook(InventoryWeight,this.onInventoryWeight);
         sysApi.addHook(EquipmentObjectMove,this.onEquipmentObjectMove);
         sysApi.addHook(ObjectModified,this.onObjectModified);
         sysApi.addHook(ShowCell,this.onShowCell);
         sysApi.addHook(OptionLockFight,this.onOptionLockFight);
         sysApi.addHook(OptionLockParty,this.onOptionLockParty);
         sysApi.addHook(OptionHelpWanted,this.onOptionHelpWanted);
         sysApi.addHook(OptionWitnessForbidden,this.onOptionWitnessForbidden);
         sysApi.addHook(RemindTurn,this.onRemindTurn);
         sysApi.addHook(MountSet,this.onMountSet);
         sysApi.addHook(MountUnSet,this.onMountUnSet);
         sysApi.addHook(JobsExpUpdated,this.onJobsExpUpdated);
         sysApi.addHook(GuildInformationsGeneral,this.onGuildInformationsGeneral);
         sysApi.addHook(PartyLeave,this.onPartyLeave);
         sysApi.addHook(PartyJoin,this.onPartyJoin);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("skipTurn",this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHOW_ALL_NAMES,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHOW_ENTITIES_TOOLTIPS,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHOW_MOUNTS_IN_FIGHT,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHOW_TACTIC_MODE,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHOW_CELL,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_DEMATERIALIZATION,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.HIGHLIGHT_INTERACTIVE_ELEMENTS,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CAPTURE_SCREEN,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CAPTURE_SCREEN_WITHOUT_UI,this.onShortcut);
         this.uiApi.addComponentHook(this.tx_hpBg,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_hpBg,"onRollOver");
         this.uiApi.addComponentHook(this.tx_hpBg,"onRollOut");
         this.uiApi.addComponentHook(this.tx_apBg,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_apBg,"onRollOver");
         this.uiApi.addComponentHook(this.tx_apBg,"onRollOut");
         this.uiApi.addComponentHook(this.tx_mpBg,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_mpBg,"onRollOver");
         this.uiApi.addComponentHook(this.tx_mpBg,"onRollOut");
         this.uiApi.addComponentHook(this.pb_xp,"onRollOver");
         this.uiApi.addComponentHook(this.pb_xp,"onRollOut");
         this.uiApi.addComponentHook(this.pb_xp,"onRightClick");
         this.uiApi.addComponentHook(this.pb_time,"onRightClick");
         this.uiApi.addComponentHook(this.pb_time2,"onRightClick");
         this.uiApi.addComponentHook(this.btn_readyOrSkip,"onRightClick");
         this.uiApi.addComponentHook(this.btn_tacticMode,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tacticMode,"onRollOut");
         this.uiApi.addComponentHook(this.btn_creatureMode,"onRollOver");
         this.uiApi.addComponentHook(this.btn_creatureMode,"onRollOut");
         this.uiApi.addComponentHook(this.btn_noSpectator,"onRollOver");
         this.uiApi.addComponentHook(this.btn_noSpectator,"onRollOut");
         this.uiApi.addComponentHook(this.btn_pointCell,"onRollOver");
         this.uiApi.addComponentHook(this.btn_pointCell,"onRollOut");
         this.uiApi.addComponentHook(this.btn_leave,"onRollOver");
         this.uiApi.addComponentHook(this.btn_leave,"onRollOut");
         this.uiApi.addComponentHook(this.btn_lockFight,"onRollOver");
         this.uiApi.addComponentHook(this.btn_lockFight,"onRollOut");
         this.uiApi.addComponentHook(this.btn_requestHelp,"onRollOver");
         this.uiApi.addComponentHook(this.btn_requestHelp,"onRollOut");
         this.uiApi.addComponentHook(this.btn_lockParty,"onRollOver");
         this.uiApi.addComponentHook(this.btn_lockParty,"onRollOut");
         this._readyTxt = this.uiApi.getText("ui.banner.ready");
         this._skipTurnTxt = this.uiApi.getText("ui.shortcuts.skipTurn");
         this.lbl_pdvBottom.visible = false;
         this.lbl_pdvTop.visible = false;
         var _loc2_:Object = sysApi.getData("lifepointMode");
         if(_loc2_)
         {
            this._lifepointMode = _loc2_.mode;
            this.changeLifepointDisplay(this._lifepointMode);
         }
         var _loc3_:int = sysApi.getData("roundGaugeMode_" + this.playerApi.id());
         this._roundGaugeType = _loc3_;
         if(this._roundGaugeType == GUILD_GAUGE)
         {
            _loc4_ = this.socialApi.getGuild();
            if(_loc4_)
            {
               _loc5_ = _loc4_.experience;
               _loc6_ = _loc4_.expLevelFloor;
               _loc7_ = _loc4_.expNextLevelFloor;
               this.setXp(_loc5_,_loc6_,_loc7_,_loc4_.level);
            }
            else
            {
               this._lookingForMyGuildPlz = true;
               this._roundGaugeType = XP_GAUGE;
            }
         }
         else
         {
            this.onChangeXpGauge(this._roundGaugeType);
         }
         sysApi.sendAction(new QuestListRequest());
         this.configApi.setConfigProperty("dofus","creaturesFightMode",false);
         this._btn_help_originalX = this.btn_requestHelp.x;
         this._btn_help_originalY = this.btn_requestHelp.y;
         this.uiApi.loadUiInside("actionBar",this.actionBarCtr,"bannerActionBar");
         changeContext(ContextEnum.ROLEPLAY);
      }
      
      public function setPdv(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = 0;
         this._percentPdv = int(param1 / param2 * 100);
         if(param1 != this._currentPdv)
         {
            _loc3_ = this._percentPdv;
            if(_loc3_ > 100)
            {
               _loc3_ = 100;
            }
            if(this._currentShieldPoints)
            {
               _loc3_ = _loc3_ + 100;
            }
            this.mask_hp.finalized = false;
            this.mask_hp.height = this.tx_hpBg.height * this._percentPdv / 100;
            this.mask_hp.y = this.tx_hpBg.y + (this.tx_hpBg.height - this.mask_hp.height);
            this.mask_hp.finalize();
         }
         this._currentPdv = param1;
         this._totalPdv = param2;
         switch(this._lifepointMode)
         {
            case HP_1_LINE_DISPLAY:
               if(this._currentShieldPoints)
               {
                  this.lbl_pdv.visible = false;
                  this.lbl_pdvBottom.visible = true;
                  this.lbl_pdvTop.visible = true;
                  this.lbl_pdvTop.text = this._currentPdv.toString();
                  this.lbl_pdvBottom.cssClass = "shield";
                  this.lbl_pdvBottom.text = this._currentShieldPoints.toString();
               }
               else
               {
                  this.lbl_pdv.visible = true;
                  this.lbl_pdvBottom.visible = false;
                  this.lbl_pdvTop.visible = false;
                  this.lbl_pdv.text = this._currentPdv.toString();
               }
               this.tx_hp_separator.visible = false;
               break;
            case HP_2_LINES_DISPLAY:
               this.lbl_pdvTop.text = this._currentPdv.toString();
               this.lbl_pdvBottom.cssClass = "hp";
               this.lbl_pdvBottom.text = this._totalPdv.toString();
               this.tx_hp_separator.finalized = false;
               this.tx_hp_separator.width = Math.max(this.lbl_pdvTop.textWidth,this.lbl_pdvBottom.textWidth);
               this.tx_hp_separator.x = this.lbl_pdvBottom.x + (this.lbl_pdvBottom.width - this.tx_hp_separator.width) / 2 + 2;
               this.tx_hp_separator.finalize();
               this.tx_hp_separator.visible = true;
               break;
            case HP_PERCENT_DISPLAY:
               this.lbl_pdv.text = this._percentPdv.toString() + "%";
               this.lbl_pdv.visible = true;
               this.lbl_pdvBottom.visible = false;
               this.lbl_pdvTop.visible = false;
               this.tx_hp_separator.visible = false;
         }
      }
      
      public function setShield(param1:uint) : void
      {
         this._currentShieldPoints = param1;
         if(this._currentShieldPoints > 0)
         {
            this.tx_shield.visible = true;
            if(this._lifepointMode == 0)
            {
               if(this.lbl_pdv.visible)
               {
                  this.lbl_pdv.visible = false;
                  this.lbl_pdvBottom.visible = true;
                  this.lbl_pdvTop.visible = true;
                  this.lbl_pdvTop.text = this._currentPdv.toString();
               }
               this.lbl_pdvBottom.cssClass = "shield";
               this.lbl_pdvBottom.text = this._currentShieldPoints.toString();
            }
         }
         else
         {
            this.tx_shield.visible = false;
            if(this._lifepointMode == 0 && !this.lbl_pdv.visible)
            {
               this.lbl_pdv.visible = true;
               this.lbl_pdvBottom.visible = false;
               this.lbl_pdvTop.visible = false;
               this.lbl_pdv.text = this._currentPdv.toString();
            }
         }
      }
      
      public function setPA(param1:int) : void
      {
         if(this.lbl_pa.text == "")
         {
            this.lbl_pa.text = String(this._nPa);
         }
         if(this._nPa != param1)
         {
            this._nPa = param1;
            this.lbl_pa.text = String(param1);
         }
      }
      
      protected function onPaTimer(param1:TimerEvent) : void
      {
         if(!this.lbl_pa)
         {
            this._paTimer.removeEventListener(TimerEvent.TIMER,this.onPaTimer);
            return;
         }
         var _loc2_:int = parseInt(this.lbl_pa.text);
         if(this._nPa == _loc2_)
         {
            this._paTimer.removeEventListener(TimerEvent.TIMER,this.onPaTimer);
            return;
         }
         var _loc3_:int = _loc2_ > this._nPa?-1:1;
         this.lbl_pa.text = String(_loc2_ + _loc3_);
      }
      
      public function setPM(param1:int) : void
      {
         if(this.lbl_pm.text == "")
         {
            this.lbl_pm.text = String(this._nPm);
         }
         if(this._nPm != param1)
         {
            this._nPm = param1;
            this.lbl_pm.text = String(param1);
         }
      }
      
      protected function onPmTimer(param1:TimerEvent) : void
      {
         if(!this.lbl_pa)
         {
            this._pmTimer.removeEventListener(TimerEvent.TIMER,this.onPmTimer);
            return;
         }
         var _loc2_:int = parseInt(this.lbl_pm.text);
         if(this._nPm == _loc2_)
         {
            this._pmTimer.removeEventListener(TimerEvent.TIMER,this.onPmTimer);
            return;
         }
         var _loc3_:int = _loc2_ > this._nPm?-1:1;
         this.lbl_pm.text = String(_loc2_ + _loc3_);
      }
      
      public function setTimeFromPercent(param1:Number) : void
      {
         var _loc2_:uint = Math.ceil(param1);
         _loc2_ = Math.max(Math.min(param1,100),1);
         var _loc3_:Number = _loc2_ / 100;
         this.pb_time.value = _loc3_;
         this.tx_timeFx.x = this._timeFxInitialX + this.pb_time.width * _loc3_;
         if(_loc3_ < 0.8)
         {
            this.pb_time.barColor = this._defaultTimeColor;
         }
         else
         {
            this.pb_time.barColor = this._hurryTimeColor;
         }
         if(this.pb_time2.visible)
         {
            this.pb_time2.gotoAndStop = int(_loc3_ * 100);
            if(_loc3_ >= 0.8 && this.pb_time2.colorTransform.greenMultiplier == 1)
            {
               this.pb_time2.colorTransform = new ColorTransform(1,0.4,0.4);
            }
            else if(_loc3_ < 0.8 && this.pb_time2.colorTransform.greenMultiplier != 1)
            {
               this.pb_time2.colorTransform = new ColorTransform();
            }
         }
      }
      
      public function setXp(param1:Number, param2:Number, param3:Number, param4:int = 0, param5:Number = 0) : void
      {
         var _loc10_:Number = NaN;
         var _loc6_:Number = (param1 - param2) / (param3 - param2) * 100;
         var _loc7_:uint = Math.floor(_loc6_);
         _loc7_ = Math.max(Math.min(_loc7_,100),1);
         var _loc8_:uint = this._roundGaugeType;
         if(_loc8_ > NB_GAUGE)
         {
            _loc8_ = NB_GAUGE;
         }
         var _loc9_:* = PROGRESS_BAR_COLORS[_loc8_];
         if(this._roundGaugeType == XP_GAUGE && param4 > ProtocolConstantsEnum.MAX_LEVEL)
         {
            _loc9_ = sysApi.getConfigEntry("colors.progressbar.gold");
         }
         if(this._roundGaugeType == XP_GAUGE && param5 > param1)
         {
            if(param5 > param3)
            {
               this.pb_xp.innerValue = 1;
            }
            else
            {
               _loc10_ = (param5 - param2) / (param3 - param2);
               this.pb_xp.innerValue = _loc10_;
            }
            this.pb_xp.innerBarColor = _loc9_;
            this.pb_xp.innerBarAlpha = 0.3;
         }
         else
         {
            this.pb_xp.innerValue = 0;
         }
         this.pb_xp.value = _loc6_ / 100;
         this.pb_xp.barColor = _loc9_;
         this._roundPercent = Math.floor(_loc6_);
         this._roundLevel = param4;
         if(this._roundGaugeType == GUILD_GAUGE && param4 == ProtocolConstantsEnum.MAX_GUILD_LEVEL || this._roundGaugeType == MOUNT_GAUGE && param4 == ProtocolConstantsEnum.MAX_MOUNT_LEVEL || this._roundGaugeType == INCARNATION_GAUGE && this._roundRemainingValue == 0 || this._roundGaugeType == HONOUR_GAUGE && param4 == ProtocolConstantsEnum.MAX_HONOR || this._roundGaugeType == JOB_GAUGE && param4 == ProtocolConstantsEnum.MAX_JOB_LEVEL)
         {
            this._roundRemainingValue = 0;
         }
         else
         {
            this._roundRemainingValue = param3 - param1;
         }
      }
      
      override protected function onContextChanged(param1:String, param2:String = "", param3:Boolean = false) : void
      {
         if(param2 == ContextEnum.SPECTATOR)
         {
            this._bIsSpectator = false;
            this.onCharacterStatsList();
         }
         this.setTimeFromPercent(0);
         this._turnElapsedTime = 0;
         switch(param1)
         {
            case ContextEnum.SPECTATOR:
               this.btn_lockParty.visible = false;
               this.btn_lockFight.visible = false;
               this.btn_requestHelp.visible = false;
               this.tx_tabsBg.visible = false;
               this.btn_creatureMode.visible = true;
               this.btn_noSpectator.visible = false;
               this.btn_pointCell.visible = true;
               this.btn_leave.visible = true;
               this.btn_tacticMode.visible = true;
               this.tx_decoration.visible = false;
               this.btn_leave.disabled = false;
               if(this._tacticModeActivated)
               {
                  sysApi.sendAction(new d2actions.ShowTacticMode());
               }
               this.btn_creatureMode.selected = this._pokemonModeActivated;
               this.setupFightUiComponents();
               break;
            case ContextEnum.PREFIGHT:
               if(this.partyApi.getPartyMembers().length > 0 && !this.partyApi.isArenaRegistered())
               {
                  this.btn_lockParty.visible = true;
               }
               else
               {
                  this.btn_lockParty.visible = false;
               }
               this.btn_lockFight.visible = true;
               this.btn_requestHelp.visible = true;
               this.tx_tabsBg.visible = true;
               this.btn_creatureMode.visible = true;
               this.btn_noSpectator.visible = true;
               this.btn_pointCell.visible = true;
               this.btn_tacticMode.visible = true;
               this.btn_leave.visible = true;
               this.tx_decoration.visible = true;
               this.btn_leave.disabled = false;
               if(this.fightApi.isWaitingBeforeFight())
               {
                  this.btn_readyOrSkip.disabled = true;
               }
               this.btn_readyOrSkip.selected = false;
               this.btn_readyOrSkip.soundId = SoundEnum.READY_TO_FIGHT;
               this.btn_lbl_btn_readyOrSkip.cssClass = "condensed";
               this.btn_lbl_btn_readyOrSkip.text = this._readyTxt;
               this.btn_lockParty.selected = false;
               this.btn_lockFight.selected = false;
               this.btn_requestHelp.selected = false;
               this.btn_creatureMode.selected = this._pokemonModeActivated;
               this.btn_noSpectator.selected = false;
               this.btn_pointCell.selected = false;
               this._bIsReady = false;
               if(param3 && this._tacticModeActivated)
               {
                  sysApi.sendAction(new d2actions.ShowTacticMode());
               }
               this.setupFightUiComponents();
               break;
            case ContextEnum.FIGHT:
               this.btn_lockParty.visible = false;
               this.btn_lockFight.visible = false;
               this.btn_requestHelp.visible = false;
               this.tx_tabsBg.visible = false;
               this.btn_creatureMode.visible = true;
               this.btn_noSpectator.visible = true;
               this.btn_pointCell.visible = true;
               this.btn_tacticMode.visible = true;
               this.btn_leave.visible = true;
               this.tx_decoration.visible = true;
               this.btn_leave.disabled = false;
               this.btn_readyOrSkip.selected = false;
               this.btn_readyOrSkip.disabled = false;
               this.btn_readyOrSkip.soundId = SoundEnum.END_TURN;
               this.btn_lbl_btn_readyOrSkip.cssClass = "condensed";
               this.btn_lbl_btn_readyOrSkip.text = this._skipTurnTxt;
               this.setupFightUiComponents();
               break;
            case ContextEnum.ROLEPLAY:
               this.resetTimeButton();
               this.setShield(0);
               this.setupRoleplayUiComponents();
         }
      }
      
      private function setupFightUiComponents() : void
      {
         var _loc1_:uint = sysApi.getBuildType();
         var _loc2_:Boolean = sysApi.getSetData("betaTurnTime2",_loc1_ == BuildTypeEnum.BETA,DataStoreEnum.BIND_COMPUTER);
         if(_loc1_ == BuildTypeEnum.RELEASE)
         {
            _loc2_ = false;
         }
         this.pb_time.visible = !_loc2_;
         this.tx_timeFx.visible = this.pb_time.visible;
         this.pb_time2.visible = _loc2_;
         this.pb_xp.visible = false;
         if(this.btn_lockParty.visible)
         {
            this.tx_tabsBg.width = this.uiApi.me().getConstant("partyTabsBgWidth");
         }
         else
         {
            this.tx_tabsBg.width = this.uiApi.me().getConstant("noPartyTabsBgWidth");
         }
         this.fightCtr.visible = true;
         this.tx_background.width = this.uiApi.me().getConstant("fightBackgroundWidth");
         this.uiApi.me().render();
         var _loc3_:* = this.uiApi.getUi("bannerMap");
         if(_loc3_)
         {
            _loc3_.visible = false;
         }
      }
      
      private function setupRoleplayUiComponents() : void
      {
         this.pb_time.visible = false;
         this.tx_timeFx.visible = false;
         this.pb_xp.visible = true;
         this.fightCtr.visible = false;
         this.tx_decoration.visible = true;
         this.tx_background.width = this.uiApi.me().getConstant("rpBackgroundWidth");
         this.uiApi.me().render();
         var _loc1_:* = this.uiApi.getUi("bannerMap");
         if(_loc1_)
         {
            _loc1_.visible = true;
         }
      }
      
      private function changeLifepointDisplay(param1:int) : void
      {
         if(param1 != this._lifepointMode)
         {
            sysApi.setData("lifepointMode",{"mode":param1});
            this._lifepointMode = param1;
         }
         switch(this._lifepointMode)
         {
            case 0:
            case 3:
               this._lifepointMode = 0;
               this.lbl_pdv.visible = true;
               this.lbl_pdvBottom.visible = false;
               this.lbl_pdvTop.visible = false;
               break;
            case 1:
            case 2:
               this.lbl_pdv.visible = false;
               this.lbl_pdvBottom.visible = true;
               this.lbl_pdvTop.visible = true;
         }
         this.setPdv(this._currentPdv,this._totalPdv);
      }
      
      private function resetTimeButton() : void
      {
         this.setTimeFromPercent(0);
         if(this.btn_lbl_btn_readyOrSkip.cssClass == "big")
         {
            this.btn_lbl_btn_readyOrSkip.cssClass = "condensed";
         }
         if(this.btn_lbl_btn_readyOrSkip.text.length == 1)
         {
            this.btn_lbl_btn_readyOrSkip.text = this._skipTurnTxt;
         }
         sysApi.removeEventListener(this.onEnterFrame);
      }
      
      private function onMountSet() : void
      {
         var _loc1_:Object = this.playerApi.getMount();
         if(this._roundGaugeType == MOUNT_GAUGE && _loc1_)
         {
            this.setXp(_loc1_.experience,_loc1_.experienceForLevel,_loc1_.experienceForNextLevel,_loc1_.level);
         }
      }
      
      private function onMountUnSet() : void
      {
         if(this._roundGaugeType == MOUNT_GAUGE && !this.playerApi.getMount())
         {
            this.onChangeXpGauge(0);
         }
      }
      
      private function onJobsExpUpdated(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:KnownJobWrapper = null;
         var _loc5_:KnownJobWrapper = null;
         var _loc6_:Boolean = false;
         var _loc7_:KnownJobWrapper = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1 == 0)
         {
            _loc2_ = 0;
            _loc3_ = this.jobsApi.getKnownJobs();
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.jobXP > 0)
               {
                  this._jobsByIndex[_loc2_] = _loc4_;
                  _loc2_++;
               }
            }
         }
         else
         {
            _loc5_ = this.jobsApi.getKnownJob(param1);
            _loc6_ = false;
            for each(_loc7_ in this._jobsByIndex)
            {
               if(_loc7_.id == param1)
               {
                  _loc7_ = _loc5_;
                  _loc6_ = true;
               }
            }
            if(!_loc6_)
            {
               this._jobsByIndex[this._jobsByIndex.length] = _loc5_;
            }
         }
         if(this._roundGaugeType >= JOB_GAUGE)
         {
            _loc8_ = this._roundGaugeType - JOB_GAUGE;
            if(param1 != 0 && this._jobsByIndex[_loc8_].id != param1)
            {
               return;
            }
            if(this._jobsByIndex[_loc8_].jobLevel == ProtocolConstantsEnum.MAX_JOB_LEVEL)
            {
               _loc9_ = 1;
               _loc10_ = 0;
               _loc11_ = 1;
            }
            else
            {
               _loc9_ = this._jobsByIndex[_loc8_].jobXP;
               _loc10_ = this._jobsByIndex[_loc8_].jobXpLevelFloor;
               _loc11_ = this._jobsByIndex[_loc8_].jobXpNextLevelFloor;
            }
            this.setXp(_loc9_,_loc10_,_loc11_,this._jobsByIndex[_loc8_].jobLevel);
         }
      }
      
      private function onGuildInformationsGeneral(param1:Number, param2:Number, param3:Number, param4:uint, param5:uint, param6:Boolean, param7:int, param8:int) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(this._lookingForMyGuildPlz)
         {
            this._roundGaugeType = GUILD_GAUGE;
            this._lookingForMyGuildPlz = false;
         }
         if(this._roundGaugeType == GUILD_GAUGE)
         {
            _loc9_ = param2;
            _loc10_ = param1;
            _loc11_ = param3;
            this.setXp(_loc9_,_loc10_,_loc11_,param4);
         }
      }
      
      public function onSlaveStatsList(param1:Object) : void
      {
         this.onCharacterStatsList(false,param1);
      }
      
      public function onCharacterStatsList(param1:Boolean = false, param2:Object = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:FighterInformations = null;
         var _loc9_:Object = null;
         if(this._bIsSpectator)
         {
            return;
         }
         if(!param2)
         {
            param2 = this.playerApi.characteristics();
         }
         if(!this.fightApi.preFightIsActive() && this.playerApi.isInFight())
         {
            _loc7_ = this.fightApi.getCurrentPlayedFighterId();
            _loc8_ = this.fightApi.getFighterInformations(_loc7_);
            if(_loc8_)
            {
               if(_loc8_.shieldPoints != this._currentShieldPoints)
               {
                  this.setShield(_loc8_.shieldPoints);
               }
               _loc3_ = _loc8_.lifePoints;
               _loc4_ = _loc8_.maxLifePoints;
               _loc5_ = _loc8_.actionPoints;
               _loc6_ = _loc8_.movementPoints;
            }
         }
         if(_loc4_ == 0)
         {
            _loc3_ = param2.lifePoints;
            _loc4_ = param2.maxLifePoints;
            _loc5_ = param2.actionPointsCurrent;
            _loc6_ = param2.movementPointsCurrent;
         }
         this.setPdv(_loc3_,_loc4_);
         this.setPA(_loc5_);
         this.setPM(_loc6_);
         switch(this._roundGaugeType)
         {
            case XP_GAUGE:
               this.setXp(param2.experience,param2.experienceLevelFloor,param2.experienceNextLevelFloor,this.playerApi.getPlayedCharacterInfo().level,param2.experienceBonusLimit);
               break;
            case ENERGY_GAUGE:
               this.setXp(this.playerApi.characteristics().energyPoints,0,this.playerApi.characteristics().maxEnergyPoints);
               break;
            case HONOUR_GAUGE:
               if(param2.alignmentInfos && param2.alignmentInfos.alignmentSide > 0)
               {
                  this.setXp(param2.alignmentInfos.honor,param2.alignmentInfos.honorGradeFloor,param2.alignmentInfos.honorNextGradeFloor,param2.alignmentInfos.alignmentGrade);
               }
               else
               {
                  this.onChangeXpGauge(0);
               }
               break;
            case POD_GAUGE:
               this.setXp(this.playerApi.inventoryWeight(),0,this.playerApi.inventoryWeightMax());
               break;
            case MOUNT_GAUGE:
               _loc9_ = this.playerApi.getMount();
               if(_loc9_)
               {
                  this.setXp(_loc9_.experience,_loc9_.experienceForLevel,_loc9_.experienceForNextLevel,_loc9_.level);
               }
         }
      }
      
      public function onInventoryWeight(param1:uint, param2:uint) : void
      {
         if(this._roundGaugeType == POD_GAUGE)
         {
            this.setXp(param1,0,param2);
         }
      }
      
      public function onObjectModified(param1:Object) : void
      {
         var _loc2_:EffectInstanceDate = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:EffectInstance = null;
         var _loc7_:int = 0;
         var _loc8_:IncarnationLevel = null;
         var _loc9_:IncarnationLevel = null;
         if(param1.position == CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON && this._roundGaugeType == INCARNATION_GAUGE)
         {
            _loc3_ = 1;
            _loc4_ = 0;
            _loc5_ = 0;
            for each(_loc6_ in this.playerApi.getWeapon().effects)
            {
               if(_loc6_.effectId == 669)
               {
                  _loc2_ = _loc6_ as EffectInstanceDate;
               }
            }
            _loc7_ = int(_loc2_.parameter3);
            do
            {
               _loc8_ = this.dataApi.getIncarnationLevel(int(_loc2_.parameter0),_loc3_);
               if(_loc8_)
               {
                  _loc4_ = _loc8_.requiredXp;
               }
               _loc3_++;
               _loc9_ = this.dataApi.getIncarnationLevel(int(_loc2_.parameter0),_loc3_);
               if(_loc9_)
               {
                  _loc5_ = _loc9_.requiredXp;
               }
            }
            while(_loc5_ < _loc7_ && _loc9_);
            
            this._roundRemainingValue = 1;
            if(!_loc9_)
            {
               if(_loc7_ >= _loc5_)
               {
                  this._roundRemainingValue = 0;
               }
               _loc5_ = _loc7_;
            }
            this.setXp(_loc7_,_loc4_,_loc5_,_loc3_ - 1);
         }
      }
      
      public function onEquipmentObjectMove(param1:Object, param2:int) : void
      {
         if(!param1 && param2 == CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON && this._roundGaugeType == INCARNATION_GAUGE)
         {
            this.onChangeXpGauge(0);
         }
      }
      
      public function onGameFightTurnStart(param1:Number, param2:int, param3:uint, param4:Boolean) : void
      {
         var _loc6_:Object = null;
         this._currentTurnEntityId = param1;
         var _loc5_:* = param1 == this.fightApi.getCurrentPlayedFighterId();
         if(_loc5_ || this._bIsSpectator)
         {
            this._clockStart = getTimer();
            this._turnDuration = param2;
            this._turnElapsedTime = param2 - param3;
            sysApi.addEventListener(this.onEnterFrame,"FightBannerA");
         }
         if(this._bIsSpectator)
         {
            _loc6_ = this.fightApi.getFighterInformations(param1);
            this.setShield(_loc6_.shieldPoints);
            this.setPdv(_loc6_.lifePoints,_loc6_.maxLifePoints);
            this.setPA(_loc6_.actionPoints);
            this.setPM(_loc6_.movementPoints);
         }
         else if(!_loc5_)
         {
            this.resetTimeButton();
         }
      }
      
      public function onGameFightTurnEnd(param1:Number) : void
      {
         if(param1 == this._currentTurnEntityId)
         {
            this.resetTimeButton();
         }
      }
      
      override public function onGameFightJoin(param1:Boolean, param2:Boolean, param3:Boolean, param4:int, param5:int, param6:Boolean) : void
      {
         var _loc7_:Object = null;
         super.onGameFightJoin(param1,param2,param3,param4,param5,param6);
         this._bIsSpectator = param3;
         if(!this._bIsSpectator)
         {
            if(param4)
            {
               if(!param6)
               {
                  _loc7_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.fight.otherTeamPreparation"));
                  this.uiApi.showTooltip(_loc7_,this.pb_time,true,"standard",7,1,3,null,null,null,"TextInfo");
               }
               this._turnDuration = param4 == -1?uint(0):uint(param4);
               this._clockStart = getTimer();
               sysApi.addEventListener(this.onEnterFrame,"FightBannerB");
            }
         }
      }
      
      private function onReadyToFight() : void
      {
         this.onRelease(this.btn_readyOrSkip);
      }
      
      private function onNotReadyToFight() : void
      {
         this._bIsReady = this.btn_readyOrSkip.selected = false;
      }
      
      override public function onGameFightStart() : void
      {
         super.onGameFightStart();
         this.resetTimeButton();
         this._arenaFightLeaver = null;
      }
      
      public function onArenaFighterLeave(param1:CharacterBasicMinimalInformations) : void
      {
         this._arenaFightLeaver = param1;
      }
      
      public function onFightEvent(param1:String, param2:Object, param3:Object = null) : void
      {
         var _loc5_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param3 == null || param3 == new Array() || param3.length == 0)
         {
            param3 = new Array();
            if(param2.length)
            {
               param3[0] = param2[0];
            }
         }
         var _loc4_:int = param3.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param3[_loc6_];
            if(_loc7_ == 0)
            {
               sysApi.log(4,"Pas de traitement du fight Event " + param1 + " : aucune cible définie");
               return;
            }
            _loc8_ = this.fightApi.getFighterInformations(_loc7_);
            if(!_loc8_ && currentContext == ContextEnum.FIGHT)
            {
               sysApi.log(4,"Pas de traitement du fight Event " + param1 + " : le combattant " + _loc7_ + " n\'existe pas.");
               return;
            }
            _loc5_ = this._bIsSpectator && _loc7_ == this.fightApi.getPlayingFighterId();
            switch(param1)
            {
               case FightEventEnum.FIGHTER_LIFE_GAIN:
               case FightEventEnum.FIGHTER_LIFE_LOSS:
               case FightEventEnum.FIGHTER_SUMMONED:
                  if(_loc7_ == this.fightApi.getCurrentPlayedFighterId() || _loc5_)
                  {
                     if(currentContext == ContextEnum.FIGHT || _loc5_)
                     {
                        _loc10_ = _loc8_.maxLifePoints;
                        _loc9_ = _loc8_.lifePoints;
                     }
                     else
                     {
                        _loc10_ = this.fightApi.getCurrentPlayedCharacteristicsInformations().maxLifePoints;
                        _loc9_ = this.fightApi.getCurrentPlayedCharacteristicsInformations().lifePoints;
                     }
                     this.setPdv(_loc9_,_loc10_);
                  }
                  break;
               case FightEventEnum.FIGHTER_DEATH:
               case FightEventEnum.FIGHTER_LEAVE:
                  if(_loc7_ == this.fightApi.getCurrentPlayedFighterId() || _loc5_)
                  {
                     this.setPdv(0,_loc8_.maxLifePoints);
                  }
                  break;
               case FightEventEnum.FIGHTER_SHIELD_LOSS:
                  if(_loc7_ == this.fightApi.getCurrentPlayedFighterId() || _loc5_)
                  {
                     _loc11_ = _loc8_.shieldPoints;
                     this.setShield(_loc11_);
                  }
                  break;
               case FightEventEnum.FIGHTER_AP_USED:
               case FightEventEnum.FIGHTER_AP_LOST:
               case FightEventEnum.FIGHTER_AP_GAINED:
                  if(_loc7_ == this.fightApi.getCurrentPlayedFighterId() || _loc5_)
                  {
                     this.setPA(_loc8_.actionPoints);
                  }
                  break;
               case FightEventEnum.FIGHTER_MP_USED:
               case FightEventEnum.FIGHTER_MP_LOST:
               case FightEventEnum.FIGHTER_MP_GAINED:
                  if(_loc7_ == this.fightApi.getCurrentPlayedFighterId() || _loc5_)
                  {
                     this.setPM(_loc8_.movementPoints);
                  }
                  break;
               case FightEventEnum.FIGHTER_GOT_DISPELLED:
               case FightEventEnum.FIGHTER_TEMPORARY_BOOSTED:
                  if(_loc7_ == this.fightApi.getCurrentPlayedFighterId() || _loc5_)
                  {
                     this.setPA(_loc8_.actionPoints);
                     this.setPM(_loc8_.movementPoints);
                     this.setPdv(_loc8_.lifePoints,_loc8_.maxLifePoints);
                     this.setShield(_loc8_.shieldPoints);
                  }
                  break;
               case FightEventEnum.FIGHTER_CASTED_SPELL:
            }
            _loc6_++;
         }
      }
      
      public function unload() : void
      {
         this.resetTimeButton();
         this.uiApi.unloadUi("bannerActionBar");
      }
      
      public function onEnterFrame() : void
      {
         if(this._turnDuration == 0)
         {
            this.resetTimeButton();
            return;
         }
         var _loc1_:uint = getTimer();
         var _loc2_:Number = (_loc1_ - this._clockStart + this._turnElapsedTime) / this._turnDuration * 100;
         var _loc3_:Number = (this._turnDuration - (_loc1_ - this._clockStart + this._turnElapsedTime)) / 1000;
         this.setTimeFromPercent(_loc2_);
         if(_loc3_ < 5 && _loc3_ >= 0)
         {
            this.btn_lbl_btn_readyOrSkip.cssClass = "big";
            this.btn_lbl_btn_readyOrSkip.text = (Math.floor(_loc3_) + 1).toString();
         }
         if(_loc2_ >= 100)
         {
            this.resetTimeButton();
         }
      }
      
      private function onShowCell() : void
      {
         this.btn_pointCell.selected = false;
         this._bCellPointed = false;
      }
      
      private function onOptionLockFight(param1:Boolean) : void
      {
         this.btn_lockFight.selected = param1;
      }
      
      private function onOptionLockParty(param1:Boolean) : void
      {
         this.btn_lockParty.selected = param1;
      }
      
      private function onOptionHelpWanted(param1:Boolean) : void
      {
         this.btn_requestHelp.selected = param1;
      }
      
      private function onOptionWitnessForbidden(param1:Boolean) : void
      {
         this.btn_noSpectator.selected = param1;
      }
      
      private function addContextMenu() : void
      {
         var _loc2_:KnownJobWrapper = null;
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc1_:Array = new Array(this.uiApi.getText("ui.banner.xpCharacter"),this.uiApi.getText("ui.banner.xpGuild"),this.uiApi.getText("ui.banner.xpMount"),this.uiApi.getText("ui.banner.xpIncarnation"),this.uiApi.getText("ui.pvp.honourPoints"),this.uiApi.getText("ui.common.weight"),this.uiApi.getText("ui.common.energyPoints"));
         for each(_loc2_ in this._jobsByIndex)
         {
            _loc1_.push(this.uiApi.getText("ui.common.xp") + " " + _loc2_.name);
         }
         _loc3_ = new Array();
         if(this._roundGaugeType > _loc1_.length - 1)
         {
            this._roundGaugeType = 0;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc1_.length)
         {
            if(this._roundGaugeType == _loc6_)
            {
               _loc4_ = true;
            }
            else
            {
               _loc4_ = false;
            }
            if(_loc6_ == GUILD_GAUGE && !this.socialApi.hasGuild() || _loc6_ == MOUNT_GAUGE && this.playerApi.getMount() == null || _loc6_ == INCARNATION_GAUGE && !this.playerApi.isIncarnation() || _loc6_ == HONOUR_GAUGE && this.playerApi.characteristics().alignmentInfos.alignmentSide == 0)
            {
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
            _loc3_.push(this.modContextMenu.createContextMenuItemObject(_loc1_[_loc6_],this.onChangeXpGauge,[_loc6_],_loc5_,null,_loc4_,true));
            _loc6_++;
         }
         var _loc7_:Object = this.menuApi.create(this.playerApi.getPlayedCharacterInfo().name);
         _loc7_.content.unshift(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.banner.customGauge"),null,null,false,_loc3_));
         this.modContextMenu.createContextMenu(_loc7_);
      }
      
      private function onChangeXpGauge(param1:uint) : void
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:EffectInstanceDate = null;
         var _loc11_:int = 0;
         var _loc12_:IncarnationLevel = null;
         var _loc13_:IncarnationLevel = null;
         var _loc14_:KnownJobWrapper = null;
         var _loc15_:EffectInstance = null;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = this.playerApi.characteristics();
         switch(param1)
         {
            case XP_GAUGE:
               if(!_loc7_)
               {
                  return;
               }
               _loc2_ = _loc7_.experience;
               _loc3_ = _loc7_.experienceLevelFloor;
               _loc4_ = _loc7_.experienceNextLevelFloor;
               _loc6_ = this.playerApi.getPlayedCharacterInfo().level;
               _loc5_ = _loc7_.experienceBonusLimit;
               break;
            case GUILD_GAUGE:
               _loc8_ = this.socialApi.getGuild();
               if(!_loc8_)
               {
                  return;
               }
               _loc2_ = _loc8_.experience;
               _loc3_ = _loc8_.expLevelFloor;
               _loc4_ = _loc8_.expNextLevelFloor;
               _loc6_ = _loc8_.level;
               break;
            case MOUNT_GAUGE:
               _loc9_ = this.playerApi.getMount();
               if(!_loc9_)
               {
                  return;
               }
               _loc2_ = _loc9_.experience;
               _loc3_ = _loc9_.experienceForLevel;
               _loc4_ = _loc9_.experienceForNextLevel;
               _loc6_ = _loc9_.level;
               break;
            case INCARNATION_GAUGE:
               _loc11_ = 1;
               if(!this.playerApi.getWeapon())
               {
                  return;
               }
               for each(_loc15_ in this.playerApi.getWeapon().effects)
               {
                  if(_loc15_.effectId == 669)
                  {
                     _loc10_ = _loc15_ as EffectInstanceDate;
                  }
               }
               _loc2_ = int(_loc10_.parameter3);
               do
               {
                  _loc12_ = this.dataApi.getIncarnationLevel(int(_loc10_.parameter0),_loc11_);
                  if(_loc12_)
                  {
                     _loc3_ = _loc12_.requiredXp;
                  }
                  _loc11_++;
                  _loc13_ = this.dataApi.getIncarnationLevel(int(_loc10_.parameter0),_loc11_);
                  if(_loc13_)
                  {
                     _loc4_ = _loc13_.requiredXp;
                  }
               }
               while(_loc4_ < _loc2_ && _loc13_);
               
               this._roundRemainingValue = 1;
               if(!_loc13_)
               {
                  if(_loc2_ >= _loc4_)
                  {
                     this._roundRemainingValue = 0;
                  }
                  _loc4_ = _loc2_;
               }
               _loc6_ = _loc11_ - 1;
               break;
            case HONOUR_GAUGE:
               if(!_loc7_)
               {
                  return;
               }
               _loc2_ = _loc7_.alignmentInfos.honor;
               _loc3_ = _loc7_.alignmentInfos.honorGradeFloor;
               _loc4_ = _loc7_.alignmentInfos.honorNextGradeFloor;
               _loc6_ = _loc7_.alignmentInfos.alignmentGrade;
               break;
            case POD_GAUGE:
               _loc2_ = this.playerApi.inventoryWeight();
               _loc3_ = 0;
               _loc4_ = this.playerApi.inventoryWeightMax();
               break;
            case ENERGY_GAUGE:
               if(!this.playerApi.characteristics())
               {
                  break;
               }
               _loc2_ = this.playerApi.characteristics().energyPoints;
               _loc3_ = 0;
               _loc4_ = this.playerApi.characteristics().maxEnergyPoints;
               break;
            case JOB_GAUGE:
            default:
               _loc14_ = this._jobsByIndex[param1 - JOB_GAUGE];
               if(!_loc14_)
               {
                  return;
               }
               if(_loc14_.jobLevel == ProtocolConstantsEnum.MAX_JOB_LEVEL)
               {
                  _loc2_ = 1;
                  _loc3_ = 0;
                  _loc4_ = 1;
               }
               else
               {
                  _loc2_ = _loc14_.jobXP;
                  _loc3_ = _loc14_.jobXpLevelFloor;
                  _loc4_ = _loc14_.jobXpNextLevelFloor;
               }
               _loc6_ = _loc14_.jobLevel;
               break;
         }
         this._roundGaugeType = param1;
         if(this._roundGaugeType != GUILD_GAUGE)
         {
            this._lookingForMyGuildPlz = false;
         }
         sysApi.setData("roundGaugeMode_" + this.playerApi.id(),this._roundGaugeType);
         this.setXp(_loc2_,_loc3_,_loc4_,_loc6_,_loc5_);
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         switch(param1)
         {
            case this.btn_tacticMode:
               sysApi.sendAction(new d2actions.ShowTacticMode());
               break;
            case this.lbl_pdv:
            case this.lbl_pdvTop:
            case this.lbl_pdvBottom:
            case this.tx_hpBg:
               if(sysApi.isFightContext() && this.uiApi.keyIsDown(Keyboard.ALTERNATE))
               {
                  sysApi.sendAction(new ChatTextOutput(this.uiApi.getText("ui.fightAutomsg.lifePoints",this._currentPdv,this._totalPdv),ChatActivableChannelsEnum.CHANNEL_TEAM,null,null));
               }
               else
               {
                  _loc2_ = this._lifepointMode + 1;
                  this.changeLifepointDisplay(_loc2_);
               }
               break;
            case this.tx_apBg:
               if(sysApi.isFightContext() && this.uiApi.keyIsDown(Keyboard.ALTERNATE))
               {
                  sysApi.sendAction(new ChatTextOutput(this.uiApi.getText("ui.fightAutomsg.actionPoints",this._nPa),ChatActivableChannelsEnum.CHANNEL_TEAM,null,null));
               }
               break;
            case this.tx_mpBg:
               if(sysApi.isFightContext() && this.uiApi.keyIsDown(Keyboard.ALTERNATE))
               {
                  sysApi.sendAction(new ChatTextOutput(this.uiApi.getText("ui.fightAutomsg.movementPoints",this._nPm),ChatActivableChannelsEnum.CHANNEL_TEAM,null,null));
               }
               break;
            case this.btn_readyOrSkip:
               if(currentContext == ContextEnum.PREFIGHT)
               {
                  if(this._bIsReady)
                  {
                     this._bIsReady = false;
                     sysApi.sendAction(new GameFightReady(false));
                     this.btn_readyOrSkip.selected = false;
                  }
                  else
                  {
                     this._bIsReady = true;
                     sysApi.sendAction(new GameFightReady(true));
                     this.btn_readyOrSkip.selected = true;
                  }
               }
               else if(currentContext == ContextEnum.FIGHT)
               {
                  sysApi.sendAction(new GameFightTurnFinish());
               }
               break;
            case this.btn_leave:
               if(!this._bIsSpectator)
               {
                  _loc3_ = sysApi.getCurrentServer();
                  if(_loc3_.gameTypeId == 1 && this.fightApi.getFightType() != FightTypeEnum.FIGHT_TYPE_CHALLENGE || _loc3_.gameTypeId == 4 && (this.fightApi.getFightType() == FightTypeEnum.FIGHT_TYPE_MXvM || this.fightApi.getFightType() == FightTypeEnum.FIGHT_TYPE_PvM))
                  {
                     _loc4_ = this.uiApi.getText("ui.popup.hardcoreGiveup");
                  }
                  else
                  {
                     _loc4_ = this.uiApi.getText("ui.popup.giveup");
                  }
                  if(this.fightApi.getFightType() == FightTypeEnum.FIGHT_TYPE_PVP_ARENA)
                  {
                     if(this._arenaFightLeaver)
                     {
                        _loc4_ = _loc4_ + ("\n" + this.uiApi.getText("ui.party.arenaLeaveAfterSomeoneElseWarning",this._arenaFightLeaver.name));
                     }
                     else
                     {
                        _loc4_ = _loc4_ + ("\n" + this.uiApi.getText("ui.party.arenaLeaveWarning",sysApi.getPlayerManager().arenaLeaveBanTime));
                     }
                  }
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc4_,[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.onPopupLeaveFight,this.onPopupClose],this.onPopupLeaveFight,this.onPopupClose);
               }
               else
               {
                  sysApi.sendAction(new GameContextQuit());
               }
               break;
            case this.btn_pointCell:
               if(!this._bCellPointed)
               {
                  this.btn_pointCell.selected = true;
                  this._bCellPointed = true;
               }
               else
               {
                  this.btn_pointCell.selected = false;
                  this._bCellPointed = false;
               }
               sysApi.sendAction(new TogglePointCell());
               break;
            case this.btn_noSpectator:
               this.toggleSpectatorForbiden();
               break;
            case this.btn_creatureMode:
               this._pokemonModeActivated = !this._pokemonModeActivated;
               this.configApi.setConfigProperty("dofus","creaturesFightMode",this._pokemonModeActivated);
               sysApi.sendAction(new ToggleDematerialization());
               break;
            case this.btn_requestHelp:
               sysApi.sendAction(new ToggleHelpWanted());
               break;
            case this.btn_lockFight:
               sysApi.sendAction(new ToggleLockFight());
               break;
            case this.btn_lockParty:
               sysApi.sendAction(new ToggleLockParty());
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:String = null;
         switch(param1)
         {
            case this.tx_apBg:
               _loc2_ = this.uiApi.getText("ui.stats.actionPoints");
               break;
            case this.tx_mpBg:
               _loc2_ = this.uiApi.getText("ui.stats.movementPoints");
               break;
            case this.btn_readyOrSkip:
               if(currentContext == ContextEnum.PREFIGHT)
               {
                  _loc2_ = this.uiApi.getText("ui.fight.ready");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.nextTurn");
               }
               _loc5_ = this.bindsApi.getShortcutBindStr("skipTurn");
               break;
            case this.btn_leave:
               if(!this._bIsSpectator)
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.giveUp");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.giveupSpectator");
               }
               break;
            case this.btn_pointCell:
               _loc2_ = this.uiApi.getText("ui.fight.option.flagHelp");
               _loc5_ = this.bindsApi.getShortcutBindStr("showCell");
               break;
            case this.btn_lockParty:
               _loc2_ = this.uiApi.getText("ui.fight.option.blockJoinerExceptParty");
               break;
            case this.btn_noSpectator:
               if(this.btn_noSpectator.selected)
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.unblockSpectator");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.blockSpectator");
               }
               break;
            case this.btn_creatureMode:
               if(this.btn_creatureMode.selected)
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.noCreatureMode");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.creatureMode");
               }
               _loc5_ = this.bindsApi.getShortcutBindStr(ShortcutHookListEnum.TOGGLE_DEMATERIALIZATION);
               break;
            case this.btn_requestHelp:
               _loc2_ = this.uiApi.getText("ui.fight.option.help");
               break;
            case this.btn_tacticMode:
               if(this.btn_tacticMode.selected)
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.noTacticMode");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.tacticMode");
               }
               _loc5_ = this.bindsApi.getShortcutBindStr(ShortcutHookListEnum.SHOW_TACTIC_MODE);
               break;
            case this.btn_lockFight:
               _loc2_ = this.uiApi.getText("ui.fight.option.blockJoiner");
               break;
            case this.tx_hpBg:
               _loc2_ = this.uiApi.getText("ui.common.lifePoints");
               break;
            case this.pb_xp:
               if(this._roundPercent < 0)
               {
                  this._roundPercent = 0;
               }
               if(this._roundPercent > 100)
               {
                  this._roundPercent = 100;
               }
               _loc2_ = "";
               if(this._roundGaugeType == ENERGY_GAUGE)
               {
                  _loc2_ = this.utilApi.formateIntToString(this.playerApi.characteristics().energyPoints) + " / " + this.utilApi.formateIntToString(this.playerApi.characteristics().maxEnergyPoints);
                  break;
               }
               if(this._roundGaugeType != POD_GAUGE && this._roundLevel > 0)
               {
                  if(this._roundGaugeType == HONOUR_GAUGE)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.pvp.rank") + this.uiApi.getText("ui.common.colon") + this._roundLevel);
                  }
                  else if(this._roundGaugeType == XP_GAUGE && this._roundLevel > ProtocolConstantsEnum.MAX_LEVEL)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.common.prestige") + this.uiApi.getText("ui.common.colon") + (this._roundLevel - ProtocolConstantsEnum.MAX_LEVEL));
                  }
                  else
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.common.level") + this.uiApi.getText("ui.common.colon") + this._roundLevel);
                  }
               }
               if(this._roundRemainingValue > 0)
               {
                  if(this._roundGaugeType != POD_GAUGE)
                  {
                     if(this._roundGaugeType == HONOUR_GAUGE)
                     {
                        _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.pvp.nextRank") + this.uiApi.getText("ui.common.colon"));
                     }
                     else
                     {
                        _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.nextLevel") + this.uiApi.getText("ui.common.colon"));
                     }
                  }
                  _loc2_ = _loc2_ + (this._roundPercent + " %");
                  if(this._roundGaugeType != POD_GAUGE)
                  {
                     _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.required") + this.uiApi.getText("ui.common.colon") + this.utilApi.formateIntToString(this._roundRemainingValue));
                  }
                  else
                  {
                     _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.remaining") + this.uiApi.getText("ui.common.colon") + this.utilApi.formateIntToString(this._roundRemainingValue));
                  }
               }
               else if(this._roundGaugeType == POD_GAUGE)
               {
                  _loc2_ = _loc2_ + (this._roundPercent + " %");
               }
               if(this._roundGaugeType == XP_GAUGE && this.playerApi.characteristics().experienceBonusLimit > 0 && this.playerApi.characteristics().experience < this.playerApi.characteristics().experienceBonusLimit)
               {
                  _loc2_ = _loc2_ + ("\n<i>" + this.uiApi.getText("ui.help.xpBonus",2) + "</i>");
               }
               break;
            case this.lbl_pdv:
            case this.lbl_pdvTop:
               if(this._lifepointMode == HP_1_LINE_DISPLAY)
               {
                  _loc2_ = this.uiApi.getText("ui.common.lifePoints.value",this._currentPdv);
               }
               break;
            case this.lbl_pdvBottom:
               if(this._lifepointMode == HP_1_LINE_DISPLAY && this._currentShieldPoints)
               {
                  _loc2_ = this.uiApi.getText("ui.common.shieldPoints.value",this._currentShieldPoints);
               }
         }
         if(_loc5_)
         {
            if(!this._shortcutColor)
            {
               this._shortcutColor = sysApi.getConfigEntry("colors.shortcut");
               this._shortcutColor = this._shortcutColor.replace("0x","#");
            }
            if(_loc2_)
            {
               _loc7_ = this.uiApi.textTooltipInfo(_loc2_ + " <font color=\'" + this._shortcutColor + "\'>(" + _loc5_ + ")</font>");
            }
            else if(_loc6_)
            {
               _loc7_ = this.uiApi.textTooltipInfo(this.uiApi.getText(_loc6_,"<font color=\'" + this._shortcutColor + "\'>(" + _loc5_ + ")</font>"));
            }
         }
         else if(_loc2_)
         {
            _loc7_ = this.uiApi.textTooltipInfo(_loc2_);
         }
         if(_loc7_)
         {
            this.uiApi.showTooltip(_loc7_,param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemFeed(param1:Object) : void
      {
         sysApi.dispatchHook(OpenFeed,param1);
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case this.pb_xp:
               if(!this._bIsSpectator)
               {
                  this.addContextMenu();
               }
               break;
            case this.btn_readyOrSkip:
            case this.pb_time:
            case this.pb_time2:
               if(sysApi.getBuildType() != BuildTypeEnum.RELEASE)
               {
                  _loc2_ = new Array();
                  _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.banner.switchTimeProgressBar"),this.onSwitchTimeProgressBar));
                  this.modContextMenu.createContextMenu(_loc2_);
               }
         }
      }
      
      private function onSwitchTimeProgressBar() : void
      {
         this.pb_time.visible = !this.pb_time.visible;
         this.pb_time2.visible = !this.pb_time2.visible;
         this.tx_timeFx.visible = this.pb_time.visible;
         sysApi.setData("betaTurnTime2",this.pb_time2.visible,DataStoreEnum.BIND_COMPUTER);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         switch(param1)
         {
            case "skipTurn":
            case this.btn_readyOrSkip:
               if(currentContext == ContextEnum.PREFIGHT)
               {
                  if(this._bIsReady)
                  {
                     this._bIsReady = false;
                     sysApi.sendAction(new GameFightReady(false));
                     this.btn_readyOrSkip.selected = false;
                     return true;
                  }
                  this._bIsReady = true;
                  sysApi.sendAction(new GameFightReady(true));
                  this.btn_readyOrSkip.selected = true;
                  return true;
               }
               sysApi.sendAction(new GameFightTurnFinish());
               return true;
            case "validUi":
               sysApi.dispatchHook(ChatFocus);
               return true;
            case "closeUi":
               if(!this.inventoryApi.removeSelectedItem())
               {
                  if(!this.fightApi.isCastingSpell())
                  {
                     return false;
                  }
                  _loc3_ = this.uiApi.getUi("bannerActionBar");
                  if(_loc3_)
                  {
                     (_loc3_.uiClass as ActionBar).unselectSpell();
                  }
               }
               return true;
            case ShortcutHookListEnum.SHOW_CELL:
               if(!this._bCellPointed)
               {
                  this.btn_pointCell.selected = true;
                  this._bCellPointed = true;
               }
               else
               {
                  this.btn_pointCell.selected = false;
                  this._bCellPointed = false;
               }
               sysApi.sendAction(new TogglePointCell());
               return true;
            case ShortcutHookListEnum.TOGGLE_DEMATERIALIZATION:
               sysApi.sendAction(new ToggleDematerialization());
               return true;
            case ShortcutHookListEnum.SHOW_ALL_NAMES:
               sysApi.sendAction(new ShowAllNames());
               return true;
            case ShortcutHookListEnum.SHOW_ENTITIES_TOOLTIPS:
               sysApi.sendAction(new ShowEntitiesTooltips());
               return true;
            case ShortcutHookListEnum.SHOW_MOUNTS_IN_FIGHT:
               _loc2_ = sysApi.getOption("showMountsInFight","dofus");
               sysApi.sendAction(new ShowMountsInFight(!_loc2_));
               return true;
            case ShortcutHookListEnum.SHOW_TACTIC_MODE:
               sysApi.sendAction(new d2actions.ShowTacticMode());
               return true;
            case ShortcutHookListEnum.CAPTURE_SCREEN:
               sysApi.sendAction(new CaptureScreen());
               return true;
            case ShortcutHookListEnum.CAPTURE_SCREEN_WITHOUT_UI:
               sysApi.sendAction(new CaptureScreenWithoutUI());
               return true;
            case ShortcutHookListEnum.HIGHLIGHT_INTERACTIVE_ELEMENTS:
               sysApi.sendAction(new HighlightInteractiveElements());
               return true;
            default:
               return false;
         }
      }
      
      public function onShowTacticMode(param1:Boolean) : void
      {
         this.btn_tacticMode.selected = param1;
         this._tacticModeActivated = param1;
      }
      
      private function onDematerializationChanged(param1:Boolean) : void
      {
         this.btn_creatureMode.selected = param1;
         this._pokemonModeActivated = param1;
         this.configApi.setConfigProperty("dofus","creaturesFightMode",this._pokemonModeActivated);
      }
      
      public function onRemindTurn() : void
      {
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onPopupLeaveFight() : void
      {
         sysApi.sendAction(new GameContextQuit());
      }
      
      private function toggleSpectatorForbiden() : void
      {
         if(getTimer() - this._spectatorCloseLastRequest < this._spectatorCloseLastRequestTime)
         {
            this.btn_noSpectator.selected = !this.btn_noSpectator.selected;
            return;
         }
         this._spectatorCloseLastRequest = getTimer();
         sysApi.sendAction(new ToggleWitnessForbidden());
      }
      
      private function onPartyJoin(param1:int, param2:Object, param3:Boolean, param4:Boolean, param5:String = "") : void
      {
         if(!this.btn_lockParty.visible && param1 == this.partyApi.getPartyId() && this.playerApi.isInPreFight())
         {
            this.btn_lockParty.visible = true;
         }
      }
      
      private function onPartyLeave(param1:int, param2:Boolean) : void
      {
         if(this.btn_lockParty.visible && param1 == this.partyApi.getPartyId() && this.playerApi.isInPreFight())
         {
            this.btn_lockParty.visible = false;
         }
      }
      
      public function dragUpdate() : void
      {
         var _loc1_:* = this.uiApi.getUi("spectatorPanel");
         if(_loc1_ && _loc1_.uiClass && _loc1_.uiClass.entityDisplayer.characterReady)
         {
            _loc1_.uiClass.entityDisplayer.updateScaleAndOffsets();
         }
      }
      
      private function getPlayerId() : Number
      {
         if(this.playerApi.isInFight())
         {
            return this.fightApi.getCurrentPlayedFighterId();
         }
         return this.playerApi.id();
      }
      
      private function formatShortcut(param1:String, param2:String) : String
      {
         if(param2)
         {
            if(!this._shortcutColor)
            {
               this._shortcutColor = sysApi.getConfigEntry("colors.shortcut");
               this._shortcutColor = this._shortcutColor.replace("0x","#");
            }
            return param1 + " <font color=\'" + this._shortcutColor + "\'>(" + param2 + ")</font>";
         }
         return param1;
      }
   }
}
