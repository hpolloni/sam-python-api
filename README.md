# sam-python-api

Python template for APIs using SAM. It's based on the sam sample for python. Note that the accompanying 'pp' script do everything for you. 

IMPORTANT: DO NOT CHECKOUT THIS PROJECT. Use 'pp' script only. All the files have placeholder in them for the project name, author and email.

## Requirements
For pp:
* Python3.6
* Git

Running it:
* SAM local
* Virtualenv

# Using it
## Creating the project
Download pp (checked-in into this repo) and run:

```bash
$ wget https://raw.githubusercontent.com/hpolloni/sam-python-api/master/pp && chmod +x pp
$ ./pp [projectName]
```
Replace ```[projectName]``` with your project's name. The project name should follow the python module naming conventions (no '/' or '-').

For instance, if running ```./pp proj```. The directory structure looks like:
```
├── Makefile
├── pp
├── proj
│   ├── handlers.py
│   └── __init__.py
├── README.md
├── requirements.txt
├── setup.cfg
├── setup.py
├── template.yml
├── test-requirements.txt
├── tests
│   └── handler_integ_test.py
└── VERSION
```

## Running local and integ tests
In order to run it locally. You will need to create the python bundle.
```bash
$ make && make bundle
```

Running sam local should be as simple as:
```bash
$ make run-local
```

After that, you can run integration tests against local endpoint:
```bash
$ make integ-test
```

