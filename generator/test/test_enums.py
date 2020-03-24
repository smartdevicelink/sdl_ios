from collections import OrderedDict
from unittest import TestCase

from model.enum import Enum
from model.enum_element import EnumElement
from transformers.enums_producer import EnumsProducer


class TestEnumsProducer(TestCase):
    """
    The structures of tests in this class was prepared to cover all possible combinations of code branching in tested
    class EnumsProducer.
    All names of Enums and nested elements doesn't reflating with real Enums
    and could be replaces with some meaningless names.

    After performing Tests there are following initial test code coverage:
    generator/transformers/common_producer.py	34%
    generator/transformers/enums_producer.py	100%
    """

    def setUp(self):
        self.maxDiff = None

        self.producer = EnumsProducer('SDLEnum')

    def test_FunctionID(self):
        """
        generator/transformers/common_producer.py	34%
        generator/transformers/enums_producer.py	80%
        """
        elements = OrderedDict()
        elements['RESERVED'] = EnumElement(name='RESERVED', value=0)
        elements['RegisterAppInterfaceID'] = EnumElement(name='RegisterAppInterfaceID', hex_value=1)
        elements['PerformAudioPassThruID'] = EnumElement(name='PerformAudioPassThruID', hex_value=10)

        item = Enum(name='FunctionID', elements=elements)
        expected = OrderedDict()
        expected['origin'] = 'FunctionID'
        expected['name'] = 'SDLFunctionID'
        expected['imports'] = {'.h': {'SDLEnum'}, '.m': {'SDLEnum'}}
        expected['params'] = (
            self.producer.param_named(description=[], name='Reserved', origin='RESERVED', since=None),
            self.producer.param_named(description=[], name='RegisterAppInterface', origin='RegisterAppInterfaceID',
                                      since=None),
            self.producer.param_named(description=[], name='PerformAudioPassThru', origin='PerformAudioPassThruID',
                                      since=None),)

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)

    def test_TextFieldName(self):
        """
        generator/transformers/common_producer.py	34%
        generator/transformers/enums_producer.py	98%
        """
        elements = OrderedDict()
        elements['SUCCESS'] = EnumElement(name='SUCCESS')
        elements['mainField1'] = EnumElement(name='mainField1')
        elements['H264'] = EnumElement(name='H264')
        elements['UNSUPPORTED_REQUEST'] = EnumElement(name='UNSUPPORTED_REQUEST')
        item = Enum(name='TextFieldName', elements=elements)

        expected = OrderedDict()
        expected['origin'] = 'TextFieldName'
        expected['name'] = 'SDLTextFieldName'
        expected['imports'] = {'.h': {'SDLEnum'}, '.m': {'SDLEnum'}}
        expected['params'] = (
            self.producer.param_named(description=[], name='Success', origin='SUCCESS', since=None),
            self.producer.param_named(description=[], name='MainField1', origin='mainField1', since=None),
            self.producer.param_named(description=[], name='H264', origin='H264', since=None),
            self.producer.param_named(description=[], name='UnsupportedRequest', origin='UNSUPPORTED_REQUEST',
                                      since=None))

        actual = self.producer.transform(item)
        self.assertDictEqual(expected, actual)
