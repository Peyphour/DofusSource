package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.atouin.types.sequences.DestroyEntityStep;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   
   public class FightDestroyEntityStep extends DestroyEntityStep implements IFightStep
   {
       
      
      public function FightDestroyEntityStep(param1:IEntity, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
         FightEntitiesHolder.getInstance().unholdEntity(param1.id);
      }
      
      public function get stepType() : String
      {
         return "destroyEntity";
      }
   }
}
