"""
Common transformer
"""
import json
import logging
import re
import textwrap
from abc import ABC
from collections import OrderedDict, namedtuple
from pprint import pformat

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

    def __init__(self, container_name, mapping, names=()):
        self.logger = logging.getLogger(self.__class__.__name__)
        self.container_name = container_name
        self.mapping = mapping
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
        if item.deprecated and item.deprecated.lower() == 'true':
            render['deprecated'] = True

        render['params'] = OrderedDict()

        for param in getattr(item, self.container_name).values():
            render['params'][param.name] = self.extract_param(param)
            if isinstance(item, (Struct, Function)):
                self.extract_imports(param, render['imports'])

        self.custom_mapping(render)

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
        if mandatory or re.match(r'\w*Int\d*|BOOL|float|double', type_native):
            return ''
        return 'nullable '

    @staticmethod
    def wrap(item):
        """

        :param item:
        :return:
        """
        if getattr(item, 'constructor_argument_override', None) is not None:
            return item.constructor_argument_override
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
        # deprecated = any([m.deprecated for m in data if hasattr(m, 'deprecated')])

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
    def evaluate_type(instance) -> dict:
        """

        :param instance:
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
            data = self.evaluate_type(param.param_type.element_type)
            data['for_name'] = data['for_name'] + 's'
            data['type_sdl'] = data['type_native'] = 'NSArray<{}> *'.format(data['type_sdl'].strip())
            return data
        return self.evaluate_type(param.param_type)

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

    @staticmethod
    def minimize_last_id(name):
        """

        :param name:
        :return:
        """
        if name.upper().endswith('ID'):
            return name[:-1] + name[-1:].lower()
        return name

    @staticmethod
    def remove_asterisk(data: dict):
        """

        :param data:
        :return:
        """
        for key, value in data.copy().items():
            if key.startswith('type') and value.endswith('*'):
                if value.startswith('NSArray') and value.endswith('*> *'):
                    data[key] = value[:-5] + '> *'
                else:
                    data[key] = value[:-1]

    @staticmethod
    def add_asterisk(data: dict):
        """

        :param data:
        :return:
        """
        for key, value in data.copy().items():
            if key.startswith('type') and not value.endswith('*'):
                data[key] = value.strip() + ' *'

    def evaluate_param(self, data, name):
        """

        :param name:
        :param data:
        :return:
        """
        param_name = data['origin'] if 'origin' in data else ''
        redundant = list(set(data.keys()) - set(self.param_named._fields))
        if redundant:
            self.logger.error('%s/%s, redundant attributes (%s)', name, param_name, redundant)
            return False
        missed = list(set(self.param_named._fields) - set(data.keys()))
        if missed:
            self.logger.error('%s/%s, missed attributes (%s)', name, param_name, missed)
            return False
        return True

    def custom_mapping(self, render):
        """

        :param render:
        :return:
        """
        key = render['origin']
        if 'extends_class' in render:
            key += render['extends_class'].replace('SDLRPC', '')
        if key in self.mapping:
            custom = self.mapping[key].copy()
        elif render['origin'] in self.mapping:
            custom = self.mapping[render['origin']].copy()
        else:
            return
        self.logger.debug('%s fount in mapping', render['origin'])

        if 'params_title' in custom and custom['params_title'] is False:
            for name, custom_data in render['params'].items():
                if re.match(r'^[A-Z\d]+$', custom_data.origin):
                    render['params'][name] = render['params'][name]._replace(name=custom_data.origin)
            del custom['params_title']

        if 'remove_asterisk' in custom:
            for name, custom_data in render['params'].items():
                data = custom_data._asdict()
                self.remove_asterisk(data)
                render['params'][name] = custom_data._replace(**data)
            del custom['remove_asterisk']

        if 'description' in custom:
            render['description'] = self.extract_description(custom['description'])
            del custom['description']

        if '-params' in custom:
            for name in custom['-params']:
                if name in render['params']:
                    imp = render['params'][name].of_class.replace('.class', '')
                    if imp in render['imports']['.m']:
                        render['imports']['.m'].remove(imp)
                    for kind in ('struct', 'enum'):
                        if imp in render['imports']['.h'][kind]:
                            render['imports']['.h'][kind].remove(imp)
                    del render['params'][name]
            del custom['-params']

        if 'minimize_last_id' in custom:
            for name, custom_data in render['params'].items():
                if name.upper().endswith('ID'):
                    render['params'][name] = custom_data._replace(
                        constructor_argument=self.minimize_last_id(custom_data.constructor_argument),
                        constructor_prefix=self.minimize_last_id(custom_data.constructor_prefix),
                        method_suffix=self.minimize_last_id(custom_data.method_suffix))
            del custom['minimize_last_id']

        if 'sort_params' in custom:
            render['params'] = OrderedDict(sorted(render['params'].items()))
            del custom['sort_params']

        if 'template' in custom:
            if isinstance(custom['template'], bool) and custom['template']:
                render['template'] = render['name'][3:]
            else:
                render['template'] = custom['template']
            del custom['template']

        if 'maximize_method' in custom:
            if isinstance(custom['maximize_method'], str):
                for name, custom_data in render['params'].items():
                    tmp = re.findall(r'^([a-z]+)(\w*)$', self.minimize_first(custom_data.method_suffix)).pop()
                    render['params'][name] = custom_data._replace(method_suffix=tmp[0].upper() + tmp[1])
            elif isinstance(custom['maximize_method'], list):
                for name in custom['maximize_method']:
                    if name in render['params']:
                        custom_data = render['params'][name]
                        tmp = re.findall(r'^([a-z]+)(\w*)$', self.minimize_first(custom_data.method_suffix)).pop()
                        render['params'][name] = custom_data._replace(method_suffix=tmp[0].upper() + tmp[1])
            del custom['maximize_method']

        for key in ('modifier', 'mandatory'):
            if key in custom:
                for name, custom_data in render['params'].items():
                    render['params'][name] = custom_data._replace(**{key: custom[key]})
                del custom[key]

        for key in ('name', 'designated_initializer', 'deprecated', 'NS_ENUM', 'NS_SWIFT_NAME', 'add_typedef'):
            if key in custom and isinstance(custom[key], str):
                render[key] = custom[key]
                del custom[key]

        for name, custom_data in custom.copy().items():
            self.logger.info('applying manual mapping for %s/%s\t%s', render['name'], name, pformat(custom_data))
            if name in render['params']:
                if isinstance(custom_data, str):
                    render['params'][name] = render['params'][name]._replace(name=custom_data)
                elif isinstance(custom_data, dict):
                    data = self.custom_param_update(render['params'][name]._asdict(), custom_data, render['imports'])
                    if self.evaluate_param(data, render['origin']):
                        render['params'][name] = self.param_named(**data)
                del custom[name]
            elif name not in ['sort_constructor']:
                if 'description' in custom[name]:
                    custom[name]['description'] = self.extract_description(custom[name]['description'])
                custom[name]['origin'] = name
                for key, value in custom[name].copy().items():
                    if key.startswith('type') and not value.endswith('*'):
                        custom[name][key] = value.strip() + ' '
                if self.evaluate_param(custom[name], render['origin']):
                    render['params'][name] = self.param_named(**custom[name])
                    render['params'].move_to_end(name, last=False)
                else:
                    self.logger.warning('For %s provided undefined mapping for "%s": %s, which will be skipped',
                                        render['name'], name, pformat(custom_data))
                del custom[name]

        if 'sort_constructor' in custom:
            sorted_params = OrderedDict(sorted(render['params'].items()))
            render['constructors'] = self.extract_constructors(sorted_params)
            del custom['sort_constructor']

    @staticmethod
    def custom_param_update(data, custom_data, imports) -> dict:
        """

        :param data:
        :param custom_data:
        :param imports:
        :return:
        """
        if 'description' in custom_data:
            custom_data['description'] = InterfaceProducerCommon.extract_description(custom_data['description'])
        if 'minimize_last_id' in custom_data:
            data['constructor_argument'] = InterfaceProducerCommon.minimize_last_id(data['constructor_argument'])
            data['constructor_prefix'] = InterfaceProducerCommon.minimize_last_id(data['constructor_prefix'])
            data['method_suffix'] = InterfaceProducerCommon.minimize_last_id(data['method_suffix'])
        if 'maximize_method' in custom_data:
            tmp = re.findall(r'^([a-z]+)(\w*)$', InterfaceProducerCommon.minimize_first(data['method_suffix'])).pop()
            data['method_suffix'] = tmp[0].upper() + tmp[1]
        if 'origin' in custom_data:
            data.update(InterfaceProducerCommon.param_origin_change(custom_data['origin']))
        if 'type' in custom_data:
            new_type = re.sub(r'NSArray|[\s<>*]', '', custom_data['type'])
            data['type_native'] = data['type_sdl'] = re.sub(r'[\s*]', '', custom_data['type']) + ' *'
            data['method_suffix'] = new_type
            if data['of_class']:
                data['of_class'] = new_type + '.class'
            if new_type.lower() in map(str.lower, imports['.m']):
                imports['.m'] = set(i for i in imports['.m'] if i.lower() != new_type.lower())
                imports['.m'].add(new_type)
            for kind in ('enum', 'struct'):
                if new_type.lower() in map(str.lower, imports['.h'][kind]):
                    imports['.h'][kind] = set(i for i in imports['.h'][kind] if i.lower() != new_type.lower())
                    imports['.h'][kind].add(new_type)
        if 'remove_asterisk' in custom_data:
            InterfaceProducerCommon.remove_asterisk(data)
        if 'add_asterisk' in custom_data:
            InterfaceProducerCommon.add_asterisk(data)
        for key, value in custom_data.copy().items():
            if key.startswith('type') and not value.endswith('*'):
                custom_data[key] = value.strip() + ' '
        data.update(custom_data)
        return data
