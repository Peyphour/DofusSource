package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ClosePopup;
   
   public class CheckboxPopup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      private var _validCallBack:Function;
      
      private var _cancelCallback:Function;
      
      public var mainCtr:GraphicContainer;
      
      public var lbl_title_popup:Label;
      
      public var lbl_description:TextArea;
      
      public var btn_label_btn_checkbox:Label;
      
      public var btn_checkbox:ButtonContainer;
      
      public var btn_close_popup:ButtonContainer;
      
      public var btn_ok:ButtonContainer;
      
      public var btn_undo:ButtonContainer;
      
      public function CheckboxPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_ok.soundId = SoundEnum.OK_BUTTON;
         this.lbl_title_popup.text = param1.title;
         this.lbl_description.text = param1.content;
         this.btn_checkbox.selected = param1.defaultSelect;
         this.btn_label_btn_checkbox.text = param1.checkboxText;
         this._validCallBack = param1.validCallBack;
         this._cancelCallback = param1.cancelCallback;
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_ok)
         {
            if(this._validCallBack != null)
            {
               this._validCallBack(this.btn_checkbox.selected);
            }
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else if(param1 == this.btn_close_popup || param1 == this.btn_undo)
         {
            if(this._cancelCallback != null)
            {
               this._cancelCallback();
            }
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case ShortcutHookListEnum.VALID_UI:
               if(this._validCallBack != null)
               {
                  this._validCallBack(this.btn_checkbox.selected);
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
