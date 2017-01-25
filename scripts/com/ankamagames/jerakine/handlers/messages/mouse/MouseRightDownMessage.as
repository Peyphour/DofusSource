package com.ankamagames.jerakine.handlers.messages.mouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseRightDownMessage extends MouseMessage
   {
       
      
      public function MouseRightDownMessage()
      {
         super();
      }
      
      public static function create(param1:InteractiveObject, param2:MouseEvent, param3:MouseMessage = null) : MouseRightDownMessage
      {
         if(!param3)
         {
            param3 = new MouseRightDownMessage();
         }
         return MouseMessage.create(param1,param2,param3) as MouseRightDownMessage;
      }
   }
}
