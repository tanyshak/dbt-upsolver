#!/usr/bin/env python
from setuptools import find_namespace_packages, setup

package_name = "dbt-upsolver"
# make sure this always matches dbt/adapters/{adapter}/__version__.py
package_version = "1.4.1"
description = """The Upsolver adapter plugin for dbt"""

setup(
    name=package_name,
    version=package_version,
    description=description,
    long_description=description,
    author="Tetiana Shemet",
    author_email="tatiana.shemet@nestlogic.com",
    url="If you have already made a github repo to tie the project to place it here, otherwise update in setup.py later.",
    packages=find_namespace_packages(include=["dbt", "dbt.*"]),
    include_package_data=True,
    install_requires=[
        "dbt-core~=1.4.1"
    ]
)
