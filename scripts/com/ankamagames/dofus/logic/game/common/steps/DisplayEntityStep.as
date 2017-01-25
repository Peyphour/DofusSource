package com.ankamagames.dofus.logic.game.common.steps
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.tiphon.types.look.EntityLookParser;
   
   public class DisplayEntityStep extends AbstractSequencable
   {
       
      
      private var _id:Number;
      
      private var _look:String;
      
      private var _cellId:uint;
      
      private var _direction:int;
      
      public function DisplayEntityStep(param1:Number, param2:String, param3:uint, param4:int)
      {
         super();
         this._id = param1;
         this._look = param2;
         this._cellId = param3;
         this._direction = param4;
      }
      
      override public function start() : void
      {
         var _loc1_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         var _loc2_:GameContextActorInformations = new GameContextActorInformations();
         var _loc3_:EntityDispositionInformations = new EntityDispositionInformations();
         _loc3_.initEntityDispositionInformations(this._cellId,this._direction);
         _loc2_.initGameContextActorInformations(this._id,EntityLookAdapter.toNetwork(EntityLookParser.fromString(this._look)),_loc3_);
         _loc1_.addOrUpdateActor(_loc2_);
         executeCallbacks();
      }
   }
}
