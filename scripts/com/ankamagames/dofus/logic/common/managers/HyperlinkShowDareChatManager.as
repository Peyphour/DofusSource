package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.internalDatacenter.dare.DareWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.DareFrame;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class HyperlinkShowDareChatManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkShowDareChatManager));
      
      private static var _dareList:Array = new Array();
      
      private static var _dareId:Number = 0;
       
      
      public function HyperlinkShowDareChatManager()
      {
         super();
      }
      
      public static function showDare(param1:Number) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.dareId = param1;
         _loc2_.forceOpen = true;
         TooltipManager.hideAll();
         KernelEventsManager.getInstance().processCallback(SocialHookList.OpenDareSearch,"" + param1,"searchFilterId");
      }
      
      public static function addDare(param1:Number) : String
      {
         var _loc4_:* = null;
         var _loc2_:DareFrame = Kernel.getWorker().getFrame(DareFrame) as DareFrame;
         var _loc3_:DareWrapper = _loc2_.getDareById(param1);
         if(_loc3_)
         {
            _dareList[_dareId] = _loc3_;
            _loc4_ = "{chatdare," + param1 + "::" + getDareName(param1) + "}";
            _dareId++;
            return _loc4_;
         }
         return getDareName(param1);
      }
      
      public static function getDareName(param1:Number) : String
      {
         return "[" + I18n.getUiText("ui.dare.dareShort") + " " + param1 + "]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:Number = 0) : void
      {
         var _loc4_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc5_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.dare.showInformations"));
         TooltipManager.show(_loc5_,_loc4_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
