package com.ankamagames.dofus.datacenter.quest.treasureHunt
{
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   
   public class LegendaryTreasureHunt
   {
       
      
      public function LegendaryTreasureHunt()
      {
         super();
      }
      
      public function get id() : uint
      {
         return new uint();
      }
      
      public function get nameId() : uint
      {
         return new uint();
      }
      
      public function get level() : uint
      {
         return new uint();
      }
      
      public function get chestId() : uint
      {
         return new uint();
      }
      
      public function get monsterId() : uint
      {
         return new uint();
      }
      
      public function get mapItemId() : uint
      {
         return new uint();
      }
      
      public function get xpRatio() : Number
      {
         return new Number();
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get monster() : Monster
      {
         return null;
      }
      
      public function get chest() : Item
      {
         return null;
      }
      
      public function get experienceReward() : int
      {
         return 0;
      }
   }
}
