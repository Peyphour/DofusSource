package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.elements.subtypes.NormalGraphicalElementData;
   import com.ankamagames.atouin.enums.HavenbagLayersEnum;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.HavenbagFurnituresManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.IFurniture;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.dofus.internalDatacenter.house.HavenbagFurnitureWrapper;
   import com.ankamagames.jerakine.entities.behaviours.IDisplayBehavior;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FiltersManager;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class HavenbagFurnitureSprite extends Sprite implements IFurniture
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HavenbagFurnitureSprite));
      
      private static const _highlightFilter:GlowFilter = new GlowFilter(16777215,0.6,8,8);
      
      private static const _multiCellsHighlightFilter:GlowFilter = new GlowFilter(16777215,0.6,8,8,2,1,false,true);
      
      private static const _errorGlowFilter:GlowFilter = new GlowFilter(15073280,0.8,8,8,8,1);
      
      private static const _errorColorFilter:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,0,0.5,0,0,0,0,0,0.5,0,0,0,0,0,0.6,0]);
       
      
      private var _id:Number;
      
      private var _data:HavenbagFurnitureWrapper;
      
      private var _mp:MapPoint;
      
      private var _gfxLoader:IResourceLoader;
      
      private var _content:Bitmap;
      
      private var _uri:Uri;
      
      private var _layerId:int = 0;
      
      private var _strata:uint;
      
      private var _orientation:uint = 0;
      
      private var _onDisplayedCallback:Function;
      
      private var _cells:Vector.<MapPoint>;
      
      private var _subSprites:Vector.<HavenbagFurnitureSubSprite>;
      
      private var _cutOnLoaded:Boolean = false;
      
      private var _originalBitmapData:BitmapData;
      
      private var _offsetY:Number = 0;
      
      private var _offsetPosition:MapPoint;
      
      private var _offsetPositionPixels:Point;
      
      public function HavenbagFurnitureSprite(param1:int, param2:Function = null)
      {
         this._offsetPositionPixels = new Point();
         super();
         this._data = HavenbagFurnitureWrapper.create(param1);
         this._layerId = this._data.layerId;
         this._strata = PlacementStrataEnums.STRATA_DEFAULT + this._layerId + 1;
         this._mp = new MapPoint();
         this._content = new Bitmap(null,PixelSnapping.NEVER);
         this._content.x = -this.element.origin.x;
         this._content.y = -this.element.origin.y;
         addChild(this._content);
         this._onDisplayedCallback = param2;
         if(this.element.gfxId)
         {
            this._uri = new Uri(Atouin.getInstance().options.elementsPath + "/" + Atouin.getInstance().options.pngSubPath + "/" + this.element.gfxId + "." + Atouin.getInstance().options.mapPictoExtension);
            this._gfxLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
            this._gfxLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onGfxLoaded);
            this._gfxLoader.addEventListener(ResourceErrorEvent.ERROR,this.onGfxError);
            this._gfxLoader.load(this._uri);
         }
         else
         {
            this.onGfxError(null);
         }
         mouseEnabled = false;
         mouseChildren = false;
         if(this._data.colorTransform)
         {
            this._content.transform.colorTransform = this._data.colorTransform;
         }
      }
      
      public function get element() : NormalGraphicalElementData
      {
         return this._data.element;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function get layerId() : int
      {
         return this._layerId;
      }
      
      public function get isStackable() : Boolean
      {
         return this._data.isStackable;
      }
      
      public function get cellsWidth() : uint
      {
         return this.orientation % 2 == 0?uint(this._data.cellsWidth):uint(this._data.cellsHeight);
      }
      
      public function get cellsHeight() : uint
      {
         return this.orientation % 2 == 0?uint(this._data.cellsHeight):uint(this._data.cellsWidth);
      }
      
      public function set offsetPosition(param1:MapPoint) : void
      {
         var _loc2_:GraphicCell = null;
         var _loc3_:GraphicCell = null;
         this._offsetPosition = param1;
         if(this._offsetPositionPixels)
         {
            this._content.x = this._content.x + this._offsetPositionPixels.x;
            this._content.y = this._content.y + this._offsetPositionPixels.y;
         }
         if(this._offsetPosition != this.position)
         {
            _loc2_ = InteractiveCellManager.getInstance().getCell(this._offsetPosition.cellId);
            _loc3_ = InteractiveCellManager.getInstance().getCell(this.position.cellId);
            this._offsetPositionPixels.x = _loc3_.x - _loc2_.x;
            this._offsetPositionPixels.y = _loc3_.y - _loc2_.y;
            this._content.x = this._content.x - this._offsetPositionPixels.x;
            this._content.y = this._content.y - this._offsetPositionPixels.y;
            this.position = param1;
         }
         else
         {
            this._offsetPositionPixels.x = 0;
            this._offsetPositionPixels.y = 0;
         }
      }
      
      public function get offsetPosition() : MapPoint
      {
         return this._offsetPosition;
      }
      
      public function destroy() : void
      {
         this.remove();
         if(this._subSprites)
         {
            while(this._subSprites.length)
            {
               this._subSprites.pop().destroy();
            }
            this._subSprites = null;
         }
         this._originalBitmapData = null;
         this._cells = null;
         filters = [];
         this._data = null;
         this._mp = null;
         this._content.bitmapData = null;
         this._content = null;
         this._uri = null;
         this._offsetY = 0;
         this.destroyLoader();
      }
      
      public function addEventListeners() : void
      {
         var _loc1_:int = 0;
         buttonMode = true;
         mouseEnabled = true;
         if(this._subSprites)
         {
            _loc1_ = 0;
            while(_loc1_ < this._subSprites.length)
            {
               this._subSprites[_loc1_].mouseEnabled = true;
               this._subSprites[_loc1_].buttonMode = true;
               _loc1_++;
            }
         }
      }
      
      public function removeEventListeners() : void
      {
         var _loc1_:int = 0;
         buttonMode = false;
         mouseEnabled = false;
         if(this._subSprites)
         {
            _loc1_ = 0;
            while(_loc1_ < this._subSprites.length)
            {
               this._subSprites[_loc1_].mouseEnabled = false;
               this._subSprites[_loc1_].buttonMode = false;
               _loc1_++;
            }
         }
      }
      
      public function displayHighlight(param1:Boolean) : void
      {
         var _loc2_:BitmapData = null;
         if(param1)
         {
            if(this._subSprites && this._subSprites.length > 1)
            {
               this._originalBitmapData = this._content.bitmapData.clone();
               _loc2_ = this._content.bitmapData.clone();
               _loc2_.threshold(_loc2_,_loc2_.rect,new Point(),">",4278190080,4278190080,4294967295);
               this._content.alpha = 1;
               this._content.bitmapData = _loc2_;
               FiltersManager.getInstance().addEffect(this,_multiCellsHighlightFilter);
            }
            else
            {
               FiltersManager.getInstance().addEffect(this,_highlightFilter);
            }
         }
         else if(this._originalBitmapData)
         {
            this._content.alpha = 0;
            this._content.bitmapData = this._originalBitmapData;
            this._originalBitmapData = null;
            FiltersManager.getInstance().removeEffect(this,_multiCellsHighlightFilter);
         }
         else
         {
            FiltersManager.getInstance().removeEffect(this,_highlightFilter);
         }
      }
      
      public function set orientation(param1:uint) : void
      {
         if(param1 == 1)
         {
            this._orientation = 1;
            this._content.scaleX = -1;
            this._content.x = this.element.origin.x - this._offsetPositionPixels.x;
            this._content.y = -this.element.origin.y - this._offsetY - this._offsetPositionPixels.y;
            this._content.x = this._content.x + ((this.cellsWidth > this.cellsHeight?this.cellsWidth:this.cellsHeight) * AtouinConstants.CELL_WIDTH - AtouinConstants.CELL_WIDTH);
            if(this.cellsWidth != this.cellsHeight)
            {
               this._content.x = this._content.x - AtouinConstants.CELL_HALF_WIDTH;
               if(this._data.cellsWidth < this._data.cellsHeight)
               {
                  this._content.y = this._content.y + AtouinConstants.CELL_HALF_HEIGHT;
               }
               else
               {
                  this._content.y = this._content.y - AtouinConstants.CELL_HALF_HEIGHT;
               }
            }
            if(this._subSprites && this._subSprites.length)
            {
               this._subSprites.reverse();
               this.reorderSubSprites();
               if(this._data.cellsWidth != this._data.cellsHeight)
               {
                  this._cells = null;
               }
               if(this._content.alpha == 1)
               {
                  this.displayAsError();
               }
            }
         }
         else
         {
            this._orientation = 0;
            this._content.scaleX = 1;
            this._content.x = -this.element.origin.x - this._offsetPositionPixels.x;
            this._content.y = -this.element.origin.y - this._offsetY - this._offsetPositionPixels.y;
            if(this._subSprites && this._subSprites.length)
            {
               this._subSprites.reverse();
               this.reorderSubSprites();
               if(this._data.cellsWidth != this._data.cellsHeight)
               {
                  this._cells = null;
               }
               if(this._content.alpha == 1)
               {
                  this.displayAsError();
               }
            }
         }
      }
      
      public function get orientation() : uint
      {
         return this._orientation;
      }
      
      public function get hasHorizontalSymmetry() : Boolean
      {
         return this._orientation % 2 != 0;
      }
      
      public function get strata() : uint
      {
         return this._strata;
      }
      
      public function get displayBehaviors() : IDisplayBehavior
      {
         return null;
      }
      
      public function set displayBehaviors(param1:IDisplayBehavior) : void
      {
      }
      
      public function get displayed() : Boolean
      {
         return this._content && this._content.parent;
      }
      
      public function get absoluteBounds() : IRectangle
      {
         return EntitiesDisplayManager.getInstance().getAbsoluteBounds(this);
      }
      
      public function get cells() : Vector.<MapPoint>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this._cells)
         {
            this._cells = new Vector.<MapPoint>(this._data.cellsWidth * this._data.cellsHeight,true);
            this._cells[0] = new MapPoint();
         }
         if(this._cells[0].cellId != this.position.cellId)
         {
            this._cells[0].cellId = this.position.cellId;
            _loc1_ = -1;
            _loc2_ = 0;
            while(_loc2_ < this.cellsWidth)
            {
               _loc3_ = 0;
               while(_loc3_ < this.cellsHeight)
               {
                  _loc1_++;
                  if(_loc1_ != 0)
                  {
                     this._cells[_loc1_] = MapPoint.fromCoords(this.position.x + _loc2_,this.position.y + _loc3_);
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         return this._cells;
      }
      
      public function display(param1:uint = 0) : void
      {
         if(this._layerId != HavenbagLayersEnum.FLOOR)
         {
            EntitiesDisplayManager.getInstance().displayEntity(this,this.position,!!param1?uint(param1):uint(this._strata),false);
         }
         else
         {
            EntitiesDisplayManager.getInstance().displayEntity(this,this.position,this._strata,false,HavenbagFurnituresManager.getInstance().sortFloorFurnitures);
         }
         if(this._data.cellsWidth != 1 || this._data.cellsHeight != 1)
         {
            if(this._content.bitmapData)
            {
               this.cutGfx();
            }
            else
            {
               this._cutOnLoaded = true;
            }
         }
         FiltersManager.getInstance().removeEffect(this,_errorColorFilter);
         FiltersManager.getInstance().removeEffect(this,_errorGlowFilter);
      }
      
      public function displayAsError() : void
      {
         this.remove();
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(HavenbagFurnituresManager.SELECTION_FURNITURE);
         if(_loc1_)
         {
            _loc1_.remove();
         }
         this._content.alpha = 1;
         if(FiltersManager.getInstance().indexOf(this,_errorColorFilter) == -1)
         {
            FiltersManager.getInstance().addEffect(this,_errorGlowFilter);
            FiltersManager.getInstance().addEffect(this,_errorColorFilter);
         }
         EntitiesDisplayManager.getInstance().displayEntity(this,this.position,PlacementStrataEnums.STRATA_NO_Z_ORDER,false);
      }
      
      public function remove() : void
      {
         var _loc1_:int = 0;
         this.displayHighlight(false);
         if(this._subSprites)
         {
            _loc1_ = 0;
            while(_loc1_ < this._subSprites.length)
            {
               this._subSprites[_loc1_].remove();
               _loc1_++;
            }
         }
         EntitiesDisplayManager.getInstance().removeEntity(this);
         FiltersManager.getInstance().removeEffect(this,_errorColorFilter);
         FiltersManager.getInstance().removeEffect(this,_errorGlowFilter);
      }
      
      public function canSeeThrough() : Boolean
      {
         return false;
      }
      
      public function canWalkThrough() : Boolean
      {
         return !this._data.blocksMovement;
      }
      
      public function canWalkTo() : Boolean
      {
         return !this._data.blocksMovement;
      }
      
      public function set id(param1:Number) : void
      {
         throw new IllegalOperationError("Furniture id are automatically generated with EntitiesManager.getInstance().getFreeEntityId()");
      }
      
      public function get id() : Number
      {
         if(!this._id)
         {
            this._id = EntitiesManager.getInstance().getFreeEntityId();
         }
         return this._id;
      }
      
      public function get typeId() : int
      {
         return this._data.typeId;
      }
      
      public function get position() : MapPoint
      {
         return this._mp;
      }
      
      public function set position(param1:MapPoint) : void
      {
         this._mp = param1;
      }
      
      public function get elementHeight() : uint
      {
         return this.element.height * 10;
      }
      
      public function updateContentY(param1:Number = 0, param2:int = -1) : void
      {
         var _loc3_:HavenbagFurnitureSubSprite = null;
         this._offsetY = param1;
         this._content.y = -this.element.origin.y - this._offsetY - this._offsetPositionPixels.y;
         if(this.hasHorizontalSymmetry && this.cellsWidth != this.cellsHeight)
         {
            if(this._data.cellsWidth < this._data.cellsHeight)
            {
               this._content.y = this._content.y + AtouinConstants.CELL_HALF_HEIGHT;
            }
            else
            {
               this._content.y = this._content.y - AtouinConstants.CELL_HALF_HEIGHT;
            }
         }
         if(param2 > -1 && this._subSprites)
         {
            for each(_loc3_ in this._subSprites)
            {
               if(_loc3_.position.cellId == param2)
               {
                  _loc3_.y = _loc3_.y - param1;
                  return;
               }
            }
         }
      }
      
      private function onGfxLoaded(param1:ResourceLoadedEvent) : void
      {
         this._content.bitmapData = param1.resource;
         this._content.smoothing = Atouin.getInstance().options.useSmooth;
         if(this._cutOnLoaded)
         {
            this.cutGfx();
         }
         this.destroyLoader();
      }
      
      private function onGfxError(param1:ResourceErrorEvent) : void
      {
         _log.error("Failed to load GFX for furniture " + this.id);
         this._content.bitmapData = new BitmapData(this.element.size.x,this.element.size.y,false,16711935);
         this.destroyLoader();
      }
      
      private function destroyLoader() : void
      {
         if(this._gfxLoader)
         {
            this._gfxLoader.removeEventListener(ResourceLoadedEvent.LOADED,this.onGfxLoaded);
            this._gfxLoader.removeEventListener(ResourceErrorEvent.ERROR,this.onGfxError);
            this._gfxLoader = null;
         }
         if(this._onDisplayedCallback != null)
         {
            this._onDisplayedCallback();
            this._onDisplayedCallback = null;
         }
      }
      
      private function reorderSubSprites() : void
      {
         var _loc3_:MapPoint = null;
         var _loc1_:int = -1;
         var _loc2_:uint = 0;
         var _loc4_:MapPoint = this.position;
         var _loc5_:int = 0;
         while(_loc5_ < this.cellsWidth)
         {
            _loc1_++;
            _loc3_ = MapPoint.fromCoords(this.position.x + _loc5_,this.position.y);
            if(_loc2_ == this._subSprites.length)
            {
               break;
            }
            if((!!this.hasHorizontalSymmetry?this.cellsWidth + this.cellsHeight - 2 - this._subSprites[_loc2_].order:this._subSprites[_loc2_].order) == _loc1_)
            {
               this._subSprites[_loc2_].position = _loc3_;
               if(this.hasHorizontalSymmetry)
               {
                  this._subSprites[_loc2_].scaleX = -1;
               }
               else
               {
                  this._subSprites[_loc2_].scaleX = 1;
               }
               this._subSprites[_loc2_].display();
               _loc2_++;
            }
            _loc4_ = _loc3_;
            _loc5_++;
         }
         var _loc6_:int = 1;
         while(_loc6_ < this.cellsHeight)
         {
            _loc1_++;
            _loc3_ = MapPoint.fromCoords(_loc4_.x,_loc4_.y + _loc6_);
            if(_loc2_ == this._subSprites.length)
            {
               break;
            }
            if(_loc2_ < this._subSprites.length && (!!this.hasHorizontalSymmetry?this.cellsWidth + this.cellsHeight - 2 - this._subSprites[_loc2_].order:this._subSprites[_loc2_].order) == _loc1_)
            {
               this._subSprites[_loc2_].position = _loc3_;
               if(this.hasHorizontalSymmetry)
               {
                  this._subSprites[_loc2_].scaleX = -1;
                  if(this.cellsHeight != this.cellsWidth)
                  {
                     this._subSprites[_loc2_].getChildAt(0).x = this._subSprites[_loc2_].getChildAt(0).x + (this.cellsHeight < this.cellsWidth?-1:1) * AtouinConstants.CELL_HALF_WIDTH;
                     this._subSprites[_loc2_].getChildAt(0).y = this._subSprites[_loc2_].getChildAt(0).y - (this.cellsHeight < this.cellsWidth?-1:1) * AtouinConstants.CELL_HALF_HEIGHT;
                  }
               }
               else
               {
                  this._subSprites[_loc2_].scaleX = 1;
               }
               this._subSprites[_loc2_].display();
               _loc2_++;
            }
            _loc6_++;
         }
      }
      
      private function cutGfx() : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:uint = 0;
         var _loc6_:MapPoint = null;
         var _loc7_:Bitmap = null;
         var _loc8_:BitmapData = null;
         var _loc9_:HavenbagFurnitureSubSprite = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:MapPoint = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Point = null;
         var _loc16_:Point = null;
         this._cutOnLoaded = false;
         var _loc1_:int = -1;
         var _loc2_:uint = Math.floor(this.position.cellId / 14);
         var _loc3_:uint = this._orientation;
         if(this._subSprites && this._subSprites.length)
         {
            this.reorderSubSprites();
            this._content.alpha = 0;
         }
         else
         {
            if(this.hasHorizontalSymmetry)
            {
               this.orientation = 0;
            }
            _loc5_ = 0;
            _loc10_ = 0;
            _loc11_ = 0;
            _loc12_ = this.position;
            this._subSprites = new Vector.<HavenbagFurnitureSubSprite>();
            _loc13_ = 0;
            for(; _loc13_ < this._data.cellsWidth; _loc13_++)
            {
               _loc1_++;
               _loc6_ = MapPoint.fromCoords(this.position.x + _loc13_,this.position.y);
               _loc4_ = new Rectangle();
               _loc4_.x = _loc5_;
               _loc4_.y = 0;
               _loc4_.height = this._content.bitmapData.height;
               _loc7_ = new Bitmap(null,PixelSnapping.NEVER);
               if(this._data.colorTransform)
               {
                  _loc7_.transform.colorTransform = this._data.colorTransform;
               }
               if(_loc13_ == 0)
               {
                  _loc15_ = InteractiveCellManager.getInstance().getCell(_loc6_.cellId).localToGlobal(new Point(0,0));
                  _loc16_ = this._content.localToGlobal(new Point(0,0));
                  _loc4_.width = Math.floor((_loc15_.x - _loc16_.x) / Atouin.getInstance().currentZoom + AtouinConstants.CELL_HALF_WIDTH);
                  _loc7_.x = -_loc4_.width;
                  if(this.cellsWidth == 1)
                  {
                     _loc4_.width = _loc4_.width + AtouinConstants.CELL_HALF_WIDTH;
                  }
                  if(_loc4_.width <= 0)
                  {
                     _loc10_ = _loc10_ - _loc4_.width;
                     _loc11_ = _loc11_ + (AtouinConstants.CELL_WIDTH - _loc10_);
                     continue;
                  }
                  _loc11_ = _loc11_ + Math.floor(AtouinConstants.CELL_HALF_WIDTH + this._content.x);
               }
               else if(_loc13_ == this._data.cellsWidth - 1)
               {
                  _loc4_.width = AtouinConstants.CELL_WIDTH + _loc10_;
                  _loc7_.x = -_loc4_.width / 2;
               }
               else
               {
                  _loc4_.width = !!_loc10_?Number(_loc10_):Number(AtouinConstants.CELL_HALF_WIDTH);
                  _loc7_.x = -_loc4_.width;
               }
               _loc10_ = 0;
               _loc5_ = _loc5_ + _loc4_.width;
               _loc4_.width++;
               _loc8_ = new BitmapData(_loc4_.width,_loc4_.height,true,0);
               _loc8_.copyPixels(this._content.bitmapData,_loc4_,new Point());
               _loc7_.bitmapData = _loc8_;
               _loc7_.smoothing = Atouin.getInstance().options.useSmooth;
               _loc7_.x = _loc7_.x - (this.element.origin.x - AtouinConstants.CELL_HALF_WIDTH + _loc11_);
               _loc7_.y = _loc7_.y - (this.element.origin.y + _loc13_ * AtouinConstants.CELL_HALF_HEIGHT);
               _loc9_ = new HavenbagFurnitureSubSprite(_loc7_,this,_loc6_,_loc1_);
               if(!_loc3_)
               {
                  _loc9_.display();
               }
               this._subSprites.push(_loc9_);
               _loc12_ = _loc6_;
            }
            _loc14_ = 1;
            for(; _loc14_ < this._data.cellsHeight; _loc14_++)
            {
               _loc1_++;
               _loc6_ = MapPoint.fromCoords(_loc12_.x,_loc12_.y + _loc14_);
               _loc4_ = new Rectangle();
               _loc4_.x = _loc5_;
               _loc4_.y = 0;
               _loc4_.height = this._content.bitmapData.height;
               _loc7_ = new Bitmap(null,PixelSnapping.NEVER);
               if(this._data.colorTransform)
               {
                  _loc7_.transform.colorTransform = this._data.colorTransform;
               }
               if(_loc14_ == this.cellsHeight - 1)
               {
                  _loc4_.width = this._content.bitmapData.width - _loc4_.x;
                  if(_loc4_.width <= 0)
                  {
                     continue;
                  }
               }
               else
               {
                  _loc4_.width = AtouinConstants.CELL_HALF_WIDTH;
               }
               _loc5_ = _loc5_ + _loc4_.width;
               _loc4_.width++;
               _loc8_ = new BitmapData(_loc4_.width,_loc4_.height,true,0);
               _loc8_.copyPixels(this._content.bitmapData,_loc4_,new Point());
               _loc7_.bitmapData = _loc8_;
               _loc7_.smoothing = Atouin.getInstance().options.useSmooth;
               _loc7_.x = _loc7_.x - (this.element.origin.x - AtouinConstants.CELL_HALF_WIDTH + _loc11_);
               _loc7_.y = _loc7_.y - (this.element.origin.y - (_loc2_ - Math.floor(_loc6_.cellId / 14)) * AtouinConstants.CELL_HALF_HEIGHT);
               _loc9_ = new HavenbagFurnitureSubSprite(_loc7_,this,_loc6_,_loc1_);
               if(!_loc3_)
               {
                  _loc9_.display();
               }
               this._subSprites.push(_loc9_);
            }
            this._content.alpha = 0;
            if(_loc3_)
            {
               this.orientation = _loc3_;
            }
         }
      }
   }
}
