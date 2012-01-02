# rubyinstaller-org

This repository holds the source code for rubyinstaller.org website.

## Getting Started

The website requires Ruby 1.9.3 (patchlevel 0 at this time) and [Isolate](https://github.com/jbarnette/isolate)

Simply invoke `rake isolate:env` so it install all the required dependencies for you.

These dependencies will be installed inside `tmp` directory, so it will not pollute your system.
