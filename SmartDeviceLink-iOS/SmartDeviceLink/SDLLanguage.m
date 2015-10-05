//  SDLLanguage.m
//


#import "SDLLanguage.h"

SDLLanguage *SDLLanguage_EN_US = nil;
SDLLanguage *SDLLanguage_ES_MX = nil;
SDLLanguage *SDLLanguage_FR_CA = nil;
SDLLanguage *SDLLanguage_DE_DE = nil;
SDLLanguage *SDLLanguage_ES_ES = nil;
SDLLanguage *SDLLanguage_EN_GB = nil;
SDLLanguage *SDLLanguage_RU_RU = nil;
SDLLanguage *SDLLanguage_TR_TR = nil;
SDLLanguage *SDLLanguage_PL_PL = nil;
SDLLanguage *SDLLanguage_FR_FR = nil;
SDLLanguage *SDLLanguage_IT_IT = nil;
SDLLanguage *SDLLanguage_SV_SE = nil;
SDLLanguage *SDLLanguage_PT_PT = nil;
SDLLanguage *SDLLanguage_NL_NL = nil;
SDLLanguage *SDLLanguage_EN_AU = nil;
SDLLanguage *SDLLanguage_ZH_CN = nil;
SDLLanguage *SDLLanguage_ZH_TW = nil;
SDLLanguage *SDLLanguage_JA_JP = nil;
SDLLanguage *SDLLanguage_AR_SA = nil;
SDLLanguage *SDLLanguage_KO_KR = nil;
SDLLanguage *SDLLanguage_PT_BR = nil;
SDLLanguage *SDLLanguage_CS_CZ = nil;
SDLLanguage *SDLLanguage_DA_DK = nil;
SDLLanguage *SDLLanguage_NO_NO = nil;

NSArray *SDLLanguage_values = nil;

@implementation SDLLanguage

+ (SDLLanguage *)valueOf:(NSString *)value {
    for (SDLLanguage *item in SDLLanguage.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLLanguage_values == nil) {
        SDLLanguage_values = @[
            SDLLanguage.EN_US,
            SDLLanguage.ES_MX,
            SDLLanguage.FR_CA,
            SDLLanguage.DE_DE,
            SDLLanguage.ES_ES,
            SDLLanguage.EN_GB,
            SDLLanguage.RU_RU,
            SDLLanguage.TR_TR,
            SDLLanguage.PL_PL,
            SDLLanguage.FR_FR,
            SDLLanguage.IT_IT,
            SDLLanguage.SV_SE,
            SDLLanguage.PT_PT,
            SDLLanguage.NL_NL,
            SDLLanguage.EN_AU,
            SDLLanguage.ZH_CN,
            SDLLanguage.ZH_TW,
            SDLLanguage.JA_JP,
            SDLLanguage.AR_SA,
            SDLLanguage.KO_KR,
            SDLLanguage.PT_BR,
            SDLLanguage.CS_CZ,
            SDLLanguage.DA_DK,
            SDLLanguage.NO_NO,
        ];
    }
    return SDLLanguage_values;
}

+ (SDLLanguage *)EN_US {
    if (SDLLanguage_EN_US == nil) {
        SDLLanguage_EN_US = [[SDLLanguage alloc] initWithValue:@"EN-US"];
    }
    return SDLLanguage_EN_US;
}

+ (SDLLanguage *)ES_MX {
    if (SDLLanguage_ES_MX == nil) {
        SDLLanguage_ES_MX = [[SDLLanguage alloc] initWithValue:@"ES-MX"];
    }
    return SDLLanguage_ES_MX;
}

+ (SDLLanguage *)FR_CA {
    if (SDLLanguage_FR_CA == nil) {
        SDLLanguage_FR_CA = [[SDLLanguage alloc] initWithValue:@"FR-CA"];
    }
    return SDLLanguage_FR_CA;
}

+ (SDLLanguage *)DE_DE {
    if (SDLLanguage_DE_DE == nil) {
        SDLLanguage_DE_DE = [[SDLLanguage alloc] initWithValue:@"DE-DE"];
    }
    return SDLLanguage_DE_DE;
}

+ (SDLLanguage *)ES_ES {
    if (SDLLanguage_ES_ES == nil) {
        SDLLanguage_ES_ES = [[SDLLanguage alloc] initWithValue:@"ES-ES"];
    }
    return SDLLanguage_ES_ES;
}

+ (SDLLanguage *)EN_GB {
    if (SDLLanguage_EN_GB == nil) {
        SDLLanguage_EN_GB = [[SDLLanguage alloc] initWithValue:@"EN-GB"];
    }
    return SDLLanguage_EN_GB;
}

