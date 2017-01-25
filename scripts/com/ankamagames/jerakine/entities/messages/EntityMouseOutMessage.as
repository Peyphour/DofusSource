package com.ankamagames.jerakine.entities.messages
{
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.messages.CancelableMessage;
   
   public class EntityMouseOutMessage extends EntityInteractionMessage implements CancelableMessage
   {
       
      
      private var _cancel:Boolean;
      
      public function EntityMouseOutMessage(param1:IInteractive)
      {
         super(param1);
      }
      
      public function set cancel(param1:Boolean) : void
      {
         this._cancel = param1;
      }
      
      public function get cancel() : Boolean
      {
         return this._cancel;
      }
   }
}
