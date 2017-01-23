package d2data
{
   import utils.ReadOnlyData;
   
   public class SmileyCategory extends ReadOnlyData
   {
       
      
      public function SmileyCategory(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get gfxId() : String
      {
         return _target.gfxId;
      }
      
      public function get isFake() : Boolean
      {
         return _target.isFake;
      }
   }
}
