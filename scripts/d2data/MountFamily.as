package d2data
{
   import utils.ReadOnlyData;
   
   public class MountFamily extends ReadOnlyData
   {
       
      
      public function MountFamily(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get headUri() : String
      {
         return _target.headUri;
      }
   }
}
