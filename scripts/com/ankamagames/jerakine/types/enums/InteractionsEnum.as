package com.ankamagames.jerakine.types.enums
{
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.utils.errors.JerakineError;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Trusted]
   public class InteractionsEnum
   {
      
      public static const CLICK:uint = 1 << 0;
      
      public static const OVER:uint = 1 << 1;
      
      public static const OUT:uint = 1 << 2;
       
      
      public function InteractionsEnum()
      {
         super();
      }
      
      public static function getEvents(param1:uint) : Array
      {
         switch(param1)
         {
            case CLICK:
               return [MouseEvent.CLICK];
            case OVER:
               return [MouseEvent.MOUSE_OVER];
            case OUT:
               return [MouseEvent.MOUSE_OUT,Event.REMOVED_FROM_STAGE];
            default:
               throw new JerakineError("Unknown interaction type " + param1 + ".");
         }
      }
      
      public static function getMessage(param1:String) : Class
      {
         switch(param1)
         {
            case MouseEvent.CLICK:
               return EntityClickMessage;
            case MouseEvent.MOUSE_OVER:
               return EntityMouseOverMessage;
            case Event.REMOVED_FROM_STAGE:
            case MouseEvent.MOUSE_OUT:
               return EntityMouseOutMessage;
            default:
               throw new JerakineError("Unknown event type for an interaction \'" + param1 + "\'.");
         }
      }
   }
}
