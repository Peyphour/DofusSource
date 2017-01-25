package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.logic.game.common.misc.ISpellCastProvider;
   import com.ankamagames.dofus.scripts.SpellScriptManager;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.Callback;
   import flash.utils.getTimer;
   
   public class FightPlaySpellScriptStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:Number;
      
      private var _cellId:int;
      
      private var _spellId:int;
      
      private var _spellRank:uint;
      
      private var _portalIds:Vector.<int>;
      
      private var _fxScriptId:int;
      
      private var _scriptStarted:uint;
      
      private var _spellCastProvider:ISpellCastProvider;
      
      public function FightPlaySpellScriptStep(param1:int, param2:Number, param3:int, param4:int, param5:uint, param6:ISpellCastProvider)
      {
         super();
         this._fxScriptId = param1;
         this._spellId = param4;
         this._spellRank = param5;
         this._spellCastProvider = param6;
         if(this._fxScriptId == 0)
         {
            return;
         }
         var _loc7_:Spell = Spell.getSpellById(this._spellId);
         if(!_loc7_)
         {
            return;
         }
         var _loc8_:SpellLevel = _loc7_.getSpellLevel(this._spellRank);
         if(!_loc8_ || !_loc8_.playAnimation)
         {
            return;
         }
         if(this._spellCastProvider.castingSpell.spell)
         {
            _log.info("Executing SpellScript" + this._fxScriptId + " for spell \'" + this._spellCastProvider.castingSpell.spell.name + "\' (" + this._spellCastProvider.castingSpell.spell.id + ")");
         }
         else
         {
            _log.info("Executing SpellScript" + this._fxScriptId + " for unknown spell");
         }
         this._scriptStarted = getTimer();
         SpellScriptManager.getInstance().runSpellScript(this._fxScriptId,this._spellCastProvider,new Callback(this.scriptEnd,true),new Callback(this.scriptEnd,false));
      }
      
      public function get stepType() : String
      {
         return "spellCast";
      }
      
      override public function start() : void
      {
         executeCallbacks();
      }
      
      private function scriptEnd(param1:Boolean = false) : void
      {
         var _loc2_:uint = getTimer() - this._scriptStarted;
         if(!param1)
         {
            _log.warn("Script failed during a fight sequence, but still took " + _loc2_ + "ms.");
         }
         else
         {
            _log.info("Script successfuly executed in " + _loc2_ + "ms.");
         }
      }
   }
}
