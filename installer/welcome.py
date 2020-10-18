import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from installer.page import Page
from installer.finished import Finished


class Welcome(Page):
    welcome_message = "Welcome the the unofficial Gentoo Installer!\nSelect Begin to start installation or Close to try Gentoo and install later."

    def __init__(self, window):
        Page.__init__(self, window, Gtk.Orientation.VERTICAL)

        self.msg = Gtk.Label(Welcome.welcome_message)
        self.msg.set_justify(Gtk.Justification.CENTER)
        self.pack_start(self.msg, True, True, 5)

        self.buttons = Gtk.HButtonBox()
        self.pack_start(self.buttons, False, False, 5)

        self.begin_button = Gtk.Button(label="Begin")
        self.begin_button.connect("clicked", self.on_begin_clicked)
        self.buttons.pack_start(self.begin_button, True, False, 5)

        self.close_button = Gtk.Button(label="Close")
        self.close_button.connect("clicked", self.on_close_clicked)
        self.buttons.pack_start(self.close_button, True, False, 5)

    def on_begin_clicked(self, widget):
        self.next_page(Finished)

    def on_close_clicked(self, widget):
        Gtk.main_quit()
