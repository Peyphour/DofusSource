package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   
   public class ItemWrapper extends Item
   {
       
      
      public function ItemWrapper()
      {
         super();
      }
      
      public function get position() : uint
      {
         return new uint();
      }
      
      public function get sortOrder() : uint
      {
         return new uint();
      }
      
      public function get objectUID() : uint
      {
         return new uint();
      }
      
      public function get objectGID() : uint
      {
         return new uint();
      }
      
      public function get quantity() : uint
      {
         return new uint();
      }
      
      public function get effects() : Vector.<EffectInstance>
      {
         return new Vector.<EffectInstance>();
      }
      
      public function get effectsList() : Vector.<ObjectEffect>
      {
         return new Vector.<ObjectEffect>();
      }
      
      public function get livingObjectId() : uint
      {
         return new uint();
      }
      
      public function get livingObjectMood() : uint
      {
         return new uint();
      }
      
      public function get livingObjectSkin() : uint
      {
         return new uint();
      }
      
      public function get livingObjectCategory() : uint
      {
         return new uint();
      }
      
      public function get livingObjectXp() : uint
      {
         return new uint();
      }
      
      public function get livingObjectMaxXp() : uint
      {
         return new uint();
      }
      
      public function get livingObjectLevel() : uint
      {
         return new uint();
      }
      
      public function get livingObjectFoodDate() : String
      {
         return new String();
      }
      
      public function get wrapperObjectCategory() : uint
      {
         return new uint();
      }
      
      public function get presetIcon() : int
      {
         return new int();
      }
      
      public function get exchangeAllowed() : Boolean
      {
         return new Boolean();
      }
      
      public function get isPresetObject() : Boolean
      {
         return new Boolean();
      }
      
      public function get isOkForMultiUse() : Boolean
      {
         return new Boolean();
      }
      
      public function get iconUri() : Object
      {
         return null;
      }
      
      public function get fullSizeIconUri() : Object
      {
         return null;
      }
      
      public function get backGroundIconUri() : Object
      {
         return null;
      }
      
      public function get forcedBackGroundIconUri() : Object
      {
         return null;
      }
      
      public function get errorIconUri() : Object
      {
         return null;
      }
      
      public function get fullSizeErrorIconUri() : Object
      {
         return null;
      }
      
      public function get isSpeakingObject() : Boolean
      {
         return false;
      }
      
      public function get isLivingObject() : Boolean
      {
         return false;
      }
      
      public function get isWrapperObject() : Boolean
      {
         return false;
      }
      
      public function get isObjectWrapped() : Boolean
      {
         return false;
      }
      
      public function get isMimicryObject() : Boolean
      {
         return false;
      }
      
      public function get info1() : String
      {
         return null;
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get active() : Boolean
      {
         return false;
      }
      
      public function get minimalRange() : uint
      {
         return 0;
      }
      
      public function get maximalRange() : uint
      {
         return 0;
      }
      
      public function get castZoneInLine() : Boolean
      {
         return false;
      }
      
      public function get castZoneInDiagonal() : Boolean
      {
         return false;
      }
      
      public function get spellZoneEffects() : Object
      {
         return null;
      }
      
      public function get isCertificate() : Boolean
      {
         return false;
      }
      
      public function get isEquipment() : Boolean
      {
         return false;
      }
      
      public function get isUsable() : Boolean
      {
         return false;
      }
      
      public function get belongsToSet() : Boolean
      {
         return false;
      }
      
      public function get favoriteEffect() : Object
      {
         return null;
      }
      
      public function get setCount() : int
      {
         return 0;
      }
      
      public function get shortName() : String
      {
         return null;
      }
      
      public function get realName() : String
      {
         return null;
      }
      
      public function get linked() : Boolean
      {
         return false;
      }
      
      public function get searchContent() : String
      {
         return null;
      }
   }
}
