package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.TaxCollectorsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   
   public class HyperlinkTaxCollectorCollected
   {
       
      
      public function HyperlinkTaxCollectorCollected()
      {
         super();
      }
      
      public static function showCollectedTaxCollector(param1:uint) : void
      {
         var _loc2_:TaxCollectorWrapper = TaxCollectorsManager.getInstance().collectedTaxCollectors[param1];
         if(_loc2_)
         {
            KernelEventsManager.getInstance().processCallback(HookList.ShowCollectedTaxCollector,_loc2_);
         }
      }
      
      public static function rollOver(param1:int, param2:int, param3:uint) : void
      {
      }
   }
}
