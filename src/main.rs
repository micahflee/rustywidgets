extern crate gtk;

use gtk::prelude::*;

fn main() {
    // Initialize the GTK app
    if gtk::init().is_err() {
        println!("Failed to initialize GTK.");
        return;
    }

    // Window
    let window = gtk::Window::new(gtk::WindowType::Toplevel);
    window.set_title("RustyWidgets");
    window.set_border_width(10);
    window.connect_delete_event(|_, _| {
        gtk::main_quit();
        Inhibit(false)
    });

    // Widgets
    let label = gtk::Label::new("[nothing yet]");
    let entry = gtk::Entry::new();

    // Layout
    let layout = gtk::Box::new(gtk::Orientation::Vertical, 10);
    layout.pack_start(&label, true, true, 10);
    layout.pack_start(&entry, false, false, 10);

    // Make the text entry update the label
    entry.connect_activate(move |e| {
        match e.get_text() {
            Some(text) => {
                e.set_text("");
                label.set_text(text.as_str());
            },
            None => {}
        }
    });

    // Start the GUI
    window.add(&layout);
    window.show_all();

    // When the window is closed, quit
    window.connect_delete_event(|_, _| {
        println!("closed window");
        gtk::main_quit();
        Inhibit(false)
    });

    gtk::main();
}
