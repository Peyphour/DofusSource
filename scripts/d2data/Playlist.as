package d2data
{
   import utils.ReadOnlyData;
   
   public class Playlist extends ReadOnlyData
   {
       
      
      public function Playlist(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get silenceDuration() : int
      {
         return _target.silenceDuration;
      }
      
      public function get iteration() : int
      {
         return _target.iteration;
      }
      
      public function get type() : int
      {
         return _target.type;
      }
      
      public function get sounds() : Object
      {
         return secure(_target.sounds);
      }
   }
}
