SHELL := /bin/bash
PY_VERSION := 3.6

# force stdout flush for python commands
export PYTHONUNBUFFERED := 1

STACK_NAME := com.github.<<Author>>.stack.<<ProjectName>>

BASE := $(shell /bin/pwd)
VENV_DIR := $(BASE)/.venv
VENV_TEST_DIR := $(BASE)/.venv-tests

PACKAGED_TEMPLATE := packaged.yml
VIRTUALENV := $(shell /usr/bin/which python$(PY_VERSION)) -m venv
ZIP_FILE := $(BASE)/<<ProjectName>>-bundle.zip
PYTHON_TEST := $(VENV_TEST_DIR)/bin/python$(PY_VERSION)

.DEFAULT_GOAL := build
.PHONY: build clean release deploy package bundle

build: clean
	$(VIRTUALENV) "$(VENV_DIR)"
	"$(VENV_DIR)/bin/pip$(PY_VERSION)" \
		--isolated \
		--disable-pip-version-check \
		install -Ur requirements.txt
	$(VIRTUALENV) "$(VENV_TEST_DIR)"
	"$(VENV_TEST_DIR)/bin/pip$(PY_VERSION)" \
		--isolated \
		--disable-pip-version-check \
		install -Ur test-requirements.txt

bundle:
	zip -r -9 "$(ZIP_FILE)" <<ProjectName>> 
	cd "$(VENV_DIR)/lib/python$(PY_VERSION)/site-packages" \
		&& zip -r9 "$(ZIP_FILE)" *
	cd "$(VENV_DIR)/lib64/python$(PY_VERSION)/site-packages" \
		&& zip -r9 "$(ZIP_FILE)" *

package: 
	sam package \
		--template-file template.yml \
		--s3-bucket $(STACK_NAME) \
		--s3-prefix sources \
		--output-template-file $(PACKAGED_TEMPLATE)

deploy:
	sam deploy \
		--template-file $(PACKAGED_TEMPLATE) \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_IAM
run-local:
	sam local start-api --template template.yml

test:
	$(PYTHON_TEST) -m unittest discover -s tests -p '*_test.py'

integ-test: 
	$(PYTHON_TEST) -m unittest discover -s tests -p '*_integ_test.py'

release:
	@make bundle
	@make package
	@make deploy

clean:
	rm -rf "$(PACKAGED_TEMPLATE)" "$(VENV_DIR)" "$(BASE)/__pycache__" "$(ZIP_FILE)" "$(VENV_TEST_DIR)"

