class Compressor

  def self.compression_types
    types = [:gzip]
    types << :lz4 if Object.const_defined?('LZ4')
    types << :snappy if Object.const_defined?('Snappy')
    types
  end

  def self.compress(data, compression)
    case compression
      when :gzip
        Zlib::Deflate.deflate(data, Zlib::BEST_COMPRESSION)

      when :lz4
        raise ArgumentError, "Unavailable compression type : #{compression}" unless Object.const_defined?('LZ4')
        LZ4::compressHC(data)

      when :snappy
        raise ArgumentError, "Unavailable compression type : #{compression}" unless Object.const_defined?('Snappy')
        Snappy::compress(data)

      else
        data
    end
  end

  def self.decompress(data, compression)
    case compression
      when :gzip
        Zlib::Inflate.inflate(data)

      when :lz4
        raise ArgumentError, "Unavailable compression type : #{compression}" unless Object.const_defined?('LZ4')
        LZ4::uncompress(data)

      when :snappy
        raise ArgumentError, "Unavailable compression type : #{compression}" unless Object.const_defined?('Snappy')
        Snappy::uncompress(data)

      else
        data
    end
  end
end