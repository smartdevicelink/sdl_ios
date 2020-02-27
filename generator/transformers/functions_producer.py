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

    def __init__(self, paths, names):
        super(FunctionsProducer, self).__init__(
            container_name='params',
            names=names)
        self.request_class = paths.request_class
        self.response_class = paths.response_class
        self.notification_class = paths.notification_class
        self.function_names = paths.function_names
        self.parameter_names = paths.parameter_names
        self.logger = logging.getLogger(self.__class__.__name__)
        self.common_names = namedtuple('common_names', 'name origin description since')

    def transform(self, item: Function, render=None) -> dict:
        """

        :param item:
        :param render:
        :return:
        """
        list(map(item.params.__delitem__, filter(item.params.__contains__, ['success', 'resultCode', 'info'])))

        name = 'SDL' + item.name
        imports = {'.h': {'enum': set(), 'struct': set()},
                   '.m': set()}
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

        :param items:
        :return: dict
        """
        render = OrderedDict()
        for item in items.values():
            tmp = {'name': self.title(item.name),
                   'origin': item.name,
                   'description': self.extract_description(item.description),
                   'since': item.since}
            render[item.name] = self.common_names(**tmp)

        return {'params': sorted(render.values(), key=lambda a: a.name)}

    def get_simple_params(self, functions: dict, structs: dict) -> dict:
        """
        :param functions:
        :param structs:
        :return:
        """

        def evaluate(element):
            # if isinstance(element.param_type, (Integer, Float, Boolean, String)):
            return {element.name: self.common_names(**{
                'name': self.title(element.name),
                'origin': element.name,
                'description': self.extract_description(element.description),
                'since': element.since})}
            # return OrderedDict()

        render = OrderedDict()

        for func in functions.values():
            for param in func.params.values():
                render.update(evaluate(param))

        for struct in structs.values():
            render.update(evaluate(struct))
            for param in struct.members.values():
                render.update(evaluate(param))

        return {'params': sorted(render.values(), key=lambda a: a.name)}
