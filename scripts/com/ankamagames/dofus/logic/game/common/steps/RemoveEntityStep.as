package com.ankamagames.dofus.logic.game.common.steps
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.scripts.api.EntityApi;
   import com.ankamagames.jerakine.lua.LuaPlayer;
   import com.ankamagames.jerakine.script.ScriptsManager;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class RemoveEntityStep extends AbstractSequencable
   {
       
      
      private var _id:Number;
      
      public function RemoveEntityStep(param1:Number)
      {
         super();
         this._id = param1;
      }
      
      override public function start() : void
      {
         var _loc3_:EntityApi = null;
         var _loc1_:GameContextRemoveElementMessage = new GameContextRemoveElementMessage();
         _loc1_.initGameContextRemoveElementMessage(this._id);
         Kernel.getWorker().process(_loc1_);
         var _loc2_:LuaPlayer = ScriptsManager.getInstance().getPlayer(ScriptsManager.LUA_PLAYER) as LuaPlayer;
         if(_loc2_)
         {
            _loc3_ = ScriptsManager.getInstance().getPlayerApi(_loc2_,"EntityApi") as EntityApi;
            if(_loc3_)
            {
               _loc3_.removeEntity(this._id);
            }
         }
         executeCallbacks();
      }
   }
}
