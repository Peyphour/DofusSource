package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.berilia.components.WebBrowser;
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class BrowserDomainReadyAction implements Action
   {
       
      
      public var browser:WebBrowser;
      
      public function BrowserDomainReadyAction()
      {
         super();
      }
      
      public static function create(param1:WebBrowser) : BrowserDomainReadyAction
      {
         var _loc2_:BrowserDomainReadyAction = new BrowserDomainReadyAction();
         _loc2_.browser = param1;
         return _loc2_;
      }
   }
}
