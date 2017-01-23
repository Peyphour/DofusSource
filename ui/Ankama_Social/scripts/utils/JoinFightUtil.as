package utils
{
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import d2actions.GuildFightJoinRequest;
   import d2actions.GuildFightLeaveRequest;
   import d2actions.GuildFightTakePlaceRequest;
   import d2actions.PrismFightJoinLeaveRequest;
   import d2actions.PrismFightSwapRequest;
   
   public class JoinFightUtil
   {
      
      private static const TYPE_TAX_COLLECTOR:int = 0;
      
      private static const TYPE_PRISM:int = 1;
       
      
      public function JoinFightUtil()
      {
         super();
      }
      
      public static function join(param1:int, param2:int) : void
      {
         if(Api.social.isPlayerDefender(param1,Api.player.id(),param2))
         {
            leave(param1,param2);
         }
         else if(param1 == TYPE_TAX_COLLECTOR)
         {
            Api.system.sendAction(new GuildFightJoinRequest(param2));
         }
         else if(param1 == TYPE_PRISM)
         {
            Api.system.sendAction(new PrismFightJoinLeaveRequest(param2,true));
         }
      }
      
      public static function leave(param1:int, param2:int) : void
      {
         if(param1 == TYPE_TAX_COLLECTOR)
         {
            Api.system.sendAction(new GuildFightLeaveRequest(param2,Api.player.id()));
         }
         else if(param1 == TYPE_PRISM)
         {
            Api.system.sendAction(new PrismFightJoinLeaveRequest(param2,false));
         }
      }
      
      public static function swapPlaces(param1:int, param2:int, param3:CharacterMinimalPlusLookInformations) : void
      {
         if(param1 == TYPE_TAX_COLLECTOR)
         {
            Api.system.sendAction(new GuildFightTakePlaceRequest(param2,param3.id));
         }
         else if(param1 == TYPE_PRISM)
         {
            Api.system.sendAction(new PrismFightSwapRequest(param2,param3.id));
         }
      }
   }
}
