package com.ankamagames.dofus.internalDatacenter.userInterface
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
   
   public class ButtonWrapper extends Proxy implements IDataCenter, ISlotData
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ButtonWrapper));
       
      
      private var _uri:Uri;
      
      private var _active:Boolean = true;
      
      public var position:uint;
      
      public var id:uint = 0;
      
      public var uriName:String;
      
      public var callback:Function;
      
      public var name:String;
      
      public var shortcut:String;
      
      public var description:String;
      
      public function ButtonWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:int, param3:String, param4:Function, param5:String, param6:String = "", param7:String = "") : ButtonWrapper
      {
         var _loc8_:ButtonWrapper = new ButtonWrapper();
         _loc8_.id = param1;
         _loc8_.position = param2;
         _loc8_.callback = param4;
         _loc8_.uriName = param3;
         _loc8_.name = param5;
         _loc8_.shortcut = param6;
         _loc8_.description = param7;
         return _loc8_;
      }
      
      public static function getButtonWrapperById(param1:uint) : ButtonWrapper
      {
         return null;
      }
      
      public function get iconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin").concat("assets.swf|").concat(this.uriName));
         }
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin").concat("assets.swf|").concat(this.uriName));
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
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         if(isAttribute(param1))
         {
            return this[param1];
         }
         return "Error_on_buttonWrapper_" + param1;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return isAttribute(param1);
      }
      
      public function toString() : String
      {
         return "[ButtonWrapper#" + this.id + "]";
      }
      
      public function setPosition(param1:int) : void
      {
         this.position = param1;
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function getIconUri(param1:Boolean = true) : Uri
      {
         return this.iconUri;
      }
   }
}
