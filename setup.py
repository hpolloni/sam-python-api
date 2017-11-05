#!/usr/bin/env python
import os
from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
VERSION = open(os.path.join(here, 'VERSION')).read().strip()

required_eggs = [
    'boto3>=1.4.7',
]

PACKAGE_NAME='<<ProjectName>>'
setup(
    name=PACKAGE_NAME,
    version=VERSION,
    description="",
    author="<<Author>>",
    author_email='<<Email>>',
    url='',
    packages=find_packages(exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    namespace_packages=[PACKAGE_NAME],
    package_data={PACKAGE_NAME: ['static/*.*', 'templates/*.*']},
    install_requires=required_eggs,
    extras_require=dict(
        test=required_eggs + [
            'pytest>=3.2',
        ],
        develop=required_eggs + [
            'ipdb>=0.10.2',
        ]),
    zip_safe=False,
)
