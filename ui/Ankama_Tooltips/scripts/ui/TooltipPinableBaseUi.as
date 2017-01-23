package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ComponentHookList;
   import d2hooks.KeyDown;
   import d2hooks.KeyUp;
   import d2hooks.MouseShiftClick;
   import d2hooks.UiLoaded;
   import d2hooks.UiUnloading;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class TooltipPinableBaseUi
   {
      
      private static var _pinCounterId:uint = 0;
      
      private static var _displayedPin:Dictionary = new Dictionary(true);
      
      private static var _pinnedTooltipScripts:Array = [];
      
      private static var _cancelKeyUp:Boolean;
      
      private static var _startPinSequence:Boolean;
       
      
      private var _params:Object;
      
      private var _pinId:int = -1;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var menuApi:ContextMenuApi;
      
      public var isPin:Boolean = false;
      
      public var btnClose:ButtonContainer;
      
      public var btnMenu:ButtonContainer;
      
      public var mainCtr:GraphicContainer;
      
      public var backgroundCtr:GraphicContainer;
      
      private var dragControler:GraphicContainer;
      
      public function TooltipPinableBaseUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:Rectangle = null;
         if(!this.backgroundCtr)
         {
            return;
         }
         var _loc2_:String = this.uiApi.me().name;
         var _loc3_:* = _loc2_.indexOf("_pin@") != -1;
         if(!_loc3_ && param1 && param1.makerParam && param1.makerParam.hasOwnProperty("pinnable") && param1.makerParam.pinnable)
         {
            if(_displayedPin[param1.data])
            {
               this.uiApi.unloadUi("tooltip_" + _displayedPin[param1.data]);
               this.uiApi.hideTooltip();
               return;
            }
            if(param1.makerParam is Object)
            {
               param1.makerParam.noLeftFooter = true;
            }
            this._pinId = _pinCounterId;
            _loc4_ = _loc2_ + "_pin@" + _pinCounterId++;
            _displayedPin[param1.data] = _loc4_;
            this.sysApi.addHook(UiLoaded,this._onUiLoaded);
            _loc5_ = new Rectangle(20,20,0,0);
            if(param1.hasOwnProperty("position") && param1.position)
            {
               _loc5_.x = param1.position.x;
               _loc5_.y = param1.position.y;
            }
            this.uiApi.showTooltip(param1.data,_loc5_,false,_loc4_,0,0,0,param1.makerName,null,param1.makerParam,null,true);
            this.uiApi.hideTooltip();
            return;
         }
         this._params = param1;
         if(_loc3_)
         {
            this.makePin();
         }
         else if(_loc2_.indexOf("compare") == -1)
         {
            this.sysApi.addHook(KeyDown,this._onKeyDown);
            this.sysApi.addHook(KeyUp,this._onKeyUp);
            this.sysApi.addHook(MouseShiftClick,this._onMouseShiftClick);
         }
      }
      
      private function makePin() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.isPin = true;
         if(!this.mainCtr)
         {
            _loc1_ = this.uiApi.me().getBounds(this.uiApi.me());
            this.dragControler = this.uiApi.createContainer("GraphicContainer") as GraphicContainer;
            this.dragControler.width = _loc1_.width;
            this.dragControler.height = _loc1_.height;
            this.dragControler.bgColor = 16711680;
            this.uiApi.me().addChildAt(this.dragControler,0);
         }
         else
         {
            this.dragControler = this.mainCtr;
            _loc2_ = this.dragControler;
            _loc3_ = this.uiApi.me();
            while(_loc2_.name != _loc3_.name && !(_loc2_ is Stage))
            {
               _loc2_.mouseChildren = true;
               _loc2_ = _loc2_.parent;
            }
         }
         this.dragControler.dragController = true;
         this.dragControler.dragTarget = this.uiApi.me().name;
         this.dragControler.dragBoundsContainer = this.dragControler.name;
         this.dragControler.dragSavePosition = false;
         if(this.btnClose)
         {
            this.btnClose.visible = true;
            this.uiApi.addComponentHook(this.btnClose,ComponentHookList.ON_RELEASE);
            if(this.btnMenu)
            {
               this.btnMenu.visible = true;
               this.uiApi.addComponentHook(this.btnMenu,ComponentHookList.ON_PRESS);
            }
         }
         this.highlightPinnedTooltip();
         this.sysApi.addHook(UiUnloading,this._onUiUnload);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("shiftCloseUi",this.onShortcut);
         this.uiApi.addComponentHook(this.mainCtr,"onPress");
         this.uiApi.addComponentHook(this.mainCtr,"onRelease");
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(!this.mainCtr.visible)
         {
            return false;
         }
         switch(param1)
         {
            case "closeUi":
               _loc2_ = this.uiApi.me();
               _loc3_ = _loc2_.parent.numChildren - 1;
               if(_loc2_.childIndex == _loc3_)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
                  return true;
               }
               return false;
            case "shiftCloseUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return false;
            default:
               return false;
         }
      }
      
      public function onPress(param1:Object) : void
      {
         if(param1 == this.mainCtr)
         {
            this.highlightPinnedTooltip();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(param1 == this.mainCtr)
         {
            _loc2_ = this.uiApi.me();
            _loc3_ = _loc2_.parent.numChildren - 1;
            _loc2_.childIndex = _loc3_;
         }
         else if(param1 == this.btnClose)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else if(param1 == this.btnMenu)
         {
            if(this._params && this._params.data && this._params.data != MountWrapper)
            {
               _loc4_ = this.menuApi.create(this._params.data,null,[{"ownedItem":false},this.uiApi.me()["name"]]);
               if(_loc4_.content.length > 0)
               {
                  this.modContextMenu.createContextMenu(_loc4_);
               }
            }
         }
      }
      
      private function _onKeyDown(param1:Object, param2:uint) : void
      {
         if(!_startPinSequence && param2 == Keyboard.SHIFT)
         {
            _cancelKeyUp = false;
            _startPinSequence = true;
         }
      }
      
      private function _onMouseShiftClick(param1:Object) : void
      {
         _cancelKeyUp = true;
      }
      
      private function _onKeyUp(param1:Object, param2:uint) : void
      {
         var _loc3_:String = null;
         _startPinSequence = false;
         if(!_cancelKeyUp && param2 == Keyboard.SHIFT && !_displayedPin[this._params.data])
         {
            _loc3_ = this.uiApi.me().name + "_pin@" + _pinCounterId++;
            this._pinId = _pinCounterId;
            _displayedPin[this._params.data] = _loc3_;
            this.sysApi.addHook(UiLoaded,this._onUiLoaded);
            if(this._params.makerParam is Object)
            {
               try
               {
                  this._params.makerParam.noFooter = true;
               }
               catch(error:Error)
               {
               }
            }
            this.uiApi.showTooltip(this._params.data,new Rectangle(this.uiApi.me().x - this.uiApi.me().width - 20,this.uiApi.me().y,0,0),false,_loc3_,0,0,0,this._params.makerName,null,this._params.makerParam,null,true);
         }
      }
      
      private function _onUiLoaded(param1:String) : void
      {
      }
      
      private function _onUiUnload(param1:String, param2:Object) : void
      {
         var _loc3_:int = 0;
         if(param1 == this.uiApi.me().name && this._params)
         {
            delete _displayedPin[this._params.data];
            _loc3_ = _pinnedTooltipScripts.indexOf(this);
            if(_loc3_ > -1)
            {
               _pinnedTooltipScripts.splice(_loc3_,1);
               if(_pinnedTooltipScripts.length)
               {
                  _pinnedTooltipScripts[_pinnedTooltipScripts.length - 1].backgroundCtr.borderColor = this.sysApi.getConfigEntry("colors.tooltip.border.activePin");
               }
            }
         }
      }
      
      public function highlightPinnedTooltip() : void
      {
         if(_pinnedTooltipScripts.length)
         {
            _pinnedTooltipScripts[_pinnedTooltipScripts.length - 1].backgroundCtr.borderColor = this.sysApi.getConfigEntry("colors.tooltip.border");
         }
         this.backgroundCtr.borderColor = this.sysApi.getConfigEntry("colors.tooltip.border.activePin");
         var _loc1_:int = _pinnedTooltipScripts.indexOf(this);
         if(_loc1_ > -1)
         {
            _pinnedTooltipScripts.splice(_loc1_,1);
         }
         _pinnedTooltipScripts.push(this);
      }
   }
}
