package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import flash.display.Sprite;
   import makers.CartographyTooltipMaker;
   import makers.ChallengeTooltipMaker;
   import makers.CraftSmileyTooltipMaker;
   import makers.DelayedActionTooltipMaker;
   import makers.EffectsListDurationTooltipMaker;
   import makers.EffectsListTooltipMaker;
   import makers.EffectsTooltipMaker;
   import makers.ItemTooltipMaker;
   import makers.MountTooltipMaker;
   import makers.SellCriterionTooltipMaker;
   import makers.SmileyTooltipMaker;
   import makers.SpellTooltipMaker;
   import makers.StatFloorsTooltipMaker;
   import makers.TchatTooltipMaker;
   import makers.TextInfoTooltipMaker;
   import makers.TextInfoWithHorizontalSeparatorTooltipMaker;
   import makers.TextTooltipMaker;
   import makers.TextWithShortcutTooltipMaker;
   import makers.TextWithTitleTooltipMaker;
   import makers.TexturesListTooltipMaker;
   import makers.ThinkTooltipMaker;
   import makers.world.WorldCompanionFighterTooltipMaker;
   import makers.world.WorldMonsterFighterTooltipMaker;
   import makers.world.WorldPlayerFighterTooltipMaker;
   import makers.world.WorldRpCharacterTooltipMaker;
   import makers.world.WorldRpFightTooltipMaker;
   import makers.world.WorldRpGroundObjectTooltipMaker;
   import makers.world.WorldRpHouseTooltipMaker;
   import makers.world.WorldRpInteractiveElementTooltipMaker;
   import makers.world.WorldRpMerchantCharacterTooltipMaker;
   import makers.world.WorldRpMonstersGroupTooltipMaker;
   import makers.world.WorldRpPaddockItemTooltipMaker;
   import makers.world.WorldRpPaddockMountTooltipMaker;
   import makers.world.WorldRpPaddockTooltipMaker;
   import makers.world.WorldRpPrismTooltipMaker;
   import makers.world.WorldRpTaxeCollectorTooltipMaker;
   import makers.world.WorldTaxeCollectorFighterTooltipMaker;
   import ui.CartographyTooltipUi;
   import ui.DelayedActionTooltipUi;
   import ui.EffectsListDurationTooltipUi;
   import ui.HouseTooltipUi;
   import ui.InteractiveElementTooltipUi;
   import ui.ItemNameTooltipUi;
   import ui.ItemTooltipUi;
   import ui.MountTooltipUi;
   import ui.SpellBannerTooltipUi;
   import ui.SpellTooltipUi;
   import ui.TchatTooltipUi;
   import ui.TextInfoTooltipUi;
   import ui.TextInfoWithHorizontalSeparatorTooltipUi;
   import ui.TextWithShortcutTooltipUi;
   import ui.TooltipUi;
   import ui.WorldCharacterFighterTooltipUi;
   import ui.WorldCompanionFighterTooltipUi;
   import ui.WorldMonsterFighterTooltipUi;
   import ui.WorldRpCharacterTooltipUi;
   import ui.WorldRpFightTooltipUi;
   import ui.WorldRpMonstersGroupTooltipUi;
   import ui.WorldRpPaddockItemTooltipUi;
   import ui.WorldRpPaddockTooltipUi;
   import ui.WorldRpPortalTooltipUi;
   import ui.WorldRpPrismTooltipUi;
   import ui.WorldRpTaxeCollectorTooltipUi;
   
   public class Tooltips extends Sprite
   {
      
      public static var STATS_ICONS_PATH:String;
       
      
      public var tooltipApi:TooltipApi;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var alignApi:AlignmentApi;
      
      public var fightApi:FightApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var chatApi:ChatApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var utilApi:UtilApi;
      
      private var include_TooltipUi:TooltipUi = null;
      
      private var include_WorldRpCharacterTooltipUi:WorldRpCharacterTooltipUi = null;
      
      private var include_TchatTooltipUi:TchatTooltipUi = null;
      
      private var include_TextInfoTooltipUi:TextInfoTooltipUi = null;
      
      public function Tooltips()
      {
         super();
      }
      
      public function main() : void
      {
         Api.system = this.sysApi;
         Api.ui = this.uiApi;
         Api.tooltip = this.tooltipApi;
         Api.data = this.dataApi;
         Api.alignment = this.alignApi;
         Api.fight = this.fightApi;
         Api.player = this.playerApi;
         Api.chat = this.chatApi;
         Api.averagePrices = this.averagePricesApi;
         Api.util = this.utilApi;
         this.uiApi.preloadCss(this.sysApi.getConfigEntry("config.ui.skin") + "css/tooltip_npc.css");
         this.uiApi.preloadCss(this.sysApi.getConfigEntry("config.ui.skin") + "css/tooltip_item-smallScreen.css");
         this.tooltipApi.setDefaultTooltipUiScript("Ankama_Tooltips","tooltip");
         this.tooltipApi.registerTooltipMaker("text",TextTooltipMaker);
         this.tooltipApi.registerTooltipMaker("textInfo",TextInfoTooltipMaker,TextInfoTooltipUi);
         this.tooltipApi.registerTooltipMaker("textWithTitle",TextWithTitleTooltipMaker);
         this.tooltipApi.registerTooltipMaker("textWithShortcut",TextWithShortcutTooltipMaker,TextWithShortcutTooltipUi);
         this.tooltipApi.registerTooltipMaker("spell",SpellTooltipMaker,SpellTooltipUi);
         this.tooltipApi.registerTooltipMaker("spellBanner",TextInfoTooltipMaker,SpellBannerTooltipUi);
         this.tooltipApi.registerTooltipMaker("item",ItemTooltipMaker,ItemTooltipUi);
         this.tooltipApi.registerTooltipMaker("itemName",TextInfoTooltipMaker,ItemNameTooltipUi);
         this.tooltipApi.registerTooltipMaker("effects",EffectsTooltipMaker);
         this.tooltipApi.registerTooltipMaker("effectsDuration",EffectsListDurationTooltipMaker,EffectsListDurationTooltipUi);
         this.tooltipApi.registerTooltipMaker("smiley",SmileyTooltipMaker);
         this.tooltipApi.registerTooltipMaker("chatBubble",TchatTooltipMaker,TchatTooltipUi);
         this.tooltipApi.registerTooltipMaker("thinkBubble",ThinkTooltipMaker,TchatTooltipUi);
         this.tooltipApi.registerTooltipMaker("craftSmiley",CraftSmileyTooltipMaker);
         this.tooltipApi.registerTooltipMaker("player",WorldRpCharacterTooltipMaker,WorldRpCharacterTooltipUi);
         this.tooltipApi.registerTooltipMaker("mutant",WorldRpCharacterTooltipMaker,WorldRpCharacterTooltipUi);
         this.tooltipApi.registerTooltipMaker("merchant",WorldRpMerchantCharacterTooltipMaker,WorldRpCharacterTooltipUi);
         this.tooltipApi.registerTooltipMaker("delayedAction",DelayedActionTooltipMaker,DelayedActionTooltipUi);
         this.tooltipApi.registerTooltipMaker("monsterGroup",WorldRpMonstersGroupTooltipMaker,WorldRpMonstersGroupTooltipUi);
         this.tooltipApi.registerTooltipMaker("taxCollector",WorldRpTaxeCollectorTooltipMaker,WorldRpTaxeCollectorTooltipUi);
         this.tooltipApi.registerTooltipMaker("paddockMount",WorldRpPaddockMountTooltipMaker);
         this.tooltipApi.registerTooltipMaker("paddock",WorldRpPaddockTooltipMaker,WorldRpPaddockTooltipUi);
         this.tooltipApi.registerTooltipMaker("paddockItem",WorldRpPaddockItemTooltipMaker,WorldRpPaddockItemTooltipUi);
         this.tooltipApi.registerTooltipMaker("mount",MountTooltipMaker,MountTooltipUi);
         this.tooltipApi.registerTooltipMaker("fightTaxCollector",WorldTaxeCollectorFighterTooltipMaker);
         this.tooltipApi.registerTooltipMaker("challenge",ChallengeTooltipMaker);
         this.tooltipApi.registerTooltipMaker("playerFighter",WorldPlayerFighterTooltipMaker,WorldCharacterFighterTooltipUi);
         this.tooltipApi.registerTooltipMaker("monsterFighter",WorldMonsterFighterTooltipMaker,WorldMonsterFighterTooltipUi);
         this.tooltipApi.registerTooltipMaker("companionFighter",WorldCompanionFighterTooltipMaker,WorldCompanionFighterTooltipUi);
         this.tooltipApi.registerTooltipMaker("roleplayFight",WorldRpFightTooltipMaker,WorldRpFightTooltipUi);
         this.tooltipApi.registerTooltipMaker("groundObject",WorldRpGroundObjectTooltipMaker);
         this.tooltipApi.registerTooltipMaker("prism",WorldRpPrismTooltipMaker,WorldRpPrismTooltipUi);
         this.tooltipApi.registerTooltipMaker("portal",WorldRpPrismTooltipMaker,WorldRpPortalTooltipUi);
         this.tooltipApi.registerTooltipMaker("effectsList",EffectsListTooltipMaker);
         this.tooltipApi.registerTooltipMaker("texturesList",TexturesListTooltipMaker);
         this.tooltipApi.registerTooltipMaker("house",WorldRpHouseTooltipMaker,HouseTooltipUi);
         this.tooltipApi.registerTooltipMaker("sellCriterion",SellCriterionTooltipMaker);
         this.tooltipApi.registerTooltipMaker("interactiveElement",WorldRpInteractiveElementTooltipMaker,InteractiveElementTooltipUi);
         this.tooltipApi.registerTooltipMaker("cartography",CartographyTooltipMaker,CartographyTooltipUi);
         this.tooltipApi.registerTooltipMaker("textInfoWithHorizontalSeparator",TextInfoWithHorizontalSeparatorTooltipMaker,TextInfoWithHorizontalSeparatorTooltipUi);
         this.tooltipApi.registerTooltipMaker("statFloors",StatFloorsTooltipMaker);
         STATS_ICONS_PATH = this.sysApi.getConfigKey("content.path").concat("gfx/characteristics/characteristics.swf|tx_");
      }
      
      public function unload() : void
      {
         Api.system = null;
         Api.ui = null;
         Api.tooltip = null;
         Api.data = null;
         Api.alignment = null;
         Api.fight = null;
         Api.player = null;
         Api.chat = null;
         Api.averagePrices = null;
         Api.util = null;
      }
   }
}
