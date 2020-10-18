import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from installer.welcome import Welcome
from installer.finished import Finished

class Installer(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Gentoo Installer")
        self.page = Welcome(self)
        self.add(self.page)
        self.connect("destroy", Gtk.main_quit)
        self.show_all()

    def next_page(self, new_page):
        self.remove(self.page)
        self.page = new_page(self)
        self.add(self.page)
        self.show_all()

    @staticmethod
    def run():
        win = Installer()
        Gtk.main()

