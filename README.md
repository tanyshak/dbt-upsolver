# dbt-upsolver

## Work in progress ...

#### Instruction for dev run:

### 1. Install dbt-core:
```sh
pip install dbt-core
```
or use [installation guide](https://docs.getdbt.com/docs/get-started/installation)

### 2. Get local driver version and install it:
```sh
git clone git@github.com:Upsolver/upsolver-sdk-python.git upsolver-sdk-python

pip install -e <path to the upsolver-sdk-python project folder>
```

### 3. Get local adapter version:
```sh
git clone git@github.com:Upsolver/dbt-upsolver.git dbt-upsolver
```
### 4. Build whl file and install it:
```sh
python setup.py bdist_wheel --universal

find ./dist/*.whl -maxdepth 1 -type f | xargs pip install --force-reinstall --find-links=dist/
```
###  5.  Add to profiles.yml the following code:

```yml
<project name>:
  target: dev
  outputs:
    dev:
      api_url: https://mt-api-prod.upsolver.com
      database: default_glue_catalog
      schema: <database>
      threads: 1
      token: <token>
      type: upsolver
      user: <user>
```

###  6. Run dbt in one of the folders of projects examples
Like /dbt-upsolver/examples/s3_to_athena

#### - To check connection:
```sh
dbt debug
```
#### - To run all models
```sh
dbt run
```
#### - To run the specific model
```sh
dbt run --select <model name>
```

> Since requests for the upsolver system information are still under development.
Models will work successfully only if they have not been created before. Otherwise, throw an error "already exists"
