package d2network
{
   public class VersionExtended extends Version
   {
       
      
      public function VersionExtended(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get install() : uint
      {
         return _target.install;
      }
      
      public function get technology() : uint
      {
         return _target.technology;
      }
   }
}
