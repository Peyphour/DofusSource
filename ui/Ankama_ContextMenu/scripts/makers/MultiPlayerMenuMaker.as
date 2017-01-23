package makers
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   
   public class MultiPlayerMenuMaker
   {
       
      
      public function MultiPlayerMenuMaker()
      {
         super();
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc3_:Object = param2[0];
         var _loc4_:Array = new Array();
         var _loc5_:uint = param2[0].position.cellId;
         var _loc6_:Object = Api.roleplay.getEntitiesOnCell(_loc5_);
         var _loc7_:PlayerMenuMaker = new PlayerMenuMaker();
         var _loc8_:HumanVendorMenuMaker = new HumanVendorMenuMaker();
         for each(_loc9_ in _loc6_)
         {
            if(_loc9_.id > 0)
            {
               _loc10_ = Api.roleplay.getEntityInfos(_loc9_);
               if(_loc10_)
               {
                  if(_loc10_ is GameRolePlayMerchantInformations)
                  {
                     _loc11_ = _loc8_.createMenu(_loc10_,[_loc9_]);
                  }
                  else
                  {
                     _loc11_ = _loc7_.createMenu(_loc10_,[_loc9_]);
                  }
                  if(!_loc10_.hasOwnProperty("fight"))
                  {
                     _loc4_.push(Api.modMenu.createContextMenuItemObject(_loc10_.name,this.onPutOnTop,[_loc9_],false,_loc11_));
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private function onPutOnTop(param1:Object) : void
      {
         Api.roleplay.putEntityOnTop(param1);
      }
   }
}
