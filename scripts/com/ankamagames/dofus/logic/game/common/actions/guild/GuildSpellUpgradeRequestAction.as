package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildSpellUpgradeRequestAction implements Action
   {
       
      
      public var spellId:uint;
      
      public function GuildSpellUpgradeRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : GuildSpellUpgradeRequestAction
      {
         var _loc2_:GuildSpellUpgradeRequestAction = new GuildSpellUpgradeRequestAction();
         _loc2_.spellId = param1;
         return _loc2_;
      }
   }
}
