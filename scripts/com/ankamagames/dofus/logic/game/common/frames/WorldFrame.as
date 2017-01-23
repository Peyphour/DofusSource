package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameRefreshMonsterBoostsMessage;
   import com.ankamagames.dofus.network.messages.game.modificator.AreaFightModificatorUpdateMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterBoosts;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class WorldFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(WorldFrame));
       
      
      private var _settings:Array = null;
      
      private var _currentFightModificator:int = -1;
      
      private var _monsterBoosts:Vector.<MonsterBoosts>;
      
      private var _raceBoosts:Vector.<MonsterBoosts>;
      
      public function WorldFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get settings() : Array
      {
         return this._settings;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:AreaFightModificatorUpdateMessage = null;
         var _loc3_:GameRefreshMonsterBoostsMessage = null;
         var _loc4_:String = null;
         switch(true)
         {
            case param1 is AreaFightModificatorUpdateMessage:
               _loc2_ = param1 as AreaFightModificatorUpdateMessage;
               if(this._currentFightModificator != _loc2_.spellPairId)
               {
                  KernelEventsManager.getInstance().processCallback(QuestHookList.AreaFightModificatorUpdate,_loc2_.spellPairId);
                  if(_loc2_.spellPairId > -1)
                  {
                     if(this._currentFightModificator > -1)
                     {
                        _loc4_ = I18n.getUiText("ui.spell.newFightModficator",[SpellPair.getSpellPairById(_loc2_.spellPairId).name]);
                     }
                     else
                     {
                        _loc4_ = I18n.getUiText("ui.spell.currentFightModficator",[SpellPair.getSpellPairById(_loc2_.spellPairId).name]);
                     }
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc4_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
                  this._currentFightModificator = _loc2_.spellPairId;
               }
               return true;
            case param1 is GameRefreshMonsterBoostsMessage:
               _loc3_ = param1 as GameRefreshMonsterBoostsMessage;
               this._monsterBoosts = _loc3_.monsterBoosts;
               this._raceBoosts = _loc3_.familyBoosts;
               return true;
            default:
               return false;
         }
      }
      
      public function getMonsterXpBoostMultiplier(param1:int) : Number
      {
         var _loc2_:MonsterBoosts = this.getMonsterBoost(param1);
         return (!!_loc2_?_loc2_.xpBoost / 100:1) * this.getRaceXpBoostMultiplier(Monster.getMonsterById(param1).race);
      }
      
      public function getMonsterDropBoostMultiplier(param1:int) : Number
      {
         var _loc2_:MonsterBoosts = this.getMonsterBoost(param1);
         return (!!_loc2_?_loc2_.dropBoost / 100:1) * this.getRaceDropBoostMultiplier(Monster.getMonsterById(param1).race);
      }
      
      public function getRaceXpBoostMultiplier(param1:int) : Number
      {
         var _loc2_:MonsterBoosts = this.getRaceBoost(param1);
         return !!_loc2_?Number(_loc2_.xpBoost / 100):Number(1);
      }
      
      public function getRaceDropBoostMultiplier(param1:int) : Number
      {
         var _loc2_:MonsterBoosts = this.getRaceBoost(param1);
         return !!_loc2_?Number(_loc2_.dropBoost / 100):Number(1);
      }
      
      private function getMonsterBoost(param1:uint) : MonsterBoosts
      {
         var _loc2_:MonsterBoosts = null;
         for each(_loc2_ in this._monsterBoosts)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function getRaceBoost(param1:int) : MonsterBoosts
      {
         var _loc2_:MonsterBoosts = null;
         for each(_loc2_ in this._raceBoosts)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}
