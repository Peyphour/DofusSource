package com.ankamagames.dofus.datacenter.servers
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class ServerGameType implements IDataCenter
   {
      
      public static const MODULE:String = "ServerGameTypes";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(ServerGameType));
       
      
      public var id:int;
      
      public var nameId:uint;
      
      private var _name:String;
      
      public function ServerGameType()
      {
         super();
      }
      
      public static function getServerGameTypeById(param1:int) : ServerGameType
      {
         return GameData.getObject(MODULE,param1) as ServerGameType;
      }
      
      public static function getServerGameTypes() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         if(!this._name)
         {
            this._name = I18n.getText(this.nameId);
         }
         return this._name;
      }
   }
}
