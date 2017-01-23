package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.CaptureApi;
   import com.ankamagames.dofus.uiApi.DocumentApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.LeaveDialogRequest;
   import data.ImageData;
   import data.LinkData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.utils.Dictionary;
   import tools.HtmlParser;
   
   public class ReadingBook extends DocumentBase
   {
      
      private static const LINKPAGE:String = "linkpage";
      
      private static const CLICKPAGE:String = "clickpage";
      
      private static const IMG_PADDING:int = 5;
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var docApi:DocumentApi;
      
      public var soundApi:SoundApi;
      
      public var captureApi:CaptureApi;
      
      public var btn_home:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_previous:ButtonContainer;
      
      public var btn_next:ButtonContainer;
      
      public var page_title:GraphicContainer;
      
      public var page_left:GraphicContainer;
      
      public var page_right:GraphicContainer;
      
      public var lbl_title:Label;
      
      public var lbl_subtitle:Label;
      
      public var lbl_author:Label;
      
      public var tx_deco:Texture;
      
      public var lbl_content_left:TextArea;
      
      public var lbl_content_right:TextArea;
      
      public var lbl_page_number_left:Label;
      
      public var lbl_page_number_right:Label;
      
      public var tx_pageLeft:Texture;
      
      public var tx_pageRight:Texture;
      
      public var mainCtr:GraphicContainer;
      
      private var _leftPageTextureList:Vector.<Texture>;
      
      private var _rightPageTextureList:Vector.<Texture>;
      
      private var _title:String;
      
      private var _author:String;
      
      private var _subTitle:String;
      
      private var _pages:Array;
      
      private var _styleSheet:StyleSheet;
      
      private var _lastIndex:int;
      
      private var _currentIndex:int;
      
      private var _nbPages:uint;
      
      private var _bmpDataLeft:BitmapData;
      
      private var _bmpDataRight:BitmapData;
      
      private var _loadingData:Dictionary;
      
      private var _rectList:Vector.<LinkData>;
      
      public function ReadingBook()
      {
         this._leftPageTextureList = new Vector.<Texture>();
         this._rightPageTextureList = new Vector.<Texture>();
         this._loadingData = new Dictionary(true);
         this._rectList = new Vector.<LinkData>();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc3_:Object = null;
         this.soundApi.playSound(SoundTypeEnum.DOCUMENT_OPEN);
         this.btn_home.soundId = SoundEnum.EMPTY;
         this.btn_close.soundId = SoundEnum.EMPTY;
         this.btn_next.soundId = SoundEnum.EMPTY;
         this.btn_previous.soundId = SoundEnum.EMPTY;
         uiApi.addShortcutHook("closeUi",this.onShortcut);
         uiApi.addShortcutHook("rightArrow",this.onShortcut);
         uiApi.addShortcutHook("leftArrow",this.onShortcut);
         this.lbl_content_left.textfield.mouseEnabled = true;
         this.lbl_content_right.textfield.mouseEnabled = true;
         this.lbl_page_number_left.textfield.mouseEnabled = true;
         this.lbl_page_number_right.textfield.mouseEnabled = true;
         uiApi.addComponentHook(this.lbl_page_number_left,"onTextClick");
         uiApi.addComponentHook(this.lbl_page_number_right,"onTextClick");
         uiApi.addComponentHook(this.page_left,"onRelease");
         uiApi.addComponentHook(this.page_right,"onRelease");
         uiApi.addComponentHook(this.tx_pageLeft,"onTextureReady");
         uiApi.addComponentHook(this.tx_pageRight,"onTextureReady");
         var _loc2_:Object = this.docApi.getDocument(param1.documentId);
         this._title = _loc2_.title;
         this._author = _loc2_.author;
         this._subTitle = _loc2_.subTitle;
         if(_loc2_.contentCSS && _loc2_.contentCSS != "null")
         {
            this._styleSheet = new StyleSheet();
            this._styleSheet.parseCSS(_loc2_.contentCSS);
            overrideLinkStyleInCss(this._styleSheet);
            this.lbl_content_left.setStyleSheet(this._styleSheet);
            this.lbl_content_right.setStyleSheet(this._styleSheet);
         }
         this._pages = new Array();
         for each(_loc3_ in _loc2_.pages)
         {
            this._pages.push(_loc3_);
         }
         this._lastIndex = -1;
         this._currentIndex = -1;
         this._nbPages = this._pages.length;
         this._initBook();
         if(sysApi.getBuildType() == 4 || sysApi.getBuildType() == 5)
         {
            uiApi.addComponentHook(this.tx_pageLeft,"onDoubleClick");
            uiApi.addComponentHook(this.tx_pageRight,"onDoubleClick");
         }
         this._updateButtons();
         this._updateBook();
      }
      
      public function unload() : void
      {
         if(this._bmpDataRight != null)
         {
            this._bmpDataRight.dispose();
         }
         if(this._bmpDataLeft != null)
         {
            this._bmpDataLeft.dispose();
         }
         this.clearTextures();
         this.clearLinks();
         this.soundApi.playSound(SoundTypeEnum.DOCUMENT_CLOSE);
         sysApi.enableWorldInteraction();
         uiApi.hideTooltip();
      }
      
      private function clearTextures(param1:String = "") : void
      {
         var _loc2_:* = undefined;
         if(param1 == "left" || param1 == "all" || param1 == "")
         {
            while((_loc2_ = this._leftPageTextureList.pop()) != null)
            {
               this._loadingData[_loc2_] = null;
               this.mainCtr.removeChild(_loc2_);
               _loc2_.free();
               _loc2_ = null;
            }
            this._leftPageTextureList = new Vector.<Texture>();
         }
         if(param1 == "left" || param1 == "all" || param1 == "")
         {
            while((_loc2_ = this._rightPageTextureList.pop()) != null)
            {
               this._loadingData[_loc2_] = null;
               this.mainCtr.removeChild(_loc2_);
               _loc2_.free();
               _loc2_ = null;
            }
            this._rightPageTextureList = new Vector.<Texture>();
         }
      }
      
      private function _initBook() : void
      {
         this.lbl_title.text = "<b>" + this._title + "</b>";
         this.lbl_subtitle.text = this._subTitle;
         this.lbl_author.text = this._author == null?"":"<b>" + this._author + "</b>";
         this.lbl_subtitle.x = 615;
         this.lbl_subtitle.y = this.lbl_title.y + this.lbl_title.textHeight + 20;
         this.tx_deco.x = 779;
         this.tx_deco.y = this.lbl_subtitle.y + this.lbl_subtitle.textHeight + 20;
      }
      
      private function _updateBook() : void
      {
         if(this._currentIndex == -1)
         {
            if(this._lastIndex > 2)
            {
               this.soundApi.playSound(SoundTypeEnum.DOCUMENT_BACK_FIRST_PAGE);
            }
            else
            {
               this.soundApi.playSound(SoundTypeEnum.DOCUMENT_TURN_PAGE);
            }
            this.page_title.visible = true;
            this.page_left.visible = false;
            this.page_right.visible = false;
            this.lbl_page_number_left.visible = false;
            this.lbl_page_number_right.visible = true;
            this.lbl_page_number_right.text = "<a href=\"event:" + CLICKPAGE + (this._currentIndex + 1) + "\">" + (this._currentIndex + 2) + "</a>";
         }
         else
         {
            this.clearTextures();
            this.soundApi.playSound(SoundTypeEnum.DOCUMENT_TURN_PAGE);
            this.page_title.visible = false;
            this.page_left.visible = true;
            this.page_right.visible = true;
            this.lbl_page_number_left.visible = true;
            this.lbl_page_number_right.visible = true;
            this.clearLinks();
            this._rectList = new Vector.<LinkData>();
            this._updatePageLeft();
            this._updatePageRight();
         }
         this._lastIndex = this._currentIndex;
      }
      
      private function _updatePageLeft() : void
      {
         var _loc1_:* = null;
         if(this._styleSheet)
         {
            _loc1_ = formateText(this._pages[this._currentIndex - 1]) + "\n\n";
         }
         else
         {
            _loc1_ = HtmlParser.parseText(this._pages[this._currentIndex - 1]);
         }
         this.tx_pageLeft.dispatchMessages = true;
         this._bmpDataLeft = this.getBitmap(this.lbl_content_left,_loc1_,"left");
         this.tx_pageLeft.loadBitmapData(this._bmpDataLeft);
         this.lbl_page_number_left.text = "<a href=\"event:" + CLICKPAGE + this._currentIndex + "\">" + (this._currentIndex + 1) + "</a>";
      }
      
      private function _updatePageRight() : void
      {
         var _loc1_:* = null;
         if(this._currentIndex < this._nbPages)
         {
            if(!this.tx_pageRight.visible)
            {
               this.tx_pageRight.visible = true;
            }
            if(this._styleSheet)
            {
               _loc1_ = formateText(this._pages[this._currentIndex]) + "\n\n";
            }
            else
            {
               _loc1_ = HtmlParser.parseText(this._pages[this._currentIndex]);
            }
            this.tx_pageRight.dispatchMessages = true;
            this._bmpDataRight = this.getBitmap(this.lbl_content_right,_loc1_,"right");
            this.tx_pageRight.loadBitmapData(this._bmpDataRight);
            this.lbl_page_number_right.text = "<a href=\"event:" + CLICKPAGE + (this._currentIndex + 1) + "\">" + (this._currentIndex + 2) + "</a>";
         }
         else
         {
            this.tx_pageRight.visible = false;
            this.lbl_page_number_right.text = "";
         }
      }
      
      private function _updateButtons() : void
      {
         if(this._currentIndex == -1)
         {
            this.btn_home.visible = false;
            this.btn_previous.visible = false;
            this.btn_next.visible = true;
         }
         else if(this._currentIndex + 1 >= this._nbPages)
         {
            this.btn_home.visible = true;
            this.btn_previous.visible = true;
            this.btn_next.visible = false;
         }
         else
         {
            this.btn_home.visible = true;
            this.btn_previous.visible = true;
            this.btn_next.visible = true;
         }
      }
      
      private function _selectPage(param1:int) : void
      {
         this._currentIndex = !!(param1 % 2)?int(param1):int(param1 + 1);
         this._updateButtons();
         this._updateBook();
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:LinkData = null;
         switch(param1)
         {
            case this.btn_home:
               super.hideDebugEditionPanel();
               this._currentIndex = -1;
               this._updateButtons();
               this._updateBook();
               break;
            case this.btn_close:
               super.hideDebugEditionPanel();
               sysApi.sendAction(new LeaveDialogRequest());
               uiApi.unloadUi(uiApi.me().name);
               break;
            case this.btn_previous:
               super.hideDebugEditionPanel();
               this._currentIndex = this._currentIndex - 2;
               this._updateButtons();
               this._updateBook();
               break;
            case this.btn_next:
               super.hideDebugEditionPanel();
               this._currentIndex = this._currentIndex + 2;
               this._updateButtons();
               this._updateBook();
               break;
            default:
               for each(_loc2_ in this._rectList)
               {
                  if(param1 == _loc2_.graphic)
                  {
                     this.onTextClick(param1,_loc2_.href);
                     return;
                  }
               }
         }
         super.onRelease(param1);
      }
      
      private function onValidPage(param1:Number) : void
      {
         this._selectPage(int(param1) - 2);
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.lbl_page_number_left:
            case this.lbl_page_number_right:
               _loc2_ = uiApi.getText("ui.common.choosePageNumber");
               _loc3_ = 0;
               _loc4_ = 2;
               break;
            case this.btn_close:
               _loc2_ = uiApi.getText("ui.common.close");
               break;
            case this.btn_home:
               _loc2_ = uiApi.getText("ui.book.titlePage");
               break;
            case this.btn_previous:
               _loc2_ = uiApi.getText("ui.book.prevPage");
               break;
            case this.btn_next:
               _loc2_ = uiApi.getText("ui.book.nextPage");
         }
         uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onTextClick(param1:Object, param2:String) : void
      {
         var _loc3_:int = 0;
         linkHandler(param2);
         if(param2.indexOf(LINKPAGE) != -1)
         {
            _loc3_ = int(param2.substr(LINKPAGE.length));
            this._selectPage(_loc3_);
         }
         else if(param2.indexOf(CLICKPAGE) != -1)
         {
            uiApi.hideTooltip();
            this.modCommon.openQuantityPopup(1,this._nbPages,int(param2.substr(CLICKPAGE.length)) + 1,this.onValidPage);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:Boolean = debugModeIsOpen();
         switch(param1)
         {
            case "rightArrow":
               if(this.btn_next.visible && !_loc2_)
               {
                  hideDebugEditionPanel();
                  this._currentIndex = this._currentIndex + 2;
                  this._updateButtons();
                  this._updateBook();
               }
               return true;
            case "leftArrow":
               if(this.btn_previous.visible && !_loc2_)
               {
                  hideDebugEditionPanel();
                  this._currentIndex = this._currentIndex - 2;
                  this._updateButtons();
                  this._updateBook();
               }
               return true;
            case "closeUi":
               hideDebugEditionPanel();
               sysApi.sendAction(new LeaveDialogRequest());
               uiApi.unloadUi(uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      private function getBitmap(param1:TextArea, param2:String, param3:String) : BitmapData
      {
         var _loc6_:ImageData = null;
         var _loc4_:BitmapData = new BitmapData(param1.width,param1.height,true,16711680);
         var _loc5_:Vector.<ImageData> = getAllImagesData(param2);
         var _loc7_:int = 0;
         var _loc8_:Matrix = new Matrix();
         if(_loc5_.length == 0)
         {
            _loc8_.translate(0,_loc7_);
            param1.text = param2;
            this.addTextToBitmap(_loc4_,param1,_loc8_);
         }
         else
         {
            for each(_loc6_ in _loc5_)
            {
               _loc8_.identity();
               if(_loc6_.before != "")
               {
                  _loc8_.translate(0,_loc7_);
                  param1.text = _loc6_.before;
                  this.addTextToBitmap(_loc4_,param1,_loc8_);
                  _loc7_ = _loc7_ + param1.textHeight;
               }
               this.addImageToBitmap(_loc4_,_loc6_,_loc7_,param3);
               _loc7_ = _loc7_ + _loc6_.height;
               param2 = param2.replace(_loc6_.regExpResult,"");
            }
            if(param2 != "")
            {
               _loc8_.identity();
               _loc8_.translate(0,_loc7_);
               param1.text = param2;
               this.addTextToBitmap(_loc4_,param1,_loc8_);
            }
         }
         return _loc4_;
      }
      
      private function addTextToBitmap(param1:BitmapData, param2:TextArea, param3:Matrix) : void
      {
         param1.draw(param2.bmpText as BitmapData,param3);
         this.formateLinks(param2,param1);
      }
      
      private function addImageToBitmap(param1:BitmapData, param2:ImageData, param3:int, param4:String) : void
      {
         var _loc5_:String = uiApi.me().getConstant("illus");
         var _loc6_:Texture = uiApi.createComponent("Texture") as Texture;
         _loc6_.visible = false;
         _loc6_.uri = uiApi.createUri(_loc5_ + param2.src);
         _loc6_.y = param3;
         _loc6_.cacheAsBitmap = true;
         _loc6_.dispatchMessages = true;
         uiApi.addComponentHook(_loc6_,"onTextureReady");
         if(param4 == "left")
         {
            this._leftPageTextureList.push(_loc6_);
         }
         else
         {
            this._rightPageTextureList.push(_loc6_);
         }
         this._loadingData[_loc6_] = {
            "bitmapdata":param1,
            "width":param2.width,
            "height":param2.height,
            "align":param2.align
         };
         _loc6_.finalize();
         this.mainCtr.addChild(_loc6_);
      }
      
      public function onTextureReady(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_pageLeft:
               this.finalizePage(this.page_left,"left");
               break;
            case this.tx_pageRight:
               this.finalizePage(this.page_right,"right");
               break;
            default:
               if(this._leftPageTextureList.indexOf(param1 as Texture) != -1)
               {
                  this.addTextureOnPage(this.page_left,param1);
               }
               else
               {
                  this.addTextureOnPage(this.page_right,param1);
               }
         }
      }
      
      private function addTextureOnPage(param1:GraphicContainer, param2:Object) : void
      {
         var _loc3_:BitmapData = this._loadingData[param2].bitmapdata;
         var _loc4_:int = param2.x;
         var _loc5_:int = param2.y;
         var _loc6_:Object = this._loadingData[param2];
         if(_loc6_.width == null || _loc6_.width == 0)
         {
            _loc6_.width = param2.width;
         }
         if(_loc6_.height == null || _loc6_.height == 0)
         {
            _loc6_.height = param2.height;
         }
         var _loc7_:Number = 1;
         if(_loc6_.width != null && _loc6_.width > 0)
         {
            _loc7_ = _loc6_.width / param2.width;
         }
         var _loc8_:Number = 1;
         if(_loc6_.height != null && _loc6_.height > 0)
         {
            _loc8_ = _loc6_.height / param2.height;
         }
         switch(_loc6_.align)
         {
            case "right":
               _loc4_ = param1.width - _loc6_.width;
               break;
            case "center":
               _loc4_ = (param1.width - _loc6_.width) / 2;
               break;
            case "left":
            default:
               _loc4_ = 0;
         }
         var _loc9_:Matrix = new Matrix();
         _loc9_.scale(_loc7_,_loc8_);
         _loc9_.translate(_loc4_,_loc5_);
         var _loc10_:Bitmap = new Bitmap(this.captureApi.getFromTarget(param2,null,1,true));
         _loc3_.draw(_loc10_,_loc9_);
      }
      
      private function finalizePage(param1:GraphicContainer, param2:String) : void
      {
         var _loc3_:LinkData = null;
         for each(_loc3_ in this._rectList)
         {
            if(_loc3_.page == param2)
            {
               _loc3_.parent = param1;
            }
         }
      }
      
      private function clearLinks() : void
      {
         var _loc1_:LinkData = null;
         if(this._rectList == null)
         {
            return;
         }
         for each(_loc1_ in this._rectList)
         {
            _loc1_.destroy();
         }
      }
      
      private function formateLinks(param1:TextArea, param2:BitmapData) : void
      {
         var _loc6_:GraphicContainer = null;
         var _loc7_:LinkData = null;
         var _loc8_:int = 0;
         var _loc9_:Rectangle = null;
         var _loc10_:Rectangle = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc3_:String = param1.text;
         var _loc4_:String = param1.textfield.htmlText;
         var _loc5_:Vector.<LinkData> = getAllLinks(_loc4_);
         for each(_loc7_ in _loc5_)
         {
            _loc8_ = _loc3_.indexOf(_loc7_.text);
            _loc9_ = param1.textfield.getCharBoundaries(_loc8_);
            _loc10_ = _loc9_.clone();
            _loc12_ = _loc7_.text.length;
            _loc11_ = 1;
            while(_loc11_ < _loc12_)
            {
               _loc9_ = param1.textfield.getCharBoundaries(_loc8_ + _loc11_);
               if(_loc9_ != null)
               {
                  _loc10_.width = _loc10_.width + _loc9_.width;
               }
               _loc11_++;
            }
            _loc6_ = uiApi.createContainer("GraphicContainer") as GraphicContainer;
            _loc7_.setGraphicData(_loc6_,this.mainCtr,_loc10_,new Point(param1.x,param1.y));
            uiApi.addComponentHook(_loc6_,"onRelease");
            this._rectList.push(_loc7_);
         }
         _loc5_ = null;
      }
      
      private function getNbOccurrencesInSentence(param1:String, param2:String) : int
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:String = param2;
         while((_loc4_ = _loc5_.search(param1)) != -1)
         {
            _loc3_++;
            _loc5_ = _loc5_.substr(_loc4_ + param1.length);
         }
         return _loc3_;
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_pageLeft:
               openDebugEditionPanel(this.page_right,this._pages[this._currentIndex - 1],this.tx_pageRight.x,this.tx_pageRight.y);
               break;
            case this.tx_pageRight:
               openDebugEditionPanel(this.page_left,this._pages[this._currentIndex],this.tx_pageLeft.x,this.tx_pageLeft.y);
         }
      }
      
      override public function updateDocumentContent(param1:GraphicContainer, param2:String) : void
      {
         switch(param1)
         {
            case this.page_right:
               this._pages[this._currentIndex - 1] = param2;
               this.clearTextures("left");
               this._updatePageLeft();
               break;
            case this.page_left:
               this._pages[this._currentIndex] = param2;
               this.clearTextures("right");
               this._updatePageRight();
         }
      }
      
      override public function copyAllDataToClipBoard() : void
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         var _loc3_:int = this._pages.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _loc1_ + (this._pages[_loc2_] + (_loc2_ < _loc3_ - 1?"<pagefeed/>":""));
            _loc2_++;
         }
         sysApi.copyToClipboard(_loc1_);
      }
   }
}
