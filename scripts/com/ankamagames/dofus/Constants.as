package com.ankamagames.dofus
{
   import com.ankamagames.jerakine.cache.Cache;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   
   public class Constants
   {
      
      public static const SIGNATURE_KEY_DATA:Class = Constants_SIGNATURE_KEY_DATA;
      
      public static const BOOK_READER_APP:Class = Constants_BOOK_READER_APP;
      
      public static const LOG_UPLOAD_MODE:Boolean = false;
      
      public static var EVENT_MODE:Boolean = true;
      
      public static var EVENT_MODE_PARAM:String = "";
      
      public static var CHARACTER_CREATION_ALLOWED:Boolean = true;
      
      public static var FORCE_MAXIMIZED_WINDOW:Boolean = true;
      
      public static const DATASTORE_COMPUTER_OPTIONS:DataStoreType = new DataStoreType("Dofus_ComputerOptions",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const DATASTORE_LANG_VERSION:DataStoreType = new DataStoreType("lastLangVersion",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const DATASTORE_CONSOLE_CMD:DataStoreType = new DataStoreType("Dofus_ConsoleCmd",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
      
      public static const DATASTORE_MODULE_DEBUG:DataStoreType = new DataStoreType("Dofus_ModuleDebug",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
      
      public static const DATASTORE_TCHAT:DataStoreType = new DataStoreType("Dofus_Tchat",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const DATASTORE_TCHAT_PRIVATE:DataStoreType = new DataStoreType("Dofus_TchatPrivate",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const SCRIPT_CACHE:Cache = new Cache(Cache.CHECK_OBJECT_COUNT,100,80);
      
      public static const PRE_GAME_MODULE:Array = new Array("Ankama_Connection");
      
      public static const COMMON_GAME_MODULE:Array = new Array("Ankama_Common","Ankama_Config","Ankama_Tooltips","Ankama_Console","Ankama_ContextMenu");
      
      public static const ADMIN_MODULE:Array = new Array("Ankama_Admin");
      
      public static const DETERMINIST_TACKLE:Boolean = true;
      
      public static const ANKAMA_ADMIN:Class = Constants_ANKAMA_ADMIN;
      
      public static const ANKAMA_CARTOGRAPHY:Class = Constants_ANKAMA_CARTOGRAPHY;
      
      public static const ANKAMA_CHARACTERSHEET:Class = Constants_ANKAMA_CHARACTERSHEET;
      
      public static const ANKAMA_COMMON:Class = Constants_ANKAMA_COMMON;
      
      public static const ANKAMA_CONFIG:Class = Constants_ANKAMA_CONFIG;
      
      public static const ANKAMA_CONNECTION:Class = Constants_ANKAMA_CONNECTION;
      
      public static const ANKAMA_CONSOLE:Class = Constants_ANKAMA_CONSOLE;
      
      public static const ANKAMA_CONTEXTMENU:Class = Constants_ANKAMA_CONTEXTMENU;
      
      public static const ANKAMA_DOCUMENT:Class = Constants_ANKAMA_DOCUMENT;
      
      public static const ANKAMA_EXCHANGE:Class = Constants_ANKAMA_EXCHANGE;
      
      public static const ANKAMA_FIGHT:Class = Constants_ANKAMA_FIGHT;
      
      public static const ANKAMA_GAMEUICORE:Class = Constants_ANKAMA_GAMEUICORE;
      
      public static const ANKAMA_GRIMOIRE:Class = Constants_ANKAMA_GRIMOIRE;
      
      public static const ANKAMA_HOUSE:Class = Constants_ANKAMA_HOUSE;
      
      public static const ANKAMA_JOB:Class = Constants_ANKAMA_JOB;
      
      public static const ANKAMA_MOUNT:Class = Constants_ANKAMA_MOUNT;
      
      public static const ANKAMA_PARTY:Class = Constants_ANKAMA_PARTY;
      
      public static const ANKAMA_ROLEPLAY:Class = Constants_ANKAMA_ROLEPLAY;
      
      public static const ANKAMA_SOCIAL:Class = Constants_ANKAMA_SOCIAL;
      
      public static const ANKAMA_STORAGE:Class = Constants_ANKAMA_STORAGE;
      
      public static const ANKAMA_TAXI:Class = Constants_ANKAMA_TAXI;
      
      public static const ANKAMA_TOOLTIPS:Class = Constants_ANKAMA_TOOLTIPS;
      
      public static const ANKAMA_TRADECENTER:Class = Constants_ANKAMA_TRADECENTER;
      
      public static const ANKAMA_TUTORIAL:Class = Constants_ANKAMA_TUTORIAL;
      
      public static const ANKAMA_WEB:Class = Constants_ANKAMA_WEB;
      
      private static var _scripts:Array = [];
       
      
      public function Constants()
      {
         super();
      }
      
      public static function get scripts() : Array
      {
         if(!_scripts.length)
         {
            _scripts["ANKAMA_ADMIN"] = ANKAMA_ADMIN;
            _scripts["ANKAMA_CARTOGRAPHY"] = ANKAMA_CARTOGRAPHY;
            _scripts["ANKAMA_CHARACTERSHEET"] = ANKAMA_CHARACTERSHEET;
            _scripts["ANKAMA_COMMON"] = ANKAMA_COMMON;
            _scripts["ANKAMA_CONFIG"] = ANKAMA_CONFIG;
            _scripts["ANKAMA_CONNECTION"] = ANKAMA_CONNECTION;
            _scripts["ANKAMA_CONSOLE"] = ANKAMA_CONSOLE;
            _scripts["ANKAMA_CONTEXTMENU"] = ANKAMA_CONTEXTMENU;
            _scripts["ANKAMA_DOCUMENT"] = ANKAMA_DOCUMENT;
            _scripts["ANKAMA_EXCHANGE"] = ANKAMA_EXCHANGE;
            _scripts["ANKAMA_FIGHT"] = ANKAMA_FIGHT;
            _scripts["ANKAMA_GAMEUICORE"] = ANKAMA_GAMEUICORE;
            _scripts["ANKAMA_GRIMOIRE"] = ANKAMA_GRIMOIRE;
            _scripts["ANKAMA_HOUSE"] = ANKAMA_HOUSE;
            _scripts["ANKAMA_JOB"] = ANKAMA_JOB;
            _scripts["ANKAMA_MOUNT"] = ANKAMA_MOUNT;
            _scripts["ANKAMA_PARTY"] = ANKAMA_PARTY;
            _scripts["ANKAMA_ROLEPLAY"] = ANKAMA_ROLEPLAY;
            _scripts["ANKAMA_SOCIAL"] = ANKAMA_SOCIAL;
            _scripts["ANKAMA_STORAGE"] = ANKAMA_STORAGE;
            _scripts["ANKAMA_TAXI"] = ANKAMA_TAXI;
            _scripts["ANKAMA_TOOLTIPS"] = ANKAMA_TOOLTIPS;
            _scripts["ANKAMA_TRADECENTER"] = ANKAMA_TRADECENTER;
            _scripts["ANKAMA_TUTORIAL"] = ANKAMA_TUTORIAL;
            _scripts["ANKAMA_WEB"] = ANKAMA_WEB;
         }
         return _scripts;
      }
   }
}
