import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from installer.page import Page
from installer.finished import Finished
import parted

class DiskSetup(Page):
    def __init__(self, window):
        Page.__init__(self, window, Gtk.Orientation.VERTICAL)
        self.selected = 0
        vbox = Gtk.VBox()

        self.btn1 = Gtk.RadioButton()
        self.btn1.set_label("Format disk and install Gentoo")
        self.btn1.connect("toggled", self.on_select)
        self.btn1.id = 0
        self.btn2 = Gtk.RadioButton.new_from_widget(self.btn1)
        self.btn2.set_label("Format disk and install Gentoo (LUKS encrypted rootfs)")
        self.btn2.connect("toggled", self.on_select)
        self.btn2.id = 1
        self.btn3 = Gtk.RadioButton.new_from_widget(self.btn1)
        self.btn3.set_label("Custom Disk Configuration (Not yet supported)")
        self.btn3.connect("toggled", self.on_select)
        self.btn3.id = 2

        vbox.add(self.btn1)
        vbox.add(self.btn2)
        vbox.add(self.btn3)
        self.pack_start(vbox, True, True, 5)

        self.continue_button = Gtk.Button(label="Continue")
        self.continue_button.connect("clicked", self.on_continue_clicked)
        self.pack_start(self.continue_button, True, False, 5)

    def on_select(self, widget, data=None):
        self.selected = widget.id

    def on_continue_clicked(self, widget):
        if self.selected == 0:
            self.window.luks = False
            self.next_page(DiskSelect)
        elif self.selected == 1:
            self.window.luks = True
            self.next_page(DiskSelect)

class DiskSelect(Page):
    def __init__(self, window):
        Page.__init__(self, window, Gtk.Orientation.VERTICAL)
        self.list = Gtk.ListBox()
        self.pack_start(self.list, True, True, 5)
        self.devices = []

        for device in parted.getAllDevices():
            self.devices.append(device.path)
            row = Gtk.HBox()
            row.add(Gtk.Label("{}: {}".format(device.path, device.model)))
            row.add(Gtk.Label("{} GB".format(int((device.length * device.sectorSize) / (1000 * 1000 * 1000)))))
            self.list.add(row)

        self.buttons = Gtk.HButtonBox()
        self.pack_start(self.buttons, False, False, 5)

        self.back_button = Gtk.Button(label="Back")
        self.back_button.connect("clicked", self.on_back_clicked)
        self.buttons.pack_start(self.back_button, True, False, 5)

        self.continue_button = Gtk.Button(label="Continue")
        self.continue_button.connect("clicked", self.on_continue_clicked)
        self.buttons.pack_start(self.continue_button, True, False, 5)

    def on_continue_clicked(self, widget, data=None):
        if self.list.get_selected_row() is not None:
            self.window.drive = self.devices[self.list.get_selected_row().get_index()]
            self.next_page(Finished)

    def on_back_clicked(self, widget, data=None):
        self.next_page(DiskSetup)

