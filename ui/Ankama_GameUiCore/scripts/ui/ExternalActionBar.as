package ui
{
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import d2enums.DataStoreEnum;
   import d2enums.GameContextEnum;
   import d2hooks.ContextChanged;
   import flash.geom.Rectangle;
   import ui.enums.ContextEnum;
   import ui.params.ActionBarParameters;
   
   public class ExternalActionBar extends ActionBar
   {
      
      public static const ORIENTATION_HORIZONTAL:uint = 1;
      
      public static const ORIENTATION_VERTICAL:uint = 2;
       
      
      public var mainCtr:GraphicContainer;
      
      public var btn_options:ButtonContainer;
      
      public var btn_minimize:ButtonContainer;
      
      public var actionBarCtr:GraphicContainer;
      
      public var backgroundCtr:GraphicContainer;
      
      public var actionBarId:uint;
      
      private var _orientation:uint;
      
      private var _screenBounds:Rectangle;
      
      private var _currentContext:uint;
      
      public function ExternalActionBar()
      {
         super();
      }
      
      override public function main(param1:Array) : void
      {
         sysApi.addHook(ContextChanged,this.onContextJustChanged);
         isMainBar = false;
         super.main(param1);
         var _loc2_:ActionBarParameters = param1[0];
         this.actionBarId = _loc2_.id;
         this._orientation = _loc2_.orientation;
         externalActionBars[this.actionBarId] = this;
         _nPageItems = 0;
         _nPageSpells = 0;
         _sTabGrid = ITEMS_TAB;
         var _loc3_:* = sysApi.getData(dataKey,DataStoreEnum.BIND_CHARACTER);
         if(_loc3_ && _loc3_[this.actionBarId])
         {
            _nPageItems = _loc3_[this.actionBarId].nPageItems;
            if(getPlayerId() >= 0)
            {
               _nPageSpells = _loc3_[this.actionBarId].nPageSpells;
            }
            _sTabGrid = _loc3_[this.actionBarId].sTabGrid;
            this.mainCtr.visible = true;
         }
         else if(_loc2_.orientationChanged)
         {
            this.mainCtr.visible = true;
         }
         onShortcutBarViewContent(0);
         onShortcutBarViewContent(1);
         gridDisplay(_sTabGrid,true);
         if(!this.mainCtr.getSavedPosition() && !_loc2_.orientationChanged)
         {
            this.place();
         }
      }
      
      public function restoreData(param1:Object) : void
      {
         _nPageItems = param1.nPageItems;
         if(getPlayerId() >= 0)
         {
            _nPageSpells = param1.nPageSpells;
         }
         _sTabGrid = param1.sTabGrid;
         gridDisplay(_sTabGrid,true);
      }
      
      public function get orientation() : uint
      {
         return this._orientation;
      }
      
      public function get bounds() : Rectangle
      {
         return new Rectangle(this.mainCtr.x,this.mainCtr.y,uiApi.me().width,uiApi.me().height);
      }
      
      private function onContextJustChanged(param1:uint) : void
      {
         if(this._currentContext && this._currentContext != param1)
         {
            this.mainCtr.visible = false;
         }
         this._currentContext = param1;
      }
      
      override protected function onContextChanged(param1:String, param2:String = "", param3:Boolean = false) : void
      {
         if(param1 == ContextEnum.ROLEPLAY)
         {
            this._currentContext = GameContextEnum.ROLE_PLAY;
         }
         else
         {
            this._currentContext = GameContextEnum.FIGHT;
         }
         var _loc4_:* = sysApi.getData(dataKey,DataStoreEnum.BIND_CHARACTER);
         if(!_loc4_)
         {
            _loc4_ = [];
         }
         switch(param1)
         {
            case ContextEnum.SPECTATOR:
               gd_spellitemotes.disabled = true;
               this.mainCtr.visible = false;
               break;
            default:
               if(!_loc4_[this.actionBarId])
               {
                  this.mainCtr.visible = false;
                  mainBar.btn_addActionBar.disabled = false;
               }
               else if(_loc4_[this.actionBarId])
               {
                  if(this._orientation != _loc4_[this.actionBarId].orientation)
                  {
                     this.changeOrientation(_loc4_[this.actionBarId].orientation,false);
                  }
                  else
                  {
                     this.restoreData(_loc4_[this.actionBarId]);
                     this.mainCtr.visible = true;
                     gd_spellitemotes.disabled = false;
                     mainBar.btn_addActionBar.disabled = !canAddExternalActionBar();
                  }
               }
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         super.onRelease(param1);
         switch(param1)
         {
            case btn_tabItems:
            case btn_tabSpells:
            case btn_upArrow:
            case btn_downArrow:
               this.saveCurrentActiveActionBars();
               break;
            case this.btn_options:
               _loc2_ = new Array();
               _loc2_.push(modContextMenu.createContextMenuTitleObject(uiApi.getText("ui.common.options")));
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.banner.actionBar.changeOrientation"),this.changeOrientation,[this._orientation == ORIENTATION_HORIZONTAL?ORIENTATION_VERTICAL:ORIENTATION_HORIZONTAL]));
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.common.close"),this.hide));
               modContextMenu.createContextMenu(_loc2_);
               break;
            case this.btn_minimize:
               this.actionBarCtr.visible = !this.actionBarCtr.visible;
               this.backgroundCtr.bgAlpha = !!this.actionBarCtr.visible?Number(0.7):Number(0);
         }
      }
      
      override public function onRollOver(param1:Object) : void
      {
         super.onRollOver(param1);
      }
      
      override public function unload() : void
      {
         externalActionBars[this.actionBarId] = null;
         super.unload();
      }
      
      override protected function onSwitchBannerTab(param1:String) : void
      {
      }
      
      override public function onOpenSpellBook() : void
      {
      }
      
      override protected function updateSpellShortcuts() : void
      {
         _aSpells = storageApi.getShortcutBarContent(1);
         if(_sTabGrid == SPELLS_TAB)
         {
            updateGrid(_aSpells,_nPageSpells);
         }
      }
      
      override protected function displayPage() : void
      {
         var _loc1_:int = 0;
         if(_sTabGrid == ITEMS_TAB)
         {
            _loc1_ = _nPageItems;
         }
         else if(_sTabGrid == SPELLS_TAB)
         {
            _loc1_ = _nPageSpells;
         }
         lbl_itemsNumber.text = (_loc1_ + 1).toString();
         btn_upArrow.disabled = _loc1_ == 0;
         btn_downArrow.disabled = _loc1_ == NUM_PAGES - 1;
      }
      
      override public function onOpenInventory(... rest) : void
      {
      }
      
      override public function onShortcut(param1:String) : Boolean
      {
         return false;
      }
      
      private function changeOrientation(param1:uint, param2:Boolean = true) : void
      {
         this._orientation = param1;
         if(param2)
         {
            this.saveCurrentActiveActionBars();
         }
         mainBar.reloadExternalActionBar(this.actionBarId,currentContext);
      }
      
      public function show() : void
      {
         this.place();
         _nPageItems = 0;
         _nPageSpells = 0;
         _sTabGrid = ITEMS_TAB;
         gridDisplay(_sTabGrid,true);
         this.mainCtr.visible = true;
         this.saveCurrentActiveActionBars();
      }
      
      public function hide() : void
      {
         this.mainCtr.visible = false;
         uiApi.getUi("bannerActionBar").uiClass.btn_addActionBar.disabled = false;
         this.saveCurrentActiveActionBars();
      }
      
      private function place() : void
      {
         var _loc3_:ExternalActionBar = null;
         var _loc4_:Rectangle = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc1_:Rectangle = this.bounds;
         var _loc2_:Vector.<Rectangle> = new Vector.<Rectangle>(0);
         for each(_loc3_ in externalActionBars)
         {
            if(_loc3_ && _loc3_ != this && _loc3_.mainCtr.visible)
            {
               _loc2_.push(_loc3_.bounds);
            }
         }
         _loc2_.sort(this.compareBounds);
         _loc5_ = _loc2_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc2_[_loc6_];
            _loc1_.x = _loc4_.x;
            _loc1_.y = _loc4_.y + _loc4_.height + 5;
            if(this.isValidBounds(_loc1_,_loc2_))
            {
               break;
            }
            _loc1_.x = _loc4_.x + _loc4_.width + 5;
            _loc1_.y = _loc4_.y;
            if(this.isValidBounds(_loc1_,_loc2_))
            {
               break;
            }
            _loc1_.x = _loc4_.x - _loc4_.width - 5;
            _loc1_.y = _loc4_.y;
            if(this.isValidBounds(_loc1_,_loc2_))
            {
               break;
            }
            _loc1_.x = _loc4_.x;
            _loc1_.y = _loc4_.y - _loc1_.height - 5;
            if(this.isValidBounds(_loc1_,_loc2_))
            {
               break;
            }
            _loc6_++;
         }
         if(_loc5_)
         {
            this.mainCtr.x = _loc1_.x;
            this.mainCtr.y = _loc1_.y;
         }
         else
         {
            this.mainCtr.x = this.mainCtr.y = 0;
         }
         this.mainCtr.setSavedPosition(this.mainCtr.x,this.mainCtr.y);
      }
      
      private function compareBounds(param1:Rectangle, param2:Rectangle) : int
      {
         if(param1.y > param2.y)
         {
            return -1;
         }
         if(param1.y < param2.y)
         {
            return 1;
         }
         return 0;
      }
      
      private function isValidBounds(param1:Rectangle, param2:Vector.<Rectangle>) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:Rectangle = null;
         if(!this._screenBounds)
         {
            _loc3_ = uiApi.getVisibleStageBounds();
            this._screenBounds = new Rectangle(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
         }
         if(this._screenBounds.containsRect(param1))
         {
            for each(_loc4_ in param2)
            {
               if(param1.intersects(_loc4_))
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      private function saveCurrentActiveActionBars() : void
      {
         var _loc1_:Array = sysApi.getData(dataKey,DataStoreEnum.BIND_CHARACTER);
         if(!_loc1_)
         {
            _loc1_ = [];
         }
         var _loc2_:Object = null;
         if(this.mainCtr.visible)
         {
            _loc2_ = new Object();
            _loc2_.sTabGrid = _sTabGrid;
            _loc2_.nPageItems = _nPageItems;
            _loc2_.nPageSpells = _nPageSpells;
            _loc2_.orientation = this._orientation;
         }
         _loc1_[this.actionBarId] = _loc2_;
         sysApi.setData(dataKey,_loc1_,DataStoreEnum.BIND_CHARACTER);
      }
   }
}
