package com.ankamagames.dofus.datacenter.monsters
{
   public class Monster
   {
       
      
      public function Monster()
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
      
      public function get gfxId() : uint
      {
         return new uint();
      }
      
      public function get race() : int
      {
         return new int();
      }
      
      public function get grades() : Vector.<MonsterGrade>
      {
         return new Vector.<MonsterGrade>();
      }
      
      public function get look() : String
      {
         return new String();
      }
      
      public function get useSummonSlot() : Boolean
      {
         return new Boolean();
      }
      
      public function get useBombSlot() : Boolean
      {
         return new Boolean();
      }
      
      public function get canPlay() : Boolean
      {
         return new Boolean();
      }
      
      public function get canTackle() : Boolean
      {
         return new Boolean();
      }
      
      public function get animFunList() : Object
      {
         return new Object();
      }
      
      public function get isBoss() : Boolean
      {
         return new Boolean();
      }
      
      public function get drops() : Vector.<MonsterDrop>
      {
         return new Vector.<MonsterDrop>();
      }
      
      public function get subareas() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get spells() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get favoriteSubareaId() : int
      {
         return new int();
      }
      
      public function get isMiniBoss() : Boolean
      {
         return new Boolean();
      }
      
      public function get isQuestMonster() : Boolean
      {
         return new Boolean();
      }
      
      public function get correspondingMiniBossId() : uint
      {
         return new uint();
      }
      
      public function get speedAdjust() : Number
      {
         return new Number();
      }
      
      public function get creatureBoneId() : int
      {
         return new int();
      }
      
      public function get canBePushed() : Boolean
      {
         return new Boolean();
      }
      
      public function get fastAnimsFun() : Boolean
      {
         return new Boolean();
      }
      
      public function get canSwitchPos() : Boolean
      {
         return new Boolean();
      }
      
      public function get incompatibleIdols() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get allIdolsDisabled() : Boolean
      {
         return new Boolean();
      }
      
      public function get dareAvailable() : Boolean
      {
         return new Boolean();
      }
      
      public function get incompatibleChallenges() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get undiatricalName() : String
      {
         return null;
      }
      
      public function get type() : MonsterRace
      {
         return null;
      }
   }
}
