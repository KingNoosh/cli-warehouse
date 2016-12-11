class SimpleWarehouse

  def run
    @live = true
    puts 'Type `help` for instructions on usage'
    while @live
      print '> '
      input = gets.chomp
      command = ''
      if scan = input.scan(/[A-Za-z0-9]+/)
        command, *args = scan
      end
      case command
        when 'help'
          show_help_message
        when 'init'
          initialise_map args[0], args[1]
        when 'locate'
          locate_objects args[0]
        when 'remove'
          remove_object args[0], args[1]
        when 'store'
          store_object  args[0],
                        args[1],
                        args[2],
                        args[3],
                        args[4]
        when 'view'
          show_map
        when 'exit'
          exit
        else
          show_unrecognized_message
      end
    end
  end

  private
  attr_accessor :map_base
  attr_accessor :map_objects
  attr_accessor :map_w
  attr_accessor :map_h

  def get_object x, y
    if !x.nil? && !y.nil?
      if !@map_objects.nil?
        obj_index = nil
        @map_objects.each_with_index {
          |e, i|
          if x.between?(e[:x], e[:x]+e[:w]) && y.between?(e[:y], e[:y]+e[:h])
            obj_index = i
          end
        }
        obj_index
      else
        puts 'Please initialise the map first by running `init w h`.'
      end
    else
      show_missing_args_message ['x', 'y']
    end
  end

  def initialise_map w, h
    if !w.nil? && !h.nil?
      @map_w = w.to_i
      @map_h = h.to_i
      @map_base = Array.new(@map_w) { |i| i = Array.new(@map_h) { |i| i = '#' } }
      @map_objects = []
      puts "Initialised map #{@map_w}x#{@map_h}"
    else
      show_missing_args_message ['width', 'height']
    end
  end

  def locate_objects p
    if !w.nil?
      objects = []
      @map_objects.each {
        |e|
        if e[:p] === p
          objects.push e
        end
      }
    else
      show_missing_args_message ['product id']
    end
  end

  def remove_object x, y
    if !x.nil? && !y.nil?
      obj_index = get_object x.to_i, y.to_i
      puts obj_index
      if !obj_index.nil?
        @map_objects.delete_at obj_index
        puts "Deleted product at #{x},#{y}"
      else
        puts 'Product doesn\'t exist'
      end
    else
      show_missing_args_message ['x', 'y']
    end
  end

  def show_help_message
    puts  'help             Shows this help message.',
          'init W H         (Re)Initialises the application as a W x H warehouse, with all spaces empty.',
          'store X Y W H P  Stores a crate of product number P and of size W x H at position X,Y.',
          'locate P         Show a list of positions where product number can be found.',
          'remove X Y       Remove the crate at positon X,Y.',
          'view             Show a representation of the current state of the warehouse, marking each position as filled or empty.',
          'exit             Exits the application.'
  end

  def show_map
    if !@map_base.nil?
      map = Marshal.load(Marshal.dump(@map_base))
      @map_objects.each {
        |e|
        e[:h].times do |h|
          e[:w].times do |w|
            map[e[:y]+h][e[:x]+w] = e[:p]
          end
        end
      }
      map.each { |e| puts e.join }
    else
      puts 'Please initialise the map first by running `init w h`.'
    end
  end

  def store_object x, y, w, h, p
    if !x.nil? && !y.nil? && !w.nil? && !h.nil? && !p.nil?
      if !@map_base.nil?
        object = {
          :x => x.to_i,
          :y => y.to_i,
          :w => w.to_i,
          :h => h.to_i,
          :p => p
        }
        if !get_object(x.to_i, y.to_i).nil?
          puts 'Something already is here'
        elsif p.length != 1
          puts 'Product Id must be a single character'
        elsif x.to_i > @map_w || y.to_i > @map_h
          puts 'This position doesn\'t exist'
        elsif x.to_i + w.to_i > @map_w || y.to_i + h.to_i > @map_h
          puts 'Not enough space'
        else
          @map_objects.push object
          puts "Created object"
        end
      else
        puts 'Please initialise the map first by running `init w h`.'
      end
    else
      show_missing_args_message ['x', 'y', 'w', 'h', 'p']
    end
  end

  def show_missing_args_message args=[]
    puts "Missing arguments #{args.join(', ')}"
  end

  def show_unrecognized_message
    puts 'Command not found. Type `help` for instructions on usage'
  end

  def exit
    puts 'Thank you for using simple_warehouse!'
    @live = false
  end

end
