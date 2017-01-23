package com.ankamagames.jerakine.managers
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.FontActiveTypeChangeMessage;
   import com.ankamagames.jerakine.messages.LangAllFilesLoadedMessage;
   import com.ankamagames.jerakine.messages.LangFileLoadedMessage;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.UserFont;
   import com.ankamagames.jerakine.utils.errors.FileTypeError;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FontManager extends EventDispatcher
   {
      
      public static const DEFAULT_FONT_TYPE:String = "default";
      
      private static var _self:FontManager;
      
      public static var initialized:Boolean = false;
       
      
      private var _log:Logger;
      
      private var _handler:MessageHandler;
      
      private var _loader:IResourceLoader;
      
      private var _data:XML;
      
      private var _lang:String;
      
      private var _activeType:String = "default";
      
      private var _fonts:Dictionary;
      
      public function FontManager()
      {
         this._log = Log.getLogger(getQualifiedClassName(FontManager));
         super();
         if(_self != null)
         {
            throw new SingletonError("FontManager is a singleton and should not be instanciated directly.");
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onFileLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
      }
      
      public static function getInstance() : FontManager
      {
         if(_self == null)
         {
            _self = new FontManager();
         }
         return _self;
      }
      
      public function get activeType() : String
      {
         return this._activeType;
      }
      
      public function set activeType(param1:String) : void
      {
         if(this._activeType != param1)
         {
            this._activeType = param1;
            dispatchEvent(new Event(Event.CHANGE));
            this._handler.process(new FontActiveTypeChangeMessage());
         }
      }
      
      public function set handler(param1:MessageHandler) : void
      {
         this._handler = param1;
      }
      
      public function loadFile(param1:String) : void
      {
         var _loc2_:String = FileUtils.getExtension(param1);
         this._lang = LangManager.getInstance().getEntry("config.lang.current");
         if(_loc2_ == null)
         {
            throw new FileTypeError(param1 + " have no type (no extension found).");
         }
         var _loc3_:Uri = new Uri(param1);
         _loc3_.tag = param1;
         this._loader.load(_loc3_);
      }
      
      public function getFontUrlList() : Array
      {
         var _loc3_:Dictionary = null;
         var _loc4_:UserFont = null;
         var _loc1_:Dictionary = new Dictionary();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._fonts)
         {
            for each(_loc4_ in _loc3_)
            {
               if(!_loc1_[_loc4_.url])
               {
                  _loc2_.push(_loc4_.url);
                  _loc1_[_loc4_.url] = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function getFontInfo(param1:String, param2:Boolean = false) : UserFont
      {
         if(!this._fonts[param1])
         {
            return null;
         }
         if(!param2 && this._fonts[param1][this._activeType])
         {
            return this._fonts[param1][this._activeType];
         }
         return this._fonts[param1][DEFAULT_FONT_TYPE];
      }
      
      private function onFileLoaded(param1:ResourceLoadedEvent) : void
      {
         var xml:XMLList = null;
         var length:int = 0;
         var i:int = 0;
         var name:String = null;
         var entry:* = undefined;
         var f:UserFont = null;
         var e:ResourceLoadedEvent = param1;
         this._data = new XML(e.resource);
         this._fonts = new Dictionary();
         xml = this._data.Fonts.(@lang == _lang);
         if(xml.length() == 0)
         {
            xml = this._data.Fonts.(@lang == "");
         }
         length = xml.font.length();
         i = 0;
         while(i < length)
         {
            name = xml.font[i].@name;
            this._fonts[name] = new Dictionary();
            for each(entry in xml.font[i]..entry)
            {
               f = new UserFont(entry.@realName.toString(),entry.@className.toString(),parseFloat(entry.@sizeMultiplicator.toString()),LangManager.getInstance().replaceKey(entry.@file.toString()),entry.@embedAsCff.toString() == "true",parseInt(entry.@maxSize.toString()),parseInt(entry.@sharpness.toString()),parseFloat(entry.@verticalOffset.toString()),parseFloat(entry.@letterSpacing.toString()));
               this._fonts[name][!!entry.hasOwnProperty("@type")?entry.@type.toString():DEFAULT_FONT_TYPE] = f;
            }
            i++;
         }
         if(this._handler)
         {
            this._handler.process(new LangFileLoadedMessage(e.uri.uri,true,e.uri.uri));
            this._handler.process(new LangAllFilesLoadedMessage(e.uri.uri,true));
         }
         initialized = true;
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         this._handler.process(new LangFileLoadedMessage(param1.uri.uri,false,param1.uri.uri));
         this._log.warn("can\'t load " + param1.uri.uri);
      }
   }
}
