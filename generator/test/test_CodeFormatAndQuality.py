# pylint: disable=C0103, C0301, C0115, C0116
"""Interface model unit test

"""
import unittest
from os import walk
from os.path import join
from pathlib import Path

from pylint.lint import Run


class TestCodeFormatAndQuality(unittest.TestCase):
    MINIMUM_SCORE = 9

    def setUp(self):
        """Searching for all python files to be checked

        """
        self.list_of_files = ['--max-line-length=130', '--disable=import-error']
        root = Path(__file__).absolute().parents[1]
        for (directory, _, filenames) in walk(root.as_posix()):
            self.list_of_files += [join(directory, file) for file in filenames
                                   if file.endswith('.py') and not file.startswith('test')
                                   and 'rpc_spec' not in directory]

    def test_pylint_conformance(self):
        """Performing checks by PyLint

        """
        results = Run(self.list_of_files, do_exit=False)
        score = results.linter.stats['global_note']
        self.assertGreaterEqual(score, self.MINIMUM_SCORE)


if __name__ == '__main__':
    unittest.main()
