require 'minitest/autorun'
require 'semverb'

class TestSemveRB < MiniTest::Test
  def setup
    @starting_pwd = Dir.pwd
  end

  def teardown
    Dir.chdir(@starting_pwd)
  end

  def test_find_version_rb
    Dir.chdir('test/fixtures/version_rb')
    r = SemveRB.find_rb_version_const
    assert_equal(['lib/foo/version.rb', 2, '1.2.3', :version_rb], r)
  end

  def test_find_rb_version_const
    Dir.chdir('test/fixtures/version_const')
    r = SemveRB.find_rb_version_const
    assert_equal(['lib/some_dir/some_file.rb', 3, '1.2.3', :version_const], r)
  end

  def test_find_gemspec_version_const
    Dir.chdir('test/fixtures/gemspec_version_const')
    r = SemveRB.find_gemspec_version_const
    assert_equal(['lib/foo.rb', 2, '1.2.3', :gemspec_version_const], r)
  end

  def test_find_gemspec_version
    Dir.chdir('test/fixtures/gemspec_version')
    r = SemveRB.find_gemspec_version
    assert_equal(['foo.gemspec', 3, '1.2.3', :gemspec_version], r)
  end
end
