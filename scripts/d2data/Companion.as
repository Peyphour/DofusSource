package d2data
{
   import utils.ReadOnlyData;
   
   public class Companion extends ReadOnlyData
   {
       
      
      public function Companion(param1:*, param2:Object)
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
      
      public function get look() : String
      {
         return _target.look;
      }
      
      public function get webDisplay() : Boolean
      {
         return _target.webDisplay;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get startingSpellLevelId() : uint
      {
         return _target.startingSpellLevelId;
      }
      
      public function get assetId() : uint
      {
         return _target.assetId;
      }
      
      public function get characteristics() : Object
      {
         return secure(_target.characteristics);
      }
      
      public function get spells() : Object
      {
         return secure(_target.spells);
      }
      
      public function get creatureBoneId() : int
      {
         return _target.creatureBoneId;
      }
   }
}
