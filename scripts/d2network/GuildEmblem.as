package d2network
{
   import utils.ReadOnlyData;
   
   public class GuildEmblem extends ReadOnlyData
   {
       
      
      public function GuildEmblem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get symbolShape() : uint
      {
         return _target.symbolShape;
      }
      
      public function get symbolColor() : int
      {
         return _target.symbolColor;
      }
      
      public function get backgroundShape() : uint
      {
         return _target.backgroundShape;
      }
      
      public function get backgroundColor() : int
      {
         return _target.backgroundColor;
      }
   }
}
