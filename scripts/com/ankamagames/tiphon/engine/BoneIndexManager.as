package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class BoneIndexManager extends EventDispatcher
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(BoneIndexManager));
      
      private static var _self:BoneIndexManager;
       
      
      private var _loader:IResourceLoader;
      
      private var _index:Dictionary;
      
      private var _transitions:Dictionary;
      
      private var _animNameModifier:Function;
      
      public function BoneIndexManager()
      {
         this._index = new Dictionary();
         this._transitions = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : BoneIndexManager
      {
         if(!_self)
         {
            _self = new BoneIndexManager();
         }
         return _self;
      }
      
      public function init(param1:String) : void
      {
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onXmlLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onXmlFailed);
         this._loader.load(new Uri(param1));
      }
      
      public function setAnimNameModifier(param1:Function) : void
      {
         this._animNameModifier = param1;
      }
      
      public function addTransition(param1:uint, param2:String, param3:String, param4:uint, param5:String) : void
      {
         if(!this._transitions[param1])
         {
            this._transitions[param1] = new Dictionary();
         }
         this._transitions[param1][param2 + "_" + param3 + "_" + param4] = param5;
      }
      
      public function hasTransition(param1:uint, param2:String, param3:String, param4:uint) : Boolean
      {
         if(this._animNameModifier != null)
         {
            param2 = this._animNameModifier(param1,param2);
            param3 = this._animNameModifier(param1,param3);
         }
         return this._transitions[param1] && (this._transitions[param1][param2 + "_" + param3 + "_" + param4] != null || this._transitions[param1][param2 + "_" + param3 + "_" + TiphonUtility.getFlipDirection(param4)] != null);
      }
      
      public function getTransition(param1:uint, param2:String, param3:String, param4:uint) : String
      {
         if(this._animNameModifier != null)
         {
            param2 = this._animNameModifier(param1,param2);
            param3 = this._animNameModifier(param1,param3);
         }
         if(!this._transitions[param1])
         {
            return null;
         }
         if(this._transitions[param1][param2 + "_" + param3 + "_" + param4])
         {
            return this._transitions[param1][param2 + "_" + param3 + "_" + param4];
         }
         return this._transitions[param1][param2 + "_" + param3 + "_" + TiphonUtility.getFlipDirection(param4)];
      }
      
      public function getBoneFile(param1:uint, param2:String) : Uri
      {
         if(!this._index[param1] || !this._index[param1][param2])
         {
            return new Uri(TiphonConstants.SWF_SKULL_PATH + param1 + ".swl");
         }
         return new Uri(TiphonConstants.SWF_SKULL_PATH + this._index[param1][param2]);
      }
      
      public function hasAnim(param1:uint, param2:String, param3:int = 0) : Boolean
      {
         if(!this._index[param1])
         {
            _log.error("Le bone " + param1 + " ne possède aucune animation");
            return false;
         }
         if(!this._index[param1][param2])
         {
            _log.error("Le bone " + param1 + " ne possède aucune animation nommée " + param2);
            return false;
         }
         return true;
      }
      
      public function hasCustomBone(param1:uint) : Boolean
      {
         return this._index[param1];
      }
      
      public function getAllCustomAnimations(param1:int) : Array
      {
         var _loc4_:* = null;
         var _loc2_:Dictionary = this._index[param1];
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:Array = new Array();
         for(_loc4_ in _loc2_)
         {
            _loc3_.push(_loc4_);
         }
         return _loc3_;
      }
      
      private function onXmlLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc5_:XML = null;
         var _loc6_:Uri = null;
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onXmlLoaded);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onSubXmlLoaded);
         this._loader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllSubXmlLoaded);
         var _loc2_:String = FileUtils.getFilePath(param1.uri.uri);
         var _loc3_:XML = param1.resource as XML;
         var _loc4_:Array = new Array();
         for each(_loc5_ in _loc3_..group)
         {
            _loc6_ = new Uri(_loc2_ + "/" + _loc5_.@id.toString() + ".xml");
            _loc6_.tag = parseInt(_loc5_.@id.toString());
            _loc4_.push(_loc6_);
         }
         this._loader.load(_loc4_);
      }
      
      private function onSubXmlLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         var _loc6_:Array = null;
         var _loc2_:XML = param1.resource as XML;
         for each(_loc4_ in _loc2_..file)
         {
            for each(_loc5_ in _loc4_..resource)
            {
               _loc3_ = _loc5_.@name.toString();
               if(_loc3_.indexOf("Anim") != -1)
               {
                  if(!this._index[param1.uri.tag])
                  {
                     this._index[param1.uri.tag] = new Dictionary();
                  }
                  this._index[param1.uri.tag][_loc3_] = _loc4_.@name.toString();
                  if(_loc3_.indexOf("_to_") != -1)
                  {
                     _loc6_ = _loc3_.split("_");
                     _self.addTransition(param1.uri.tag,_loc6_[0],_loc6_[2],parseInt(_loc6_[3]),_loc6_[0] + "_to_" + _loc6_[2]);
                  }
               }
            }
         }
      }
      
      private function onXmlFailed(param1:ResourceErrorEvent) : void
      {
         _log.error("Impossible de charger ou parser le fichier d\'index d\'animation : " + param1.uri);
      }
      
      private function onAllSubXmlLoaded(param1:ResourceLoaderProgressEvent) : void
      {
         this._loader = null;
         dispatchEvent(new Event(Event.INIT));
      }
   }
}
