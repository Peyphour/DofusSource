package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.dofus.network.messages.authorized.ConsoleMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.jerakine.messages.RegisteringFrame;
   import flash.utils.setTimeout;
   
   public class BenchmarkFrame extends RegisteringFrame
   {
       
      
      private var _subAreaIndex:uint;
      
      public function BenchmarkFrame()
      {
         super();
      }
      
      override protected function registerMessages() : void
      {
         register(MapComplementaryInformationsDataMessage,this.onMapReady);
         register(ConsoleMessage,this.onConsoleMsg);
      }
      
      private function onConsoleMsg(param1:ConsoleMessage) : void
      {
         if(param1.content && param1.content.indexOf("La carte ne doit pas exister, ou n\'est pas accessible ") != -1)
         {
            this.moveToNextMap();
         }
      }
      
      private function onMapReady(param1:MapComplementaryInformationsDataMessage) : void
      {
         setTimeout(this.moveToNextMap,1000);
      }
      
      override public function pushed() : Boolean
      {
         this._subAreaIndex = 0;
         this.moveToNextMap();
         return true;
      }
      
      private function moveToNextMap() : void
      {
         var _loc1_:Array = SubArea.getAllSubArea();
         var _loc2_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc2_.initAdminQuietCommandMessage("moveto " + SubArea(_loc1_[this._subAreaIndex++ % _loc1_.length]).mapIds[0]);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
   }
}
