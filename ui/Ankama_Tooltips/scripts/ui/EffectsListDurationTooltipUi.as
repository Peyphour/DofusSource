package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class EffectsListDurationTooltipUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      private var _skip:Boolean = true;
      
      private var _timerHide:Timer;
      
      public var backgroundCtr:GraphicContainer;
      
      public var lbl_text:Label;
      
      public function EffectsListDurationTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onRollOver(param1:Object) : void
      {
      }
      
      public function onRollOut(param1:Object) : void
      {
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
      }
      
      public function unload() : void
      {
      }
   }
}
