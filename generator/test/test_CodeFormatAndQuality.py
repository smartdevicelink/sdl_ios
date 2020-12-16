"""
Interface model unit test
"""
import unittest
from os import walk
from os.path import join
from pathlib import Path

from flake8.api import legacy as flake8


class CodeFormatAndQuality(unittest.TestCase):
    def setUp(self):
        self.list_of_files = []
        for (directory, _, filenames) in walk(Path(__file__).absolute().parents[1].as_posix()):
            self.list_of_files += [join(directory, file) for file in filenames
                                   if file.endswith('.py') and 'test' not in directory
                                   and 'rpc_spec' not in directory]

    def test_checkCodeFormatAndQuality(self):
        """
        Performing checks of Code Format And Quality by flake8
        If any inconvenient low quality code will be found, this will be shown in stdout and
        each such cases will be reflected with report.total_errors number
        """
        style_guide = flake8.get_style_guide(max_line_length=2048)
        report = style_guide.check_files(self.list_of_files)
        self.assertEqual(report.total_errors, 0)


if __name__ == '__main__':
    unittest.main()
