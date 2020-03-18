"""
Enums transformer
"""
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

    def __init__(self, enum_class):
        super(EnumsProducer, self).__init__(
            container_name='elements')
        self.enum_class = enum_class
        self.logger = logging.getLogger(self.__class__.__name__)
        self.param_named = namedtuple('param_named', 'origin description name since value')

    def transform(self, item: Enum, render: dict = None) -> dict:
        """
        Main entry point for transforming each Enum into output dictionary,
        which going to be applied to Jinja2 template
        :param item: instance of Enum
        :param render: empty dictionary, present in parameter for code consistency
        :return: dictionary which going to be applied to Jinja2 template
        """
        item.name = self.replace_sync(item.name)
        name = 'SDL{}{}'.format(item.name[:1].upper(), item.name[1:])
        tmp = {self.enum_class}
        imports = {'.h': tmp, '.m': tmp}
        if not render:
            render = OrderedDict()
            render['origin'] = item.name
            render['name'] = name
            render['imports'] = imports
        super(EnumsProducer, self).transform(item, render)
        if any(map(lambda p: p.value, render['params'])):
            render['template'] = 'enums/template_numeric'
        return render

    def extract_param(self, param: EnumElement):
        """
        Preparing self.param_named with prepared params
        :param param: EnumElement from initial Model
        :return: self.param_named with prepared params
        """
        data = {'origin': param.name, 'description': self.extract_description(param.description, 113),
                'since': param.since}

        if re.match(r'^[A-Z]{1,2}\d|\d[A-Z]{1,2}$', param.name):
            data['name'] = param.name
        elif re.match(r'(^[a-z\d]+$|^[A-Z\d]+$)', param.name):
            data['name'] = param.name.title()
        elif re.match(r'^(?=\w*[a-z])(?=\w*[A-Z])\w+$', param.name):
            if param.name.endswith('ID'):
                data['name'] = param.name[:-2]
            else:
                data['name'] = param.name[:1].upper() + param.name[1:]
        elif re.match(r'^(?=\w*?[a-zA-Z])(?=\w*?[_-])(?=[0-9])?.*$', param.name):
            name = []
            for item in re.split('[_-]', param.name):
                if re.match(r'^[A-Z\d]+$', item):
                    name.append(item.title())
            data['name'] = ''.join(name)

        data['value'] = param.value

        return self.param_named(**data)
