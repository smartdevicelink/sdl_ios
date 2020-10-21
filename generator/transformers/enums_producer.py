"""
Enums transformer
"""
import json
import logging
import re
from collections import namedtuple, OrderedDict

from model.enum import Enum
from model.enum_element import EnumElement
from transformers.common_producer import InterfaceProducerCommon


class EnumsProducer(InterfaceProducerCommon):
    """
    Enums transformer
    """

    def __init__(self, enum_class, key_words):
        super(EnumsProducer, self).__init__(key_words=key_words)
        self._container_name = 'elements'
        self.enum_class = enum_class
        self.logger = logging.getLogger(self.__class__.__name__)
        self.param_named = namedtuple('param_named', 'origin description name since deprecated history')
        self._item_name = None

    @property
    def container_name(self):
        return self._container_name

    def transform(self, item: Enum, render: dict = None) -> dict:
        """
        Main entry point for transforming each Enum into output dictionary,
        which going to be applied to Jinja2 template
        :param item: instance of Enum
        :param render: empty dictionary, present in parameter for code consistency
        :return: dictionary which going to be applied to Jinja2 template
        """
        item.name = self._replace_sync(item.name)
        name = 'SDL{}{}'.format(item.name[:1].upper(), item.name[1:])
        tmp = {self.enum_class}
        imports = {'.h': tmp, '.m': tmp}
        if not render:
            render = OrderedDict()
            render['origin'] = item.name
            render['name'] = name
            render['imports'] = imports
            render['history'] = item.history
        super(EnumsProducer, self).transform(item, render)
        return render

    def extract_param(self, param: EnumElement, item_name: str):
        """
        Preparing self.param_named with prepared params
        :param param: EnumElement from initial Model
        :param item_name:
        :return: self.param_named with prepared params
        """
        data = {'origin': param.name,
                'description': self.extract_description(param.description),
                'since': param.since,
                'history': param.history,
                # 'default_value': param.default_value,
                'deprecated': json.loads(param.deprecated.lower()) if param.deprecated else False}
        name = None
        if re.match(r'^[A-Z]{1,2}\d|\d[A-Z]{1,2}$', param.name):
            name = param.name
        elif re.match(r'(^[a-z\d]+$|^[A-Z\d]+$)', param.name):
            name = param.name.title()
        elif re.match(r'^(?=\w*[a-z])(?=\w*[A-Z])\w+$', param.name):
            if param.name.endswith('ID'):
                name = param.name[:-2]
            else:
                name = param.name[:1].upper() + param.name[1:]
        elif re.match(r'^(?=\w*?[a-zA-Z])(?=\w*?[_-])(?=[0-9])?.*$', param.name):
            name = []
            for item in re.split('[_-]', param.name):
                if re.match(r'^[A-Z\d]+$', item):
                    name.append(item.title())
            name = ''.join(name)
        if any(re.search(r'^(sdl)?({}){}$'.format(item_name.casefold(), name.casefold()), k) for k in self.key_words):
            name = self._replace_keywords(name)
        data['name'] = name
        # try:
        #     param.default_value
        # except NameError:
        #     data['default_value'] = None
        # else:
        #     data['default_value'] = param.default_value

        return self.param_named(**data)
