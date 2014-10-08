//  SDLLanguage.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLLanguage : SDLEnum {}

+(SDLLanguage*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLLanguage*) EN_US;
+(SDLLanguage*) ES_MX;
+(SDLLanguage*) FR_CA;
+(SDLLanguage*) DE_DE;
+(SDLLanguage*) ES_ES;
+(SDLLanguage*) EN_GB;
+(SDLLanguage*) RU_RU;
+(SDLLanguage*) TR_TR;
+(SDLLanguage*) PL_PL;
+(SDLLanguage*) FR_FR;
+(SDLLanguage*) IT_IT;
+(SDLLanguage*) SV_SE;
+(SDLLanguage*) PT_PT;
+(SDLLanguage*) NL_NL;
+(SDLLanguage*) EN_AU;
+(SDLLanguage*) ZH_CN;
+(SDLLanguage*) ZH_TW;
+(SDLLanguage*) JA_JP;
+(SDLLanguage*) AR_SA;
+(SDLLanguage*) KO_KR;
+(SDLLanguage*) PT_BR;
+(SDLLanguage*) CS_CZ;
+(SDLLanguage*) DA_DK;
+(SDLLanguage*) NO_NO;

@end
