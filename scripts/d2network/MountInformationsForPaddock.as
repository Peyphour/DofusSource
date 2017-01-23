package d2network
{
   import utils.ReadOnlyData;
   
   public class MountInformationsForPaddock extends ReadOnlyData
   {
       
      
      public function MountInformationsForPaddock(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get modelId() : uint
      {
         return _target.modelId;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get ownerName() : String
      {
         return _target.ownerName;
      }
   }
}
