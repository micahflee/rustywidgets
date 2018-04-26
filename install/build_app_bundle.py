#!/usr/bin/env python
import os
import subprocess
import shutil

# Roughly following: https://vin047.xyz/binaries-to-app-bundle/ (which is down)
# Google cache version: https://webcache.googleusercontent.com/search?q=cache:OCW5q4AbSAsJ:https://vin047.xyz/binaries-to-app-bundle/+&cd=6&hl=en&ct=clnk&gl=us&client=firefox-b-1-ab

# Build paths
repo_path = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
bundle_path = os.path.join(repo_path, 'target/release/bundle/osx/RustyWidgets.app')
bin_path = os.path.join(bundle_path, 'Contents/MacOS/rustywidgets')
libraries_path = os.path.join(bundle_path, 'Contents/Libraries')

def find_libs(filename, dylibs=[], recursive=True):
    """
    Recursively find all the dynamic library dependencies of a binary, return a
    list of paths to the .dylib files
    """
    new_dylibs = []

    out = subprocess.check_output(['otool', '-L', filename])
    for line in out.split('\n')[1:]:
        dylib = line.strip().split(' ')[0]
        if dylib.startswith('/usr/local/'):
            basename = os.path.basename(dylib)

            # Fix reference in binary being checked
            subprocess.call([
                'install_name_tool', '-change', dylib,
                "@executable_path/../Libraries/{}".format(basename), filename
            ])

            if dylib not in dylibs:
                # Copy dependency, and fix reference to itself
                dylib_filename = os.path.join(libraries_path, basename)
                shutil.copyfile(dylib, dylib_filename)
                os.chmod(dylib_filename, 0o644)

                subprocess.call([
                    'install_name_tool', '-id',
                    "@executable_path/../Libraries/{}".format(basename),
                    os.path.join(libraries_path, basename)
                ])

                new_dylibs.append(os.path.join(libraries_path, basename))

    # Add all the new dylibs we found to dylibs
    dylibs.extend(new_dylibs)

    if not recursive:
        return dylibs

    # Loop through new dylibs, recursively finding their deps
    for dylib in new_dylibs:
        recursive_dylibs = find_libs(dylib, dylibs)
        for recursive_dylib in recursive_dylibs:
            if recursive_dylib not in dylibs:
                dylibs.append(recursive_dylib)

    return dylibs

def main():
    # Clean up from last time, and create a new app bundle
    shutil.rmtree(bundle_path, True)
    subprocess.call(['cargo', 'bundle', '--release'])
    os.makedirs(libraries_path)
    dylibs = find_libs(bin_path)

if __name__ == '__main__':
    main()
