package com.ankamagames.dofus.logic.game.roleplay.messages
{
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.jerakine.messages.Message;
   
   public class InteractiveElementMouseOverMessage implements Message
   {
       
      
      private var _ie:InteractiveElement;
      
      private var _sprite;
      
      public function InteractiveElementMouseOverMessage(param1:InteractiveElement, param2:*)
      {
         super();
         this._ie = param1;
         this._sprite = param2;
      }
      
      public function get interactiveElement() : InteractiveElement
      {
         return this._ie;
      }
      
      public function get sprite() : *
      {
         return this._sprite;
      }
   }
}
