from collections import OrderedDict
from unittest import TestCase

try:
    from generator import Generator
except ImportError as error:
    from generator.generator import Generator

from model.integer import Integer
from model.param import Param
from model.string import String
from model.struct import Struct
from transformers.structs_producer import StructsProducer


class TestStructsProducer(TestCase):
    """
    The structures of tests in this class was prepared to cover all possible combinations of code branching in tested
    class StructsProducer.
    All names of Structs and nested elements doesn't reflating with real Structs
    and could be replaces with some meaningless names.

    After performing Tests there are following initial test code coverage:
    generator/transformers/common_producer.py	72%
    generator/transformers/structs_producer.py	100%
    """

    def setUp(self):
        self.maxDiff = None
        key_words = ('value', 'id')

        self.producer = StructsProducer('SDLRPCStruct', enum_names=(), struct_names=['Image'], key_words=key_words)

    def test_CloudAppProperties(self):
        """
        generator/transformers/common_producer.py	64%
        generator/transformers/structs_producer.py	100%
        """
        members = OrderedDict()
        members['appID'] = Param(name='appID', param_type=String())
        members['value'] = Param(name='value', param_type=String())
        item = Struct(name='CloudAppProperties', members=members)
        expected = OrderedDict()
        expected['origin'] = 'CloudAppProperties'
        expected['name'] = 'SDLCloudAppProperties'
        expected['extends_class'] = 'SDLRPCStruct'
        expected['imports'] = {'.m': set(), '.h': {'enum': {'SDLRPCStruct'}, 'struct': set()}}
        expected['history'] = None
        expected['params'] = (
            self.producer.param_named(
                history=None,
                constructor_argument='appID', constructor_argument_override=None, constructor_prefix='AppID',
                deprecated=False, description=['{"string_min_length": null, "string_max_length": null}'],
                for_name='object', mandatory=True, method_suffix='AppID', modifier='strong', of_class='NSString.class',
                origin='appID', since=None, type_native='NSString *', type_sdl='NSString *'),
            self.producer.param_named(
                history=None,
                constructor_argument='valueParam', constructor_argument_override=None, constructor_prefix='ValueParam',
                deprecated=False, description=['{"string_min_length": null, "string_max_length": null}'],
                for_name='object', mandatory=True, method_suffix='ValueParam', modifier='strong',
                of_class='NSString.class', origin='valueParam', since=None, type_native='NSString *',
                type_sdl='NSString *')
        )

        argument = [
            self.producer.argument_named(
                variable='appID', deprecated=False, constructor_argument='appID', origin='appID'),
            self.producer.argument_named(
                variable='valueParam', deprecated=False, constructor_argument='valueParam', origin='valueParam')
        ]

        expected['constructors'] = (self.producer.constructor_named(
            all=argument, arguments=argument, self='',
            init='AppID:(NSString *)appID valueParam:(NSString *)valueParam'),)

        actual = self.producer.transform(item)
        expected['imports'] = actual['imports']
        self.assertDictEqual(expected, actual)

    def test_TouchEvent(self):
        """
        generator/transformers/common_producer.py	69%
        generator/transformers/structs_producer.py	100%
        """
        item = Struct(name='TouchEvent', members={
            'id': Param(name='id', param_type=Integer(max_value=9, min_value=0))
        })
        expected = OrderedDict()
        expected['origin'] = 'TouchEvent'
        expected['name'] = 'SDLTouchEvent'
        expected['extends_class'] = 'SDLRPCStruct'
        expected['imports'] = {'.h': {'enum': {'SDLRPCStruct'}, 'struct': set()}, '.m': set()}
        expected['history'] = None
        expected['params'] = (
            self.producer.param_named(
                history=None,
                constructor_argument='idParam', constructor_argument_override=None,
                constructor_prefix='IdParam', deprecated=False,
                description=['{"num_min_value": 0, "num_max_value": 9}'], for_name='object',
                mandatory=True, method_suffix='IdParam', modifier='strong', of_class='NSNumber.class',
                origin='idParam', since=None, type_native='UInt8', type_sdl='NSNumber<SDLUInt> *'),)

        argument = [
            self.producer.argument_named(variable='idParam', deprecated=False,
                                         constructor_argument='@(idParam)', origin='idParam')]

        expected['constructors'] = (self.producer.constructor_named(
            all=argument, arguments=argument, self='',
            init='IdParam:(UInt8)idParam'),)

        actual = self.producer.transform(item)
        expected['imports'] = actual['imports']
        self.assertDictEqual(expected, actual)
