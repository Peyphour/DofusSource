package com.ankamagames.berilia.types.event
{
   import com.ankamagames.berilia.types.data.UiData;
   import flash.events.Event;
   
   public class UiRenderAskEvent extends Event
   {
      
      public static const UI_RENDER_ASK:String = "UiRenderAsk";
       
      
      private var _uiData:UiData;
      
      private var _name:String;
      
      public function UiRenderAskEvent(param1:String, param2:UiData)
      {
         super(UI_RENDER_ASK,false,false);
         this._uiData = param2;
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get uiData() : UiData
      {
         return this._uiData;
      }
   }
}
