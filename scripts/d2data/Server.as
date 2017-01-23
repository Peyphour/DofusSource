package d2data
{
   import utils.ReadOnlyData;
   
   public class Server extends ReadOnlyData
   {
       
      
      public function Server(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get commentId() : uint
      {
         return _target.commentId;
      }
      
      public function get openingDate() : Number
      {
         return _target.openingDate;
      }
      
      public function get language() : String
      {
         return _target.language;
      }
      
      public function get populationId() : int
      {
         return _target.populationId;
      }
      
      public function get gameTypeId() : uint
      {
         return _target.gameTypeId;
      }
      
      public function get communityId() : int
      {
         return _target.communityId;
      }
      
      public function get restrictedToLanguages() : Object
      {
         return secure(_target.restrictedToLanguages);
      }
   }
}
