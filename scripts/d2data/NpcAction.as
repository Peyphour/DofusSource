package d2data
{
   import utils.ReadOnlyData;
   
   public class NpcAction extends ReadOnlyData
   {
       
      
      public function NpcAction(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get realId() : int
      {
         return _target.realId;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
   }
}
