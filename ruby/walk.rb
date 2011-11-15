class Walk
  attr_reader :orders, :ai, :targets

  def initialize(ai)
    @ai = ai
    @orders = {}
    @targets = {}
  end
  def not_taken?(loc)
    !@orders.has_key?(loc)
  end
  

  def move_location(ant_loc, dest)
    dirs = ant_loc.direction(dest)
    warn "directions : #{dirs}"
    dirs.each do |dir|
      if(move_direction(ant_loc, dir))
        warn "Move direction [#{ant_loc.row}, #{ant_loc.col}], #{dir}"
        targets[dest] = ant_loc
        return true
      else
        false
      end
    end
  end
  
  def move_direction(ant_loc, dir)
    new_loc = ant_loc.neighbor dir
    if(!new_loc.ant? && not_taken?(new_loc) && new_loc.land?)
      ant_loc.ant.order dir
      @orders[new_loc] = ant_loc
      true
    else
      false
    end
  end
  
  def walk
    @ai.my_ants.each do |ant|
      [:N, :E, :S, :W].each do |dir|
        break if move_direction(ant.square, dir)  
      end
    end
  end

  #This method updates heuristics for all the food squares in the map.
  def update_food_heuristics
    @ai.food_squares.each do |fs|
      fs.food_steps[fs] = 0
      need_update = fs.update_adjacent_scores(fs)
      while(nx = need_update.shift )
        need_update.concat nx.update_adjacent_scores(fs)
      end
    end
  end

  def astar_walk
    ants_moved = []
    all_moves = []

 #   warn "Before update visibility"
    @ai.my_ants.each do |ant|
#      warn "updating ant on square #{ant.row}, #{ant.col}"
      ant.square.update_approx_visibility(@ai.viewradius)
    end
    
  #  warn "Before update food heuristics"
    update_food_heuristics
  #  warn "Finished update food heuristics"
    
#    generate_html_map
#    warn "After html map"
    
    @ai.my_ants.each do |ant|
      all_moves.concat ant.square.adj_square_directions
    end
    
 #   warn all_moves.size
    all_moves.sort! do |a, b|
      a[0] <=> b[0]
    end

    all_moves.each do |num_steps, ant_square, food_square, dir|
      if(!targets[food_square] && move_direction(ant_square, dir))
        targets[food_square] = ant_square
        ants_moved << ant_square.ant
      end
    end

    unmoved_ants = @ai.my_ants - ants_moved
    #move randomly if you are not going after anything
    unmoved_ants.each do |ant|
      random_directions.each do |dir|
        break if move_direction(ant.square, dir)  
      end
    end
  end

  def generate_html_map
    $stderr.flush

    b = Builder::XmlMarkup.new(:indent => 2 )
    html = b.html {
      b.head {
        b.link("rel"=>"stylesheet", "href"=>"http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css")
      }
      b.body {
        b.table("class"=>"zebra-striped bordered-table") {
          0.upto(@ai.rows - 1).each do |row_num|
            b.tr {
              0.upto(@ai.cols - 1).each do |col_num|
                sq = @ai.map[row_num][col_num]
                food = sq.food_steps
                color = case
                        when (sq.ant? && sq.ant.mine?) then "violet"
                        when (sq.ant? && sq.ant.enemy?) then "red"
                        when (sq.water?) then "lightblue"
                        when (sq.food?) then "lightgreen"
                        when (sq.visible?) then "brown"
                        else "whiteSmoke"
                        end
                b.td({"style" => "background-color: #{color}"}){
                  food.each do |fs, num_steps|
                    b.br
                    b.span "[#{fs.row}, #{fs.col}] : #{num_steps}"
                  end
                }
              end   
            }
          end
        }
      }
    }
    warn "html is " + html
    $stderr.flush
    File.open("#{@ai.turn_number}.html", "w") do |f|
      f.write(html)
    end
  end
  
  def food_walk
    ant_dist = []
    @ai.food_squares.each do |fs|
      @ai.my_ants.each do |ant|
        dist = ant.square.distance(fs)
        ant_dist << [dist, ant.square, fs]
      end
      ant_dist.sort! do |a, b|
        a[0] <=> b[0]
      end
      ant_dist.each do |dist, ant_loc, food_loc|
        if (!@targets.keys.include?(food_loc) && !@targets.values.include?(ant_loc))
          move_location(ant_loc, food_loc)
        #  warn "Move location, #{ant_loc}, #{food_loc}"
        end
      end
    end
  end
  
  def random_directions
    dirs = [:N, :E, :S, :W]
    new_dirs = []
    while !dirs.empty?
      n = dirs[rand(dirs.size)]
      new_dirs << n
      dirs.delete(n)
    end
    new_dirs
  end
  
  def random_walk
    @ai.my_ants.each do |ant|
      random_directions.each do |dir|
        break if move_direction(ant.square, dir)  
      end
    end
  end
  
  def old_walk
    @ai.my_ants.each do |ant|
      # try to go north, if possible; otherwise try east, south, west.
      [:N, :E, :S, :W].each do |dir|
        if ant.square.neighbor(dir).land?
          ant.order dir
          break
        end
      end
    end
  end
end
