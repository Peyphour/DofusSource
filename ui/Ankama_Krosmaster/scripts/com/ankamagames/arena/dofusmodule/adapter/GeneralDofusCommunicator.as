package com.ankamagames.arena.dofusmodule.adapter
{
   import d2api.SystemApi;
   import d2api.TimeApi;
   import d2hooks.PlayerAggression;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TextEvent;
   
   public class GeneralDofusCommunicator extends EventDispatcher implements IGeneralCommunicator
   {
      
      public static const EVT_DESTROY_FROM_DOFUS:String = "com.ankamagames.arena.dofusmodule.adapter.GeneralDofusCommunicator.EVT_DESTROY_FROM_DOFUS";
      
      public static const EVT_CLOSE_ARENA_IN_DOFUS_REQUEST:String = "com.ankamagames.arena.dofusmodule.adapter.GeneralDofusCommunicator.EVT_CLOSE_ARENA_IN_DOFUS_REQUEST";
      
      public static const EVT_AGGRO_IN_DOFUS:String = "com.ankamagames.arena.dofusmodule.adapter.GeneralDofusCommunicator.EVT_AGGRO_IN_DOFUS";
      
      public static const EVT_GET_TEXT_REQUEST:String = "com.ankamagames.arena.dofusmodule.adapter.GeneralDofusCommunicator.EVT_GET_TEXT_REQUEST";
      
      public static const EVT_DOFUS_CLOSE_BUTTON_CLICKED:String = "com.ankamagames.arena.dofusmodule.adapter.GeneralDofusCommunicator.EVT_DOFUS_CLOSE_BUTTON_CLICKED";
      
      public static const CLOSE_ARENA_KEY:String = "dofus_close_arena";
      
      public static const REDUCE_ARENA_KEY:String = "dofus_reduce_arena";
      
      public static const RESTORE_ARENA_KEY:String = "dofus_restore_arena";
       
      
      private var _sysApi:SystemApi;
      
      private var _texts:Array;
      
      private var _timeApi:TimeApi;
      
      public function GeneralDofusCommunicator(param1:SystemApi, param2:TimeApi)
      {
         super();
         this._sysApi = param1;
         this._timeApi = param2;
         this._texts = new Array();
         this._sysApi.addHook(PlayerAggression,this.onAggro);
      }
      
      public function onAggro(param1:int, param2:String) : void
      {
         dispatchEvent(new TextEvent(EVT_AGGRO_IN_DOFUS,false,false,param2));
      }
      
      public function destroy() : void
      {
         dispatchEvent(new Event(EVT_DESTROY_FROM_DOFUS));
      }
      
      public function closeArenaRequest() : void
      {
         dispatchEvent(new Event(EVT_CLOSE_ARENA_IN_DOFUS_REQUEST));
      }
      
      public function setText(param1:String, param2:String) : void
      {
         this._texts[param1] = param2;
      }
      
      public function getText(param1:String) : String
      {
         if(this._texts[param1] == null)
         {
            dispatchEvent(new TextEvent(EVT_GET_TEXT_REQUEST,false,false,param1));
         }
         return this._texts[param1] == null?"":this._texts[param1];
      }
   }
}
