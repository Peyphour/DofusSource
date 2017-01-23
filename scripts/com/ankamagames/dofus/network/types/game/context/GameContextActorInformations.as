package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GameContextActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 150;
       
      
      public var contextualId:Number = 0;
      
      public var look:EntityLook;
      
      public var disposition:EntityDispositionInformations;
      
      public function GameContextActorInformations()
      {
         this.look = new EntityLook();
         this.disposition = new EntityDispositionInformations();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 150;
      }
      
      public function initGameContextActorInformations(param1:Number = 0, param2:EntityLook = null, param3:EntityDispositionInformations = null) : GameContextActorInformations
      {
         this.contextualId = param1;
         this.look = param2;
         this.disposition = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.contextualId = 0;
         this.look = new EntityLook();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameContextActorInformations(param1);
      }
      
      public function serializeAs_GameContextActorInformations(param1:ICustomDataOutput) : void
      {
         if(this.contextualId < -9007199254740990 || this.contextualId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.contextualId + ") on element contextualId.");
         }
         param1.writeDouble(this.contextualId);
         this.look.serializeAs_EntityLook(param1);
         param1.writeShort(this.disposition.getTypeId());
         this.disposition.serialize(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameContextActorInformations(param1);
      }
      
      public function deserializeAs_GameContextActorInformations(param1:ICustomDataInput) : void
      {
         this.contextualId = param1.readDouble();
         if(this.contextualId < -9007199254740990 || this.contextualId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.contextualId + ") on element of GameContextActorInformations.contextualId.");
         }
         this.look = new EntityLook();
         this.look.deserialize(param1);
         var _loc2_:uint = param1.readUnsignedShort();
         this.disposition = ProtocolTypeManager.getInstance(EntityDispositionInformations,_loc2_);
         this.disposition.deserialize(param1);
      }
   }
}
