package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2actions.EmotePlayRequest;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.ComponentHookList;
   import d2hooks.TextInformation;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BetaMenu
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var timeApi:TimeApi;
      
      public var rpApi:RoleplayApi;
      
      private var _timer:Timer;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var btn_beta:ButtonContainer;
      
      public var btn_p:ButtonContainer;
      
      public var ctr_bg:GraphicContainer;
      
      public function BetaMenu()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         if(rest && rest.length == 1)
         {
            if(rest[0].hasOwnProperty("visibleBugReportBtn"))
            {
               this.btn_beta.visible = rest[0].visibleBugReportBtn;
               this.ctr_bg.visible = rest[0].visibleBugReportBtn;
               if(rest[0].visibleBugReportBtn)
               {
                  this.uiApi.addComponentHook(this.btn_beta,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(this.btn_beta,ComponentHookList.ON_ROLL_OUT);
               }
            }
            if(rest[0].hasOwnProperty("visiblePartyTimeBtn"))
            {
               this.btn_p.visible = rest[0].visiblePartyTimeBtn;
               if(rest[0].visiblePartyTimeBtn)
               {
                  this._timer = new Timer(800,4);
                  this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
               }
            }
         }
      }
      
      public function unload() : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer = null;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_beta)
         {
            this.sysApi.goToUrl(this.uiApi.getText("ui.link.betaForumReport"));
         }
         else if(param1 == this.btn_p)
         {
            this._timer.reset();
            this.dispatchCallback();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.btn_beta)
         {
            _loc2_ = this.uiApi.getText("ui.common.bugReport");
         }
         this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function dispatchCallback() : void
      {
         this.onTimer(null);
         this._timer.start();
         var _loc1_:Array = ["YEAH ! PARTY HARD !","C\'est carrément la fête aujourd\'hui !","Je passe un super bon moment !","Je suis super heureux !","\\o/",":D","Ouhouou ! Shut up and dance with me !","Cette journée est tellement magique !","C\'est la fête ! C\'est la fête ! Service garanti impec\' !","Tout le monde chante, tout le monde danse, oui mam\'zelle ça c\'est la France !"];
         var _loc2_:int = Math.floor(Math.random() * _loc1_.length);
         this.sysApi.dispatchHook(TextInformation,_loc1_[_loc2_],ChatActivableChannelsEnum.CHANNEL_ADMIN,this.timeApi.getTimestamp());
      }
      
      private function onTimer(param1:Event) : void
      {
         var _loc2_:Array = [1846,1841,1848];
         var _loc3_:int = Math.floor(Math.random() * 195) + 363;
         var _loc4_:int = Math.floor(Math.random() * _loc2_.length);
         this.rpApi.playSpellAnimation(_loc2_[_loc4_],5,_loc3_);
         if(this._timer.currentCount == this._timer.repeatCount || this._timer.running == false)
         {
            this.sysApi.sendAction(new EmotePlayRequest(27));
         }
      }
   }
}
