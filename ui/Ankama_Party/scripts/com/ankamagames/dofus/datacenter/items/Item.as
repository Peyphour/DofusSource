package com.ankamagames.dofus.datacenter.items
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.criterion.GroupItemCriterion;
   
   public class Item
   {
       
      
      public function Item()
      {
         super();
      }
      
      public function get id() : int
      {
         return new int();
      }
      
      public function get nameId() : uint
      {
         return new uint();
      }
      
      public function get typeId() : uint
      {
         return new uint();
      }
      
      public function get descriptionId() : uint
      {
         return new uint();
      }
      
      public function get iconId() : uint
      {
         return new uint();
      }
      
      public function get level() : uint
      {
         return new uint();
      }
      
      public function get realWeight() : uint
      {
         return new uint();
      }
      
      public function get cursed() : Boolean
      {
         return new Boolean();
      }
      
      public function get useAnimationId() : int
      {
         return new int();
      }
      
      public function get usable() : Boolean
      {
         return new Boolean();
      }
      
      public function get targetable() : Boolean
      {
         return new Boolean();
      }
      
      public function get exchangeable() : Boolean
      {
         return new Boolean();
      }
      
      public function get price() : Number
      {
         return new Number();
      }
      
      public function get twoHanded() : Boolean
      {
         return new Boolean();
      }
      
      public function get etheral() : Boolean
      {
         return new Boolean();
      }
      
      public function get itemSetId() : int
      {
         return new int();
      }
      
      public function get criteria() : String
      {
         return new String();
      }
      
      public function get criteriaTarget() : String
      {
         return new String();
      }
      
      public function get hideEffects() : Boolean
      {
         return new Boolean();
      }
      
      public function get enhanceable() : Boolean
      {
         return new Boolean();
      }
      
      public function get nonUsableOnAnother() : Boolean
      {
         return new Boolean();
      }
      
      public function get appearanceId() : uint
      {
         return new uint();
      }
      
      public function get secretRecipe() : Boolean
      {
         return new Boolean();
      }
      
      public function get dropMonsterIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get recipeSlots() : uint
      {
         return new uint();
      }
      
      public function get recipeIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get bonusIsSecret() : Boolean
      {
         return new Boolean();
      }
      
      public function get possibleEffects() : Vector.<EffectInstance>
      {
         return new Vector.<EffectInstance>();
      }
      
      public function get favoriteSubAreas() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get favoriteSubAreasBonus() : uint
      {
         return new uint();
      }
      
      public function get craftXpRatio() : int
      {
         return new int();
      }
      
      public function get needUseConfirm() : Boolean
      {
         return new Boolean();
      }
      
      public function get isDestructible() : Boolean
      {
         return new Boolean();
      }
      
      public function get nuggetsBySubarea() : Object
      {
         return new Object();
      }
      
      public function get containerIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get resourcesBySubarea() : Object
      {
         return new Object();
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get undiatricalName() : String
      {
         return null;
      }
      
      public function get description() : String
      {
         return null;
      }
      
      public function get weight() : uint
      {
         return 0;
      }
      
      public function get type() : Object
      {
         return null;
      }
      
      public function get isWeapon() : Boolean
      {
         return false;
      }
      
      public function get itemSet() : ItemSet
      {
         return null;
      }
      
      public function get appearance() : Object
      {
         return null;
      }
      
      public function get recipes() : Array
      {
         return null;
      }
      
      public function get category() : uint
      {
         return 0;
      }
      
      public function get isEquipable() : Boolean
      {
         return false;
      }
      
      public function get canEquip() : Boolean
      {
         return false;
      }
      
      public function get conditions() : GroupItemCriterion
      {
         return null;
      }
      
      public function get targetConditions() : GroupItemCriterion
      {
         return null;
      }
      
      public function get nuggetsQuantity() : Number
      {
         return 0;
      }
   }
}
