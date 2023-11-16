class Generation
  LINK_ID_REGEX = /-(\d+)-link$/

  attr_reader :profile
  attr_reader :path

  def self.from_path(profile, path)
    instance = self.new
    instance.instance_exec do
      @profile = profile
      @path = path
    end
    instance
  end

  def id()
    LINK_ID_REGEX.match(path)[1]
  end

  def date()
    File.birthtime(path)
  end

  def store_path()
    File.readlink(path)
  end

  def bootspec()
    return @bootspec if @bootspec

    file = File.join(path, "boot.json")
    if File.exists?(file)
      @bootspec = JSON.parse(File.read(file))
    end

    @bootspec
  end

  def label()
    label =
      if bootspec
        bootspec["org.nixos.bootspec.v1"]["label"]
      else
        nil
      end

    label = File.basename(store_path).sub(/^[^-]+-/, "") unless label
    label
  end

  # File names likely copied to a flat "store" in the boot partition (e.g. ESP).
  def boot_files()
    boot_files = []

    if bootspec
      if bootspec["org.nixos.specialisation.v1"]
        specialisations = bootspec["org.nixos.specialisation.v1"]
        specialisations.each do |name, specialisation|
          boot_files << specialisation["org.nixos.bootspec.v1"]["initrd"]
          boot_files << specialisation["org.nixos.bootspec.v1"]["kernel"]
        end
      end
      v1 = bootspec["org.nixos.bootspec.v1"]
      if v1
        boot_files << v1["initrd"]
        boot_files << v1["kernel"]
      end
    end

    needle = File.join(path, "initrd")
    boot_files << File.readlink(needle) if File.exists?(needle)

    needle = File.join(path, "kernel")
    boot_files << File.readlink(needle) if File.exists?(needle)


    boot_files.compact.sort.uniq.map do |path|
      path.sub(%r{^#{NIX_STORE_DIR}/}, "").gsub("/", "-")
    end
  end

  def formatted_size_usage()
    files = boot_files_usage
    unique_usage = files[:unique].map do |path|
      File.size?(File.join($root, $boot_partition, "kernels", path)) || 0
    end
      .reduce(0, &:+)
    shared_usage = files[:shared].keys.map do |path|
      File.size?(File.join($root, $boot_partition, "kernels", path)) || 0
    end
      .reduce(0, &:+)

    size_usage = "(#{unique_usage.format_size()}+#{shared_usage.format_size()})"
  end

  def boot_files_usage()
    unique = []
    shared = {}

    boot_files.each do |file|
      profile.generations.each do |_, other|
        # Skip self
        next if other.id == self.id

        if other.boot_files.include?(file)
          shared[file] ||= []
          shared[file] << other.id
        end
      end

      unless shared[file]
        unique << file
      end
    end

    {
      unique: unique,
      shared: shared,
    }
  end

  def to_serialized()
    {
      profile: profile.path,
      path: path,
      store_path: store_path,
      date: date,
      label: label,
      boot_files: boot_files,
      boot_files_usage: boot_files_usage,
    }
  end

  private

  def init()
  end
end
