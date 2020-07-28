from setuptools import setup

setup(
    name='infrastructure',
    version='0.1.0',
    packages=['infrastructure'],
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
