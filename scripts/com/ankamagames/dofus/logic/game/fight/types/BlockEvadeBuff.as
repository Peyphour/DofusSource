package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   
   public class BlockEvadeBuff extends StatBuff
   {
       
      
      public function BlockEvadeBuff(param1:FightTemporaryBoostEffect = null, param2:CastingSpell = null, param3:int = 0)
      {
         super(param1,param2,param3);
      }
      
      override public function onApplyed() : void
      {
         super.onApplyed();
         this.updateMovementPath();
      }
      
      override public function onRemoved() : void
      {
         super.onRemoved();
         this.updateMovementPath();
      }
      
      private function updateMovementPath() : void
      {
         var _loc1_:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(targetId == CurrentPlayedFighterManager.getInstance().currentFighterId && _loc1_ && _loc1_.myTurn && _loc1_.lastPath)
         {
            _loc1_.updatePath();
         }
      }
   }
}
