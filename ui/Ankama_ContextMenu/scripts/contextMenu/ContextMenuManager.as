package contextMenu
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import d2hooks.CloseContextMenu;
   import d2hooks.MouseClick;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class ContextMenuManager
   {
      
      private static var _self:ContextMenuManager;
       
      
      private var _contextMenuTree:Array;
      
      private var _currentFocus:Object;
      
      private var _cancelNextClick:Boolean = false;
      
      private var _openDate:uint;
      
      private var _closeCallback:Function;
      
      public var mainUiLoaded:Boolean;
      
      public function ContextMenuManager()
      {
         this._contextMenuTree = new Array();
         super();
         if(_self)
         {
            new Error("Singleton Error");
         }
         Api.system.addHook(MouseClick,this.onGenericMouseClick);
         Api.system.addHook(CloseContextMenu,this.closeAll);
      }
      
      public static function getInstance() : ContextMenuManager
      {
         if(!_self)
         {
            _self = new ContextMenuManager();
         }
         return _self;
      }
      
      public function openNew(param1:Array, param2:Object = null, param3:Function = null, param4:Boolean = false, param5:String = null) : void
      {
         var _loc6_:Object = null;
         if(param1 == null)
         {
            return;
         }
         if(!param4)
         {
            setTimeout(this.openNew,1,param1,param2,param3,true,param5);
            return;
         }
         if(param1.length > 0)
         {
            if(this._contextMenuTree.length)
            {
               for each(_loc6_ in this._contextMenuTree)
               {
                  Api.ui.unloadUi(_loc6_.name);
               }
               if(this._closeCallback != null)
               {
                  this._closeCallback();
               }
            }
            this._openDate = getTimer();
            this._closeCallback = param3;
            this._contextMenuTree = new Array();
            this.mainUiLoaded = false;
            this._contextMenuTree.push(Api.ui.loadUi("contextMenu",!param5?"Ankama_ContextMenu":param5,[param1,param2],3));
         }
      }
      
      public function openChild(param1:Object) : void
      {
         this._contextMenuTree.push(Api.ui.loadUi("contextMenu","Ankama_SubContextMenu" + this._contextMenuTree.length,param1,3));
      }
      
      public function closeChild(param1:Object) : void
      {
         if(this._contextMenuTree.indexOf(param1) == -1)
         {
            return;
         }
         while(this._contextMenuTree.length && this._contextMenuTree[this._contextMenuTree.length - 1] != param1)
         {
            Api.ui.unloadUi(this._contextMenuTree.pop().name);
         }
      }
      
      public function closeAll() : void
      {
         if(!this._contextMenuTree.length)
         {
            return;
         }
         while(this._contextMenuTree.length)
         {
            Api.ui.unloadUi(this._contextMenuTree.pop().name);
         }
         if(this._closeCallback != null)
         {
            this._closeCallback();
         }
      }
      
      public function childHasFocus(param1:Object) : Boolean
      {
         var _loc2_:uint = this._contextMenuTree.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._contextMenuTree[_loc2_] == param1)
            {
               return false;
            }
            if(this._contextMenuTree[_loc2_] == this._currentFocus)
            {
               return true;
            }
            _loc2_--;
         }
         return false;
      }
      
      public function setCurrentFocus(param1:Object) : void
      {
         this._currentFocus = param1;
      }
      
      public function placeMe(param1:Object, param2:Object, param3:Point, param4:Number = 0) : void
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc5_:* = Api.ui.getVisibleStageBounds();
         var _loc6_:int = param3.x;
         var _loc7_:int = param3.y;
         if(_loc6_ + param2.width > _loc5_.right)
         {
            _loc8_ = this.getParent(param1);
            if(_loc8_)
            {
               _loc6_ = _loc8_.getElement("mainCtr").x - param2.width;
            }
            else
            {
               _loc6_ = param3.x - param2.width;
            }
         }
         if(_loc7_ + param2.height > _loc5_.bottom)
         {
            _loc9_ = this.getParent(param1);
            if(_loc9_)
            {
               _loc7_ = _loc7_ - param2.height + param4;
            }
            else
            {
               _loc7_ = param3.y - param2.height;
            }
         }
         if(_loc6_ < _loc5_.left)
         {
            _loc6_ = _loc5_.left;
         }
         if(_loc7_ < _loc5_.top)
         {
            _loc7_ = _loc5_.top;
         }
         param2.x = _loc6_;
         param2.y = _loc7_;
      }
      
      public function getTopParent() : Object
      {
         return this._contextMenuTree[0];
      }
      
      public function getParent(param1:Object) : Object
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._contextMenuTree.length)
         {
            if(this._contextMenuTree[_loc2_] == param1)
            {
               return this._contextMenuTree[_loc2_ - 1];
            }
            _loc2_++;
         }
         return this._contextMenuTree[this._contextMenuTree.length - 1];
      }
      
      private function onGenericMouseClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         try
         {
            _loc2_ = param1 is GraphicContainer?param1.getUi():null;
         }
         catch(e:Error)
         {
         }
         if(!_loc2_ || this._contextMenuTree.indexOf(_loc2_) == -1)
         {
            this.closeAll();
         }
      }
   }
}
