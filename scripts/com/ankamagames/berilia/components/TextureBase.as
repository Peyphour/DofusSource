package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.resources.ResourceType;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   
   public class TextureBase extends GraphicContainer
   {
      
      protected static var _bitmapCache:Dictionary = new Dictionary(true);
      
      protected static var _totalBitmapInCache:uint = 0;
      
      protected static var _textureReference:Dictionary = new Dictionary(true);
      
      protected static var _userColors:Array;
      
      protected static const NULL_COLOR:ColorTransform = new ColorTransform();
      
      private static var _init:Boolean;
       
      
      protected var _autoCenterBitmap:Boolean;
      
      protected var _smooth:Boolean = false;
      
      protected var _showLoadingError:Boolean = true;
      
      protected var _uri:Uri;
      
      protected var _useCache:Boolean = true;
      
      protected var _useCacheTmp:Boolean;
      
      public function TextureBase()
      {
         this._useCacheTmp = this._useCache;
         super();
         _textureReference[this] = true;
      }
      
      public static function getBitmapCache() : Dictionary
      {
         return _bitmapCache;
      }
      
      public static function clearCache() : void
      {
         var _loc1_:BitmapData = null;
         for each(_loc1_ in _bitmapCache)
         {
            _loc1_.dispose();
         }
         _bitmapCache = new Dictionary(true);
         _totalBitmapInCache = 0;
      }
      
      private static function addBitmapToCache(param1:String, param2:BitmapData) : void
      {
         if(param1)
         {
            if(!_bitmapCache[param1])
            {
               _bitmapCache[param1] = param2;
               _totalBitmapInCache++;
            }
         }
      }
      
      private static function initUserColor() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:UserColor = null;
         if(_init)
         {
            return;
         }
         _init = true;
         var _loc1_:Array = StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_UI_CSS,"userUiColor");
         if(_loc1_)
         {
            _userColors = new Array();
            _loc2_ = _loc1_.length - 1;
            while(_loc2_ > -1)
            {
               _loc3_ = _loc1_[_loc2_];
               _loc4_ = new UserColor();
               _loc4_.filter = _loc3_.filter;
               _loc4_.exclude = _loc3_.exclude;
               _loc4_.colorTransform = new ColorTransform(_loc3_.redMultiplier,_loc3_.greenMultiplier,_loc3_.blueMultiplier,1,_loc3_.redOffset,_loc3_.greenOffset,_loc3_.blueOffset);
               _userColors.push(_loc4_);
               _loc2_--;
            }
         }
      }
      
      public static function colorize(param1:String, param2:ColorTransform) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = null;
         var _loc3_:* = param1.charAt(0) == "-";
         addUserColor(param1.substr(!!_loc3_?Number(1):Number(0)),param2,_loc3_);
         for(_loc5_ in _textureReference)
         {
            if(_loc5_ && _loc5_.uri && _loc5_.uri.fileType != "swf")
            {
               _loc5_.transform.colorTransform = getUserColor(_loc5_.uri.path);
            }
         }
      }
      
      public static function getUserColorList() : Array
      {
         var _loc2_:UserColor = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in _userColors)
         {
            _loc1_.push([_loc2_.filter,_loc2_.exclude,!!_loc2_.colorTransform?_loc2_.colorTransform.redMultiplier + " " + _loc2_.colorTransform.greenMultiplier + " " + _loc2_.colorTransform.blueMultiplier + " " + _loc2_.colorTransform.redOffset + " " + _loc2_.colorTransform.greenOffset + " " + _loc2_.colorTransform.blueOffset:""]);
         }
         return _loc1_;
      }
      
      public static function resetColor() : void
      {
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_CSS,"userUiColor",null);
      }
      
      public static function saveColor() : void
      {
         var _loc2_:UserColor = null;
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         var _loc5_:ColorTransform = null;
         var _loc6_:BitmapData = null;
         var _loc7_:* = null;
         var _loc1_:Array = [];
         for each(_loc2_ in _userColors)
         {
            _loc1_.push({
               "filter":_loc2_.filter,
               "exclude":_loc2_.exclude,
               "redMultiplier":_loc2_.colorTransform.redMultiplier,
               "greenMultiplier":_loc2_.colorTransform.greenMultiplier,
               "blueMultiplier":_loc2_.colorTransform.blueMultiplier,
               "redOffset":_loc2_.colorTransform.redOffset,
               "greenOffset":_loc2_.colorTransform.greenOffset,
               "blueOffset":_loc2_.colorTransform.blueOffset
            });
         }
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_CSS,"userUiColor",_loc1_,true);
         for(_loc3_ in _bitmapCache)
         {
            _loc5_ = getUserColor(_loc3_);
            if(_loc5_ && _loc5_ != NULL_COLOR)
            {
               _loc6_ = _bitmapCache[_loc3_];
               _loc6_.colorTransform(_loc6_.rect,_loc5_);
            }
         }
         for(_loc7_ in _textureReference)
         {
            if(_loc7_ && _loc7_.uri && _loc7_ is TextureBitmap)
            {
               _loc7_.transform.colorTransform = NULL_COLOR;
            }
         }
      }
      
      protected static function applyUserColor(param1:String, param2:*) : void
      {
         var _loc3_:ColorTransform = getUserColor(param1);
         if(_loc3_ && _loc3_ != NULL_COLOR)
         {
            if(param2 is BitmapData)
            {
               BitmapData(param2).colorTransform(param2.rect,_loc3_);
            }
            else if(param2 is DisplayObject)
            {
               DisplayObject(param2).transform.colorTransform = _loc3_;
            }
         }
      }
      
      private static function addUserColor(param1:String, param2:ColorTransform, param3:Boolean = false) : void
      {
         var uc:UserColor = null;
         var i:* = undefined;
         var filter:String = param1;
         var ct:ColorTransform = param2;
         var exclude:Boolean = param3;
         if(!_userColors)
         {
            _userColors = new Array();
         }
         for(i in _userColors)
         {
            uc = _userColors[i];
            if(uc.filter == filter)
            {
               uc.colorTransform = !!ct?ct:NULL_COLOR;
               uc.exclude = exclude;
               if(!exclude && ct == NULL_COLOR || ct == null)
               {
                  delete _userColors[i];
                  break;
               }
               return;
            }
         }
         uc = new UserColor();
         uc.filter = filter;
         uc.colorTransform = ct;
         uc.exclude = exclude;
         _userColors.push(uc);
         _userColors.sort(function(param1:UserColor, param2:UserColor):int
         {
            if(param1.filter.length > param2.filter.length)
            {
               return 1;
            }
            if(param1.filter.length < param2.filter.length)
            {
               return -1;
            }
            return 0;
         });
      }
      
      private static function getUserColor(param1:String) : ColorTransform
      {
         var _loc2_:UserColor = null;
         if(_userColors && param1)
         {
            for each(_loc2_ in _userColors)
            {
               if(param1.indexOf(_loc2_.filter) != -1 || _loc2_.filter == "*")
               {
                  if(_loc2_.exclude)
                  {
                     return NULL_COLOR;
                  }
                  return _loc2_.colorTransform;
               }
            }
         }
         return NULL_COLOR;
      }
      
      override public function remove() : void
      {
         super.remove();
      }
      
      public function get useCache() : Boolean
      {
         return this._useCache;
      }
      
      public function set useCache(param1:Boolean) : void
      {
         this._useCache = param1;
         this._useCacheTmp = param1;
      }
      
      public function get showLoadingError() : Boolean
      {
         return this._showLoadingError;
      }
      
      public function set showLoadingError(param1:Boolean) : void
      {
         this._showLoadingError = param1;
      }
      
      public function get autoCenterBitmap() : Boolean
      {
         return this._autoCenterBitmap;
      }
      
      public function set autoCenterBitmap(param1:Boolean) : void
      {
         this._autoCenterBitmap = param1;
      }
      
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         this._smooth = param1;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function set uri(param1:Uri) : void
      {
      }
      
      protected function getBitmapDataFromCache(param1:String) : BitmapData
      {
         if(this._useCache && param1 && _bitmapCache[param1])
         {
            return _bitmapCache[param1];
         }
         return null;
      }
      
      public function loadBitmapData(param1:BitmapData) : void
      {
      }
      
      protected function onLoaded(param1:ResourceLoadedEvent) : void
      {
         if(this._useCache && param1.resourceType == ResourceType.RESOURCE_BITMAP)
         {
            addBitmapToCache(param1.uri.path,param1.resource);
         }
      }
      
      protected function onFailed(param1:ResourceErrorEvent) : void
      {
      }
   }
}

import flash.geom.ColorTransform;

class UserColor
{
    
   
   public var exclude:Boolean = false;
   
   public var filter:String;
   
   public var colorTransform:ColorTransform;
   
   function UserColor()
   {
      super();
   }
}
