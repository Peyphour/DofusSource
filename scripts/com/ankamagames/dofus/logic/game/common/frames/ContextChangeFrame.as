package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.PanicMessages;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.GameContextQuitAction;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.GameContextEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextQuitMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class ContextChangeFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ContextChangeFrame));
       
      
      public var mapChangeConnexion:String = "";
      
      public function ContextChangeFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.LOW;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameContextCreateMessage = null;
         var _loc3_:GameContextQuitMessage = null;
         var _loc4_:CurrentMapMessage = null;
         switch(true)
         {
            case param1 is GameContextCreateMessage:
               _loc2_ = param1 as GameContextCreateMessage;
               switch(_loc2_.context)
               {
                  case GameContextEnum.ROLE_PLAY:
                     Kernel.getWorker().addFrame(new RoleplayContextFrame());
                     KernelEventsManager.getInstance().processCallback(HookList.ContextChanged,GameContextEnum.ROLE_PLAY);
                     break;
                  case GameContextEnum.FIGHT:
                     Kernel.getWorker().addFrame(new FightContextFrame());
                     KernelEventsManager.getInstance().processCallback(HookList.ContextChanged,GameContextEnum.FIGHT);
                     break;
                  default:
                     Kernel.panic(PanicMessages.WRONG_CONTEXT_CREATED,[_loc2_.context]);
               }
               return true;
            case param1 is GameContextQuitAction:
               _loc3_ = new GameContextQuitMessage();
               ConnectionsHandler.getConnection().send(_loc3_);
               return true;
            case param1 is CurrentMapMessage:
               _loc4_ = param1 as CurrentMapMessage;
               this.mapChangeConnexion = _loc4_.sourceConnection;
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
