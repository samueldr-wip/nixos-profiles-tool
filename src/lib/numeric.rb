class Numeric
  SIZE_MAGNITUDES = {
    0 => "B",
    1 => "KiB",
    2 => "MiB",
    3 => "GiB",
  }

  def format_size()
    size = self
    magnitude = 0
    while size > 1024 and magnitude < SIZE_MAGNITUDES.keys.length
      magnitude += 1
      size /= 1024.0
    end

    "%1.2f%s" % [size, SIZE_MAGNITUDES[magnitude]]
  end
end
