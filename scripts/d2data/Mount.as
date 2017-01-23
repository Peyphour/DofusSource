package d2data
{
   import utils.ReadOnlyData;
   
   public class Mount extends ReadOnlyData
   {
       
      
      public function Mount(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get familyId() : uint
      {
         return _target.familyId;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get look() : String
      {
         return _target.look;
      }
   }
}
