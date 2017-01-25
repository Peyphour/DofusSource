package com.ankamagames.dofus.network.types.game.mount
{
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectInteger;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   
   public class MountClientData implements INetworkType
   {
      
      public static const protocolId:uint = 178;
       
      
      public var id:Number = 0;
      
      public var model:uint = 0;
      
      public var ancestor:Vector.<uint>;
      
      public var behaviors:Vector.<uint>;
      
      public var name:String = "";
      
      public var sex:Boolean = false;
      
      public var ownerId:uint = 0;
      
      public var experience:Number = 0;
      
      public var experienceForLevel:Number = 0;
      
      public var experienceForNextLevel:Number = 0;
      
      public var level:uint = 0;
      
      public var isRideable:Boolean = false;
      
      public var maxPods:uint = 0;
      
      public var isWild:Boolean = false;
      
      public var stamina:uint = 0;
      
      public var staminaMax:uint = 0;
      
      public var maturity:uint = 0;
      
      public var maturityForAdult:uint = 0;
      
      public var energy:uint = 0;
      
      public var energyMax:uint = 0;
      
      public var serenity:int = 0;
      
      public var aggressivityMax:int = 0;
      
      public var serenityMax:uint = 0;
      
      public var love:uint = 0;
      
      public var loveMax:uint = 0;
      
      public var fecondationTime:int = 0;
      
      public var isFecondationReady:Boolean = false;
      
      public var boostLimiter:uint = 0;
      
      public var boostMax:Number = 0;
      
      public var reproductionCount:int = 0;
      
      public var reproductionCountMax:uint = 0;
      
      public var harnessGID:uint = 0;
      
      public var useHarnessColors:Boolean = false;
      
      public var effectList:Vector.<ObjectEffectInteger>;
      
      public function MountClientData()
      {
         this.ancestor = new Vector.<uint>();
         this.behaviors = new Vector.<uint>();
         this.effectList = new Vector.<ObjectEffectInteger>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 178;
      }
      
      public function initMountClientData(param1:Number = 0, param2:uint = 0, param3:Vector.<uint> = null, param4:Vector.<uint> = null, param5:String = "", param6:Boolean = false, param7:uint = 0, param8:Number = 0, param9:Number = 0, param10:Number = 0, param11:uint = 0, param12:Boolean = false, param13:uint = 0, param14:Boolean = false, param15:uint = 0, param16:uint = 0, param17:uint = 0, param18:uint = 0, param19:uint = 0, param20:uint = 0, param21:int = 0, param22:int = 0, param23:uint = 0, param24:uint = 0, param25:uint = 0, param26:int = 0, param27:Boolean = false, param28:uint = 0, param29:Number = 0, param30:int = 0, param31:uint = 0, param32:uint = 0, param33:Boolean = false, param34:Vector.<ObjectEffectInteger> = null) : MountClientData
      {
         this.id = param1;
         this.model = param2;
         this.ancestor = param3;
         this.behaviors = param4;
         this.name = param5;
         this.sex = param6;
         this.ownerId = param7;
         this.experience = param8;
         this.experienceForLevel = param9;
         this.experienceForNextLevel = param10;
         this.level = param11;
         this.isRideable = param12;
         this.maxPods = param13;
         this.isWild = param14;
         this.stamina = param15;
         this.staminaMax = param16;
         this.maturity = param17;
         this.maturityForAdult = param18;
         this.energy = param19;
         this.energyMax = param20;
         this.serenity = param21;
         this.aggressivityMax = param22;
         this.serenityMax = param23;
         this.love = param24;
         this.loveMax = param25;
         this.fecondationTime = param26;
         this.isFecondationReady = param27;
         this.boostLimiter = param28;
         this.boostMax = param29;
         this.reproductionCount = param30;
         this.reproductionCountMax = param31;
         this.harnessGID = param32;
         this.useHarnessColors = param33;
         this.effectList = param34;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.model = 0;
         this.ancestor = new Vector.<uint>();
         this.behaviors = new Vector.<uint>();
         this.name = "";
         this.sex = false;
         this.ownerId = 0;
         this.experience = 0;
         this.experienceForLevel = 0;
         this.experienceForNextLevel = 0;
         this.level = 0;
         this.isRideable = false;
         this.maxPods = 0;
         this.isWild = false;
         this.stamina = 0;
         this.staminaMax = 0;
         this.maturity = 0;
         this.maturityForAdult = 0;
         this.energy = 0;
         this.energyMax = 0;
         this.serenity = 0;
         this.aggressivityMax = 0;
         this.serenityMax = 0;
         this.love = 0;
         this.loveMax = 0;
         this.fecondationTime = 0;
         this.isFecondationReady = false;
         this.boostLimiter = 0;
         this.boostMax = 0;
         this.reproductionCount = 0;
         this.reproductionCountMax = 0;
         this.harnessGID = 0;
         this.useHarnessColors = false;
         this.effectList = new Vector.<ObjectEffectInteger>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_MountClientData(param1);
      }
      
      public function serializeAs_MountClientData(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,0,this.sex);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,1,this.isRideable);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,2,this.isWild);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,3,this.isFecondationReady);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,4,this.useHarnessColors);
         param1.writeByte(_loc2_);
         if(this.id < -9007199254740990 || this.id > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeDouble(this.id);
         if(this.model < 0)
         {
            throw new Error("Forbidden value (" + this.model + ") on element model.");
         }
         param1.writeVarInt(this.model);
         param1.writeShort(this.ancestor.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.ancestor.length)
         {
            if(this.ancestor[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.ancestor[_loc3_] + ") on element 3 (starting at 1) of ancestor.");
            }
            param1.writeInt(this.ancestor[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.behaviors.length);
         var _loc4_:uint = 0;
         while(_loc4_ < this.behaviors.length)
         {
            if(this.behaviors[_loc4_] < 0)
            {
               throw new Error("Forbidden value (" + this.behaviors[_loc4_] + ") on element 4 (starting at 1) of behaviors.");
            }
            param1.writeInt(this.behaviors[_loc4_]);
            _loc4_++;
         }
         param1.writeUTF(this.name);
         if(this.ownerId < 0)
         {
            throw new Error("Forbidden value (" + this.ownerId + ") on element ownerId.");
         }
         param1.writeInt(this.ownerId);
         if(this.experience < 0 || this.experience > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element experience.");
         }
         param1.writeVarLong(this.experience);
         if(this.experienceForLevel < 0 || this.experienceForLevel > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experienceForLevel + ") on element experienceForLevel.");
         }
         param1.writeVarLong(this.experienceForLevel);
         if(this.experienceForNextLevel < -9007199254740990 || this.experienceForNextLevel > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experienceForNextLevel + ") on element experienceForNextLevel.");
         }
         param1.writeDouble(this.experienceForNextLevel);
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         param1.writeByte(this.level);
         if(this.maxPods < 0)
         {
            throw new Error("Forbidden value (" + this.maxPods + ") on element maxPods.");
         }
         param1.writeVarInt(this.maxPods);
         if(this.stamina < 0)
         {
            throw new Error("Forbidden value (" + this.stamina + ") on element stamina.");
         }
         param1.writeVarInt(this.stamina);
         if(this.staminaMax < 0)
         {
            throw new Error("Forbidden value (" + this.staminaMax + ") on element staminaMax.");
         }
         param1.writeVarInt(this.staminaMax);
         if(this.maturity < 0)
         {
            throw new Error("Forbidden value (" + this.maturity + ") on element maturity.");
         }
         param1.writeVarInt(this.maturity);
         if(this.maturityForAdult < 0)
         {
            throw new Error("Forbidden value (" + this.maturityForAdult + ") on element maturityForAdult.");
         }
         param1.writeVarInt(this.maturityForAdult);
         if(this.energy < 0)
         {
            throw new Error("Forbidden value (" + this.energy + ") on element energy.");
         }
         param1.writeVarInt(this.energy);
         if(this.energyMax < 0)
         {
            throw new Error("Forbidden value (" + this.energyMax + ") on element energyMax.");
         }
         param1.writeVarInt(this.energyMax);
         param1.writeInt(this.serenity);
         param1.writeInt(this.aggressivityMax);
         if(this.serenityMax < 0)
         {
            throw new Error("Forbidden value (" + this.serenityMax + ") on element serenityMax.");
         }
         param1.writeVarInt(this.serenityMax);
         if(this.love < 0)
         {
            throw new Error("Forbidden value (" + this.love + ") on element love.");
         }
         param1.writeVarInt(this.love);
         if(this.loveMax < 0)
         {
            throw new Error("Forbidden value (" + this.loveMax + ") on element loveMax.");
         }
         param1.writeVarInt(this.loveMax);
         param1.writeInt(this.fecondationTime);
         if(this.boostLimiter < 0)
         {
            throw new Error("Forbidden value (" + this.boostLimiter + ") on element boostLimiter.");
         }
         param1.writeInt(this.boostLimiter);
         if(this.boostMax < -9007199254740990 || this.boostMax > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.boostMax + ") on element boostMax.");
         }
         param1.writeDouble(this.boostMax);
         param1.writeInt(this.reproductionCount);
         if(this.reproductionCountMax < 0)
         {
            throw new Error("Forbidden value (" + this.reproductionCountMax + ") on element reproductionCountMax.");
         }
         param1.writeVarInt(this.reproductionCountMax);
         if(this.harnessGID < 0)
         {
            throw new Error("Forbidden value (" + this.harnessGID + ") on element harnessGID.");
         }
         param1.writeVarShort(this.harnessGID);
         param1.writeShort(this.effectList.length);
         var _loc5_:uint = 0;
         while(_loc5_ < this.effectList.length)
         {
            (this.effectList[_loc5_] as ObjectEffectInteger).serializeAs_ObjectEffectInteger(param1);
            _loc5_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MountClientData(param1);
      }
      
      public function deserializeAs_MountClientData(param1:ICustomDataInput) : void
      {
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:ObjectEffectInteger = null;
         var _loc2_:uint = param1.readByte();
         this.sex = BooleanByteWrapper.getFlag(_loc2_,0);
         this.isRideable = BooleanByteWrapper.getFlag(_loc2_,1);
         this.isWild = BooleanByteWrapper.getFlag(_loc2_,2);
         this.isFecondationReady = BooleanByteWrapper.getFlag(_loc2_,3);
         this.useHarnessColors = BooleanByteWrapper.getFlag(_loc2_,4);
         this.id = param1.readDouble();
         if(this.id < -9007199254740990 || this.id > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of MountClientData.id.");
         }
         this.model = param1.readVarUhInt();
         if(this.model < 0)
         {
            throw new Error("Forbidden value (" + this.model + ") on element of MountClientData.model.");
         }
         var _loc3_:uint = param1.readUnsignedShort();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc9_ = param1.readInt();
            if(_loc9_ < 0)
            {
               throw new Error("Forbidden value (" + _loc9_ + ") on elements of ancestor.");
            }
            this.ancestor.push(_loc9_);
            _loc4_++;
         }
         var _loc5_:uint = param1.readUnsignedShort();
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc10_ = param1.readInt();
            if(_loc10_ < 0)
            {
               throw new Error("Forbidden value (" + _loc10_ + ") on elements of behaviors.");
            }
            this.behaviors.push(_loc10_);
            _loc6_++;
         }
         this.name = param1.readUTF();
         this.ownerId = param1.readInt();
         if(this.ownerId < 0)
         {
            throw new Error("Forbidden value (" + this.ownerId + ") on element of MountClientData.ownerId.");
         }
         this.experience = param1.readVarUhLong();
         if(this.experience < 0 || this.experience > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element of MountClientData.experience.");
         }
         this.experienceForLevel = param1.readVarUhLong();
         if(this.experienceForLevel < 0 || this.experienceForLevel > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experienceForLevel + ") on element of MountClientData.experienceForLevel.");
         }
         this.experienceForNextLevel = param1.readDouble();
         if(this.experienceForNextLevel < -9007199254740990 || this.experienceForNextLevel > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experienceForNextLevel + ") on element of MountClientData.experienceForNextLevel.");
         }
         this.level = param1.readByte();
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of MountClientData.level.");
         }
         this.maxPods = param1.readVarUhInt();
         if(this.maxPods < 0)
         {
            throw new Error("Forbidden value (" + this.maxPods + ") on element of MountClientData.maxPods.");
         }
         this.stamina = param1.readVarUhInt();
         if(this.stamina < 0)
         {
            throw new Error("Forbidden value (" + this.stamina + ") on element of MountClientData.stamina.");
         }
         this.staminaMax = param1.readVarUhInt();
         if(this.staminaMax < 0)
         {
            throw new Error("Forbidden value (" + this.staminaMax + ") on element of MountClientData.staminaMax.");
         }
         this.maturity = param1.readVarUhInt();
         if(this.maturity < 0)
         {
            throw new Error("Forbidden value (" + this.maturity + ") on element of MountClientData.maturity.");
         }
         this.maturityForAdult = param1.readVarUhInt();
         if(this.maturityForAdult < 0)
         {
            throw new Error("Forbidden value (" + this.maturityForAdult + ") on element of MountClientData.maturityForAdult.");
         }
         this.energy = param1.readVarUhInt();
         if(this.energy < 0)
         {
            throw new Error("Forbidden value (" + this.energy + ") on element of MountClientData.energy.");
         }
         this.energyMax = param1.readVarUhInt();
         if(this.energyMax < 0)
         {
            throw new Error("Forbidden value (" + this.energyMax + ") on element of MountClientData.energyMax.");
         }
         this.serenity = param1.readInt();
         this.aggressivityMax = param1.readInt();
         this.serenityMax = param1.readVarUhInt();
         if(this.serenityMax < 0)
         {
            throw new Error("Forbidden value (" + this.serenityMax + ") on element of MountClientData.serenityMax.");
         }
         this.love = param1.readVarUhInt();
         if(this.love < 0)
         {
            throw new Error("Forbidden value (" + this.love + ") on element of MountClientData.love.");
         }
         this.loveMax = param1.readVarUhInt();
         if(this.loveMax < 0)
         {
            throw new Error("Forbidden value (" + this.loveMax + ") on element of MountClientData.loveMax.");
         }
         this.fecondationTime = param1.readInt();
         this.boostLimiter = param1.readInt();
         if(this.boostLimiter < 0)
         {
            throw new Error("Forbidden value (" + this.boostLimiter + ") on element of MountClientData.boostLimiter.");
         }
         this.boostMax = param1.readDouble();
         if(this.boostMax < -9007199254740990 || this.boostMax > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.boostMax + ") on element of MountClientData.boostMax.");
         }
         this.reproductionCount = param1.readInt();
         this.reproductionCountMax = param1.readVarUhInt();
         if(this.reproductionCountMax < 0)
         {
            throw new Error("Forbidden value (" + this.reproductionCountMax + ") on element of MountClientData.reproductionCountMax.");
         }
         this.harnessGID = param1.readVarUhShort();
         if(this.harnessGID < 0)
         {
            throw new Error("Forbidden value (" + this.harnessGID + ") on element of MountClientData.harnessGID.");
         }
         var _loc7_:uint = param1.readUnsignedShort();
         var _loc8_:uint = 0;
         while(_loc8_ < _loc7_)
         {
            _loc11_ = new ObjectEffectInteger();
            _loc11_.deserialize(param1);
            this.effectList.push(_loc11_);
            _loc8_++;
         }
      }
   }
}
