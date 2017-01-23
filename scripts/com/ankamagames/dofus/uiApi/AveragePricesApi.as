package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AveragePricesFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class AveragePricesApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function AveragePricesApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(AveragePricesApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Trusted]
      public function getItemAveragePrice(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:AveragePricesFrame = null;
         if(this.dataAvailable())
         {
            _loc3_ = Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
            _loc2_ = _loc3_.pricesData.items["item" + param1];
         }
         return _loc2_;
      }
      
      [Trusted]
      public function getItemAveragePriceString(param1:*, param2:Boolean = false, param3:String = "", param4:String = "") : String
      {
         var _loc6_:int = 0;
         var _loc7_:* = false;
         var _loc5_:String = "";
         if(param1.exchangeable)
         {
            _loc6_ = this.getItemAveragePrice(param1.objectGID);
            _loc7_ = _loc6_ > 0;
            _loc5_ = _loc5_ + ((!!param2?"\n":"") + I18n.getUiText("ui.item.averageprice") + I18n.getUiText("ui.common.colon") + param3 + (!!_loc7_?StringUtils.kamasToString(_loc6_):I18n.getUiText("ui.item.averageprice.unavailable")) + param4);
            if(_loc7_ && param1.quantity > 1)
            {
               _loc5_ = _loc5_ + ("\n" + I18n.getUiText("ui.item.averageprice.stack") + I18n.getUiText("ui.common.colon") + param3 + StringUtils.kamasToString(_loc6_ * param1.quantity) + param4);
            }
         }
         return _loc5_;
      }
      
      [Trusted]
      public function dataAvailable() : Boolean
      {
         var _loc1_:AveragePricesFrame = Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
         return _loc1_.dataAvailable;
      }
   }
}
