package com.ankamagames.dofus.themes.utils
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.ThemeInstallerSecurity;
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.berilia.types.data.Theme;
   import com.ankamagames.berilia.utils.ThemeInspector;
   import com.ankamagames.dofus.logic.connection.frames.AuthentificationFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.themes.utils.actions.ThemeDeleteRequestAction;
   import com.ankamagames.dofus.themes.utils.actions.ThemeInstallRequestAction;
   import com.ankamagames.dofus.themes.utils.actions.ThemeListRequestAction;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.crypto.CRC32;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import nochump.util.zip.ZipEntry;
   import nochump.util.zip.ZipFile;
   
   public class ThemeInstallerFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationFrame));
      
      private static const _priority:int = Priority.NORMAL;
       
      
      private var _loader:IResourceLoader;
      
      private var _contextLoader:LoaderContext;
      
      private var _themeDirectory:File;
      
      private var fileCrc:CRC32;
      
      private var _fileToInstall:Vector.<ZipEntry>;
      
      private var _totalTreatedFile:int;
      
      private var _instalThemeDirectory:File;
      
      private var _currentZipFile:ZipFile;
      
      private var _currentDtData:XML;
      
      public function ThemeInstallerFrame()
      {
         this.fileCrc = new CRC32();
         super();
      }
      
      public function pushed() : Boolean
      {
         this._contextLoader = new LoaderContext();
         this._contextLoader.checkPolicyFile = true;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
         var _loc1_:String = LangManager.getInstance().getEntry("config.mod.path");
         if(_loc1_.substr(0,2) != "\\\\" && _loc1_.substr(1,2) != ":/")
         {
            this._themeDirectory = new File(File.applicationStorageDirectory.nativePath + File.separator + _loc1_);
            this._themeDirectory.createDirectory();
         }
         else
         {
            this._themeDirectory = new File(_loc1_);
         }
         return true;
      }
      
      public function pulled() : Boolean
      {
         this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:Uri = null;
         var _loc3_:Uri = null;
         switch(true)
         {
            case param1 is ThemeListRequestAction:
               _loc2_ = new Uri((param1 as ThemeListRequestAction).listUrl);
               _loc2_.loaderContext = this._contextLoader;
               this._loader.load(_loc2_);
               return true;
            case param1 is ThemeInstallRequestAction:
               _loc3_ = new Uri((param1 as ThemeInstallRequestAction).url);
               _loc3_.loaderContext = this._contextLoader;
               this._loader.load(_loc3_);
               return true;
            case param1 is ThemeDeleteRequestAction:
               this.deleteTheme(ThemeDeleteRequestAction(param1).themeDirectory);
               return true;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return _priority;
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:* = undefined;
         switch(param1.uri.fileType.toLowerCase())
         {
            case "json":
               if(param1.resource is Array)
               {
                  _loc2_ = param1.resource;
               }
               else
               {
                  _loc2_ = com.ankamagames.jerakine.json.JSON.decode(param1.resource,true);
               }
               if(_loc2_ is Array)
               {
                  this.processJsonList(_loc2_);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ThemeList,[]);
               }
               break;
            case "zip":
               this.getZippedThemeInformations(param1.resource);
               break;
            default:
               KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,2);
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         _log.error("Cannot load file " + param1.uri + "(" + param1.errorMsg + ")");
         if(param1.uri.fileType.toLowerCase() == "json")
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,1);
         }
         else if(param1.uri.fileType.toLowerCase() == "zip")
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,8);
         }
         else
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,0);
         }
      }
      
      private function processJsonList(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Theme = null;
         for each(_loc2_ in param1)
         {
            _loc5_ = ThemeManager.getInstance().getThemeByAuthorAndName(_loc2_.author + "_" + _loc2_.name);
            if(_loc5_)
            {
               _loc2_.exist = true;
               _loc2_.upToDate = true;
               _loc3_ = String(_loc2_.version).split(".");
               while(_loc5_.version.length > _loc3_.length)
               {
                  _loc3_.push(0);
               }
               _loc4_ = 0;
               while(_loc4_ < _loc5_.version.length)
               {
                  if(_loc5_.version[_loc4_] < _loc3_[_loc4_])
                  {
                     _loc2_.upToDate = false;
                  }
                  _loc4_++;
               }
            }
            else
            {
               _loc2_.exist = false;
            }
         }
         KernelEventsManager.getInstance().processCallback(HookList.ThemeList,param1);
      }
      
      private function getZippedThemeInformations(param1:ZipFile) : void
      {
         var _loc2_:XML = ThemeInspector.getZipDmFile(param1);
         if(!_loc2_ || !ThemeInspector.checkArchiveValidity(param1))
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,3);
            _log.error("Theme ZIP file is missing .dt file!");
            return;
         }
         if(ThemeManager.getInstance().getThemeByAuthorAndName(_loc2_.author + "_" + _loc2_.name))
         {
            this.updateTheme(param1,_loc2_);
         }
         else
         {
            this.installTheme(param1,_loc2_);
         }
      }
      
      private function installTheme(param1:ZipFile, param2:XML) : void
      {
         var _loc3_:ZipEntry = null;
         this._currentZipFile = param1;
         if(!param2 || !param1)
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,6);
            _log.fatal("No description theme file found( DT file)");
            return;
         }
         this._instalThemeDirectory = new File(ThemeManager.getInstance().customThemesPath + param2.author + "_" + param2.name);
         this._instalThemeDirectory.createDirectory();
         ThemeInstallerSecurity.createSecurity(this._instalThemeDirectory);
         this._totalTreatedFile = 0;
         this._fileToInstall = new Vector.<ZipEntry>();
         for each(_loc3_ in param1.entries)
         {
            this._fileToInstall.push(_loc3_);
         }
         this.processZipEntry();
      }
      
      private function processZipEntry() : void
      {
         var writeStream:FileStream = null;
         var unzipedFile:File = null;
         var unzipedData:ByteArray = null;
         var entry:ZipEntry = null;
         var startProcess:uint = getTimer();
         while(this._fileToInstall.length && getTimer() - startProcess < 16)
         {
            entry = this._fileToInstall.pop();
            this._totalTreatedFile++;
            unzipedFile = new File(this._instalThemeDirectory.nativePath + File.separator + entry.name);
            try
            {
               if(unzipedFile.exists && !unzipedFile.isDirectory)
               {
                  unzipedFile.deleteFile();
               }
            }
            catch(e:Error)
            {
               _log.fatal("Cannot delete " + unzipedFile.nativePath + " : " + e.toString());
               KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,6);
               return;
            }
            if(!unzipedFile.exists || unzipedFile.isDirectory)
            {
               if(entry.isDirectory())
               {
                  try
                  {
                     unzipedFile.createDirectory();
                  }
                  catch(e:Error)
                  {
                     _log.fatal("Cannot create directory " + unzipedFile.nativePath + " : " + e.toString());
                     KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,6);
                  }
               }
               else
               {
                  try
                  {
                     this.writeZipEntry(unzipedData,entry,writeStream,unzipedFile,this._currentZipFile);
                  }
                  catch(e:Error)
                  {
                     _log.fatal("Can\'t create file " + unzipedFile.nativePath + " : " + e.toString());
                     KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,6);
                  }
               }
               KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationProgress,this._totalTreatedFile / this._currentZipFile.entries.length);
               continue;
            }
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,6);
            return;
         }
         if(this._fileToInstall.length)
         {
            setTimeout(this.processZipEntry,1);
         }
         else
         {
            this.finishInstall();
         }
      }
      
      private function finishInstall() : void
      {
         ThemeManager.getInstance().initTheme(this._instalThemeDirectory);
         if(this._totalTreatedFile == this._currentZipFile.entries.length)
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationProgress,1);
         }
         else
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,6);
            _log.fatal("Wrong extracted file, done : " + this._totalTreatedFile + ", in Zip : " + this._currentZipFile.entries.length);
         }
         this._currentDtData = null;
         this._currentZipFile = null;
         this._fileToInstall = null;
         this._totalTreatedFile = 0;
         this._instalThemeDirectory = null;
      }
      
      private function updateTheme(param1:ZipFile, param2:XML) : void
      {
         var _loc3_:ZipEntry = null;
         var _loc4_:FileStream = null;
         var _loc5_:FileStream = null;
         var _loc6_:File = null;
         var _loc7_:ByteArray = null;
         if(!param2 || !param1)
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,3);
            return;
         }
         this._instalThemeDirectory = new File(ThemeManager.getInstance().customThemesPath + param2.author + "_" + param2.name);
         if(!this._instalThemeDirectory.exists)
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationProgress,4);
         }
         this._currentDtData = param2;
         this._currentZipFile = param1;
         this._totalTreatedFile = 0;
         this._fileToInstall = new Vector.<ZipEntry>();
         for each(_loc3_ in param1.entries)
         {
            this._fileToInstall.push(_loc3_);
         }
         this.processZipEntryForUpdate();
      }
      
      private function processZipEntryForUpdate() : void
      {
         var _loc1_:FileStream = null;
         var _loc2_:FileStream = null;
         var _loc3_:File = null;
         var _loc4_:ByteArray = null;
         var _loc6_:ZipEntry = null;
         var _loc7_:ByteArray = null;
         var _loc8_:uint = 0;
         var _loc5_:uint = getTimer();
         while(this._fileToInstall.length && getTimer() - _loc5_ < 16)
         {
            _loc6_ = this._fileToInstall.pop();
            this._totalTreatedFile++;
            _loc3_ = new File(this._instalThemeDirectory.nativePath + File.separator + _loc6_.name);
            if(!_loc3_.exists)
            {
               if(_loc6_.isDirectory())
               {
                  _loc3_.createDirectory();
               }
               else
               {
                  this.writeZipEntry(_loc4_,_loc6_,_loc1_,_loc3_,this._currentZipFile);
               }
            }
            else if(!_loc6_.isDirectory())
            {
               _loc7_ = new ByteArray();
               _loc2_ = new FileStream();
               _loc2_.open(_loc3_,FileMode.READ);
               _loc2_.readBytes(_loc7_,0,_loc2_.bytesAvailable);
               _loc2_.close();
               this.fileCrc.update(_loc7_,0,_loc7_.bytesAvailable);
               _loc8_ = this.fileCrc.getValue();
               if(_loc8_ != _loc6_.crc)
               {
                  _loc3_.deleteFile();
                  this.writeZipEntry(_loc4_,_loc6_,_loc1_,_loc3_,this._currentZipFile);
               }
            }
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationProgress,this._totalTreatedFile / this._currentZipFile.entries.length);
         }
         if(this._fileToInstall.length)
         {
            setTimeout(this.processZipEntryForUpdate,1);
         }
         else
         {
            this.finishUpdate();
         }
      }
      
      private function finishUpdate() : void
      {
         var _loc1_:Theme = null;
         var _loc2_:Array = null;
         if(this._totalTreatedFile == this._currentZipFile.entries.length)
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationProgress,1);
            _loc1_ = ThemeManager.getInstance().getThemeByAuthorAndName(this._currentDtData.author + "_" + this._currentDtData.name);
            if(_loc1_)
            {
               _loc2_ = !!this._currentDtData.version?String(this._currentDtData.version).split("."):new Array(0,0,0);
               _loc2_ = _loc2_.length > 3?_loc2_.slice(0,3):_loc2_;
               while(_loc2_.length < 3)
               {
                  _loc2_.push(0);
               }
               _loc1_.version = _loc2_ == null?new Array(0,0,0):_loc2_;
            }
         }
         else
         {
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,3);
            _log.fatal("Wrong extracted file, done : " + this._totalTreatedFile + ", in Zip : " + this._currentZipFile.entries.length);
         }
         this._currentDtData = null;
         this._currentZipFile = null;
         this._fileToInstall = null;
         this._totalTreatedFile = 0;
         this._instalThemeDirectory = null;
      }
      
      private function writeZipEntry(param1:ByteArray, param2:ZipEntry, param3:FileStream, param4:File, param5:ZipFile) : Boolean
      {
         param1 = param5.getInput(param2);
         if(!ThemeInstallerSecurity.isValidFile(param4.extension,param1))
         {
            _log.error(param4.name + " is invalid! Either its size is too big or its header is not matching its extension");
            KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,6);
            return false;
         }
         param3 = new FileStream();
         param3.open(param4,FileMode.WRITE);
         param3.writeBytes(param1,0,param1.bytesAvailable);
         param3.close();
         return true;
      }
      
      private function deleteTheme(param1:String) : void
      {
         var _loc3_:Theme = null;
         var _loc2_:File = new File(ThemeManager.getInstance().customThemesPath + param1);
         if(_loc2_.exists)
         {
            _loc2_.deleteDirectory(true);
            _loc3_ = ThemeManager.getInstance().getThemeByAuthorAndName(param1);
            if(_loc3_ && _loc3_.folderFullPath)
            {
               ThemeManager.getInstance().deleteTheme(_loc3_.folderFullPath);
               KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationProgress,-1);
               return;
            }
         }
         else
         {
            _loc2_ = new File(param1);
            if(_loc2_.exists)
            {
               _loc2_.deleteDirectory(true);
               ThemeManager.getInstance().deleteTheme(param1);
               KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationProgress,-1);
               return;
            }
         }
         KernelEventsManager.getInstance().processCallback(HookList.ThemeInstallationError,5);
         _log.fatal("Can\'t delete " + _loc2_.nativePath);
      }
   }
}
