package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ClosePopup;
   
   public class InputPopup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      private var _validCallBack:Function;
      
      private var _cancelCallback:Function;
      
      public var mainCtr:GraphicContainer;
      
      public var lbl_title_popup:Label;
      
      public var lbl_description:Label;
      
      public var lbl_input:Input;
      
      public var btn_close_popup:ButtonContainer;
      
      public var btn_ok:ButtonContainer;
      
      public function InputPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_ok.soundId = SoundEnum.OK_BUTTON;
         this.lbl_title_popup.text = param1.title;
         this.lbl_description.text = param1.content;
         this.lbl_input.text = param1.defaultValue;
         this.lbl_input.selectAll();
         this._validCallBack = param1.validCallBack;
         this._cancelCallback = param1.cancelCallback;
         this.lbl_input.restrictChars = param1.restric;
         this.lbl_input.maxChars = param1.maxChars;
         this.lbl_input.focus();
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_ok)
         {
            if(this._validCallBack != null)
            {
               this._validCallBack(this.lbl_input.text);
            }
         }
         else if(param1 == this.btn_close_popup)
         {
            if(this._cancelCallback != null)
            {
               this._cancelCallback();
            }
         }
         this.uiApi.unloadUi(this.uiApi.me().name);
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
                  this._validCallBack(this.lbl_input.text);
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
