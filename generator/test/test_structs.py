import re
from collections import OrderedDict, defaultdict
from unittest import TestCase

from model.param import Param
from model.string import String
from model.struct import Struct
from transformers.structs_producer import StructsProducer


class TestStructsProducer(TestCase):
    def setUp(self):
        self.maxDiff = None

        self.producer = StructsProducer('SDLRPCStruct', ['Image'])

    def test_Version(self):
        version = self.producer.get_version
        self.assertIsNotNone(version)
        self.assertTrue(re.match(r'^\d*\.\d*\.\d*$', version))

    def test_CloudAppProperties(self):
        item = Struct(name='CloudAppProperties', members={
            'appID': Param(name='appID', param_type=String())
        })
        expected = OrderedDict()
        expected['origin'] = 'CloudAppProperties'
        expected['name'] = 'SDLCloudAppProperties'
        expected['extends_class'] = 'SDLRPCStruct'
        expected['imports'] = {'.m': set(), '.h': {'enum': {'SDLRPCStruct'}, 'struct': set()}}
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='appID', constructor_argument_override=None, constructor_prefix='AppID',
                deprecated=False, description=['{"default_value": null, "max_length": null, "min_length": null}'],
                for_name='object', mandatory=True, method_suffix='AppID', modifier='strong', of_class='NSString.class',
                origin='appID', since=None, type_native='NSString *', type_sdl='NSString *', ),)

        argument = [
            self.producer.argument_named(variable='appID', deprecated=False, constructor_argument='appID', origin='appID')]

        expected['constructors'] = (self.producer.constructor_named(
            all=argument, arguments=argument, deprecated=False, self='',
            init='AppID:(NSString *)appID'),)

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)

    def test_not_mandatory_NS_DESIGNATED_INITIALIZER(self):
        item = Struct(name='CloudAppProperties', members={
            'appID': Param(name='appID', param_type=String(), is_mandatory=False)
        })
        expected = OrderedDict()
        expected['origin'] = 'CloudAppProperties'
        expected['name'] = 'SDLCloudAppProperties'
        expected['extends_class'] = 'SDLRPCStruct'
        expected['imports'] = {'.m': set(), '.h': {'enum': {'SDLRPCStruct'}, 'struct': set()}}
        expected['params'] = (
            self.producer.param_named(
                constructor_argument='appID', constructor_argument_override=None, constructor_prefix='AppID',
                deprecated=False, description=['{"default_value": null, "max_length": null, "min_length": null}'],
                for_name='object', mandatory=False, method_suffix='AppID', modifier='strong', of_class='NSString.class',
                origin='appID', since=None, type_native='NSString *', type_sdl='NSString *', ),)

        argument = [
            self.producer.argument_named(variable='appID', deprecated=False, constructor_argument='appID', origin='appID')]

        expected['constructors'] = (self.producer.constructor_named(
            all=argument, arguments=argument, deprecated=False, self='',
            init='AppID:(nullable NSString *)appID'),)

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)
