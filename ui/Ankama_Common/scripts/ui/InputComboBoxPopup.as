package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.InputComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ClosePopup;
   
   public class InputComboBoxPopup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      private var _validCallBack:Function;
      
      private var _cancelCallback:Function;
      
      private var _resetCallback:Function;
      
      public var mainCtr:GraphicContainer;
      
      public var lbl_title_popup:Label;
      
      public var lbl_description:Label;
      
      public var lbl_input:InputComboBox;
      
      public var btn_close_popup:ButtonContainer;
      
      public var btn_ok:ButtonContainer;
      
      public var btn_emptyOptionHistory:ButtonContainer;
      
      public var _resetButtonTooltip:String;
      
      public function InputComboBoxPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_ok.soundId = SoundEnum.OK_BUTTON;
         this.uiApi.addComponentHook(this.btn_emptyOptionHistory,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_emptyOptionHistory,ComponentHookList.ON_ROLL_OUT);
         this.lbl_title_popup.text = param1.title;
         this.lbl_description.text = param1.content;
         this.lbl_input.input.text = param1.defaultValue;
         this.lbl_input.input.selectAll();
         this._validCallBack = param1.validCallBack;
         this._cancelCallback = param1.cancelCallback;
         this._resetCallback = param1.resetCallback;
         this._resetButtonTooltip = param1.resetButtonTooltip;
         this.lbl_input.input.restrictChars = param1.restric;
         this.lbl_input.maxChars = param1.maxChars;
         this.lbl_input.focus();
         this.lbl_input.dataProvider = param1.dataProvider;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Boolean = true;
         if(param1 == this.btn_ok)
         {
            if(this._validCallBack != null)
            {
               this._validCallBack(this.lbl_input.input.text);
            }
         }
         else if(param1 == this.btn_close_popup)
         {
            if(this._cancelCallback != null)
            {
               this._cancelCallback();
            }
         }
         else if(param1 == this.btn_emptyOptionHistory)
         {
            _loc2_ = false;
            this.lbl_input.dataProvider = new Array();
            if(this._resetCallback != null)
            {
               this._resetCallback();
            }
         }
         if(_loc2_)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btn_emptyOptionHistory:
               _loc2_ = this._resetButtonTooltip;
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(this.lbl_input == null)
         {
            return true;
         }
         switch(param1)
         {
            case ShortcutHookListEnum.VALID_UI:
               if(this._validCallBack != null)
               {
                  this._validCallBack(this.lbl_input.input.text);
               }
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case ShortcutHookListEnum.CLOSE_UI:
               this.onRelease(this.btn_close_popup);
               return true;
         }
         return false;
      }
      
      public function unload() : void
      {
         this.sysApi.dispatchHook(ClosePopup);
      }
   }
}
