package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.enums.LocationTypeEnum;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.RadioGroup;
   import com.ankamagames.berilia.types.data.UISnapshot;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.NativeWindowBoundsEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class UiRootContainer extends GraphicContainer implements UIComponent
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiRootContainer));
       
      
      private var _magneticElements:Dictionary;
      
      private var _aNamedElements:Array;
      
      private var _bUsedCustomSize:Boolean = false;
      
      private var _stage:Stage;
      
      private var _root:Sprite;
      
      private var _aGraphicLocationStack:Array;
      
      private var _aSizeStack:Array;
      
      private var _aGraphicElementIndex:Array;
      
      private var _aPositionnedElement:Array;
      
      private var _linkedUi:Array;
      
      private var _aPostFinalizeElement:Array;
      
      private var _aFinalizeElements:Array;
      
      private var _uiDefinitionUpdateTimer:Timer;
      
      private var _rendering:Boolean = false;
      
      private var _ready:Boolean;
      
      private var _waitingFctCall:Array;
      
      private var _properties;
      
      private var _wasVisible:Boolean;
      
      var _lock:Boolean = true;
      
      private var _renderAsk:Boolean = false;
      
      private var _isNotFinalized:Boolean = true;
      
      private var _tempVisible:Boolean = true;
      
      private var _uiData:UiData;
      
      private var _scriptTime:Number;
      
      var _dragControllers:Dictionary;
      
      public var windowOwner:ExternalUi;
      
      public var uiClass;
      
      public var uiModule:UiModule;
      
      public var strata:int;
      
      public var depth:int;
      
      public var scalable:Boolean = true;
      
      public var modal:Boolean = false;
      
      private var _modalContainer:GraphicContainer;
      
      private var _fullscreen:Boolean = false;
      
      public var giveFocus:Boolean = true;
      
      public var modalIndex:uint = 0;
      
      public var radioGroup:Array;
      
      public var cached:Boolean = false;
      
      public var hideAfterLoading:Boolean = false;
      
      public var transmitFocus:Boolean = true;
      
      public var constants:Array;
      
      public var tempHolder:DisplayObjectContainer;
      
      public var restoreSnapshotAfterLoading:Boolean;
      
      public function UiRootContainer(param1:Stage, param2:UiData, param3:Sprite = null)
      {
         this._dragControllers = new Dictionary();
         this.radioGroup = new Array();
         super();
         this._stage = param1;
         this._root = param3;
         this._magneticElements = new Dictionary(true);
         this._aNamedElements = new Array();
         this._aSizeStack = new Array();
         this._linkedUi = new Array();
         this._uiData = param2;
         this._aGraphicLocationStack = new Array();
         this._aGraphicElementIndex = new Array();
         this._aPostFinalizeElement = new Array();
         this._aFinalizeElements = new Array();
         this._waitingFctCall = new Array();
         this.radioGroup = new Array();
         super.visible = false;
         MEMORY_LOG[this] = 1;
      }
      
      public function get fullscreen() : Boolean
      {
         return this._fullscreen;
      }
      
      public function set fullscreen(param1:Boolean) : void
      {
         if(this._fullscreen == param1)
         {
            return;
         }
         if(AirScanner.hasAir())
         {
            this._fullscreen = param1;
            this.listenResize(this._fullscreen);
            this.onResize();
         }
         else
         {
            _log.info("fullscreen mode not supported without Air");
         }
      }
      
      public function get properties() : *
      {
         return this._properties;
      }
      
      public function set properties(param1:*) : void
      {
         if(!this._properties)
         {
            this._properties = param1;
         }
      }
      
      override public function get customUnicName() : String
      {
         return name;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(this._isNotFinalized)
         {
            this._tempVisible = param1;
         }
         else
         {
            super.visible = param1;
         }
      }
      
      override public function get width() : Number
      {
         if(this._bUsedCustomSize)
         {
            return __width;
         }
         return super.width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._bUsedCustomSize = true;
         __width = param1;
      }
      
      override public function get height() : Number
      {
         if(this._bUsedCustomSize)
         {
            return __height;
         }
         return super.height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._bUsedCustomSize = true;
         __height = param1;
      }
      
      public function set useCustomSize(param1:Boolean) : void
      {
         this._bUsedCustomSize = param1;
      }
      
      public function get useCustomSize() : Boolean
      {
         return this._bUsedCustomSize;
      }
      
      public function set disableRender(param1:Boolean) : void
      {
         this._rendering = param1;
      }
      
      public function get disableRender() : Boolean
      {
         return this._rendering;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function set modalContainer(param1:GraphicContainer) : void
      {
         this._modalContainer = param1;
      }
      
      public function set showModalContainer(param1:Boolean) : void
      {
         if(this.modal && this._modalContainer != null)
         {
            this._modalContainer.visible = param1;
         }
      }
      
      public function get uiData() : UiData
      {
         return this._uiData;
      }
      
      public function get scriptTime() : Number
      {
         return this._scriptTime;
      }
      
      public function get childIndex() : int
      {
         return parent.getChildIndex(this);
      }
      
      public function set childIndex(param1:int) : void
      {
         parent.setChildIndex(this,param1);
      }
      
      public function get magneticElements() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._magneticElements)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function addElement(param1:String, param2:Object) : void
      {
         this._aNamedElements[param1] = param2;
      }
      
      public function removeElement(param1:String) : void
      {
         delete this._aNamedElements[param1];
      }
      
      public function getElement(param1:String) : GraphicContainer
      {
         if(!this._aNamedElements[param1] && param1 == name)
         {
            return this;
         }
         return this._aNamedElements[param1];
      }
      
      public function getElements() : Array
      {
         return this._aNamedElements;
      }
      
      public function getConstant(param1:String) : *
      {
         return this.constants[param1];
      }
      
      public function iAmFinalized(param1:FinalizableUIComponent) : void
      {
         var _loc2_:FinalizableUIComponent = null;
         var _loc4_:int = 0;
         var _loc5_:Callback = null;
         if(!this._lock || this._rendering)
         {
            return;
         }
         for each(_loc2_ in this._aFinalizeElements)
         {
            if(!_loc2_.finalized)
            {
               return;
            }
         }
         this._lock = false;
         this.render();
         this._ready = true;
         if(this.tempHolder && this.tempHolder.parent)
         {
            if(!this.hideAfterLoading)
            {
               this.tempHolder.parent.addChildAt(this,this.tempHolder.parent.getChildIndex(this.tempHolder));
            }
            this.tempHolder.parent.removeChild(this.tempHolder);
         }
         this.tempHolder = null;
         this._isNotFinalized = false;
         var _loc3_:Boolean = false;
         if(this.uiClass && this.uiClass.hasOwnProperty("main"))
         {
            this._rendering = true;
            FpsManager.getInstance().startTracking("hook",7108545);
            _loc4_ = getTimer();
            ErrorManager.tryFunction(this.uiClass["main"],[this._properties],"Une erreur est survenue lors de l\'exécution de la fonction main de l\'interface " + name + " (" + getQualifiedClassName(this.uiClass) + ")");
            this._scriptTime = getTimer() - _loc4_;
            FpsManager.getInstance().stopTracking("hook");
            this._rendering = false;
            if(ErrorManager.lastTryFunctionHasException)
            {
               _loc3_ = true;
            }
            else if(this._renderAsk)
            {
               this.render();
            }
            this._ready = true;
            for each(_loc5_ in this._waitingFctCall)
            {
               _loc5_.exec();
            }
            this._waitingFctCall.length = 0;
         }
         dispatchEvent(new UiRenderEvent(UiRenderEvent.UIRenderComplete,false,false,this));
         this.visible = this._tempVisible;
         if(_loc3_)
         {
            _log.error("UI " + name + " has encountered an exception and must be unloaded.");
            _log.warn("" + ErrorManager.lastExceptionStacktrace);
            Berilia.getInstance().unloadUi(name);
         }
         else if(this.restoreSnapshotAfterLoading)
         {
            this.restoreSnapshot();
         }
      }
      
      public function render() : void
      {
         var _loc3_:int = 0;
         var _loc4_:GraphicElement = null;
         var _loc5_:* = undefined;
         var _loc6_:FinalizableUIComponent = null;
         var _loc7_:Rectangle = null;
         this._renderAsk = true;
         var _loc1_:Boolean = this._ready;
         this._ready = false;
         if(this._rendering || this._lock)
         {
            return;
         }
         if(this.fullscreen && AirScanner.hasAir())
         {
            _loc7_ = StageShareManager.stageVisibleBounds;
            x = _loc7_.x;
            y = _loc7_.y;
         }
         var _loc2_:uint = getTimer();
         this._rendering = true;
         this._aPositionnedElement = new Array();
         this.zSort(this._aSizeStack);
         this.processSize();
         _loc3_ = 0;
         while(_loc3_ < this._aGraphicLocationStack.length)
         {
            if(this._aGraphicLocationStack[_loc3_] != null)
            {
               this._aGraphicLocationStack[_loc3_].render = false;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this._aGraphicLocationStack.length)
         {
            if(this._aGraphicLocationStack[_loc3_] != null)
            {
               if(!this._aGraphicLocationStack[_loc3_].render)
               {
                  _loc4_ = this._aGraphicLocationStack[_loc3_];
                  if(!_loc4_.sprite.dynamicPosition)
                  {
                     this.processLocation(this._aGraphicLocationStack[_loc3_]);
                  }
               }
            }
            _loc3_++;
         }
         for(_loc5_ in this._dragControllers)
         {
            DragControler(_loc5_).restrictPosition();
         }
         this.updateLinkedUi();
         for each(_loc6_ in this._aPostFinalizeElement)
         {
            _loc6_.finalize();
         }
         this._aPositionnedElement = new Array();
         this._rendering = false;
         this._ready = _loc1_;
         if(this.uiClass && Object(this.uiClass).hasOwnProperty("renderUpdate"))
         {
            this.uiClass.renderUpdate();
         }
      }
      
      public function registerMagneticElement(param1:GraphicContainer) : void
      {
         this._magneticElements[param1] = true;
      }
      
      public function removeMagneticElement(param1:GraphicContainer) : void
      {
         delete this._magneticElements[param1];
      }
      
      public function registerId(param1:String, param2:GraphicElement) : void
      {
         if(this._aGraphicElementIndex[param1] != null && this._aGraphicElementIndex[param1] != undefined)
         {
            throw new BeriliaError(param1 + " name is already used");
         }
         this._aGraphicElementIndex[param1] = param2;
         this.addElement(param1,param2.sprite);
      }
      
      public function deleteId(param1:String) : void
      {
         if(this._aGraphicElementIndex[param1] == null)
         {
            return;
         }
         delete this._aGraphicElementIndex[param1];
         this.removeElement(param1);
      }
      
      public function getElementById(param1:String) : GraphicElement
      {
         return this._aGraphicElementIndex[param1];
      }
      
      public function removeFromRenderList(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:GraphicElement = null;
         _loc2_ = 0;
         while(_loc2_ < this._aGraphicLocationStack.length)
         {
            _loc3_ = this._aGraphicLocationStack[_loc2_];
            if(_loc3_ != null && _loc3_.sprite.name == param1)
            {
               delete this._aGraphicLocationStack[_loc2_];
               break;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._aSizeStack.length)
         {
            if(this._aSizeStack[_loc2_] != null && this._aSizeStack[_loc2_].name == param1)
            {
               delete this._aSizeStack[_loc2_];
               break;
            }
            _loc2_++;
         }
      }
      
      public function addDynamicSizeElement(param1:GraphicElement) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this._aSizeStack.length)
         {
            if(this._aSizeStack[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this._aSizeStack.push(param1);
      }
      
      public function addDynamicElement(param1:GraphicElement) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._aGraphicLocationStack.length)
         {
            if(this._aGraphicLocationStack[_loc2_] != null && this._aGraphicLocationStack[_loc2_].sprite.name == param1.sprite.name)
            {
               return;
            }
            _loc2_++;
         }
         this._aGraphicLocationStack.push(param1);
      }
      
      public function addPostFinalizeComponent(param1:FinalizableUIComponent) : void
      {
         this._aPostFinalizeElement.push(param1);
      }
      
      public function addFinalizeElement(param1:FinalizableUIComponent) : void
      {
         if(!this._aFinalizeElements)
         {
            _log.error("_aFinalizeElements NULL, on ne peut pas push " + (param1 as GraphicContainer).name + "  pour " + name);
            return;
         }
         this._aFinalizeElements.push(param1);
      }
      
      public function addRadioGroup(param1:String) : RadioGroup
      {
         if(!this.radioGroup)
         {
            this.radioGroup = new Array();
         }
         if(!this.radioGroup[param1])
         {
            this.radioGroup[param1] = new RadioGroup(param1);
         }
         return this.radioGroup[param1];
      }
      
      public function getRadioGroup(param1:String) : RadioGroup
      {
         if(!this.radioGroup)
         {
            return null;
         }
         return this.radioGroup[param1];
      }
      
      public function addLinkedUi(param1:String) : void
      {
         if(param1 != name)
         {
            this._linkedUi[param1] = param1;
         }
         else
         {
            _log.error("Cannot add link to yourself in " + name);
         }
      }
      
      public function removeLinkedUi(param1:String) : void
      {
         delete this._linkedUi[param1];
      }
      
      public function updateLinkedUi() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this._linkedUi)
         {
            if(Berilia.getInstance().getUi(this._linkedUi[_loc1_]))
            {
               Berilia.getInstance().getUi(this._linkedUi[_loc1_]).render();
            }
         }
      }
      
      public function call(param1:Function, param2:Array, param3:Object) : void
      {
         if(param3 !== SecureCenter.ACCESS_KEY)
         {
            throw new IllegalOperationError();
         }
         if(this._ready)
         {
            CallWithParameters.call(param1,param2);
         }
         else
         {
            this._waitingFctCall.push(CallWithParameters.callConstructor(Callback,[param1].concat(param2)));
         }
      }
      
      public function destroyUi(param1:Object) : void
      {
         var _loc2_:RadioGroup = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:GraphicContainer = null;
         if(param1 !== SecureCenter.ACCESS_KEY)
         {
            throw new IllegalOperationError();
         }
         for each(_loc2_ in this.radioGroup)
         {
            RadioGroup(_loc2_).destroy();
         }
         this.radioGroup = null;
         this._stage = null;
         this._root = null;
         this._magneticElements = new Dictionary(true);
         this._aNamedElements = new Array();
         this._aSizeStack = new Array();
         this._linkedUi = new Array();
         this._aGraphicLocationStack = new Array();
         this._aGraphicElementIndex = new Array();
         this._aPostFinalizeElement = new Array();
         if(this._aFinalizeElements)
         {
            _loc3_ = this._aFinalizeElements.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = this._aFinalizeElements[_loc4_];
               _loc5_.remove();
               _loc4_++;
            }
         }
         if(this.windowOwner)
         {
            this.windowOwner.destroy();
         }
         this._aFinalizeElements = null;
      }
      
      public function makeSnapshot() : void
      {
         var _loc1_:UISnapshot = null;
         var _loc3_:String = null;
         var _loc2_:RadioGroup = this.getRadioGroup("tabHGroup");
         if(_loc2_ && _loc2_.selectedItem)
         {
            _loc1_ = new UISnapshot();
            _loc3_ = (_loc2_.selectedItem as GraphicContainer).customUnicName;
            if(_loc3_.indexOf("::") != -1)
            {
               _loc3_ = _loc3_.split("::")[1];
            }
            _loc1_.lastHorizontalTabName = _loc3_;
         }
         if(_loc1_)
         {
            StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_SNAPSHOT,getQualifiedClassName(this.uiClass) + "_snapshot",_loc1_);
         }
      }
      
      public function setOnTop() : void
      {
         parent.addChild(this);
      }
      
      private function restoreSnapshot() : void
      {
         var _loc2_:ButtonContainer = null;
         var _loc1_:UISnapshot = StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_UI_SNAPSHOT,getQualifiedClassName(this.uiClass) + "_snapshot");
         if(_loc1_)
         {
            if(_loc1_.lastHorizontalTabName)
            {
               _loc2_ = this.getElement(_loc1_.lastHorizontalTabName) as ButtonContainer;
               if(_loc2_ && _loc2_.visible && !_loc2_.selected && !_loc2_.softDisabled && !_loc2_.disabled)
               {
                  _loc2_.selected = true;
                  this.uiClass.onRelease(this.uiClass[_loc1_.lastHorizontalTabName]);
               }
            }
         }
      }
      
      private function isRegisteredId(param1:String) : Boolean
      {
         return this._aGraphicElementIndex[param1] != null;
      }
      
      private function processSize() : void
      {
         var _loc1_:GraphicElement = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._aSizeStack.length)
         {
            _loc1_ = this._aSizeStack[_loc2_];
            if(_loc1_ != null)
            {
               _loc3_ = NaN;
               _loc4_ = NaN;
               _loc5_ = _loc1_.sprite.getSavedDimension();
               if(_loc5_)
               {
                  this.listenResize(true);
                  _loc3_ = _loc5_.x;
                  _loc4_ = _loc5_.y;
               }
               else
               {
                  if(!isNaN(_loc1_.size.x) && _loc1_.size.xUnit == GraphicSize.SIZE_PRC)
                  {
                     if(_loc1_.sprite && _loc1_.sprite.parent && _loc1_.sprite.parent.parent is UiRootContainer)
                     {
                        if(this.fullscreen)
                        {
                           _loc3_ = int(_loc1_.size.x * StageShareManager.stageVisibleBounds.width);
                        }
                        else
                        {
                           _loc3_ = int(_loc1_.size.x * StageShareManager.startWidth);
                        }
                     }
                     else if(GraphicContainer(_loc1_.sprite).getParent())
                     {
                        _loc3_ = int(_loc1_.size.x * GraphicContainer(_loc1_.sprite).getParent().width);
                     }
                  }
                  if(!isNaN(_loc1_.size.y) && _loc1_.size.yUnit == GraphicSize.SIZE_PRC)
                  {
                     if(_loc1_.sprite && _loc1_.sprite.parent && _loc1_.sprite.parent.parent is UiRootContainer)
                     {
                        if(this.fullscreen)
                        {
                           _loc4_ = int(_loc1_.size.y * StageShareManager.stageVisibleBounds.height);
                        }
                        else
                        {
                           _loc4_ = int(_loc1_.size.y * StageShareManager.startHeight);
                        }
                     }
                     else if(GraphicContainer(_loc1_.sprite).getParent())
                     {
                        _loc4_ = int(_loc1_.size.y * GraphicContainer(_loc1_.sprite).getParent().height);
                     }
                  }
               }
               if(isNaN(_loc3_) || isNaN(_loc4_))
               {
                  if(!isNaN(_loc3_))
                  {
                     _loc1_.sprite.width = _loc3_;
                  }
                  if(!isNaN(_loc4_))
                  {
                     _loc1_.sprite.height = _loc4_;
                  }
               }
               else
               {
                  _loc1_.sprite.finalized = false;
                  _loc1_.sprite.width = _loc3_;
                  _loc1_.sprite.finalized = true;
                  _loc1_.sprite.height = _loc4_;
               }
            }
            _loc2_++;
         }
      }
      
      public function processLocation(param1:GraphicElement) : void
      {
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc2_:Point = param1.sprite.getSavedPosition();
         if(_loc2_)
         {
            if(!param1.sprite.dragController || param1.sprite._dragController.savePosition)
            {
               this.listenResize(true);
               param1.sprite.xNoCache = _loc2_.x;
               param1.sprite.yNoCache = _loc2_.y;
               return;
            }
         }
         var _loc3_:Number = param1.sprite.x;
         var _loc4_:Number = param1.sprite.y;
         param1.sprite.xNoCache = 0;
         param1.sprite.yNoCache = 0;
         if(param1.locations.length > 1)
         {
            param1.sprite.width = 0;
            param1.sprite.height = 0;
            _loc6_ = this.getLocation(new Point(param1.sprite.x,param1.sprite.y),param1.locations[0],param1.sprite);
            _loc7_ = this.getLocation(new Point(param1.sprite.x,param1.sprite.y),param1.locations[1],param1.sprite);
            if(_loc6_ && _loc7_)
            {
               param1.sprite.width = Math.floor(Math.abs(_loc7_.x - _loc6_.x));
               param1.sprite.height = Math.floor(Math.abs(_loc7_.y - _loc6_.y));
            }
            else
            {
               _log.error("Erreur de positionement dans " + name + " avec " + param1.name);
            }
         }
         var _loc5_:Point = this.getLocation(new Point(param1.sprite.x,param1.sprite.y),param1.location,param1.sprite);
         if(param1.sprite && _loc5_)
         {
            param1.sprite.x = _loc5_.x;
            param1.sprite.y = _loc5_.y;
         }
         else
         {
            param1.sprite.x = _loc3_;
            param1.sprite.y = _loc4_;
            _log.error("Erreur dans " + name + " avec " + param1.name);
         }
      }
      
      private function getLocation(param1:Point, param2:GraphicLocation, param3:DisplayObject) : Point
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:Array = null;
         var _loc10_:UiRootContainer = null;
         var _loc4_:Point = new Point();
         var _loc5_:Point = new Point();
         var _loc6_:Point = new Point();
         if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_RELATIVE || param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
         {
            _loc5_ = param3.localToGlobal(new Point(param3.x,param3.y));
            switch(param2.getRelativeTo())
            {
               case GraphicLocation.REF_PARENT:
                  _loc4_.x = Math.floor(GraphicContainer(param3).getParent().width * param2.getOffsetX());
                  _loc4_.y = Math.floor(GraphicContainer(param3).getParent().height * param2.getOffsetY());
            }
            if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
            {
               param1.x = param1.x + _loc4_.x;
            }
            if(param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
            {
               param1.y = param1.y + _loc4_.y;
            }
         }
         if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE || param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
         {
            _loc4_.x = 0;
            _loc4_.y = 0;
            _loc5_ = param3.localToGlobal(new Point(param3.x,param3.y));
            switch(param2.getRelativeTo())
            {
               case GraphicLocation.REF_PARENT:
                  _loc4_.x = param2.getOffsetX();
                  _loc4_.y = param2.getOffsetY();
                  break;
               case GraphicLocation.REF_SCREEN:
                  _loc6_ = param3.localToGlobal(new Point(param3.x,param3.y));
                  _loc4_.x = param2.getOffsetX() - _loc6_.x;
                  _loc4_.y = param2.getOffsetY() - _loc6_.y;
                  break;
               case GraphicLocation.REF_TOP:
                  _loc6_ = new Point(x,y);
                  _loc4_.x = param2.getOffsetX() + (_loc6_.x - _loc5_.x);
                  _loc4_.y = param2.getOffsetY() + (_loc6_.y - _loc5_.y);
                  break;
               default:
                  if(this.isRegisteredId(param2.getRelativeTo()))
                  {
                     _loc8_ = this._aGraphicElementIndex[param2.getRelativeTo()].sprite;
                  }
                  else if(Berilia.getInstance().getUi(param2.getRelativeTo()))
                  {
                     _loc8_ = Berilia.getInstance().getUi(param2.getRelativeTo());
                     UiRootContainer(_loc8_).addLinkedUi(name);
                     param3 = _loc8_;
                  }
                  else if(param2.getRelativeTo().indexOf(".") != -1)
                  {
                     _loc9_ = param2.getRelativeTo().split(".");
                     _loc10_ = Berilia.getInstance().getUi(_loc9_[0]);
                     if(!_loc10_)
                     {
                        _log.warn("[Warning] UI " + _loc9_[0] + " does not exist (found " + param2.getRelativeTo() + " in " + name + ")");
                        return null;
                     }
                     if(!_loc10_.getElementById(_loc9_[1]))
                     {
                        _log.warn("[Warning] UI " + _loc9_[0] + " does not contain element [" + _loc9_[1] + "] (found " + param2.getRelativeTo() + " in " + name + ")");
                        return null;
                     }
                     _loc8_ = _loc10_.getElementById(_loc9_[1]).sprite;
                     _loc5_ = param3.localToGlobal(new Point(param3.x,param3.y));
                     GraphicContainer(_loc8_).getUi().addLinkedUi(name);
                  }
                  else
                  {
                     _log.warn("[Warning] " + param2.getRelativeTo() + " is unknow graphic element reference");
                     return null;
                  }
                  _loc6_ = param3.localToGlobal(new Point(_loc8_.x,_loc8_.y));
                  _loc4_.x = param2.getOffsetX() + (_loc6_.x - _loc5_.x);
                  _loc4_.y = param2.getOffsetY() + (_loc6_.y - _loc5_.y);
            }
            if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
            {
               param1.x = param1.x + _loc4_.x;
            }
            if(param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
            {
               param1.y = param1.y + _loc4_.y;
            }
         }
         _loc4_ = this.getOffsetModificator(param2.getPoint(),param3);
         param1.x = param1.x - _loc4_.x;
         param1.y = param1.y - _loc4_.y;
         switch(param2.getRelativeTo())
         {
            case GraphicLocation.REF_PARENT:
               if(param3.parent && param3.parent.parent)
               {
                  _loc7_ = param3.parent.parent;
               }
               break;
            case GraphicLocation.REF_SCREEN:
               _loc7_ = this._root;
               break;
            case GraphicLocation.REF_TOP:
               _loc7_ = this;
               break;
            default:
               _loc7_ = _loc8_;
               if(_loc7_ == param3)
               {
                  _log.warn("[Warning] Wrong relative position : " + _loc7_.name + " refer to himself");
               }
         }
         _loc4_ = this.getOffsetModificator(param2.getRelativePoint(),_loc7_);
         param1.x = param1.x + _loc4_.x;
         param1.y = param1.y + _loc4_.y;
         return param1;
      }
      
      protected function listenResize(param1:Boolean) : void
      {
         if(AirScanner.hasAir())
         {
            if(param1)
            {
               StageShareManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE,this.onResize,false,0,true);
               StageShareManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onResize,false,0,true);
            }
            else
            {
               StageShareManager.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.RESIZE,this.onResize);
               StageShareManager.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onResize);
            }
         }
      }
      
      private function getOffsetModificator(param1:uint, param2:DisplayObject) : Point
      {
         var _loc3_:uint = Math.abs(param2 == null || param2 is UiRootContainer?!!this._fullscreen?Number(StageShareManager.stageVisibleBounds.width):Number(StageShareManager.startWidth):Number(param2.width));
         var _loc4_:uint = Math.abs(param2 == null || param2 is UiRootContainer?!!this._fullscreen?Number(StageShareManager.stageVisibleBounds.height):Number(StageShareManager.startHeight):Number(param2.height));
         var _loc5_:Point = new Point(0,0);
         switch(param1)
         {
            case LocationEnum.POINT_TOPLEFT:
               break;
            case LocationEnum.POINT_TOP:
               _loc5_.x = _loc3_ / 2;
               break;
            case LocationEnum.POINT_TOPRIGHT:
               _loc5_.x = _loc3_;
               break;
            case LocationEnum.POINT_LEFT:
               _loc5_.y = _loc3_ / 2;
               break;
            case LocationEnum.POINT_CENTER:
               _loc5_.x = _loc3_ / 2;
               _loc5_.y = _loc4_ / 2;
               break;
            case LocationEnum.POINT_RIGHT:
               _loc5_.x = _loc3_;
               _loc5_.y = _loc4_ / 2;
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
               _loc5_.y = _loc4_;
               break;
            case LocationEnum.POINT_BOTTOM:
               _loc5_.x = _loc3_ / 2;
               _loc5_.y = _loc4_;
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
               _loc5_.x = _loc3_;
               _loc5_.y = _loc4_;
         }
         return _loc5_;
      }
      
      private function zSort(param1:Array) : Boolean
      {
         var _loc2_:GraphicElement = null;
         var _loc3_:GraphicLocation = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc4_:Boolean = true;
         var _loc5_:Boolean = false;
         while(_loc4_)
         {
            _loc4_ = false;
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               _loc2_ = param1[_loc6_];
               if(_loc2_ != null)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc2_.locations.length)
                  {
                     _loc8_ = _loc6_ + 1;
                     while(_loc8_ < param1.length)
                     {
                        _loc3_ = _loc2_.locations[_loc7_];
                        if(param1[_loc8_] != null)
                        {
                           if(_loc3_.getRelativeTo().charAt(0) != "$" && _loc3_.getRelativeTo() == param1[_loc8_].sprite.name || _loc3_.getRelativeTo() == GraphicLocation.REF_PARENT && param1[_loc8_].sprite == _loc2_.sprite.getParent())
                           {
                              _loc5_ = true;
                              _loc4_ = true;
                              param1[_loc6_] = param1[_loc8_];
                              param1[_loc8_] = _loc2_;
                              break;
                           }
                        }
                        _loc8_++;
                     }
                     _loc7_++;
                  }
               }
               _loc6_++;
            }
         }
         return _loc5_;
      }
      
      protected function onResize(param1:Event = null) : void
      {
         if(this._lock == false)
         {
            this.render();
         }
      }
   }
}
