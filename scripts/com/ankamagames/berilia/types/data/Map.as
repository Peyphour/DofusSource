package com.ankamagames.berilia.types.data
{
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.impl.ParallelRessourceLoader;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Rectangle;
   
   public class Map
   {
      
      private static var _cache:ICache;
       
      
      public var currentScale:Number;
      
      public var initialWidth:uint;
      
      public var initialHeight:uint;
      
      public var chunckWidth:uint;
      
      public var chunckHeight:uint;
      
      public var zoom:Number;
      
      private var _areas:Vector.<MapArea>;
      
      public var container:DisplayObjectContainer;
      
      public var numXChunck:uint;
      
      public var numYChunck:uint;
      
      private var _visibleAreas:Vector.<MapArea>;
      
      private var _loader:ParallelRessourceLoader;
      
      public function Map(param1:Number, param2:String, param3:DisplayObjectContainer, param4:uint, param5:uint, param6:uint, param7:uint)
      {
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         super();
         if(!_cache)
         {
            _loc13_ = XmlConfig.getInstance().getEntry("config.gfx.path.maps");
            _cache = UriCacheFactory.init(_loc13_,new Cache(50,new LruGarbageCollector()));
         }
         this.zoom = param1;
         this.container = param3;
         this.initialHeight = param5;
         this.initialWidth = param4;
         this.chunckHeight = param7;
         this.chunckWidth = param6;
         this._visibleAreas = new Vector.<MapArea>();
         this._loader = new ParallelRessourceLoader(6);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
         param3.doubleClickEnabled = true;
         this.numXChunck = Math.ceil(param4 * param1 / param6);
         this.numYChunck = Math.ceil(param5 * param1 / param7);
         this._areas = new Vector.<MapArea>(this.numXChunck * this.numYChunck,true);
         var _loc8_:uint = 1;
         _loc10_ = 0;
         while(_loc10_ < this.numYChunck)
         {
            _loc9_ = 0;
            while(_loc9_ < this.numXChunck)
            {
               _loc11_ = param6 / param1;
               _loc12_ = param7 / param1;
               this.areas[_loc8_ - 1] = new MapArea(param2 + _loc8_ + ".jpg",_loc9_ * _loc11_,_loc10_ * _loc12_,_loc11_,_loc12_,this);
               _loc8_++;
               _loc9_++;
            }
            _loc10_++;
         }
      }
      
      public function get areas() : Vector.<MapArea>
      {
         return this._areas;
      }
      
      public function loadAreas(param1:Rectangle) : Vector.<MapArea>
      {
         var _loc2_:MapArea = null;
         this._visibleAreas.length = 0;
         var _loc3_:Array = new Array();
         for each(_loc2_ in this._areas)
         {
            if(param1.intersects(_loc2_))
            {
               if(!_loc2_.isUsed)
               {
                  this.container.addChild(_loc2_.getBitmap());
                  _loc3_.push(_loc2_.src);
               }
               this._visibleAreas.push(_loc2_);
            }
            else if(_loc2_.isUsed)
            {
               _loc2_.free();
            }
         }
         if(_loc3_.length > 0)
         {
            this._loader.load(_loc3_,_cache,null,true);
         }
         return this._visibleAreas;
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:MapArea = null;
         for each(_loc2_ in this._visibleAreas)
         {
            if(param1.uri == _loc2_.src)
            {
               _loc2_.setBitmap(param1.resource);
               break;
            }
         }
      }
   }
}
