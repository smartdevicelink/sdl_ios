import re
from collections import namedtuple, OrderedDict
from unittest import TestCase

from model.array import Array
from model.boolean import Boolean
from model.enum import Enum
from model.enum_element import EnumElement
from model.float import Float
from model.function import Function
from model.integer import Integer
from model.param import Param
from model.string import String
from model.struct import Struct
from transformers.functions_producer import FunctionsProducer


class TestFunctionsProducer(TestCase):
    """
    The structures of tests in this class was prepared to cover all possible combinations of code branching in tested
    class FunctionsProducer.
    All names of Functions and nested elements doesn't reflating with real Functions
    and could be replaces with some meaningless names.

    After performing Tests there are following initial test code coverage:
    generator/transformers/common_producer.py		99%
    generator/transformers/functions_producer.py	100%
    """

    def setUp(self):
        self.maxDiff = None

        Paths = namedtuple('Paths', 'request_class response_class notification_class function_names parameter_names')
        paths = Paths(request_class='SDLRPCRequest',
                      response_class='SDLRPCResponse',
                      notification_class='SDLRPCNotification',
                      function_names='SDLRPCFunctionNames',
                      parameter_names='SDLRPCParameterNames')

        names = ('FileType', 'Language', 'SyncMsgVersion', 'TemplateColorScheme', 'TTSChunk', 'Choice')
        self.producer = FunctionsProducer(paths, names)

    def test_process_function_name(self):
        """
        generator/transformers/common_producer.py		29%
        generator/transformers/functions_producer.py	61%
        """
        functions = {
            'RegisterAppInterface': Function(name='RegisterAppInterface',
                                             function_id=EnumElement(name='RegisterAppInterfaceID'), since='3.0.0',
                                             message_type=EnumElement(name='request'),
                                             description=['RegisterAppInterface description'], params={
                    'syncMsgVersion': Param(name='syncMsgVersion', param_type=Float(), since='3.5.0',
                                            description=['syncMsgVersion description'])}),
            'OnHMIStatus': Function(name='OnHMIStatus', function_id=EnumElement(name='OnHMIStatusID'), since='4.0.0',
                                    message_type=EnumElement(name='notification'),
                                    description=['OnHMIStatus description'], params={
                    'acEnable': Param(name='acEnable', param_type=Integer(), since='4.5.0',
                                      description=['acEnable description'])})}
        structs = {
            'SoftButton': Struct(name='SoftButton', members={
                'image': Param(name='image', param_type=String(), since='1.0.0', description=['image description']),
                'ignore': Param(name='ignore', param_type=Struct(name='ignore'))}),
            'PresetBankCapabilities': Struct(name='PresetBankCapabilities', members={
                'availableHdChannelsAvailable': Param(name='availableHdChannelsAvailable', param_type=Boolean(),
                                                      since='2.0.0',
                                                      description=['availableHDChannelsAvailable description'])})}

        expected = [
            self.producer.common_names(
                description=['OnHMIStatus description'], name='OnHMIStatus', origin='OnHMIStatus', since='4.0.0'),
            self.producer.common_names(
                description=['RegisterAppInterface description'], name='RegisterAppInterface',
                origin='RegisterAppInterface', since='3.0.0')]
        actual = self.producer.get_function_names(functions)
        self.assertListEqual(expected, actual['params'])

        expected = [
            self.producer.common_names(description=['acEnable description'], name='AcEnable',
                                       origin='acEnable', since='4.5.0'),
            self.producer.common_names(description=['availableHDChannelsAvailable description'],
                                       since='2.0.0', name='AvailableHdChannelsAvailable',
                                       origin='availableHdChannelsAvailable'),
            self.producer.common_names(description=[], name='Ignore', origin='ignore', since=None),
            self.producer.common_names(description=['image description'], name='Image', origin='image', since='1.0.0'),
            self.producer.common_names(description=[], name='PresetBankCapabilities', origin='PresetBankCapabilities',
                                       since=None),
            self.producer.common_names(description=[], name='SoftButton', origin='SoftButton', since=None),
            self.producer.common_names(description=['syncMsgVersion description'], name='SdlMsgVersion',
                                       origin='syncMsgVersion', since='3.5.0')]
        actual = self.producer.get_simple_params(functions, structs)
        self.assertCountEqual(expected, actual['params'])

    def test_RegisterAppInterfaceRequest(self):
        """
        generator/transformers/common_producer.py		85%
        generator/transformers/functions_producer.py	63%
        """
        params = OrderedDict()
        params['syncMsgVersion'] = Param(
            name='syncMsgVersion', param_type=Struct(name='SyncMsgVersion', description=['Specifies the'], members={
                'majorVersion': Param(name='majorVersion', param_type=Integer())}), description=['See SyncMsgVersion'],
            is_mandatory=True)
        params['fullAppID'] = Param(name='fullAppID', description=['ID used'], param_type=String(), is_mandatory=False)
        params['dayColorScheme'] = Param(
            name='dayColorScheme', param_type=Struct(name='TemplateColorScheme', description=[
                '\n            A color scheme for all display layout templates.\n        ']), is_mandatory=False)
        params['ttsName'] = Param(
            name='ttsName', description=['\n      TTS string for'], is_mandatory=False,
            param_type=Array(element_type=Struct(name='TTSChunk', description=['A TTS chunk'])))
        params['isMediaApplication'] = Param(
            name='isMediaApplication', param_type=Boolean(),
            description=['\n                Indicates if the application is a media or a '], is_mandatory=True)

        item = Function(name='RegisterAppInterface', function_id=EnumElement(name='RegisterAppInterfaceID'),
                        since='1.0.0',
                        description=['\n            Establishes an interface with a mobile application.\n            '
                                     'Before registerAppInterface no other commands will be accepted/executed.\n     '],
                        message_type=EnumElement(name='request'), params=params)
        expected = OrderedDict()
        expected['origin'] = 'RegisterAppInterface'
        expected['name'] = 'SDLRegisterAppInterface'
        expected['extends_class'] = 'SDLRPCRequest'
        expected['imports'] = {
            '.h': {'enum': {'SDLRPCRequest'}, 'struct': {'SDLTemplateColorScheme', 'SDLTTSChunk', 'SDLSdlMsgVersion'}},
            '.m': {'SDLTemplateColorScheme', 'SDLTTSChunk', 'SDLSdlMsgVersion'}}
        expected['description'] = ['Establishes an interface with a mobile application. Before registerAppInterface no '
                                   'other commands will be', 'accepted/executed.']
        expected['since'] = '1.0.0'
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='sdlMsgVersion', constructor_argument_override=None,
                constructor_prefix='SdlMsgVersion', deprecated=False, description=['See SyncMsgVersion'],
                for_name='object', mandatory=True, method_suffix='SdlMsgVersion', modifier='strong',
                of_class='SDLSdlMsgVersion.class', origin='sdlMsgVersion', since=None,
                type_native='SDLSdlMsgVersion *', type_sdl='SDLSdlMsgVersion *'),
            self.producer.param_named(
                constructor_argument='fullAppID', constructor_argument_override=None, constructor_prefix='FullAppID',
                deprecated=False, description=['ID used',
                                               '{"default_value": null, "max_length": null, "min_length": null}'],
                for_name='object', mandatory=False, method_suffix='FullAppID', modifier='strong',
                of_class='NSString.class', origin='fullAppID', since=None, type_native='NSString *',
                type_sdl='NSString *'),
            self.producer.param_named(
                constructor_argument='dayColorScheme', constructor_argument_override=None, mandatory=False,
                constructor_prefix='DayColorScheme', deprecated=False, description=[], for_name='object',
                method_suffix='DayColorScheme', modifier='strong', of_class='SDLTemplateColorScheme.class',
                origin='dayColorScheme', since=None, type_native='SDLTemplateColorScheme *',
                type_sdl='SDLTemplateColorScheme *'),
            self.producer.param_named(
                constructor_argument='ttsName', constructor_argument_override=None, constructor_prefix='TtsName',
                deprecated=False, description=['TTS string for'], for_name='objects', mandatory=False,
                method_suffix='TtsName', modifier='strong', of_class='SDLTTSChunk.class', origin='ttsName', since=None,
                type_native='NSArray<SDLTTSChunk *> *', type_sdl='NSArray<SDLTTSChunk *> *'),
            self.producer.param_named(
                constructor_argument='isMediaApplication', constructor_argument_override=None,
                constructor_prefix='IsMediaApplication', deprecated=False,
                description=['Indicates if the application is a media or a'], for_name='object', mandatory=True,
                method_suffix='IsMediaApplication', modifier='strong', of_class='NSNumber.class',
                origin='isMediaApplication', since=None, type_native='BOOL', type_sdl='NSNumber<SDLBool> *'))

        mandatory_arguments = [
            self.producer.argument_named(variable='sdlMsgVersion', deprecated=False, origin='sdlMsgVersion',
                                         constructor_argument='sdlMsgVersion'),
            self.producer.argument_named(variable='isMediaApplication', deprecated=False, origin='isMediaApplication',
                                         constructor_argument='@(isMediaApplication)')]
        not_mandatory_arguments = [
            self.producer.argument_named(variable='fullAppID', deprecated=False, origin='fullAppID',
                                         constructor_argument='fullAppID'),
            self.producer.argument_named(variable='dayColorScheme', deprecated=False, origin='dayColorScheme',
                                         constructor_argument='dayColorScheme'),
            self.producer.argument_named(variable='ttsName', deprecated=False, origin='ttsName',
                                         constructor_argument='ttsName')]
        mandatory_init = 'SdlMsgVersion:(SDLSdlMsgVersion *)sdlMsgVersion ' \
                         'isMediaApplication:(BOOL)isMediaApplication'

        expected['constructors'] = (
            self.producer.constructor_named(
                all=mandatory_arguments, arguments=mandatory_arguments, deprecated=False,
                init=mandatory_init, self=True),
            self.producer.constructor_named(
                all=mandatory_arguments + not_mandatory_arguments, arguments=not_mandatory_arguments, deprecated=False,
                init=mandatory_init + ' fullAppID:(nullable NSString *)fullAppID dayColorScheme:(nullable '
                                      'SDLTemplateColorScheme *)dayColorScheme ttsName:(nullable NSArray<SDLTTSChunk '
                                      '*> *)ttsName',
                self=re.sub(r'([\w\d]+:)\([\w\d\s<>*]*\)([\w\d]+\s*)', r'\1\2', mandatory_init)))

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)

    def test_RegisterAppInterfaceResponse(self):
        """
        generator/transformers/common_producer.py		82%
        generator/transformers/functions_producer.py	63%
        """
        params = OrderedDict()
        params['success'] = Param(name='success', param_type=Boolean(), description=[' True if '], is_mandatory=False)
        params['language'] = Param(name='language', is_mandatory=False, param_type=Enum(name='Language', elements={
            'EN-US': EnumElement(name='EN-US', description=['English - US'])}), description=['The currently'])
        params['supportedDiagModes'] = Param(
            name='supportedDiagModes', is_mandatory=False, description=['\n                Specifies the'],
            param_type=Array(element_type=Integer(max_value=255, min_value=0), max_size=100, min_size=1))
        params['hmiZoneCapabilities'] = Param(name='hmiZoneCapabilities', is_mandatory=False,
                                              param_type=Array(element_type=Enum(name='HmiZoneCapabilities'),
                                                               max_size=100, min_size=1))

        item = Function(name='RegisterAppInterface', function_id=EnumElement(name='RegisterAppInterfaceID'),
                        description=['The response '], message_type=EnumElement(name='response'), params=params)

        expected = OrderedDict()
        expected['origin'] = 'RegisterAppInterface'
        expected['name'] = 'SDLRegisterAppInterfaceResponse'
        expected['extends_class'] = 'SDLRPCResponse'
        expected['imports'] = {'.h': {'enum': {'SDLRPCResponse', 'SDLLanguage'}, 'struct': set()},
                               '.m': {'SDLLanguage'}}
        expected['description'] = ['The response']
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='language', constructor_argument_override=None, constructor_prefix='Language',
                deprecated=False, description=['The currently'], for_name='enum', mandatory=False,
                method_suffix='Language', modifier='strong', of_class='', origin='language',
                since=None, type_native='SDLLanguage ', type_sdl='SDLLanguage '),
            self.producer.param_named(
                constructor_argument='supportedDiagModes', constructor_argument_override=None,
                constructor_prefix='SupportedDiagModes', deprecated=False, description=['Specifies the'],
                for_name='objects', mandatory=False, method_suffix='SupportedDiagModes', modifier='strong',
                of_class='NSNumber.class', origin='supportedDiagModes', since=None,
                type_native='NSArray<NSNumber<SDLUInt> *> *', type_sdl='NSArray<NSNumber<SDLUInt> *> *'),
            self.producer.param_named(
                constructor_argument='hmiZoneCapabilities', constructor_argument_override=None,
                constructor_prefix='HmiZoneCapabilities', deprecated=False, description=[], for_name='enums',
                mandatory=False, method_suffix='HmiZoneCapabilities', modifier='strong',
                of_class='', origin='hmiZoneCapabilities', since=None,
                type_native='NSArray<SDLHmiZoneCapabilities> *', type_sdl='NSArray<SDLHmiZoneCapabilities> *'))

        arguments = [self.producer.argument_named(
            variable='language', deprecated=False, origin='language', constructor_argument='language'),
            self.producer.argument_named(
                variable='supportedDiagModes', deprecated=False, origin='supportedDiagModes',
                constructor_argument='supportedDiagModes'),
            self.producer.argument_named(
                variable='hmiZoneCapabilities', deprecated=False, origin='hmiZoneCapabilities',
                constructor_argument='hmiZoneCapabilities')]

        expected['constructors'] = (
            self.producer.constructor_named(
                all=arguments, arguments=arguments, deprecated=False,
                init='Language:(nullable SDLLanguage)language supportedDiagModes:(nullable NSArray<NSNumber<SDLUInt> *>'
                     ' *)supportedDiagModes hmiZoneCapabilities:(nullable NSArray<SDLHmiZoneCapabilities> *)'
                     'hmiZoneCapabilities',
                self=''),)

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)

    def test_OnHMIStatus(self):
        """
        generator/transformers/common_producer.py		66%
        generator/transformers/functions_producer.py	65%
        """
        item = Function(name='OnHMIStatus', function_id=EnumElement(name='OnHMIStatusID'),
                        message_type=EnumElement(name='notification'), params={
                'hmiLevel': Param(name='hmiLevel', param_type=Enum(name='HMILevel'))
            })
        expected = OrderedDict()
        expected['origin'] = 'OnHMIStatus'
        expected['name'] = 'SDLOnHMIStatus'
        expected['extends_class'] = 'SDLRPCNotification'
        expected['imports'] = {
            ".h": {'enum': {'SDLRPCNotification'}, 'struct': set()},
            ".m": set()
        }
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='hmiLevel', constructor_argument_override=None, constructor_prefix='HmiLevel',
                deprecated=False, description=[], for_name='enum', mandatory=True, method_suffix='HmiLevel',
                modifier='strong', of_class='', origin='hmiLevel', since=None,
                type_native='SDLHMILevel ', type_sdl='SDLHMILevel '),)

        arguments = [self.producer.argument_named(variable='hmiLevel', deprecated=False, origin='hmiLevel',
                                                  constructor_argument='hmiLevel')]

        expected['constructors'] = (self.producer.constructor_named(
            all=arguments, arguments=arguments, deprecated=False, self=True, init='HmiLevel:(SDLHMILevel)hmiLevel'),)

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)

    def test_CreateWindow(self):
        """
        generator/transformers/common_producer.py		82%
        generator/transformers/functions_producer.py	63%
        """
        params = OrderedDict()
        params['windowID'] = Param(name='windowID', param_type=Integer())
        params['cmdID'] = Param(name='cmdID', param_type=Integer(max_value=2000000000, min_value=0))
        params['position'] = Param(name='position', param_type=Integer(default_value=1000, max_value=1000, min_value=0))
        params['speed'] = Param(name='speed', param_type=Float(max_value=700.0, min_value=0.0))
        params['offset'] = Param(name='offset', param_type=Integer(max_value=100000000000, min_value=0))
        params['duplicateUpdatesFromWindowID'] = Param(name='duplicateUpdatesFromWindowID', param_type=Integer(),
                                                       is_mandatory=False)
        item = Function(name='CreateWindow', function_id=EnumElement(name='CreateWindowID'),
                        message_type=EnumElement(name='request'), params=params)

        expected = OrderedDict()
        expected['origin'] = 'CreateWindow'
        expected['name'] = 'SDLCreateWindow'
        expected['extends_class'] = 'SDLRPCRequest'
        expected['imports'] = {'.m': set(), '.h': {'struct': set(), 'enum': {'SDLRPCRequest'}}}
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='windowID', constructor_argument_override=None, constructor_prefix='WindowID',
                deprecated=False, description=['{"default_value": null, "max_value": null, "min_value": null}'],
                for_name='object', mandatory=True, method_suffix='WindowID', modifier='strong',
                of_class='NSNumber.class', origin='windowID', since=None, type_native='UInt32',
                type_sdl='NSNumber<SDLInt> *'),
            self.producer.param_named(
                constructor_argument='cmdID', constructor_argument_override=None, constructor_prefix='CmdID',
                deprecated=False, description=['{"default_value": null, "max_value": 2000000000, "min_value": 0}'],
                for_name='object', mandatory=True, method_suffix='CmdID', modifier='strong', of_class='NSNumber.class',
                origin='cmdID', since=None, type_native='UInt32', type_sdl='NSNumber<SDLUInt> *'),
            self.producer.param_named(
                constructor_argument='position', constructor_argument_override=None, constructor_prefix='Position',
                deprecated=False, description=['{"default_value": 1000, "max_value": 1000, "min_value": 0}'],
                for_name='object', mandatory=True, method_suffix='Position', modifier='strong',
                of_class='NSNumber.class', origin='position', since=None, type_native='UInt16',
                type_sdl='NSNumber<SDLUInt> *'),
            self.producer.param_named(
                constructor_argument='speed', constructor_argument_override=None, constructor_prefix='Speed',
                deprecated=False, description=['{"default_value": null, "max_value": 700.0, "min_value": 0.0}'],
                for_name='object', mandatory=True, method_suffix='Speed', modifier='strong', of_class='NSNumber.class',
                origin='speed', since=None, type_native='float', type_sdl='NSNumber<SDLFloat> *'),
            self.producer.param_named(
                constructor_argument='offset', constructor_argument_override=None, constructor_prefix='Offset',
                deprecated=False, description=['{"default_value": null, "max_value": 100000000000, "min_value": 0}'],
                for_name='object', mandatory=True, method_suffix='Offset', modifier='strong', of_class='NSNumber.class',
                origin='offset', since=None, type_native='UInt64', type_sdl='NSNumber<SDLUInt> *'),
            self.producer.param_named(
                constructor_argument='duplicateUpdatesFromWindowID', constructor_argument_override=None,
                constructor_prefix='DuplicateUpdatesFromWindowID', deprecated=False,
                description=['{"default_value": null, "max_value": null, "min_value": null}'], for_name='object',
                mandatory=False, method_suffix='DuplicateUpdatesFromWindowID', modifier='strong',
                of_class='NSNumber.class', origin='duplicateUpdatesFromWindowID', since=None,
                type_native='NSNumber<SDLInt> *', type_sdl='NSNumber<SDLInt> *'))

        not_mandatory_arguments = [
            self.producer.argument_named(variable='windowID', deprecated=False, origin='windowID',
                                         constructor_argument='@(windowID)'),
            self.producer.argument_named(variable='cmdID', deprecated=False, origin='cmdID',
                                         constructor_argument='@(cmdID)'),
            self.producer.argument_named(variable='position', deprecated=False, origin='position',
                                         constructor_argument='@(position)'),
            self.producer.argument_named(variable='speed', deprecated=False, origin='speed',
                                         constructor_argument='@(speed)'),
            self.producer.argument_named(variable='offset', deprecated=False, origin='offset',
                                         constructor_argument='@(offset)')]
        mandatory_arguments = [self.producer.argument_named(
            variable='duplicateUpdatesFromWindowID', deprecated=False, origin='duplicateUpdatesFromWindowID',
            constructor_argument='duplicateUpdatesFromWindowID')]

        expected['constructors'] = (
            self.producer.constructor_named(
                all=not_mandatory_arguments, arguments=not_mandatory_arguments, deprecated=False, self=True,
                init='WindowID:(UInt32)windowID cmdID:(UInt32)cmdID position:(UInt16)position speed:(float)speed '
                     'offset:(UInt64)offset'),
            self.producer.constructor_named(
                all=not_mandatory_arguments + mandatory_arguments, arguments=mandatory_arguments,
                deprecated=False, self='WindowID:windowID cmdID:cmdID position:position speed:speed offset:offset',
                init='WindowID:(UInt32)windowID cmdID:(UInt32)cmdID position:(UInt16)position speed:(float)speed '
                     'offset:(UInt64)offset duplicateUpdatesFromWindowID:(nullable NSNumber<SDLInt> *)'
                     'duplicateUpdatesFromWindowID'))

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)

    def test_CreateInteractionChoiceSet(self):
        """
        generator/transformers/common_producer.py		67%
        generator/transformers/functions_producer.py	63%
        """
        params = OrderedDict()
        params['choiceSet'] = Param(name='choiceSet', param_type=Array(element_type=Struct(name='Choice')))
        item = Function(name='CreateInteractionChoiceSet', function_id=EnumElement(name='CreateInteractionChoiceSetID'),
                        message_type=EnumElement(name='request'), params=params)

        expected = OrderedDict()
        expected['origin'] = 'CreateInteractionChoiceSet'
        expected['name'] = 'SDLCreateInteractionChoiceSet'
        expected['extends_class'] = 'SDLRPCRequest'
        expected['imports'] = {'.m': {'SDLChoice'}, '.h': {'struct': {'SDLChoice'}, 'enum': {'SDLRPCRequest'}}}
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='choiceSet', constructor_argument_override=None,
                constructor_prefix='ChoiceSet', deprecated=False, description=[], for_name='objects', mandatory=True,
                method_suffix='ChoiceSet', modifier='strong', of_class='SDLChoice.class', origin='choiceSet',
                since=None, type_native='NSArray<SDLChoice *> *', type_sdl='NSArray<SDLChoice *> *'),)

        argument = [
            self.producer.argument_named(variable='choiceSet', deprecated=False, constructor_argument='choiceSet',
                                         origin='choiceSet')]

        expected['constructors'] = (self.producer.constructor_named(
            all=argument, arguments=argument, deprecated=False, self=True,
            init='ChoiceSet:(NSArray<SDLChoice *> *)choiceSet'),)

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)

    def test_SetDisplayLayout(self):
        """
        generator/transformers/common_producer.py		66%
        generator/transformers/functions_producer.py	63%
        """
        params = OrderedDict()
        params['displayLayout'] = Param(name='displayLayout', param_type=String(max_length=500, min_length=1))
        item = Function(name='SetDisplayLayout', function_id=EnumElement(name='SetDisplayLayoutID'),
                        message_type=EnumElement(name='request'), params=params, history=[
                Function(name='SetDisplayLayout', function_id=EnumElement(name='SetDisplayLayoutID'),
                         message_type=EnumElement(name='request'), params={}, history=None, since='3.0.0',
                         until='6.0.0')
            ], since='6.0.0', until=None, deprecated='true')

        expected = OrderedDict()
        expected['origin'] = 'SetDisplayLayout'
        expected['name'] = 'SDLSetDisplayLayout'
        expected['extends_class'] = 'SDLRPCRequest'
        expected['imports'] = {'.h': {'enum': {'SDLRPCRequest'}, 'struct': set()}, '.m': set()}
        expected['since'] = '6.0.0'
        expected['history'] = '3.0.0'
        expected['deprecated'] = True
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='displayLayout', constructor_argument_override=None,
                constructor_prefix='DisplayLayout', deprecated=False,
                description=['{"default_value": null, "max_length": 500, "min_length": 1}'], for_name='object',
                mandatory=True, method_suffix='DisplayLayout', modifier='strong', of_class='NSString.class',
                origin='displayLayout', since=None, type_native='NSString *', type_sdl='NSString *'),)

        argument = [
            self.producer.argument_named(variable='displayLayout', deprecated=False,
                                         constructor_argument='displayLayout', origin='displayLayout')]

        expected['constructors'] = (self.producer.constructor_named(
            all=argument, arguments=argument, deprecated=False, self=True,
            init='DisplayLayout:(NSString *)displayLayout'),)

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)
