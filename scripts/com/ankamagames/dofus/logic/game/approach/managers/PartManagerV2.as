package com.ankamagames.dofus.logic.game.approach.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.kernel.updaterv2.IUpdaterMessageHandler;
   import com.ankamagames.dofus.kernel.updaterv2.UpdaterApi;
   import com.ankamagames.dofus.kernel.updaterv2.messages.IUpdaterInputMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.ComponentListMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.ErrorMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.FinishedMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.ProgressMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.StepMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.SystemConfigurationMessage;
   import com.ankamagames.dofus.logic.connection.managers.StoreUserDataManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class PartManagerV2 implements IUpdaterMessageHandler
   {
      
      private static const instance:PartManagerV2 = new PartManagerV2();
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(PartManagerV2));
      
      private static const PROJECT_NAME:String = "game";
       
      
      private var api:UpdaterApi;
      
      private var _modules:Dictionary;
      
      private var _init_mode:Boolean;
      
      public function PartManagerV2()
      {
         super();
         if(!this.api)
         {
            this.api = new UpdaterApi(this);
         }
      }
      
      public static function getInstance() : PartManagerV2
      {
         return instance;
      }
      
      public function init() : void
      {
         _log.info("Initializing PartManager");
         this.api.getComponentList(PROJECT_NAME);
      }
      
      public function hasComponent(param1:String) : Boolean
      {
         return !!this._modules?this._modules[param1] != null?Boolean(this._modules[param1].activated as Boolean):false:false;
      }
      
      public function activateComponent(param1:String, param2:Boolean = true, param3:String = "game") : void
      {
         if(!this.hasComponent(param1))
         {
            _log.debug(!!("Ask updater for " + param2)?"activate":"desactivate" + " component : " + param1);
            this.api.activateComponent(param1,param2,param3);
         }
      }
      
      public function getSystemConfiguration(param1:String = "") : void
      {
         this.api.getSystemConfiguration(param1);
      }
      
      public function set installedModules(param1:Dictionary) : void
      {
         this._modules = param1;
      }
      
      public function handleMessage(param1:IUpdaterInputMessage) : void
      {
         var _loc4_:SystemConfigurationMessage = null;
         var _loc5_:ErrorMessage = null;
         var _loc6_:ComponentListMessage = null;
         var _loc7_:StepMessage = null;
         var _loc8_:UiModule = null;
         var _loc9_:ProgressMessage = null;
         var _loc10_:FinishedMessage = null;
         var _loc2_:Hook = null;
         var _loc3_:Array = null;
         _log.info("From updater : " + getQualifiedClassName(param1));
         switch(true)
         {
            case param1 is ComponentListMessage:
               _loc6_ = param1 as ComponentListMessage;
               this._modules = _loc6_.components;
               break;
            case param1 is StepMessage:
               _loc7_ = param1 as StepMessage;
               if(_loc7_.step == StepMessage.UPDATING_STEP)
               {
                  _loc8_ = UiModuleManager.getInstance().getModule("Ankama_Common");
                  if(!Berilia.getInstance().isUiDisplayed("downloadUiNewUpdaterInstance"))
                  {
                     Berilia.getInstance().loadUi(_loc8_,_loc8_.getUi("downloadUiNewUpdater"),"downloadUiNewUpdaterInstance",null,false,StrataEnum.STRATA_HIGH);
                  }
               }
               _loc2_ = HookList.UpdateStepChange;
               _loc3_ = [_loc2_,_loc7_.step];
               break;
            case param1 is ProgressMessage:
               _loc9_ = param1 as ProgressMessage;
               _loc2_ = HookList.UpdateProgress;
               _loc3_ = [_loc2_,_loc9_.step,_loc9_.currentSize,_loc9_.eta,_loc9_.progress,_loc9_.smooth,_loc9_.speed,_loc9_.totalSize];
               break;
            case param1 is FinishedMessage:
               _loc10_ = param1 as FinishedMessage;
               _loc2_ = HookList.UpdateFinished;
               _loc3_ = [_loc2_,_loc10_.needRestart,_loc10_.needUpdate,_loc10_.newVersion,_loc10_.previousVersion,_loc10_.error];
               setTimeout(Berilia.getInstance().unloadUi,2000,"downloadUiNewUpdaterInstance");
               break;
            case param1 is SystemConfigurationMessage:
               _loc4_ = param1 as SystemConfigurationMessage;
               StoreUserDataManager.getInstance().onSystemConfiguration(_loc4_.config);
               break;
            case param1 is ErrorMessage:
               _loc5_ = param1 as ErrorMessage;
               _loc2_ = HookList.UpdateError;
               _loc3_ = [_loc2_,_loc5_.type,_loc5_.message];
         }
         if(_loc2_)
         {
            KernelEventsManager.getInstance().processCallback.apply(null,_loc3_);
         }
      }
      
      public function handleConnectionOpened() : void
      {
         _log.info("Updater is online");
      }
      
      public function handleConnectionClosed() : void
      {
         _log.info("Connexion with updater has been closed");
      }
   }
}
