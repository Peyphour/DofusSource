package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import contextMenu.ContextMenuItem;
   import contextMenu.ContextMenuManager;
   import contextMenu.ContextMenuPictureItem;
   import contextMenu.ContextMenuPictureLabelItem;
   import contextMenu.ContextMenuSeparator;
   import contextMenu.ContextMenuTitle;
   import d2enums.StatesEnum;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ContextMenuUi
   {
      
      private static var _openedMenuTriangle:Vector.<Point> = new Vector.<Point>();
      
      private static var _testLabel:Label;
      
      private static const LEFT_DIR:uint = 1;
      
      private static const RIGHT_DIR:uint = 2;
      
      private static const UP_DIR:uint = 3;
      
      private static const DOWN_DIR:uint = 4;
      
      private static const ACTIVATION_DELAY:uint = 300;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      public var mainCtr:GraphicContainer;
      
      public var bgCtr:GraphicContainer;
      
      private var _items:Array;
      
      private var _orderedItems:Array;
      
      private var _openTimer:Timer;
      
      private var _closeTimer:Timer;
      
      private var _lastItemOver:Object;
      
      private var _openedItem:Object;
      
      private var _lastOverIsVirtual:Boolean;
      
      private var _hasPuce:Boolean;
      
      private var _tooltipTimer:Timer;
      
      private var _currentHelpText:String;
      
      public function ContextMenuUi()
      {
         this._items = new Array();
         this._orderedItems = [];
         super();
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:GraphicContainer = null;
         var _loc4_:Label = null;
         var _loc5_:Texture = null;
         var _loc6_:Texture = null;
         var _loc7_:* = undefined;
         var _loc9_:uint = 0;
         var _loc17_:Point = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:String = null;
         var _loc24_:ContextMenuItem = null;
         var _loc25_:Texture = null;
         var _loc26_:Array = null;
         var _loc27_:Array = null;
         this.soundApi.playSound(SoundTypeEnum.OPEN_CONTEXT_MENU);
         if(!_testLabel)
         {
            _testLabel = this.uiApi.createComponent("Label") as Label;
            _testLabel.css = this.uiApi.createUri(this.uiApi.me().getConstant("css.uri"));
            _testLabel.cssClass = this.uiApi.me().getConstant("item.cssClass");
            _testLabel.fixedWidth = false;
            _testLabel.useExtendWidth = true;
         }
         this.initTimer();
         if(param1 is Array)
         {
            _loc2_ = param1[0] as Array;
         }
         else
         {
            _loc2_ = param1.menu;
         }
         var _loc8_:uint = 0;
         var _loc10_:int = parseInt(this.uiApi.me().getConstant("separatorHeight"));
         var _loc11_:int = parseInt(this.uiApi.me().getConstant("titleHeight"));
         var _loc12_:int = parseInt(this.uiApi.me().getConstant("itemHeight"));
         var _loc13_:int = parseInt(this.uiApi.me().getConstant("minWidth"));
         this.uiApi.addShortcutHook("ALL",this.onShortcut);
         var _loc14_:uint = 0;
         var _loc15_:Boolean = false;
         _loc9_ = 0;
         while(_loc9_ < _loc2_.length)
         {
            _loc7_ = _loc2_[_loc9_];
            switch(true)
            {
               case _loc7_ is ContextMenuTitle:
               case _loc7_ is ContextMenuItem:
                  if(_loc7_ is ContextMenuItem || _loc7_ is ContextMenuPictureLabelItem)
                  {
                     if(_loc7_.child)
                     {
                        _loc15_ = true;
                     }
                     if(_loc7_ is ContextMenuItem && ContextMenuItem(_loc7_).selected)
                     {
                        this._hasPuce = true;
                     }
                  }
                  _testLabel.text = _loc7_.label;
                  if(_testLabel.width > _loc14_)
                  {
                     _loc14_ = _testLabel.width;
                  }
                  if(_loc7_ is ContextMenuPictureLabelItem)
                  {
                     _loc19_ = ContextMenuPictureLabelItem(_loc7_).txSize;
                     _loc20_ = _testLabel.width + _loc19_;
                  }
                  if(_loc20_ > _loc14_)
                  {
                     _loc14_ = _loc20_;
                  }
            }
            _loc9_++;
         }
         var _loc16_:uint = 16;
         _loc14_ = _loc14_ + (10 + (!!_loc15_?20:0) + _loc16_);
         if(_loc14_ < _loc13_)
         {
            _loc14_ = _loc13_;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc2_.length)
         {
            _loc7_ = _loc2_[_loc9_];
            switch(true)
            {
               case _loc7_ is ContextMenuTitle:
                  _loc4_ = this.uiApi.createComponent("Label") as Label;
                  _loc4_.width = _loc14_ + 2;
                  _loc4_.height = _loc11_;
                  _loc4_.cssClass = this.uiApi.me().getConstant("title.cssClass");
                  _loc4_.css = this.uiApi.createUri(this.uiApi.me().getConstant("css.uri"));
                  _loc4_.text = " " + this.uiApi.replaceKey(_loc7_.label);
                  _loc4_.bgColor = this.sysApi.getConfigEntry("colors.contextmenu.title");
                  _loc4_.bgAlpha = this.sysApi.getConfigEntry("colors.contextmenu.title.alpha");
                  _loc4_.y = _loc8_ - 2;
                  _loc4_.x = -1;
                  this.mainCtr.addChild(_loc4_);
                  _loc8_ = _loc8_ + _loc11_;
                  this.uiApi.addComponentHook(_loc4_,"onRollOver");
                  break;
               case _loc7_ is ContextMenuSeparator:
                  _loc3_ = this.uiApi.createContainer("GraphicContainer");
                  _loc3_.width = _loc14_;
                  _loc3_.height = 1;
                  _loc3_.y = _loc8_ + (_loc10_ - 1) / 2;
                  _loc3_.bgColor = this.sysApi.getConfigEntry("colors.contextmenu.separator");
                  this.mainCtr.addChild(_loc3_);
                  _loc8_ = _loc8_ + _loc10_;
                  this.uiApi.addComponentHook(_loc3_,"onRollOver");
                  break;
               case _loc7_ is ContextMenuItem:
                  _loc21_ = true;
                  _loc22_ = false;
                  _loc23_ = "";
                  if(_loc7_ is ContextMenuPictureItem)
                  {
                     _loc23_ = ContextMenuPictureItem(_loc7_).uri;
                     _loc21_ = false;
                     _loc22_ = true;
                  }
                  else if(_loc7_ is ContextMenuPictureLabelItem)
                  {
                     _loc22_ = true;
                     _loc23_ = ContextMenuPictureLabelItem(_loc7_).uri;
                  }
                  _loc24_ = _loc7_ as ContextMenuItem;
                  _loc3_ = this.uiApi.createContainer("ButtonContainer");
                  ButtonContainer(_loc3_).isMute = true;
                  _loc3_.width = _loc14_;
                  _loc3_.height = _loc12_;
                  _loc3_.y = _loc8_;
                  _loc3_.name = "btn" + (_loc9_ + 1);
                  this.uiApi.me().registerId(_loc3_.name,this.uiApi.createContainer("GraphicElement",_loc3_,new Array(),_loc3_.name));
                  this._orderedItems.push(_loc3_);
                  _loc25_ = this.uiApi.createComponent("Texture") as Texture;
                  _loc25_.width = 16;
                  _loc25_.height = 16;
                  _loc25_.y = 3;
                  _loc25_.name = "puce" + _loc9_;
                  _loc25_.uri = this.uiApi.createUri(this.uiApi.me().getConstant(!!_loc24_.radioStyle?"radio.uri":"selected.uri"));
                  _loc25_.finalize();
                  _loc3_.addChild(_loc25_);
                  _loc25_.alpha = 0;
                  this.uiApi.me().registerId(_loc25_.name,this.uiApi.createContainer("GraphicElement",_loc25_,new Array(),_loc25_.name));
                  _loc26_ = new Array();
                  _loc26_[StatesEnum.STATE_SELECTED] = new Array();
                  _loc26_[StatesEnum.STATE_SELECTED][_loc3_.name] = new Array();
                  if(!_loc24_.child || !_loc24_.child.length)
                  {
                     _loc26_[StatesEnum.STATE_SELECTED]["puce" + _loc9_] = new Array();
                     _loc26_[StatesEnum.STATE_SELECTED]["puce" + _loc9_]["alpha"] = 1;
                     _loc26_[StatesEnum.STATE_SELECTED][_loc3_.name]["bgColor"] = -1;
                  }
                  else
                  {
                     _loc26_[StatesEnum.STATE_SELECTED][_loc3_.name]["bgColor"] = this.sysApi.getConfigEntry("colors.contextmenu.over");
                     _loc26_[StatesEnum.STATE_SELECTED][_loc3_.name]["bgAlpha"] = this.sysApi.getConfigEntry("colors.contextmenu.over.alpha");
                  }
                  if(!_loc24_.disabled)
                  {
                     _loc26_[StatesEnum.STATE_OVER] = new Array();
                     _loc26_[StatesEnum.STATE_OVER][_loc3_.name] = new Array();
                     _loc26_[StatesEnum.STATE_OVER][_loc3_.name]["bgColor"] = this.sysApi.getConfigEntry("colors.contextmenu.over");
                     _loc26_[StatesEnum.STATE_OVER][_loc3_.name]["bgAlpha"] = this.sysApi.getConfigEntry("colors.contextmenu.over.alpha");
                     _loc26_[StatesEnum.STATE_SELECTED_OVER] = new Array();
                     _loc26_[StatesEnum.STATE_SELECTED_OVER][_loc3_.name] = new Array();
                     _loc26_[StatesEnum.STATE_SELECTED_OVER][_loc3_.name]["bgColor"] = this.sysApi.getConfigEntry("colors.contextmenu.over");
                     _loc26_[StatesEnum.STATE_SELECTED_OVER][_loc3_.name]["bgAlpha"] = this.sysApi.getConfigEntry("colors.contextmenu.over.alpha");
                     _loc26_[StatesEnum.STATE_CLICKED] = _loc26_[StatesEnum.STATE_OVER];
                     if(!_loc24_.child || !_loc24_.child.length)
                     {
                        _loc26_[StatesEnum.STATE_SELECTED_OVER]["puce" + _loc9_] = new Array();
                        _loc26_[StatesEnum.STATE_SELECTED_OVER]["puce" + _loc9_]["alpha"] = 1;
                        _loc26_[StatesEnum.STATE_OVER]["puce" + _loc9_] = new Array();
                        _loc26_[StatesEnum.STATE_OVER]["puce" + _loc9_]["alpha"] = 0;
                     }
                     _loc26_[StatesEnum.STATE_SELECTED_CLICKED] = _loc26_[StatesEnum.STATE_SELECTED_OVER];
                  }
                  ButtonContainer(_loc3_).changingStateData = _loc26_;
                  if(_loc22_)
                  {
                     _loc5_ = this.uiApi.createComponent("Texture") as Texture;
                     if(_loc7_ is ContextMenuPictureLabelItem && _loc7_.txSize <= _loc12_)
                     {
                        _loc5_.height = _loc7_.txSize;
                        _loc5_.width = _loc7_.txSize;
                        _loc5_.y = _loc12_ / 2 - _loc7_.txSize / 2;
                     }
                     else
                     {
                        _loc5_.height = _loc12_;
                        _loc5_.width = _loc12_;
                        _loc5_.y = 0;
                     }
                     _loc27_ = _loc23_.split("?");
                     _loc5_.uri = this.uiApi.createUri(_loc27_[0]);
                     _loc5_.x = _loc16_;
                     if(_loc27_.length == 2)
                     {
                        _loc5_.gotoAndStop = parseInt(_loc27_[1]);
                     }
                     _loc5_.finalize();
                  }
                  if(_loc21_)
                  {
                     _loc4_ = this.uiApi.createComponent("Label") as Label;
                     _loc4_.width = _loc14_ - _loc16_;
                     _loc4_.height = _loc12_;
                     if(_loc24_.disabled)
                     {
                        _loc4_.cssClass = this.uiApi.me().getConstant("disabled.cssClass");
                     }
                     else
                     {
                        _loc4_.cssClass = this.uiApi.me().getConstant("item.cssClass");
                     }
                     _loc4_.css = this.uiApi.createUri(this.uiApi.me().getConstant("css.uri"));
                     _loc4_.html = true;
                     _loc4_.useCustomFormat = true;
                     _loc4_.text = this.uiApi.replaceKey(_loc24_.label);
                     if(_loc22_)
                     {
                        if(_loc7_ is ContextMenuPictureLabelItem && _loc7_.pictureAfterLaber)
                        {
                           _loc5_.x = _loc4_.x + (_loc14_ - _loc5_.width);
                           _loc4_.x = _loc16_;
                        }
                        else
                        {
                           _loc4_.x = _loc16_ + _loc5_.width;
                        }
                     }
                     else
                     {
                        _loc4_.x = _loc16_;
                     }
                  }
                  if(!_loc24_.disabled)
                  {
                     if(_loc24_.child)
                     {
                        _loc6_ = this.uiApi.createComponent("Texture") as Texture;
                        _loc6_.width = 10;
                        _loc6_.height = 10;
                        _loc6_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("rightArrow.uri"));
                        _loc6_.x = _loc4_.width - _loc6_.width;
                        _loc6_.y = (_loc3_.height - _loc6_.height) / 2;
                        _loc6_.finalize();
                        _loc3_.addChild(_loc6_);
                     }
                     this.uiApi.addComponentHook(_loc3_,"onRollOver");
                     this.uiApi.addComponentHook(_loc3_,"onRollOut");
                  }
                  if(_loc24_.callback != null || _loc24_.child)
                  {
                     this.uiApi.addComponentHook(_loc3_,"onRelease");
                  }
                  if(_loc22_)
                  {
                     _loc3_.addChild(_loc5_);
                  }
                  if(_loc21_)
                  {
                     _loc3_.addChild(_loc4_);
                  }
                  ButtonContainer(_loc3_).finalize();
                  _loc8_ = _loc8_ + _loc12_;
                  this._items[_loc3_.name] = _loc24_;
                  this.mainCtr.addChild(_loc3_);
                  ButtonContainer(_loc3_).selected = _loc24_.selected;
            }
            _loc9_++;
         }
         this.bgCtr.x = -1;
         this.bgCtr.y = -1;
         this.bgCtr.width = _loc14_ + 2;
         this.bgCtr.height = _loc8_ + 4;
         var _loc18_:Number = 0;
         if(param1 is Array)
         {
            if(!param1[1])
            {
               _loc17_ = new Point(this.uiApi.getMouseX() + 5,this.uiApi.getMouseY() + 5);
            }
            else
            {
               _loc17_ = new Point(param1[1].x,param1[1].y);
            }
            ContextMenuManager.getInstance().mainUiLoaded = true;
         }
         else
         {
            _loc17_ = new Point(param1.x,param1.y);
            if(param1.hasOwnProperty("targetHeight"))
            {
               _loc18_ = param1.targetHeight;
            }
         }
         ContextMenuManager.getInstance().placeMe(this.uiApi.me(),this.mainCtr,_loc17_,_loc18_);
      }
      
      public function selectParentOpenItem() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = ContextMenuManager.getInstance().getParent(this.uiApi.me());
         if(_loc1_)
         {
            _loc2_ = _loc1_.uiClass.getOpenItem();
            if(_loc2_)
            {
               _loc1_.uiClass.onRollOver(_loc2_,true);
            }
         }
      }
      
      public function getOpenItem() : Object
      {
         return this._openedItem;
      }
      
      public function unload() : void
      {
         this._tooltipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showHelp);
         this.uiApi.hideTooltip("contextMenuHelp");
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         if(this._openedItem == param1)
         {
            return;
         }
         var _loc2_:ContextMenuItem = this._items[param1.name];
         if(this._openedItem)
         {
            this.closeChild();
         }
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.disabled && _loc2_.callback != null)
         {
            if(_loc2_.radioStyle || _loc2_.forceCloseOnSelect)
            {
               _loc2_.callback.apply(null,_loc2_.callbackArgs);
               if(!_loc2_.child)
               {
                  ContextMenuManager.getInstance().closeAll();
               }
            }
            else
            {
               for each(_loc3_ in this._orderedItems)
               {
                  if(_loc3_ != param1)
                  {
                     if(_loc2_.radioStyle)
                     {
                        _loc3_.selected = false;
                     }
                  }
                  else if(!_loc2_.radioStyle)
                  {
                     _loc2_.callback.apply(null,_loc2_.callbackArgs);
                     param1.selected = !param1.selected;
                  }
                  else
                  {
                     if(!param1.selected)
                     {
                        _loc2_.callback.apply(null,_loc2_.callbackArgs);
                     }
                     param1.selected = true;
                  }
               }
            }
         }
         else if(_loc2_.disabled && _loc2_.disabledCallback != null)
         {
            _loc2_.disabledCallback.apply(null,_loc2_.disabledCallbackArgs);
         }
         if(_loc2_.child && !_loc2_.disabled && this.mainCtr != null)
         {
            this._openTimer.reset();
            this._openedItem = param1;
            _loc4_ = RIGHT_DIR;
            _loc5_ = this.mainCtr.x + this.mainCtr.width;
            _loc6_ = this.mainCtr.y + param1.y;
            _loc7_ = this.getMenuWidth(this._items[param1.name].child) + 2;
            _loc8_ = this.getMenuHeight(this._items[param1.name].child) + 4;
            if(_loc5_ + _loc7_ > this.uiApi.getStageWidth())
            {
               _loc5_ = this.mainCtr.x - _loc7_;
               _loc4_ = LEFT_DIR;
            }
            if(_loc6_ + _loc8_ > this.uiApi.getStageHeight())
            {
               _loc6_ = _loc6_ - _loc8_;
            }
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            if(_loc6_ < 0)
            {
               _loc6_ = 0;
            }
            _loc9_ = new Point();
            _loc10_ = new Point();
            if(_loc4_ == RIGHT_DIR)
            {
               _loc9_.x = _loc5_;
               _loc9_.y = _loc6_;
               _loc10_.x = _loc9_.x;
               _loc10_.y = _loc9_.y + _loc8_;
            }
            else if(_loc4_ == LEFT_DIR)
            {
               _loc9_.x = _loc5_ + _loc7_;
               _loc9_.y = _loc6_;
               _loc10_.x = _loc9_.x;
               _loc10_.y = _loc9_.y + _loc8_;
            }
            _openedMenuTriangle.length = 0;
            _openedMenuTriangle.push(new Point(this.uiApi.getMouseX(),this.uiApi.getMouseY()),_loc9_,_loc10_);
            param1.selected = true;
            ContextMenuManager.getInstance().openChild({
               "menu":this._items[param1.name].child,
               "x":this.mainCtr.x + this.mainCtr.width,
               "y":this.mainCtr.y + param1.y,
               "targetHeight":param1.height
            });
         }
         if(!_loc2_.child)
         {
            _loc2_.selected = param1.selected;
         }
      }
      
      public function onRollOver(param1:Object, param2:Boolean = false) : void
      {
         this._tooltipTimer.reset();
         this.selectParentOpenItem();
         if(this._items[param1.name] && this._items[param1.name].child)
         {
            this._openTimer.delay = !!this.isPointInsideTriangle(_openedMenuTriangle,new Point(this.uiApi.getMouseX(),this.uiApi.getMouseY()))?Number(ACTIVATION_DELAY):Number(0);
            this._openTimer.start();
         }
         if(ContextMenuManager.getInstance().childHasFocus(this.uiApi.me()))
         {
            this._closeTimer.start();
         }
         if(this._lastItemOver == param1)
         {
            this._closeTimer.reset();
         }
         if(param2)
         {
            this._lastOverIsVirtual = true;
            param1.state = param1.state + 1;
         }
         if(this._lastItemOver && this._lastOverIsVirtual)
         {
            this.onRollOut(this._lastItemOver,true);
         }
         var _loc3_:ContextMenuItem = this._items[param1.name];
         if(_loc3_ && _loc3_.help)
         {
            this._tooltipTimer.delay = _loc3_.helpDelay;
            this._tooltipTimer.start();
            this._currentHelpText = _loc3_.help;
         }
         ContextMenuManager.getInstance().setCurrentFocus(this.uiApi.me());
         this._lastItemOver = param1;
         this._lastOverIsVirtual = param2;
      }
      
      public function onRollOut(param1:Object, param2:Boolean = false) : void
      {
         this._tooltipTimer.reset();
         this.uiApi.hideTooltip("contextMenuHelp");
         if(this._openedItem)
         {
            this._closeTimer.start();
         }
         this._openTimer.reset();
         if(param2 && param1.hasOwnProperty("state"))
         {
            param1.state = param1.state - 1;
         }
      }
      
      public function showHelp(param1:Event) : void
      {
         this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this._currentHelpText),ContextMenuManager.getInstance().getTopParent().getElement("mainCtr"),false,"contextMenuHelp",2,0,3,null,null,null,"TextInfo");
      }
      
      private function openChild(param1:Event = null) : void
      {
         this._openTimer.reset();
         this.onRelease(this._lastItemOver);
      }
      
      private function closeChild(param1:Event = null) : void
      {
         if(!this.uiApi || ContextMenuManager.getInstance().childHasFocus(this.uiApi.me()))
         {
            return;
         }
         this._openedItem.selected = false;
         this._closeTimer.reset();
         this._openedItem = null;
         ContextMenuManager.getInstance().closeChild(this.uiApi.me());
      }
      
      private function initTimer() : void
      {
         this._tooltipTimer = new Timer(1000,1);
         this._tooltipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.showHelp);
         this._openTimer = new Timer(parseInt(this.uiApi.me().getConstant("timer.open")),1);
         this._openTimer.addEventListener(TimerEvent.TIMER,this.openChild);
         this._closeTimer = new Timer(parseInt(this.uiApi.me().getConstant("timer.close")),1);
         this._closeTimer.addEventListener(TimerEvent.TIMER,this.closeChild);
      }
      
      private function addToIndex(param1:int) : void
      {
         var _loc2_:int = -1;
         if(this._lastItemOver)
         {
            _loc2_ = this._orderedItems.indexOf(this._lastItemOver);
         }
         if(_loc2_ == -1)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = (_loc2_ + param1) % this._orderedItems.length;
            if(_loc2_ == -1)
            {
               _loc2_ = this._orderedItems.length - 1;
            }
         }
         var _loc3_:Object = this._orderedItems[_loc2_];
         if(_loc3_)
         {
            if(this._lastItemOver)
            {
               this.onRollOut(this._lastItemOver);
            }
            this.onRollOver(_loc3_,true);
            this._lastItemOver = _loc3_;
         }
      }
      
      private function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(this._lastItemOver)
               {
                  this.onRelease(this._lastItemOver);
               }
               ContextMenuManager.getInstance().closeAll();
               return true;
            case "upArrow":
               this.addToIndex(-1);
               return true;
            case "downArrow":
               this.addToIndex(1);
               return true;
            case "closeUi":
               ContextMenuManager.getInstance().closeAll();
               return true;
            default:
               return true;
         }
      }
      
      private function getMenuWidth(param1:Array) : Number
      {
         var _loc2_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         var _loc3_:int = param1.length;
         var _loc4_:Number = 0;
         var _loc7_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1[_loc2_];
            if(_loc5_ is ContextMenuItem && _loc5_.child)
            {
               _loc7_ = true;
            }
            switch(true)
            {
               case _loc5_ is ContextMenuTitle:
               case _loc5_ is ContextMenuItem:
                  _testLabel.text = _loc5_.label;
                  _loc6_ = _loc5_ is ContextMenuPictureLabelItem?Number(_testLabel.width + (_loc5_ as ContextMenuPictureLabelItem).txSize):Number(_testLabel.width);
                  if(_loc6_ > _loc4_)
                  {
                     _loc4_ = _loc6_;
                  }
            }
            _loc2_++;
         }
         var _loc8_:int = parseInt(this.uiApi.me().getConstant("minWidth"));
         _loc4_ = _loc4_ + (10 + (!!_loc7_?20:0) + 16);
         if(_loc4_ < _loc8_)
         {
            _loc4_ = _loc8_;
         }
         return _loc4_;
      }
      
      private function getMenuHeight(param1:Array) : Number
      {
         var _loc2_:int = 0;
         var _loc5_:* = undefined;
         var _loc3_:int = param1.length;
         var _loc4_:Number = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1[_loc2_];
            switch(true)
            {
               case _loc5_ is ContextMenuTitle:
                  _loc4_ = _loc4_ + parseInt(this.uiApi.me().getConstant("titleHeight"));
                  break;
               case _loc5_ is ContextMenuSeparator:
                  _loc4_ = _loc4_ + parseInt(this.uiApi.me().getConstant("separatorHeight"));
                  break;
               case _loc5_ is ContextMenuItem:
                  _loc4_ = _loc4_ + parseInt(this.uiApi.me().getConstant("itemHeight"));
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      private function isPointInsideTriangle(param1:Vector.<Point>, param2:Point) : Boolean
      {
         if(param1.length != 3)
         {
            return false;
         }
         var _loc3_:Point = param1[0];
         var _loc4_:Point = param1[1];
         var _loc5_:Point = param1[2];
         var _loc6_:Number = ((_loc4_.y - _loc5_.y) * (param2.x - _loc5_.x) + (_loc5_.x - _loc4_.x) * (param2.y - _loc5_.y)) / ((_loc4_.y - _loc5_.y) * (_loc3_.x - _loc5_.x) + (_loc5_.x - _loc4_.x) * (_loc3_.y - _loc5_.y));
         var _loc7_:Number = ((_loc5_.y - _loc3_.y) * (param2.x - _loc5_.x) + (_loc3_.x - _loc5_.x) * (param2.y - _loc5_.y)) / ((_loc4_.y - _loc5_.y) * (_loc3_.x - _loc5_.x) + (_loc5_.x - _loc4_.x) * (_loc3_.y - _loc5_.y));
         var _loc8_:Number = 1 - _loc6_ - _loc7_;
         return _loc6_ > 0 && _loc7_ > 0 && _loc8_ > 0;
      }
   }
}
