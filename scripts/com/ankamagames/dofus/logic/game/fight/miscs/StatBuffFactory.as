package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.dofus.logic.game.fight.types.BlockEvadeBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   
   public class StatBuffFactory
   {
       
      
      public function StatBuffFactory()
      {
         super();
      }
      
      public static function createStatBuff(param1:FightTemporaryBoostEffect, param2:CastingSpell, param3:uint) : StatBuff
      {
         var _loc4_:StatBuff = null;
         switch(param3)
         {
            case ActionIdConverter.ACTION_CHARACTER_BOOST_DODGE:
            case ActionIdConverter.ACTION_CHARACTER_BOOST_TACKLE:
            case ActionIdConverter.ACTION_CHARACTER_DEBOOST_DODGE:
            case ActionIdConverter.ACTION_CHARACTER_DEBOOST_TACKLE:
               _loc4_ = new BlockEvadeBuff(param1,param2,param3);
               break;
            default:
               _loc4_ = new StatBuff(param1,param2,param3);
         }
         return _loc4_;
      }
   }
}
