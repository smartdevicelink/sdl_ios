"""
Functions transformer
"""

import logging
from collections import namedtuple, OrderedDict

from model.function import Function
from transformers.common_producer import InterfaceProducerCommon


class FunctionsProducer(InterfaceProducerCommon):
    """
    Functions transformer
    """

    def __init__(self, paths, names, key_words):
        super(FunctionsProducer, self).__init__(names=names, key_words=key_words)
        self._container_name = 'params'
        self.request_class = paths.request_class
        self.response_class = paths.response_class
        self.notification_class = paths.notification_class
        self.function_names = paths.function_names
        self.parameter_names = paths.parameter_names
        self.logger = logging.getLogger(self.__class__.__name__)
        self.common_names = namedtuple('common_names', 'name origin description since')

    @property
    def container_name(self):
        return self._container_name

    def transform(self, item: Function, render: dict = None) -> dict:
        """
        Main entry point for transforming each Enum/Function/Struct into output dictionary,
        which going to be applied to Jinja2 template
        :param item: instance of Enum/Function/Struct
        :param render: dictionary with pre filled entries, which going to be filled/changed by reference
        :return: dictionary which going to be applied to Jinja2 template
        """
        list(map(item.params.__delitem__, filter(item.params.__contains__, ['success', 'resultCode', 'info'])))
        item.name = self.replace_sync(item.name)
        name = 'SDL' + item.name
        imports = {'.h': {'enum': set(), 'struct': set()}, '.m': set()}
        extends_class = None
        if item.message_type.name == 'response':
            extends_class = self.response_class
            name = name + item.message_type.name.capitalize()
        elif item.message_type.name == 'request':
            extends_class = self.request_class
        elif item.message_type.name == 'notification':
            extends_class = self.notification_class
        if extends_class:
            imports['.h']['enum'].add(extends_class)

        if not render:
            render = OrderedDict()
            render['origin'] = item.name
            render['name'] = name
            render['extends_class'] = extends_class
            render['imports'] = imports

        super(FunctionsProducer, self).transform(item, render)

        return render

    def get_function_names(self, items: dict) -> dict:
        """
        Standalone method used for preparing SDLRPCFunctionNames collection ready to be applied to Jinja2 template
        :param items: collection with all functions from initial Model
        :return: collection with transformed element ready to be applied to Jinja2 template
        """
        render = OrderedDict()
        for item in items.values():
            tmp = {'name': self.title(self.replace_keywords(item.name)),
                   'origin': item.name,
                   'description': self.extract_description(item.description),
                   'since': item.since}
            render[item.name] = self.common_names(**tmp)

        return {'params': sorted(render.values(), key=lambda a: a.name)}

    def evaluate(self, element) -> dict:
        """
        Internal evaluator used for preparing SDLRPCParameterNames collection
        :param element: Param from initial Model
        :return: dictionary with evaluated part of output collection
        """
        origin = element.name
        name = self.replace_sync(element.name)
        # if isinstance(element.param_type, (Integer, Float, Boolean, String)):
        return {name: self.common_names(**{
            'name': self.title(name),
            'origin': origin,
            'description': self.extract_description(element.description),
            'since': element.since})}
        # return OrderedDict()

    def get_simple_params(self, functions: dict, structs: dict) -> dict:
        """
        Standalone method used for preparing SDLRPCParameterNames collection ready to be applied to Jinja2 template
        :param functions: collection with all functions from initial Model
        :param structs: collection with all structs from initial Model
        :return: collection with transformed element ready to be applied to Jinja2 template
        """
        render = OrderedDict()

        for func in functions.values():
            for param in func.params.values():
                render.update(self.evaluate(param))

        for struct in structs.values():
            render.update(self.evaluate(struct))
            for param in struct.members.values():
                render.update(self.evaluate(param))
        unique = dict(zip(list(map(lambda l: l.name, render.values())), render.values()))
        return {'params': sorted(unique.values(), key=lambda a: a.name)}
