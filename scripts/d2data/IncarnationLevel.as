package d2data
{
   import utils.ReadOnlyData;
   
   public class IncarnationLevel extends ReadOnlyData
   {
       
      
      public function IncarnationLevel(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get incarnationId() : int
      {
         return _target.incarnationId;
      }
      
      public function get level() : int
      {
         return _target.level;
      }
      
      public function get requiredXp() : uint
      {
         return _target.requiredXp;
      }
   }
}
