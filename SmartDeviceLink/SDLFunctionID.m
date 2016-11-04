//  SDLFunctionID.m
//


#import "SDLFunctionID.h"

#import "SDLNames.h"

@implementation SDLFunctionID

- (instancetype)init {
    if (self = [super init]) {
        functionIDs = [NSDictionary dictionaryWithObjectsAndKeys:
                                        NAMES_reserved, @"0", NAMES_RegisterAppInterface, @"1", NAMES_UnregisterAppInterface, @"2", NAMES_SetGlobalProperties, @"3", NAMES_ResetGlobalProperties, @"4", NAMES_AddCommand, @"5", NAMES_DeleteCommand, @"6", NAMES_AddSubMenu, @"7", NAMES_DeleteSubMenu, @"8", NAMES_CreateInteractionChoiceSet, @"9", NAMES_PerformInteraction, @"10", NAMES_DeleteInteractionChoiceSet, @"11", NAMES_Alert, @"12", NAMES_Show, @"13", NAMES_Speak, @"14", NAMES_SetMediaClockTimer, @"15", NAMES_PerformAudioPassThru, @"16", NAMES_EndAudioPassThru, @"17", NAMES_SubscribeButton, @"18", NAMES_UnsubscribeButton, @"19", NAMES_SubscribeVehicleData, @"20", NAMES_UnsubscribeVehicleData, @"21", NAMES_GetVehicleData, @"22", NAMES_ReadDID, @"23", NAMES_GetDTCs, @"24", NAMES_ScrollableMessage, @"25", NAMES_Slider, @"26", NAMES_ShowConstantTBT, @"27", NAMES_AlertManeuver, @"28", NAMES_UpdateTurnList, @"29", NAMES_ChangeRegistration, @"30", NAMES_GenericResponse, @"31", NAMES_PutFile, @"32", NAMES_DeleteFile, @"33", NAMES_ListFiles, @"34", NAMES_SetAppIcon, @"35", NAMES_SetDisplayLayout, @"36", NAMES_DiagnosticMessage, @"37", NAMES_SystemRequest, @"38", NAMES_SendLocation, @"39", NAMES_DialNumber, @"40", NAMES_GetWaypoints, @"45", NAMES_SubscribeWaypoints, @"46", NAMES_UnsubscribeWaypoints, @"47", NAMES_OnHMIStatus, @"32768", NAMES_OnAppInterfaceUnregistered, @"32769", NAMES_OnButtonEvent, @"32770", NAMES_OnButtonPress, @"32771", NAMES_OnVehicleData, @"32772", NAMES_OnCommand, @"32773", NAMES_OnTBTClientState, @"32774", NAMES_OnDriverDistraction, @"32775", NAMES_OnPermissionsChange, @"32776", NAMES_OnAudioPassThru, @"32777", NAMES_OnLanguageChange, @"32778", NAMES_OnKeyboardInput, @"32779", NAMES_OnTouchEvent, @"32780", NAMES_OnSystemRequest, @"32781", NAMES_OnHashChange, @"32782", NAMES_OnWaypointChange, @"32784",

                                        NAMES_EncodedSyncPData,
                                        @"65536",
                                        NAMES_SyncPData,
                                        @"65537",

                                        NAMES_OnEncodedSyncPData,
                                        @"98304",
                                        NAMES_OnSyncPData,
                                        @"98305",
                                        nil];
    }
    return self;
}

- (NSString *)getFunctionName:(int)functionID {
    return [functionIDs objectForKey:[NSString stringWithFormat:@"%d", functionID]];
}


- (NSNumber *)getFunctionID:(NSString *)functionName {
    return [NSNumber numberWithInt:[[[functionIDs allKeysForObject:functionName] objectAtIndex:0] intValue]];
}


@end
