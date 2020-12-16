"""
All Enums/Structs/Functions Producer are inherited from this class and using features of it
"""
import json
import logging
import re
import textwrap
from abc import ABC, abstractmethod
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
    All Enums/Structs/Functions Producer are inherited from this class and using features of it
    """

    def __init__(self, enum_names=(), struct_names=(), key_words=()):
        self.logger = logging.getLogger(self.__class__.__name__)
        self.struct_names = tuple(map(lambda e: self._replace_sync(e), struct_names))
        self.key_words = key_words
        self.param_named = namedtuple('param_named',
                                      'origin constructor_argument constructor_prefix deprecated mandatory since '
                                      'method_suffix of_class type_native type_sdl modifier for_name description history '
                                      'constructor_argument_override')
        self.constructor_named = namedtuple('constructor', 'init self arguments all')
        self.argument_named = namedtuple('argument', 'origin constructor_argument variable deprecated')
        self.names = self.struct_names + tuple(map(lambda e: self._replace_sync(e), enum_names))

    @property
    @abstractmethod
    def container_name(self):
        pass

    def transform(self, item: (Enum, Function, Struct), render: dict) -> dict:
        """
        Main entry point for transforming each Enum/Function/Struct into output dictionary,
        which going to be applied to Jinja2 template
        :param item: instance of Enum/Function/Struct
        :param render: dictionary with pre filled entries, which going to be filled/changed by reference
        :return: dictionary which going to be applied to Jinja2 template
        """

        importsKey = 'imports'
        enumKey = 'enum'
        structKey = 'struct'

        if item.description:
            render['description'] = self.extract_description(item.description)
        if item.since:
            render['since'] = item.since
        if item.history:
            render['history'] = item.history.pop().since
        if item.deprecated and str(item.deprecated).lower() == 'true':
            render['deprecated'] = True

        render['params'] = OrderedDict()

        for param in getattr(item, self.container_name).values():
            render['params'][param.name] = self.extract_param(param, item.name)
            if isinstance(item, (Struct, Function)):
                self.extract_imports(param, render['imports'])

        # Add additional known imports to the import list
        if isinstance(item, (Struct, Function)):
            name = 'SDL' + item.name
            render[importsKey]['.m'].add("NSMutableDictionary+Store")
            render[importsKey]['.m'].add(name)
            render[importsKey]['.h'][enumKey] = list(render[importsKey]['.h'][enumKey])
            (render[importsKey]['.h'][enumKey]).sort()
            render[importsKey]['.h'][structKey] = list(render[importsKey]['.h'][structKey])
            (render[importsKey]['.h'][structKey]).sort()

        if isinstance(item, Struct):
            name = 'SDL' + item.name
            render[importsKey]['.m'].add("SDLRPCParameterNames")

        if isinstance(item, Function):
            render[importsKey]['.m'].add("SDLRPCFunctionNames")
            render[importsKey]['.m'].add("SDLRPCParameterNames")

        # Sort the import list to ensure they appear in alphabetical order in the template
        render[importsKey]['.m'] = list(render[importsKey]['.m'])
        (render[importsKey]['.m']).sort()

        if 'constructors' not in render and isinstance(item, (Struct, Function)):
            render['constructors'] = self.extract_constructors(render['params'])

        render['params'] = tuple(render['params'].values())
        return render

    def _replace_keywords(self, name: str) -> str:
        origin = name
        if name.isupper():
            name += '_PARAM'
        else:
            name += 'Param'
        self.logger.debug('Replacing %s with %s', origin, name)
        return name

    def replace_keywords(self, name: str) -> str:
        """
        if :param name in self.key_words, :return: name += 'Param'
        :param name: string with item name
        """
        if name.casefold() in self.key_words:
            name = self._replace_keywords(name)
        return self._replace_sync(name)

    @staticmethod
    def _replace_sync(name):
        """
        :param name: string with item name
        :return: string with replaced 'sync' to 'Sdl'
        """
        if name:
            name = re.sub(r'^([sS])ync(.+)$', r'\1dl\2', name)
        return name

    def extract_imports(self, param: Param, imports: dict):
        """
        Extracting appropriate imports and updating in render['imports'] by reference
        :param param: instance of Param, which is sub element of Enum/Function/Struct
        :param imports: dictionary from render['imports']
        :return: dictionary with extracted imports
        """

        if isinstance(param.param_type, Array):
            type_origin, kind = self.evaluate_import(param.param_type.element_type)
        else:
            type_origin, kind = self.evaluate_import(param.param_type)

        if type_origin and any(map(lambda n: type_origin.lower() in n.lower(), self.names)):
            name = 'SDL' + type_origin
            imports['.h'][kind].add(name)
            imports['.m'].add(name)

        return imports

    def evaluate_import(self, element):
        """
        :param element: instance of param.param_type
        :return: tuple with element.name, type(element).__name__.lower()
        """
        if isinstance(element, (Struct, Enum)):
            return self._replace_sync(element.name), type(element).__name__.lower()
        return None, None

    @staticmethod
    def title(name: str = '') -> str:
        """
        Capitalizing only first character in string.
        :param name: string to be capitalized first character
        :return: initial parameter with capitalized first character
        """
        return name[:1].upper() + name[1:]

    @staticmethod
    def minimize_first(name: str = '') -> str:
        """
        Minimizing only first character in string.
        :param name: string to be minimized first character
        :return: initial parameter with minimized first character
        """
        return name[:1].lower() + name[1:]

    @staticmethod
    def extract_description(data, length: int = 2048) -> list:
        """
        Evaluate, align and delete @TODO
        :param data: list with description
        :param length: length of the string to be split
        :return: evaluated string
        """
        if not data:
            return []
        if isinstance(data, list):
            data = ' '.join(data)
        return textwrap.wrap(re.sub(r'(\s{2,}|\n)', ' ', data).strip(), length)

    @staticmethod
    def nullable(type_native: str, mandatory: bool) -> str:
        """
        Used for adding nullable modificator into initiator (constructor) parameter
        :param type_native: native type
        :param mandatory: is parameter mandatory
        :return: string with modificator
        """
        if mandatory or re.match(r'BOOL', type_native):
            return ''
        return 'nullable '

    def parentheses(self, item):
        """
        Used for wrapping appropriate initiator (constructor) parameter with '@({})'
        :param item: named tuple with initiator (constructor) parameter
        :return: wrapped parameter
        """
        if re.match(r'\w*Int\d+|BOOL|float|double', item.type_native) or \
                any(map(lambda n: item.type_native.lower() in n.lower(), self.struct_names)):
            return '@({})'.format(item.constructor_argument)
        return item.constructor_argument

    def extract_constructor(self, data: list, mandatory: bool) -> dict:
        """
        Preparing dictionary with initial initiator (constructor)
        :param data: list with prepared parameters
        :param mandatory: is parameter mandatory
        :return: dictionary with initial initiator (constructor)
        """
        data = list(data)

        first = data.pop(0)
        init = ['{}:({}{}){}'.format(self.title(first.constructor_prefix),
                                     self.nullable(first.type_native, mandatory),
                                     first.type_native.strip(), first.constructor_argument)]
        arguments = [self.argument_named(origin=first.origin, constructor_argument=self.parentheses(first),
                                         variable=first.constructor_argument, deprecated=first.deprecated)]
        for param in data:
            arguments.append(self.argument_named(origin=param.origin, constructor_argument=self.parentheses(param),
                                                 variable=param.constructor_argument, deprecated=param.deprecated))
            init.append('{}:({}{}){}'.format(self.minimize_first(param.constructor_prefix),
                                             self.nullable(param.type_native, mandatory),
                                             param.type_native.strip(), param.constructor_argument))
        _self = True if 'functions' in self.__class__.__name__.lower() and mandatory else ''
        return {'init': ' '.join(init), 'self': _self, 'arguments': arguments, 'all': arguments}

    def extract_constructors(self, data: dict) -> tuple:
        """
        Preparing tuple with all initiators (constructors)
        :param data: list with prepared parameters
        :return: tuple with all initiators (constructors)
        """
        mandatory = []
        not_mandatory = []
        for param in data.values():
            if param.deprecated:
                # Omit deprecated parameters from the constructors
                continue
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
                not_mandatory['self'] = re.sub(r'([\w\d]+:)\([\w\d\s<>*]*\)([\w\d]+\s*)', r'\1\2', mandatory['init'])
            result.append(self.constructor_named(**not_mandatory))

        if mandatory:
            result.insert(0, self.constructor_named(**mandatory))

        return tuple(result)

    def evaluate_type(self, instance) -> dict:
        """
        Extracting dictionary with evaluated output types
        :param instance: param_type of Param
        :return: dictionary with evaluated output types
        """
        if hasattr(instance, 'name'):
            instance.name = self.replace_keywords(instance.name)
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
        Preparing dictionary with output types information
        :param param: sub element of Enum/Function/Struct
        :return: dictionary with output types information
        """

        if isinstance(param.param_type, Array):
            data = self.evaluate_type(param.param_type.element_type)
            data['for_name'] = data['for_name'] + 's'
            data['type_sdl'] = data['type_native'] = 'NSArray<{}> *'.format(data['type_sdl'].strip())
        else:
            data = self.evaluate_type(param.param_type)

        if not param.is_mandatory and re.match(r'\w*Int\d*|BOOL|\w*float\d*', data['type_native']):
            data['type_native'] = data['type_sdl']

        return data

    @staticmethod
    def param_origin_change(name) -> dict:
        """
        Based on name preparing common part of output types information
        :param name: Param name
        :return: dictionary with part of output types information
        """
        return {'origin': name,
                'constructor_argument': name,
                'constructor_prefix': InterfaceProducerCommon.title(name),
                'method_suffix': InterfaceProducerCommon.title(name)}

    def extract_param(self, param: Param, item_name: str):
        """
        Preparing self.param_named with prepared params
        :param param: Param from initial Model
        :return: self.param_named with prepared params
        """
        param.name = self.replace_keywords(param.name)
        data = {'constructor_argument_override': None,
                'description': self.extract_description(param.description),
                'since': param.since,
                'mandatory': param.is_mandatory,
                'deprecated': json.loads(param.deprecated.lower()) if param.deprecated else False,
                'modifier': 'strong',
                'history': param.history}
        if isinstance(param.param_type, (Integer, Float, String, Array)):
            self.create_param_type_descriptor(param.param_type, parameterItems)

        if isinstance(param.param_type, (Boolean, Enum)):
            self.create_param_default_value_descriptor(param, parameterItems)

        if len(parameterItems) > 0:
            data['description'].append(json.dumps(parameterItems, sort_keys=False))

        data.update(self.extract_type(param))
        data.update(self.param_origin_change(param.name))
        return self.param_named(**data)

    def create_param_type_descriptor(self, param_type, parameterItems):
        """
        Gets all the descriptors for a parameter to be used in parameter's documentation (e.g. {"string_min_length": 1, string_max_length": 500}). The parameters should be returned in the same order they were added to the parameterItems dictionary
        :param param_type: param_type from the initial Model
        :param parameterItems: Ordered dictionary that stores each of the parameter's descriptors
        :return: All the descriptor params
        """
        # The key is a descriptor (i.e. max_value) and value is the associated value (i.e. 100). Some values will be dictionaries that have to be parsed to get additional descriptors (e.g. the value for an array of strings' data type will be sub-dictionary describing the min_length, max_length, and default value for the strings used in the array)
        for key, value in param_type.__dict__.items():
            # If a value contains a dictionary, recurse until all the descriptors have been found. Once a descriptor (i.e. `max_size`) has been found along with its associated value (i.e. 100), add the descriptor/value pair to the parameterItems dictionary
            if hasattr(value, '__dict__'):
                if isinstance(value, Enum) or isinstance(value, Struct):
                    # Skip adding documentation for the data type if it is a struct or enum. This is unnecessary as each enum or struct has its own documentation
                    continue
                else:
                    self.create_param_type_descriptor(value, parameterItems)
            else:
                if key == 'default_value' and value is None:
                    # Do not add the default_value key/value pair unless it has been explicitly set in the RPC Spec
                    continue
                else:
                    parameterDescriptor = self.update_param_descriptor(key)
                    parameterItems[parameterDescriptor] = value

        return parameterItems

    def create_param_default_value_descriptor(self, param, parameterItems):
        """
        Extracts the default value for a parameter to be used in parameter's documentation (HAX: The default_value for Ints and Floats is save to both the param and param_type but is only saved to the param_type for Enums and Bools for some reason)
        :param param: param from the initial Model
        :param parameterItems: Ordered dictionary that stores each of the parameter's descriptors
        :return: All the descriptor params
        """
        if param.default_value is None:
            return parameterItems

        if isinstance(param.param_type, Enum):
            parameterItems['default_value'] = param.default_value.name
        else:
            parameterItems['default_value'] = param.default_value

        return parameterItems

    def update_param_descriptor(self, parameterName):
        """
        Updates the parameter's descriptor name for clarity. This is helpful for array documentation as the descriptors can contain both the size of the array and the size of the array's data type
        :param parameterName: The name of the parameter
        :return: All the descriptor params from param_type concatenated into one string
        """
        if parameterName == 'min_size':
            return 'array_min_size'
        elif parameterName == 'max_size':
            return 'array_max_size'
        elif parameterName == 'min_length':
            return 'string_min_length'
        elif parameterName == 'max_length':
            return 'string_max_length'
        elif parameterName == 'max_value':
            return 'num_max_value'
        elif parameterName == 'min_value':
            return 'num_min_value'
        else:
            return parameterName
