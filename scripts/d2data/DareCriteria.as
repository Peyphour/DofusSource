package d2data
{
   import utils.ReadOnlyData;
   
   public class DareCriteria extends ReadOnlyData
   {
       
      
      public function DareCriteria(param1:*, param2:Object)
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
      
      public function get maxOccurence() : uint
      {
         return _target.maxOccurence;
      }
      
      public function get maxParameters() : uint
      {
         return _target.maxParameters;
      }
      
      public function get minParameterBound() : int
      {
         return _target.minParameterBound;
      }
      
      public function get maxParameterBound() : int
      {
         return _target.maxParameterBound;
      }
   }
}
