"""
Generator
"""
import asyncio
import logging
import re
import sys
from argparse import ArgumentParser
from collections import namedtuple, OrderedDict
from datetime import datetime, date
from inspect import getfile
from os.path import basename, join
from pathlib import Path
from re import findall

from jinja2 import UndefinedError, TemplateNotFound, FileSystemLoader, Environment, ChoiceLoader, \
    TemplateAssertionError, TemplateSyntaxError, TemplateRuntimeError

ROOT = Path(__file__).absolute().parents[0]

sys.path.append(ROOT.joinpath('rpc_spec/InterfaceParser').as_posix())

try:
    from parsers.rpc_base import ParseError
    from parsers.sdl_rpc_v2 import Parser
    from model.interface import Interface
    from transformers.common_producer import InterfaceProducerCommon as Common
    from transformers.enums_producer import EnumsProducer
    from transformers.functions_producer import FunctionsProducer
    from transformers.structs_producer import StructsProducer
except ImportError as error:
    print('%s.\nprobably you did not initialize submodule', error)
    sys.exit(1)


class Generator:
    """
    This class contains only technical features, as follow:
    - parsing command-line arguments, or evaluating required container interactively;
    - calling parsers to get Model from xml;
    - calling producers to transform initial Model to dict used in Jinja2 templates
    Not required to be covered by unit tests cause contains only technical features.
    """

    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)
        self._env = None
        self._output_directory = None
        self.loop = asyncio.get_event_loop()
        self.paths_named = namedtuple('paths_named', 'enum_class struct_class request_class response_class '
                                                     'notification_class function_names parameter_names')

    _version = '1.0.0'

    @property
    def get_version(self) -> str:
        """
        version of the entire generator
        :return: current entire generator version
        """
        return self._version

    @property
    def output_directory(self) -> Path:
        """
        Getter for output directory
        :return: output directory Path
        """
        return self._output_directory

    @output_directory.setter
    def output_directory(self, output_directory: str):
        """
        Setting and validating output directory
        :param output_directory: path to output directory
        :return: None
        """
        if output_directory.startswith('/'):
            path = Path(output_directory).absolute().resolve()
        else:
            path = Path('.').absolute().joinpath(output_directory).resolve()
        if not path.exists():
            self.logger.warning('Directory not found: %s, trying to create it', path)
            try:
                path.mkdir(parents=True, exist_ok=True)
            except OSError as message1:
                self.logger.critical('Failed to create directory %s, %s', path.as_posix(), message1)
                sys.exit(1)
        self._output_directory = path

    @property
    def env(self) -> Environment:
        """
        Getter for Jinja2 instance
        :return: initialized Jinja2 instance
        """
        return self._env

    @env.setter
    def env(self, paths: list):
        """
        Initiating Jinja2 instance
        :param paths: list with paths to all Jinja2 templates
        :return: None
        """
        loaders = list(filter(lambda l: Path(l).exists(), paths))
        if not loaders:
            self.logger.error('Directory with templates not found %s', str(paths))
            sys.exit(1)
        loaders = [FileSystemLoader(l) for l in loaders]

        self._env = Environment(loader=ChoiceLoader(loaders))
        self._env.filters['title'] = self.title
        self._env.globals['year'] = date.today().year

    @staticmethod
    def title(name: str):
        """
        Capitalizing only first character in string. Using for appropriate filter in Jinja2
        :param name: string to be capitalized first character
        :return: initial parameter with capitalized first character
        """
        return Common.title(name)

    def config_logging(self, verbose):
        """
        Configuring logging for all application
        :param verbose: if True setting logging.DEBUG else logging.ERROR
        :return: None
        """
        handler = logging.StreamHandler()
        handler.setFormatter(logging.Formatter(fmt='%(asctime)s.%(msecs)03d - %(levelname)s - %(message)s',
                                               datefmt='%H:%M:%S'))
        root_logger = logging.getLogger()

        if verbose:
            handler.setLevel(logging.DEBUG)
            self.logger.setLevel(logging.DEBUG)
            root_logger.setLevel(logging.DEBUG)
        else:
            handler.setLevel(logging.ERROR)
            self.logger.setLevel(logging.ERROR)
            root_logger.setLevel(logging.ERROR)
        logging.getLogger().handlers.clear()
        root_logger.addHandler(handler)

    def get_parser(self):
        """
        Parsing and evaluating command-line arguments
        :return: object with parsed and validated CLI arguments
        """
        if len(sys.argv) == 2 and sys.argv[1] in ('-v', '--version'):
            print(self.get_version)
            sys.exit(0)

        container = namedtuple('container', 'name path')
        xml = container('source_xml', ROOT.joinpath('rpc_spec/MOBILE_API.xml'))
        required_source = not xml.path.exists()

        out = container('output_directory', ROOT.parents[0].joinpath('SmartDeviceLink'))
        output_required = not out.path.exists()

        parser = ArgumentParser(description='Proxy Library RPC Generator')
        parser.add_argument('-v', '--version', action='store_true', help='print the version and sys.exit')
        parser.add_argument('-xml', '--source-xml', '--input-file', required=required_source,
                            help='should point to MOBILE_API.xml')
        parser.add_argument('-xsd', '--source-xsd', required=False)
        parser.add_argument('-d', '--output-directory', required=output_required,
                            help='define the place where the generated output should be placed')
        parser.add_argument('-t', '--templates-directory', nargs='?', default=ROOT.joinpath('templates').as_posix(),
                            help='path to directory with templates')
        parser.add_argument('-r', '--regex-pattern', required=False,
                            help='only elements matched with defined regex pattern will be parsed and generated')
        parser.add_argument('--verbose', action='store_true', help='display additional details like logs etc')
        parser.add_argument('-e', '--enums', required=False, action='store_true',
                            help='if present, all enums will be generated')
        parser.add_argument('-s', '--structs', required=False, action='store_true',
                            help='if present, all structs will be generated')
        parser.add_argument('-m', '-f', '--functions', required=False, action='store_true',
                            help='if present, all functions will be generated')
        parser.add_argument('-y', '--overwrite', action='store_true',
                            help='force overwriting of existing files in output directory, ignore confirmation message')
        parser.add_argument('-n', '--skip', action='store_true',
                            help='skip overwriting of existing files in output directory, ignore confirmation message')

        args, unknown = parser.parse_known_args()

        if unknown:
            print('found unknown arguments: ' + ' '.join(unknown))
            parser.print_help(sys.stderr)
            sys.exit(1)

        if args.skip and args.overwrite:
            print('please select only one option skip "-n" or overwrite "-y"')
            sys.exit(1)

        if not args.enums and not args.structs and not args.functions:
            args.enums = args.structs = args.functions = True

        for kind in (xml, out):
            if not getattr(args, kind.name) and kind.path.exists():
                while True:
                    try:
                        confirm = input('Confirm default path {} for {} [Y/n]:\t'
                                        .format(kind.path, kind.name))
                        if confirm.lower() == 'y' or not confirm:
                            print('{} set to {}'.format(kind.name, kind.path))
                            setattr(args, kind.name, kind.path.as_posix())
                            break
                        if confirm.lower() == 'n':
                            print('provide argument ' + kind.name)
                            sys.exit(1)
                    except KeyboardInterrupt:
                        print('\nThe user interrupted the execution of the program')
                        sys.exit(1)

        self.logger.debug('parsed arguments:\n%s', vars(args))

        return args

    def versions_compatibility_validating(self):
        """
        Version of generator script requires the same or lesser version of parser script.
        if the parser script needs to fix a bug (and becomes, e.g. 1.0.1) and the generator script stays at 1.0.0.
        As long as the generator script is the same or greater major version, it should be parsable.
        This requires some level of backward compatibility. E.g. they have to be the same major version.
        """

        regex = r'(\d+\.\d+).(\d)'

        parser_origin = Parser().get_version
        generator_origin = self.get_version
        parser_split = findall(regex, parser_origin).pop()
        generator_split = findall(regex, generator_origin).pop()

        parser_major = float(parser_split[0])
        generator_major = float(generator_split[0])

        if parser_major > generator_major:
            self.logger.critical('Generator (%s) requires the same or lesser version of Parser (%s)',
                                 generator_origin, parser_origin)
            sys.exit(1)

        self.logger.info('Parser type: %s, version %s,\tGenerator version %s',
                         basename(getfile(Parser().__class__)), parser_origin, generator_origin)

    def get_file_content(self, file_name: Path) -> list:
        """

        :param file_name:
        :return:
        """
        try:
            with file_name.open('r') as file:
                content = file.readlines()
            return content
        except FileNotFoundError as message1:
            self.logger.error(message1)
            return []

    def get_key_words(self, file_name=ROOT.joinpath('rpc_spec/RpcParser/RESERVED_KEYWORDS')):
        """
        :param file_name:
        :return:
        """
        content = self.get_file_content(file_name)
        content = tuple(map(lambda e: re.sub(r'\n', r'', e).strip().casefold(), content))
        content = tuple(filter(lambda e: not re.search(r'^#+\s+.+|^$', e), content))
        return content

    def get_paths(self, file_name: Path = ROOT.joinpath('paths.ini')):
        """
        Getting and validating parent classes names
        :param file_name: path to file with container
        :return: namedtuple with container to key elements
        """
        content = self.get_file_content(file_name)
        if not content:
            self.logger.critical('%s not found', file_name)
            sys.exit(1)
        data = OrderedDict()

        for line in content:
            if line.startswith('#'):
                self.logger.warning('commented property %s, which will be skipped', line.strip())
                continue
            if re.match(r'^(\w+)\s?=\s?(.+)', line):
                if len(line.split('=')) > 2:
                    self.logger.critical('can not evaluate value, too many separators %s', str(line))
                    sys.exit(1)
                name, var = line.partition('=')[::2]
                if name.strip() in data:
                    self.logger.critical('duplicate key %s', name)
                    sys.exit(1)
                data[name.strip().lower()] = var.strip()

        missed = list(set(self.paths_named._fields) - set(data.keys()))
        if missed:
            self.logger.critical('in %s missed fields: %s ', content, str(missed))
            sys.exit(1)

        return self.paths_named(**data)

    def write_file(self, file: Path, templates: list, data: dict):
        """
        Calling producer/transformer instance to transform initial Model to dict used in jinja2 templates.
        Applying transformed dict to jinja2 templates and writing to appropriate file
        :param file: output file name
        :param templates: list with templates
        :param data: Dictionary with prepared output data, ready to be applied to Jinja2 template
        """
        try:
            render = self.env.get_or_select_template(templates).render(data)
            with file.open('w', encoding='utf-8') as handler:
                handler.write(render)
        except (TemplateNotFound, UndefinedError, TemplateAssertionError, TemplateSyntaxError, TemplateRuntimeError) \
                as error1:
            self.logger.error('skipping %s, template not found %s', file.as_posix(), error1)

    async def process_main(self, skip: bool, overwrite: bool, items: dict, transformer):
        """
        Process each item from initial Model. According to provided arguments skipping, overriding or asking what to to.
        :param skip: if file exist skip it
        :param overwrite: if file exist overwrite it
        :param items: elements initial Model
        :param transformer: producer/transformer instance
        """
        tasks = []
        for item in items.values():
            if item.name == 'FunctionID':
                self.logger.warning('%s will be skipped', item.name)
                continue
            render = transformer.transform(item)
            file = self.output_directory.joinpath(render.get('name', item.name))
            for extension in ('.h', '.m'):
                data = render.copy()
                data['imports'] = data['imports'][extension]
                file_with_suffix = file.with_suffix(extension)
                templates = ['{}s/template{}.jinja2'.format(type(item).__name__.lower(), extension)]
                if 'template' in data:
                    templates.insert(0, data['template'] + extension)
                tasks.append(self.process_common(skip, overwrite, file_with_suffix, data, templates))

        await asyncio.gather(*tasks)

    async def process_function_name(self, skip: bool, overwrite: bool, functions: dict, structs: dict,
                                    transformer: FunctionsProducer):
        """
        Processing output for SDLRPCFunctionNames and SDLRPCParameterNames
        :param skip: if target file exist it will be skipped
        :param overwrite: if target file exist it will be overwritten
        :param functions: Dictionary with all functions
        :param structs: Dictionary with all structs
        :param transformer: FunctionsProducer (transformer) instance
        :return:
        """
        tasks = []
        for name in [transformer.function_names, transformer.parameter_names]:
            file = self.output_directory.joinpath(name)
            if name == transformer.function_names:
                data = transformer.get_function_names(functions)
            elif name == transformer.parameter_names:
                data = transformer.get_simple_params(functions, structs)
            else:
                self.logger.error('No "data" for %s', name)
                continue
            for extension in ('.h', '.m'):
                templates = ['{}{}.jinja2'.format(name, extension)]
                file_with_suffix = file.with_suffix(extension)
                tasks.append(self.process_common(skip, overwrite, file_with_suffix, data, templates))

        await asyncio.gather(*tasks)

    async def process_common(self, skip: bool, overwrite: bool, file_with_suffix: Path, data: dict, templates: list):
        """
        Processing output common
        :param skip: if target file exist it will be skipped
        :param overwrite: if target file exist it will be overwritten
        :param file_with_suffix: output file name
        :param data: Dictionary with prepared output data, ready to be applied to Jinja2 template
        :param templates: list with paths to Jinja2 templates
        :return: None
        """
        if file_with_suffix.is_file():
            if skip:
                self.logger.info('Skipping %s', file_with_suffix.name)
                return
            if overwrite:
                self.logger.info('Overriding %s', file_with_suffix.name)
                file_with_suffix.unlink()
                self.write_file(file_with_suffix, templates, data)
            else:
                while True:
                    try:
                        confirm = input('File already exists {}. Overwrite? [Y/n]:\t'
                                        .format(file_with_suffix.name))
                        if confirm.lower() == 'y' or not confirm:
                            self.logger.info('Overriding %s', file_with_suffix.name)
                            self.write_file(file_with_suffix, templates, data)
                            break
                        if confirm.lower() == 'n':
                            self.logger.info('Skipping %s', file_with_suffix.name)
                            break
                    except KeyboardInterrupt:
                        print('\nThe user interrupted the execution of the program')
                        sys.exit(1)
        else:
            self.logger.info('Writing new %s', file_with_suffix.name)
            self.write_file(file_with_suffix, templates, data)

    @staticmethod
    def filter_pattern(interface, pattern):
        """
        Filtering Model to match with regex pattern
        :param interface: Initial (original) Model, obtained from module 'rpc_spec/InterfaceParser'
        :param pattern: regex pattern (string)
        :return: Model with items which match with regex pattern
        """
        enum_names = tuple(interface.enums.keys())
        struct_names = tuple(interface.structs.keys())

        if pattern:
            match = {key: OrderedDict() for key in vars(interface).keys()}
            match['params'] = interface.params
            for key, value in vars(interface).items():
                if key == 'params':
                    continue
                match[key].update({name: item for name, item in value.items() if re.match(pattern, item.name)})
            return Interface(**match), enum_names, struct_names
        return interface, enum_names, struct_names

    async def parser(self, source_xml, source_xsd):
        """
        Getting Model from source_xml, parsed and validated by module 'rpc_spec/InterfaceParser'
        :param source_xml: path to xml file
        :param source_xsd: path to xsd file
        :return: Model, obtained from module 'rpc_spec/InterfaceParser'
        """
        try:
            start = datetime.now()
            model = self.loop.run_in_executor(None, Parser().parse, source_xml, source_xsd)
            model = await model
            self.logger.debug('finish getting model in %s milisec,', (datetime.now() - start).microseconds / 1000.0)
            return model
        except ParseError as error1:
            self.logger.error(error1)
            sys.exit(1)

    def main(self):
        """
        Entry point for parser and generator
        :return: None
        """
        args = self.get_parser()
        self.config_logging(args.verbose)
        self.versions_compatibility_validating()
        self.output_directory = args.output_directory

        interface = self.loop.run_until_complete(self.parser(args.source_xml, args.source_xsd))
        paths = self.get_paths()

        self.env = [args.templates_directory] + [join(args.templates_directory, k) for k in vars(interface).keys()]

        filtered, enum_names, struct_names = self.filter_pattern(interface, args.regex_pattern)

        tasks = []
        key_words = self.get_key_words()

        functions_transformer = FunctionsProducer(paths, enum_names, struct_names, key_words)
        if args.enums and filtered.enums:
            tasks.append(self.process_main(args.skip, args.overwrite, filtered.enums,
                                           EnumsProducer(paths.enum_class, key_words)))
        if args.structs and filtered.structs:
            tasks.append(self.process_main(args.skip, args.overwrite, filtered.structs,
                                           StructsProducer(paths.struct_class, enum_names, struct_names, key_words)))
        if args.functions and filtered.functions:
            tasks.append(self.process_main(args.skip, args.overwrite, filtered.functions, functions_transformer))
            tasks.append(self.process_function_name(args.skip, args.overwrite, interface.functions,
                                                    interface.structs, functions_transformer))
        if tasks:
            self.loop.run_until_complete(asyncio.wait(tasks))
        else:
            self.logger.warning('Nothing matched with "%s"', args.regex_pattern)

        self.loop.close()


if __name__ == '__main__':
    Generator().main()
