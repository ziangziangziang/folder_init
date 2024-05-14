#!/usr/bin/env  bash
##
# Created on Mon May 13 2024
#
# Copyright (c) 2024 Ziang Zhang
#
# High Performance Computing Facility (HPCF), St. Jude Children's Research Hospital (SJCRH)
# 
##
VERSION="0.1.0"
AUTHOR="Ziang Zhang"
AUTHOR_EMAIL="ZIANGZHANG1997[at]GMAIL.COM"
LICENSE_ADDRESS="https://www.gnu.org/licenses/gpl.txt"
declare -A TYPE_MAP
TYPE_MAP["pyproject"]="pyproject"

# help function
function help {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help: show help information"
    echo "  -v, --version: show version information"
    echo "  -t, --type: the type of the program"
    echo "Available types:"
    for key in "${!TYPE_MAP[@]}"; do
        echo "  $key - ${TYPE_MAP[$key]}"
    done
}

# version function, read version from VERSION file
function version {
    echo "Version: $VERSION"
}

# main function
function main {
    if [ $# -eq 0 ]; then
        help
        exit 1
    fi
    while [ "$1" != "" ]; do
        case $1 in
            -h | --help ) help
                          exit
                          ;;
            -v | --version ) version
                              exit
                              ;;
            -t | --type ) shift
                            TYPE=$1
                          ;;
            # print help and quit if the option is not valid
            * ) help
                exit 1
                ;;
        esac
        shift
    done

    echo "Initializing a $TYPE project..."

    # check if the type is valid
    if [ -z ${TYPE_MAP[$TYPE]} ]; then
        echo "Invalid type: $TYPE"
        exit 1
    fi
    
    # call the corresponding function
    ${TYPE_MAP[$TYPE]}

}

function pyproject {
    echo "Create a Python project..."
    
    # The file structure of a Python project
    # project/
    # ├── README.md
    # ├── LICENSE
    # ├── CHANGELOG
    # ├── pyproject.toml
    # ├── src/
    # │   └── project/
    # │       ├── __init__.py
    # │       └── mymodule.py
    # └── tests/
    #     └── test_mymodule.py
    
    # Ask for the prefix folder, default the current folder
    read -p "Enter the project folder (default: .): " FOLDER
    read -p "Enter the project name: " PROJECT_NAME
    FOLDER=${FOLDER:-$(pwd)}
    
    # Create the project folder if it does not exist
    if [ ! -d $FOLDER ]; then
        echo "Creating the project folder $FOLDER"
        mkdir -p $FOLDER
    else
        echo "The project folder $FOLDER already exists"
    fi
    
    # Create the project folder
    PROJECT_FOLDER=$FOLDER
    if [ ! -d $PROJECT_FOLDER ]; then
        echo "Creating the project folder $PROJECT_FOLDER"
        mkdir -p $PROJECT_FOLDER
    else
        echo "The project folder $PROJECT_FOLDER already exists"
    fi

    # Create the README.md file
    README_FILE=$PROJECT_FOLDER/README.md
    touch $README_FILE
    
    # Create the LICENSE file
    LICENSE_FILE=$PROJECT_FOLDER/LICENSE
    wget -O $LICENSE_FILE $LICENSE_ADDRESS --no-check-certifie

    # Create the CHANGELOG file
    CHANGELOG_FILE=$PROJECT_FOLDER/CHANGELOG
    touch $CHANGELOG_FILE

    # Create the requirements.txt file
    REQUIREMENTS_FILE=$PROJECT_FOLDER/requirements.txt
    touch $REQUIREMENTS_FILE

    # Create the pyproject.toml file
    PYPROJECT_FILE=$PROJECT_FOLDER/pyproject.toml
    cat <<EOF > $PYPROJECT_FILE
[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
description = "A Python project"
version = "0.1.0"
requires-python = ">= 3.6"
dependencies = [ 
  "numpy == 1.21.0",
  "pandas == 1.3.0",
]
authors = [ 
  {name = "$AUTHOR", email = "$AUTHOR_EMAIL"},
]
maintainers = [ 
  {name = "$AUTHOR", email = "$AUTHOR_EMAIL"},
]
readme = "README.md"
license = {text = "GPL License"}
keywords = ["python", "project"]
EOF

    # Create the src folder
    SRC_FOLDER=$PROJECT_FOLDER/src
    if [ ! -d $SRC_FOLDER ]; then
        echo "Creating the src folder $SRC_FOLDER"
        mkdir -p $SRC_FOLDER
    else
        echo "The src folder $SRC_FOLDER already exists"
    fi

    # Create the project folder
    PROJECT_SRC_FOLDER=$SRC_FOLDER/$PROJECT_NAME
    if [ ! -d $PROJECT_SRC_FOLDER ]; then
        echo "Creating the project folder $PROJECT_SRC_FOLDER"
        mkdir -p $PROJECT_SRC_FOLDER
    else
        echo "The project folder $PROJECT_SRC_FOLDER already exists"
    fi

    # Create the __init__.py file
    INIT_FILE=$PROJECT_SRC_FOLDER/__init__.py
    touch $INIT_FILE

    # Create the mymodule.py file
    MYMODULE_FILE=$PROJECT_SRC_FOLDER/mymodule.py
    touch $MYMODULE_FILE

    # Create the tests folder
    TESTS_FOLDER=$PROJECT_FOLDER/tests
    if [ ! -d $TESTS_FOLDER ]; then
        echo "Creating the tests folder $TESTS_FOLDER"
        mkdir -p $TESTS_FOLDER
    else
        echo "The tests folder $TESTS_FOLDER already exists"
    fi

    # Create the test_mymodule.py file
    TEST_MYMODULE_FILE=$TESTS_FOLDER/test_mymodule.py
    cat <<EOF > $TEST_MYMODULE_FILE
import unittest
from $PROJECT_NAME import add

class TestMyModule(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(1, 2), 3)

if __name__ == '__main__':

    unittest.main()
    
EOF

    echo "Python project $PROJECT_NAME initialized successfully"
     
}

# call the main function
main $@
