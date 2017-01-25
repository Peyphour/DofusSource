package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.enums.PortalAnimationEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.PathElement;
   
   public class FightMarkActivateStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _markId:int;
      
      private var _activate:Boolean;
      
      public function FightMarkActivateStep(param1:int, param2:Boolean)
      {
         super();
         this._markId = param1;
         this._activate = param2;
      }
      
      public function get stepType() : String
      {
         return "markActivate";
      }
      
      override public function start() : void
      {
         var _loc2_:Glyph = null;
         var _loc3_:FightTurnFrame = null;
         var _loc4_:PathElement = null;
         var _loc5_:Boolean = false;
         var _loc1_:MarkInstance = MarkedCellsManager.getInstance().getMarkDatas(this._markId);
         if(_loc1_)
         {
            _loc1_.active = this._activate;
            _loc2_ = MarkedCellsManager.getInstance().getGlyph(_loc1_.markId);
            if(_loc2_)
            {
               if(_loc1_.markType == GameActionMarkTypeEnum.PORTAL)
               {
                  _loc2_.setAnimation(!!this._activate?PortalAnimationEnum.STATE_NORMAL:PortalAnimationEnum.STATE_DISABLED);
               }
            }
            _loc3_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            if(_loc3_ && _loc3_.myTurn && _loc3_.lastPath)
            {
               for each(_loc4_ in _loc3_.lastPath.path)
               {
                  if(_loc1_.cells.indexOf(_loc4_.cellId) != -1)
                  {
                     _loc5_ = true;
                     break;
                  }
               }
               if(_loc5_)
               {
                  _loc3_.updatePath();
               }
            }
         }
         executeCallbacks();
      }
   }
}
