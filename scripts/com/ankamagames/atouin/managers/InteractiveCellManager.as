package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.data.map.Layer;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.renderers.TrapZoneRenderer;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.CellContainer;
   import com.ankamagames.atouin.types.CellReference;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.DebugToolTip;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.LayerContainer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class InteractiveCellManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InteractiveCellManager));
      
      private static var _self:InteractiveCellManager;
       
      
      private var _cellOverEnabled:Boolean = false;
      
      private var _aCells:Array;
      
      private var _aCellPool:Array;
      
      private var _bShowGrid:Boolean;
      
      private var _isInFight:Boolean = false;
      
      private var _interaction_click:Boolean;
      
      private var _interaction_out:Boolean;
      
      private var _trapZoneRenderer:TrapZoneRenderer;
      
      public function InteractiveCellManager()
      {
         this._aCellPool = new Array();
         this._bShowGrid = Atouin.getInstance().options.alwaysShowGrid;
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.init();
      }
      
      public static function getInstance() : InteractiveCellManager
      {
         if(!_self)
         {
            _self = new InteractiveCellManager();
         }
         return _self;
      }
      
      public function get cellOverEnabled() : Boolean
      {
         return this._cellOverEnabled;
      }
      
      public function set cellOverEnabled(param1:Boolean) : void
      {
         this.overStateChanged(this._cellOverEnabled,param1);
         this._cellOverEnabled = param1;
      }
      
      public function get cellOutEnabled() : Boolean
      {
         return this._interaction_out;
      }
      
      public function get cellClickEnabled() : Boolean
      {
         return this._interaction_click;
      }
      
      public function initManager() : void
      {
         this._aCells = new Array();
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public function setInteraction(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true) : void
      {
         var _loc6_:GraphicCell = null;
         this._interaction_click = param1;
         this._cellOverEnabled = param2;
         this._interaction_out = param3;
         for each(_loc6_ in this._aCells)
         {
            if(param1)
            {
               _loc6_.addEventListener(MouseEvent.CLICK,this.mouseClick);
            }
            else
            {
               _loc6_.removeEventListener(MouseEvent.CLICK,this.mouseClick);
            }
            if(param2)
            {
               _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            }
            else
            {
               _loc6_.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            }
            if(param3)
            {
               _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            }
            else
            {
               _loc6_.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            }
            _loc6_.mouseEnabled = param1 || param2 || param3;
            if(param4 && CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc6_.cellId]).havenbagCell)
            {
               _loc6_.visible = param5;
            }
         }
      }
      
      public function getCell(param1:uint) : GraphicCell
      {
         this._aCells[param1] = this._aCellPool[param1];
         return this._aCells[param1];
      }
      
      public function updateInteractiveCell(param1:DataMapContainer) : void
      {
         var _loc3_:CellReference = null;
         var _loc4_:GraphicCell = null;
         var _loc5_:DisplayObject = null;
         var _loc8_:LayerContainer = null;
         var _loc13_:CellContainer = null;
         if(!param1)
         {
            _log.error("Can\'t update interactive cell of a NULL container");
            return;
         }
         this.setInteraction(true,Atouin.getInstance().options.showCellIdOnOver,Atouin.getInstance().options.showCellIdOnOver);
         var _loc2_:Array = param1.getCell();
         var _loc6_:Boolean = Atouin.getInstance().options.showTransitions;
         var _loc7_:Number = this._bShowGrid || Atouin.getInstance().options.alwaysShowGrid?Number(1):Number(0);
         _loc8_ = param1.getLayer(Layer.LAYER_DECOR);
         var _loc9_:uint = 0;
         var _loc10_:uint = this._aCells.length;
         var _loc11_:uint = 0;
         var _loc12_:GraphicCell = this._aCells[0];
         if(!_loc12_)
         {
            while(!_loc12_ && _loc9_ < _loc10_)
            {
               _loc12_ = this._aCells[_loc9_++];
            }
            _loc9_--;
         }
         while(_loc11_ < _loc8_.numChildren && _loc9_ < _loc10_)
         {
            _loc13_ = _loc8_.getChildAt(_loc11_) as CellContainer;
            if(_loc12_ != null && (_loc13_ && _loc12_.cellId <= _loc13_.cellId))
            {
               _loc3_ = _loc2_[_loc9_];
               _loc4_ = this._aCells[_loc9_];
               _loc4_.y = _loc3_.elevation;
               _loc4_.visible = _loc3_.mov && !_loc3_.isDisabled;
               _loc4_.alpha = _loc7_;
               _loc8_.addChildAt(_loc4_,_loc11_);
               _loc12_ = this._aCells[++_loc9_];
            }
            _loc11_++;
         }
      }
      
      public function updateCell(param1:uint, param2:Boolean) : Boolean
      {
         DataMapProvider.getInstance().updateCellMovLov(param1,param2);
         if(this._aCells[param1] != null)
         {
            this._aCells[param1].visible = param2;
            return true;
         }
         return false;
      }
      
      public function updateCellElevation(param1:uint, param2:int) : void
      {
         if(!this._aCells[param1].initialElevation)
         {
            this._aCells[param1].initialElevation = this._aCells[param1].y;
         }
         this._aCells[param1].y = this._aCells[param1].initialElevation - param2;
      }
      
      public function resetHavenbagCellsVisibility() : void
      {
         var _loc1_:GraphicCell = null;
         for each(_loc1_ in this._aCells)
         {
            if(_loc1_ && MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc1_.cellId].havenbagCell)
            {
               _loc1_.visible = true;
            }
         }
      }
      
      public function show(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc5_:GraphicCell = null;
         this._bShowGrid = param1;
         this._isInFight = param2;
         var _loc3_:Number = this._bShowGrid || Atouin.getInstance().options.alwaysShowGrid?Number(1):Number(0);
         var _loc4_:Array = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells;
         var _loc6_:uint = 0;
         while(_loc6_ < this._aCells.length)
         {
            _loc5_ = GraphicCell(this._aCells[_loc6_]);
            if(_loc5_)
            {
               if(param2)
               {
                  _loc5_.buttonMode = !_loc4_[_loc6_].nonWalkableDuringFight;
               }
               else
               {
                  _loc5_.buttonMode = !_loc4_[_loc6_].nonWalkableDuringRP;
               }
               if(param2 && _loc3_ == 1 && _loc4_[_loc6_].nonWalkableDuringFight)
               {
                  _loc5_.alpha = 0;
               }
               else
               {
                  _loc5_.alpha = _loc3_;
               }
            }
            _loc6_++;
         }
      }
      
      public function clean() : void
      {
         var _loc1_:uint = 0;
         if(this._aCells)
         {
            _loc1_ = 0;
            while(_loc1_ < this._aCells.length)
            {
               if(!(!this._aCells[_loc1_] || !this._aCells[_loc1_].parent))
               {
                  this._aCells[_loc1_].parent.removeChild(this._aCells[_loc1_]);
               }
               _loc1_++;
            }
         }
      }
      
      private function init() : void
      {
         var _loc2_:GraphicCell = null;
         var _loc1_:uint = 0;
         while(_loc1_ < AtouinConstants.MAP_CELLS_COUNT)
         {
            _loc2_ = new GraphicCell(_loc1_);
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            this._aCellPool[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      private function overStateChanged(param1:Boolean, param2:Boolean) : void
      {
         if(param1 == param2)
         {
            return;
         }
         if(!param1 && param2)
         {
            this.registerOver(true);
         }
         else if(param1 && !param2)
         {
            this.registerOver(false);
         }
      }
      
      private function registerOver(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < AtouinConstants.MAP_CELLS_COUNT)
         {
            if(this._aCells[_loc2_])
            {
               if(param1)
               {
                  this._aCells[_loc2_].addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
                  this._aCells[_loc2_].addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
               }
               else
               {
                  this._aCells[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
                  this._aCells[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
               }
            }
            _loc2_++;
         }
      }
      
      private function mouseClick(param1:MouseEvent) : void
      {
         var _loc6_:Array = null;
         var _loc7_:IEntity = null;
         var _loc8_:CellClickMessage = null;
         var _loc2_:Sprite = Sprite(param1.target);
         if(!_loc2_.parent)
         {
            return;
         }
         var _loc3_:int = _loc2_.parent.getChildIndex(_loc2_);
         var _loc4_:int = parseInt(_loc2_.name);
         var _loc5_:Point = CellIdConverter.cellIdToCoord(_loc4_);
         if(!DataMapProvider.getInstance().pointCanStop(_loc5_.x,_loc5_.y))
         {
            _log.info("Cannot move to this cell in RP");
            return;
         }
         if(Atouin.getInstance().options.virtualPlayerJump)
         {
            _loc6_ = EntitiesManager.getInstance().entities;
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_ is IMovable)
               {
                  IMovable(_loc7_).jump(MapPoint.fromCellId(_loc4_));
                  break;
               }
            }
         }
         else
         {
            _loc8_ = new CellClickMessage();
            _loc8_.cellContainer = _loc2_;
            _loc8_.cellDepth = _loc3_;
            _loc8_.cell = MapPoint.fromCoords(_loc5_.x,_loc5_.y);
            _loc8_.cellId = _loc4_;
            Atouin.getInstance().handler.process(_loc8_);
         }
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:* = null;
         var _loc9_:MapPoint = null;
         var _loc10_:CellData = null;
         var _loc11_:Selection = null;
         var _loc2_:Sprite = Sprite(param1.target);
         if(!_loc2_.parent)
         {
            return;
         }
         var _loc3_:int = _loc2_.parent.getChildIndex(_loc2_);
         var _loc4_:int = parseInt(_loc2_.name);
         var _loc5_:Point = CellIdConverter.cellIdToCoord(_loc4_);
         if(Atouin.getInstance().options.showCellIdOnOver)
         {
            _loc7_ = 0;
            _loc8_ = _loc2_.name + " (" + _loc5_.x + "/" + _loc5_.y + ")";
            _loc9_ = MapPoint.fromCoords(_loc5_.x,_loc5_.y);
            _loc8_ = _loc8_ + ("\nLigne de vue : " + !DataMapProvider.getInstance().pointLos(_loc9_.x,_loc9_.y));
            _loc8_ = _loc8_ + ("\nBlocage éditeur : " + !DataMapProvider.getInstance().pointMov(_loc9_.x,_loc9_.y));
            _loc8_ = _loc8_ + ("\nBlocage entitée : " + !DataMapProvider.getInstance().pointMov(_loc9_.x,_loc9_.y,false));
            _loc8_ = _loc8_ + ("\nfarmCell : " + DataMapProvider.getInstance().farmCell(_loc9_.x,_loc9_.y));
            _loc8_ = _loc8_ + ("\nhavenbagCell : " + DataMapProvider.getInstance().cellByCoordsIsHavenbagCell(_loc9_.x,_loc9_.y));
            _loc10_ = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc4_]);
            _loc8_ = _loc8_ + ("\nForcage fleche bas : " + _loc10_.useBottomArrow);
            _loc8_ = _loc8_ + ("\nForcage fleche haut : " + _loc10_.useTopArrow);
            _loc8_ = _loc8_ + ("\nForcage fleche droite : " + _loc10_.useRightArrow);
            _loc8_ = _loc8_ + ("\nForcage fleche gauche : " + _loc10_.useLeftArrow);
            _loc8_ = _loc8_ + ("\nID de zone : " + _loc10_.moveZone);
            _loc8_ = _loc8_ + ("\nHauteur : " + _loc10_.floor + " px");
            _loc8_ = _loc8_ + ("\nSpeed : " + _loc10_.speed);
            DebugToolTip.getInstance().text = _loc8_;
            _loc11_ = SelectionManager.getInstance().getSelection("infoOverCell");
            if(!_loc11_)
            {
               _loc11_ = new Selection();
               _loc11_.color = new Color(_loc7_);
               _loc11_.renderer = new ZoneDARenderer();
               _loc11_.zone = new Lozenge(0,0,DataMapProvider.getInstance());
               SelectionManager.getInstance().addSelection(_loc11_,"infoOverCell",_loc4_);
            }
            else
            {
               SelectionManager.getInstance().update("infoOverCell",_loc4_);
            }
            StageShareManager.stage.addChild(DebugToolTip.getInstance());
         }
         var _loc6_:CellOverMessage = new CellOverMessage();
         _loc6_.cellContainer = _loc2_;
         _loc6_.cellDepth = _loc3_;
         _loc6_.cell = MapPoint.fromCoords(_loc5_.x,_loc5_.y);
         _loc6_.cellId = _loc4_;
         Atouin.getInstance().handler.process(_loc6_);
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = Sprite(param1.target);
         if(!_loc2_.parent)
         {
            return;
         }
         var _loc3_:int = _loc2_.parent.getChildIndex(_loc2_);
         var _loc4_:int = parseInt(_loc2_.name);
         var _loc5_:Point = CellIdConverter.cellIdToCoord(_loc4_);
         if(Atouin.getInstance().worldContainer.contains(DebugToolTip.getInstance()))
         {
            Atouin.getInstance().worldContainer.removeChild(DebugToolTip.getInstance());
         }
         var _loc6_:CellOutMessage = new CellOutMessage();
         _loc6_.cellContainer = _loc2_;
         _loc6_.cellDepth = _loc3_;
         _loc6_.cell = MapPoint.fromCoords(_loc5_.x,_loc5_.y);
         _loc6_.cellId = _loc4_;
         Atouin.getInstance().handler.process(_loc6_);
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName == "alwaysShowGrid")
         {
            this.show(param1.propertyValue,this._isInFight);
         }
      }
   }
}
