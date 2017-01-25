package com.ankamagames.berilia.components
{
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.messages.Message;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class LinkedLabel extends Label
   {
       
      
      private var _sUrl:String;
      
      private var _sTarget:String = "_blank";
      
      public function LinkedLabel()
      {
         super();
         buttonMode = true;
         mouseChildren = false;
      }
      
      public function get url() : String
      {
         return this._sUrl;
      }
      
      public function set url(param1:String) : void
      {
         this._sUrl = param1;
      }
      
      public function get target() : String
      {
         return this._sTarget;
      }
      
      public function set target(param1:String) : void
      {
         this._sTarget = param1;
      }
      
      override public function process(param1:Message) : Boolean
      {
         switch(true)
         {
            case param1 is MouseClickMessage:
               if((param1 as MouseClickMessage).target == this && getUi() && getUi().uiModule.trusted)
               {
                  navigateToURL(new URLRequest(this.url),this.target);
                  return true;
               }
               break;
            default:
               if((param1 as MouseClickMessage).target == this && getUi() && getUi().uiModule.trusted)
               {
                  navigateToURL(new URLRequest(this.url),this.target);
                  return true;
               }
               break;
         }
         return false;
      }
   }
}
