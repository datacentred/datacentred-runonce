# Run Once

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Testing - Guide for contributing to the module](#testing)

## Overview

The run once module is a wrapper around exec.  It ensures that a command is only ever executed once without having to explitily specifying $onlyif or $unless parameters.

## Module Description

The underlying implmentation uses semaphore lock files to control whether or not to run a command.  An optional semaphore directory is created if it did not already exist, the command executed and the semaphore created upon success.  Semaphores can either be persistent, by default residing in `/etc/puppetlabs/puppet/semaphores, or transient, residing in /tmp, and thus the command will be executed once per reboot.

## Usage

    runonce { 'hello-world':
      command => 'echo hello world!',
    }

    runonce { 'init-modules':
      command    => 'service kmod start',
      persistent => false,
    }

## Limitations

The current implmentation relies on /tmp being cleared by the underlying operating system on a reboot.  Aditionally the persistent semaphore directory does not support parent directory creation.

## Testing

This has been tested on Ubuntu LTS 12.04 and 14.04

