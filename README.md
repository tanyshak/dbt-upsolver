# dbt-upsolver

## Work in progress ...

#### Instruction for dev run:

> Note: The latest version of dbt-core is compatible with `Python versions 3.7, 3.8, 3.9, and 3.10`

### 1. Install dbt-core:
```sh
pip install dbt-core
```
##### make sure that insatled latest dbt version  1.4.1:
```sh
dbt --version
```
##### if not upgrade it:
```sh
pip install --upgrade dbt-core
```
or use [installation guide](https://docs.getdbt.com/docs/get-started/installation)

### 2. Get local driver version and install it:
```sh
git clone git@github.com:Upsolver/upsolver-sdk-python.git upsolver-sdk-python
cd upsolver-sdk-python
pip install -e $(pwd)
```
### 3. Get local adapter version:
#### back to work directory
```sh
cd ..
```
#### clone dbt-upsolver
```sh
git clone git@github.com:Upsolver/dbt-upsolver.git dbt-upsolver
```
### 4. Build whl file and install it:
```sh
cd dbt-upsolver

python setup.py bdist_wheel --universal

find ./dist/*.whl -maxdepth 1 -type f | xargs pip install --force-reinstall --find-links=dist/
```

### 5. Make sure the adapter is installed:
```sh
dbt --version
```
#### Expect to see:
```
Core:
  - installed: 1.4.5
  - latest:    1.4.5 - Up to date!
Plugins:
  - upsolver: 1.4.5 - Could not determine latest version
```
###  5.  Add to profiles.yml the following code:
###### profiles.yml location is something like /Users/tanya shemet/.dbt/profiles.yml
```yml
config:
  use_colors: true
  partial_parse: true
  warn_error: true
  debug: true

mt-api-integ-e2e:
  target: dev
  outputs:
    dev:
      api_url: https://mt-api-integ-e2e.upsolver.com
      database: ...
      schema: ...
      threads: 1
      token: ...
      type: upsolver
      user: ...
```
> database and schema  you can find on your https://mt-api-integ-e2e.upsolver.com
> token you should  generate on your https://mt-api-integ-e2e.upsolver.com

###  6. Run dbt in one of the folders of projects examples
For example: /dbt-upsolver/examples/s3_to_athena
#### Go to project folder
Under dbt-upsolver/
```sh
cd examples/s3_to_athena
```
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
The model will work successfully if it hasn't been created before. If it did then the model will be altered with "COMMENT = {curr_datetime}"
