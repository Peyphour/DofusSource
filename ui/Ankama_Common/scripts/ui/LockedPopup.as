package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2hooks.ClosePopup;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class LockedPopup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      protected var onCancelFunction:Function = null;
      
      private var _autoCloseTimer:Timer;
      
      private var _closeAllowed:Boolean = true;
      
      private var _autoClose:Boolean = false;
      
      private var _remainedTime:uint;
      
      private var _clockStart:uint;
      
      private var _duration:uint;
      
      public var popCtr:GraphicContainer;
      
      public var btn_ok:ButtonContainer;
      
      public var btn_lbl_btn_ok:Label;
      
      public var lbl_title_popup:Label;
      
      public var lbl_content:Label;
      
      public function LockedPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_ok.soundId = SoundEnum.WINDOW_CLOSE;
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         if(param1)
         {
            if(param1.hideModalContainer)
            {
               this.popCtr.getUi().showModalContainer = false;
            }
            else
            {
               this.popCtr.getUi().showModalContainer = true;
            }
            if(!this.sysApi.isFightContext())
            {
               this.btn_ok.disabled = true;
               this._closeAllowed = false;
               this._autoClose = param1.autoClose;
               if(param1.closeAtHook)
               {
                  for each(_loc2_ in param1.closeParam)
                  {
                     this.sysApi.addHook(_loc2_,this.onCloseHook);
                  }
               }
               else
               {
                  _loc3_ = uint(param1.closeParam[0]) * 1000;
                  if(_loc3_ > 10000)
                  {
                     _loc3_ = 10000;
                  }
                  this._remainedTime = _loc3_ / 1000;
                  this.btn_lbl_btn_ok.text = this.uiApi.getText("ui.common.ok") + " (" + this._remainedTime + ")";
                  this._clockStart = getTimer();
                  this._duration = _loc3_;
                  this.sysApi.addEventListener(this.onEnterFrame,"checkTimer");
               }
            }
            this.lbl_title_popup.text = param1.title;
            if(param1.useHyperLink)
            {
               this.lbl_content.hyperlinkEnabled = true;
               this.lbl_content.useStyleSheet = true;
            }
            this.lbl_content.text = param1.content;
            this.popCtr.height = Math.floor(this.lbl_content.textfield.textHeight) + this.lbl_content.y + 92;
            return;
         }
         throw new Error("Can\'t load popup without properties.");
      }
      
      public function unload() : void
      {
         if(this._autoCloseTimer)
         {
            this._autoCloseTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
            this._autoCloseTimer.stop();
            this._autoCloseTimer = null;
         }
         this.sysApi.dispatchHook(ClosePopup);
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      private function allowClose() : void
      {
         this._closeAllowed = true;
         this.btn_ok.disabled = false;
         if(this._autoClose)
         {
            this._autoCloseTimer = new Timer(2000,1);
            this._autoCloseTimer.start();
            this._autoCloseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         }
      }
      
      private function closePopup() : void
      {
         if(this._closeAllowed)
         {
            if(this._autoCloseTimer)
            {
               this._autoCloseTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
               this._autoCloseTimer.stop();
               this._autoCloseTimer = null;
            }
            if(this.onCancelFunction != null)
            {
               this.onCancelFunction();
            }
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_ok)
         {
            this.closePopup();
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
            case "closeUi":
               this.closePopup();
               return true;
            default:
               return false;
         }
      }
      
      public function onCloseHook(param1:Object) : void
      {
         this.allowClose();
      }
      
      public function onEnterFrame() : void
      {
         var _loc1_:uint = getTimer();
         var _loc2_:int = Math.floor((this._duration - (_loc1_ - this._clockStart)) / 1000);
         if(this._remainedTime > _loc2_)
         {
            this.btn_lbl_btn_ok.text = this.uiApi.getText("ui.common.ok") + " (" + _loc2_ + ")";
            this._remainedTime = _loc2_;
         }
         if(_loc2_ <= 0)
         {
            this.sysApi.removeEventListener(this.onEnterFrame);
            this.btn_lbl_btn_ok.text = this.uiApi.getText("ui.common.ok");
            this.allowClose();
         }
      }
      
      public function onTimeOut(param1:TimerEvent) : void
      {
         this.closePopup();
      }
   }
}
