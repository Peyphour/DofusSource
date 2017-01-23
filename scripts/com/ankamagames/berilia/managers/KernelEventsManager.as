package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.data.OldMessage;
   import com.ankamagames.berilia.types.event.HookEvent;
   import com.ankamagames.berilia.types.event.HookLogEvent;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.jerakine.logger.ModuleLogger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.events.EventDispatcher;
   
   public class KernelEventsManager extends GenericEventsManager
   {
      
      private static var _self:KernelEventsManager;
       
      
      private var _aLoadingUi:Array;
      
      private var _eventDispatcher:EventDispatcher;
      
      public function KernelEventsManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("KernelEventsManager is a singleton and should not be instanciated directly.");
         }
         this._eventDispatcher = new EventDispatcher();
         this._aLoadingUi = new Array();
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderComplete,this.processOldMessage);
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderFailed,this.processOldMessage);
      }
      
      public static function getInstance() : KernelEventsManager
      {
         if(_self == null)
         {
            _self = new KernelEventsManager();
         }
         return _self;
      }
      
      public function get eventDispatcher() : EventDispatcher
      {
         return this._eventDispatcher;
      }
      
      public function isRegisteredEvent(param1:String) : Boolean
      {
         return _aEvent[param1] != null;
      }
      
      public function processCallback(param1:Hook, ... rest) : void
      {
         var _loc5_:* = null;
         var _loc6_:GenericListener = null;
         FpsManager.getInstance().startTracking("hook",7108545);
         if(!UiModuleManager.getInstance().ready)
         {
            _log.warn("Hook " + param1.name + " discarded");
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:Array = Berilia.getInstance().loadingUi;
         for(_loc5_ in _loc4_)
         {
            _loc3_++;
            if(Berilia.getInstance().loadingUi[_loc5_])
            {
               if(this._aLoadingUi[_loc5_] == null)
               {
                  this._aLoadingUi[_loc5_] = new Array();
               }
               this._aLoadingUi[_loc5_].push(new OldMessage(param1,rest));
            }
         }
         _log.logDirectly(new HookLogEvent(param1.name,[]));
         if(!_aEvent[param1.name])
         {
            return;
         }
         ModuleLogger.log(param1,rest);
         var _loc7_:Array = [];
         for each(_loc6_ in _aEvent[param1.name])
         {
            _loc7_.push(_loc6_);
         }
         for each(_loc6_ in _loc7_)
         {
            if(_loc6_)
            {
               if(_loc6_.listenerType == GenericListener.LISTENER_TYPE_UI && !Berilia.getInstance().getUi(_loc6_.listener))
               {
                  _log.info("L\'UI " + _loc6_.listener + " n\'existe plus pour recevoir le hook " + _loc6_.event);
               }
               else
               {
                  ErrorManager.tryFunction(_loc6_.callback,rest,"Une erreur est survenue lors du traitement du hook " + param1.name);
               }
            }
         }
         if(this._eventDispatcher.hasEventListener(HookEvent.DISPATCHED))
         {
            this._eventDispatcher.dispatchEvent(new HookEvent(HookEvent.DISPATCHED,param1));
         }
         FpsManager.getInstance().stopTracking("hook");
      }
      
      private function processOldMessage(param1:UiRenderEvent) : void
      {
         var _loc2_:Hook = null;
         var _loc3_:Array = null;
         var _loc5_:* = null;
         var _loc6_:GenericListener = null;
         if(!this._aLoadingUi[param1.uiTarget.name])
         {
            return;
         }
         if(param1.type == UiRenderEvent.UIRenderFailed)
         {
            this._aLoadingUi[param1.uiTarget.name] = null;
            return;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < this._aLoadingUi[param1.uiTarget.name].length)
         {
            _loc2_ = this._aLoadingUi[param1.uiTarget.name][_loc4_].hook;
            _loc3_ = this._aLoadingUi[param1.uiTarget.name][_loc4_].args;
            for(_loc5_ in _aEvent[_loc2_.name])
            {
               if(_aEvent[_loc2_.name][_loc5_])
               {
                  _loc6_ = _aEvent[_loc2_.name][_loc5_];
                  if(_loc6_.listener == param1.uiTarget.name)
                  {
                     _loc6_.callback.apply(null,_loc3_);
                  }
                  if(_aEvent[_loc2_.name] == null)
                  {
                     break;
                  }
               }
            }
            _loc4_++;
         }
         delete this._aLoadingUi[param1.uiTarget.name];
      }
   }
}
