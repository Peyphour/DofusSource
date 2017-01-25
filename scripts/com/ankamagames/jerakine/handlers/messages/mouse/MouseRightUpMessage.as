package com.ankamagames.jerakine.handlers.messages.mouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseRightUpMessage extends MouseMessage
   {
       
      
      public function MouseRightUpMessage()
      {
         super();
      }
      
      public static function create(param1:InteractiveObject, param2:MouseEvent, param3:MouseMessage = null) : MouseRightUpMessage
      {
         if(!param3)
         {
            param3 = new MouseRightUpMessage();
         }
         return MouseMessage.create(param1,param2,param3) as MouseRightUpMessage;
      }
   }
}
