package com.ankamagames.berilia.types.event
{
   import com.ankamagames.berilia.types.uiDefinition.UiDefinition;
   import flash.events.Event;
   
   public class ParsorEvent extends Event
   {
       
      
      private var _uiDef:UiDefinition;
      
      private var _error:Boolean;
      
      public function ParsorEvent(param1:UiDefinition, param2:Boolean)
      {
         super(Event.COMPLETE,false,false);
         this._uiDef = param1;
         this._error = param2;
      }
      
      public function get error() : Boolean
      {
         return this._error;
      }
      
      public function get uiDefinition() : UiDefinition
      {
         return this._uiDef;
      }
   }
}
