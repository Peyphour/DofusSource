package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   
   public class HyperlinkShowOfflineSales
   {
       
      
      public function HyperlinkShowOfflineSales()
      {
         super();
      }
      
      public static function showOfflineSales(param1:uint, param2:uint) : void
      {
         var _loc3_:ChatFrame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
         KernelEventsManager.getInstance().processCallback(HookList.OpenOfflineSales,param1,_loc3_.offlineSales,_loc3_.getUnsoldItems(param2));
      }
   }
}
