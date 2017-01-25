package com.ankamagames.berilia.types.tooltip.event
{
   import flash.events.Event;
   
   public class TooltipEvent extends Event
   {
      
      public static const TOOLTIPS_ORDERED:String = "TooltipEvent.TOOLTIPS_ORDERED";
       
      
      public function TooltipEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
