package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.internalDatacenter.communication.DelayedActionItem;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import flash.utils.getTimer;
   
   public class DelayedActionTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var delayedActionBackground:Texture;
      
      private var _currentTargetTs:Number;
      
      private var _targetTs:Number;
      
      private var _lastTs:Number;
      
      public function DelayedActionTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         if(param1.zoom > 1)
         {
            this.uiApi.me().scaleX = param1.zoom;
            this.uiApi.me().scaleY = param1.zoom;
         }
         this._currentTargetTs = 0;
         this._targetTs = DelayedActionItem(param1.data).endTime;
         this._lastTs = getTimer();
         this.sysApi.addEventListener(this.updateProgress,"delayed item use tooltip");
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
      }
      
      private function updateProgress() : void
      {
         this._currentTargetTs = this._currentTargetTs + (getTimer() - this._lastTs);
         this._lastTs = getTimer();
         var _loc1_:uint = Math.min(100,Math.ceil(this._currentTargetTs / this._targetTs * 100));
         this.delayedActionBackground.gotoAndStop = _loc1_;
      }
      
      public function unload() : void
      {
         this.sysApi.removeEventListener(this.updateProgress);
      }
   }
}
