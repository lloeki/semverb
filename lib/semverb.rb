module SemveRB
  module_function

  SEMVER_RE = /
    (?<version_string>
      (?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)
      (?<extra>-(?<extra_name>.+)(?<extra_level>\d*)|)
    )
  /x
  CONST_RE = /
    (?<const>
      (?<module_name>
        (?:[A-Z][A-Za-z0-9_]*::)*
      )
      (?<const_name>[A-Z][A-Za-z0-9_]*)
    )
  /x

  def find_gemspec_version
    Dir['*.gemspec'].each do |f|
      File.read(f).each_line.with_index(1) do |l, i|
        if l =~ /\.version\s*=\s*["']#{SEMVER_RE}["']/
          return [f, i, $~[:version_string], :gemspec_version]
        end
      end
    end

    nil
  end

  def find_gemspec_version_const_name
    # look for gemspec version attr with a const in front
    Dir['*.gemspec'].each do |f|
      File.read(f).each_line.with_index(1) do |l, i|
        if l =~ /\.version\s*=\s*#{CONST_RE}/
          return [f, i, $~[:const_name], :gemspec_version_const_name]
        end
      end
    end

    nil
  end

  def find_gemspec_version_const
    _, _, const_name = find_gemspec_version_const_name

    # look for const name in files according to naming convention
    path = const_name
           .gsub('::', '/')
           .gsub(/[A-Z]/) { |m| "_#{m.downcase}" }
           .gsub(/\b_/, '')

    # pop each basename, going up
    while path != '.'
      Dir["lib/#{path}.rb"].each do |f|
        File.read(f).each_line.with_index(1) do |l, i|
          if l =~ /\b#{const_name}\s*=\s*["']#{semver_re}["']/
            return [f, i, $~[:version_string], :gemspec_version_const]
          end
        end
      end

      path = File.dirname(path)
    end

    # look for const name in all files in lib
    Dir['lib/**/*.rb'].each do |f|
      File.read(f).each_line.with_index(1) do |l, i|
        if l =~ /\b#{const_name}\s*=\s*["']#{SEMVER_RE}["']/
          return [f, i, $~[:version_string], :gemspec_version_const]
        end
      end
    end

    nil
  end

  def find_rb_version_const
    const_name = 'VERSION'

    # look for VERSION in files named `version.rb` in lib
    Dir['lib/**/version.rb'].each do |f|
      File.read(f).each_line.with_index(1) do |l, i|
        if l =~ /\b#{const_name}\s*=\s*["']#{SEMVER_RE}["']/
          return [f, i, $~[:version_string], :version_rb]
        end
      end
    end

    # look for VERSION in all files in lib
    Dir['lib/**/*.rb'].each do |f|
      File.read(f).each_line.with_index(1) do |l, i|
        if l =~ /\b#{const_name}\s*=\s*["']#{SEMVER_RE}["']/
          return [f, i, $~[:version_string], :version_const]
        end
      end
    end

    nil
  end
end
