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

    def __init__(self, struct_class, enum_names):
        super(StructsProducer, self).__init__(
            container_name='members',
            names=enum_names)
        self.struct_class = struct_class
        self.logger = logging.getLogger(self.__class__.__name__)

    def transform(self, item: Struct, render=None) -> dict:
        """

        :param item:
        :param render:
        :return:
        """
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
