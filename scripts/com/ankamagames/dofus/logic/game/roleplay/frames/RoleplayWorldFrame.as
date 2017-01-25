package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOutMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOverMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.types.FrustumShape;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   import com.ankamagames.dofus.datacenter.interactives.SkillName;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.NpcAction;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.EmptyStackAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightJoinRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeOnHumanVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowAllNamesAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcGenericActionRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ShowEntitiestooltipsAction;
   import com.ankamagames.dofus.logic.game.roleplay.managers.RoleplayManager;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOutMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOverMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.CharacterTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.FightTeam;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.MutantTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.PortalTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.PrismTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplayTeamFightersTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.TaxCollectorTooltipInformation;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.enums.TeamTypeEnum;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseKickIndoorMerchantRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOnHumanVendorRequestMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.TaxCollectorStaticExtendedInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.AllianceInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPortalInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayTreasureHintInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementNamedSkill;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementSkill;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementWithAgeBonus;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.enum.OptionEnum;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.events.FramePushedEvent;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayWorldFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayWorldFrame));
      
      private static const NO_CURSOR:int = -1;
      
      private static const FIGHT_CURSOR:int = 3;
      
      private static const NPC_CURSOR:int = 1;
      
      private static const INTERACTIVE_CURSOR_OFFSET:Point = new Point(0,0);
      
      private static const ACTION_COLLECTABLE_RESOURCES:uint = 1;
      
      private static var _entitiesTooltipsFrame:EntitiesTooltipsFrame = new EntitiesTooltipsFrame();
       
      
      private const _common:String = XmlConfig.getInstance().getEntry("config.ui.skin");
      
      private var _mouseLabel:Label;
      
      private var _mouseTop:Texture;
      
      private var _mouseBottom:Texture;
      
      private var _mouseRight:Texture;
      
      private var _mouseLeft:Texture;
      
      private var _mouseTopBlue:Texture;
      
      private var _mouseBottomBlue:Texture;
      
      private var _mouseRightBlue:Texture;
      
      private var _mouseLeftBlue:Texture;
      
      private var _texturesReady:Boolean;
      
      private var _playerEntity:AnimatedCharacter;
      
      private var _playerName:String;
      
      private var _allowOnlyCharacterInteraction:Boolean;
      
      public var cellClickEnabled:Boolean;
      
      private var _infoEntitiesFrame:InfoEntitiesFrame;
      
      private var _mouseOverEntityId:Number;
      
      private var sysApi:SystemApi;
      
      private var _entityTooltipData:Dictionary;
      
      private var _mouseDown:Boolean;
      
      private var _roleplayApi:RoleplayApi;
      
      private var _socialApi:SocialApi;
      
      public var pivotingCharacter:Boolean;
      
      public function RoleplayWorldFrame()
      {
         this._infoEntitiesFrame = new InfoEntitiesFrame();
         this.sysApi = new SystemApi();
         this._entityTooltipData = new Dictionary();
         this._roleplayApi = new RoleplayApi();
         this._socialApi = new SocialApi();
         super();
      }
      
      public function get mouseOverEntityId() : Number
      {
         return this._mouseOverEntityId;
      }
      
      public function set allowOnlyCharacterInteraction(param1:Boolean) : void
      {
         this._allowOnlyCharacterInteraction = param1;
      }
      
      public function get allowOnlyCharacterInteraction() : Boolean
      {
         return this._allowOnlyCharacterInteraction;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      private function get roleplayMovementFrame() : RoleplayMovementFrame
      {
         return Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame;
      }
      
      public function pushed() : Boolean
      {
         FrustumManager.getInstance().setBorderInteraction(true);
         this._allowOnlyCharacterInteraction = false;
         this.cellClickEnabled = true;
         this.pivotingCharacter = false;
         var _loc1_:ShortcutsFrame = Kernel.getWorker().getFrame(ShortcutsFrame) as ShortcutsFrame;
         if(_loc1_.heldShortcuts.indexOf("showEntitiesTooltips") != -1 && !Kernel.getWorker().contains(EntitiesTooltipsFrame))
         {
            if(Kernel.getWorker().contains(RoleplayEntitiesFrame))
            {
               Kernel.getWorker().addFrame(_entitiesTooltipsFrame);
            }
            else
            {
               Kernel.getWorker().addEventListener(FramePushedEvent.EVENT_FRAME_PUSHED,this.onFramePushed);
            }
         }
         else if(Kernel.getWorker().contains(EntitiesTooltipsFrame))
         {
            Kernel.getWorker().removeFrame(_entitiesTooltipsFrame);
         }
         StageShareManager.stage.addEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
         if(this._texturesReady)
         {
            return true;
         }
         this._mouseBottom = new Texture();
         this._mouseBottom.uri = new Uri(this._common + "assets.swf|cursorBottom");
         this._mouseBottom.finalize();
         this._mouseTop = new Texture();
         this._mouseTop.uri = new Uri(this._common + "assets.swf|cursorTop");
         this._mouseTop.finalize();
         this._mouseRight = new Texture();
         this._mouseRight.uri = new Uri(this._common + "assets.swf|cursorRight");
         this._mouseRight.finalize();
         this._mouseLeft = new Texture();
         this._mouseLeft.uri = new Uri(this._common + "assets.swf|cursorLeft");
         this._mouseLeft.finalize();
         this._mouseBottomBlue = new Texture();
         this._mouseBottomBlue.uri = new Uri(this._common + "assets.swf|cursorBottomBlue");
         this._mouseBottomBlue.finalize();
         this._mouseTopBlue = new Texture();
         this._mouseTopBlue.uri = new Uri(this._common + "assets.swf|cursorTopBlue");
         this._mouseTopBlue.finalize();
         this._mouseRightBlue = new Texture();
         this._mouseRightBlue.uri = new Uri(this._common + "assets.swf|cursorRightBlue");
         this._mouseRightBlue.finalize();
         this._mouseLeftBlue = new Texture();
         this._mouseLeftBlue.uri = new Uri(this._common + "assets.swf|cursorLeftBlue");
         this._mouseLeftBlue.finalize();
         this._mouseLabel = new Label();
         this._mouseLabel.css = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "css/normal.css");
         this._texturesReady = true;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:AdjacentMapOverMessage = null;
         var _loc3_:Point = null;
         var _loc4_:GraphicCell = null;
         var _loc5_:Point = null;
         var _loc6_:LinkedCursorData = null;
         var _loc7_:WorldPointWrapper = null;
         var _loc8_:int = 0;
         var _loc9_:SubArea = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Rectangle = null;
         var _loc16_:Point = null;
         var _loc17_:EntityMouseOverMessage = null;
         var _loc18_:String = null;
         var _loc19_:IInteractive = null;
         var _loc20_:AnimatedCharacter = null;
         var _loc21_:* = undefined;
         var _loc22_:IRectangle = null;
         var _loc23_:String = null;
         var _loc24_:String = null;
         var _loc25_:Number = NaN;
         var _loc26_:MouseRightClickMessage = null;
         var _loc27_:Object = null;
         var _loc28_:Object = null;
         var _loc29_:IInteractive = null;
         var _loc30_:RoleplayInteractivesFrame = null;
         var _loc31_:InteractiveElement = null;
         var _loc32_:EntityMouseOutMessage = null;
         var _loc33_:EntityClickMessage = null;
         var _loc34_:IInteractive = null;
         var _loc35_:GameContextActorInformations = null;
         var _loc36_:GameRolePlayNpcInformations = null;
         var _loc37_:Boolean = false;
         var _loc38_:Boolean = false;
         var _loc39_:InteractiveElementActivationMessage = null;
         var _loc40_:RoleplayInteractivesFrame = null;
         var _loc41_:InteractiveElementMouseOverMessage = null;
         var _loc42_:Object = null;
         var _loc43_:String = null;
         var _loc44_:String = null;
         var _loc45_:InteractiveElement = null;
         var _loc46_:InteractiveElementSkill = null;
         var _loc47_:Interactive = null;
         var _loc48_:uint = 0;
         var _loc49_:RoleplayEntitiesFrame = null;
         var _loc50_:HouseWrapper = null;
         var _loc51_:Rectangle = null;
         var _loc52_:InteractiveElementMouseOutMessage = null;
         var _loc53_:ShowEntitiestooltipsAction = null;
         var _loc54_:MouseUpMessage = null;
         var _loc55_:ShortcutsFrame = null;
         var _loc56_:CellClickMessage = null;
         var _loc57_:SerialSequencer = null;
         var _loc58_:AdjacentMapClickMessage = null;
         var _loc59_:IEntity = null;
         var _loc60_:MapPosition = null;
         var _loc61_:String = null;
         var _loc62_:Rectangle = null;
         var _loc63_:Object = null;
         var _loc64_:Array = null;
         var _loc65_:DisplayObject = null;
         var _loc66_:DisplayObjectContainer = null;
         var _loc67_:TiphonSprite = null;
         var _loc68_:TiphonSprite = null;
         var _loc69_:Boolean = false;
         var _loc70_:DisplayObject = null;
         var _loc71_:Rectangle = null;
         var _loc72_:Rectangle2 = null;
         var _loc73_:FightTeam = null;
         var _loc74_:AllianceInformations = null;
         var _loc75_:int = 0;
         var _loc76_:GameRolePlayTaxCollectorInformations = null;
         var _loc77_:GuildInformations = null;
         var _loc78_:GuildWrapper = null;
         var _loc79_:AllianceWrapper = null;
         var _loc80_:GameRolePlayNpcInformations = null;
         var _loc81_:Npc = null;
         var _loc82_:AllianceFrame = null;
         var _loc83_:GameRolePlayTreasureHintInformations = null;
         var _loc84_:Npc = null;
         var _loc85_:uint = 0;
         var _loc86_:RoleplayContextFrame = null;
         var _loc87_:GameContextActorInformations = null;
         var _loc88_:GameContextActorInformations = null;
         var _loc89_:String = null;
         var _loc90_:Object = null;
         var _loc91_:GameRolePlayPrismInformations = null;
         var _loc92_:String = null;
         var _loc93_:GameRolePlayTaxCollectorInformations = null;
         var _loc94_:Vector.<uint> = null;
         var _loc95_:NpcGenericActionRequestAction = null;
         var _loc96_:uint = 0;
         var _loc97_:Number = NaN;
         var _loc98_:uint = 0;
         var _loc99_:GameFightJoinRequestMessage = null;
         var _loc100_:IEntity = null;
         var _loc101_:int = 0;
         var _loc102_:FightTeam = null;
         var _loc103_:FightTeamMemberInformations = null;
         var _loc104_:GuildWrapper = null;
         var _loc105_:IEntity = null;
         var _loc106_:Array = null;
         var _loc107_:int = 0;
         var _loc108_:MapPoint = null;
         var _loc109_:Array = null;
         var _loc110_:CellData = null;
         var _loc111_:MapPoint = null;
         var _loc112_:CellData = null;
         var _loc113_:InteractiveElementSkill = null;
         var _loc114_:Boolean = false;
         var _loc115_:InteractiveElementSkill = null;
         var _loc116_:Object = null;
         var _loc117_:String = null;
         var _loc118_:Skill = null;
         var _loc119_:String = null;
         var _loc120_:String = null;
         var _loc121_:Skill = null;
         var _loc122_:Boolean = false;
         var _loc123_:InteractiveElementWithAgeBonus = null;
         switch(true)
         {
            case param1 is CellClickMessage:
               if(this.pivotingCharacter)
               {
                  return false;
               }
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               if(this.cellClickEnabled)
               {
                  _loc56_ = param1 as CellClickMessage;
                  try
                  {
                     _loc57_ = new SerialSequencer();
                     _loc57_.addStep(new AddGfxEntityStep(3506,_loc56_.cellId));
                     _loc57_.start();
                  }
                  catch(e:Error)
                  {
                  }
                  (Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).currentEmoticon = 0;
                  this.roleplayMovementFrame.resetNextMoveMapChange();
                  this.roleplayMovementFrame.setFollowingInteraction(null);
                  this.roleplayMovementFrame.askMoveTo(MapPoint.fromCellId(_loc56_.cellId));
               }
               return true;
            case param1 is AdjacentMapClickMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               if(this.cellClickEnabled)
               {
                  _loc58_ = param1 as AdjacentMapClickMessage;
                  _loc59_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if(!_loc59_)
                  {
                     _log.warn("The player tried to move before its character was added to the scene. Aborting.");
                     return false;
                  }
                  this.roleplayMovementFrame.setNextMoveMapChange(_loc58_.adjacentMapId);
                  if(!_loc59_.position.equals(MapPoint.fromCellId(_loc58_.cellId)))
                  {
                     this.roleplayMovementFrame.setFollowingInteraction(null);
                     this.roleplayMovementFrame.askMoveTo(MapPoint.fromCellId(_loc58_.cellId));
                  }
                  else
                  {
                     this.roleplayMovementFrame.setFollowingInteraction(null);
                     this.roleplayMovementFrame.askMapChange();
                  }
               }
               return true;
            case param1 is AdjacentMapOutMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               TooltipManager.hide("subareaChange");
               LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
               return true;
            case param1 is AdjacentMapOverMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               _loc2_ = AdjacentMapOverMessage(param1);
               _loc3_ = CellIdConverter.cellIdToCoord(_loc2_.cellId);
               _loc4_ = InteractiveCellManager.getInstance().getCell(_loc2_.cellId);
               _loc5_ = _loc4_.parent.localToGlobal(new Point(_loc4_.x,_loc4_.y));
               _loc6_ = new LinkedCursorData();
               if(PlayedCharacterManager.getInstance().currentMap.leftNeighbourId == -1 && PlayedCharacterManager.getInstance().currentMap.rightNeighbourId == -1 && PlayedCharacterManager.getInstance().currentMap.topNeighbourId == -1 && PlayedCharacterManager.getInstance().currentMap.bottomNeighbourId == -1)
               {
                  _loc7_ = new WorldPointWrapper(MapDisplayManager.getInstance().getDataMapContainer().id);
               }
               else
               {
                  _loc7_ = PlayedCharacterManager.getInstance().currentMap;
               }
               if(_loc2_.direction == DirectionsEnum.RIGHT)
               {
                  _loc8_ = _loc7_.rightNeighbourId;
               }
               else if(_loc2_.direction == DirectionsEnum.DOWN)
               {
                  _loc8_ = _loc7_.bottomNeighbourId;
               }
               else if(_loc2_.direction == DirectionsEnum.LEFT)
               {
                  _loc8_ = _loc7_.leftNeighbourId;
               }
               else if(_loc2_.direction == DirectionsEnum.UP)
               {
                  _loc8_ = _loc7_.topNeighbourId;
               }
               _loc9_ = SubArea.getSubAreaByMapId(_loc8_);
               _loc10_ = false;
               _loc11_ = 0;
               _loc12_ = 0;
               if(_loc9_)
               {
                  if(_loc9_.id != PlayedCharacterManager.getInstance().currentSubArea.id)
                  {
                     _loc10_ = true;
                     _loc14_ = I18n.getUiText("ui.common.toward",[_loc9_.name]);
                     _loc61_ = I18n.getUiText("ui.common.level") + " " + _loc9_.level;
                  }
                  _loc60_ = MapPosition.getMapPositionById(_loc8_);
                  if(_loc60_.showNameOnFingerpost && _loc60_.name)
                  {
                     _loc14_ = I18n.getUiText("ui.common.toward",[_loc60_.name]);
                  }
                  if(_loc14_ && _loc14_ != "")
                  {
                     this._mouseLabel.text = _loc14_.length > _loc61_.length?_loc14_:_loc61_;
                     _loc13_ = _loc14_ + "\n" + _loc61_;
                  }
               }
               _loc15_ = _loc2_.zone.getBounds(_loc2_.zone);
               switch(_loc2_.direction)
               {
                  case DirectionsEnum.LEFT:
                     _loc6_.sprite = !!_loc10_?this._mouseLeftBlue:this._mouseLeft;
                     _loc6_.lockX = true;
                     _loc6_.sprite.x = _loc15_.right;
                     _loc6_.offset = new Point(0,0);
                     _loc6_.lockY = true;
                     _loc6_.sprite.y = _loc5_.y + AtouinConstants.CELL_HEIGHT / 2 * Atouin.getInstance().currentZoom;
                     if(_loc10_)
                     {
                        _loc11_ = 0;
                        _loc12_ = _loc6_.sprite.height / 2;
                     }
                     break;
                  case DirectionsEnum.UP:
                     _loc6_.sprite = !!_loc10_?this._mouseTopBlue:this._mouseTop;
                     _loc6_.lockY = true;
                     _loc6_.sprite.y = _loc15_.bottom;
                     _loc6_.offset = new Point(0,0);
                     _loc6_.lockX = true;
                     _loc6_.sprite.x = _loc5_.x + AtouinConstants.CELL_WIDTH / 2 * Atouin.getInstance().currentZoom;
                     if(_loc10_)
                     {
                        _loc11_ = -this._mouseLabel.textWidth / 2;
                        _loc12_ = _loc6_.sprite.height + 5;
                     }
                     break;
                  case DirectionsEnum.DOWN:
                     _loc6_.sprite = !!_loc10_?this._mouseBottomBlue:this._mouseBottom;
                     _loc6_.lockY = true;
                     _loc6_.sprite.y = _loc15_.top;
                     _loc6_.offset = new Point(0,0);
                     _loc6_.lockX = true;
                     _loc6_.sprite.x = _loc5_.x + AtouinConstants.CELL_WIDTH / 2 * Atouin.getInstance().currentZoom;
                     if(_loc10_)
                     {
                        _loc11_ = -this._mouseLabel.textWidth / 2;
                        _loc12_ = -_loc6_.sprite.height - this._mouseLabel.textHeight - 34;
                     }
                     break;
                  case DirectionsEnum.RIGHT:
                     _loc6_.sprite = !!_loc10_?this._mouseRightBlue:this._mouseRight;
                     _loc6_.lockX = true;
                     _loc6_.sprite.x = _loc15_.left;
                     _loc6_.offset = new Point(0,0);
                     _loc6_.lockY = true;
                     _loc6_.sprite.y = _loc5_.y + AtouinConstants.CELL_HEIGHT / 2 * Atouin.getInstance().currentZoom;
                     if(_loc10_)
                     {
                        _loc11_ = -this._mouseLabel.textWidth;
                        _loc12_ = _loc6_.sprite.height / 2;
                     }
               }
               if(_loc10_)
               {
                  _loc62_ = new Rectangle(_loc6_.sprite.x + _loc11_,_loc6_.sprite.y + _loc12_,1,1);
                  _loc63_ = new Object();
                  _loc63_.classCss = "center";
                  TooltipManager.show(_loc13_,_loc62_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"subareaChange",0,0,0,true,null,null,_loc63_,"Text" + _loc8_,false,StrataEnum.STRATA_TOOLTIP,1);
               }
               LinkedCursorSpriteManager.getInstance().addItem("changeMapCursor",_loc6_);
               return true;
            case param1 is MapComplementaryInformationsDataMessage:
               if(!StageShareManager.mouseOnStage)
               {
                  return false;
               }
               _loc16_ = new Point(StageShareManager.stage.mouseX,StageShareManager.stage.mouseY);
               if(Atouin.getInstance().options.frustum.containsPoint(_loc16_))
               {
                  _loc64_ = StageShareManager.stage.getObjectsUnderPoint(_loc16_);
                  for each(_loc65_ in _loc64_)
                  {
                     if(_loc65_ is FrustumShape)
                     {
                        _loc65_.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
                        break;
                     }
                  }
               }
               return false;
            case param1 is EntityMouseOverMessage:
               _loc17_ = param1 as EntityMouseOverMessage;
               this._mouseOverEntityId = _loc17_.entity.id;
               _loc18_ = "entity_" + _loc17_.entity.id;
               this.displayCursor(NO_CURSOR);
               _loc19_ = _loc17_.entity as IInteractive;
               _loc20_ = _loc19_ as AnimatedCharacter;
               if(_loc20_)
               {
                  _loc20_ = _loc20_.getRootEntity();
                  _loc20_.highLightCharacterAndFollower(true);
                  _loc19_ = _loc20_;
                  if(OptionManager.getOptionManager("tiphon").auraMode == OptionEnum.AURA_ON_ROLLOVER && _loc20_.getDirection() == DirectionsEnum.DOWN)
                  {
                     _loc20_.visibleAura = true;
                  }
               }
               _loc21_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc19_.id) as GameRolePlayActorInformations;
               if(_loc19_ is TiphonSprite)
               {
                  _loc67_ = _loc19_ as TiphonSprite;
                  _loc68_ = (_loc19_ as TiphonSprite).getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
                  _loc69_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) && RoleplayEntitiesFrame(Kernel.getWorker().getFrame(RoleplayEntitiesFrame)).isCreatureMode;
                  if(_loc68_ && !_loc69_)
                  {
                     _loc67_ = _loc68_;
                  }
                  _loc70_ = _loc67_.getSlot("Tete");
                  if(_loc70_)
                  {
                     _loc71_ = _loc70_.getBounds(StageShareManager.stage);
                     _loc72_ = new Rectangle2(_loc71_.x,_loc71_.y,_loc71_.width,_loc71_.height);
                     _loc22_ = _loc72_;
                  }
               }
               if(!_loc22_ || _loc22_.width == 0 && _loc22_.height == 0)
               {
                  _loc22_ = (_loc19_ as IDisplayable).absoluteBounds;
               }
               _loc23_ = null;
               _loc25_ = 0;
               if(this.roleplayContextFrame.entitiesFrame.isFight(_loc19_.id))
               {
                  if(this.allowOnlyCharacterInteraction)
                  {
                     return false;
                  }
                  _loc73_ = this.roleplayContextFrame.entitiesFrame.getFightTeam(_loc19_.id);
                  _loc21_ = new RoleplayTeamFightersTooltipInformation(_loc73_);
                  _loc23_ = "roleplayFight";
                  this.displayCursor(FIGHT_CURSOR,!PlayedCharacterManager.getInstance().restrictions.cantAttackMonster);
                  if(_loc73_.hasOptions() || _loc73_.hasGroupMember())
                  {
                     _loc25_ = 35;
                  }
               }
               else
               {
                  switch(true)
                  {
                     case _loc21_ is GameRolePlayCharacterInformations:
                        if(_loc21_.contextualId == PlayedCharacterManager.getInstance().id)
                        {
                           _loc75_ = 0;
                        }
                        else
                        {
                           _loc85_ = int(_loc21_.alignmentInfos.characterPower - _loc21_.contextualId);
                           _loc75_ = PlayedCharacterManager.getInstance().levelDiff(_loc85_);
                        }
                        _loc21_ = new CharacterTooltipInformation(_loc21_ as GameRolePlayCharacterInformations,_loc75_);
                        _loc24_ = "CharacterCache";
                        break;
                     case _loc21_ is GameRolePlayMerchantInformations:
                        _loc24_ = "MerchantCharacterCache";
                        break;
                     case _loc21_ is GameRolePlayMutantInformations:
                        if((_loc21_ as GameRolePlayMutantInformations).humanoidInfo.restrictions.cantAttack)
                        {
                           _loc21_ = new CharacterTooltipInformation(_loc21_,0);
                        }
                        else
                        {
                           _loc21_ = new MutantTooltipInformation(_loc21_ as GameRolePlayMutantInformations);
                        }
                        break;
                     case _loc21_ is GameRolePlayTaxCollectorInformations:
                        if(this.allowOnlyCharacterInteraction)
                        {
                           return false;
                        }
                        _loc76_ = _loc21_ as GameRolePlayTaxCollectorInformations;
                        _loc77_ = _loc76_.identification.guildIdentity;
                        _loc74_ = _loc76_.identification is TaxCollectorStaticExtendedInformations?(_loc76_.identification as TaxCollectorStaticExtendedInformations).allianceIdentity:null;
                        _loc78_ = GuildWrapper.create(_loc77_.guildId,_loc77_.guildName,_loc77_.guildEmblem,0);
                        _loc79_ = !!_loc74_?AllianceWrapper.create(_loc74_.allianceId,_loc74_.allianceTag,_loc74_.allianceName,_loc74_.allianceEmblem):null;
                        _loc21_ = new TaxCollectorTooltipInformation(TaxCollectorName.getTaxCollectorNameById((_loc21_ as GameRolePlayTaxCollectorInformations).identification.lastNameId).name,TaxCollectorFirstname.getTaxCollectorFirstnameById((_loc21_ as GameRolePlayTaxCollectorInformations).identification.firstNameId).firstname,_loc78_,_loc79_,(_loc21_ as GameRolePlayTaxCollectorInformations).taxCollectorAttack,_loc17_.checkSuperposition,_loc76_.disposition.cellId);
                        _loc24_ = "TaxCollectorCache";
                        break;
                     case _loc21_ is GameRolePlayNpcInformations:
                        if(this.allowOnlyCharacterInteraction)
                        {
                           return false;
                        }
                        _loc80_ = _loc21_ as GameRolePlayNpcInformations;
                        _loc81_ = Npc.getNpcById(_loc80_.npcId);
                        _loc21_ = new TextTooltipInfo(_loc81_.name,XmlConfig.getInstance().getEntry("config.ui.skin") + "css/tooltip_npc.css","green",0,_loc17_.checkSuperposition,_loc80_.disposition.cellId);
                        _loc21_.bgCornerRadius = 10;
                        _loc24_ = !_loc17_.virtual?"NPCCacheName":"NPCCacheName_" + this._mouseOverEntityId;
                        if(_loc81_.actions.length == 0)
                        {
                           break;
                        }
                        if(!_loc17_.virtual)
                        {
                           this.displayCursor(NPC_CURSOR);
                        }
                        break;
                     case _loc21_ is GameRolePlayGroupMonsterInformations:
                        if(this.allowOnlyCharacterInteraction)
                        {
                           return false;
                        }
                        if(!_loc17_.virtual)
                        {
                           this.displayCursor(FIGHT_CURSOR,!PlayedCharacterManager.getInstance().restrictions.cantAttackMonster);
                        }
                        _loc24_ = !_loc17_.virtual?"GroupMonsterCache":"GroupMonsterCache_" + this._mouseOverEntityId;
                        break;
                     case _loc21_ is GameRolePlayPrismInformations:
                        _loc82_ = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
                        _loc21_ = new PrismTooltipInformation(_loc82_.getPrismSubAreaById(PlayedCharacterManager.getInstance().currentSubArea.id).alliance,_loc17_.checkSuperposition,_loc21_.disposition.cellId);
                        _loc24_ = "PrismCache";
                        break;
                     case _loc21_ is GameRolePlayPortalInformations:
                        _loc21_ = new PortalTooltipInformation((_loc21_ as GameRolePlayPortalInformations).portal.areaId,_loc17_.checkSuperposition,_loc21_.disposition.cellId);
                        _loc24_ = "PortalCache";
                        break;
                     case _loc21_ is GameContextPaddockItemInformations:
                        _loc24_ = "PaddockItemCache";
                        break;
                     case _loc21_ is GameRolePlayTreasureHintInformations:
                        if(this.allowOnlyCharacterInteraction)
                        {
                           return false;
                        }
                        _loc83_ = _loc21_ as GameRolePlayTreasureHintInformations;
                        _loc84_ = Npc.getNpcById(_loc83_.npcId);
                        _loc21_ = new TextTooltipInfo(_loc84_.name,XmlConfig.getInstance().getEntry("config.ui.skin") + "css/tooltip_npc.css","orange",0);
                        _loc21_.bgCornerRadius = 10;
                        _loc24_ = "TrHintCacheName";
                        break;
                  }
               }
               if(!_loc21_)
               {
                  _log.warn("Rolling over a unknown entity (" + _loc17_.entity.id + ").");
                  return false;
               }
               if(this.roleplayContextFrame.entitiesFrame.hasIcon(_loc19_.id))
               {
                  _loc25_ = 45;
               }
               if(_loc20_ && !_loc20_.rawAnimation && !this._entityTooltipData[_loc20_])
               {
                  this._entityTooltipData[_loc20_] = {
                     "data":_loc21_,
                     "name":_loc18_,
                     "tooltipMaker":_loc23_,
                     "tooltipOffset":_loc25_,
                     "cacheName":_loc24_
                  };
                  _loc20_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityAnimRendered);
                  _loc20_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityAnimRendered);
               }
               else
               {
                  TooltipManager.show(_loc21_,_loc22_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,_loc18_,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,_loc25_,true,_loc23_,null,null,_loc24_,false,StrataEnum.STRATA_WORLD,this.sysApi.getCurrentZoom());
               }
               return true;
            case param1 is MouseRightClickMessage:
               _loc26_ = param1 as MouseRightClickMessage;
               _loc27_ = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
               _loc29_ = _loc26_.target as IInteractive;
               if(_loc29_)
               {
                  _loc86_ = this.roleplayContextFrame;
                  if(!(_loc29_ as AnimatedCharacter) || (_loc29_ as AnimatedCharacter).followed == null)
                  {
                     _loc87_ = _loc86_.entitiesFrame.getEntityInfos(_loc29_.id);
                  }
                  else
                  {
                     _loc87_ = _loc86_.entitiesFrame.getEntityInfos((_loc29_ as AnimatedCharacter).followed.id);
                  }
                  if(_loc87_ is GameRolePlayNamedActorInformations)
                  {
                     if(!(_loc29_ is AnimatedCharacter))
                     {
                        _log.error("L\'entity " + _loc29_.id + " est un GameRolePlayNamedActorInformations mais n\'est pas un AnimatedCharacter");
                        return true;
                     }
                     _loc29_ = (_loc29_ as AnimatedCharacter).getRootEntity();
                     _loc88_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc29_.id);
                     _loc28_ = MenusFactory.create(_loc88_,"multiplayer",[_loc29_]);
                     if(_loc28_)
                     {
                        _loc27_.createContextMenu(_loc28_);
                     }
                     return true;
                  }
                  if(_loc87_ is GameRolePlayGroupMonsterInformations)
                  {
                     _loc28_ = MenusFactory.create(_loc87_,"monsterGroup",[_loc29_]);
                     if(_loc28_)
                     {
                        _loc27_.createContextMenu(_loc28_);
                     }
                     return true;
                  }
                  if(_loc87_ is GameRolePlayPortalInformations || _loc87_ is GameRolePlayPrismInformations || _loc87_ is GameRolePlayTaxCollectorInformations || _loc87_ is GameRolePlayNpcInformations)
                  {
                     _loc28_ = MenusFactory.create(_loc87_,null,{
                        "entity":_loc29_,
                        "rightClick":true
                     });
                     if(_loc28_)
                     {
                        _loc27_.createContextMenu(_loc28_);
                     }
                     return true;
                  }
               }
               _loc30_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
               _loc31_ = _loc30_.getInteractiveElement(_loc26_.target);
               if(_loc31_ && _loc31_.elementTypeId != -1)
               {
                  _loc28_ = MenusFactory.create(_loc31_,"interactiveElement");
                  if(_loc28_)
                  {
                     TooltipManager.hide();
                     _loc27_.createContextMenu(_loc28_);
                  }
                  return true;
               }
               return false;
            case param1 is EntityMouseOutMessage:
               _loc32_ = param1 as EntityMouseOutMessage;
               this._mouseOverEntityId = 0;
               this.displayCursor(NO_CURSOR);
               TooltipManager.hide("entity_" + _loc32_.entity.id);
               _loc20_ = _loc32_.entity as AnimatedCharacter;
               if(_loc20_)
               {
                  _loc20_ = _loc20_.getRootEntity();
                  _loc20_.highLightCharacterAndFollower(false);
                  if(OptionManager.getOptionManager("tiphon").auraMode == OptionEnum.AURA_ON_ROLLOVER)
                  {
                     _loc20_.visibleAura = false;
                  }
               }
               return true;
            case param1 is EntityClickMessage:
               _loc33_ = param1 as EntityClickMessage;
               _loc34_ = _loc33_.entity as IInteractive;
               if(_loc34_ is AnimatedCharacter)
               {
                  _loc34_ = (_loc34_ as AnimatedCharacter).getRootEntity();
               }
               _loc35_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc34_.id);
               if(ShortcutsFrame.shiftKey)
               {
                  _loc89_ = "Map";
                  _loc90_ = {
                     "x":PlayedCharacterManager.getInstance().currentMap.outdoorX,
                     "y":PlayedCharacterManager.getInstance().currentMap.outdoorY,
                     "worldMapId":PlayedCharacterManager.getInstance().currentSubArea.worldmap.id,
                     "elementName":""
                  };
                  switch(true)
                  {
                     case _loc35_ is GameRolePlayPortalInformations:
                        _loc90_.elementName = I18n.getUiText("ui.dimension.portal",[Area.getAreaById((_loc35_ as GameRolePlayPortalInformations).portal.areaId).name]) + " ";
                        break;
                     case _loc35_ is GameRolePlayPrismInformations:
                        _loc91_ = _loc35_ as GameRolePlayPrismInformations;
                        _loc92_ = this._socialApi.getAllianceNameAndTag(_loc91_.prism);
                        _loc90_.elementName = I18n.getUiText("ui.prism.prismInState",[I18n.getUiText("ui.prism.state" + _loc91_.prism.state)]) + " " + LangManager.getInstance().replaceKey(_loc92_,true) + " ";
                        break;
                     case _loc35_ is GameRolePlayTaxCollectorInformations:
                        _loc93_ = _loc35_ as GameRolePlayTaxCollectorInformations;
                        _loc90_.elementName = I18n.getUiText("ui.guild.taxCollector",[_loc93_.identification.guildIdentity.guildName]) + " ";
                        break;
                     case _loc35_ is GameRolePlayNpcInformations:
                        _loc90_.elementName = Npc.getNpcById((_loc35_ as GameRolePlayNpcInformations).npcId).name + " ";
                        break;
                     case _loc35_ is GameRolePlayGroupMonsterInformations:
                        _loc89_ = "MonsterGroup";
                        _loc90_.monsterName = Monster.getMonsterById((_loc35_ as GameRolePlayGroupMonsterInformations).staticInfos.mainCreatureLightInfos.creatureGenericId).name;
                        _loc90_.infos = this._roleplayApi.getMonsterGroupString(_loc35_);
                        break;
                     case _loc35_ is GameRolePlayCharacterInformations:
                        _loc90_.elementName = (_loc35_ as GameRolePlayCharacterInformations).name + " ";
                  }
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.MouseShiftClick,{
                     "data":_loc89_,
                     "params":_loc90_
                  });
                  Kernel.getWorker().process(EmptyStackAction.create());
                  return true;
               }
               _loc36_ = _loc35_ as GameRolePlayNpcInformations;
               if(_loc36_)
               {
                  _loc94_ = Npc.getNpcById(_loc36_.npcId).actions;
                  if(!MenusFactory.getMenuMaker("npc").maker.disabled && _loc94_.length == 1)
                  {
                     _loc95_ = new NpcGenericActionRequestAction();
                     _loc95_.npcId = _loc34_.id;
                     this.process(new EntityMouseOutMessage(_loc34_));
                     _loc95_.actionId = NpcAction.getNpcActionById(_loc94_[0]).realId;
                     Kernel.getWorker().process(_loc95_);
                     return true;
                  }
               }
               else if(_loc35_ is GameRolePlayMerchantInformations)
               {
                  Kernel.getWorker().process(ExchangeOnHumanVendorRequestAction.create(_loc35_.contextualId,_loc35_.disposition.cellId));
                  return true;
               }
               _loc37_ = RoleplayManager.getInstance().displayContextualMenu(_loc35_,_loc34_);
               if(this.roleplayContextFrame.entitiesFrame.isFight(_loc34_.id))
               {
                  _loc96_ = this.roleplayContextFrame.entitiesFrame.getFightId(_loc34_.id);
                  _loc97_ = this.roleplayContextFrame.entitiesFrame.getFightLeaderId(_loc34_.id);
                  _loc98_ = this.roleplayContextFrame.entitiesFrame.getFightTeamType(_loc34_.id);
                  if(_loc98_ == TeamTypeEnum.TEAM_TYPE_TAXCOLLECTOR)
                  {
                     _loc102_ = this.roleplayContextFrame.entitiesFrame.getFightTeam(_loc34_.id) as FightTeam;
                     for each(_loc103_ in _loc102_.teamInfos.teamMembers)
                     {
                        if(_loc103_ is FightTeamMemberTaxCollectorInformations)
                        {
                           _loc101_ = (_loc103_ as FightTeamMemberTaxCollectorInformations).guildId;
                        }
                     }
                     _loc104_ = (Kernel.getWorker().getFrame(SocialFrame) as SocialFrame).guild;
                     if(_loc104_ && _loc101_ == _loc104_.guildId)
                     {
                        KernelEventsManager.getInstance().processCallback(SocialHookList.OpenSocial,1,2);
                        Kernel.getWorker().process(GuildFightJoinRequestAction.create(PlayedCharacterManager.getInstance().currentMap.mapId));
                        return true;
                     }
                  }
                  _loc99_ = new GameFightJoinRequestMessage();
                  _loc99_.initGameFightJoinRequestMessage(_loc97_,_loc96_);
                  _loc100_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if((_loc100_ as IMovable).isMoving)
                  {
                     this.roleplayMovementFrame.setFollowingMessage(_loc99_);
                     (_loc100_ as IMovable).stop();
                  }
                  else
                  {
                     ConnectionsHandler.getConnection().send(_loc99_);
                  }
               }
               else if(_loc34_.id != PlayedCharacterManager.getInstance().id && !_loc37_)
               {
                  this.roleplayMovementFrame.setFollowingInteraction(null);
                  if(_loc35_ is GameRolePlayActorInformations && _loc35_ is GameRolePlayGroupMonsterInformations)
                  {
                     this.roleplayMovementFrame.setFollowingMonsterFight(_loc34_);
                  }
                  this.roleplayMovementFrame.askMoveTo(_loc34_.position);
               }
               return true;
            case param1 is InteractiveElementActivationMessage:
               if(this.allowOnlyCharacterInteraction || !AirScanner.isStreamingVersion() && (OptionManager.getOptionManager("dofus")["enableForceWalk"] == true && (ShortcutsFrame.ctrlKeyDown || SystemManager.getSingleton().os == OperatingSystem.MAC_OS && ShortcutsFrame.altKeyDown)))
               {
                  return false;
               }
               _loc38_ = true;
               _loc39_ = param1 as InteractiveElementActivationMessage;
               _loc40_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
               if(!(_loc40_ && _loc40_.usingInteractive))
               {
                  _loc105_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if(!_loc105_)
                  {
                     return true;
                  }
                  _loc106_ = new Array();
                  _loc109_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells;
                  _loc107_ = 0;
                  while(_loc107_ < 8)
                  {
                     _loc108_ = _loc39_.position.getNearestCellInDirection(_loc107_);
                     if(_loc108_)
                     {
                        _loc110_ = _loc109_[_loc108_.cellId];
                        if(!_loc110_.mov || _loc110_.farmCell)
                        {
                           if(!_loc106_)
                           {
                              _loc106_ = [];
                           }
                           _loc106_.push(_loc108_.cellId);
                        }
                     }
                     _loc107_++;
                  }
                  _loc112_ = _loc109_[_loc39_.position.cellId];
                  if(_loc39_.position.distanceToCell(_loc105_.position) == 1 && (!_loc112_.mov || _loc112_.farmCell))
                  {
                     _loc111_ = _loc105_.position;
                  }
                  else
                  {
                     _loc111_ = _loc39_.position.getNearestFreeCellInDirection(_loc39_.position.advancedOrientationTo(_loc105_.position),DataMapProvider.getInstance(),true,true,false,_loc106_);
                  }
                  for each(_loc113_ in _loc39_.interactiveElement.enabledSkills)
                  {
                     if(_loc113_.skillId == 339)
                     {
                        _loc111_.cellId = _loc39_.position.cellId;
                        _loc38_ = false;
                        break;
                     }
                  }
                  if(!_loc111_ || _loc106_.indexOf(_loc111_.cellId) != -1)
                  {
                     _loc111_ = _loc39_.position;
                  }
                  if(_loc38_)
                  {
                     this.roleplayMovementFrame.setFollowingInteraction({
                        "ie":_loc39_.interactiveElement,
                        "skillInstanceId":_loc39_.skillInstanceId
                     });
                  }
                  this.roleplayMovementFrame.askMoveTo(_loc111_);
               }
               return true;
            case param1 is InteractiveElementMouseOverMessage:
               if(this.allowOnlyCharacterInteraction || !AirScanner.isStreamingVersion() && (OptionManager.getOptionManager("dofus")["enableForceWalk"] == true && (ShortcutsFrame.ctrlKeyDown || SystemManager.getSingleton().os == OperatingSystem.MAC_OS && ShortcutsFrame.altKeyDown)))
               {
                  return false;
               }
               _loc41_ = param1 as InteractiveElementMouseOverMessage;
               _loc45_ = _loc41_.interactiveElement;
               for each(_loc46_ in _loc45_.enabledSkills)
               {
                  if(_loc46_.skillId == 175)
                  {
                     _loc42_ = this.roleplayContextFrame.currentPaddock;
                     break;
                  }
               }
               for each(_loc46_ in _loc45_.disabledSkills)
               {
                  if(_loc46_.skillId == 339)
                  {
                     _loc114_ = false;
                     for each(_loc115_ in _loc45_.enabledSkills)
                     {
                        if(_loc115_.skillId == _loc46_.skillId)
                        {
                           _loc114_ = true;
                           break;
                        }
                     }
                     if(!_loc114_)
                     {
                        _loc45_.enabledSkills.push(_loc46_);
                     }
                     break;
                  }
               }
               _loc47_ = Interactive.getInteractiveById(_loc45_.elementTypeId);
               _loc48_ = _loc41_.interactiveElement.elementId;
               _loc49_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
               _loc50_ = _loc49_.housesInformations[_loc48_];
               _loc51_ = _loc41_.sprite.getRect(StageShareManager.stage);
               if(_loc50_)
               {
                  _loc42_ = _loc50_;
               }
               else if(_loc42_ == null && _loc47_)
               {
                  _loc116_ = new Object();
                  _loc116_.interactive = _loc47_.name;
                  _loc116_.isCollectable = false;
                  _loc117_ = "";
                  for each(_loc46_ in _loc45_.enabledSkills)
                  {
                     _loc118_ = Skill.getSkillById(_loc46_.skillId);
                     if(_loc118_.elementActionId == ACTION_COLLECTABLE_RESOURCES)
                     {
                        _loc116_.isCollectable = true;
                     }
                     if(_loc46_ is InteractiveElementNamedSkill)
                     {
                        _loc119_ = SkillName.getSkillNameById((_loc46_ as InteractiveElementNamedSkill).nameId).name;
                     }
                     else
                     {
                        _loc119_ = _loc118_.name;
                     }
                     _loc117_ = _loc117_ + (_loc119_ + "\n");
                  }
                  _loc116_.enabledSkills = _loc117_;
                  _loc120_ = "";
                  for each(_loc46_ in _loc45_.disabledSkills)
                  {
                     _loc118_ = Skill.getSkillById(_loc46_.skillId);
                     if(_loc118_.elementActionId == ACTION_COLLECTABLE_RESOURCES)
                     {
                        _loc116_.isCollectable = true;
                     }
                     if(_loc46_ is InteractiveElementNamedSkill)
                     {
                        _loc119_ = SkillName.getSkillNameById((_loc46_ as InteractiveElementNamedSkill).nameId).name;
                     }
                     else
                     {
                        _loc119_ = _loc118_.name;
                     }
                     _loc120_ = _loc120_ + (_loc119_ + "\n");
                  }
                  _loc116_.disabledSkills = _loc120_;
                  if(_loc116_.isCollectable)
                  {
                     _loc122_ = true;
                     _loc123_ = _loc45_ as InteractiveElementWithAgeBonus;
                     if(_loc45_.enabledSkills.length > 0)
                     {
                        _loc121_ = Skill.getSkillById(_loc45_.enabledSkills[0].skillId);
                        if(_loc121_.parentJobId == 1)
                        {
                           _loc122_ = false;
                        }
                     }
                     else if(!_loc123_)
                     {
                        _loc122_ = false;
                     }
                     if(_loc122_)
                     {
                        _loc116_.collectSkill = _loc121_;
                        _loc116_.ageBonus = !!_loc123_?_loc123_.ageBonus:0;
                     }
                  }
                  _loc42_ = _loc116_;
                  _loc43_ = "interactiveElement";
                  _loc44_ = "InteractiveElementCache";
               }
               if(_loc42_)
               {
                  TooltipManager.show(_loc42_,new Rectangle(_loc51_.right,int(_loc51_.y + _loc51_.height - AtouinConstants.CELL_HEIGHT),0,0),UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,TooltipManager.TOOLTIP_STANDAR_NAME,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOP,0,true,_loc43_,null,null,_loc44_);
               }
               return true;
            case param1 is InteractiveElementMouseOutMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               _loc52_ = param1 as InteractiveElementMouseOutMessage;
               TooltipManager.hide();
               return true;
            case param1 is ShowAllNamesAction:
               if(Kernel.getWorker().contains(InfoEntitiesFrame))
               {
                  Kernel.getWorker().removeFrame(this._infoEntitiesFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.ShowPlayersNames,false);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._infoEntitiesFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.ShowPlayersNames,true);
               }
               return true;
            case param1 is ShowEntitiestooltipsAction:
               _loc53_ = param1 as ShowEntitiestooltipsAction;
               _entitiesTooltipsFrame.triggeredByShortcut = _loc53_.fromShortcut;
               if(Kernel.getWorker().contains(EntitiesTooltipsFrame))
               {
                  Kernel.getWorker().removeFrame(_entitiesTooltipsFrame);
               }
               else if(StageShareManager.isActive && !(!_entitiesTooltipsFrame.triggeredByShortcut && !this._mouseDown))
               {
                  if(Kernel.getWorker().contains(RoleplayEntitiesFrame))
                  {
                     Kernel.getWorker().addFrame(_entitiesTooltipsFrame);
                  }
                  else
                  {
                     Kernel.getWorker().addEventListener(FramePushedEvent.EVENT_FRAME_PUSHED,this.onFramePushed);
                  }
               }
               return true;
            case param1 is MouseDownMessage:
               this._mouseDown = true;
               break;
            case param1 is MouseUpMessage:
               this._mouseDown = false;
               _loc54_ = param1 as MouseUpMessage;
               _loc55_ = Kernel.getWorker().getFrame(ShortcutsFrame) as ShortcutsFrame;
               if(_loc55_.heldShortcuts.indexOf("showEntitiesTooltips") == -1 && Kernel.getWorker().contains(EntitiesTooltipsFrame))
               {
                  Kernel.getWorker().removeFrame(_entitiesTooltipsFrame);
               }
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         StageShareManager.stage.removeEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
         Mouse.show();
         LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
         LinkedCursorSpriteManager.getInstance().removeItem("interactiveCursor");
         FrustumManager.getInstance().setBorderInteraction(false);
         return true;
      }
      
      private function onFramePushed(param1:FramePushedEvent) : void
      {
         var _loc2_:ShortcutsFrame = null;
         if(param1.frame is RoleplayEntitiesFrame)
         {
            param1.currentTarget.removeEventListener(FramePushedEvent.EVENT_FRAME_PUSHED,this.onFramePushed);
            _loc2_ = Kernel.getWorker().getFrame(ShortcutsFrame) as ShortcutsFrame;
            if(_loc2_.heldShortcuts.indexOf("showEntitiesTooltips") != -1 && !Kernel.getWorker().contains(EntitiesTooltipsFrame))
            {
               Kernel.getWorker().addFrame(_entitiesTooltipsFrame);
            }
         }
      }
      
      private function onEntityAnimRendered(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityAnimRendered);
         var _loc3_:Object = this._entityTooltipData[_loc2_];
         TooltipManager.show(_loc3_.data,_loc2_.absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,_loc3_.name,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,_loc3_.tooltipOffset,true,_loc3_.tooltipMaker,null,null,_loc3_.cacheName,false,StrataEnum.STRATA_WORLD,this.sysApi.getCurrentZoom());
         delete this._entityTooltipData[_loc2_];
      }
      
      private function displayCursor(param1:int, param2:Boolean = true) : void
      {
         if(param1 == -1)
         {
            Mouse.show();
            LinkedCursorSpriteManager.getInstance().removeItem("interactiveCursor");
            return;
         }
         if(PlayedCharacterManager.getInstance().state != PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
         {
            return;
         }
         var _loc3_:LinkedCursorData = new LinkedCursorData();
         _loc3_.sprite = RoleplayInteractivesFrame.getCursor(param1,param2);
         _loc3_.offset = INTERACTIVE_CURSOR_OFFSET;
         Mouse.hide();
         LinkedCursorSpriteManager.getInstance().addItem("interactiveCursor",_loc3_);
      }
      
      private function onWisperMessage(param1:String) : void
      {
         KernelEventsManager.getInstance().processCallback(ChatHookList.ChatFocus,param1);
      }
      
      private function onMerchantPlayerBuyClick(param1:Number, param2:uint) : void
      {
         var _loc3_:ExchangeOnHumanVendorRequestMessage = new ExchangeOnHumanVendorRequestMessage();
         _loc3_.initExchangeOnHumanVendorRequestMessage(param1,param2);
         ConnectionsHandler.getConnection().send(_loc3_);
      }
      
      private function onInviteMenuClicked(param1:String) : void
      {
         var _loc2_:PartyInvitationRequestMessage = new PartyInvitationRequestMessage();
         _loc2_.initPartyInvitationRequestMessage(param1);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
      
      private function onMerchantHouseKickOff(param1:uint) : void
      {
         var _loc2_:HouseKickIndoorMerchantRequestMessage = new HouseKickIndoorMerchantRequestMessage();
         _loc2_.initHouseKickIndoorMerchantRequestMessage(param1);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
      
      private function onWindowDeactivate(param1:Event) : void
      {
         if(Kernel.getWorker().contains(EntitiesTooltipsFrame))
         {
            Kernel.getWorker().removeFrame(_entitiesTooltipsFrame);
         }
      }
   }
}
