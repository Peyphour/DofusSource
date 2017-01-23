package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.messages.ItemRollOutMessage;
   import com.ankamagames.berilia.components.messages.ItemRollOverMessage;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.berilia.types.uiDefinition.SizeElement;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.interfaces.ICustomUnicNameGetter;
   import com.ankamagames.jerakine.interfaces.IDragAndDropHandler;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.pools.GenericPool;
   import com.ankamagames.jerakine.pools.Poolable;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import gs.TweenLite;
   import gs.TweenMax;
   import gs.easing.Circ;
   import gs.easing.Expo;
   import gs.easing.Strong;
   
   public class GraphicContainer extends Sprite implements UIComponent, IRectangle, Poolable, IDragAndDropHandler, ICustomUnicNameGetter, FinalizableUIComponent
   {
      
      public static const COLOR_TRANSFORM_DEFAULT:ColorTransform = new ColorTransform(1,1,1,1);
      
      public static const COLOR_TRANSFORM_DISABLED:ColorTransform = new ColorTransform(0.6,0.6,0.6,1);
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GraphicContainer));
       
      
      protected var __width:uint;
      
      protected var __widthReal:uint;
      
      protected var __height:uint;
      
      protected var __heightReal:uint;
      
      protected var __removed:Boolean;
      
      protected var _bgColor:int = -1;
      
      protected var _bgAlpha:Number = 1;
      
      protected var _bgMargin:Number = 0;
      
      protected var _borderColor:int = -1;
      
      protected var _bgCornerRadius:uint = 0;
      
      protected var _isSizeControler:Boolean = false;
      
      protected var _aStrata:Array;
      
      private var _scale:Number = 1.0;
      
      private var _sLinkedTo:String;
      
      private var _bDynamicPosition:Boolean;
      
      private var _bDisabled:Boolean;
      
      private var _bSoftDisabled:Boolean;
      
      private var _bGreyedOut:Boolean;
      
      private var _shadow:DropShadowFilter;
      
      private var _luminosity:Number = 1.0;
      
      private var _shResizeBorder:Shape;
      
      private var _bUseSimpleResize:Boolean = false;
      
      var _uiRootContainer:UiRootContainer;
      
      var _resizeController:ResizeController;
      
      var _dragController:DragControler;
      
      private var _dropValidatorFunction:Function;
      
      private var _processDropFunction:Function;
      
      private var _removeDropSourceFunction:Function;
      
      private var _themeDataId:String;
      
      private var _isMagnetic:Boolean;
      
      private var _customName:String;
      
      protected var _finalized:Boolean;
      
      public var minSize:GraphicSize;
      
      public var maxSize:GraphicSize;
      
      public function GraphicContainer()
      {
         this._dropValidatorFunction = this.defaultDropValidatorFunction;
         this._processDropFunction = this.defaultProcessDropFunction;
         this._removeDropSourceFunction = this.defaultRemoveDropSourceFunction;
         super();
         this._aStrata = new Array();
         focusRect = false;
         this.mouseEnabled = false;
         doubleClickEnabled = true;
      }
      
      public function get isMagnetic() : Boolean
      {
         return this._isMagnetic;
      }
      
      public function set isMagnetic(param1:Boolean) : void
      {
         this._isMagnetic = param1;
         if(param1)
         {
            this.getUi().registerMagneticElement(this);
         }
         else
         {
            this.getUi().removeMagneticElement(this);
         }
      }
      
      public function get dragSavePosition() : Boolean
      {
         return this._dragController != null?Boolean(this._dragController.savePosition):false;
      }
      
      public function set dragSavePosition(param1:Boolean) : void
      {
         if(!this._dragController)
         {
            this.dragController = true;
         }
         this._dragController.savePosition = param1;
      }
      
      public function get resizeController() : Boolean
      {
         return this._resizeController != null;
      }
      
      public function set resizeController(param1:Boolean) : void
      {
         if(!param1 && this._resizeController)
         {
            if(this._resizeController.parent)
            {
               this._resizeController.parent.removeChild(this._resizeController);
            }
            this._resizeController.destroy();
            this._resizeController = null;
         }
         else if(param1 && !this._resizeController)
         {
            this._resizeController = new ResizeController();
            this._resizeController.width = this.width;
            this._resizeController.height = this.height;
            this._resizeController.controler = this;
            this.getStrata(StrataEnum.STRATA_LOW).addChild(this._resizeController);
         }
      }
      
      public function get resizeTarget() : String
      {
         return this._resizeController != null?this._resizeController.target:null;
      }
      
      public function set resizeTarget(param1:String) : void
      {
         if(!this._resizeController)
         {
            this.resizeController = true;
         }
         this._resizeController.target = param1;
      }
      
      public function get dragTarget() : String
      {
         return !!this._dragController?this._dragController.target:null;
      }
      
      public function set dragTarget(param1:String) : void
      {
         if(param1 == "null")
         {
            param1 = null;
         }
         if(param1)
         {
            if(!this.dragController)
            {
               this.dragController = true;
            }
            this._dragController.target = param1;
         }
         else if(this.dragController)
         {
            this.dragController = false;
         }
      }
      
      public function set dragBoundsContainer(param1:String) : void
      {
         if(!this.dragController)
         {
            this.dragController = true;
         }
         this._dragController.boundsContainer = param1;
      }
      
      public function get dragBoundsContainer() : String
      {
         return this._dragController != null?this._dragController.boundsContainer:null;
      }
      
      public function set useDragMagnetism(param1:Boolean) : void
      {
         if(!this.dragController)
         {
            this.dragController = true;
         }
         this._dragController.useDragMagnetism = param1;
      }
      
      public function get useDragMagnetism() : Boolean
      {
         return this._dragController != null?Boolean(this._dragController.useDragMagnetism):false;
      }
      
      public function set verticalDrag(param1:Boolean) : void
      {
         if(!this.dragController)
         {
            this.dragController = true;
         }
         this._dragController.verticalDrag = param1;
      }
      
      public function get verticalDrag() : Boolean
      {
         return this._dragController != null?Boolean(this._dragController.verticalDrag):false;
      }
      
      public function set horizontalDrag(param1:Boolean) : void
      {
         if(!this.dragController)
         {
            this.dragController = true;
         }
         this._dragController.horizontalDrag = param1;
      }
      
      public function get horizontalDrag() : Boolean
      {
         return this._dragController != null?Boolean(this._dragController.horizontalDrag):false;
      }
      
      public function get dragController() : Boolean
      {
         return this._dragController != null;
      }
      
      public function set dragController(param1:Boolean) : void
      {
         if(param1 && !this._dragController)
         {
            this._dragController = new DragControler();
            this._dragController.controler = this;
            this.getUi()._dragControllers[this._dragController] = true;
         }
         else if(!param1)
         {
            if(this._dragController)
            {
               delete this.getUi()._dragControllers[this._dragController];
               this._dragController.destroy();
               this._dragController = null;
            }
         }
      }
      
      public function get customUnicName() : String
      {
         if(!this._customName)
         {
            if(this.getUi())
            {
               if(name.indexOf(this.getUi().name + "::") == 0)
               {
                  this._customName = name;
               }
               else
               {
                  this._customName = this.getUi().name + "::" + name;
               }
            }
         }
         return this._customName;
      }
      
      public function set themeDataId(param1:String) : void
      {
         this._themeDataId = param1;
         if(!ThemeManager.getInstance().applyThemeData(this,param1))
         {
            this._themeDataId = null;
         }
      }
      
      public function get themeDataId() : String
      {
         return this._themeDataId;
      }
      
      public function set dropValidator(param1:Function) : void
      {
         this._dropValidatorFunction = param1;
      }
      
      public function get dropValidator() : Function
      {
         return this._dropValidatorFunction;
      }
      
      public function set removeDropSource(param1:Function) : void
      {
         this._removeDropSourceFunction = param1;
      }
      
      public function get removeDropSource() : Function
      {
         return this._removeDropSourceFunction;
      }
      
      public function set processDrop(param1:Function) : void
      {
         this._processDropFunction = param1;
      }
      
      public function get processDrop() : Function
      {
         return this._processDropFunction;
      }
      
      public function set sizeControler(param1:Boolean) : void
      {
         this._isSizeControler = param1;
         if(this.getUi() && this.getUi().windowOwner)
         {
            this.getUi().windowOwner.sizeControler = !!param1?this:null;
         }
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(param1:Boolean) : void
      {
         this._finalized = param1;
      }
      
      public function finalize() : void
      {
         if(this._isSizeControler && this.getUi() && this.getUi().windowOwner)
         {
            this.getUi().windowOwner.sizeControler = this;
         }
         this._finalized = true;
      }
      
      public function focus() : void
      {
         FocusHandler.getInstance().setFocus(this);
      }
      
      public function get hasFocus() : Boolean
      {
         return FocusHandler.getInstance().hasFocus(this);
      }
      
      public function get colorTransform() : ColorTransform
      {
         return transform.colorTransform;
      }
      
      public function set colorTransform(param1:ColorTransform) : void
      {
         transform.colorTransform = param1;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(param1:Number) : void
      {
         this.__width = this.__widthReal * (1 - param1);
         this.__height = this.__heightReal * (1 - param1);
         scaleX = param1;
         scaleY = param1;
         this._scale = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc3_:GraphicElement = null;
         if(param1 < 1)
         {
            this.__width = 1;
         }
         else
         {
            this.__width = param1;
         }
         if(this._bgColor != -1)
         {
            this.bgColor = this._bgColor;
         }
         this.__widthReal = this.__width;
         var _loc2_:UiRootContainer = this.getUi();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getElementById(name);
            if(_loc3_ && _loc2_.ready)
            {
               _loc3_.size.setX(param1,_loc3_.size.xUnit);
            }
            _loc2_.updateLinkedUi();
         }
         if(this._resizeController)
         {
            this._resizeController.width = this.width;
         }
      }
      
      public function set widthNoCache(param1:Number) : void
      {
         if(param1 < 1)
         {
            this.__width = 1;
         }
         else
         {
            this.__width = param1;
         }
         if(this._bgColor != -1)
         {
            this.bgColor = this._bgColor;
         }
         this.__widthReal = this.__width;
         var _loc2_:UiRootContainer = this.getUi();
         if(_loc2_)
         {
            _loc2_.updateLinkedUi();
         }
         if(this._resizeController)
         {
            this._resizeController.width = this.width;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc3_:GraphicElement = null;
         if(param1 < 1)
         {
            this.__height = 1;
         }
         else
         {
            this.__height = param1;
         }
         if(this._bgColor != -1)
         {
            this.bgColor = this._bgColor;
         }
         this.__heightReal = this.__height;
         var _loc2_:UiRootContainer = this.getUi();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getElementById(name);
            if(_loc3_ && _loc2_.ready)
            {
               _loc3_.size.setY(param1,_loc3_.size.yUnit);
            }
            _loc2_.updateLinkedUi();
         }
         if(this._resizeController)
         {
            this._resizeController.height = this.height;
         }
      }
      
      public function set heightNoCache(param1:Number) : void
      {
         if(param1 < 1)
         {
            this.__height = 1;
         }
         else
         {
            this.__height = param1;
         }
         if(this._bgColor != -1)
         {
            this.bgColor = this._bgColor;
         }
         this.__heightReal = this.__height;
         var _loc2_:UiRootContainer = this.getUi();
         if(_loc2_)
         {
            _loc2_.updateLinkedUi();
         }
         if(this._resizeController)
         {
            this._resizeController.height = this.height;
         }
      }
      
      override public function get width() : Number
      {
         if(isNaN(this.__width) || !this.__width)
         {
            return this.getBounds(this).width * scaleX;
         }
         return this.__width * scaleX;
      }
      
      override public function get height() : Number
      {
         if(isNaN(this.__height) || !this.__height)
         {
            return this.getBounds(this).height * scaleY;
         }
         return this.__height * scaleY;
      }
      
      public function get contentWidth() : Number
      {
         return super.width;
      }
      
      public function get contentHeight() : Number
      {
         return super.height;
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc3_:GraphicElement = null;
         super.x = param1;
         var _loc2_:UiRootContainer = this.getUi();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getElementById(name);
            if(_loc3_ && _loc2_.ready)
            {
               _loc3_.location.setOffsetX(param1);
            }
            _loc2_.updateLinkedUi();
         }
      }
      
      public function set xNoCache(param1:Number) : void
      {
         super.x = param1;
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc3_:GraphicElement = null;
         super.y = param1;
         var _loc2_:UiRootContainer = this.getUi();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getElementById(name);
            if(_loc3_ && _loc2_.ready)
            {
               _loc3_.location.setOffsetY(param1);
            }
            _loc2_.updateLinkedUi();
         }
      }
      
      public function set yNoCache(param1:Number) : void
      {
         super.y = param1;
      }
      
      public function get anchorY() : Number
      {
         var _loc2_:GraphicElement = null;
         var _loc1_:UiRootContainer = this.getUi();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getElementById(name);
            if(_loc2_ && _loc1_.ready)
            {
               return _loc2_.location.getOffsetY();
            }
         }
         return NaN;
      }
      
      public function get anchorX() : Number
      {
         var _loc2_:GraphicElement = null;
         var _loc1_:UiRootContainer = this.getUi();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getElementById(name);
            if(_loc2_ && _loc1_.ready)
            {
               return _loc2_.location.getOffsetX();
            }
         }
         return NaN;
      }
      
      public function set bgColor(param1:*) : void
      {
         this.setColorVar(param1);
         graphics.clear();
         if(!this.width || !this.height)
         {
            return;
         }
         if(this._borderColor != -1)
         {
            graphics.lineStyle(1,this._borderColor);
         }
         graphics.beginFill(this.bgColor,this.bgColor == -1?Number(0):Number(this._bgAlpha));
         if(!this._bgCornerRadius)
         {
            graphics.drawRect(0,0,this.width,this.height);
         }
         else
         {
            graphics.drawRoundRect(0,0,this.width,this.height,this._bgCornerRadius,this._bgCornerRadius);
         }
         graphics.endFill();
      }
      
      protected function setColorVar(param1:*) : void
      {
         var _loc2_:uint = 0;
         if(param1 is String)
         {
            _loc2_ = String(param1).substr(0,2) == "0x"?uint(16):uint(10);
            this._bgColor = parseInt(param1,_loc2_);
            this._bgColor = this._bgColor < 0?int(this._bgColor):this._bgColor & 16777215;
            if(param1.length > 8)
            {
               this._bgAlpha = ((parseInt(param1,_loc2_) & 4278190080) >> 24) / 255;
            }
         }
         else if(param1 is int || param1 is uint || param1 is Number)
         {
            this._bgColor = param1;
            this._bgColor = this._bgColor < 0?int(this._bgColor):this._bgColor & 16777215;
            if(param1 & 4278190080 && this._bgColor != -1)
            {
               this._bgAlpha = ((param1 & 4278190080) >> 24) / 255;
            }
         }
         else
         {
            this._bgColor = -1;
         }
      }
      
      public function get bgColor() : *
      {
         return this._bgColor;
      }
      
      public function set bgAlpha(param1:Number) : void
      {
         this._bgAlpha = param1;
         this.bgColor = this.bgColor;
      }
      
      public function get bgAlpha() : Number
      {
         return this._bgAlpha;
      }
      
      public function set bgMargin(param1:Number) : void
      {
         this._bgMargin = param1;
      }
      
      public function get bgMargin() : Number
      {
         return this._bgMargin;
      }
      
      public function set borderColor(param1:int) : void
      {
         this._borderColor = param1;
         this.bgColor = this.bgColor;
      }
      
      public function get borderColor() : int
      {
         return this._borderColor;
      }
      
      public function set bgCornerRadius(param1:uint) : void
      {
         this._bgCornerRadius = param1;
         this.bgColor = this.bgColor;
      }
      
      public function get bgCornerRadius() : uint
      {
         return this._bgCornerRadius;
      }
      
      public function set luminosity(param1:Number) : void
      {
         this._luminosity = param1;
         filters = [new ColorMatrixFilter([param1,0,0,0,0,0,param1,0,0,0,0,0,param1,0,0,0,0,0,1,0])];
      }
      
      public function get luminosity() : Number
      {
         return this._luminosity;
      }
      
      public function set linkedTo(param1:String) : void
      {
         this._sLinkedTo = param1;
      }
      
      public function get linkedTo() : String
      {
         return this._sLinkedTo;
      }
      
      public function set shadowColor(param1:int) : void
      {
         if(param1 >= 0)
         {
            this._shadow = new DropShadowFilter(3,90,param1,1,10,10,0.61,BitmapFilterQuality.HIGH);
            filters = [this._shadow];
         }
         else if(param1 == -1 && this._shadow)
         {
            this._shadow = null;
            filters = [];
         }
      }
      
      public function get shadowColor() : int
      {
         return !!this._shadow?int(this._shadow.color):-1;
      }
      
      public function get topParent() : DisplayObject
      {
         return this.getTopParent(this);
      }
      
      public function setAdvancedGlow(param1:uint, param2:Number = 1, param3:Number = 6.0, param4:Number = 6.0, param5:Number = 2) : void
      {
      }
      
      public function clearFilters() : void
      {
         filters = [];
      }
      
      public function getStrata(param1:int) : Sprite
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this._aStrata[param1] != null)
         {
            return this._aStrata[param1];
         }
         this._aStrata[param1] = new Sprite();
         this._aStrata[param1].name = "strata_" + param1;
         this._aStrata[param1].mouseEnabled = false;
         this._aStrata[param1].doubleClickEnabled = true;
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this._aStrata.length)
         {
            if(this._aStrata[_loc3_] != null)
            {
               addChildAt(this._aStrata[_loc3_],_loc2_++);
            }
            _loc3_++;
         }
         return this._aStrata[param1];
      }
      
      public function set dynamicPosition(param1:Boolean) : void
      {
         this._bDynamicPosition = param1;
      }
      
      public function get dynamicPosition() : Boolean
      {
         return this._bDynamicPosition;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         if(param1)
         {
            transform.colorTransform = COLOR_TRANSFORM_DISABLED;
            this.handCursor = false;
            this.mouseEnabled = false;
            mouseChildren = false;
         }
         else
         {
            if(!this.greyedOut)
            {
               transform.colorTransform = COLOR_TRANSFORM_DEFAULT;
            }
            this.handCursor = true;
            this.mouseEnabled = true;
            mouseChildren = true;
         }
         this._bDisabled = param1;
      }
      
      public function get disabled() : Boolean
      {
         return this._bDisabled;
      }
      
      public function set softDisabled(param1:Boolean) : void
      {
         if(this._bSoftDisabled != param1)
         {
            if(param1)
            {
               transform.colorTransform = COLOR_TRANSFORM_DISABLED;
            }
            else
            {
               transform.colorTransform = COLOR_TRANSFORM_DEFAULT;
            }
         }
         this._bSoftDisabled = param1;
      }
      
      public function get softDisabled() : Boolean
      {
         return this._bSoftDisabled;
      }
      
      public function set greyedOut(param1:Boolean) : void
      {
         if(this._bGreyedOut != param1)
         {
            if(param1)
            {
               transform.colorTransform = COLOR_TRANSFORM_DISABLED;
            }
            else if(!this.disabled)
            {
               transform.colorTransform = COLOR_TRANSFORM_DEFAULT;
            }
         }
         this._bGreyedOut = param1;
      }
      
      public function get greyedOut() : Boolean
      {
         return this._bGreyedOut;
      }
      
      public function get depths() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:GraphicContainer = this;
         while(_loc2_.getParent() != null)
         {
            _loc1_.unshift(_loc2_.getParent());
            _loc2_ = _loc2_.getParent();
         }
         return _loc1_;
      }
      
      public function set handCursor(param1:Boolean) : void
      {
         this.buttonMode = param1;
         this.mouseChildren = !param1;
      }
      
      public function get handCursor() : Boolean
      {
         return this.buttonMode && !this.mouseChildren;
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         super.mouseEnabled = param1;
         for each(_loc2_ in this._aStrata)
         {
            _loc2_.mouseEnabled = param1;
         }
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:UiRootContainer = null;
         var _loc3_:MouseClickMessage = null;
         if(this._resizeController)
         {
            this._resizeController.process(param1);
         }
         if(this._dragController)
         {
            this._dragController.process(param1);
         }
         if(!this.canProcessMessage(param1))
         {
            return true;
         }
         if(param1 is MouseClickMessage && this._sLinkedTo)
         {
            _loc2_ = this.getUi();
            if(_loc2_ != null)
            {
               _loc3_ = GenericPool.get(MouseClickMessage,_loc2_.getElement(this._sLinkedTo),MouseClickMessage(param1).mouseEvent);
               _loc2_.getElement(this._sLinkedTo).process(_loc3_);
            }
         }
         return false;
      }
      
      override public function stopDrag() : void
      {
         super.stopDrag();
         this.x = x;
         this.y = y;
      }
      
      public function getStageRect() : Rectangle
      {
         return this.getRect(stage);
      }
      
      public function remove() : void
      {
         if(this._dragController)
         {
            this._dragController.destroy();
         }
         if(this._resizeController)
         {
            this._resizeController.destroy();
         }
         var _loc1_:UiRootContainer = this.getUi();
         if(_loc1_)
         {
            _loc1_.deleteId(name);
         }
         this.destroy(this);
         SecureCenter.destroy(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         this.__removed = true;
      }
      
      public function addContent(param1:GraphicContainer, param2:int = -1) : GraphicContainer
      {
         if(param2 == -1)
         {
            this.getStrata(0).addChild(param1);
         }
         else
         {
            this.getStrata(0).addChildAt(param1,param2);
         }
         return param1;
      }
      
      public function removeFromParent() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function getParent() : GraphicContainer
      {
         if(this.parent == null || this is UiRootContainer)
         {
            return null;
         }
         var _loc1_:DisplayObjectContainer = DisplayObjectContainer(this.parent);
         while(!(_loc1_ is GraphicContainer))
         {
            _loc1_ = DisplayObjectContainer(_loc1_.parent);
         }
         return GraphicContainer(_loc1_);
      }
      
      public function getUi() : UiRootContainer
      {
         if(this is UiRootContainer)
         {
            return this as UiRootContainer;
         }
         if(this._uiRootContainer)
         {
            return this._uiRootContainer;
         }
         if(this.parent == null)
         {
            return null;
         }
         var _loc1_:Sprite = Sprite(this.parent);
         while(!(_loc1_ is UiRootContainer) && _loc1_ != null)
         {
            if(_loc1_ is GraphicContainer && GraphicContainer(_loc1_)._uiRootContainer)
            {
               _loc1_ = GraphicContainer(_loc1_)._uiRootContainer;
            }
            else if(_loc1_.parent is Sprite)
            {
               _loc1_ = Sprite(_loc1_.parent);
            }
            else
            {
               _loc1_ = null;
            }
         }
         if(_loc1_ == null)
         {
            return null;
         }
         this._uiRootContainer = UiRootContainer(_loc1_);
         return UiRootContainer(_loc1_);
      }
      
      public function setUi(param1:UiRootContainer, param2:Object) : void
      {
         if(param2 != SecureCenter.ACCESS_KEY)
         {
            throw new SecurityError();
         }
         this._uiRootContainer = param1;
      }
      
      public function getTopParent(param1:DisplayObject) : DisplayObject
      {
         if(param1.parent != null)
         {
            return this.getTopParent(param1.parent);
         }
         return param1;
      }
      
      public function slide(param1:int, param2:int, param3:int, param4:Boolean = false, param5:int = 0, param6:int = 0) : void
      {
         var _loc7_:Function = Strong.easeOut;
         if(param4)
         {
            _loc7_ = Strong.easeInOut;
         }
         TweenLite.to(this,param3 / 1000,{
            "bezier":[{
               "x":param5,
               "y":param6
            }],
            "x":param1,
            "y":param2,
            "ease":_loc7_,
            "onComplete":this.moveComplete
         });
      }
      
      public function alphaFade(param1:Number, param2:int) : void
      {
         var _loc3_:Function = Circ.easeOut;
         TweenLite.to(this,param2 / 1000,{
            "alpha":param1,
            "ease":_loc3_
         });
      }
      
      public function colorSlide(param1:Number, param2:int, param3:Boolean) : void
      {
         var _loc4_:Function = Circ.easeOut;
         var _loc5_:int = 0;
         var _loc6_:int = 0.5;
         if(param3)
         {
            _loc5_ = 1;
            _loc6_ = 0.5;
         }
         TweenMax.to(this,param2 / 1000,{
            "repeat":_loc5_,
            "repeatDelay":_loc6_,
            "yoyo":param3,
            "ease":Expo.easeIn,
            "colorTransform":{"exposure":param1}
         });
      }
      
      public function getSavedPosition() : Point
      {
         var _loc1_:* = StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_UI_POSITIONS,this.getUi().name + "##pos##" + name + "##" + Berilia.getInstance().uiSavedModificationPresetName);
         if(_loc1_ && !(_loc1_ is Point))
         {
            _loc1_ = new Point(_loc1_.x,_loc1_.y);
         }
         return _loc1_;
      }
      
      public function setSavedPosition(param1:Number, param2:Number) : void
      {
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_POSITIONS,this.getUi().name + "##pos##" + name + "##" + Berilia.getInstance().uiSavedModificationPresetName,isNaN(param1) && isNaN(param2)?null:new Point(param1,param2));
      }
      
      public function getSavedDimension() : Point
      {
         var _loc1_:* = StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_UI_POSITIONS,this.getUi().name + "##size##" + name + "##" + Berilia.getInstance().uiSavedModificationPresetName);
         if(_loc1_ && !(_loc1_ is Point))
         {
            _loc1_ = new Point(_loc1_.x,_loc1_.y);
         }
         return _loc1_;
      }
      
      public function setSavedDimension(param1:Number, param2:Number) : void
      {
         if(this.getUi())
         {
            this.getUi().addDynamicSizeElement(this.getUi().getElementById(name));
         }
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_POSITIONS,this.getUi().name + "##size##" + name + "##" + Berilia.getInstance().uiSavedModificationPresetName,isNaN(param1) && isNaN(param2)?null:new Point(param1,param2));
      }
      
      public function resetSavedInformations(param1:Boolean = true) : void
      {
         var _loc4_:GraphicElement = null;
         var _loc2_:* = this.getSavedDimension() != null;
         var _loc3_:* = this.getSavedPosition() != null;
         if(param1 && _loc2_)
         {
            this.setSavedDimension(NaN,NaN);
         }
         if(param1 && _loc2_)
         {
            this.setSavedPosition(NaN,NaN);
         }
         if(_loc2_)
         {
            _loc4_ = this.getUi().getElementById(name);
            if(_loc4_ && _loc4_.size)
            {
               if(_loc4_.size.xUnit == SizeElement.SIZE_PIXEL)
               {
                  this.widthNoCache = _loc4_.size.x;
               }
               if(_loc4_.size.yUnit == SizeElement.SIZE_PIXEL)
               {
                  this.heightNoCache = _loc4_.size.y;
               }
            }
         }
         if(_loc3_)
         {
            this.xNoCache = this.anchorX;
            this.yNoCache = this.anchorY;
         }
      }
      
      private function moveComplete() : void
      {
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.SlideComplete,this);
      }
      
      private function defaultDropValidatorFunction(param1:*, param2:*, param3:*) : Boolean
      {
         var _loc4_:DisplayObject = this;
         do
         {
            _loc4_ = _loc4_.parent;
         }
         while(!(_loc4_ is IDragAndDropHandler) && _loc4_.parent);
         
         if(_loc4_ is IDragAndDropHandler)
         {
            return (_loc4_ as IDragAndDropHandler).dropValidator(param1,param2,param3);
         }
         return false;
      }
      
      private function defaultProcessDropFunction(param1:*, param2:*, param3:*) : void
      {
         var _loc4_:DisplayObject = this;
         do
         {
            _loc4_ = _loc4_.parent;
         }
         while(!(_loc4_ is IDragAndDropHandler) && _loc4_.parent);
         
         if(_loc4_ is IDragAndDropHandler)
         {
            (_loc4_ as IDragAndDropHandler).processDrop(param1,param2,param3);
         }
      }
      
      private function defaultRemoveDropSourceFunction(param1:*) : void
      {
         var _loc2_:DisplayObject = this;
         do
         {
            _loc2_ = _loc2_.parent;
         }
         while(!(_loc2_ is IDragAndDropHandler) && _loc2_.parent);
         
         if(_loc2_ is IDragAndDropHandler)
         {
            (_loc2_ as IDragAndDropHandler).removeDropSource(param1);
         }
      }
      
      override public function localToGlobal(param1:Point) : Point
      {
         var _loc2_:DisplayObject = this;
         var _loc3_:Point = param1;
         while(_loc2_ && _loc2_.parent)
         {
            _loc3_.x = _loc3_.x + _loc2_.parent.x;
            _loc3_.y = _loc3_.y + _loc2_.parent.y;
            _loc2_ = _loc2_.parent;
         }
         return _loc3_;
      }
      
      protected function destroy(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObject = null;
         if(!param1 || param1 is MovieClip && MovieClip(param1).totalFrames > 1)
         {
            return;
         }
         if(this._dragController && this.getUi())
         {
            delete this.getUi()._dragControllers[this._dragController];
         }
         var _loc3_:uint = 0;
         var _loc4_:int = param1.numChildren;
         while(param1.numChildren)
         {
            _loc2_ = param1.removeChildAt(0);
            if(_loc2_ is TiphonSprite)
            {
               (_loc2_ as TiphonSprite).destroy();
            }
            else
            {
               if(_loc2_ is GraphicContainer)
               {
                  (_loc2_ as GraphicContainer).remove();
               }
               if(_loc2_ is DisplayObjectContainer)
               {
                  this.destroy(_loc2_ as DisplayObjectContainer);
               }
            }
         }
      }
      
      public function free() : void
      {
         this.__width = 0;
         this.__widthReal = 0;
         this.__height = 0;
         this.__heightReal = 0;
         this.__removed = false;
         this._bgColor = -1;
         this._bgAlpha = 1;
         this.minSize = null;
         this.maxSize = null;
         this._scale = 1;
         this._sLinkedTo = null;
         this._bDisabled = false;
         this._shadow = null;
         this._luminosity = 1;
         this._bgCornerRadius = 0;
         this._shResizeBorder = null;
         this._bUseSimpleResize = false;
         this._uiRootContainer = null;
         if(this._resizeController)
         {
            this._resizeController.destroy();
         }
         this._resizeController = null;
      }
      
      override public function contains(param1:DisplayObject) : Boolean
      {
         return super.contains(param1);
      }
      
      protected function canProcessMessage(param1:Message) : Boolean
      {
         if(this._bSoftDisabled)
         {
            if(!(param1 is ItemRollOutMessage || param1 is ItemRollOverMessage || param1 is MouseOverMessage || param1 is MouseOutMessage))
            {
               return false;
            }
         }
         return true;
      }
   }
}
