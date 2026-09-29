#!/usr/bin/env python3
"""Minimal GTK4 control panel for Linuwu-Sense (Acer Predator PHN16-71)."""
import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gdk
import json, sys
from pathlib import Path

BASE = "/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi"
KB = f"{BASE}/four_zoned_kb"
PS = f"{BASE}/predator_sense"
STATE_FILE = Path.home() / ".config" / "linuwu-sense-gui" / "state.json"

MODES = ["Static", "Breathing", "Neon", "Wave", "Shifting", "Zoom", "Meteor", "Twinkling"]

DEFAULT_STATE = {
    "kb_on": False,
    "mode": 3,
    "speed": 5,
    "brightness": 100,
    "direction": 1,
    "color": (0, 150, 255),
    "zone_colors": ["ff0000", "00ff00", "0000ff", "ffffff"],
    "zone_brightness": 100,
    "cpu_fan": 0,
    "gpu_fan": 0,
}


def load_state():
    try:
        merged = DEFAULT_STATE.copy()
        merged.update(json.loads(STATE_FILE.read_text()))
        return merged
    except Exception:
        return DEFAULT_STATE.copy()


def save_state(state):
    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
    STATE_FILE.write_text(json.dumps(state))


def write(path, value):
    with open(path, "w") as f:
        f.write(value)


def read(path, default=""):
    try:
        return open(path).read().strip()
    except Exception:
        return default


def apply_keyboard(state):
    if not state["kb_on"]:
        write(f"{KB}/four_zone_mode", "0,0,0,1,0,0,0")
        return
    r, g, b = state["color"]
    write(f"{KB}/four_zone_mode",
          f"{state['mode']},{state['speed']},{state['brightness']},{state['direction']},{r},{g},{b}")


def apply_zones(state):
    z = ",".join(state["zone_colors"])
    write(f"{KB}/per_zone_mode", f"{z},{state['zone_brightness']}")


def apply_fans(state):
    write(f"{PS}/fan_speed", f"{state['cpu_fan']},{state['gpu_fan']}")


def apply_all(state):
    apply_keyboard(state)
    apply_fans(state)


def rgba_of(rgb):
    c = Gdk.RGBA()
    c.red, c.green, c.blue, c.alpha = rgb[0] / 255, rgb[1] / 255, rgb[2] / 255, 1.0
    return c


def rgba_of_hex(h):
    return rgba_of((int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)))


def hex_of_rgba(rgba):
    return "%02x%02x%02x" % (round(rgba.red * 255), round(rgba.green * 255), round(rgba.blue * 255))


