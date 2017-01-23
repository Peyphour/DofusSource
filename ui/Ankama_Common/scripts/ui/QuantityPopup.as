package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2hooks.MouseClick;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class QuantityPopup
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var soundApi:SoundApi;
      
      public var utilApi:UtilApi;
      
      public var btnMin:ButtonContainer;
      
      public var btnMax:ButtonContainer;
      
      public var btnOk:ButtonContainer;
      
      public var inputQty:Input;
      
      private var _defaultValue:uint;
      
      private var _validCallback:Function;
      
      private var _cancelCallback:Function;
      
      private var _max:Number;
      
      private var _min:Number;
      
      private var _lockMin:Boolean = false;
      
      private var _lockValue:Boolean = false;
      
      private var _timer:Timer;
      
      public function QuantityPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._defaultValue = param1.defaultValue;
         this._min = param1.min;
         this._max = param1.max;
         this._validCallback = param1.validCallback;
         this._cancelCallback = param1.cancelCallback;
         if(param1.hasOwnProperty("lockMin"))
         {
            this._lockMin = param1.lockMin;
         }
         if(param1.hasOwnProperty("lockValue"))
         {
            this._lockValue = param1.lockValue;
         }
         if(this._max > this.inputMaxChars())
         {
            this._max = this.inputMaxChars();
         }
         if(this._defaultValue > this._max)
         {
            this._defaultValue = this._max;
         }
         this.uiApi.me().visible = false;
         this.uiApi.addComponentHook(this.btnMax,"onRollOver");
         this.uiApi.addComponentHook(this.btnMax,"onRollOut");
         this._timer = new Timer(10,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onInitialize);
         this._timer.start();
      }
      
      private function onInitialize(param1:TimerEvent) : void
      {
         this.uiApi.me().visible = true;
         this._timer.removeEventListener(TimerEvent.TIMER,this.onInitialize);
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.btnMin.soundId = SoundEnum.SCROLL_DOWN;
         this.btnMax.soundId = SoundEnum.SCROLL_UP;
         this.btnOk.soundId = SoundEnum.CHECKBOX_CHECKED;
         if(this._defaultValue == 0 && !this._lockValue)
         {
            this.inputQty.text = this.utilApi.kamasToString(1,"");
         }
         else
         {
            this.inputQty.text = this.utilApi.kamasToString(this._defaultValue,"");
         }
         this.inputQty.setSelection(0,this.inputQty.text.length);
         this.inputQty.focus();
         (this.inputQty.textfield as TextField).setSelection(0,(this.inputQty.textfield as TextField).length);
         if(this._max == 0)
         {
            this.btnMax.softDisabled = true;
         }
         this.sysApi.addHook(MouseClick,this.onGenericMouseClick);
         this.sysApi.log(2,"addHook MouseClick");
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.inputQty,"onChange");
         this.uiApi.me().x = this.uiApi.getMouseX() - this.inputQty.x - 2;
         this.uiApi.me().y = this.uiApi.getMouseY() - this.uiApi.me().height - 2;
         if(this.uiApi.me().x + this.uiApi.me().width > this.uiApi.getStageWidth())
         {
            this.uiApi.me().x = this.uiApi.me().x - this.uiApi.me().width;
         }
         if(this.uiApi.me().y + this.uiApi.me().height > this.uiApi.getStageHeight())
         {
            this.uiApi.me().y = this.uiApi.me().y - this.uiApi.me().height;
         }
         if(this.uiApi.me().x < 0)
         {
            this.uiApi.me().x = 0;
         }
         if(this.uiApi.me().y < 0)
         {
            this.uiApi.me().y = 0;
         }
      }
      
      public function unload() : void
      {
         this._timer.stop();
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
      }
      
      private function valid() : void
      {
         var _loc1_:Number = this.utilApi.stringToKamas(this.inputQty.text,"");
         if(_loc1_ > this._max && this._max > 0)
         {
            _loc1_ = this._max;
         }
         if((this._lockMin || _loc1_ < 0) && _loc1_ < this._min)
         {
            _loc1_ = this._min;
         }
         this._validCallback.apply(null,[_loc1_]);
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      private function cancel() : void
      {
         if(this._cancelCallback != null)
         {
            this._cancelCallback.apply(null);
         }
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btnMin:
               this.inputQty.text = this.utilApi.kamasToString(this._min,"");
               break;
            case this.btnMax:
               _loc2_ = this.utilApi.kamasToString(this._max,"");
               this.inputQty.text = _loc2_;
               break;
            case this.btnOk:
               this.valid();
         }
      }
      
      private function inputMaxChars() : Number
      {
         var _loc1_:int = this.inputQty.maxChars;
         return Math.pow(10,int(_loc1_ / 4) * 3 + _loc1_ % 4) - 1;
      }
      
      public function onRollOver(param1:Object) : void
      {
         if(param1 == this.btnMax && this._max == 0)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.error.contextProblem")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onChange(param1:Object) : void
      {
         var _loc2_:Number = this.utilApi.stringToKamas(this.inputQty.text,"");
         var _loc3_:Number = _loc2_;
         if(_loc2_ > this._max)
         {
            _loc2_ = this._max;
         }
         if(this._lockMin && _loc2_ < this._min)
         {
            _loc2_ = this._min;
         }
         if(_loc2_ == 0)
         {
            this.inputQty.text = "0";
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc3_ != _loc2_)
         {
            this.inputQty.text = this.utilApi.kamasToString(_loc2_,"");
         }
      }
      
      private function onGenericMouseClick(param1:Object) : void
      {
         var _loc2_:Object = param1;
         try
         {
            if(!(_loc2_ is GraphicContainer))
            {
               _loc2_ = _loc2_.parent;
            }
            if(!(_loc2_ is GraphicContainer) || _loc2_.getUi() != this.uiApi.me())
            {
               this.cancel();
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.cancel();
               return true;
            case "validUi":
               this.valid();
               return true;
            default:
               return false;
         }
      }
   }
}
