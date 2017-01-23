package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.GameFightPlacementSwapPositionsAccept;
   import d2actions.GameFightPlacementSwapPositionsCancel;
   import d2hooks.AfkModeChanged;
   import d2hooks.ChallengeInfoUpdate;
   import d2hooks.CharacterLevelUp;
   import d2hooks.FightIdolList;
   import d2hooks.FightText;
   import d2hooks.FighterSelected;
   import d2hooks.FightersListUpdated;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightStart;
   import d2hooks.GameFightStarting;
   import d2hooks.GameFightTurnStart;
   import d2hooks.IdolFightPreparationUpdate;
   import d2hooks.LevelUiClosed;
   import d2hooks.ShowSwapPositionRequestMenu;
   import d2hooks.SpectateUpdate;
   import d2hooks.SpectatorWantLeave;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import ui.Buffs;
   import ui.ChallengeDisplay;
   import ui.FightIdols;
   import ui.FightResult;
   import ui.FighterInfo;
   import ui.SpectatorPanel;
   import ui.SwapPositionIcon;
   import ui.Timeline;
   import ui.TurnStart;
   
   public class Fight extends Sprite
   {
      
      private static var _newLevel:int;
       
      
      protected var timeline:Timeline;
      
      protected var buffs:Buffs;
      
      protected var fightResult:FightResult;
      
      protected var turnStart:TurnStart;
      
      protected var fighterInfo:FighterInfo;
      
      protected var challengeDisplay:ChallengeDisplay;
      
      protected var spectatorPanel:SpectatorPanel;
      
      protected var swapPositionIconUi:SwapPositionIcon;
      
      protected var fightIdols:FightIdols;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var fightApi:FightApi;
      
      public var dataApi:DataApi;
      
      public var configApi:ConfigApi;
      
      public var chatApi:ChatApi;
      
      private var _currentBuffsOwnerId:Number;
      
      private var _fightEndParams:Object;
      
      private var _fightEventsTimer:Timer;
      
      private var _currentFightStartDate:Number = 0;
      
      private var _currentFightAttackersName:String = "";
      
      private var _currentFightDefendersName:String = "";
      
      private var _afkPopup:String;
      
      private var _preparationPhase:Boolean;
      
      private var _killCount:uint = 0;
      
      public function Fight()
      {
         this._fightEventsTimer = new Timer(1000);
         super();
      }
      
      public static function get newLevel() : int
      {
         return _newLevel;
      }
      
      public function main() : void
      {
         Api.sysApi = this.sysApi;
         Api.uiApi = this.uiApi;
         Api.fightApi = this.fightApi;
         Api.dataApi = this.dataApi;
         Api.configApi = this.configApi;
         Api.chatApi = this.chatApi;
         _newLevel = -1;
         this._fightEventsTimer.addEventListener(TimerEvent.TIMER,this.onFightEventsTimer);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(GameFightStarting,this.onGameFightStarting);
         this.sysApi.addHook(GameFightStart,this.onGameFightStart);
         this.sysApi.addHook(SpectateUpdate,this.onSpectateUpdate);
         this.sysApi.addHook(FightersListUpdated,this.onFightersListUpdated);
         this.sysApi.addHook(FightText,this.onFightText);
         this.sysApi.addHook(FighterSelected,this.onOpenBuffs);
         this.sysApi.addHook(GameFightTurnStart,this.onTurnStart);
         this.sysApi.addHook(CharacterLevelUp,this.onCharacterLevelUp);
         this.sysApi.addHook(LevelUiClosed,this.onLevelUiClosed);
         this.sysApi.addHook(SpectatorWantLeave,this.onSpectatorWantLeave);
         this.sysApi.addHook(AfkModeChanged,this.onAfkModeChanged);
         this.sysApi.addHook(ChallengeInfoUpdate,this.onChallengeInfoUpdate);
         this.sysApi.addHook(ShowSwapPositionRequestMenu,this.onShowSwapPositionRequestMenu);
         this.sysApi.addHook(IdolFightPreparationUpdate,this.onIdolFightPreparationUpdate);
         this.sysApi.addHook(FightIdolList,this.onFightIdolList);
      }
      
      public function unload() : void
      {
         if(this._fightEventsTimer)
         {
            this._fightEventsTimer.reset();
            this._fightEventsTimer.removeEventListener(TimerEvent.TIMER,this.onFightEventsTimer);
            this._fightEventsTimer = null;
         }
      }
      
      private function onTurnStart(param1:Number, param2:uint, param3:uint, param4:Boolean) : void
      {
         var _loc5_:Object = null;
         this._killCount = 0;
         if(param4)
         {
            _loc5_ = this.uiApi.getUi("turnStart");
            if(_loc5_)
            {
               _loc5_.uiClass.restart(param1,param2);
            }
            else
            {
               this.uiApi.loadUi("turnStart","turnStart",{
                  "fighterId":param1,
                  "waitingTime":param2
               });
            }
         }
         else if(this.uiApi.getUi("turnStart"))
         {
            this.uiApi.unloadUi("turnStart");
         }
      }
      
      private function onFightersListUpdated() : void
      {
         if(!this.uiApi.getUi("timeline"))
         {
            this.uiApi.loadUi("timeline","timeline");
         }
      }
      
      private function onGameFightEnd(param1:Object) : void
      {
         this._fightEventsTimer.reset();
         this.uiApi.unloadUi("timeline");
         this.uiApi.unloadUi("fighterInfo");
         if(this.uiApi.getUi("buffs"))
         {
            this.uiApi.unloadUi("buffs");
         }
         if(param1.results.length > 0)
         {
            this.uiApi.loadUi("fightResult","fightResult",param1);
         }
         if(this.uiApi.getUi("turnStart"))
         {
            this.uiApi.unloadUi("turnStart");
         }
         if(this.uiApi.getUi("challengeDisplay"))
         {
            this.uiApi.unloadUi("challengeDisplay");
         }
         if(this.uiApi.getUi("fightIdols"))
         {
            this.uiApi.unloadUi("fightIdols");
         }
         if(this._afkPopup)
         {
            this.uiApi.unloadUi(this._afkPopup);
            this._afkPopup = null;
         }
         this._preparationPhase = false;
         this._currentFightStartDate = 0;
         this._currentFightAttackersName = "";
         this._currentFightDefendersName = "";
      }
      
      private function onFightText(param1:String, param2:Object, param3:Object, param4:String = "") : void
      {
         var pEvtName:String = param1;
         var pParams:Object = param2;
         var pTargets:Object = param3;
         var pTargetsTeam:String = param4;
         try
         {
            FightTexts.event(pEvtName,pParams,pTargets,pTargetsTeam);
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function onOpenBuffs(param1:Number) : void
      {
         var _loc2_:Object = this.uiApi.getUi("timeline");
         if(!this.uiApi.getUi("buffs"))
         {
            this._currentBuffsOwnerId = param1;
            this.uiApi.loadUiInside("buffs",_loc2_.uiClass.ctr_buffs,"buffs",param1);
         }
         else if(this._currentBuffsOwnerId == param1)
         {
            this.uiApi.unloadUi("buffs");
         }
         else
         {
            this._currentBuffsOwnerId = param1;
            this.uiApi.unloadUi("buffs");
            this.uiApi.loadUiInside("buffs",_loc2_.uiClass.ctr_buffs,"buffs",param1);
         }
      }
      
      private function onCharacterLevelUp(param1:uint, param2:uint, param3:uint, param4:uint, param5:Object, param6:Boolean, param7:int) : void
      {
         _newLevel = param1;
      }
      
      private function onLevelUiClosed() : void
      {
         this.uiApi.loadUi("fightResult","fightResult",this._fightEndParams);
      }
      
      private function onSpectatorWantLeave() : void
      {
         this.uiApi.unloadUi("timeline");
         this.uiApi.unloadUi("fighterInfo");
         if(this.uiApi.getUi("buffs"))
         {
            this.uiApi.unloadUi("buffs");
         }
         if(this.uiApi.getUi("turnStart"))
         {
            this.uiApi.unloadUi("turnStart");
         }
         if(this.uiApi.getUi("challengeDisplay"))
         {
            this.uiApi.unloadUi("challengeDisplay");
         }
         if(this.uiApi.getUi("spectatorPanel"))
         {
            this.uiApi.unloadUi("spectatorPanel");
         }
         if(this.uiApi.getUi("fightIdols"))
         {
            this.uiApi.unloadUi("fightIdols");
         }
         this._currentFightStartDate = 0;
         this._currentFightAttackersName = "";
         this._currentFightDefendersName = "";
      }
      
      private function onSpectateUpdate(param1:Number, param2:String = "", param3:String = "") : void
      {
         if(param1 > 0)
         {
            this._currentFightStartDate = param1;
         }
         if(param2 != "")
         {
            this._currentFightAttackersName = param2;
         }
         if(param3 != "")
         {
            this._currentFightDefendersName = param3;
         }
         var _loc4_:* = this.uiApi.getUi("banner");
         if(_loc4_ && !this.uiApi.getUi("spectatorPanel"))
         {
            this.uiApi.loadUiInside("spectatorPanel",_loc4_.uiClass.spectatorUiCtr,"spectatorPanel",[this._currentFightStartDate,this._currentFightAttackersName,this._currentFightDefendersName]);
         }
      }
      
      private function onGameFightStarting(... rest) : void
      {
         FightTexts.cacheFighterName = new Dictionary();
         this._preparationPhase = true;
         this.uiApi.unloadUi("fightResult");
         if(!this.uiApi.getUi("timeline"))
         {
            this.uiApi.loadUi("timeline","timeline");
         }
         var _loc2_:* = this.uiApi.getUi("banner");
         if(_loc2_ && !this.uiApi.getUi("fighterInfo"))
         {
            this.uiApi.loadUiInside("fighterInfo",_loc2_.uiClass.subUiCtr);
         }
      }
      
      private function onGameFightStart(... rest) : void
      {
         this._preparationPhase = false;
      }
      
      private function onAfkModeChanged(param1:Boolean) : void
      {
         if(param1 && !this._afkPopup)
         {
            this._afkPopup = this.modCommon.openPopup(this.uiApi.getText("ui.fight.inactivityTitle"),this.uiApi.getText("ui.fight.inactivityMessage"),[this.uiApi.getText("ui.common.ok")],[this.onQuitAfk],this.onQuitAfk,this.onQuitAfk);
         }
      }
      
      private function onQuitAfk() : void
      {
         this._afkPopup = null;
      }
      
      private function onFightEventsTimer(param1:TimerEvent) : void
      {
         FightTexts.writeLog();
      }
      
      public function onChallengeInfoUpdate(param1:Object) : void
      {
         if(!this.uiApi.getUi("challengeDisplay"))
         {
            this.uiApi.loadUi("challengeDisplay","challengeDisplay",{"challenges":param1});
         }
      }
      
      private function onShowSwapPositionRequestMenu(param1:uint, param2:Boolean) : void
      {
         var _loc3_:Array = new Array();
         _loc3_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.companion.switchPlaces")));
         if(param2)
         {
            _loc3_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.accept"),this.onAccept,[param1]));
         }
         _loc3_.push(this.modContextMenu.createContextMenuItemObject(!!param2?this.uiApi.getText("ui.common.refuse"):this.uiApi.getText("ui.common.cancel"),this.onRefuse,[param1]));
         this.modContextMenu.createContextMenu(_loc3_,null,null,"swapPositionMenu");
      }
      
      private function onAccept(param1:uint) : void
      {
         this.sysApi.sendAction(new GameFightPlacementSwapPositionsAccept(param1));
      }
      
      private function onRefuse(param1:uint) : void
      {
         this.sysApi.sendAction(new GameFightPlacementSwapPositionsCancel(param1));
      }
      
      private function onIdolFightPreparationUpdate(param1:Number, param2:Object) : void
      {
         if(!this.uiApi.getUi("fightIdols"))
         {
            this.uiApi.loadUi("fightIdols","fightIdols",[param1,param2,false]);
         }
      }
      
      private function onFightIdolList(param1:Object) : void
      {
         if(!this.uiApi.getUi("fightIdols"))
         {
            this.uiApi.loadUi("fightIdols","fightIdols",[-1,param1,true]);
         }
      }
   }
}
