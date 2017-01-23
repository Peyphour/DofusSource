package makers
{
   public class PartyMemberMenuMaker extends PlayerMenuMaker
   {
       
      
      public function PartyMemberMenuMaker()
      {
         super();
      }
      
      override public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:String = param1.name;
         var _loc4_:Number = param1.id;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Boolean = param1.onSameMap;
         if(_loc7_)
         {
            _loc5_ = param1.alignmentInfos;
         }
         if(param1.hasOwnProperty("guildInformations"))
         {
            _loc6_ = param1.guildInformations;
         }
         _partyId = int(param2);
         return super.createMenu2(_loc3_,_loc4_,false,_loc5_,param1.guildInformations,null,null,0,param1.cantBeChallenged,param1.cantExchange);
      }
   }
}
