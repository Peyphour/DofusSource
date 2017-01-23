package makers
{
   import contextMenu.ContextMenuItem;
   import d2actions.InteractiveElementActivation;
   
   public class SkillMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function SkillMenuMaker()
      {
         super();
      }
      
      private function onSkillClicked(param1:Object, param2:uint) : void
      {
         Api.system.sendAction(new InteractiveElementActivation(param1.element,param1.position,param2));
      }
      
      private function onDisabledSkillClicked(param1:Object, param2:uint) : void
      {
         Api.modCommon.openPopup(Api.ui.getText("ui.popup.warning"),Api.ui.getText("ui.skill.disabled"),[Api.ui.getText("ui.common.ok")],null);
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc6_:ContextMenuItem = null;
         var _loc7_:Array = null;
         var _loc8_:Boolean = false;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         var _loc5_:Object = Api.data.getHouseInformations(param2[0].element.elementId);
         if(_loc5_)
         {
            _loc10_ = null;
            if(_loc5_.ownerName == Api.player.getPlayedCharacterInfo().name)
            {
               _loc10_ = Api.ui.getText("ui.house.myHome");
            }
            else if(_loc5_.ownerName != "")
            {
               _loc10_ = Api.ui.getText("ui.house.homeOf",_loc5_.ownerName);
            }
            _loc11_ = _loc5_.name;
            if(_loc10_)
            {
               _loc11_ = _loc11_ + (" - " + _loc10_);
            }
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc11_));
         }
         else if(param2[1])
         {
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(param2[1].name));
         }
         for each(_loc9_ in param1)
         {
            _loc8_ = disabled || !_loc9_.enabled || _loc4_;
            _loc7_ = [param2[0],_loc9_.instanceId];
            _loc6_ = ContextMenu.static_createContextMenuItemObject(_loc9_.name,this.onSkillClicked,[param2[0],_loc9_.instanceId],_loc8_);
            if(_loc8_)
            {
               _loc6_.addDisabledCallback(this.onDisabledSkillClicked,_loc7_);
            }
            _loc3_.push(_loc6_);
         }
         return _loc3_;
      }
   }
}
