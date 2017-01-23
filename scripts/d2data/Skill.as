package d2data
{
   import utils.ReadOnlyData;
   
   public class Skill extends ReadOnlyData
   {
       
      
      public function Skill(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get parentJobId() : int
      {
         return _target.parentJobId;
      }
      
      public function get isForgemagus() : Boolean
      {
         return _target.isForgemagus;
      }
      
      public function get modifiableItemTypeIds() : Object
      {
         return secure(_target.modifiableItemTypeIds);
      }
      
      public function get gatheredRessourceItem() : int
      {
         return _target.gatheredRessourceItem;
      }
      
      public function get craftableItemIds() : Object
      {
         return secure(_target.craftableItemIds);
      }
      
      public function get interactiveId() : int
      {
         return _target.interactiveId;
      }
      
      public function get useAnimation() : String
      {
         return _target.useAnimation;
      }
      
      public function get cursor() : int
      {
         return _target.cursor;
      }
      
      public function get elementActionId() : int
      {
         return _target.elementActionId;
      }
      
      public function get availableInHouse() : Boolean
      {
         return _target.availableInHouse;
      }
      
      public function get levelMin() : uint
      {
         return _target.levelMin;
      }
      
      public function get clientDisplay() : Boolean
      {
         return _target.clientDisplay;
      }
   }
}
