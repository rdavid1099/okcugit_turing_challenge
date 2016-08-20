require 'minitest/autorun'
require 'minitest/pride'
require './lib/okcugit'

class TestOkCuGit < Minitest::Test
  def test_finder_exists
    finder = OkCuGit::Finder.new("test")

    assert_instance_of OkCuGit::Finder, finder
  end

  def test_finder_is_initialized_with_arguments
    finder = OkCuGit::Finder.new("test")

    assert_equal "https://github.com/test.git", finder.repo_name
  end

  def test_finder_converts_repo_name
    finder = OkCuGit::Finder.new("test")

    assert_equal "https://github.com/test.git",  finder.convert_name("test")
  end

  def test_it_splits_authors_and_emails
    finder = OkCuGit::Finder.new("test")

    assert_equal ['"Casey Ann Cumbow"', '<cumbow8@gmail.com>'], finder.split_authors_and_email("Author: Casey Ann Cumbow <cumbow8@gmail.com>")
  end
end
