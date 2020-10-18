import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class Page(Gtk.Box):
    def __init__(self, window, orientation=Gtk.Orientation.VERTICAL):
        Gtk.Box.__init__(self, orientation=orientation)
        self.window = window

    def next_page(self, new_page):
        self.window.next_page(new_page)
