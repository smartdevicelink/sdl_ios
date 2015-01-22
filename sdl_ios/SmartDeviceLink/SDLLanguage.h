//  SDLLanguage.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Specifies the language to be used for TTS, VR, displayed messages/menus
 * <p>
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 *
 */
@interface SDLLanguage : SDLEnum {}

/*!
 @abstract get a Langusge according to a String
 @param value NSString
 @result return the Language
 */
+(SDLLanguage*) valueOf:(NSString*) value;
/*!
 @abstract store all possible Language values
 @result return an array with all possible Language values inside
 */
+(NSMutableArray*) values;

/*!
 @abstract language English_US
 */
+(SDLLanguage*) EN_US;
/*!
 @abstract language ES_MX
 */
+(SDLLanguage*) ES_MX;
/*!
 @abstract language FR_CA
 */
+(SDLLanguage*) FR_CA;
/*!
 @abstract language DE_DE
 */
+(SDLLanguage*) DE_DE;
/*!
 @abstract language ES_ES
 */
+(SDLLanguage*) ES_ES;
/*!
 @abstract language EN_GB
 */
+(SDLLanguage*) EN_GB;
/*!
 @abstract language RU_RU
 */
+(SDLLanguage*) RU_RU;
/*!
 @abstract language TR_TR
 */
+(SDLLanguage*) TR_TR;
/*!
 @abstract language PL_PL
 */
+(SDLLanguage*) PL_PL;
/*!
 @abstract language FR_FR
 */
+(SDLLanguage*) FR_FR;
/*!
 @abstract language IT_IT
 */
+(SDLLanguage*) IT_IT;
/*!
 @abstract language SV_SE
 */
+(SDLLanguage*) SV_SE;
/*!
 @abstract language PT_PT
 */
+(SDLLanguage*) PT_PT;
/*!
 @abstract language NL_NL
 */
+(SDLLanguage*) NL_NL;
/*!
 @abstract language EN_AU
 */
+(SDLLanguage*) EN_AU;
/*!
 @abstract language Chinese
 */
+(SDLLanguage*) ZH_CN;
/*!
 @abstract language Chinese TaiWan
 */
+(SDLLanguage*) ZH_TW;
/*!
 @abstract language JA_JP
 */
+(SDLLanguage*) JA_JP;
/*!
 @abstract language AR_SA
 */
+(SDLLanguage*) AR_SA;
/*!
 @abstract language KO_KR
 */
+(SDLLanguage*) KO_KR;
/*!
 @abstract language PT_BR
 */
+(SDLLanguage*) PT_BR;
/*!
 @abstract language CS_CZ
 */
+(SDLLanguage*) CS_CZ;
/*!
 @abstract language DA_DK
 */
+(SDLLanguage*) DA_DK;
/*!
 @abstract language NO_NO
 */
+(SDLLanguage*) NO_NO;

@end
