package d2data
{
   import utils.ReadOnlyData;
   
   public class ItemType extends ReadOnlyData
   {
       
      
      public function ItemType(param1:*, param2:Object)
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
      
      public function get superTypeId() : uint
      {
         return _target.superTypeId;
      }
      
      public function get plural() : Boolean
      {
         return _target.plural;
      }
      
      public function get gender() : uint
      {
         return _target.gender;
      }
      
      public function get rawZone() : String
      {
         return _target.rawZone;
      }
      
      public function get mimickable() : Boolean
      {
         return _target.mimickable;
      }
      
      public function get craftXpRatio() : int
      {
         return _target.craftXpRatio;
      }
   }
}
