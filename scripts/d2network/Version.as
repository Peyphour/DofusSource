package d2network
{
   import utils.ReadOnlyData;
   
   public class Version extends ReadOnlyData
   {
       
      
      public function Version(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get major() : uint
      {
         return _target.major;
      }
      
      public function get minor() : uint
      {
         return _target.minor;
      }
      
      public function get release() : uint
      {
         return _target.release;
      }
      
      public function get revision() : uint
      {
         return _target.revision;
      }
      
      public function get patch() : uint
      {
         return _target.patch;
      }
      
      public function get buildType() : uint
      {
         return _target.buildType;
      }
   }
}
