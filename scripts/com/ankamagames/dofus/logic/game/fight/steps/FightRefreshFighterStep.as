package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightRefreshFighterStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _infos:GameContextActorInformations;
      
      public function FightRefreshFighterStep(param1:GameContextActorInformations)
      {
         super();
         this._infos = param1;
      }
      
      public function get stepType() : String
      {
         return "refreshFighter";
      }
      
      override public function start() : void
      {
         var _loc1_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc2_:GameContextActorInformations = _loc1_.getEntityInfos(this._infos.contextualId);
         if(_loc2_)
         {
            _loc2_.disposition = this._infos.disposition;
            _loc2_.look = this._infos.look;
            _loc1_.setRealFighterLook(_loc2_.contextualId,this._infos.look);
            _loc1_.updateActor(_loc2_,true);
         }
         executeCallbacks();
      }
   }
}
