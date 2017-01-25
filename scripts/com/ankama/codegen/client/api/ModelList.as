package com.ankama.codegen.client.api
{
   import com.ankama.codegen.client.model.Account;
   import com.ankama.codegen.client.model.AccountStatus;
   import com.ankama.codegen.client.model.ApiExceptionResponseCode;
   import com.ankama.codegen.client.model.ApiKey;
   import com.ankama.codegen.client.model.ApiTransactionReturn;
   import com.ankama.codegen.client.model.AuthenticatorAccount;
   import com.ankama.codegen.client.model.AuthenticatorDevice;
   import com.ankama.codegen.client.model.AuthenticatorError;
   import com.ankama.codegen.client.model.AuthenticatorHelp;
   import com.ankama.codegen.client.model.AuthenticatorRestoreDevice;
   import com.ankama.codegen.client.model.Avatar;
   import com.ankama.codegen.client.model.CmsArticle;
   import com.ankama.codegen.client.model.CmsBookItem;
   import com.ankama.codegen.client.model.CmsNews;
   import com.ankama.codegen.client.model.CmsNewsItem;
   import com.ankama.codegen.client.model.CmsPollInGame;
   import com.ankama.codegen.client.model.ErrorAccountLogin;
   import com.ankama.codegen.client.model.ErrorAccountSuggest;
   import com.ankama.codegen.client.model.ErrorRelation;
   import com.ankama.codegen.client.model.ErrorTranslated;
   import com.ankama.codegen.client.model.ForumPost;
   import com.ankama.codegen.client.model.ForumTopic;
   import com.ankama.codegen.client.model.GameAccount;
   import com.ankama.codegen.client.model.GameActionsAccountAvailable;
   import com.ankama.codegen.client.model.GameActionsAccountConsumed;
   import com.ankama.codegen.client.model.GameActionsActionsAccountCharacterAccountTransfer;
   import com.ankama.codegen.client.model.GameActionsActionsAccountDofusHavenBagPod;
   import com.ankama.codegen.client.model.GameActionsActionsAccountDofusHavenBagRoom;
   import com.ankama.codegen.client.model.GameActionsActionsAccountDofusHavenBagTheme;
   import com.ankama.codegen.client.model.GameActionsActionsAccountDofusItem;
   import com.ankama.codegen.client.model.GameActionsActionsAccountKard;
   import com.ankama.codegen.client.model.GameActionsActionsAccountKrosmagaBooster;
   import com.ankama.codegen.client.model.GameActionsActionsAccountKrosmagaCard;
   import com.ankama.codegen.client.model.GameActionsActionsAccountKrosmagaGod;
   import com.ankama.codegen.client.model.GameActionsActionsAccountKrosmagaKamas;
   import com.ankama.codegen.client.model.GameActionsActionsAccountKrosmagaKick;
   import com.ankama.codegen.client.model.GameActionsActionsAccountKrosmasterFigure;
   import com.ankama.codegen.client.model.GameActionsActionsAccountMeta;
   import com.ankama.codegen.client.model.GameActionsActionsAccountWakfuItem;
   import com.ankama.codegen.client.model.GameActionsActionsDelivered;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredCharacterAccountTransfer;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredDofusHavenBagPod;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredDofusHavenBagRoom;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredDofusHavenBagTheme;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredDofusItem;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredKard;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredKrosmagaBooster;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredKrosmagaCard;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredKrosmagaGod;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredKrosmagaKamas;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredKrosmagaKick;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredKrosmasterFigure;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredMeta;
   import com.ankama.codegen.client.model.GameActionsActionsDeliveredWakfuItem;
   import com.ankama.codegen.client.model.GameActionsActionsMeta;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleCharacterAccountTransfer;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleDofusHavenBagPod;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleDofusHavenBagRoom;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleDofusHavenBagTheme;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleDofusItem;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleKard;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleKrosmasterFigure;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleMeta;
   import com.ankama.codegen.client.model.GameActionsActionsSimpleWakfuItem;
   import com.ankama.codegen.client.model.GameActionsActionsTypeCharacterAccountTransfer;
   import com.ankama.codegen.client.model.GameActionsActionsTypeDofusHavenBagPod;
   import com.ankama.codegen.client.model.GameActionsActionsTypeDofusHavenBagRoom;
   import com.ankama.codegen.client.model.GameActionsActionsTypeDofusItem;
   import com.ankama.codegen.client.model.GameActionsActionsTypeKard;
   import com.ankama.codegen.client.model.GameActionsActionsTypeKrosmasterFigure;
   import com.ankama.codegen.client.model.GameActionsActionsTypeWakfuItem;
   import com.ankama.codegen.client.model.GameActionsCategory;
   import com.ankama.codegen.client.model.GameActionsDefinition;
   import com.ankama.codegen.client.model.GameActionsDescription;
   import com.ankama.codegen.client.model.GameActionsRestriction;
   import com.ankama.codegen.client.model.GameAdminRightResponse;
   import com.ankama.codegen.client.model.HaapiException;
   import com.ankama.codegen.client.model.KardKard;
   import com.ankama.codegen.client.model.KardTypeAction;
   import com.ankama.codegen.client.model.KardTypeKrosmaster;
   import com.ankama.codegen.client.model.LegalContent;
   import com.ankama.codegen.client.model.MoneyBalance;
   import com.ankama.codegen.client.model.OAuthAccount;
   import com.ankama.codegen.client.model.OAuthKey;
   import com.ankama.codegen.client.model.OAuthProvider;
   import com.ankama.codegen.client.model.RelationGroup;
   import com.ankama.codegen.client.model.RelationRelation;
   import com.ankama.codegen.client.model.SessionAccount;
   import com.ankama.codegen.client.model.SessionAccountsPaged;
   import com.ankama.codegen.client.model.SessionLogin;
   import com.ankama.codegen.client.model.ShopArticle;
   import com.ankama.codegen.client.model.ShopBuyError;
   import com.ankama.codegen.client.model.ShopBuyResult;
   import com.ankama.codegen.client.model.ShopCategory;
   import com.ankama.codegen.client.model.ShopGondolaHead;
   import com.ankama.codegen.client.model.ShopHighlight;
   import com.ankama.codegen.client.model.ShopHome;
   import com.ankama.codegen.client.model.ShopIAPsListResponse;
   import com.ankama.codegen.client.model.ShopImage;
   import com.ankama.codegen.client.model.ShopMedia;
   import com.ankama.codegen.client.model.ShopMeta;
   import com.ankama.codegen.client.model.ShopMetaGroup;
   import com.ankama.codegen.client.model.ShopOneClickToken;
   import com.ankama.codegen.client.model.ShopOrder;
   import com.ankama.codegen.client.model.ShopPaymentHkCodeSendResult;
   import com.ankama.codegen.client.model.ShopPromo;
   import com.ankama.codegen.client.model.ShopReference;
   import com.ankama.codegen.client.model.ShopReferenceTypeAccountStatus;
   import com.ankama.codegen.client.model.ShopReferenceTypeCharTransfer;
   import com.ankama.codegen.client.model.ShopReferenceTypeDigitalComic;
   import com.ankama.codegen.client.model.ShopReferenceTypeFlag;
   import com.ankama.codegen.client.model.ShopReferenceTypeGameAction;
   import com.ankama.codegen.client.model.ShopReferenceTypeIceGift;
   import com.ankama.codegen.client.model.ShopReferenceTypeKard;
   import com.ankama.codegen.client.model.ShopReferenceTypeKrosmaster;
   import com.ankama.codegen.client.model.ShopReferenceTypeMusic;
   import com.ankama.codegen.client.model.ShopReferenceTypeNothing;
   import com.ankama.codegen.client.model.ShopReferenceTypeOgrine;
   import com.ankama.codegen.client.model.ShopReferenceTypePremium;
   import com.ankama.codegen.client.model.ShopReferenceTypeRecurringVirtualSubscription;
   import com.ankama.codegen.client.model.ShopReferenceTypeTactilewars;
   import com.ankama.codegen.client.model.ShopReferenceTypeVideo;
   import com.ankama.codegen.client.model.ShopReferenceTypeVirtualGift;
   import com.ankama.codegen.client.model.ShopReferenceTypeVirtualSubscriptionLevel;
   import com.ankama.codegen.client.model.SteamAccountApp;
   import com.ankama.codegen.client.model.SteamAccountDLC;
   import com.ankama.codegen.client.model.SteamAccountMeta;
   import com.ankama.codegen.client.model.SteamDLC;
   import com.ankama.codegen.client.model.ThemisModel;
   import com.ankama.codegen.client.model.Token;
   
   public class ModelList
   {
       
      
      private var forceImportAccount:Account = null;
      
      private var forceImportAvatar:Avatar = null;
      
      private var forceImportErrorTranslated:ErrorTranslated = null;
      
      private var forceImportToken:Token = null;
      
      private var forceImportErrorAccountLogin:ErrorAccountLogin = null;
      
      private var forceImportSessionLogin:SessionLogin = null;
      
      private var forceImportGameAccount:GameAccount = null;
      
      private var forceImportSessionAccountsPaged:SessionAccountsPaged = null;
      
      private var forceImportErrorAccountSuggest:ErrorAccountSuggest = null;
      
      private var forceImportSessionAccount:SessionAccount = null;
      
      private var forceImportAccountStatus:AccountStatus = null;
      
      private var forceImportApiTransactionReturn:ApiTransactionReturn = null;
      
      private var forceImportApiKey:ApiKey = null;
      
      private var forceImportOAuthAccount:OAuthAccount = null;
      
      private var forceImportOAuthProvider:OAuthProvider = null;
      
      private var forceImportOAuthKey:OAuthKey = null;
      
      private var forceImportAuthenticatorError:AuthenticatorError = null;
      
      private var forceImportAuthenticatorAccount:AuthenticatorAccount = null;
      
      private var forceImportAuthenticatorDevice:AuthenticatorDevice = null;
      
      private var forceImportAuthenticatorHelp:AuthenticatorHelp = null;
      
      private var forceImportAuthenticatorRestoreDevice:AuthenticatorRestoreDevice = null;
      
      private var forceImportCmsBookItem:CmsBookItem = null;
      
      private var forceImportCmsArticle:CmsArticle = null;
      
      private var forceImportCmsNews:CmsNews = null;
      
      private var forceImportCmsNewsItem:CmsNewsItem = null;
      
      private var forceImportCmsPollInGame:CmsPollInGame = null;
      
      private var forceImportSteamDLC:SteamDLC = null;
      
      private var forceImportForumPost:ForumPost = null;
      
      private var forceImportApiExceptionResponseCode:ApiExceptionResponseCode = null;
      
      private var forceImportForumTopic:ForumTopic = null;
      
      private var forceImportGameAdminRightResponse:GameAdminRightResponse = null;
      
      private var forceImportGameActionsAccountAvailable:GameActionsAccountAvailable = null;
      
      private var forceImportGameActionsActionsAccountCharacterAccountTransfer:GameActionsActionsAccountCharacterAccountTransfer = null;
      
      private var forceImportGameActionsActionsAccountDofusHavenBagPod:GameActionsActionsAccountDofusHavenBagPod = null;
      
      private var forceImportGameActionsActionsAccountDofusHavenBagRoom:GameActionsActionsAccountDofusHavenBagRoom = null;
      
      private var forceImportGameActionsActionsAccountDofusHavenBagTheme:GameActionsActionsAccountDofusHavenBagTheme = null;
      
      private var forceImportGameActionsActionsAccountDofusItem:GameActionsActionsAccountDofusItem = null;
      
      private var forceImportGameActionsActionsAccountKard:GameActionsActionsAccountKard = null;
      
      private var forceImportGameActionsActionsAccountKrosmasterFigure:GameActionsActionsAccountKrosmasterFigure = null;
      
      private var forceImportGameActionsActionsAccountWakfuItem:GameActionsActionsAccountWakfuItem = null;
      
      private var forceImportGameActionsActionsAccountKrosmagaBooster:GameActionsActionsAccountKrosmagaBooster = null;
      
      private var forceImportGameActionsActionsAccountKrosmagaCard:GameActionsActionsAccountKrosmagaCard = null;
      
      private var forceImportGameActionsActionsAccountKrosmagaGod:GameActionsActionsAccountKrosmagaGod = null;
      
      private var forceImportGameActionsActionsAccountKrosmagaKamas:GameActionsActionsAccountKrosmagaKamas = null;
      
      private var forceImportGameActionsActionsAccountKrosmagaKick:GameActionsActionsAccountKrosmagaKick = null;
      
      private var forceImportGameActionsActionsAccountMeta:GameActionsActionsAccountMeta = null;
      
      private var forceImportGameActionsActionsSimpleCharacterAccountTransfer:GameActionsActionsSimpleCharacterAccountTransfer = null;
      
      private var forceImportGameActionsDescription:GameActionsDescription = null;
      
      private var forceImportGameActionsActionsSimpleDofusHavenBagRoom:GameActionsActionsSimpleDofusHavenBagRoom = null;
      
      private var forceImportGameActionsActionsSimpleDofusHavenBagPod:GameActionsActionsSimpleDofusHavenBagPod = null;
      
      private var forceImportGameActionsActionsSimpleDofusHavenBagTheme:GameActionsActionsSimpleDofusHavenBagTheme = null;
      
      private var forceImportGameActionsActionsSimpleDofusItem:GameActionsActionsSimpleDofusItem = null;
      
      private var forceImportGameActionsActionsSimpleKard:GameActionsActionsSimpleKard = null;
      
      private var forceImportGameActionsActionsSimpleKrosmasterFigure:GameActionsActionsSimpleKrosmasterFigure = null;
      
      private var forceImportGameActionsActionsSimpleWakfuItem:GameActionsActionsSimpleWakfuItem = null;
      
      private var forceImportGameActionsActionsDeliveredKrosmagaBooster:GameActionsActionsDeliveredKrosmagaBooster = null;
      
      private var forceImportGameActionsActionsDeliveredKrosmagaCard:GameActionsActionsDeliveredKrosmagaCard = null;
      
      private var forceImportGameActionsActionsDeliveredKrosmagaGod:GameActionsActionsDeliveredKrosmagaGod = null;
      
      private var forceImportGameActionsActionsDeliveredKrosmagaKamas:GameActionsActionsDeliveredKrosmagaKamas = null;
      
      private var forceImportGameActionsActionsDeliveredKrosmagaKick:GameActionsActionsDeliveredKrosmagaKick = null;
      
      private var forceImportGameActionsActionsMeta:GameActionsActionsMeta = null;
      
      private var forceImportGameActionsActionsSimpleMeta:GameActionsActionsSimpleMeta = null;
      
      private var forceImportGameActionsActionsDeliveredCharacterAccountTransfer:GameActionsActionsDeliveredCharacterAccountTransfer = null;
      
      private var forceImportGameActionsActionsDeliveredDofusHavenBagPod:GameActionsActionsDeliveredDofusHavenBagPod = null;
      
      private var forceImportGameActionsActionsDeliveredDofusHavenBagRoom:GameActionsActionsDeliveredDofusHavenBagRoom = null;
      
      private var forceImportGameActionsActionsDeliveredDofusHavenBagTheme:GameActionsActionsDeliveredDofusHavenBagTheme = null;
      
      private var forceImportGameActionsActionsDeliveredDofusItem:GameActionsActionsDeliveredDofusItem = null;
      
      private var forceImportGameActionsActionsDeliveredKard:GameActionsActionsDeliveredKard = null;
      
      private var forceImportGameActionsActionsDeliveredKrosmasterFigure:GameActionsActionsDeliveredKrosmasterFigure = null;
      
      private var forceImportGameActionsActionsDeliveredWakfuItem:GameActionsActionsDeliveredWakfuItem = null;
      
      private var forceImportGameActionsActionsDeliveredMeta:GameActionsActionsDeliveredMeta = null;
      
      private var forceImportGameActionsAccountConsumed:GameActionsAccountConsumed = null;
      
      private var forceImportGameActionsActionsDelivered:GameActionsActionsDelivered = null;
      
      private var forceImportGameActionsCategory:GameActionsCategory = null;
      
      private var forceImportGameActionsDefinition:GameActionsDefinition = null;
      
      private var forceImportGameActionsActionsTypeCharacterAccountTransfer:GameActionsActionsTypeCharacterAccountTransfer = null;
      
      private var forceImportGameActionsActionsTypeDofusHavenBagPod:GameActionsActionsTypeDofusHavenBagPod = null;
      
      private var forceImportGameActionsActionsTypeDofusHavenBagRoom:GameActionsActionsTypeDofusHavenBagRoom = null;
      
      private var forceImportGameActionsActionsTypeDofusItem:GameActionsActionsTypeDofusItem = null;
      
      private var forceImportGameActionsActionsTypeKard:GameActionsActionsTypeKard = null;
      
      private var forceImportGameActionsActionsTypeKrosmasterFigure:GameActionsActionsTypeKrosmasterFigure = null;
      
      private var forceImportGameActionsActionsTypeWakfuItem:GameActionsActionsTypeWakfuItem = null;
      
      private var forceImportGameActionsRestriction:GameActionsRestriction = null;
      
      private var forceImportKardKard:KardKard = null;
      
      private var forceImportKardTypeKrosmaster:KardTypeKrosmaster = null;
      
      private var forceImportKardTypeAction:KardTypeAction = null;
      
      private var forceImportLegalContent:LegalContent = null;
      
      private var forceImportMoneyBalance:MoneyBalance = null;
      
      private var forceImportErrorRelation:ErrorRelation = null;
      
      private var forceImportRelationGroup:RelationGroup = null;
      
      private var forceImportRelationRelation:RelationRelation = null;
      
      private var forceImportShopArticle:ShopArticle = null;
      
      private var forceImportShopImage:ShopImage = null;
      
      private var forceImportShopReference:ShopReference = null;
      
      private var forceImportShopReferenceTypeAccountStatus:ShopReferenceTypeAccountStatus = null;
      
      private var forceImportShopReferenceTypeIceGift:ShopReferenceTypeIceGift = null;
      
      private var forceImportShopReferenceTypeVirtualGift:ShopReferenceTypeVirtualGift = null;
      
      private var forceImportShopReferenceTypeKard:ShopReferenceTypeKard = null;
      
      private var forceImportShopReferenceTypeKrosmaster:ShopReferenceTypeKrosmaster = null;
      
      private var forceImportShopReferenceTypeNothing:ShopReferenceTypeNothing = null;
      
      private var forceImportShopReferenceTypeTactilewars:ShopReferenceTypeTactilewars = null;
      
      private var forceImportShopReferenceTypeVirtualSubscriptionLevel:ShopReferenceTypeVirtualSubscriptionLevel = null;
      
      private var forceImportShopReferenceTypeVideo:ShopReferenceTypeVideo = null;
      
      private var forceImportShopReferenceTypeMusic:ShopReferenceTypeMusic = null;
      
      private var forceImportShopReferenceTypeFlag:ShopReferenceTypeFlag = null;
      
      private var forceImportShopReferenceTypeCharTransfer:ShopReferenceTypeCharTransfer = null;
      
      private var forceImportShopReferenceTypeDigitalComic:ShopReferenceTypeDigitalComic = null;
      
      private var forceImportShopReferenceTypePremium:ShopReferenceTypePremium = null;
      
      private var forceImportShopReferenceTypeRecurringVirtualSubscription:ShopReferenceTypeRecurringVirtualSubscription = null;
      
      private var forceImportShopReferenceTypeOgrine:ShopReferenceTypeOgrine = null;
      
      private var forceImportShopReferenceTypeGameAction:ShopReferenceTypeGameAction = null;
      
      private var forceImportShopPromo:ShopPromo = null;
      
      private var forceImportShopMedia:ShopMedia = null;
      
      private var forceImportShopMetaGroup:ShopMetaGroup = null;
      
      private var forceImportShopMeta:ShopMeta = null;
      
      private var forceImportShopBuyResult:ShopBuyResult = null;
      
      private var forceImportShopBuyError:ShopBuyError = null;
      
      private var forceImportShopCategory:ShopCategory = null;
      
      private var forceImportShopGondolaHead:ShopGondolaHead = null;
      
      private var forceImportShopHighlight:ShopHighlight = null;
      
      private var forceImportShopHome:ShopHome = null;
      
      private var forceImportShopIAPsListResponse:ShopIAPsListResponse = null;
      
      private var forceImportShopPaymentHkCodeSendResult:ShopPaymentHkCodeSendResult = null;
      
      private var forceImportShopOneClickToken:ShopOneClickToken = null;
      
      private var forceImportShopOrder:ShopOrder = null;
      
      private var forceImportSteamAccountDLC:SteamAccountDLC = null;
      
      private var forceImportSteamAccountApp:SteamAccountApp = null;
      
      private var forceImportSteamAccountMeta:SteamAccountMeta = null;
      
      private var forceImportThemisModel:ThemisModel = null;
      
      private var forceImportHaapiException:HaapiException = null;
      
      public function ModelList()
      {
         super();
      }
   }
}