class Window(Gtk.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Predator Control")
        self.set_default_size(420, 520)
        self.state = load_state()

        header = Gtk.HeaderBar()
        self.set_titlebar(header)

        stack = Gtk.Stack()
        switcher = Gtk.StackSwitcher(stack=stack)
        header.set_title_widget(switcher)

        stack.add_titled(self.build_keyboard_page(), "keyboard", "Keyboard")
        stack.add_titled(self.build_fan_page(), "fans", "Fans")
        self.set_child(stack)

    def build_keyboard_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        for m in ("margin_top", "margin_bottom", "margin_start", "margin_end"):
            getattr(box, f"set_{m}")(18)

        row = Gtk.Box(spacing=8)
        row.append(Gtk.Label(label="Backlight", xalign=0, hexpand=True))
        self.kb_switch = Gtk.Switch(active=self.state["kb_on"])
        row.append(self.kb_switch)
        box.append(row)

        box.append(Gtk.Separator())
        box.append(Gtk.Label(label="Effect", xalign=0))

        self.mode_dropdown = Gtk.DropDown.new_from_strings(MODES)
        self.mode_dropdown.set_selected(self.state["mode"])
        box.append(self.mode_dropdown)

        box.append(Gtk.Label(label="Speed", xalign=0))
        self.speed_scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 9, 1)
        self.speed_scale.set_value(self.state["speed"])
        box.append(self.speed_scale)

        box.append(Gtk.Label(label="Brightness", xalign=0))
        self.bright_scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
        self.bright_scale.set_value(self.state["brightness"])
        box.append(self.bright_scale)

        dir_row = Gtk.Box(spacing=8)
        dir_row.append(Gtk.Label(label="Direction", xalign=0, hexpand=True))
        self.dir_toggle = Gtk.ToggleButton(
            label="Left → Right" if self.state["direction"] == 2 else "Right → Left")
        self.dir_toggle.set_active(self.state["direction"] == 2)
        self.dir_toggle.connect("toggled", lambda b: b.set_label(
            "Left → Right" if b.get_active() else "Right → Left"))
        dir_row.append(self.dir_toggle)
        box.append(dir_row)

        color_row = Gtk.Box(spacing=8)
        color_row.append(Gtk.Label(label="Color", xalign=0, hexpand=True))
        self.color_btn = Gtk.ColorButton()
        self.color_btn.set_rgba(rgba_of(self.state["color"]))
        color_row.append(self.color_btn)
        box.append(color_row)

        apply_btn = Gtk.Button(label="Apply effect")
        apply_btn.connect("clicked", self.on_apply_keyboard)
        box.append(apply_btn)

        box.append(Gtk.Separator())
        box.append(Gtk.Label(label="Per-zone colors (Static)", xalign=0))

        self.zone_buttons = []
        zones_row = Gtk.Box(spacing=8)
        for hexcol in self.state["zone_colors"]:
            btn = Gtk.ColorButton()
            btn.set_rgba(rgba_of_hex(hexcol))
            zones_row.append(btn)
            self.zone_buttons.append(btn)
        box.append(zones_row)

        zone_apply = Gtk.Button(label="Apply per-zone colors")
        zone_apply.connect("clicked", self.on_apply_zones)
        box.append(zone_apply)

        return box

    def on_apply_keyboard(self, _btn):
        rgba = self.color_btn.get_rgba()
        self.state.update({
            "kb_on": self.kb_switch.get_active(),
            "mode": self.mode_dropdown.get_selected(),
            "speed": int(self.speed_scale.get_value()),
            "brightness": int(self.bright_scale.get_value()),
            "direction": 2 if self.dir_toggle.get_active() else 1,
            "color": (round(rgba.red * 255), round(rgba.green * 255), round(rgba.blue * 255)),
        })
        apply_keyboard(self.state)
        save_state(self.state)

    def on_apply_zones(self, _btn):
        self.state["zone_colors"] = [hex_of_rgba(b.get_rgba()) for b in self.zone_buttons]
        self.state["kb_on"] = True
        apply_zones(self.state)
        save_state(self.state)

    def build_fan_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        for m in ("margin_top", "margin_bottom", "margin_start", "margin_end"):
            getattr(box, f"set_{m}")(18)

        cur = read(f"{PS}/fan_speed", "0,0")
        try:
            cpu_cur, gpu_cur = (int(x) for x in cur.split(","))
        except Exception:
            cpu_cur, gpu_cur = 0, 0

        box.append(Gtk.Label(label="CPU fan (0 = auto)", xalign=0))
        self.cpu_scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
        self.cpu_scale.set_value(cpu_cur)
        box.append(self.cpu_scale)

        box.append(Gtk.Label(label="GPU fan (0 = auto)", xalign=0))
        self.gpu_scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
        self.gpu_scale.set_value(gpu_cur)
        box.append(self.gpu_scale)

        btn_row = Gtk.Box(spacing=8)
        auto_btn = Gtk.Button(label="Auto")
        auto_btn.connect("clicked", self.on_fan_auto)
        btn_row.append(auto_btn)
        apply_btn = Gtk.Button(label="Apply")
        apply_btn.connect("clicked", self.on_apply_fans)
        btn_row.append(apply_btn)
        box.append(btn_row)

        note = Gtk.Label(
            label="Values are a target %, not RPM. 0 hands control back to firmware.",
            wrap=True)
        note.add_css_class("dim-label")
        box.append(note)
        return box

    def on_fan_auto(self, _btn):
        self.cpu_scale.set_value(0)
        self.gpu_scale.set_value(0)
        self.on_apply_fans(_btn)

    def on_apply_fans(self, _btn):
        self.state["cpu_fan"] = int(self.cpu_scale.get_value())
        self.state["gpu_fan"] = int(self.gpu_scale.get_value())
        apply_fans(self.state)
        save_state(self.state)


class App(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="dev.subhajitroy.PredatorControl")

    def do_activate(self):
        Window(self).present()


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--apply-saved":
        apply_all(load_state())
        return
    App().run(None)


if __name__ == "__main__":
    main()

