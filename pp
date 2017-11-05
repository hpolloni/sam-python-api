#!/usr/bin/env python3

import logging
import subprocess
import os

PROJECT_REPO = 'ssh://git@github.com/hpolloni/sam-python-api.git'

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

def sh(cmd):
    stdout_bytes = subprocess.check_output(cmd, shell=True)
    return stdout_bytes.decode('unicode_escape')

def author():
    try:
        return sh('git config --global user.name').strip()
    except Exception as e:
        import getpass
        return getpass.getuser().strip()

def gitemail():
    try:
        return sh('git config --global user.email').strip()
    except Exception as e:
        log.exception(e)
        return 'nobody@nowhere.com'

def projectdir(projectName):
    return os.path.join(os.getcwd(), projectName)

def templatereplace(filename, templateargs):
    with open(filename, 'r') as f:
        content = f.read()
    for key,value in templateargs.items():
        content = content.replace('<<' + key + '>>', value)
    with open(filename, 'w') as f:
        f.write(content)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Creates a project package')
    parser.add_argument('--author', default=author(), type=str, help='Specifies the author name')
    parser.add_argument('--email', default=gitemail(), type=str, help='Specifies the author email')
    parser.add_argument('projectName', help='Project name')
    args = parser.parse_args()
    log.info('Generating: %s' % args.projectName)
    log.info('Email: %s' % args.email)
    log.info('Author: %s' % args.author)
    log.info('File: %s' % __file__)

    if os.path.sep in args.projectName:
        raise Exception('Project name cant contain path separator')

    pdir = projectdir(args.projectName)

    log.info('Checking out project template into %s' % pdir)
    # TODO: use git archive
    sh('git clone %s %s' % (PROJECT_REPO, pdir))
    os.rename(os.path.join(pdir, 'example'), os.path.join(pdir, args.projectName))
    log.info('Replacing templates')
    for dirpath, dirnames, files in os.walk(pdir):
        if '.git' in dirpath:
            continue
        for f in files:
            templateargs = {
                'ProjectName': args.projectName,
                'Author': args.author,
                'Email':  args.email
            }
            filename = os.path.join(dirpath, f)
            log.info('Processing: %s' % filename)
            templatereplace(filename, templateargs)
    
