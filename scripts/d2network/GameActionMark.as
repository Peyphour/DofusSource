package d2network
{
   import utils.ReadOnlyData;
   
   public class GameActionMark extends ReadOnlyData
   {
       
      
      public function GameActionMark(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get markAuthorId() : Number
      {
         return _target.markAuthorId;
      }
      
      public function get markTeamId() : uint
      {
         return _target.markTeamId;
      }
      
      public function get markSpellId() : uint
      {
         return _target.markSpellId;
      }
      
      public function get markSpellLevel() : uint
      {
         return _target.markSpellLevel;
      }
      
      public function get markId() : int
      {
         return _target.markId;
      }
      
      public function get markType() : int
      {
         return _target.markType;
      }
      
      public function get markimpactCell() : int
      {
         return _target.markimpactCell;
      }
      
      public function get cells() : Object
      {
         return secure(_target.cells);
      }
      
      public function get active() : Boolean
      {
         return _target.active;
      }
   }
}
