package com.ankamagames.atouin.messages
{
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.messages.ILogableMessage;
   import com.ankamagames.jerakine.messages.Message;
   
   public class EntityMovementCompleteMessage implements Message, ILogableMessage
   {
       
      
      private var _entity:IEntity;
      
      public var id:Number;
      
      public function EntityMovementCompleteMessage(param1:IEntity = null)
      {
         super();
         this._entity = param1;
         if(this._entity)
         {
            this.id = param1.id;
         }
      }
      
      public function get entity() : IEntity
      {
         return this._entity;
      }
   }
}
