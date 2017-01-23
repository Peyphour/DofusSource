package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.EstateFrame;
   import com.ankamagames.dofus.logic.game.roleplay.types.Estate;
   
   public class HyperlinkShowEstate
   {
       
      
      public function HyperlinkShowEstate()
      {
         super();
      }
      
      public static function click(param1:int) : void
      {
         var _loc3_:Estate = null;
         var _loc4_:UiModule = null;
         var _loc2_:EstateFrame = Kernel.getWorker().getFrame(EstateFrame) as EstateFrame;
         if(_loc2_)
         {
            _loc3_ = _loc2_.estateList[param1];
            if(_loc3_)
            {
               Berilia.getInstance().unloadUi("estateForm");
               _loc4_ = UiModuleManager.getInstance().getModule("Ankama_TradeCenter");
               Berilia.getInstance().loadUi(_loc4_,_loc4_.uis["estateForm"],"estateForm",[_loc2_.estateType,_loc3_.infos]);
            }
         }
      }
   }
}
