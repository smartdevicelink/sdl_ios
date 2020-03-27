"""
Structs transformer
"""

import logging
from collections import OrderedDict

from model.struct import Struct
from transformers.common_producer import InterfaceProducerCommon


class StructsProducer(InterfaceProducerCommon):
    """
    Structs transformer
    """

    def __init__(self, struct_class, enum_names, key_words):
        super(StructsProducer, self).__init__(names=enum_names, key_words=key_words)
        self._container_name = 'members'
        self.struct_class = struct_class
        self.logger = logging.getLogger(self.__class__.__name__)

    @property
    def container_name(self):
        return self._container_name

    def transform(self, item: Struct, render: dict = None) -> dict:
        """
        Main entry point for transforming each Enum/Function/Struct into output dictionary,
        which going to be applied to Jinja2 template
        :param item: instance of Enum/Function/Struct
        :param render: dictionary with pre filled entries, which going to be filled/changed by reference
        :return: dictionary which going to be applied to Jinja2 template
        """
        item.name = self.replace_sync(item.name)
        name = 'SDL' + item.name
        imports = {'.h': {'enum': set(), 'struct': set()}, '.m': set()}
        imports['.h']['enum'].add(self.struct_class)
        if not render:
            render = OrderedDict()
            render['origin'] = item.name
            render['name'] = name
            render['extends_class'] = self.struct_class
            render['imports'] = imports

        super(StructsProducer, self).transform(item, render)

        return render
