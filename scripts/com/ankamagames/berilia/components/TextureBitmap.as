package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.messages.TextureLoadFailMessage;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.Margin;
   import com.ankamagames.berilia.types.event.TextureLoadFailedEvent;
   import com.ankamagames.berilia.types.graphic.GraphicLocation;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.DynamicSecureObject;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class TextureBitmap extends TextureBase implements FinalizableUIComponent
   {
      
      private static const RENDER_MODE_FIT:uint = 0;
      
      private static const RENDER_MODE_SCALE9:uint = 1;
      
      private static const RENDER_MODE_CROP:uint = 2;
      
      private static const RENDER_MODE_TILE:uint = 3;
      
      private static const RENDER_MODE_DYNAMIC:uint = 4;
       
      
      private var _bitmapData:BitmapData;
      
      private var _align:String;
      
      private var _autoFit:Boolean = false;
      
      private var _scale9Grid:Rectangle;
      
      private var _margin:Margin;
      
      private var _loader:IResourceLoader;
      
      private var _fillMatrix:Matrix;
      
      private var _dynamicRender:Boolean = false;
      
      private var _tileRender:Boolean = false;
      
      private var _renderMode:uint = 0;
      
      public function TextureBitmap()
      {
         this._margin = new Margin();
         this._fillMatrix = new Matrix();
         super();
      }
      
      override public function set useCache(param1:Boolean) : void
      {
         super.useCache = param1;
      }
      
      override public function set shadowColor(param1:int) : void
      {
      }
      
      public function get dynamicRender() : Boolean
      {
         return this._dynamicRender;
      }
      
      public function set dynamicRender(param1:Boolean) : void
      {
         this._dynamicRender = param1;
         this.invalidate();
      }
      
      public function get tileRender() : Boolean
      {
         return this._tileRender;
      }
      
      public function set tileRender(param1:Boolean) : void
      {
         this._tileRender = param1;
         this.invalidate();
      }
      
      public function get margin() : Margin
      {
         return this._margin;
      }
      
      public function set margin(param1:Margin) : void
      {
         this._margin = param1;
         this.invalidate();
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this.invalidate();
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         this.invalidate();
      }
      
      override public function set uri(param1:Uri) : void
      {
         super.uri = param1;
         if(_uri == param1 || param1 && param1.path == "null" || _uri && param1 && _uri.path == param1.path && _uri.subPath == param1.subPath)
         {
            return;
         }
         _uri = param1;
         if(_uri == null)
         {
            this._bitmapData = null;
            this.invalidate();
            return;
         }
         _finalized = false;
         this._bitmapData = getBitmapDataFromCache(_uri.path);
         if(!this._bitmapData)
         {
            if(!this._loader)
            {
               this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
               this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoaded);
               this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onFailed);
            }
            else
            {
               this._loader.cancel();
            }
            this._loader.load(_uri);
         }
         else
         {
            this.destroyLoader();
            this.finalize();
         }
      }
      
      public function set align(param1:String) : void
      {
         if(param1 == this._align)
         {
            return;
         }
         var _loc2_:Array = [null,"TOPLEFT","TOP","TOPRIGHT","LEFT","CENTER","RIGHT","BOTTOMLEFT","BOTTOM","BOTTOMRIGHT"];
         if(_loc2_.indexOf(param1.toUpperCase()) == -1)
         {
            _log.warn("[" + param1 + "] is not a valid align value, please use one of those : " + _loc2_.join(","));
            return;
         }
         this._align = param1;
         this.invalidate();
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      override public function get scale9Grid() : Rectangle
      {
         return this._scale9Grid;
      }
      
      override public function set scale9Grid(param1:Rectangle) : void
      {
         this._scale9Grid = param1;
         this.invalidate();
      }
      
      override public function set smooth(param1:Boolean) : void
      {
         super.smooth = param1;
         this.invalidate();
      }
      
      public function invalidate() : void
      {
         if(_finalized)
         {
            this.finalize();
         }
      }
      
      override public function finalize() : void
      {
         graphics.clear();
         if(this._bitmapData)
         {
            this._fillMatrix.identity();
            this.updateRenderMode();
            switch(this._renderMode)
            {
               case RENDER_MODE_SCALE9:
                  this.drawScale9();
                  break;
               case RENDER_MODE_CROP:
                  this.drawCrop();
                  break;
               case RENDER_MODE_FIT:
                  this.drawFit();
                  break;
               case RENDER_MODE_DYNAMIC:
                  this.drawDynamic();
                  break;
               case RENDER_MODE_TILE:
                  this.drawTile();
            }
         }
         super.finalize();
         if(getUi())
         {
            getUi().iAmFinalized(this);
         }
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      override public function remove() : void
      {
         super.remove();
         this.destroyLoader();
         graphics.clear();
         this._bitmapData = null;
         _uri = null;
      }
      
      override public function loadBitmapData(param1:BitmapData) : void
      {
         this._bitmapData = param1;
         this.finalize();
      }
      
      private function drawDynamic() : void
      {
         var _loc1_:Point = localToGlobal(new Point(x,y));
         var _loc2_:Matrix = new Matrix();
         _loc2_.translate(-_loc1_.x,-_loc1_.y);
         if(_autoCenterBitmap)
         {
            _loc2_.translate(-width / 2,-height / 2);
         }
         graphics.clear();
         graphics.beginBitmapFill(this._bitmapData,_loc2_,true,_smooth);
         if(_autoCenterBitmap)
         {
            graphics.drawRect(-width / 2,-height / 2,width,height);
         }
         else
         {
            graphics.drawRect(0,0,width,height);
         }
         graphics.endFill();
      }
      
      private function drawTile() : void
      {
         graphics.clear();
         graphics.beginBitmapFill(this._bitmapData,null,true,_smooth);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
      }
      
      private function drawScale9() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(this.width < this._bitmapData.width)
         {
            this.drawFit();
            return;
         }
         var _loc1_:uint = Math.abs(!!this.width?Number(this.width):Number(this._bitmapData.width));
         var _loc2_:uint = Math.abs(!!this.height?Number(this.height):Number(this._bitmapData.height));
         var _loc5_:Number = 0;
         var _loc7_:Number = 0;
         var _loc13_:int = this._bitmapData.width;
         var _loc14_:int = this._bitmapData.height;
         var _loc15_:Rectangle = this.scale9Grid && !this.scale9Grid.isEmpty()?this.scale9Grid:new Rectangle(Math.floor(this._bitmapData.width / 3 - 1),Math.floor(this._bitmapData.height / 3 - 1),3,3);
         var _loc16_:Array = [_loc15_.left + 1,_loc15_.width - 2,_loc13_ - _loc15_.right + 1];
         var _loc17_:Array = [_loc15_.top + 1,_loc15_.height - 2,_loc14_ - _loc15_.bottom + 1];
         var _loc18_:Number = _loc1_ - _loc16_[0] - _loc16_[2] - this._margin.right - this._margin.left;
         var _loc19_:Number = _loc2_ - _loc17_[0] - _loc17_[2] - this._margin.bottom - this._margin.top;
         var _loc20_:Number = this._margin.left;
         var _loc21_:Number = this._margin.top;
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc9_ = _loc16_[_loc3_];
            _loc11_ = _loc3_ == 1?Number(_loc18_):Number(_loc9_);
            _loc8_ = _loc6_ = 0;
            this._fillMatrix.a = _loc11_ / _loc9_;
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc10_ = _loc17_[_loc4_];
               _loc12_ = _loc4_ == 1?Number(_loc19_):Number(_loc10_);
               if(_loc11_ > 0 && _loc12_ > 0)
               {
                  this._fillMatrix.d = _loc12_ / _loc10_;
                  this._fillMatrix.tx = -_loc5_ * this._fillMatrix.a + _loc7_;
                  this._fillMatrix.ty = -_loc6_ * this._fillMatrix.d + _loc8_;
                  this._fillMatrix.translate(_loc20_,_loc21_);
                  graphics.beginBitmapFill(this._bitmapData,this._fillMatrix,false,_smooth);
                  graphics.drawRect(_loc7_ + _loc20_,_loc8_ + _loc21_,_loc11_,_loc12_);
               }
               _loc6_ = _loc6_ + _loc10_;
               _loc8_ = _loc8_ + _loc12_;
               _loc4_++;
            }
            _loc5_ = _loc5_ + _loc9_;
            _loc7_ = _loc7_ + _loc11_;
            _loc3_++;
         }
         graphics.endFill();
      }
      
      private function drawCrop() : void
      {
         var _loc1_:uint = !!this.width?uint(this.width):uint(this._bitmapData.width);
         var _loc2_:uint = !!this.height?uint(this.height):uint(this._bitmapData.height);
         switch(GraphicLocation.convertPointStringToInt(this._align.toUpperCase()))
         {
            case LocationEnum.POINT_TOPLEFT:
               break;
            case LocationEnum.POINT_TOP:
               this._fillMatrix.translate((_loc1_ - this._bitmapData.width) / 2,0);
               break;
            case LocationEnum.POINT_TOPRIGHT:
               this._fillMatrix.translate(_loc1_ - this._bitmapData.width,0);
               break;
            case LocationEnum.POINT_LEFT:
               this._fillMatrix.translate(0,(_loc2_ - this._bitmapData.height) / 2);
               break;
            case LocationEnum.POINT_CENTER:
               this._fillMatrix.translate((_loc1_ - this._bitmapData.width) / 2,(_loc2_ - this._bitmapData.height) / 2);
               break;
            case LocationEnum.POINT_RIGHT:
               this._fillMatrix.translate(_loc1_ - this._bitmapData.width,(_loc2_ - this._bitmapData.height) / 2);
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
               this._fillMatrix.translate(0,_loc2_ - this._bitmapData.height);
               break;
            case LocationEnum.POINT_BOTTOM:
               this._fillMatrix.translate((_loc1_ - this._bitmapData.width) / 2,_loc2_ - this._bitmapData.height);
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
               this._fillMatrix.translate(_loc1_ - this._bitmapData.width,_loc2_ - this._bitmapData.height);
         }
         this._fillMatrix.translate(this._margin.left,this._margin.top);
         graphics.beginBitmapFill(this._bitmapData,this._fillMatrix,false,_smooth);
         graphics.drawRect(this._margin.left,this._margin.top,_loc1_ - this._margin.left - this._margin.right,_loc2_ - this._margin.top - this._margin.bottom);
         graphics.endFill();
      }
      
      private function drawFit() : void
      {
         var _loc1_:int = !!this.width?int(this.width):int(this._bitmapData.width);
         var _loc2_:int = !!this.height?int(this.height):int(this._bitmapData.height);
         var _loc3_:int = Math.abs(_loc1_);
         var _loc4_:int = Math.abs(_loc2_);
         var _loc5_:Number = _loc3_ / (this._bitmapData.width - this._margin.left - this._margin.right);
         var _loc6_:Number = _loc4_ / (this._bitmapData.height - this._margin.top - this._margin.bottom);
         this._fillMatrix.scale(_loc5_,_loc6_);
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(_loc1_ < 0)
         {
            _loc7_ = _loc1_;
         }
         if(_loc2_ < 0)
         {
            _loc8_ = _loc2_;
         }
         this._fillMatrix.translate(-this._margin.left * _loc5_ + _loc7_,-this.margin.top * _loc6_ + _loc8_);
         if(_autoCenterBitmap)
         {
            this._fillMatrix.translate(-_loc3_ / 2,-_loc4_ / 2);
         }
         graphics.beginBitmapFill(this._bitmapData,this._fillMatrix,false,_smooth);
         if(_autoCenterBitmap)
         {
            graphics.drawRect(_loc7_ - _loc3_ / 2,_loc8_ - _loc4_ / 2,_loc3_,_loc4_);
         }
         else
         {
            graphics.drawRect(_loc7_,_loc8_,_loc3_,_loc4_);
         }
         graphics.endFill();
      }
      
      private function destroyLoader() : void
      {
         if(!this._loader)
         {
            return;
         }
         this._loader.cancel();
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onLoaded);
         this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onFailed);
         this._loader = null;
      }
      
      private function updateRenderMode() : void
      {
         this._renderMode = RENDER_MODE_FIT;
         if(this._scale9Grid)
         {
            this._renderMode = RENDER_MODE_SCALE9;
         }
         if(this._align)
         {
            this._renderMode = RENDER_MODE_CROP;
         }
         if(this._dynamicRender)
         {
            this._renderMode = RENDER_MODE_DYNAMIC;
         }
         if(this._tileRender)
         {
            this._renderMode = RENDER_MODE_TILE;
         }
      }
      
      function drawErrorTexture() : void
      {
         graphics.beginFill(16711935);
         graphics.drawRect(0,0,width != 0?Number(width):Number(10),height != 0?Number(height):Number(10));
         graphics.endFill();
      }
      
      override protected function onLoaded(param1:ResourceLoadedEvent) : void
      {
         super.onLoaded(param1);
         if(param1.resource is BitmapData)
         {
            this._bitmapData = param1.resource;
         }
         else
         {
            _log.error("Failed to load " + param1.uri + ", resource type not supported! (component name : " + name + ")");
         }
         this.destroyLoader();
         this.finalize();
      }
      
      override protected function onFailed(param1:ResourceErrorEvent) : void
      {
         this.destroyLoader();
         this.finalize();
         if(_showLoadingError)
         {
            this.drawErrorTexture();
         }
         var _loc2_:DynamicSecureObject = new DynamicSecureObject();
         _loc2_.cancel = false;
         if(KernelEventsManager.getInstance().isRegisteredEvent(BeriliaHookList.TextureLoadFailed.name))
         {
            _finalized = true;
            KernelEventsManager.getInstance().processCallback(BeriliaHookList.TextureLoadFailed,this,_loc2_);
         }
         else
         {
            _log.error("UI " + (!!getUi()?getUi().name:"unknow") + "/" + name + ", TextureBitmap resource not found: " + (!!param1?param1.errorMsg:"No ressource specified.") + ", requested uri : " + param1.uri);
         }
         this.drawErrorTexture();
         dispatchEvent(new TextureLoadFailedEvent(this,_loc2_));
         Berilia.getInstance().handler.process(new TextureLoadFailMessage(this));
      }
   }
}
