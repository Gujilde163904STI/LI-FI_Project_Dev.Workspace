#!/usr/bin/env python3
"""
Setup script for the Raspberry Pi Manager module.
"""

from setuptools import setup, find_packages
import os

# Read the version from __init__.py
with open(os.path.join('rpi_manager', '__init__.py'), 'r') as f:
    for line in f:
        if line.startswith('__version__'):
            version = line.split('=')[1].strip().strip("'").strip('"')
            break

# Read the long description from README.md
with open('README.md', 'r') as f:
    long_description = f.read()

setup(
    name='rpi_manager',
    version=version,
    description='A comprehensive GUI tool for managing Raspberry Pi devices',
    long_description=long_description,
    long_description_content_type='text/markdown',
    author='LI-FI Project Dev Team',
    author_email='info@lifiproject.dev',
    url='https://github.com/lifiproject/rpi-manager',
    packages=find_packages(),
    install_requires=[
        'pyserial',
        'paramiko',
    ],
    entry_points={
        'console_scripts': [
            'rpi-manager=rpi_manager.cli:main',
        ],
        'gui_scripts': [
            'rpi-manager-gui=rpi_manager.gui:main',
        ],
    },
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Topic :: System :: Hardware',
        'Topic :: System :: Systems Administration',
        'Topic :: Utilities',
    ],
    python_requires='>=3.6',
    include_package_data=True,
    zip_safe=False,
)