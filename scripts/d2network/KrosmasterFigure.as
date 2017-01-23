package d2network
{
   import utils.ReadOnlyData;
   
   public class KrosmasterFigure extends ReadOnlyData
   {
       
      
      public function KrosmasterFigure(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get uid() : String
      {
         return _target.uid;
      }
      
      public function get figure() : uint
      {
         return _target.figure;
      }
      
      public function get pedestal() : uint
      {
         return _target.pedestal;
      }
      
      public function get bound() : Boolean
      {
         return _target.bound;
      }
   }
}
