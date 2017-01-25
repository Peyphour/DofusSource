package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class LivingObjectInstructionHandler implements ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InventoryInstructionHandler));
       
      
      public function LivingObjectInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         switch(param2)
         {
            case "floodlivingobject":
               if(SpeakingItemManager.getInstance().speakTimerMinuteDelay != SpeakingItemManager.MINUTE_DELAY)
               {
                  SpeakingItemManager.getInstance().speakTimerMinuteDelay = SpeakingItemManager.MINUTE_DELAY;
               }
               else
               {
                  SpeakingItemManager.getInstance().speakTimerMinuteDelay = 100;
               }
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "floodlivingobject":
               return "Make a flood of talk from living objects.";
            default:
               return "Unknown command \'" + param1 + "\'.";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}
