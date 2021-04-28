from distutils.core import setup

setup(
    name="texcompile",
    version="0.0.1",
    packages=[
      "texcompile.client",
    ],
    license="Apache License 2.0",
    long_description=open("README.md").read(),
    url="https://github.com/andrewhead/texcompile",
    install_requires=[
        "requests>=2.0.0,<3.0.0",
        "typing_extensions"
    ],
)
