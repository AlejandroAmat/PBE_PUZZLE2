require "gtk3"
require "thread"
require "puzzle1"
require "css"

css_provider = Gtk::CssProvider.new
style_prov = Gtk::StyleProvider::PRIORITY_USER
css_provider.load_from_path("stylesheet.css")


@rf= Rfid.new 
@window = Gtk::Window.new("Rfid Window")
@window.set_size_request(600, 150)
@window.set_border_width(5)
@window.style_context.add_provider(css_provider, style_prov)
@uid=""
@cyan = Gdk::RGBA::new(1.0,1.0,0,1.0)
@white = Gdk::RGBA::new(1.0,1.0,1.0,1.0)
@red = Gdk::RGBA::new(1.0,0,0,1.0)
@black =Gdk::RGBA::new(0,0,0,1.0)

@window_button = Gtk::Button.new(:label => "Please, login with your university card")

   @window_button.override_background_color(:normal, @cyan)
@window_button.override_color(:normal, @black)

@button = Gtk::Button.new(:label => "Clear")
@button.style_context.add_provider(css_provider, style_prov)

@fixed = Gtk::Fixed.new
@button.set_size_request(540,40)
@window_button.set_size_request(540,100)
@fixed.put(@window_button, 30,0)
@fixed.put(@button, 30,110)
@window.add(@fixed)




@button.signal_connect "clicked" do |_widget|
  if @uid!= ""
    
    @window_button.override_background_color(:normal, @cyan)
    @window_button.override_color(:normal, @black)
    @window_button.set_label("Please, login with your university card")
    @uid=""
    threads
  end
end
  

def threads
    thr = Thread.new {
    lectura
    puts "END THREAD"
    thr.exit
    
    }
end
threads

def lectura 
  puts "Autentificación requerida"
	@uid = @rf.read_uid   
	GLib::Idle.add{gestion_UI}
 
end

def gestion_UI
if @uid != ""
  @window_button.set_label(@uid)
  @window_button.override_background_color(:normal, @red)
  @window_button.override_color(:normal, @white)
end
end



@window.signal_connect("delete-event") { |_widget| Gtk.main_quit }
@window.show_all
Gtk.main


