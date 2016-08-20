module OkCuGit
  class Finder
    attr_reader :repo_name,
                :raw_repo_name,
                :raw_contributors

    def initialize(repo_name)
      @raw_repo_name = repo_name.split("/").last
      @repo_name = convert_name(repo_name)
    end

    def convert_name(repo_name)
      "https://github.com/#{repo_name}.git"
    end

    def split_contributors(data)
      splited = strip_out_authors(data)
      splited.map do |data|
        split_authors_and_email(data)
      end
    end

    def split_authors_and_email(data)
      data.split(" ").reduce([]) do |result, data|
        if data.include?("<")
          result = ['"' + result.join(" ") + '"']
          result << data
        else
          result << data unless data.include?("Author")
        end
        result
      end
    end

    def strip_out_authors(data)
      data.reduce([]) do |result, data|
        result << data if data[0..5] == "Author"
        result
      end
    end

    def all_contributors
      clone_repo
      get_contributors
      contributors = split_contributors(raw_contributors.split("\n"))
      print_out_contributors(contributors)
      clear_temp_folder
    end

    def print_out_contributors(contributors)
      contributors.each do |contributor|
        puts "#{contributor[0]} #{contributor[1]}"
      end
    end

    def clear_temp_folder
      `rm -rf #{raw_repo_name}`
    end

    def clone_repo
      Dir.chdir("temp")
      `git clone #{repo_name}`
    end

    def get_contributors
      Dir.chdir("#{raw_repo_name}")
      @raw_contributors = `git log`
      Dir.chdir("..")
    end
  end
end

repo_name = ARGV[0]
finder = OkCuGit::Finder.new(repo_name)
finder.all_contributors
