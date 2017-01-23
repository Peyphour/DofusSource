package com.ankamagames.berilia.managers
{
   import com.adobe.air.filesystem.FileMonitor;
   import com.adobe.air.filesystem.events.FileMonitorEvent;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.tooltip.TooltipBlock;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class AutoReloadUiManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AutoReloadUiManager));
       
      
      private const _regImport:RegExp = /<Import *url="([^"]*)/gm;
      
      private var _uiData:UiData;
      
      private var _fileMonitors:Vector.<FileMonitor>;
      
      private var _componentsSnapShot:Dictionary;
      
      private var _scriptParams:Dictionary;
      
      private var _fileMonitorRef:Dictionary;
      
      public function AutoReloadUiManager(param1:UiData)
      {
         var _loc4_:FileMonitor = null;
         this._fileMonitors = new Vector.<FileMonitor>();
         this._fileMonitorRef = new Dictionary();
         super();
         this._uiData = param1;
         var _loc2_:File = new Uri(param1.file).toFile();
         this.watchFile(_loc2_);
         this.detectImport(_loc2_,new Dictionary());
         var _loc3_:Array = [];
         for each(_loc4_ in this._fileMonitors)
         {
            _loc3_.push(_loc4_.file.name);
         }
         _log.info(this._uiData.name + " watch " + _loc3_.join(", "));
      }
      
      public static function create(param1:String) : AutoReloadUiManager
      {
         var _loc2_:UiModule = null;
         var _loc3_:UiData = null;
         for each(_loc2_ in UiModuleManager.getInstance().getModules())
         {
            _loc3_ = _loc2_.getUi(param1);
            if(_loc3_)
            {
               return new AutoReloadUiManager(_loc3_);
            }
         }
         return null;
      }
      
      public function destroy() : void
      {
         var _loc1_:FileMonitor = null;
         for each(_loc1_ in this._fileMonitors)
         {
            _loc1_.removeEventListener(FileMonitorEvent.CHANGE,this.onXmlChange);
         }
         this._fileMonitors = null;
         this._componentsSnapShot = null;
         this._scriptParams = null;
      }
      
      private function detectImport(param1:File, param2:Dictionary) : void
      {
         var _loc6_:String = null;
         var _loc7_:File = null;
         if(!param1.exists)
         {
            return;
         }
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(param1,FileMode.READ);
         var _loc4_:String = _loc3_.readUTFBytes(_loc3_.bytesAvailable);
         _loc3_.close();
         var _loc5_:Array = _loc4_.match(this._regImport);
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = new Uri(LangManager.getInstance().replaceKey(_loc6_.substr(_loc6_.indexOf("\"") + 1))).toFile();
            if(!param2[_loc7_.nativePath])
            {
               param2[_loc7_.nativePath] = true;
               this.watchFile(_loc7_);
               this.detectImport(param1,param2);
            }
         }
      }
      
      private function watchFile(param1:File) : void
      {
         var _loc2_:FileMonitor = null;
         if(!this._fileMonitorRef[param1.nativePath])
         {
            this._fileMonitorRef[param1.nativePath] = true;
            _loc2_ = new FileMonitor(param1);
            _loc2_.addEventListener(FileMonitorEvent.CHANGE,this.onXmlChange);
            this._fileMonitors.push(_loc2_);
            _loc2_.watch();
         }
      }
      
      protected function onXmlChange(param1:FileMonitorEvent) : void
      {
         var _loc3_:UiRootContainer = null;
         var _loc4_:Callback = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:* = undefined;
         var _loc7_:GraphicContainer = null;
         var _loc8_:UiRootContainer = null;
         UiRenderManager.getInstance().clearCacheFromId(this._uiData.file);
         CssManager.clear(true);
         TooltipManager.clearCache();
         TooltipBlock.clearCache();
         var _loc2_:Vector.<Callback> = new Vector.<Callback>();
         for each(_loc3_ in Berilia.getInstance().uiList)
         {
            if(_loc3_.uiData == this._uiData)
            {
               _loc5_ = _loc3_;
               while(!(_loc5_ is Stage) && _loc5_ != null && (_loc5_ = _loc5_.parent) && !(_loc5_ is GraphicContainer))
               {
               }
               _loc6_ = _loc3_.properties;
               if(_loc5_ is GraphicContainer)
               {
                  _loc7_ = _loc5_ as GraphicContainer;
                  _loc8_ = new UiRootContainer(StageShareManager.stage,this._uiData);
                  _loc8_.uiModule = _loc3_.uiModule;
                  _loc8_.strata = _loc7_.getUi().strata;
                  _loc8_.restoreSnapshotAfterLoading = _loc7_.getUi().restoreSnapshotAfterLoading;
                  _loc8_.depth = _loc7_.getUi().depth + 1;
                  _loc7_.addChild(_loc8_);
                  _loc2_.push(new Callback(Berilia.getInstance().loadUiInside,this._uiData,_loc3_.name,_loc8_,_loc6_,true));
               }
               else
               {
                  _loc2_.push(new Callback(Berilia.getInstance().loadUi,_loc3_.uiModule,this._uiData,_loc3_.name,_loc6_,true));
               }
            }
         }
         for each(_loc4_ in _loc2_)
         {
            _loc4_.exec();
         }
      }
   }
}
