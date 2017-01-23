package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DocumentApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.LeaveDialogRequest;
   import data.ImageData;
   import flash.geom.Point;
   import flash.text.StyleSheet;
   import tools.HtmlParser;
   
   public class Scroll extends DocumentBase
   {
      
      private static var EXP_TAG:RegExp = /(<[a-zA-Z]+\s*[^>]*+>)+([^<].*?)/gi;
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var docApi:DocumentApi;
      
      public var soundApi:SoundApi;
      
      public var btn_close:ButtonContainer;
      
      public var btn_close2:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var lbl_content:TextArea;
      
      public var tx_illu:Texture;
      
      public var mainCtr:GraphicContainer;
      
      public var tx_deco:Texture;
      
      public var tx_background:Texture;
      
      private var _styleSheet:StyleSheet;
      
      private var _title:String;
      
      private var _pages:Array;
      
      private var _image:ImageData;
      
      private var _illuUri:Object;
      
      private var _properties:Object;
      
      private var _hasText:Boolean = true;
      
      private var _showtitle:Boolean;
      
      private var _showBackgroundImage:Boolean;
      
      private var _btn_Close:ButtonContainer;
      
      private var _hideTitleDecoration:Boolean;
      
      private var _updateIlluPosition:Boolean;
      
      private const MAX_LINES:int = 30;
      
      public function Scroll()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.soundApi.playSound(SoundTypeEnum.MAP_OPEN);
         uiApi.addShortcutHook("closeUi",this.onShortcut);
         if(sysApi.getBuildType() == 4 || sysApi.getBuildType() == 5)
         {
            this.lbl_content.textfield.doubleClickEnabled = true;
            uiApi.addComponentHook(this.lbl_content,"onDoubleClick");
         }
         var _loc2_:Object = this.docApi.getDocument(param1.documentId);
         this._title = _loc2_.title;
         this._pages = new Array();
         this._pages[0] = _loc2_.pages[0];
         this._properties = getProperties(_loc2_.clientProperties);
         this._showtitle = _loc2_.showTitle;
         this._showBackgroundImage = _loc2_.showBackgroundImage;
         if(this._pages[0] && this._pages[0].length)
         {
            this.preInitData();
            this.initCss(_loc2_);
            this._initScroll();
         }
         else
         {
            sysApi.enableWorldInteraction();
            sysApi.sendAction(new LeaveDialogRequest());
            uiApi.unloadUi(uiApi.me().name);
         }
      }
      
      private function preInitData() : void
      {
         this._hasText = this.documentHasText(this._pages[0]);
         this._image = getImageData(this._pages[0]);
         if(this._image != null)
         {
            this._illuUri = uiApi.createUri(uiApi.me().getConstant("illus") + this._image.src);
         }
      }
      
      private function initCss(param1:Object) : void
      {
         if(param1.contentCSS && param1.contentCSS != "null")
         {
            this._styleSheet = new StyleSheet();
            this._styleSheet.parseCSS(param1.contentCSS);
            overrideLinkStyleInCss(this._styleSheet);
            this.lbl_content.setStyleSheet(this._styleSheet);
         }
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.MAP_CLOSE);
         sysApi.enableWorldInteraction();
         sysApi.sendAction(new LeaveDialogRequest());
      }
      
      private function _initScroll() : void
      {
         var _loc1_:String = null;
         this.lbl_title.text = this._title.search("<b>") == -1?"<b>" + this._title + "</b>":this._title;
         if(this._styleSheet)
         {
            _loc1_ = formateText(this._pages[0]);
         }
         else
         {
            _loc1_ = HtmlParser.parseText(this._pages[0]);
         }
         if(!this._hasText && this._image != null)
         {
            this.btn_close.visible = this._showBackgroundImage;
            this.tx_background.visible = this._showBackgroundImage;
            if(!this._showtitle)
            {
               this.showTitle(false);
            }
            this.lbl_content.visible = false;
            if(this._image.width > 0)
            {
               this.tx_illu.width = this._image.width;
            }
            else
            {
               this.tx_illu.width = 354;
            }
            if(this._image.height > 0)
            {
               this.tx_illu.height = this._image.height;
            }
            else
            {
               this.tx_illu.height = 539;
            }
            this.tx_illu.x = 150 + (800 - this.tx_illu.width) / 2;
            if(this.tx_illu.x < 0)
            {
               this.tx_illu.x = 0;
            }
            this.tx_illu.y = 130 + (600 - this.tx_illu.height) / 2;
            if(this.tx_illu.y < 0)
            {
               this.tx_illu.y = 0;
            }
            if(!this._showBackgroundImage)
            {
               this.btn_close2.x = this.tx_illu.x + this._image.width - this.btn_close.width;
               this.btn_close2.y = this.tx_illu.y - this.btn_close.height;
               if(this._showtitle)
               {
                  this.showTitle(false);
               }
               this.btn_close2.visible = false;
               this.tx_illu.dispatchMessages = true;
               uiApi.addComponentHook(this.tx_illu,"onTextureReady");
            }
            if(this.tx_illu.x == 0 && this.tx_illu.y == 0)
            {
               this.tx_illu.visible = false;
               this._updateIlluPosition = true;
            }
            this.tx_illu.uri = this._illuUri;
         }
         else
         {
            if(this._showBackgroundImage)
            {
               this.btn_close2.visible = false;
               this.btn_close.visible = true;
            }
            if(this._illuUri)
            {
               this.lbl_content.width = 490;
            }
            else
            {
               this.lbl_content.width = 800;
            }
            this.lbl_content.text = (this._image == null?"\n":"") + _loc1_;
            this.lbl_content.scrollBarX = this.lbl_content.width;
            this.lbl_content.visible = true;
            this.lbl_content.textfield.mouseEnabled = true;
            this.lbl_content.textfield.multiline = true;
            this.lbl_content.wordWrap = true;
            uiApi.addComponentHook(this.lbl_content,"onTextClick");
            if(this.lbl_content.textHeight > this.lbl_content.height && this.lbl_content.textHeight - this.lbl_content.height < 10)
            {
               this.lbl_content.height = this.lbl_content.textHeight;
            }
            this.tx_illu.x = 643;
            this.tx_illu.y = 148;
            if(this._image != null)
            {
               if(this._image.width > 0)
               {
                  this.tx_illu.width = this._image.width;
               }
               else
               {
                  this.tx_illu.width = 354;
               }
               if(this._image.height > 0)
               {
                  this.tx_illu.height = this._image.height;
               }
               else
               {
                  this.tx_illu.height = 539;
               }
               this.tx_illu.uri = this._illuUri;
            }
            if(this.lbl_content.textfield.numLines <= this.MAX_LINES)
            {
               this.lbl_content.hideScrollBar();
            }
         }
         this.applyProperties();
         if(this._btn_Close && this._showBackgroundImage)
         {
            this._btn_Close.visible = true;
         }
      }
      
      public function documentHasText(param1:String) : Boolean
      {
         var _loc2_:* = new RegExp(EXP_TAG).exec(param1);
         return _loc2_ != null;
      }
      
      private function showTitle(param1:Boolean) : void
      {
         this.lbl_title.visible = param1;
         this.tx_deco.visible = !this._hideTitleDecoration?Boolean(param1):false;
      }
      
      private function applyProperties() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         if(this._properties)
         {
            this._hideTitleDecoration = this._properties.hasOwnProperty("hideTitleDecoration");
            if(this._hideTitleDecoration)
            {
               this.tx_deco.visible = false;
            }
            if(this._properties.hasOwnProperty("titleOffsetY"))
            {
               _loc1_ = this._properties["titleOffsetY"];
               this.lbl_title.y = this.lbl_title.y + _loc1_;
               this.tx_deco.y = this.tx_deco.y + _loc1_;
            }
            if(this._properties.hasOwnProperty("buttonType"))
            {
               _loc2_ = this._properties["buttonType"];
               if(_loc2_ == 1)
               {
                  this.btn_close2.visible = false;
                  this._btn_Close = this.btn_close;
               }
               else if(_loc2_ == 2)
               {
                  this.btn_close.visible = false;
                  this._btn_Close = this.btn_close2;
               }
            }
         }
      }
      
      public function onTextClick(param1:Object, param2:String) : void
      {
         linkHandler(param2);
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
            case this.btn_close2:
               uiApi.unloadUi(uiApi.me().name);
         }
         super.onRelease(param1);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               uiApi.unloadUi(uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         if(param1 == this.lbl_content)
         {
            openDebugEditionPanel(this.lbl_content,this._pages[0],480);
         }
      }
      
      override public function updateDocumentContent(param1:GraphicContainer, param2:String) : void
      {
         this._pages[0] = param2;
         this.preInitData();
         this._initScroll();
      }
      
      override public function copyAllDataToClipBoard() : void
      {
         sysApi.copyToClipboard(this._pages[0]);
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Point = null;
         if(param1 == this.tx_illu)
         {
            if(this._updateIlluPosition)
            {
               this.tx_illu.height = Object(this.tx_illu.child).bitmapData.height;
               this.tx_illu.width = Object(this.tx_illu.child).bitmapData.width;
               _loc2_ = uiApi.getVisibleStageBounds();
               _loc3_ = this.tx_illu.getParent()["globalToLocal"](new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2));
               this.tx_illu.x = _loc3_.x - this.tx_illu.width / 2;
               this.tx_illu.y = _loc3_.y - this.tx_illu.height / 2;
               param1.visible = true;
               this.btn_close2.y = param1.y + 35;
            }
            if(this._showtitle)
            {
               this.showTitle(true);
            }
            if(this._btn_Close)
            {
               this._btn_Close.visible = true;
            }
            else
            {
               this.btn_close2.visible = true;
            }
         }
      }
   }
}
