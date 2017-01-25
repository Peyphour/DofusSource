package com.ankamagames.dofus.internalDatacenter.jobs
{
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatusExtended;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryListEntry;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class CraftsmanWrapper implements IDataCenter
   {
       
      
      public var playerId:Number;
      
      public var playerName:String;
      
      public var alignmentSide:int;
      
      public var breed:int;
      
      public var sex:Boolean;
      
      public var isInWorkshop:Boolean = false;
      
      public var mapId:int;
      
      public var subAreaId:int;
      
      public var worldPos:String;
      
      public var statusId:int;
      
      public var awayMessage:String;
      
      public var jobId:int;
      
      public var jobLevel:int;
      
      public var minLevelCraft:int;
      
      public var freeCraft:Boolean;
      
      public function CraftsmanWrapper()
      {
         super();
      }
      
      public static function create(param1:JobCrafterDirectoryListEntry) : CraftsmanWrapper
      {
         var _loc2_:CraftsmanWrapper = new CraftsmanWrapper();
         _loc2_.playerId = param1.playerInfo.playerId;
         _loc2_.playerName = param1.playerInfo.playerName;
         _loc2_.alignmentSide = param1.playerInfo.alignmentSide;
         _loc2_.breed = param1.playerInfo.breed;
         _loc2_.sex = param1.playerInfo.sex;
         _loc2_.isInWorkshop = param1.playerInfo.isInWorkshop;
         _loc2_.mapId = param1.playerInfo.mapId;
         _loc2_.subAreaId = param1.playerInfo.subAreaId;
         _loc2_.worldPos = "(" + param1.playerInfo.worldX + ", " + param1.playerInfo.worldY + ")";
         _loc2_.statusId = param1.playerInfo.status.statusId;
         if(param1.playerInfo.status is PlayerStatusExtended)
         {
            _loc2_.awayMessage = PlayerStatusExtended(param1.playerInfo.status).message;
         }
         _loc2_.jobId = param1.jobInfo.jobId;
         _loc2_.jobLevel = param1.jobInfo.jobLevel;
         _loc2_.minLevelCraft = param1.jobInfo.minLevel;
         _loc2_.freeCraft = param1.jobInfo.free;
         return _loc2_;
      }
   }
}
