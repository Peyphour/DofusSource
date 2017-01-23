package com.ankamagames.dofus.internalDatacenter.servers
{
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   
   public class ServerWrapper
   {
       
      
      private var _server:Server;
      
      private var _serverInfo:GameServerInformations;
      
      public function ServerWrapper()
      {
         super();
      }
      
      public static function create(param1:Server, param2:GameServerInformations) : ServerWrapper
      {
         var _loc3_:ServerWrapper = new ServerWrapper();
         _loc3_._server = param1;
         _loc3_._serverInfo = param2;
         return _loc3_;
      }
      
      public static function sortByPopulation(param1:ServerWrapper, param2:ServerWrapper) : Number
      {
         if(param1.server.population.id < param2.server.population.id)
         {
            return -1;
         }
         if(param1.server.population.id > param2.server.population.id)
         {
            return 1;
         }
         return 0;
      }
      
      public function get server() : Server
      {
         return this._server;
      }
      
      public function get serverInfo() : GameServerInformations
      {
         return this._serverInfo;
      }
   }
}
