# A PseudoStore represent the flattened down store files copied to
# a boot partition, generally the ESP.
# 
# Different bootloader schemes within NixOS use different paths for
# their pseudo-stores.
class PseudoStore
  # Relative to the boot partition
  PSEUDOSTORES = [
    "kernels",   # grub
    "EFI/nixos", # systemd-boot
  ]

  # Relative to the boot partition
  attr_reader :path

  @@pseudostores = nil

  # Returns all pseudo-stores
  def self.all()
    return @@pseudostores if @@pseudostores

    @@pseudostores =
      PSEUDOSTORES.map do |path|
        instance = self.new
        instance.instance_exec do
          @path = File.join($root, $boot_partition, path)
        end
        instance
      end
  end

  def self.files()
    all
      .map { |store| store.files() }
      .flatten
      .compact
  end

  def files()
    if File.exists?(path)
      Dir.glob(File.join(path, "*"))
    else
      []
    end
  end

  # Returns the full paths to a filename found to be in any pseudo-store.
  def self.find(needle)
    all
      .map { |store| store.find(needle) }
      .compact
  end

  # Returns the full path to a filename presumed to be in the pseudo-store.
  # If the file is not found, nil is returned.
  def find(needle)
    qualified_path = File.join(@path, needle)
    if File.exists?(qualified_path)
      qualified_path
    else
      nil
    end
  end

  private
  def init()
  end
end