+ (SDLLanguage *)RU_RU {
    if (SDLLanguage_RU_RU == nil) {
        SDLLanguage_RU_RU = [[SDLLanguage alloc] initWithValue:@"RU-RU"];
    }
    return SDLLanguage_RU_RU;
}

+ (SDLLanguage *)TR_TR {
    if (SDLLanguage_TR_TR == nil) {
        SDLLanguage_TR_TR = [[SDLLanguage alloc] initWithValue:@"TR-TR"];
    }
    return SDLLanguage_TR_TR;
}

+ (SDLLanguage *)PL_PL {
    if (SDLLanguage_PL_PL == nil) {
        SDLLanguage_PL_PL = [[SDLLanguage alloc] initWithValue:@"PL-PL"];
    }
    return SDLLanguage_PL_PL;
}

+ (SDLLanguage *)FR_FR {
    if (SDLLanguage_FR_FR == nil) {
        SDLLanguage_FR_FR = [[SDLLanguage alloc] initWithValue:@"FR-FR"];
    }
    return SDLLanguage_FR_FR;
}

+ (SDLLanguage *)IT_IT {
    if (SDLLanguage_IT_IT == nil) {
        SDLLanguage_IT_IT = [[SDLLanguage alloc] initWithValue:@"IT-IT"];
    }
    return SDLLanguage_IT_IT;
}

+ (SDLLanguage *)SV_SE {
    if (SDLLanguage_SV_SE == nil) {
        SDLLanguage_SV_SE = [[SDLLanguage alloc] initWithValue:@"SV-SE"];
    }
    return SDLLanguage_SV_SE;
}

+ (SDLLanguage *)PT_PT {
    if (SDLLanguage_PT_PT == nil) {
        SDLLanguage_PT_PT = [[SDLLanguage alloc] initWithValue:@"PT-PT"];
    }
    return SDLLanguage_PT_PT;
}

+ (SDLLanguage *)NL_NL {
    if (SDLLanguage_NL_NL == nil) {
        SDLLanguage_NL_NL = [[SDLLanguage alloc] initWithValue:@"NL-NL"];
    }
    return SDLLanguage_NL_NL;
}

+ (SDLLanguage *)EN_AU {
    if (SDLLanguage_EN_AU == nil) {
        SDLLanguage_EN_AU = [[SDLLanguage alloc] initWithValue:@"EN-AU"];
    }
    return SDLLanguage_EN_AU;
}

+ (SDLLanguage *)ZH_CN {
    if (SDLLanguage_ZH_CN == nil) {
        SDLLanguage_ZH_CN = [[SDLLanguage alloc] initWithValue:@"ZH-CN"];
    }
    return SDLLanguage_ZH_CN;
}

+ (SDLLanguage *)ZH_TW {
    if (SDLLanguage_ZH_TW == nil) {
        SDLLanguage_ZH_TW = [[SDLLanguage alloc] initWithValue:@"ZH-TW"];
    }
    return SDLLanguage_ZH_TW;
}

+ (SDLLanguage *)JA_JP {
    if (SDLLanguage_JA_JP == nil) {
        SDLLanguage_JA_JP = [[SDLLanguage alloc] initWithValue:@"JA-JP"];
    }
    return SDLLanguage_JA_JP;
}

+ (SDLLanguage *)AR_SA {
    if (SDLLanguage_AR_SA == nil) {
        SDLLanguage_AR_SA = [[SDLLanguage alloc] initWithValue:@"AR-SA"];
    }
    return SDLLanguage_AR_SA;
}

+ (SDLLanguage *)KO_KR {
    if (SDLLanguage_KO_KR == nil) {
        SDLLanguage_KO_KR = [[SDLLanguage alloc] initWithValue:@"KO-KR"];
    }
    return SDLLanguage_KO_KR;
}

+ (SDLLanguage *)PT_BR {
    if (SDLLanguage_PT_BR == nil) {
        SDLLanguage_PT_BR = [[SDLLanguage alloc] initWithValue:@"PT-BR"];
    }
    return SDLLanguage_PT_BR;
}

+ (SDLLanguage *)CS_CZ {
    if (SDLLanguage_CS_CZ == nil) {
        SDLLanguage_CS_CZ = [[SDLLanguage alloc] initWithValue:@"CS-CZ"];
    }
    return SDLLanguage_CS_CZ;
}

+ (SDLLanguage *)DA_DK {
    if (SDLLanguage_DA_DK == nil) {
        SDLLanguage_DA_DK = [[SDLLanguage alloc] initWithValue:@"DA-DK"];
    }
    return SDLLanguage_DA_DK;
}

+ (SDLLanguage *)NO_NO {
    if (SDLLanguage_NO_NO == nil) {
        SDLLanguage_NO_NO = [[SDLLanguage alloc] initWithValue:@"NO-NO"];
    }
    return SDLLanguage_NO_NO;
}

@end
