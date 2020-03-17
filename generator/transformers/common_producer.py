"""
Common transformer
"""
import json
import logging
import re
import textwrap
from abc import ABC
from collections import OrderedDict, namedtuple

from model.array import Array
from model.boolean import Boolean
from model.enum import Enum
from model.float import Float
from model.function import Function
from model.integer import Integer
from model.param import Param
from model.string import String
from model.struct import Struct


class InterfaceProducerCommon(ABC):
    """
    Common transformer
    """

    version = '1.0.0'

    def __init__(self, container_name, names=()):
        self.logger = logging.getLogger(self.__class__.__name__)
        self.container_name = container_name
        self.names = names
        self.param_named = namedtuple('param_named',
                                      'origin constructor_argument constructor_prefix deprecated mandatory since '
                                      'method_suffix of_class type_native type_sdl modifier for_name description '
                                      'constructor_argument_override')
        self.constructor_named = namedtuple('constructor', 'init self arguments all deprecated')
        self.argument_named = namedtuple('argument', 'origin constructor_argument variable deprecated')

    @property
    def get_version(self):
        """

        :return:
        """
        return self.version

    def transform(self, item: (Enum, Function, Struct), render: dict) -> dict:
        """

        :param item:
        :param render:
        :return:
        """
        if item.description:
            render['description'] = self.extract_description(item.description)
        if item.since:
            render['since'] = item.since
        if item.history:
            render['history'] = item.history.pop().since
        if item.deprecated and item.deprecated.lower() == 'true':
            render['deprecated'] = True

        render['params'] = OrderedDict()

        for param in getattr(item, self.container_name).values():
            if param.name.lower() in ['id']:
                param.name = self.minimize_first(item.name) + self.title(param.name)
            render['params'][param.name] = self.extract_param(param)
            if isinstance(item, (Struct, Function)):
                self.extract_imports(param, render['imports'])

        if 'constructors' not in render and isinstance(item, (Struct, Function)):
            designated_initializer = render['designated_initializer'] if 'designated_initializer' in render else False
            render['constructors'] = self.extract_constructors(render['params'], designated_initializer)

        render['params'] = tuple(render['params'].values())
        return render

    def extract_imports(self, param: Param, imports):
        """

        :param param:
        :param imports:
        :return:
        """

        def evaluate(element):
            if isinstance(element, (Struct, Enum)):
                return element.name, type(element).__name__.lower()
            return None, None

        if isinstance(param.param_type, Array):
            type_origin, kind = evaluate(param.param_type.element_type)
        else:
            type_origin, kind = evaluate(param.param_type)

        if type_origin in self.names:
            name = 'SDL' + type_origin
            imports['.h'][kind].add(name)
            imports['.m'].add(name)

        return imports

    @staticmethod
    def title(name):
        """

        :param name:
        :return:
        """
        return name[:1].upper() + name[1:]

    @staticmethod
    def minimize_first(name):
        """

        :param name:
        :return:
        """
        return name[:1].lower() + name[1:]

    @staticmethod
    def extract_description(data, length: int = 113) -> list:
        """
        Evaluate, align and delete @TODO
        :param data: list with description
        :param length:
        :return: evaluated string
        """
        if not data:
            return []
        if isinstance(data, list):
            data = ' '.join(data)
        return textwrap.wrap(re.sub(r'(\s{2,}|\n|\[@TODO.+)', ' ', data).strip(), length)

    @staticmethod
    def nullable(type_native, mandatory):
        """

        :param type_native:
        :param mandatory:
        :return:
        """
        if mandatory or re.match(r'BOOL|float|double', type_native):
            return ''
        return 'nullable '

    @staticmethod
    def wrap(item):
        """

        :param item:
        :return:
        """
        if re.match(r'\w*Int\d*|BOOL|float|double', item.type_native):
            return '@({})'.format(item.constructor_argument)
        return item.constructor_argument

    def extract_constructor(self, data: list, mandatory: bool) -> dict:
        """

        :param data:
        :param mandatory:
        :return:
        """
        data = list(data)

        first = data.pop(0)
        init = ['{}:({}{}){}'.format(self.title(first.constructor_prefix),
                                     self.nullable(first.type_native, mandatory),
                                     first.type_native.strip(), first.constructor_argument)]
        arguments = [self.argument_named(origin=first.origin, constructor_argument=self.wrap(first),
                                         variable=first.constructor_argument, deprecated=first.deprecated)]
        for param in data:
            arguments.append(self.argument_named(origin=param.origin, constructor_argument=self.wrap(param),
                                                 variable=param.constructor_argument, deprecated=param.deprecated))
            init_str = '{}:({}{}){}'.format(self.minimize_first(param.constructor_prefix),
                                            self.nullable(param.type_native, mandatory),
                                            param.type_native.strip(), param.constructor_argument)
            init.append(init_str)

        return {'init': ' '.join(init), 'self': '', 'arguments': arguments, 'all': arguments, 'deprecated': False}

    def extract_constructors(self, data: dict, designated_initializer: bool = None) -> tuple:
        """

        :param data:
        :param designated_initializer:
        :return:
        """
        mandatory = []
        not_mandatory = []
        for param in data.values():
            if param.mandatory:
                mandatory.append(param)
            else:
                not_mandatory.append(param)

        result = []
        if mandatory:
            mandatory = self.extract_constructor(mandatory, True)
        else:
            mandatory = OrderedDict()

        if not_mandatory:
            not_mandatory = self.extract_constructor(not_mandatory, False)
            if mandatory:
                not_mandatory['init'] = '{} {}'.format(mandatory['init'], self.minimize_first(not_mandatory['init']))
                not_mandatory['all'] = mandatory['arguments'] + not_mandatory['arguments']
                not_mandatory['deprecated'] = any([m.deprecated for m in mandatory if hasattr(m, 'deprecated')])
                not_mandatory['self'] = re.sub(r'([\w\d]+:)\([\w\d\s<>*]*\)([\w\d]+\s*)', r'\1\2', mandatory['init'])
            if not mandatory and designated_initializer:
                not_mandatory['init'] = not_mandatory['init'] + ' NS_DESIGNATED_INITIALIZER'
            result.append(self.constructor_named(**not_mandatory))

        if mandatory:
            if designated_initializer:
                mandatory['init'] = mandatory['init'] + ' NS_DESIGNATED_INITIALIZER'
            result.insert(0, self.constructor_named(**mandatory))

        return tuple(result)

    @staticmethod
    def evaluate_type(instance, mandatory) -> dict:
        """

        :param instance:
        :param mandatory:
        :return:
        """
        data = OrderedDict()
        if isinstance(instance, Enum):
            data['for_name'] = 'enum'
            data['of_class'] = ''
        else:
            data['for_name'] = 'object'
        if isinstance(instance, (Struct, Enum)):
            data['type_sdl'] = 'SDL' + instance.name
            data['type_native'] = data['type_sdl'] = 'SDL{} '.format(instance.name)
        if isinstance(instance, Struct):
            data['of_class'] = 'SDL{}.class'.format(instance.name)
            data['type_native'] = data['type_sdl'] = 'SDL{} *'.format(instance.name)
        elif isinstance(instance, (Integer, Float)):
            if isinstance(instance, Float):
                data['type_sdl'] = 'SDLFloat'
                data['type_native'] = 'float'
            if isinstance(instance, Integer):
                if not instance.max_value:
                    data['type_native'] = 'UInt32'
                elif instance.max_value <= 255:
                    data['type_native'] = 'UInt8'
                elif instance.max_value <= 65535:
                    data['type_native'] = 'UInt16'
                elif instance.max_value <= 4294967295:
                    data['type_native'] = 'UInt32'
                elif instance.max_value > 4294967295:
                    data['type_native'] = 'UInt64'
                if instance.min_value is None or instance.min_value < 0:
                    data['type_sdl'] = 'SDLInt'
                elif instance.min_value >= 0:
                    data['type_sdl'] = 'SDLUInt'
            data['of_class'] = 'NSNumber.class'
            data['type_sdl'] = 'NSNumber<{}> *'.format(data['type_sdl'])
            if not mandatory:
                data['type_native'] = data['type_sdl']
        elif isinstance(instance, String):
            data['of_class'] = 'NSString.class'
            data['type_sdl'] = data['type_native'] = 'NSString *'
        elif isinstance(instance, Boolean):
            data['of_class'] = 'NSNumber.class'
            data['type_native'] = 'BOOL'
            data['type_sdl'] = 'NSNumber<SDLBool> *'
        return data

    def extract_type(self, param: Param) -> dict:
        """

        :param param:
        :return:
        """

        if isinstance(param.param_type, Array):
            data = self.evaluate_type(param.param_type.element_type, param.is_mandatory)
            data['for_name'] = data['for_name'] + 's'
            data['type_sdl'] = data['type_native'] = 'NSArray<{}> *'.format(data['type_sdl'].strip())
            return data
        return self.evaluate_type(param.param_type, param.is_mandatory)

    @staticmethod
    def param_origin_change(name):
        """

        :param name:
        :return:
        """
        return {'origin': name,
                'constructor_argument': name,
                'constructor_prefix': InterfaceProducerCommon.title(name),
                'method_suffix': InterfaceProducerCommon.title(name)}

    def extract_param(self, param: Param):
        """

        :param param:
        :return:
        """
        data = {'constructor_argument_override': None,
                'description': self.extract_description(param.description),
                'since': param.since,
                'mandatory': param.is_mandatory,
                'deprecated': json.loads(param.deprecated.lower()) if param.deprecated else False,
                'modifier': 'strong'}
        if isinstance(param.param_type, (Integer, Float, String)):
            data['description'].append(json.dumps(vars(param.param_type), sort_keys=True))

        data.update(self.extract_type(param))
        data.update(self.param_origin_change(param.name))
        return self.param_named(**data)
