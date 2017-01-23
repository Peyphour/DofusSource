package makers
{
   import d2actions.ExchangeRequestOnTaxCollector;
   import d2actions.GameRolePlayTaxCollectorFightRequest;
   import d2actions.NpcGenericActionRequest;
   import d2hooks.MouseShiftClick;
   
   public class TaxCollectorMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function TaxCollectorMenuMaker()
      {
         super();
      }
      
      private function onTalkTaxCollectorClick(param1:int) : void
      {
         Api.system.sendAction(new NpcGenericActionRequest(param1,3));
      }
      
      private function onCollectTaxCollectorClick(param1:int) : void
      {
         Api.system.sendAction(new ExchangeRequestOnTaxCollector(param1));
      }
      
      private function onAttackTaxCollectorClick(param1:int) : void
      {
         Api.system.sendAction(new GameRolePlayTaxCollectorFightRequest(param1));
      }
      
      private function insertLink(param1:String) : void
      {
         Api.system.dispatchHook(MouseShiftClick,{
            "data":"Map",
            "params":{
               "x":Api.player.currentMap().outdoorX,
               "y":Api.player.currentMap().outdoorY,
               "worldMapId":Api.player.currentSubArea().worldmap.id,
               "elementName":param1 + " "
            }
         });
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc6_:Object = null;
         var _loc7_:* = false;
         var _loc8_:Boolean = false;
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         var _loc5_:String = Api.data.getTaxCollectorFirstname(param1.identification.firstNameId).firstname + " " + Api.data.getTaxCollectorName(param1.identification.lastNameId).name;
         _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc5_));
         if(param2.rightClick)
         {
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.chat.insertCoordinates"),this.insertLink,[Api.ui.getText("ui.guild.taxCollector",param1.identification.guildIdentity.guildName)],disabled));
            return _loc3_;
         }
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.talk"),this.onTalkTaxCollectorClick,[param2.entity.id]));
         if(Api.social.hasGuild() && Api.social.getGuild().guildId == param1.identification.guildIdentity.guildId)
         {
            _loc6_ = Api.player.getPlayedCharacterInfo();
            _loc7_ = !Api.social.hasGuildRight(_loc6_.id,"collect");
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.CollectTaxCollector"),this.onCollectTaxCollectorClick,[param2.entity.id]),disabled || _loc7_ || _loc4_);
         }
         else
         {
            _loc8_ = false;
            if(param1.taxCollectorAttack != 0)
            {
               _loc8_ = true;
            }
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.attack"),this.onAttackTaxCollectorClick,[param2.entity.id],disabled || _loc8_ || _loc4_));
         }
         return _loc3_;
      }
   }
}
