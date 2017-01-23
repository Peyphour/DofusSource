package com.ankamagames.jerakine.utils.crypto
{
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filesystem.File;
   
   public class FolderHashChecker extends EventDispatcher
   {
      
      public static const ERROR_SIG:uint = 0;
      
      public static const ERROR_SIZE:uint = 1;
      
      public static const ERROR_HASH:uint = 2;
       
      
      private var _loader:IResourceLoader;
      
      private var _hashRoot:File;
      
      private var _metaUri:Uri;
      
      private var _onInit:Function;
      
      public function FolderHashChecker(param1:Uri, param2:Function = null)
      {
         super();
         this._onInit = param2;
         this._metaUri = param1;
         this._hashRoot = param1.toFile().parent;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onMetaLoaded,false,0,true);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onMetaLoadFailed,false,0,true);
         this._loader.load(param1);
      }
      
      private function onMetaLoadFailed(param1:ResourceErrorEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Invalid signature for " + this._metaUri,ERROR_HASH));
         }
      }
      
      private function onMetaLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(_loc2_)
         {
            this.processXML(param1.resource);
         }
      }
      
      private function processXML(param1:XML) : void
      {
         var _loc6_:Boolean = true;
         var _loc7_:Boolean = false;
         var _loc2_:XML = null;
         §§push(0);
         if(_loc7_)
         {
            §§push(-§§pop() - 42 - 101);
         }
         var _loc3_:uint = §§pop();
         if(_loc6_)
         {
            §§push(0);
            if(_loc7_)
            {
               §§push(-(§§pop() - 97) - 1);
            }
            if(_loc6_)
            {
               if(!_loc7_)
               {
                  for(; §§hasnext(param1.filesVersions..file,_loc4_); if(parseInt(_loc2_.toString()) != _loc3_)
                  {
                     if(!_loc7_)
                     {
                        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Invalid file size for " + this._hashRoot.resolvePath(_loc2_.@name).nativePath,ERROR_SIZE));
                     }
                     §§goto(addr96);
                  }
                  else
                  {
                     continue;
                  })
                  {
                     _loc2_ = §§nextvalue(_loc4_,_loc5_);
                     if(!_loc7_)
                     {
                        _loc3_ = this._hashRoot.resolvePath(_loc2_.@name).size;
                        if(!_loc7_)
                        {
                           continue;
                        }
                        addr96:
                        return;
                     }
                  }
               }
            }
            if(!_loc6_)
            {
            }
            addr113:
            this._onInit();
            addr124:
            if(!_loc7_)
            {
               addr117:
            }
            return;
         }
         if(this._onInit != null)
         {
            if(!_loc7_)
            {
               §§goto(addr113);
            }
            §§goto(addr117);
         }
         else
         {
            dispatchEvent(new Event(Event.INIT));
         }
         §§goto(addr124);
      }
   }
}
