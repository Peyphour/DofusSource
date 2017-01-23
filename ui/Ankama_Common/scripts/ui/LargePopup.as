package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2hooks.ClosePopup;
   
   public class LargePopup
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
      
      public var ctr_buttons:GraphicContainer;
      
      public var lbl_title_popup:Label;
      
      public var lbl_content:TextArea;
      
      public var tx_background:Texture;
      
      public function LargePopup()
      {
         this._aEventIndex = new Array();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:ButtonContainer = null;
         var _loc7_:* = undefined;
         var _loc8_:Texture = null;
         var _loc9_:Label = null;
         var _loc11_:Array = null;
         this.sysApi.log(2,"go large popup " + param1);
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_close_popup.soundId = SoundEnum.WINDOW_CLOSE;
         this.tx_background.autoGrid = true;
         this.lbl_content.multiline = true;
         this.lbl_content.wordWrap = true;
         this.lbl_content.allowTextMouse(true);
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
            if(param1.useHyperLink)
            {
               this.lbl_content.hyperlinkEnabled = true;
               this.lbl_content.useStyleSheet = true;
            }
            this.lbl_content.text = param1.content;
            if(!param1.buttonText || !param1.buttonText.length)
            {
               throw new Error("Can\'t create popup without any button");
            }
            var _loc2_:uint = 100;
            var _loc3_:uint = 32;
            var _loc4_:uint = 20;
            this.sysApi.log(2,"hauteur " + this.popCtr.height);
            this.numberButton = param1.buttonText.length;
            if(this.numberButton == 1 && param1.buttonCallback && param1.buttonCallback.length == 1)
            {
               this.defaultShortcutFunction = param1.buttonCallback[0];
            }
            var _loc10_:uint = 0;
            while(_loc10_ < this.numberButton)
            {
               _loc6_ = this.uiApi.createContainer("ButtonContainer") as ButtonContainer;
               if(_loc10_ == 0)
               {
                  _loc6_.soundId = SoundEnum.POPUP_YES;
               }
               else
               {
                  _loc6_.soundId = SoundEnum.POPUP_NO;
               }
               _loc6_.width = _loc2_;
               _loc6_.height = _loc3_;
               _loc6_.x = _loc10_ * (_loc4_ + _loc2_);
               _loc6_.name = "btn" + (_loc10_ + 1);
               _loc7_ = this.uiApi.createComponent("TextureBitmap");
               _loc7_.width = _loc2_;
               _loc7_.height = _loc3_;
               _loc7_.themeDataId = this.uiApi.me().getConstant("txBtnBg_normal") as String;
               _loc7_.name = _loc6_.name + "_tx";
               this.uiApi.me().registerId(_loc7_.name,this.uiApi.createContainer("GraphicElement",_loc7_,new Array(),_loc7_.name));
               _loc7_.finalize();
               _loc8_ = this.uiApi.createComponent("Texture") as Texture;
               _loc8_.height = _loc3_;
               if(_loc10_ == 0)
               {
                  _loc8_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("btnOkIcon.file"));
               }
               else
               {
                  _loc8_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("btnCancelIcon.file"));
               }
               _loc8_.autoGrid = true;
               _loc8_.name = _loc6_.name + "_tx_icon";
               this.uiApi.me().registerId(_loc8_.name,this.uiApi.createContainer("GraphicElement",_loc8_,new Array(),_loc8_.name));
               _loc8_.x = 10;
               _loc8_.finalize();
               _loc9_ = this.uiApi.createComponent("Label") as Label;
               _loc9_.x = 30;
               _loc9_.width = _loc2_ - 30;
               _loc9_.height = _loc3_;
               _loc9_.verticalAlign = "center";
               _loc9_.css = this.uiApi.createUri(this.uiApi.me().getConstant("btn.css"));
               _loc9_.text = this.uiApi.replaceKey(param1.buttonText[_loc10_]);
               _loc6_.addChild(_loc7_);
               _loc6_.addChild(_loc8_);
               _loc6_.addChild(_loc9_);
               _loc11_ = new Array();
               _loc11_[1] = new Array();
               _loc11_[1][_loc7_.name] = new Array();
               _loc11_[1][_loc7_.name]["gotoAndStop"] = "over";
               _loc11_[2] = new Array();
               _loc11_[2][_loc7_.name] = new Array();
               _loc11_[2][_loc7_.name]["gotoAndStop"] = "pressed";
               _loc6_.changingStateData = _loc11_;
               if(param1.buttonCallback && param1.buttonCallback[_loc10_])
               {
                  this._aEventIndex[_loc6_.name] = param1.buttonCallback[_loc10_];
               }
               this.uiApi.addComponentHook(_loc6_,"onRelease");
               this.ctr_buttons.addChild(_loc6_);
               _loc10_++;
            }
            if(param1.onCancel)
            {
               this.onCancelFunction = param1.onCancel;
            }
            if(param1.onEnterKey)
            {
               this.onEnterKey = param1.onEnterKey;
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
         switch(param1)
         {
            case "validUi":
               if(this.onEnterKey == null && this.numberButton > 1)
               {
                  throw new Error("onEnterKey method is null");
               }
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
               if(this.onCancelFunction == null && this.numberButton > 1)
               {
                  throw new Error("onCancelFunction method is null");
               }
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
      
      private function closeMe() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function unload() : void
      {
         this.sysApi.dispatchHook(ClosePopup);
      }
   }
}
