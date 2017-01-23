package com.ankamagames.dofus.datacenter.quest
{
   import flash.geom.Point;
   
   public class QuestObjective
   {
       
      
      public function QuestObjective()
      {
         super();
      }
      
      public function get id() : uint
      {
         return new uint();
      }
      
      public function get stepId() : uint
      {
         return new uint();
      }
      
      public function get typeId() : uint
      {
         return new uint();
      }
      
      public function get dialogId() : int
      {
         return new int();
      }
      
      public function get parameters() : Object
      {
         return new Object();
      }
      
      public function get coords() : Point
      {
         return new Point();
      }
      
      public function get mapId() : int
      {
         return new int();
      }
      
      public function get step() : QuestStep
      {
         return null;
      }
      
      public function get type() : QuestObjectiveType
      {
         return null;
      }
      
      public function get text() : String
      {
         return null;
      }
      
      public function get dialog() : String
      {
         return null;
      }
   }
}
