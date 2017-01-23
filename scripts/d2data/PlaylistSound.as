package d2data
{
   import utils.ReadOnlyData;
   
   public class PlaylistSound extends ReadOnlyData
   {
       
      
      public function PlaylistSound(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : String
      {
         return _target.id;
      }
      
      public function get volume() : int
      {
         return _target.volume;
      }
      
      public function get channel() : int
      {
         return _target.channel;
      }
   }
}
