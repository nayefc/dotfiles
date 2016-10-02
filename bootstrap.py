class Package(object):

    osx_packages = []

    def install_osx(self):
        for package in self.osx_packages:
            # brew install package
            pass
        pass

    def install_linux(self):
        pass


class Bash(object):

    def pre_stow(self):
        # back up .bash_profile and .bashrc
        pass


class Tmux(object):

    osx_packages = ['tmux']

class Git(object):

    def pre_stow(self):
        # set up gitconfig templates
        pass


class Emacs(object):

    osx_packages = ['emacs', 'cask']


class Ssh(object):
    pass


class Bootstrap(object):

    supported_packages = {
    }

    def stow_package(self, package):
        pass

    def stow(self, packages=None):

        if not packages:
            # all
            pass
        else:
            for package in packages:
                print 'Stowing ...'
                self.stow_package(package)


if __name__ == '__main__':
    pass
