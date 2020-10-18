import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from installer.page import Page

class Finished(Page):
    def __init__(self, window):
        Page.__init__(self, window)

        self.button = Gtk.Button(label="Exit")
        self.button.connect("clicked", self.on_exit_clicked)
        self.pack_start(self.button, False, False, 6)

    def on_exit_clicked(self, widget):
        Gtk.main_quit()
