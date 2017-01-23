package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.fight.FighterInformations;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2actions.GameContextQuit;
   import d2actions.ToggleDematerialization;
   import d2actions.TogglePointCell;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.BuffAdd;
   import d2hooks.BuffDispell;
   import d2hooks.BuffRemove;
   import d2hooks.BuffUpdate;
   import d2hooks.DematerializationChanged;
   import d2hooks.FightEvent;
   import d2hooks.FightersListUpdated;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightStart;
   import d2hooks.GameFightTurnStart;
   import d2hooks.ShowCell;
   import d2hooks.ShowTacticMode;
   import d2hooks.SpectateUpdate;
   import d2hooks.UpdatePreFightersList;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class SpectatorPanel
   {
      
      private static var ATTACKER_ID:int = 0;
      
      private static var DEFENDER_ID:int = 1;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var fightApi:FightApi;
      
      public var timeApi:TimeApi;
      
      public var bindsApi:BindsApi;
      
      public var configApi:ConfigApi;
      
      public var mainCtr:GraphicContainer;
      
      public var entityDisplayer:EntityDisplayer;
      
      public var lbl_attackersName:Label;
      
      public var lbl_defendersName:Label;
      
      public var lbl_time:Label;
      
      public var lbl_attackersLife:Label;
      
      public var lbl_defendersLife:Label;
      
      public var btn_spectaTactic:ButtonContainer;
      
      public var btn_spectaCreature:ButtonContainer;
      
      public var btn_spectaPointCell:ButtonContainer;
      
      public var btn_spectaLeave:ButtonContainer;
      
      private var LIFEPOINTS_STR:String;
      
      private var _fightStartTime:Number;
      
      private var _ticker:Object;
      
      private var _attackersName:String;
      
      private var _defendersName:String;
      
      private var _lifePoints:Array;
      
      private var _attackersLifeById:Dictionary;
      
      private var _defendersLifeById:Dictionary;
      
      private var _shortcutColor:String;
      
      private var _pokemonModeActivated:Boolean = false;
      
      public var pb_defenders:ProgressBar;
      
      public function SpectatorPanel()
      {
         this._lifePoints = new Array();
         this._attackersLifeById = new Dictionary();
         this._defendersLifeById = new Dictionary();
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(FightersListUpdated,this.onGameFightTurnListUpdated);
         this.sysApi.addHook(UpdatePreFightersList,this.onUpdatePreFightersList);
         this.sysApi.addHook(SpectateUpdate,this.onSpectateUpdate);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(GameFightStart,this.onGameFightStart);
         this.sysApi.addHook(GameFightTurnStart,this.onTurnStart);
         this.sysApi.addHook(FightEvent,this.onFightEvent);
         this.sysApi.addHook(BuffAdd,this.onBuffAdd);
         this.sysApi.addHook(BuffDispell,this.onBuffDispell);
         this.sysApi.addHook(BuffRemove,this.onBuffRemove);
         this.sysApi.addHook(BuffUpdate,this.onBuffUpdate);
         this.sysApi.addHook(d2hooks.ShowTacticMode,this.onShowTacticMode);
         this.sysApi.addHook(DematerializationChanged,this.onDematerializationChanged);
         this.sysApi.addHook(ShowCell,this.onShowCell);
         this.uiApi.addComponentHook(this.btn_spectaTactic,"onRollOver");
         this.uiApi.addComponentHook(this.btn_spectaTactic,"onRollOut");
         this.uiApi.addComponentHook(this.btn_spectaCreature,"onRollOver");
         this.uiApi.addComponentHook(this.btn_spectaCreature,"onRollOut");
         this.uiApi.addComponentHook(this.btn_spectaPointCell,"onRollOver");
         this.uiApi.addComponentHook(this.btn_spectaPointCell,"onRollOut");
         this.uiApi.addComponentHook(this.btn_spectaLeave,"onRollOver");
         this.uiApi.addComponentHook(this.btn_spectaLeave,"onRollOut");
         this.LIFEPOINTS_STR = this.uiApi.getText("ui.short.lifePoints");
         this._fightStartTime = param1[0];
         this._attackersName = param1[1];
         this._defendersName = param1[2];
         if(this._fightStartTime > 0)
         {
            this.updateClock(null);
            this._ticker = new Timer(1000);
            this._ticker.addEventListener(TimerEvent.TIMER,this.updateClock);
            this._ticker.start();
         }
         else
         {
            this.lbl_time.text = "-";
         }
         if(this._attackersName != "")
         {
            this.lbl_attackersName.text = this._attackersName;
         }
         else
         {
            this.lbl_attackersName.text = this.uiApi.getText("ui.common.attackers");
         }
         if(this._defendersName != "")
         {
            this.lbl_defendersName.text = this._defendersName;
         }
         else
         {
            this.lbl_defendersName.text = this.uiApi.getText("ui.common.defenders");
         }
         this.entityDisplayer.view = "timeline";
         this.onGameFightTurnListUpdated();
      }
      
      public function unload() : void
      {
         if(this._ticker)
         {
            this._ticker.removeEventListener(TimerEvent.TIMER,this.updateClock);
            this._ticker.stop();
         }
      }
      
      private function updateClock(param1:TimerEvent) : void
      {
         var _loc2_:Number = new Date().getTime() - this._fightStartTime * 1000;
         this.lbl_time.text = "" + this.timeApi.getShortDuration(_loc2_,true);
      }
      
      private function updateLifeOfOneFighter(param1:Number) : void
      {
         var _loc2_:FighterInformations = this.fightApi.getFighterInformations(param1);
         if(_loc2_ && (!_loc2_.summoned || _loc2_.fighterId > -1))
         {
            if(_loc2_.team == "challenger")
            {
               this._attackersLifeById[param1] = _loc2_.lifePoints + _loc2_.shieldPoints;
            }
            else if(_loc2_.team == "defender")
            {
               this._defendersLifeById[param1] = _loc2_.lifePoints + _loc2_.shieldPoints;
            }
            else if(this._attackersLifeById[param1])
            {
               this._attackersLifeById[param1] = 0;
            }
            else if(this._defendersLifeById[param1])
            {
               this._defendersLifeById[param1] = 0;
            }
            this.updateLifeBalance();
         }
      }
      
      private function updateLifeBalance() : void
      {
         var _loc1_:int = 0;
         this._lifePoints[ATTACKER_ID] = 0;
         for each(_loc1_ in this._attackersLifeById)
         {
            this._lifePoints[ATTACKER_ID] = this._lifePoints[ATTACKER_ID] + _loc1_;
         }
         this._lifePoints[DEFENDER_ID] = 0;
         for each(_loc1_ in this._defendersLifeById)
         {
            this._lifePoints[DEFENDER_ID] = this._lifePoints[DEFENDER_ID] + _loc1_;
         }
         this.lbl_attackersLife.text = this._lifePoints[ATTACKER_ID] + " " + this.LIFEPOINTS_STR;
         this.lbl_defendersLife.text = this._lifePoints[DEFENDER_ID] + " " + this.LIFEPOINTS_STR;
         this.pb_defenders.value = 1 - this._lifePoints[ATTACKER_ID] / (this._lifePoints[DEFENDER_ID] + this._lifePoints[ATTACKER_ID]);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_spectaTactic:
               this.sysApi.sendAction(new d2actions.ShowTacticMode());
               break;
            case this.btn_spectaLeave:
               this.sysApi.sendAction(new GameContextQuit());
               break;
            case this.btn_spectaPointCell:
               this.btn_spectaPointCell.selected = !this.btn_spectaPointCell.selected;
               this.sysApi.sendAction(new TogglePointCell());
               break;
            case this.btn_spectaCreature:
               this._pokemonModeActivated = !this._pokemonModeActivated;
               this.configApi.setConfigProperty("dofus","creaturesFightMode",this._pokemonModeActivated);
               this.sysApi.sendAction(new ToggleDematerialization());
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc6_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:String = null;
         switch(param1)
         {
            case this.btn_spectaLeave:
               _loc2_ = this.uiApi.getText("ui.fight.option.giveupSpectator");
               break;
            case this.btn_spectaPointCell:
               _loc2_ = this.uiApi.getText("ui.fight.option.flagHelp");
               _loc5_ = this.bindsApi.getShortcutBindStr("showCell");
               break;
            case this.btn_spectaCreature:
               if(this.btn_spectaCreature.selected)
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.noCreatureMode");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.creatureMode");
               }
               _loc5_ = this.bindsApi.getShortcutBindStr(ShortcutHookListEnum.TOGGLE_DEMATERIALIZATION);
               break;
            case this.btn_spectaTactic:
               if(this.btn_spectaTactic.selected)
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.noTacticMode");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.fight.option.tacticMode");
               }
               _loc5_ = this.bindsApi.getShortcutBindStr(ShortcutHookListEnum.SHOW_TACTIC_MODE);
         }
         if(_loc5_)
         {
            if(!this._shortcutColor)
            {
               this._shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
               this._shortcutColor = this._shortcutColor.replace("0x","#");
            }
            if(_loc2_)
            {
               _loc6_ = this.uiApi.textTooltipInfo(_loc2_ + " <font color=\'" + this._shortcutColor + "\'>(" + _loc5_ + ")</font>");
            }
         }
         else
         {
            _loc6_ = this.uiApi.textTooltipInfo(_loc2_);
         }
         this.uiApi.showTooltip(_loc6_,param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onGameFightTurnListUpdated() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:FighterInformations = null;
         var _loc1_:Object = this.fightApi.getFighters();
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:int = _loc1_.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = this.fightApi.getFighterInformations(_loc3_);
            if(_loc4_ && (!_loc4_.summoned || _loc4_.fighterId > -1))
            {
               if(_loc4_.team == "challenger")
               {
                  this._attackersLifeById[_loc3_] = _loc4_.lifePoints + _loc4_.shieldPoints;
               }
               else
               {
                  this._defendersLifeById[_loc3_] = _loc4_.lifePoints + _loc4_.shieldPoints;
               }
            }
            _loc2_--;
         }
         this.updateLifeBalance();
      }
      
      private function onUpdatePreFightersList(param1:Number = 0) : void
      {
         this.updateLifeOfOneFighter(param1);
      }
      
      private function onGameFightStart(... rest) : void
      {
         if(this._fightStartTime == 0)
         {
            this._fightStartTime = new Date().getTime() / 1000;
            this.updateClock(null);
            this._ticker = new Timer(1000);
            this._ticker.addEventListener(TimerEvent.TIMER,this.updateClock);
            this._ticker.start();
         }
      }
      
      private function onTurnStart(param1:Number, param2:uint, param3:uint, param4:Boolean) : void
      {
         this.entityDisplayer.look = this.fightApi.getFighterInformations(param1).look;
         this.entityDisplayer.setAnimationAndDirection("AnimArtwork",1);
         this.entityDisplayer.visible = true;
      }
      
      private function onSpectateUpdate(param1:Number, param2:String = "", param3:String = "") : void
      {
         if(param1 == 0)
         {
            return;
         }
         this._fightStartTime = param1;
         this.updateClock(null);
         this._ticker = new Timer(1000);
         this._ticker.addEventListener(TimerEvent.TIMER,this.updateClock);
         this._ticker.start();
      }
      
      public function onBuffAdd(param1:uint, param2:Number) : void
      {
         this.updateLifeOfOneFighter(param2);
      }
      
      public function onBuffRemove(param1:*, param2:Number, param3:String) : void
      {
         this.updateLifeOfOneFighter(param2);
      }
      
      public function onBuffUpdate(param1:uint, param2:Number) : void
      {
         this.updateLifeOfOneFighter(param2);
      }
      
      public function onBuffDispell(param1:Number) : void
      {
         this.updateLifeOfOneFighter(param1);
      }
      
      private function onFightEvent(param1:String, param2:Object, param3:Object = null) : void
      {
         var _loc6_:Number = NaN;
         if(param3 == null)
         {
            param3 = new Array();
            if(param2.length)
            {
               param3[0] = param2[0];
            }
         }
         var _loc4_:int = param3.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param3[_loc5_];
            switch(param1)
            {
               case "fighterLifeGain":
               case "fighterLifeLoss":
               case "fighterShieldLoss":
               case "fighterGotDispelled":
               case "fighterTemporaryBoosted":
               case "fighterDeath":
               case "fighterLeave":
                  this.updateLifeOfOneFighter(_loc6_);
                  break;
               case "fighterSummoned":
            }
            _loc5_++;
         }
      }
      
      private function onGameFightEnd(param1:Object) : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onShowTacticMode(param1:Boolean) : void
      {
         this.btn_spectaTactic.selected = param1;
      }
      
      private function onDematerializationChanged(param1:Boolean) : void
      {
         this.btn_spectaCreature.selected = param1;
      }
      
      private function onShowCell() : void
      {
         this.btn_spectaPointCell.selected = false;
      }
   }
}
