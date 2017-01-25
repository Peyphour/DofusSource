package com.ankamagames.jerakine.handlers.messages.mouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseRightReleaseOutsideMessage extends MouseMessage
   {
       
      
      public function MouseRightReleaseOutsideMessage()
      {
         super();
      }
      
      public static function create(param1:InteractiveObject, param2:MouseEvent, param3:MouseMessage = null) : MouseRightReleaseOutsideMessage
      {
         if(!param3)
         {
            param3 = new MouseRightReleaseOutsideMessage();
         }
         return MouseMessage.create(param1,param2,param3) as MouseRightReleaseOutsideMessage;
      }
   }
}
