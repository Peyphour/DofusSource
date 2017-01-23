package
{
   import adminMenu.AdminMenu;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.data.ContextMenuData;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FileApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.OpeningContextMenu;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import ui.AdminSelectItem;
   
   public class Admin extends Sprite
   {
      
      private static var _self:Admin;
      
      private static var _adminMenu:AdminMenu;
       
      
      private var _include_SelectItem:AdminSelectItem = null;
      
      public var fileApi:FileApi;
      
      public var sysApi:SystemApi;
      
      public var roleplayApi:RoleplayApi;
      
      public var uiApi:UiApi;
      
      public var playedCharacterApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var contextMod:Object;
      
      [Module(name="Ankama_Console")]
      public var consoleMod:Object;
      
      public function Admin()
      {
         super();
      }
      
      public static function getInstance() : Admin
      {
         return _self;
      }
      
      public function main(... rest) : void
      {
         if(!this.sysApi.hasRight())
         {
            return;
         }
         _self = this;
         Api.fileApi = this.fileApi;
         Api.uiApi = this.uiApi;
         Api.systemApi = this.sysApi;
         Api.dataApi = this.dataApi;
         Api.contextMod = this.contextMod;
         Api.consoleMod = this.consoleMod;
         _adminMenu = new AdminMenu();
         this.sysApi.addHook(MapComplementaryInformationsData,this.onGameStart);
         this.sysApi.addHook(OpeningContextMenu,this.onOpeningContextMenu);
      }
      
      public function reloadXml() : void
      {
         _adminMenu = new AdminMenu();
      }
      
      private function onOpeningContextMenu(param1:ContextMenuData) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Dictionary = null;
         var _loc7_:Object = null;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         if(param1)
         {
            _loc2_ = new Object();
            _loc2_.m = this.playedCharacterApi.currentMap().mapId;
            _loc2_.n = this.playedCharacterApi.getPlayedCharacterInfo().name;
            _loc2_.s = this.sysApi.getCurrentServer().name;
            _loc2_.v = this.sysApi.getCurrentVersion();
            if(param1.makerName == "player")
            {
               if(param1.data)
               {
                  _loc5_ = param1.data;
                  if(_loc5_.hasOwnProperty("name"))
                  {
                     _loc2_.p = _loc5_.name;
                  }
                  if(_loc5_ is String)
                  {
                     _loc2_.p = _loc5_;
                  }
                  if(_loc5_.hasOwnProperty("humanoidInfo") && _loc5_.humanoidInfo.hasOwnProperty("guildInformations") && _loc5_.humanoidInfo.guildInformations && _loc5_.humanoidInfo.guildInformations.guildName)
                  {
                     _loc2_.g = _loc5_.humanoidInfo.guildInformations.guildName;
                  }
               }
               _loc3_ = _adminMenu.process(_loc2_);
               for each(_loc4_ in _loc3_)
               {
                  param1.content.push(_loc4_);
               }
            }
            else if(param1.makerName == "multiplayer")
            {
               _loc6_ = new Dictionary();
               _loc7_ = this.roleplayApi.getEntityByName(param1.data.name);
               _loc8_ = _loc7_.position.cellId;
               _loc9_ = this.roleplayApi.getEntitiesOnCell(_loc8_);
               for each(_loc7_ in _loc9_)
               {
                  if(_loc7_.id > 0)
                  {
                     _loc11_ = this.roleplayApi.getEntityInfos(_loc7_);
                     if(!_loc11_.hasOwnProperty("fight"))
                     {
                        _loc6_[_loc11_.name] = _loc11_;
                     }
                  }
               }
               for each(_loc10_ in param1.content)
               {
                  _loc2_ = new Object();
                  _loc5_ = _loc6_[_loc10_.label];
                  if(_loc5_.hasOwnProperty("name"))
                  {
                     _loc2_.p = _loc5_.name;
                  }
                  if(_loc5_ is String)
                  {
                     _loc2_.p = _loc5_;
                  }
                  if(_loc5_.hasOwnProperty("humanoidInfo") && _loc5_.humanoidInfo.hasOwnProperty("guildInformations") && _loc5_.humanoidInfo.guildInformations && _loc5_.humanoidInfo.guildInformations.guildName)
                  {
                     _loc2_.g = _loc5_.humanoidInfo.guildInformations.guildName;
                  }
                  _loc10_.child = _loc10_.child.concat(_adminMenu.process(_loc2_));
               }
            }
         }
      }
      
      private function onGameStart(... rest) : void
      {
         this.sysApi.removeHook(MapComplementaryInformationsData);
         _adminMenu.onStart();
      }
   }
}
