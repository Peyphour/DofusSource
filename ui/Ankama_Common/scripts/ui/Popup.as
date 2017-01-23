package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2hooks.ClosePopup;
   
   public class Popup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      protected var _aEventIndex:Array;
      
      protected var onCancelFunction:Function = null;
      
      protected var onEnterKey:Function = null;
      
      protected var numberButton:uint;
      
      protected var defaultShortcutFunction:Function;
      
      public var popCtr:GraphicContainer;
      
      public var btn_close_popup:ButtonContainer;
      
      public var tx_background_close_button_popup:TextureBitmap;
      
      public var ctr_buttons:GraphicContainer;
      
      public var lbl_title_popup:Label;
      
      public var lbl_content:Label;
      
      private var _ignoreShortcuts:Boolean = false;
      
      public function Popup()
      {
         this._aEventIndex = new Array();
         super();
      }
      
      public function set content(param1:String) : void
      {
         if(this.lbl_content)
         {
            this.lbl_content.text = param1;
         }
      }
      
      public function main(param1:Object) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:ButtonContainer = null;
         var _loc8_:TextureBitmap = null;
         var _loc9_:Texture = null;
         var _loc10_:Label = null;
         var _loc11_:uint = 0;
         var _loc12_:Array = null;
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_close_popup.soundId = SoundEnum.WINDOW_CLOSE;
         this.lbl_content.multiline = true;
         this.lbl_content.wordWrap = true;
         var _loc2_:Boolean = param1.hasOwnProperty("noButton");
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
            this.lbl_title_popup.text = param1.title;
            if(param1.noHtml)
            {
               this.lbl_content.html = false;
            }
            else if(param1.useHyperLink)
            {
               this.lbl_content.hyperlinkEnabled = true;
               this.lbl_content.useStyleSheet = true;
            }
            this.lbl_content.text = param1.content;
            if(!_loc2_ && (!param1.buttonText || !param1.buttonText.length))
            {
               throw new Error("Can\'t create popup without any button");
            }
            var _loc3_:uint = 150;
            var _loc4_:uint = 32;
            var _loc5_:uint = 20;
            this.popCtr.height = Math.floor(this.lbl_content.textfield.textHeight) + 150;
            if(!_loc2_)
            {
               this.numberButton = param1.buttonText.length;
               if(this.numberButton == 1 && param1.buttonCallback && param1.buttonCallback.length == 1)
               {
                  this.defaultShortcutFunction = param1.buttonCallback[0];
               }
               _loc11_ = 0;
               while(_loc11_ < this.numberButton)
               {
                  _loc7_ = this.uiApi.createContainer("ButtonContainer") as ButtonContainer;
                  if(_loc11_ == 0)
                  {
                     _loc7_.soundId = SoundEnum.POPUP_YES;
                  }
                  else
                  {
                     _loc7_.soundId = SoundEnum.POPUP_NO;
                  }
                  _loc7_.height = _loc4_;
                  _loc7_.x = _loc11_ == 0?Number(0):Number(_loc6_ + _loc11_ * _loc5_);
                  _loc7_.name = "btn" + (_loc11_ + 1);
                  this.uiApi.me().registerId(_loc7_.name,this.uiApi.createContainer("GraphicElement",_loc7_,new Array(),_loc7_.name));
                  _loc8_ = this.uiApi.createComponent("TextureBitmap") as TextureBitmap;
                  _loc8_.height = _loc4_;
                  _loc8_.themeDataId = this.uiApi.me().getConstant("txBtnBg_normal") as String;
                  _loc8_.name = _loc7_.name + "_tx";
                  this.uiApi.me().registerId(_loc8_.name,this.uiApi.createContainer("GraphicElement",_loc8_,new Array(),_loc8_.name));
                  _loc8_.finalize();
                  _loc9_ = this.uiApi.createComponent("Texture") as Texture;
                  _loc9_.height = _loc4_;
                  if(_loc11_ == 0)
                  {
                     _loc9_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("btnOkIcon.file"));
                  }
                  else
                  {
                     _loc9_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("btnCancelIcon.file"));
                  }
                  _loc9_.autoGrid = true;
                  _loc9_.name = _loc7_.name + "_tx_icon";
                  this.uiApi.me().registerId(_loc9_.name,this.uiApi.createContainer("GraphicElement",_loc9_,new Array(),_loc9_.name));
                  _loc9_.x = 10;
                  _loc9_.finalize();
                  _loc10_ = this.uiApi.createComponent("Label") as Label;
                  _loc10_.height = _loc4_;
                  _loc10_.verticalAlign = "center";
                  _loc10_.css = this.uiApi.createUri(this.uiApi.me().getConstant("btn.css"));
                  _loc10_.text = this.uiApi.replaceKey(param1.buttonText[_loc11_]);
                  _loc10_.x = 30;
                  _loc3_ = Math.max(_loc10_.textWidth + 10 + 30,150);
                  _loc10_.width = _loc3_ - 30;
                  _loc7_.width = _loc3_;
                  _loc8_.width = _loc3_;
                  _loc6_ = _loc6_ + _loc3_;
                  _loc7_.addChild(_loc8_);
                  _loc7_.addChild(_loc9_);
                  _loc7_.addChild(_loc10_);
                  _loc12_ = new Array();
                  _loc12_[1] = new Array();
                  _loc12_[1][_loc8_.name] = new Array();
                  _loc12_[1][_loc8_.name]["themeDataId"] = this.uiApi.me().getConstant("txBtnBg_over") as String;
                  _loc12_[2] = new Array();
                  _loc12_[2][_loc8_.name] = new Array();
                  _loc12_[2][_loc8_.name]["themeDataId"] = this.uiApi.me().getConstant("txBtnBg_pressed") as String;
                  _loc7_.changingStateData = _loc12_;
                  if(param1.buttonCallback && param1.buttonCallback[_loc11_])
                  {
                     this._aEventIndex[_loc7_.name] = param1.buttonCallback[_loc11_];
                  }
                  this.uiApi.addComponentHook(_loc7_,"onRelease");
                  this.ctr_buttons.addChild(_loc7_);
                  _loc11_++;
               }
               this.popCtr.width = Math.max(_loc7_.x + _loc3_ + _loc5_ * 2,this.uiApi.me().getConstant("popWidth"));
               if(param1.onCancel)
               {
                  this.onCancelFunction = param1.onCancel;
               }
               if(param1.onEnterKey)
               {
                  this.onEnterKey = param1.onEnterKey;
               }
            }
            else
            {
               this.popCtr.getUi().showModalContainer = true;
               this._ignoreShortcuts = true;
               this.btn_close_popup.visible = false;
               this.tx_background_close_button_popup.visible = false;
               this.popCtr.height = this.popCtr.height - (_loc4_ + _loc5_);
               this.popCtr.width = this.uiApi.me().getConstant("popWidth");
            }
            this.uiApi.me().render();
            return;
         }
         throw new Error("Can\'t load popup without properties.");
      }
      
      public function onRelease(param1:Object) : void
      {
         if(this._aEventIndex[param1.name])
         {
            this._aEventIndex[param1.name].apply(null);
         }
         else if(param1 == this.btn_close_popup && this.onCancelFunction != null)
         {
            this.onCancelFunction();
         }
         if(this.uiApi && this.uiApi.me() && this.uiApi.getUi(this.uiApi.me().name))
         {
            this.closeMe();
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(this._ignoreShortcuts)
         {
            return true;
         }
         switch(param1)
         {
            case "validUi":
               if(this.onEnterKey != null)
               {
                  this.onEnterKey();
               }
               else if(this.defaultShortcutFunction != null)
               {
                  this.defaultShortcutFunction();
               }
               this.closeMe();
               return true;
            case "closeUi":
               if(this.onCancelFunction != null)
               {
                  this.onCancelFunction();
               }
               this.closeMe();
               return true;
            default:
               return false;
         }
      }
      
      public function unload() : void
      {
         this.sysApi.dispatchHook(ClosePopup);
      }
      
      private function closeMe() : void
      {
         if(this.uiApi)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
   }
}
