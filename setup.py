from setuptools import find_packages, setup

setup(
    name='infrastructure',
    version='0.1.0',
    packages=find_packages(),
    package_data = {
        '': ['*/*/*/*/*'],
    },
    install_requires=[
        'Click>=7,<8',
        'requests>=2,<3',
        'Jinja2>=2,<3',
    ],
    entry_points={
        'console_scripts': [
            'infrastructure = infrastructure:main',
        ],
    },
)
