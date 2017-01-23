package d2data
{
   import utils.ReadOnlyData;
   
   public class AlignmentTitle extends ReadOnlyData
   {
       
      
      public function AlignmentTitle(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get sideId() : int
      {
         return _target.sideId;
      }
      
      public function get namesId() : Object
      {
         return secure(_target.namesId);
      }
      
      public function get shortsId() : Object
      {
         return secure(_target.shortsId);
      }
   }
}
