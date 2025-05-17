module UrlHelper

    def get_filename_from_url(url)
      parts = url.to_s.split('/')
      return if parts.size < 2

      if parts[-2] == 'main'
        parts[-1]
      else
        File.join(parts[-2], parts[-1])
      end
    end

    def get_url_from_commit_id(clone_url, commit_id)
      format_clone_url = clone_url.to_s[0..-5] # Удалялем ".git"
      [format_clone_url, 'commit', commit_id.to_s].join('/')
    end

end
