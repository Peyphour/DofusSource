package d2data
{
   import utils.ReadOnlyData;
   
   public class SpellPair extends ReadOnlyData
   {
       
      
      public function SpellPair(param1:*, param2:Object)
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
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get iconId() : uint
      {
         return _target.iconId;
      }
   }
}
