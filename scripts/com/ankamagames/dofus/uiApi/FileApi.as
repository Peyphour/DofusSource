package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.utils.ModuleFileManager;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.dofus.modules.utils.ModuleFilestream;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   
   [InstanciedApi]
   public class FileApi implements IApi
   {
       
      
      private var _loader:IResourceLoader;
      
      private var _module:UiModule;
      
      private var _openedFiles:Dictionary;
      
      public function FileApi()
      {
         this._openedFiles = new Dictionary();
         super();
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onError);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoaded);
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         this._module = null;
         for(_loc1_ in this._openedFiles)
         {
            if(_loc1_)
            {
               try
               {
                  _loc1_.close();
               }
               catch(e:Error)
               {
                  continue;
               }
            }
         }
         this._openedFiles = null;
      }
      
      [NoBoxing]
      [Untrusted]
      public function loadXmlFile(param1:String, param2:Function, param3:Function = null) : void
      {
         if(FileUtils.getExtension(param1).toUpperCase() != "XML")
         {
            throw new ApiError("loadXmlFile can only load file with XML extension");
         }
         if(!param1)
         {
            throw new ApiError("loadXmlFile need a non-null url");
         }
         if(param2 == null)
         {
            throw new ApiError("loadXmlFile need a non-null success callback function");
         }
         if(this._module == null)
         {
            throw new ApiError("loadXmlFile need a non-null module");
         }
         param1 = this._module.rootPath + param1.replace("..","");
         var _loc4_:Uri = new Uri(param1);
         _loc4_.tag = {
            "loadSuccessCallBack":param2,
            "loadErrorCallBack":param3
         };
         this._loader.load(_loc4_);
      }
      
      [Trusted]
      public function trustedLoadXmlFile(param1:String, param2:Function, param3:Function = null) : void
      {
         if(FileUtils.getExtension(param1).toUpperCase() != "XML")
         {
            throw new ApiError("loadXmlFile can only load file with XML extension");
         }
         if(!param1)
         {
            throw new ApiError("loadXmlFile need a non-null url");
         }
         if(param2 == null)
         {
            throw new ApiError("loadXmlFile need a non-null success callback function");
         }
         var _loc4_:Uri = new Uri(param1);
         _loc4_.tag = {
            "loadSuccessCallBack":param2,
            "loadErrorCallBack":param3
         };
         this._loader.load(_loc4_);
      }
      
      [Untrusted]
      public function openFile(param1:String, param2:String = "update") : ModuleFilestream
      {
         var _loc3_:ModuleFilestream = new ModuleFilestream(param1,param2,this._module);
         this._openedFiles[_loc3_] = param1;
         return _loc3_;
      }
      
      [Untrusted]
      public function deleteFile(param1:String) : void
      {
         param1 = ModuleFilestream.cleanUrl(param1);
         var _loc2_:File = new File(this._module.storagePath + param1 + ".dmf");
         if(_loc2_.exists && !_loc2_.isDirectory)
         {
            _loc2_.deleteFile();
         }
      }
      
      [Untrusted]
      public function deleteDir(param1:String, param2:Boolean = true) : void
      {
         param1 = ModuleFilestream.cleanUrl(param1);
         var _loc3_:File = new File(this._module.storagePath + param1);
         if(_loc3_.exists && _loc3_.isDirectory)
         {
            _loc3_.deleteDirectory(param2);
         }
      }
      
      [Untrusted]
      [NoBoxing]
      public function getDirectoryContent(param1:String = null, param2:Boolean = false, param3:Boolean = false) : Array
      {
         var _loc6_:Array = null;
         var _loc7_:File = null;
         param1 = !!param1?ModuleFilestream.cleanUrl(param1):"";
         var _loc4_:Array = [];
         var _loc5_:File = new File(this._module.storagePath + param1);
         if(_loc5_.exists && _loc5_.isDirectory)
         {
            _loc6_ = _loc5_.getDirectoryListing();
            for each(_loc7_ in _loc6_)
            {
               if(!_loc7_.isDirectory && !param2)
               {
                  _loc4_.push(_loc7_.name.substr(_loc7_.name.lastIndexOf(".dm")));
               }
               if(_loc7_.isDirectory && !param3)
               {
                  _loc4_.push(_loc7_.name);
               }
            }
         }
         return _loc4_;
      }
      
      [Untrusted]
      [NoBoxing]
      public function isDirectory(param1:String) : Boolean
      {
         param1 = !!param1?ModuleFilestream.cleanUrl(param1):"";
         var _loc2_:File = new File(this._module.storagePath + param1);
         return _loc2_.exists && _loc2_.isDirectory;
      }
      
      [Untrusted]
      [NoBoxing]
      public function createDirectory(param1:String) : void
      {
         param1 = !!param1?ModuleFilestream.cleanUrl(param1):"";
         var _loc2_:File = new File(this._module.storagePath + param1);
         ModuleFilestream.checkCreation(param1,this._module);
         _loc2_.createDirectory();
      }
      
      [Untrusted]
      public function getAvaibleSpace() : uint
      {
         return ModuleFileManager.getInstance().getAvaibleSpace(this._module.id);
      }
      
      [Untrusted]
      public function getUsedSpace() : uint
      {
         return ModuleFileManager.getInstance().getUsedSpace(this._module.id);
      }
      
      [Untrusted]
      public function getMaxSpace() : uint
      {
         return ModuleFileManager.getInstance().getMaxSpace(this._module.id);
      }
      
      [Untrusted]
      public function getUsedFileCount() : uint
      {
         return ModuleFileManager.getInstance().getUsedFileCount(this._module.id);
      }
      
      [Untrusted]
      public function getMaxFileCount() : uint
      {
         return ModuleFileManager.getInstance().getMaxFileCount(this._module.id);
      }
      
      private function onLoaded(param1:ResourceLoadedEvent) : void
      {
         param1.uri.tag.loadSuccessCallBack(param1.resource);
      }
      
      private function onError(param1:ResourceErrorEvent) : void
      {
         var e:ResourceErrorEvent = param1;
         if(e.uri.tag.loadErrorCallBack)
         {
            try
            {
               e.uri.tag.loadErrorCallBack(e.errorCode,e.errorMsg);
               return;
            }
            catch(e:ArgumentError)
            {
               throw new ApiError("loadErrorCallBack on loadXmlFile function need two args : onError(errorCode : uint, errorMsg : String)");
            }
         }
      }
   }
}
