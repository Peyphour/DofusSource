package com.ankamagames.dofus.logic.connection.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManagerV2;
   import com.ankamagames.dofus.logic.game.common.managers.SteamManager;
   import com.ankamagames.dofus.misc.interClient.InterClientManager;
   import com.ankamagames.dofus.misc.utils.HaapiDebugManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.ankamagames.performance.Benchmark;
   import com.hurlant.util.Base64;
   import flash.display.Screen;
   import flash.display.StageDisplayState;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.utils.getQualifiedClassName;
   
   public class StoreUserDataManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StoreUserDataManager));
      
      private static var _self:StoreUserDataManager;
      
      private static const NUMBER_OF_UPLOAD_PER_VERSION:uint = 1;
       
      
      private var _so:CustomSharedObject;
      
      private var _userData:Object;
      
      public function StoreUserDataManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("StoreUserDataManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : StoreUserDataManager
      {
         if(_self == null)
         {
            _self = new StoreUserDataManager();
         }
         return _self;
      }
      
      public function gatherUserData() : void
      {
         this._so = CustomSharedObject.getLocal("playerData_" + PlayerManager.getInstance().accountId);
         var _loc1_:Boolean = false;
         if(this._so && this._so.data && this._so.data.hasOwnProperty("version") && this._so.data.version.major == BuildInfos.BUILD_VERSION.major && this._so.data.version.minor == BuildInfos.BUILD_VERSION.minor && this._so.data.hasOwnProperty("totalUploads") && this._so.data.totalUploads >= NUMBER_OF_UPLOAD_PER_VERSION)
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            _log.debug("Data already saved.");
            return;
         }
         this._userData = new Object();
         this.addBaseInfoToUserData();
         if(AirScanner.hasAir())
         {
            if(CommandLineArguments.getInstance().hasArgument("updater_version") && CommandLineArguments.getInstance().getArgument("updater_version") == "v2")
            {
               PartManagerV2.getInstance().getSystemConfiguration();
            }
            else if(CommandLineArguments.getInstance().hasArgument("sysinfos"))
            {
               this.addUpdaterV1InfoToUserData();
               this.addAirAvailableInfoToUserData(true);
            }
            else
            {
               this.addAirAvailableInfoToUserData(false);
            }
         }
         else if(AirScanner.isStreamingVersion())
         {
            this.addStreamingAvailableInfoToUserData();
         }
      }
      
      public function onSystemConfiguration(param1:*) : void
      {
         var _loc2_:* = null;
         if(param1 && param1.config)
         {
            for(_loc2_ in param1.config)
            {
               this.addData("updaterV2_" + _loc2_,param1.config[_loc2_]);
            }
         }
         this.addAirAvailableInfoToUserData(true);
      }
      
      private function addBaseInfoToUserData() : void
      {
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Screen = null;
         this.addData("client_buildType",BuildInfos.BUILD_TYPE);
         this.addData("client_version",BuildInfos.BUILD_VERSION.major + "." + BuildInfos.BUILD_VERSION.minor);
         this.addData("client_sUid",MD5.hash(PlayerManager.getInstance().accountId.toString()));
         this.addData("client_isAbo",PlayerManager.getInstance().subscriptionEndDate > 0 || PlayerManager.getInstance().hasRights);
         this.addData("client_creationAbo",PlayerManager.getInstance().accountCreation);
         var _loc1_:Date = new Date(PlayerManager.getInstance().accountCreation);
         var _loc2_:String = _loc1_.fullYearUTC + "-" + StringUtils.fill((_loc1_.monthUTC + 1).toString(),2,"0") + "-" + StringUtils.fill(_loc1_.dateUTC.toString(),2,"0") + "T" + StringUtils.fill(_loc1_.hoursUTC.toString(),2,"0") + ":" + StringUtils.fill(_loc1_.minutesUTC.toString(),2,"0") + ":" + StringUtils.fill(_loc1_.secondsUTC.toString(),2,"0");
         this.addData("client_creationAboDate",_loc2_);
         this.addData("client_currentScreenResolution",StageShareManager.stage.fullScreenWidth + "x" + StageShareManager.stage.fullScreenHeight);
         if(Screen.screens && Screen.screens.length)
         {
            _loc8_ = new Array();
            _loc9_ = new Array();
            _loc10_ = new Array();
            for each(_loc11_ in Screen.screens)
            {
               _loc8_.push(_loc11_.bounds.width + "x" + _loc11_.bounds.height);
               _loc9_.push(_loc11_.bounds.width);
               _loc10_.push(_loc11_.bounds.height);
            }
            this.addData("client_availableScreens",_loc8_);
         }
         var _loc3_:String = StageShareManager.stage.displayState;
         if(AirScanner.hasAir())
         {
            this.addData("client_nativeWindow",StageShareManager.stage.nativeWindow.width + "x" + StageShareManager.stage.nativeWindow.height);
            if(_loc3_ == StageDisplayState.NORMAL)
            {
               _loc3_ = StageShareManager.stage.nativeWindow.displayState;
            }
         }
         this.addData("client_displayState",_loc3_);
         this.addData("client_uiTheme",ThemeManager.getInstance().currentTheme);
         this.addData("client_hideBlackBorders",Atouin.getInstance().options.hideBlackBorder);
         this.addData("client_mapInteriorZoom",Atouin.getInstance().options.useInsideAutoZoom);
         var _loc4_:int = 1;
         if(this._so && this._so.data && this._so.data.hasOwnProperty("totalUploads"))
         {
            _loc4_ = this._so.data.hasOwnProperty("totalUploads") + 1;
         }
         this.addData("client_totalUploads",_loc4_);
         var _loc5_:String = Capabilities.os.toLowerCase();
         var _loc6_:String = "other";
         if(_loc5_.search("windows") != -1)
         {
            _loc6_ = "windows";
         }
         else if(Capabilities.manufacturer.toLowerCase().search("android") != -1)
         {
            _loc6_ = "android";
         }
         else if(_loc5_.search("mac") != -1)
         {
            _loc6_ = "mac";
         }
         else if(_loc5_.search("linux") != -1)
         {
            _loc6_ = "linux";
         }
         else if(_loc5_.search("ipad") != -1 || _loc5_.search("iphone") != -1)
         {
            _loc6_ = "ios";
         }
         this.addData("client_os",_loc6_);
         this.addData("client_osVersion",SystemManager.getSingleton().version);
         var _loc7_:String = "none";
         if(Capabilities.supports32BitProcesses && !Capabilities.supports64BitProcesses)
         {
            _loc7_ = "32-bit";
         }
         else if(Capabilities.supports64BitProcesses)
         {
            _loc7_ = "64-bit";
         }
         this.addData("client_supportedCpuArchitecture",_loc7_);
      }
      
      private function addUpdaterV1InfoToUserData() : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc7_:Array = null;
         var _loc1_:String = Base64.decode(CommandLineArguments.getInstance().getArgument("sysinfos"));
         var _loc2_:Array = _loc1_.split("\n");
         var _loc6_:Array = new Array();
         for each(_loc3_ in _loc2_)
         {
            _loc3_ = _loc3_.replace("\n","");
            if(!(_loc3_ == "" || _loc3_.search(":") == -1))
            {
               _loc7_ = _loc3_.split(":");
               _loc4_ = _loc7_[0];
               _loc5_ = _loc7_[1];
               if(!(_loc5_ == "" || _loc4_ == ""))
               {
                  switch(_loc4_)
                  {
                     case "RAM_FREE":
                     case "DISK_FREE":
                        continue;
                     case "VIDEO_DRIVER_INSTALLATION_DATE":
                        _loc5_ = _loc5_.substr(0,6);
                  }
                  this.addData("updaterV1_" + _loc4_,_loc5_);
               }
            }
         }
      }
      
      private function addAirAvailableInfoToUserData(param1:Boolean) : void
      {
         var _loc3_:Array = null;
         this.addData("client_envType","air");
         this.addData("client_isUsingUpdater",param1);
         this.addData("client_inSteam",SteamManager.hasSteamApi() && SteamManager.getInstance().isSteamEmbed());
         var _loc2_:String = InterClientManager.getInstance().flashKey;
         if(_loc2_)
         {
            _loc3_ = _loc2_.split("#");
            this.addData("client_flashKeyBase",_loc3_[0]);
            if(_loc3_[1])
            {
               this.addData("client_flashKeyId",parseInt(_loc3_[1]));
            }
         }
         this.checkStage3D();
      }
      
      private function addStreamingAvailableInfoToUserData() : void
      {
         this.addData("client_envType","streaming");
         this.addData("client_browser",SystemManager.getSingleton().browser);
         this.addData("client_browserVersion",SystemManager.getSingleton().browserVersion);
         this.addData("client_fpVersion",Capabilities.version);
         this.addData("client_fpManufacturer",Capabilities.manufacturer);
         this.checkStage3D();
      }
      
      private function addBenchmarkInfoToUserData() : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc1_:String = Benchmark.getResults(true);
         if(_loc1_)
         {
            _loc2_ = _loc1_.split(";");
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_.split(":");
               if(_loc4_.length == 2)
               {
                  if(_loc4_[1] != "none")
                  {
                     if(_loc4_[1] == "error")
                     {
                        _loc4_[1] = "-1";
                     }
                     this.addData("client_benchmark_" + _loc4_[0],parseInt(_loc4_[1]));
                  }
               }
            }
         }
      }
      
      private function checkStage3D() : void
      {
         var _loc1_:* = undefined;
         if(ApplicationDomain.currentDomain.hasDefinition("flash.display.Stage3D"))
         {
            _loc1_ = StageShareManager.stage["stage3Ds"];
            if(_loc1_ && _loc1_.length && _loc1_[0])
            {
               _loc1_[0].addEventListener("context3DCreate",this.onContext3DCreate);
               _loc1_[0].addEventListener(ErrorEvent.ERROR,this.onContext3DError);
               _loc1_[0].requestContext3D();
            }
         }
         else
         {
            this.submitData();
         }
      }
      
      private function submitData() : void
      {
         _log.debug("Sending data...");
         this.addBenchmarkInfoToUserData();
         var _loc1_:String = by.blooddy.crypto.serialization.JSON.encode(this._userData);
         HaapiDebugManager.getInstance().submitData(HaapiDebugManager.HARDWARE_DATA_TYPE,_loc1_,this.onUserDataUploaded,this.onUserDataUploadError);
      }
      
      private function onContext3DCreate(param1:Event) : void
      {
         var _loc2_:String = "none";
         try
         {
            _loc2_ = param1.target.context3D.driverInfo;
         }
         catch(error:Error)
         {
         }
         this.addData("client_stage3dDriverInfo",_loc2_);
         this.submitData();
      }
      
      private function onContext3DError(param1:Event) : void
      {
         this.addData("client_stage3dDriverInfo","contextCreationFailed");
         this.submitData();
      }
      
      private function addData(param1:String, param2:*) : void
      {
         this._userData[param1] = param2;
      }
      
      private function onUserDataUploaded() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         if(this._so.data)
         {
            if(this._so.data.hasOwnProperty("version") && this._so.data.version.major == BuildInfos.BUILD_VERSION.major && this._so.data.version.minor == BuildInfos.BUILD_VERSION.minor)
            {
               _loc1_ = true;
            }
            if(_loc1_ && this._so.data.hasOwnProperty("totalUploads"))
            {
               _loc2_ = this._so.data.totalUploads;
            }
         }
         this._so.data = new Object();
         this._so.data.version = {
            "major":BuildInfos.BUILD_VERSION.major,
            "minor":BuildInfos.BUILD_VERSION.minor
         };
         this._so.data.totalUploads = _loc2_ + 1;
         this._so.flush();
         this._userData = null;
         this._so = null;
      }
      
      private function onUserDataUploadError() : void
      {
         _log.error("Couldn\'t send user data, an error occurred during the upload.");
      }
   }
}
