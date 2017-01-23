package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.messages.TextClickMessage;
   import com.ankamagames.berilia.events.LinkInteractionEvent;
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.ExtendedStyleSheet;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.UserFont;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class Label extends GraphicContainer implements UIComponent, IRectangle, FinalizableUIComponent
   {
      
      public static var HEIGHT_OFFSET:int = 0;
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Label));
      
      private static const VALIGN_NONE:String = "NONE";
      
      private static const VALIGN_TOP:String = "TOP";
      
      private static const VALIGN_CENTER:String = "CENTER";
      
      private static const VALIGN_BOTTOM:String = "BOTTOM";
      
      private static const VALIGN_FIXEDHEIGHT:String = "FIXEDHEIGHT";
      
      private static const _filterIndex:Dictionary = new Dictionary();
       
      
      protected var _tText:TextField;
      
      private var _cssApplied:Boolean = false;
      
      protected var _sText:String = "";
      
      protected var _sType:String = "default";
      
      private var _binded:Boolean = false;
      
      private var _needToFinalize:Boolean = false;
      
      private var _lastWidth:Number = -1;
      
      protected var _sCssUrl:Uri;
      
      protected var _nWidth:uint = 100;
      
      protected var _nHeight:uint = 20;
      
      protected var _bHtmlAllowed:Boolean = true;
      
      protected var _sAntialiasType:String = "normal";
      
      protected var _bFixedWidth:Boolean = true;
      
      protected var _hyperlinkEnabled:Boolean = false;
      
      protected var _bFixedHeight:Boolean = true;
      
      protected var _bFixedHeightForMultiline:Boolean = false;
      
      protected var _aStyleObj:Array;
      
      protected var _ssSheet:ExtendedStyleSheet;
      
      protected var _tfFormatter:TextFormat;
      
      protected var _useEmbedFonts:Boolean = true;
      
      protected var _useDefaultFont:Boolean = false;
      
      protected var _nPaddingLeft:int = 0;
      
      protected var _nTextIndent:int = 0;
      
      protected var _verticalOffset:Number = 0.0;
      
      protected var _bDisabled:Boolean;
      
      protected var _nTextHeight:int;
      
      protected var _sVerticalAlign:String = "none";
      
      protected var _useExtendWidth:Boolean = false;
      
      protected var _autoResize:Boolean = true;
      
      protected var _useStyleSheet:Boolean = false;
      
      protected var _currentStyleSheet:StyleSheet;
      
      protected var _useCustomFormat:Boolean = false;
      
      protected var _neverIndent:Boolean = false;
      
      protected var _hasHandCursor:Boolean = false;
      
      protected var _shiftClickActivated:Boolean = true;
      
      protected var _forceUppercase:Boolean = false;
      
      private var _useTooltipExtension:Boolean = true;
      
      private var _textFieldTooltipExtension:TextField;
      
      private var _textTooltipExtensionColor:uint;
      
      private var _mouseOverHyperLink:Boolean;
      
      private var _lastHyperLinkId:int;
      
      private var _hyperLinks:Array;
      
      protected var _sCssClass:String;
      
      public function Label()
      {
         super();
         this.aStyleObj = new Array();
         this.createTextField();
         this._tText.type = TextFieldType.DYNAMIC;
         this._tText.selectable = false;
         this._tText.mouseEnabled = false;
         FontManager.getInstance().addEventListener(Event.CHANGE,this.onFontConfigChange,false,0,true);
         MEMORY_LOG[this] = 1;
      }
      
      public function get text() : String
      {
         return this._tText.text;
      }
      
      public function set text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         if(this._forceUppercase)
         {
            param1 = param1.toLocaleUpperCase();
         }
         this._sText = param1;
         if(this._bHtmlAllowed)
         {
            if(this._useStyleSheet)
            {
               this._tText.styleSheet = null;
            }
            this._tText.htmlText = param1;
            if(!this._useCustomFormat)
            {
               if(this._sCssUrl != null && !this._cssApplied)
               {
                  this.applyCSS(this._sCssUrl);
                  this._cssApplied = true;
               }
               else
               {
                  this.updateCss();
                  if(_bgColor != -1)
                  {
                     this.bgColor = _bgColor;
                  }
               }
            }
         }
         else
         {
            this._tText.text = param1;
         }
         if(!this._useCustomFormat)
         {
            if(!this._sCssClass)
            {
               this.cssClass = "p";
            }
         }
         if(this._hyperlinkEnabled)
         {
            HyperlinkFactory.createTextClickHandler(this._tText,this._useStyleSheet);
            HyperlinkFactory.createRollOverHandler(this._tText);
            this.parseLinks();
         }
         if(this._currentStyleSheet)
         {
            if(this._hyperlinkEnabled)
            {
               param1 = HyperlinkFactory.decode(param1);
               this.parseLinks();
            }
            this._tText.styleSheet = this._currentStyleSheet;
            this._tText.htmlText = param1;
         }
         if(_finalized && this._autoResize)
         {
            this.resizeText();
         }
      }
      
      public function get htmlText() : String
      {
         return this._tText.htmlText;
      }
      
      public function set htmlText(param1:String) : void
      {
         _log.warn("Warning ! You should better use the \'set text\' method than \'set htmlText\' to keep your label " + name + " in good shape.");
         if(this._forceUppercase)
         {
            param1 = param1.toLocaleUpperCase();
         }
         this._tText.htmlText = param1;
         if(this._hyperlinkEnabled)
         {
            this.parseLinks();
         }
      }
      
      public function get hyperlinkEnabled() : Boolean
      {
         return this._hyperlinkEnabled;
      }
      
      public function set hyperlinkEnabled(param1:Boolean) : void
      {
         this._hyperlinkEnabled = param1;
         mouseEnabled = param1;
         mouseChildren = param1;
         this._tText.mouseEnabled = param1;
         if(param1)
         {
            this._hyperLinks = new Array();
            this._tText.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this._tText.addEventListener(MouseEvent.ROLL_OUT,this.hyperlinkRollOut);
         }
         else
         {
            this._tText.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this._tText.removeEventListener(MouseEvent.ROLL_OUT,this.hyperlinkRollOut);
         }
      }
      
      public function get useStyleSheet() : Boolean
      {
         return this._useStyleSheet;
      }
      
      public function set useStyleSheet(param1:Boolean) : void
      {
         this._useStyleSheet = param1;
      }
      
      public function get useCustomFormat() : Boolean
      {
         return this._useCustomFormat;
      }
      
      public function set useCustomFormat(param1:Boolean) : void
      {
         this._useCustomFormat = param1;
      }
      
      public function get shiftClickActivated() : Boolean
      {
         return this._shiftClickActivated;
      }
      
      public function set shiftClickActivated(param1:Boolean) : void
      {
         this._shiftClickActivated = param1;
      }
      
      public function get neverIndent() : Boolean
      {
         return this._neverIndent;
      }
      
      public function set neverIndent(param1:Boolean) : void
      {
         this._neverIndent = param1;
      }
      
      public function get autoResize() : Boolean
      {
         return this._autoResize;
      }
      
      public function set autoResize(param1:Boolean) : void
      {
         this._autoResize = param1;
      }
      
      public function get caretIndex() : int
      {
         return this._tText.caretIndex;
      }
      
      public function set caretIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 == -1)
         {
            _loc2_ = this._tText.text.length;
            this._tText.setSelection(_loc2_,_loc2_);
         }
         else
         {
            this._tText.setSelection(param1,param1);
         }
      }
      
      public function selectAll() : void
      {
         this._tText.setSelection(0,this._tText.length);
      }
      
      public function get type() : String
      {
         return this._sType;
      }
      
      public function set type(param1:String) : void
      {
         this._sType = param1;
      }
      
      public function get css() : Uri
      {
         return this._sCssUrl;
      }
      
      public function set css(param1:Uri) : void
      {
         this._cssApplied = false;
         this.applyCSS(param1);
      }
      
      public function set cssClass(param1:String) : void
      {
         this._sCssClass = param1 == ""?"p":param1;
         this.bindCss();
      }
      
      public function get cssClass() : String
      {
         return this._sCssClass;
      }
      
      public function get antialias() : String
      {
         return this._sAntialiasType;
      }
      
      public function set antialias(param1:String) : void
      {
         this._sAntialiasType = param1;
         this._tText.antiAliasType = this._sAntialiasType;
      }
      
      public function get thickness() : int
      {
         return this._tText.thickness;
      }
      
      public function set thickness(param1:int) : void
      {
         this._tText.thickness = param1;
      }
      
      public function get forceUppercase() : Boolean
      {
         return this._forceUppercase;
      }
      
      public function set forceUppercase(param1:Boolean) : void
      {
         this._forceUppercase = param1;
         var _loc2_:String = this.text;
         this.text = _loc2_;
      }
      
      public function set aStyleObj(param1:Object) : void
      {
         this._aStyleObj = param1 as Array;
      }
      
      public function get aStyleObj() : Object
      {
         return this._aStyleObj;
      }
      
      override public function get width() : Number
      {
         return this._useExtendWidth && this._tText.numLines < 2?Number(this._tText.textWidth + 7):Number(this._nWidth);
      }
      
      override public function set width(param1:Number) : void
      {
         if(param1 == 0)
         {
            return;
         }
         this._nWidth = param1;
         this._tText.width = this._nWidth;
         super.width = param1;
         if(!this._bFixedHeight)
         {
            this.bindCss();
         }
         if(_finalized && this._autoResize)
         {
            this.resizeText();
         }
      }
      
      override public function get height() : Number
      {
         return this._nHeight;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(!this._tText.multiline)
         {
            _loc2_ = this._tText.textHeight;
            if(param1 < _loc2_)
            {
               param1 = _loc2_;
            }
         }
         this._nHeight = param1;
         this._tText.height = this._nHeight;
         __height = this._nHeight;
         if(_bgColor != -1)
         {
            this.bgColor = _bgColor;
         }
         this.updateAlign();
      }
      
      public function get textWidth() : Number
      {
         return this._tText.textWidth;
      }
      
      public function get textHeight() : Number
      {
         return this._tText.textHeight;
      }
      
      public function get html() : Boolean
      {
         return this._bHtmlAllowed;
      }
      
      public function set html(param1:Boolean) : void
      {
         this._bHtmlAllowed = param1;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         this._tText.wordWrap = param1;
      }
      
      public function get wordWrap() : Boolean
      {
         return this._tText.wordWrap;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         this._tText.multiline = param1;
      }
      
      public function get multiline() : Boolean
      {
         return this._tText.multiline;
      }
      
      public function get border() : Boolean
      {
         return this._tText.border;
      }
      
      public function set border(param1:Boolean) : void
      {
         this._tText.border = param1;
      }
      
      public function get fixedWidth() : Boolean
      {
         return this._bFixedWidth;
      }
      
      public function set fixedWidth(param1:Boolean) : void
      {
         this._bFixedWidth = param1;
         if(this._bFixedWidth)
         {
            this._tText.autoSize = TextFieldAutoSize.NONE;
         }
         else
         {
            this._tText.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      public function get useExtendWidth() : Boolean
      {
         return this._useExtendWidth;
      }
      
      public function set useExtendWidth(param1:Boolean) : void
      {
         this._useExtendWidth = param1;
      }
      
      public function get hasTooltipExtension() : Boolean
      {
         return this._textFieldTooltipExtension && this._textFieldTooltipExtension.text != "";
      }
      
      public function get fixedHeight() : Boolean
      {
         return this._bFixedHeight;
      }
      
      public function set fixedHeight(param1:Boolean) : void
      {
         this._bFixedHeight = param1;
         if(this._tText.wordWrap && param1)
         {
            _log.warn("Setting wordWrap to false as fixedHeight has been set to true!");
         }
         this._tText.wordWrap = !this._bFixedHeight;
      }
      
      public function get fixedHeightForMultiline() : Boolean
      {
         return this._bFixedHeightForMultiline;
      }
      
      public function set fixedHeightForMultiline(param1:Boolean) : void
      {
         this._bFixedHeightForMultiline = param1;
      }
      
      override public function set bgColor(param1:*) : void
      {
         setColorVar(param1);
         graphics.clear();
         if(bgColor == -1 || !this.width || !this.height)
         {
            return;
         }
         if(_borderColor != -1)
         {
            graphics.lineStyle(1,_borderColor);
         }
         graphics.beginFill(_bgColor,_bgAlpha);
         if(!_bgCornerRadius)
         {
            graphics.drawRect(x - _bgMargin,y,this.width + _bgMargin * 2,this.height + 2);
         }
         else
         {
            graphics.drawRoundRect(this._tText.x - _bgMargin,this._tText.y,this._tText.width + _bgMargin * 2,this._tText.height + 2,_bgCornerRadius,_bgCornerRadius);
         }
         graphics.endFill();
      }
      
      override public function set borderColor(param1:int) : void
      {
         if(param1 == -1)
         {
            this._tText.border = false;
         }
         else
         {
            this._tText.border = true;
            this._tText.borderColor = param1;
         }
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._tText.selectable = param1;
      }
      
      public function get length() : uint
      {
         return this._tText.length;
      }
      
      public function set scrollV(param1:int) : void
      {
         this._tText.scrollV = param1;
      }
      
      public function get scrollV() : int
      {
         this._tText.getCharBoundaries(0);
         return this._tText.scrollV;
      }
      
      public function get maxScrollV() : int
      {
         this._tText.getCharBoundaries(0);
         return this._tText.maxScrollV;
      }
      
      public function get textfield() : TextField
      {
         return this._tText;
      }
      
      public function get useEmbedFonts() : Boolean
      {
         return this._useEmbedFonts;
      }
      
      public function set useEmbedFonts(param1:Boolean) : void
      {
         this._useEmbedFonts = param1;
         this._tText.embedFonts = param1;
      }
      
      override public function set disabled(param1:Boolean) : void
      {
         if(param1)
         {
            this._hasHandCursor = handCursor;
            handCursor = false;
            mouseEnabled = false;
            this._tText.mouseEnabled = false;
         }
         else
         {
            if(!handCursor)
            {
               handCursor = this._hasHandCursor;
            }
            mouseEnabled = true;
            this._tText.mouseEnabled = true;
         }
         this._bDisabled = param1;
      }
      
      public function get verticalAlign() : String
      {
         return this._sVerticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         this._sVerticalAlign = param1;
         this.updateAlign();
      }
      
      public function get textFormat() : TextFormat
      {
         return this._tfFormatter;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         this._tfFormatter = param1;
         this._tText.setTextFormat(this._tfFormatter);
      }
      
      public function set restrict(param1:String) : void
      {
         this._tText.restrict = param1;
      }
      
      public function get restrict() : String
      {
         return this._tText.restrict;
      }
      
      public function set colorText(param1:uint) : void
      {
         if(!this._tfFormatter)
         {
            _log.error("Error. Try to change the size before formatter was initialized.");
            return;
         }
         this._tfFormatter.color = param1;
         this._tText.setTextFormat(this._tfFormatter);
         this._tText.defaultTextFormat = this._tfFormatter;
      }
      
      public function get useDefaultFont() : Boolean
      {
         return this._useDefaultFont;
      }
      
      public function set useDefaultFont(param1:Boolean) : void
      {
         this._useDefaultFont = param1;
      }
      
      public function setCssColor(param1:String, param2:String = null) : void
      {
         this.changeCssClassColor(param1,param2);
      }
      
      public function setCssSize(param1:uint, param2:String = null) : void
      {
         this.changeCssClassSize(param1,param2);
      }
      
      public function setCssFont(param1:String, param2:String = null) : void
      {
         this.changeCssClassFont(param1,param2);
      }
      
      public function setStyleSheet(param1:StyleSheet) : void
      {
         this._useStyleSheet = true;
         this._currentStyleSheet = param1;
      }
      
      protected function onFontConfigChange(param1:Event) : void
      {
         this.bindCss();
      }
      
      public function applyCSS(param1:Uri) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 == this._sCssUrl && this._tfFormatter)
         {
            this.updateCss();
         }
         else
         {
            this._sCssUrl = param1;
            CssManager.getInstance().askCss(param1.uri,new Callback(this.bindCss));
         }
      }
      
      public function setBorderColor(param1:int) : void
      {
         this._tText.borderColor = param1;
      }
      
      public function allowTextMouse(param1:Boolean) : void
      {
         this.mouseChildren = param1;
         this._tText.mouseEnabled = param1;
      }
      
      override public function remove() : void
      {
         super.remove();
         if(this._tText && this._tText.parent)
         {
            removeChild(this._tText);
         }
         TooltipManager.hide("TextExtension");
         this._tText.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this._tText.removeEventListener(MouseEvent.ROLL_OUT,this.hyperlinkRollOut);
      }
      
      override public function free() : void
      {
         super.free();
         this._sType = "default";
         this._nWidth = 100;
         this._nHeight = 20;
         this._bHtmlAllowed = true;
         this._sAntialiasType = AntiAliasType.NORMAL;
         this._bFixedWidth = true;
         this._bFixedHeight = true;
         this._bFixedHeightForMultiline = false;
         this._ssSheet = null;
         this._useEmbedFonts = true;
         this._nPaddingLeft = 0;
         this._nTextIndent = 0;
         this._bDisabled = false;
         this._nTextHeight = 0;
         this._sVerticalAlign = "none";
         this._useExtendWidth = false;
         this._sCssClass = null;
         this._tText.type = TextFieldType.DYNAMIC;
         this._tText.selectable = false;
      }
      
      private function createTextField() : void
      {
         this._tText = new TextField();
         this._tText.addEventListener(TextEvent.LINK,this.onTextClick);
         addChild(this._tText);
      }
      
      private function changeCssClassColor(param1:String, param2:String = null) : void
      {
         var _loc3_:* = undefined;
         if(param2)
         {
            if(this.aStyleObj[param2] == null)
            {
               this.aStyleObj[param2] = new Object();
            }
            this.aStyleObj[param2].color = param1;
            if(this._ssSheet)
            {
               this._tfFormatter = this._ssSheet.transform(this.aStyleObj[param2]);
               this._tText.setTextFormat(this._tfFormatter);
               this._tText.defaultTextFormat = this._tfFormatter;
            }
         }
         else
         {
            for each(_loc3_ in this.aStyleObj)
            {
               _loc3_.color = param1;
            }
         }
      }
      
      private function changeCssClassSize(param1:uint, param2:String = null) : void
      {
         var _loc3_:* = undefined;
         if(param2)
         {
            if(this.aStyleObj[param2] == null)
            {
               this.aStyleObj[param2] = new Object();
            }
            this.aStyleObj[param2].fontSize = param1;
         }
         else
         {
            for each(_loc3_ in this.aStyleObj)
            {
               _loc3_.fontSize = param1;
            }
         }
      }
      
      private function changeCssClassFont(param1:String, param2:String = null) : void
      {
         var _loc3_:* = undefined;
         if(param2)
         {
            if(this.aStyleObj[param2] == null)
            {
               this.aStyleObj[param2] = new Object();
            }
            this.aStyleObj[param2].fontFamily = param1;
         }
         else
         {
            for each(_loc3_ in this.aStyleObj)
            {
               _loc3_.fontFamily = param1;
            }
         }
      }
      
      public function appendText(param1:String, param2:String = null) : void
      {
         var _loc3_:TextFormat = null;
         if(this._forceUppercase)
         {
            param1 = param1.toLocaleUpperCase();
         }
         if(param2 && this.aStyleObj[param2] && this._ssSheet)
         {
            if(this._tText.filters.length)
            {
               this._tText.filters = new Array();
            }
            _loc3_ = this._ssSheet.transform(this.aStyleObj[param2]);
            if(!_loc3_.bold)
            {
               _loc3_.bold = false;
            }
            this._tText.defaultTextFormat = _loc3_;
         }
         if(this._hyperlinkEnabled)
         {
            param1 = HyperlinkFactory.decode(param1);
         }
         this._tText.htmlText = this._tText.htmlText + param1;
         if(this._hyperlinkEnabled)
         {
            this.parseLinks();
         }
      }
      
      public function activeSmallHyperlink() : void
      {
         HyperlinkFactory.activeSmallHyperlink(this._tText);
      }
      
      private function bindCss() : void
      {
         var styleToDisplay:String = null;
         var s:String = null;
         var effectName:String = null;
         var filtersTmp:Array = null;
         var filterRef:Dictionary = null;
         var cssKey:String = null;
         var filter:BitmapFilter = null;
         var oldSize:Number = NaN;
         var font:String = null;
         if(!this._sCssUrl)
         {
            if(this._needToFinalize)
            {
               this.finalize();
            }
            return;
         }
         var oldCss:ExtendedStyleSheet = this._ssSheet;
         this._ssSheet = CssManager.getInstance().getCss(this._sCssUrl.uri);
         if(!this._ssSheet)
         {
            if(this._needToFinalize)
            {
               this.finalize();
            }
            return;
         }
         var currentStyleSheet:StyleSheet = this._tText.styleSheet;
         this._tText.styleSheet = null;
         var stylesSizes:Object = new Array();
         for(s in this.aStyleObj)
         {
            stylesSizes[s] = this.aStyleObj[s].fontSize;
         }
         this.aStyleObj = new Array();
         for each(s in this._ssSheet.styleNames)
         {
            if(!styleToDisplay || s == this._sCssClass || this._sCssClass != styleToDisplay && s == "p")
            {
               styleToDisplay = s;
            }
            if(this._ssSheet != oldCss || !this.aStyleObj[s])
            {
               this.aStyleObj[s] = this._ssSheet.getStyle(s);
            }
            if(stylesSizes[s])
            {
               this.aStyleObj[s].fontSize = stylesSizes[s];
            }
         }
         filtersTmp = [];
         filterRef = new Dictionary();
         for(cssKey in this.aStyleObj[styleToDisplay])
         {
            effectName = cssKey.indexOf("shadow") != -1?"shadow":null;
            effectName = !effectName && cssKey.indexOf("glow") != -1?"glow":effectName;
            if(effectName)
            {
               if(!filterRef[effectName])
               {
                  if(effectName == "shadow")
                  {
                     filter = new DropShadowFilter();
                  }
                  else if(effectName == "glow")
                  {
                     filter = new GlowFilter();
                  }
                  this.buildFilterIndex(filter);
                  filtersTmp.push(filter);
                  filterRef[effectName] = filter;
               }
               else
               {
                  filter = filterRef[effectName];
               }
               try
               {
                  filter[_filterIndex[getQualifiedClassName(filter)][cssKey.substr(effectName.length).toLowerCase()]] = parseInt(this.aStyleObj[styleToDisplay][cssKey]);
               }
               catch(e:Error)
               {
                  _log.error(e);
                  continue;
               }
            }
         }
         filters = filtersTmp;
         if(this.aStyleObj[styleToDisplay]["useEmbedFonts"])
         {
            this._useEmbedFonts = this.aStyleObj[styleToDisplay]["useEmbedFonts"] == "true";
         }
         if(this.aStyleObj[styleToDisplay]["paddingLeft"])
         {
            this._nPaddingLeft = parseInt(this.aStyleObj[styleToDisplay]["paddingLeft"]);
         }
         if(this.aStyleObj[styleToDisplay]["verticalHeight"])
         {
            this._nTextHeight = parseInt(this.aStyleObj[styleToDisplay]["verticalHeight"]);
         }
         if(this.aStyleObj[styleToDisplay]["verticalAlign"])
         {
            this.verticalAlign = this.aStyleObj[styleToDisplay]["verticalAlign"];
         }
         if(this.aStyleObj[styleToDisplay]["thickness"])
         {
            this._tText.thickness = this.aStyleObj[styleToDisplay]["thickness"];
         }
         this._tText.gridFitType = GridFitType.PIXEL;
         this._tText.htmlText = !!this._sText?this._sText:this.text;
         this._tfFormatter = this._ssSheet.transform(this.aStyleObj[styleToDisplay]);
         if(this.aStyleObj[styleToDisplay]["leading"])
         {
            this._tfFormatter.leading = this.aStyleObj[styleToDisplay]["leading"];
         }
         if(this.aStyleObj[styleToDisplay]["letterSpacing"])
         {
            this._tfFormatter.letterSpacing = parseFloat(this.aStyleObj[styleToDisplay]["letterSpacing"]);
         }
         if(this.aStyleObj[styleToDisplay]["kerning"])
         {
            this._tfFormatter.kerning = this.aStyleObj[styleToDisplay]["kerning"] == "true";
         }
         if(!this._neverIndent)
         {
            this._tfFormatter.indent = this._nTextIndent;
         }
         this._tfFormatter.leftMargin = this._nPaddingLeft;
         var fontInfo:UserFont = FontManager.getInstance().getFontInfo(this._tfFormatter.font,this._useDefaultFont);
         if(this._useEmbedFonts)
         {
            if(fontInfo)
            {
               oldSize = this._tfFormatter.size != null?Number(Number(this._tfFormatter.size)):Number(12);
               if(fontInfo.maxSize != UserFont.FONT_SIZE_NO_MAX && this._tfFormatter.size < fontInfo.maxSize)
               {
                  this._tfFormatter.size = Math.min(Math.round(int(this._tfFormatter.size) * fontInfo.sizeMultiplicator),fontInfo.maxSize != UserFont.FONT_SIZE_NO_MAX?Number(fontInfo.maxSize):Number(1000));
                  this._verticalOffset = ((this._tfFormatter.size != null?Number(this._tfFormatter.size):12) - oldSize) * fontInfo.verticalOffset;
               }
               this._tfFormatter.font = fontInfo.className;
               this._tText.defaultTextFormat.font = fontInfo.className;
               this._tText.embedFonts = true;
               this._tText.antiAliasType = AntiAliasType.ADVANCED;
               this._tText.sharpness = fontInfo.sharpness;
               if(this._tfFormatter.letterSpacing < fontInfo.letterSpacing)
               {
                  this._tfFormatter.letterSpacing = fontInfo.letterSpacing;
               }
               if(this._tfFormatter.letterSpacing == null)
               {
                  this._tfFormatter.letterSpacing = 0.0001;
               }
            }
            else if(this._tfFormatter)
            {
               _log.warn("System font [" + this._tfFormatter.font + "] used (in " + (!!getUi()?getUi().name:"unknow") + ", from " + this._sCssUrl.uri + ")");
            }
            else
            {
               _log.fatal("Erreur de formattage.");
            }
         }
         else
         {
            font = !!fontInfo?fontInfo.realName:"";
            this._tfFormatter.font = font != ""?font:this._tfFormatter.font;
            this._tText.embedFonts = false;
         }
         this._tText.setTextFormat(this._tfFormatter);
         this._tText.defaultTextFormat = this._tfFormatter;
         if(this._hyperlinkEnabled)
         {
            HyperlinkFactory.createTextClickHandler(this._tText,true);
            HyperlinkFactory.createRollOverHandler(this._tText);
            this.parseLinks();
         }
         if(this._nTextHeight)
         {
            this._tText.height = this._nTextHeight;
            this._tText.y = this._tText.y + (this._nHeight / 2 - this._tText.height / 2);
         }
         else if(!this._bFixedHeight)
         {
            this._tText.height = this._tText.textHeight + 5;
            this._nHeight = this._tText.height;
         }
         else
         {
            this._tText.height = this._nHeight;
         }
         if(this._useExtendWidth)
         {
            this._tText.width = this._tText.textWidth + 7;
            this._nWidth = this._tText.width;
         }
         if(_bgColor != -1)
         {
            this.bgColor = _bgColor;
         }
         this.updateAlign();
         if(this._useExtendWidth && getUi())
         {
            getUi().render();
         }
         this._binded = true;
         this.updateTooltipExtensionStyle();
         if(this._needToFinalize)
         {
            this.finalize();
         }
      }
      
      public function updateCss() : void
      {
         if(!this._tfFormatter)
         {
            return;
         }
         this._tText.setTextFormat(this._tfFormatter);
         this._tText.defaultTextFormat = this._tfFormatter;
         this.updateTooltipExtensionStyle();
         if(!this._bFixedHeight)
         {
            this._tText.height = this._tText.textHeight + 5;
            this._nHeight = this._tText.height;
         }
         else
         {
            this._tText.height = this._nHeight;
         }
         if(this._useExtendWidth)
         {
            this._tText.width = this._tText.textWidth + 7;
            this._nWidth = this._tText.width;
         }
         if(_bgColor != -1)
         {
            this.bgColor = _bgColor;
         }
         this.updateAlign();
         if(this._useExtendWidth && getUi())
         {
            getUi().render();
         }
      }
      
      public function updateTextFormatProperty(param1:String, param2:*) : void
      {
         this._tfFormatter[param1] = param2;
         this.updateCss();
      }
      
      public function fullSize(param1:int) : void
      {
         this.removeTooltipExtension();
         this._nWidth = param1;
         this._tText.width = param1;
         var _loc2_:uint = this._tText.textHeight + 8;
         this._tText.height = _loc2_;
         this._nHeight = _loc2_;
      }
      
      public function fullWidth(param1:uint = 0, param2:uint = 5) : void
      {
         this._nWidth = int(this._tText.textWidth + param2);
         this._tText.width = this._nWidth;
         if(param1 > 0)
         {
            this._nWidth = param1;
            this._tText.width = param1;
            if(this._tText.textWidth < param1)
            {
               this._tText.width = this._tText.textWidth + 10;
            }
         }
         this._nHeight = this._tText.textHeight + 8;
         this._tText.height = this._nHeight;
      }
      
      public function resizeText() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         this.removeTooltipExtension();
         if((this._bFixedHeight && !this._tText.multiline || this._bFixedHeightForMultiline) && this._tText.autoSize == "none" && this._tfFormatter)
         {
            _loc1_ = false;
            _loc2_ = this._tText.width;
            if(this._tText.textWidth > _loc2_ + 1 || this._tText.textHeight > this._tText.height || this._bFixedHeightForMultiline && this._tText.textHeight > this.height)
            {
               if(this._useTooltipExtension)
               {
                  _loc1_ = true;
               }
               else
               {
                  _log.warn("Attention : Ce texte est beaucoup trop long pour entrer dans ce TextField (Texte : " + this._tText.text + ")");
               }
            }
            if(_loc1_ && (!this.multiline && this._bFixedHeight || this._bFixedHeightForMultiline))
            {
               this.addTooltipExtension();
            }
            else if(this._lastWidth != this._tText.width)
            {
               this._lastWidth = this._tText.width;
            }
         }
      }
      
      public function truncateText(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         this._nHeight = __height = this._tText.height = param1;
         if(this._tText.wordWrap && this._tText.numLines > 0)
         {
            _loc3_ = this._tText.numLines;
            _loc7_ = 4;
            _loc8_ = this._tText.getLineMetrics(0).height;
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc7_ = _loc7_ + _loc8_;
               if(_loc7_ < this._tText.height)
               {
                  _loc4_++;
                  _loc5_ = _loc5_ + this._tText.getLineLength(_loc6_);
                  _loc6_++;
                  continue;
               }
               break;
            }
            this._tText.text = this._tText.text.substr(0,_loc5_);
            if(param2)
            {
               _loc9_ = this._tText.text.lastIndexOf(String.fromCharCode(10));
               _loc10_ = this._tText.text.lastIndexOf(".");
               if(_loc9_ != -1 || _loc10_ != -1)
               {
                  this._tText.text = this._tText.text.substring(0,Math.max(_loc9_,_loc10_));
                  this._tText.appendText(" (" + String.fromCharCode(8230) + ")");
                  this._nHeight = __height = this._tText.height = this._tText.height - (_loc4_ - this._tText.numLines) * _loc8_;
               }
               else
               {
                  this.addEllipsis();
               }
            }
            else
            {
               this.addEllipsis();
            }
         }
      }
      
      public function removeTooltipExtension() : void
      {
         if(this._textFieldTooltipExtension)
         {
            removeChild(this._textFieldTooltipExtension);
            this._tText.width = __width + int(this._textFieldTooltipExtension.width + 2);
            __width = this._tText.width;
            this._textFieldTooltipExtension.removeEventListener(MouseEvent.ROLL_OVER,this.onTooltipExtensionOver);
            this._textFieldTooltipExtension.removeEventListener(MouseEvent.ROLL_OUT,this.onTooltipExtensionOut);
            this._textFieldTooltipExtension = null;
         }
      }
      
      private function buildFilterIndex(param1:BitmapFilter) : void
      {
         var _loc4_:String = null;
         if(_filterIndex[getQualifiedClassName(param1)])
         {
            return;
         }
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:Array = DescribeTypeCache.getVariables(param1);
         for each(_loc4_ in _loc3_)
         {
            _loc2_[_loc4_.toLowerCase()] = _loc4_;
         }
         _filterIndex[getQualifiedClassName(param1)] = _loc2_;
      }
      
      private function addEllipsis() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._tText.text.length - 3 > 0)
         {
            this._tText.text = this._tText.text.substr(0,this._tText.text.length - 3);
            _loc1_ = this._tText.text.length - 1;
            while(_loc1_ >= 0 && this._tText.text.charAt(_loc1_) == " ")
            {
               _loc2_++;
               _loc1_--;
            }
            if(_loc2_ > 0)
            {
               this._tText.text = this._tText.text.substr(0,this._tText.text.length - _loc2_);
            }
            this._tText.appendText(String.fromCharCode(8230));
         }
      }
      
      private function addTooltipExtension() : void
      {
         this._textFieldTooltipExtension = new TextField();
         this._textFieldTooltipExtension.selectable = false;
         this._textFieldTooltipExtension.height = 1;
         this._textFieldTooltipExtension.width = 1;
         this._textFieldTooltipExtension.autoSize = TextFieldAutoSize.LEFT;
         this.updateTooltipExtensionStyle();
         this._textFieldTooltipExtension.text = "...";
         this._textFieldTooltipExtension.name = "extension_" + name;
         addChild(this._textFieldTooltipExtension);
         var _loc1_:int = this._textFieldTooltipExtension.width + 2;
         this._tText.width = this._tText.width - _loc1_;
         __width = this._tText.width;
         this._textFieldTooltipExtension.x = this._tText.width;
         this._textFieldTooltipExtension.y = this._tText.y + this._tText.height - this._textFieldTooltipExtension.textHeight - 10;
         if(!this._tText.wordWrap)
         {
            this._textFieldTooltipExtension.y = this._tText.y;
            this._tText.height = this._tText.textHeight + 3;
            __height = this._tText.height;
         }
         else if(this._bFixedHeightForMultiline)
         {
            this._tText.height = this.height + 3;
            __height = this._tText.height;
            switch(this._sVerticalAlign.toUpperCase())
            {
               case VALIGN_CENTER:
                  this._tText.y = (this.height - this._tText.height) / 2;
                  break;
               case VALIGN_BOTTOM:
                  this._tText.y = this.height - this._tText.height;
                  break;
               default:
                  this._tText.y = 0;
            }
            this._textFieldTooltipExtension.y = this._tText.y + this.height - this._textFieldTooltipExtension.textHeight;
         }
         var _loc2_:DisplayObjectContainer = this;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            if(_loc2_ is ButtonContainer)
            {
               (_loc2_ as ButtonContainer).mouseChildren = true;
               break;
            }
            _loc2_ = _loc2_.parent;
            if(!_loc2_)
            {
               break;
            }
            _loc3_++;
         }
         this._textFieldTooltipExtension.addEventListener(MouseEvent.ROLL_OVER,this.onTooltipExtensionOver,false,0,true);
         this._textFieldTooltipExtension.addEventListener(MouseEvent.ROLL_OUT,this.onTooltipExtensionOut,false,0,true);
         this._textFieldTooltipExtension.addEventListener(MouseEvent.MOUSE_WHEEL,this.onTooltipExtensionOut,false,0,true);
      }
      
      private function updateTooltipExtensionStyle() : void
      {
         if(!this._textFieldTooltipExtension)
         {
            return;
         }
         this._textFieldTooltipExtension.embedFonts = this._tText.embedFonts;
         this._textFieldTooltipExtension.defaultTextFormat = this._tfFormatter;
         this._textFieldTooltipExtension.setTextFormat(this._tfFormatter);
         this._textTooltipExtensionColor = uint(this._tfFormatter.color);
         this._textFieldTooltipExtension.textColor = this._textTooltipExtensionColor;
      }
      
      private function onTextClick(param1:TextEvent) : void
      {
         param1.stopPropagation();
         Berilia.getInstance().handler.process(new TextClickMessage(this,param1.text));
      }
      
      protected function updateAlign() : void
      {
         if(!this._tText.textHeight)
         {
            return;
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._tText.numLines)
         {
            _loc1_ = _loc1_ + (TextLineMetrics(this._tText.getLineMetrics(_loc2_)).height + TextLineMetrics(this._tText.getLineMetrics(_loc2_)).leading + TextLineMetrics(this._tText.getLineMetrics(_loc2_)).descent);
            _loc2_++;
         }
         this._tText.y = 0;
         switch(this._sVerticalAlign.toUpperCase())
         {
            case VALIGN_CENTER:
               this._tText.height = _loc1_;
               this._tText.y = (this.height - this._tText.height) / 2;
               break;
            case VALIGN_BOTTOM:
               this._tText.height = this.height;
               this._tText.y = this.height - _loc1_;
               break;
            case VALIGN_TOP:
               this._tText.height = _loc1_;
               this._tText.y = 0;
               break;
            case VALIGN_FIXEDHEIGHT:
               if(!this._tText.wordWrap || this._tText.multiline)
               {
                  this._tText.height = this._tText.textHeight + HEIGHT_OFFSET;
               }
               this._tText.y = 0;
               break;
            case VALIGN_NONE:
               if(!this._tText.wordWrap || this._tText.multiline)
               {
                  this._tText.height = this._tText.textHeight + 4 + HEIGHT_OFFSET;
               }
               this._tText.y = 0;
         }
         if(this._tfFormatter && FontManager.getInstance().getFontInfo(this._tfFormatter.font))
         {
            this._tText.y = this._tText.y + this._verticalOffset;
         }
      }
      
      private function onTooltipExtensionOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = Berilia.getInstance().docMain;
         TooltipManager.show(new TextTooltipInfo(this._tText.text),this,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"TextExtension",LocationEnum.POINT_TOP,LocationEnum.POINT_BOTTOM,20,true,null,TooltipManager.defaultTooltipUiScript,null,"TextInfo");
         this._textFieldTooltipExtension.textColor = XmlConfig.getInstance().getEntry("colors.hyperlink.link");
      }
      
      private function onTooltipExtensionOut(param1:MouseEvent = null) : void
      {
         TooltipManager.hide("TextExtension");
         this._textFieldTooltipExtension.textColor = this._textTooltipExtensionColor;
      }
      
      override public function finalize() : void
      {
         var _loc1_:UiRootContainer = null;
         if(this._binded)
         {
            if(this._autoResize)
            {
               this.resizeText();
            }
            if(this._hyperlinkEnabled)
            {
               HyperlinkFactory.createTextClickHandler(this._tText);
               HyperlinkFactory.createRollOverHandler(this._tText);
               this.parseLinks();
            }
            _finalized = true;
            super.finalize();
            _loc1_ = getUi();
            if(_loc1_)
            {
               _loc1_.iAmFinalized(this);
            }
         }
         else
         {
            this._needToFinalize = true;
         }
      }
      
      public function get bmpText() : BitmapData
      {
         var _loc1_:Matrix = new Matrix();
         var _loc2_:BitmapData = new BitmapData(this.width,this.height,true,16711680);
         _loc2_.draw(this._tText,_loc1_,null,null,null,true);
         return _loc2_;
      }
      
      private function parseLinks() : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:Array = this._tText.getTextRuns();
         var _loc4_:int = _loc1_.length;
         this._lastHyperLinkId = -1;
         this._hyperLinks.length = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc4_)
         {
            _loc2_ = _loc1_[_loc8_];
            if(_loc2_.textFormat && _loc2_.textFormat.url.length > 0)
            {
               _loc3_ = this._tText.text.substring(_loc2_.beginIndex,_loc2_.endIndex);
               _loc5_ = StringUtils.getAllIndexOf("[",_loc3_);
               _loc6_ = StringUtils.getAllIndexOf("]",_loc3_);
               if(_loc5_.length > 1 && _loc5_.length == _loc6_.length)
               {
                  _loc7_ = _loc5_.length;
                  _loc9_ = 0;
                  while(_loc9_ < _loc7_)
                  {
                     this._hyperLinks.push({
                        "beginIndex":_loc2_.beginIndex + _loc5_[_loc9_],
                        "endIndex":_loc2_.beginIndex + _loc6_[_loc9_],
                        "textFormat":_loc2_.textFormat
                     });
                     _loc9_++;
                  }
               }
               else
               {
                  this._hyperLinks.push(_loc2_);
               }
            }
            _loc8_++;
         }
      }
      
      private function getHyperLinkId(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:int = this._hyperLinks.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1 >= this._hyperLinks[_loc4_].beginIndex && param1 <= this._hyperLinks[_loc4_].endIndex)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:Point = null;
         var _loc16_:String = null;
         if(this._tText.length > 0)
         {
            _loc2_ = this._tText.getCharIndexAtPoint(param1.localX,param1.localY);
            _loc3_ = 4;
            _loc5_ = this._tText.getLineMetrics(0).height;
            _loc7_ = this._tText.numLines;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc3_ = _loc3_ + _loc5_;
               if(_loc3_ <= this._tText.height)
               {
                  _loc4_++;
                  _loc6_++;
                  continue;
               }
               break;
            }
            _loc8_ = this._tText.height - _loc4_ * _loc5_;
            _loc9_ = parent.localToGlobal(new Point(x,y));
            _loc10_ = param1.stageY > _loc9_.y + this._tText.height - _loc8_?false:true;
            if(_loc10_ && _loc2_ != -1)
            {
               _loc11_ = this.getHyperLinkId(_loc2_);
               _loc12_ = _loc11_ >= 0?this._hyperLinks[_loc11_].textFormat.url:null;
               if(_loc12_)
               {
                  if(this._mouseOverHyperLink && (this._lastHyperLinkId >= 0 && _loc11_ != this._lastHyperLinkId))
                  {
                     this._mouseOverHyperLink = true;
                     this.hyperlinkRollOut();
                  }
                  if(!this._mouseOverHyperLink)
                  {
                     _loc13_ = _loc12_.replace("event:","").split(",");
                     _loc14_ = _loc13_.shift();
                     _loc15_ = new Point(param1.stageX,_loc9_.y + this._tText.getCharBoundaries(_loc2_).y);
                     _loc16_ = _loc14_ + "," + Math.round(_loc15_.x) + "," + Math.round(_loc15_.y) + "," + _loc13_.join(",");
                     this._tText.dispatchEvent(new LinkInteractionEvent(LinkInteractionEvent.ROLL_OVER,_loc16_));
                     this._mouseOverHyperLink = true;
                     this._lastHyperLinkId = _loc11_;
                  }
               }
               else
               {
                  this.hyperlinkRollOut();
               }
            }
            else
            {
               this.hyperlinkRollOut();
            }
         }
      }
      
      private function hyperlinkRollOut(param1:MouseEvent = null) : void
      {
         if(param1 || this._mouseOverHyperLink)
         {
            TooltipManager.hideAll();
            this._tText.dispatchEvent(new LinkInteractionEvent(LinkInteractionEvent.ROLL_OUT));
         }
         this._mouseOverHyperLink = false;
      }
   }
}
