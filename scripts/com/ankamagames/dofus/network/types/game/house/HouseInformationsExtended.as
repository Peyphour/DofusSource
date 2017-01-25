package com.ankamagames.dofus.network.types.game.house
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class HouseInformationsExtended extends HouseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 112;
       
      
      public var guildInfo:GuildInformations;
      
      public function HouseInformationsExtended()
      {
         this.guildInfo = new GuildInformations();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 112;
      }
      
      public function initHouseInformationsExtended(param1:uint = 0, param2:Vector.<uint> = null, param3:String = "", param4:Boolean = false, param5:Boolean = false, param6:uint = 0, param7:GuildInformations = null) : HouseInformationsExtended
      {
         super.initHouseInformations(param1,param2,param3,param4,param5,param6);
         this.guildInfo = param7;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.guildInfo = new GuildInformations();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_HouseInformationsExtended(param1);
      }
      
      public function serializeAs_HouseInformationsExtended(param1:ICustomDataOutput) : void
      {
         super.serializeAs_HouseInformations(param1);
         this.guildInfo.serializeAs_GuildInformations(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HouseInformationsExtended(param1);
      }
      
      public function deserializeAs_HouseInformationsExtended(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.guildInfo = new GuildInformations();
         this.guildInfo.deserialize(param1);
      }
   }
}
