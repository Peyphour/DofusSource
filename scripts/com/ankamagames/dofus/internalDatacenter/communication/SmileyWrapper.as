package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   
   public class SmileyWrapper extends Proxy implements IDataCenter, ISlotData
   {
      
      private static var _cache:Array = new Array();
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SmileyWrapper));
       
      
      private var _uri:Uri;
      
      public var id:uint = 0;
      
      public var iconId:String;
      
      public var packId:int;
      
      public var categoryId:int;
      
      public var isOkForMultiUse:Boolean = false;
      
      public var quantity:uint = 1;
      
      public function SmileyWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:int, param4:int, param5:Boolean = true) : SmileyWrapper
      {
         var _loc6_:SmileyWrapper = null;
         if(!_cache[param1] || !param5)
         {
            _loc6_ = new SmileyWrapper();
            _loc6_.id = param1;
            if(param5)
            {
               _cache[param1] = _loc6_;
            }
         }
         else
         {
            _loc6_ = _cache[param1];
         }
         _loc6_.iconId = param2;
         _loc6_.packId = param3;
         _loc6_.categoryId = param4;
         return _loc6_;
      }
      
      public static function getSmileyWrapperById(param1:uint) : SmileyWrapper
      {
         return _cache[param1];
      }
      
      public function get iconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path") + "gfx/smilies/assets.swf|" + this.iconId);
         }
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path") + "gfx/smilies/assets.swf|" + this.iconId);
         }
         return this._uri;
      }
      
      public function get backGroundIconUri() : Uri
      {
         return null;
      }
      
      public function get errorIconUri() : Uri
      {
         return null;
      }
      
      public function get info1() : String
      {
         return null;
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function set endTime(param1:int) : void
      {
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get currentCooldown() : uint
      {
         return 0;
      }
      
      public function get isUsable() : Boolean
      {
         return true;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         if(isAttribute(param1))
         {
            return this[param1];
         }
         return "Error on smiley " + param1;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return isAttribute(param1);
      }
      
      public function toString() : String
      {
         return "[SmileyWrapper#" + this.id + "]";
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function getIconUri(param1:Boolean = true) : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path") + "gfx/smilies/assets.swf|" + this.iconId);
         }
         return this._uri;
      }
   }
}
