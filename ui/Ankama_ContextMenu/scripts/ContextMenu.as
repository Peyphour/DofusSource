package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import contextMenu.ContextMenuItem;
   import contextMenu.ContextMenuManager;
   import contextMenu.ContextMenuPictureItem;
   import contextMenu.ContextMenuPictureLabelItem;
   import contextMenu.ContextMenuSeparator;
   import contextMenu.ContextMenuTitle;
   import d2hooks.OpeningContextMenu;
   import d2hooks.ShowPlayersNames;
   import flash.display.Sprite;
   import makers.AccountMenuMaker;
   import makers.CompanionMenuMaker;
   import makers.FightAllyMenuMaker;
   import makers.FightWorldMenuMaker;
   import makers.HumanVendorMenuMaker;
   import makers.InteractiveElementMenuMaker;
   import makers.ItemMenuMaker;
   import makers.MapFlagMenuMaker;
   import makers.MonsterGroupMenuMaker;
   import makers.MountMenuMaker;
   import makers.MultiPlayerMenuMaker;
   import makers.NpcMenuMaker;
   import makers.PaddockItemMenuMaker;
   import makers.PartyMemberMenuMaker;
   import makers.PlayerMenuMaker;
   import makers.PortalMenuMaker;
   import makers.PrismMenuMaker;
   import makers.SkillMenuMaker;
   import makers.TaxCollectorMenuMaker;
   import makers.WorldMenuMaker;
   import ui.ContextMenuUi;
   
   public class ContextMenu extends Sprite
   {
      
      private static var _self:ContextMenu;
       
      
      private var include_ContextMenuUi:ContextMenuUi = null;
      
      public var sysApi:SystemApi;
      
      public var configApi:ConfigApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var alignApi:AlignmentApi;
      
      public var fightApi:FightApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var menuApi:ContextMenuApi;
      
      public var mapApi:MapApi;
      
      public var jobsApi:JobsApi;
      
      public var socialApi:SocialApi;
      
      public var mountApi:MountApi;
      
      public var timeApi:TimeApi;
      
      public var tooltipApi:TooltipApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var roleplayApi:RoleplayApi;
      
      public var partyApi:PartyApi;
      
      public var bindsApi:BindsApi;
      
      public var storageApi:StorageApi;
      
      public var playersNamesVisible:Boolean;
      
      public function ContextMenu()
      {
         super();
      }
      
      public static function getInstance() : ContextMenu
      {
         return _self;
      }
      
      public static function static_createContextMenuTitleObject(param1:String) : ContextMenuTitle
      {
         return new ContextMenuTitle(param1);
      }
      
      public static function static_createContextMenuItemObject(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = true, param8:String = null, param9:Boolean = false, param10:uint = 1000) : ContextMenuItem
      {
         return new ContextMenuItem(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public static function static_createContextMenuPictureItemObject(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = false, param8:String = null, param9:Boolean = false, param10:uint = 1000) : ContextMenuPictureItem
      {
         return new ContextMenuPictureItem(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public static function static_createContextMenuPictureLabelItemObject(param1:String, param2:String, param3:int, param4:Boolean = false, param5:Function = null, param6:Array = null, param7:Boolean = false, param8:Array = null, param9:Boolean = false, param10:Boolean = false, param11:String = null, param12:Boolean = false, param13:uint = 1000) : ContextMenuPictureLabelItem
      {
         return new ContextMenuPictureLabelItem(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13);
      }
      
      public static function static_createContextMenuSeparatorObject() : ContextMenuSeparator
      {
         return new ContextMenuSeparator();
      }
      
      public function main() : void
      {
         _self = this;
         Api.system = this.sysApi;
         Api.config = this.configApi;
         Api.ui = this.uiApi;
         Api.menu = this.menuApi;
         Api.data = this.dataApi;
         Api.alignment = this.alignApi;
         Api.fight = this.fightApi;
         Api.player = this.playerApi;
         Api.map = this.mapApi;
         Api.social = this.socialApi;
         Api.jobs = this.jobsApi;
         Api.mount = this.mountApi;
         Api.modCommon = this.modCommon;
         Api.roleplay = this.roleplayApi;
         Api.party = this.partyApi;
         Api.binds = this.bindsApi;
         Api.time = this.timeApi;
         Api.storage = this.storageApi;
         Api.tooltip = this.tooltipApi;
         Api.modMenu = this;
         this.sysApi.createHook("OpeningContextMenu");
         this.sysApi.addHook(ShowPlayersNames,this.onShowPlayersNames);
         this.menuApi.registerMenuMaker("humanVendor",HumanVendorMenuMaker);
         this.menuApi.registerMenuMaker("multiplayer",MultiPlayerMenuMaker);
         this.menuApi.registerMenuMaker("player",PlayerMenuMaker);
         this.menuApi.registerMenuMaker("mutant",PlayerMenuMaker);
         this.menuApi.registerMenuMaker("account",AccountMenuMaker);
         this.menuApi.registerMenuMaker("item",ItemMenuMaker);
         this.menuApi.registerMenuMaker("paddockItem",PaddockItemMenuMaker);
         this.menuApi.registerMenuMaker("npc",NpcMenuMaker);
         this.menuApi.registerMenuMaker("taxCollector",TaxCollectorMenuMaker);
         this.menuApi.registerMenuMaker("prism",PrismMenuMaker);
         this.menuApi.registerMenuMaker("portal",PortalMenuMaker);
         this.menuApi.registerMenuMaker("skill",SkillMenuMaker);
         this.menuApi.registerMenuMaker("partyMember",PartyMemberMenuMaker);
         this.menuApi.registerMenuMaker("mount",MountMenuMaker);
         this.menuApi.registerMenuMaker("world",WorldMenuMaker);
         this.menuApi.registerMenuMaker("fightWorld",FightWorldMenuMaker);
         this.menuApi.registerMenuMaker("mapFlag",MapFlagMenuMaker);
         this.menuApi.registerMenuMaker("monsterGroup",MonsterGroupMenuMaker);
         this.menuApi.registerMenuMaker("companion",CompanionMenuMaker);
         this.menuApi.registerMenuMaker("fightAlly",FightAllyMenuMaker);
         this.menuApi.registerMenuMaker("interactiveElement",InteractiveElementMenuMaker);
      }
      
      public function getMenuMaker(param1:String) : Object
      {
         return this.menuApi.getMenuMaker(param1);
      }
      
      public function createContextMenuTitleObject(param1:String) : ContextMenuTitle
      {
         return static_createContextMenuTitleObject(param1);
      }
      
      public function createContextMenuItemObject(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = true, param8:String = null, param9:Boolean = false, param10:uint = 1000) : ContextMenuItem
      {
         return static_createContextMenuItemObject(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public function createContextMenuPictureItemObject(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = false, param8:String = null, param9:Boolean = false, param10:uint = 1000) : ContextMenuPictureItem
      {
         return static_createContextMenuPictureItemObject(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public function createContextMenuPictureLabelItemObject(param1:String, param2:String, param3:int, param4:Boolean, param5:Function = null, param6:Array = null, param7:Boolean = false, param8:Array = null, param9:Boolean = false, param10:Boolean = false, param11:String = "", param12:Boolean = false, param13:uint = 1000) : ContextMenuPictureLabelItem
      {
         return static_createContextMenuPictureLabelItemObject(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13);
      }
      
      public function createContextMenuSeparatorObject() : ContextMenuSeparator
      {
         return static_createContextMenuSeparatorObject();
      }
      
      public function closeAllMenu() : void
      {
         ContextMenuManager.getInstance().closeAll();
      }
      
      public function createContextMenu(param1:*, param2:Object = null, param3:Function = null, param4:String = null) : void
      {
         var menu:* = param1;
         var positionReference:Object = param2;
         var closeCallBack:Function = param3;
         var instanceName:String = param4;
         if(menu == null)
         {
            return;
         }
         if(menu is Array)
         {
            menu = this.menuApi.create(null,null,menu);
         }
         try
         {
            this.sysApi.dispatchHook(OpeningContextMenu,menu);
         }
         catch(e:Error)
         {
            sysApi.log(8,"Context menu exception : " + e);
         }
         var resultMenu:* = menu is Array?menu:menu.content;
         ContextMenuManager.getInstance().openNew(resultMenu,positionReference,closeCallBack,false,instanceName);
      }
      
      public function unload() : void
      {
         Api.system = null;
         Api.config = null;
         Api.ui = null;
         Api.menu = null;
         Api.data = null;
         Api.alignment = null;
         Api.fight = null;
         Api.player = null;
         Api.map = null;
         Api.social = null;
         Api.jobs = null;
         Api.mount = null;
         Api.modCommon = null;
         Api.roleplay = null;
         Api.party = null;
         Api.binds = null;
         Api.time = null;
         Api.storage = null;
         Api.modMenu = null;
      }
      
      private function onShowPlayersNames(param1:Boolean) : void
      {
         this.playersNamesVisible = param1;
      }
   }
}
