package com.ankamagames.dofus.logic.game.fight.behaviours
{
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.behaviours.IEntityDeleteBehavior;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   
   public class FightEntityDeleteBehavior implements IEntityDeleteBehavior
   {
      
      private static var _self:FightEntityDeleteBehavior;
       
      
      public function FightEntityDeleteBehavior()
      {
         super();
      }
      
      public static function getInstance() : FightEntityDeleteBehavior
      {
         if(!_self)
         {
            _self = new FightEntityDeleteBehavior();
         }
         return _self;
      }
      
      public function entityDeleted(param1:AnimatedCharacter) : void
      {
         var _loc2_:FightSpellCastFrame = null;
         var _loc3_:FightEntitiesFrame = null;
         var _loc4_:GameFightFighterInformations = null;
         var _loc5_:Selection = null;
         var _loc6_:FightTurnFrame = null;
         if(param1.rootEntity == param1)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
            _loc3_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            if(!_loc3_ || !_loc2_)
            {
               return;
            }
            _loc4_ = !!_loc3_?_loc3_.getEntityInfos(CurrentPlayedFighterManager.getInstance().currentFighterId) as GameFightFighterInformations:null;
            _loc5_ = SelectionManager.getInstance().getSelection("SpellCastRange");
            if(_loc4_ && !_loc2_.hasInvocationPreview && !_loc2_.isTeleportationPreviewEntity(param1.id) && !_loc2_.isReplacementInvocation(param1) && _loc5_ && _loc5_.cells && _loc5_.cells.length && param1.position && SelectionManager.getInstance().isInside(param1.position.cellId,"SpellCastLos"))
            {
               FightSpellCastFrame.updateRangeAndTarget();
            }
            _loc6_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            if(_loc6_ && _loc6_.myTurn)
            {
               _loc6_.updatePath();
            }
         }
      }
   }
}
