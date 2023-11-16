class Profile
  attr_reader :name
  attr_reader :path

  def self.from_name(name, context: File.join($root, NIX_STATE_DIR))
    instance = self.new
    instance.instance_exec do
      @name = name
      @context = context
      @path = File.join(@context, "profiles", @name)
    end
    instance
  end

  def generations()
    return @generations if @generations

    @generations =
      Dir.glob("#{@path}-*-link")
      .map do |path|
        num = Generation::LINK_ID_REGEX.match(path)[1]

        [num, Generation.from_path(self, path)]
      end
      .sort { |a, b| a.first.to_i <=> b.first.to_i }
      .to_h
  end

  def current_generation()
    num = Generation::LINK_ID_REGEX.match(File.readlink(@path))[1]
    generations[num]
  end

  # Lists all known bootfiles, detached from their original generations.
  def boot_files()
    generations.values.reduce([]) do |list, generation|
      list + generation.boot_files
    end.sort.uniq
  end

  def to_serialized()
    {
      name: name,
      path: path,
      current_id: current_generation.id,
      generations: generations.map do |num, generation|
        [num, generation.to_serialized()]
      end.to_h
    }
  end

  private
  def init()
  end
end
