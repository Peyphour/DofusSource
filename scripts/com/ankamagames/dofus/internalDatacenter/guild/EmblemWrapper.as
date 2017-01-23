package com.ankamagames.dofus.internalDatacenter.guild
{
   import com.ankamagames.dofus.datacenter.guild.EmblemBackground;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
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
   
   public class EmblemWrapper extends Proxy implements IDataCenter, ISlotData
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EmblemWrapper));
      
      private static var _cache:Array = new Array();
      
      public static const UP:uint = 1;
      
      public static const BACK:uint = 2;
       
      
      private var _uri:Uri;
      
      private var _fullSizeUri:Uri;
      
      private var _color:uint;
      
      private var _type:uint;
      
      private var _order:int;
      
      private var _category:int;
      
      private var _forAlliance:Boolean;
      
      private var _isInit:Boolean;
      
      public var idEmblem:uint;
      
      public function EmblemWrapper()
      {
         super();
      }
      
      public static function fromNetwork(param1:GuildEmblem, param2:Boolean, param3:Boolean = false) : EmblemWrapper
      {
         var _loc4_:EmblemWrapper = new EmblemWrapper();
         _loc4_._forAlliance = param3;
         if(param2)
         {
            _loc4_.idEmblem = param1.backgroundShape;
            _loc4_._color = param1.backgroundColor;
            _loc4_._type = BACK;
         }
         else
         {
            _loc4_.idEmblem = param1.symbolShape;
            _loc4_._color = param1.symbolColor;
            _loc4_._type = UP;
         }
         return _loc4_;
      }
      
      public static function create(param1:uint, param2:uint, param3:uint = 0, param4:Boolean = false, param5:Boolean = false) : EmblemWrapper
      {
         var _loc6_:EmblemWrapper = null;
         if(!_cache[param1] || !param5)
         {
            _loc6_ = new EmblemWrapper();
            _loc6_.idEmblem = param1;
            if(param5)
            {
               _cache[param1] = _loc6_;
            }
         }
         else
         {
            _loc6_ = _cache[param1];
         }
         _loc6_._type = param2;
         _loc6_._color = param3;
         _loc6_._forAlliance = param4;
         _loc6_._isInit = false;
         return _loc6_;
      }
      
      public static function getEmblemFromId(param1:uint) : EmblemWrapper
      {
         return _cache[param1];
      }
      
      public function get category() : int
      {
         this.init();
         return this._category;
      }
      
      public function get order() : int
      {
         this.init();
         return this._order;
      }
      
      public function get iconUri() : Uri
      {
         this.init();
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         this.init();
         return this._fullSizeUri;
      }
      
      public function get backGroundIconUri() : Uri
      {
         return new Uri(XmlConfig.getInstance().getEntry("config.ui.skin").concat("texture/slot/emptySlot.png"));
      }
      
      public function set backGroundIconUri(param1:Uri) : void
      {
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
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get errorIconUri() : Uri
      {
         return null;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         if(isAttribute(param1))
         {
            return this[param1];
         }
         return "Error on emblem " + param1;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return isAttribute(param1);
      }
      
      public function update(param1:uint, param2:uint, param3:uint = 0) : void
      {
         this.idEmblem = param1;
         this._type = param2;
         this._color = param3;
         this._isInit = false;
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
      }
      
      private function init() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:EmblemSymbol = null;
         var _loc5_:EmblemBackground = null;
         if(this._isInit)
         {
            return;
         }
         switch(this._type)
         {
            case UP:
               _loc4_ = EmblemSymbol.getEmblemSymbolById(this.idEmblem);
               _loc3_ = _loc4_.iconId;
               this._order = _loc4_.order;
               this._category = _loc4_.categoryId;
               _loc1_ = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.small") + "up/";
               _loc2_ = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.large") + "up/";
               break;
            case BACK:
               _loc5_ = EmblemBackground.getEmblemBackgroundById(this.idEmblem);
               this._order = _loc5_.order;
               _loc3_ = this.idEmblem;
               if(this._forAlliance)
               {
                  _loc1_ = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.small") + "backalliance/";
                  _loc2_ = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.large") + "backalliance/";
               }
               else
               {
                  _loc1_ = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.small") + "back/";
                  _loc2_ = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.large") + "back/";
               }
         }
         this._uri = new Uri(_loc1_ + _loc3_ + ".png");
         this._fullSizeUri = new Uri(_loc2_ + _loc3_ + ".swf");
         this._isInit = true;
      }
   }
}
