package d2data
{
   public class AmbientSound extends PlaylistSound
   {
       
      
      public function AmbientSound(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get criterionId() : int
      {
         return _target.criterionId;
      }
      
      public function get silenceMin() : uint
      {
         return _target.silenceMin;
      }
      
      public function get silenceMax() : uint
      {
         return _target.silenceMax;
      }
      
      public function get type_id() : int
      {
         return _target.type_id;
      }
   }
}
