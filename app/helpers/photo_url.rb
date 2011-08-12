require 'uri'

module PhotoUrl
  class Base
    icon_size = {small:"24x24", normal:"73x73", big:"240x240"}

    def Base.generate(user, options)
      # You need to name classes like so: ProviderPhotoUrl
      provider = user.provider
      klass =
        if provider
          provider.capitalize
        else
          "Local"
        end
      PhotoUrl.const_get(klass).new(user, options)
    end

    def initialize(user, options)
      @user, @options = user, options
    end

    define_method(:icon_size) do
      icon_size[@options[:size]]
    end

    def add_suffix_to_path(path, suffix)
      u     = URI.parse(path)
      ext   = File.extname(u.path)
      path.chomp(ext) << suffix + ext
    end
  end

  class Twitter < Base
    def path
      case @options[:size]
      when :small
        add_suffix_to_path(@user.remote_photo_url, "_normal")
      when :normal
        add_suffix_to_path(@user.remote_photo_url, "_bigger")
      when :big
        @user.remote_photo_url
      else
        raise "Invalid size option for photo_tag"
      end
    end
  end
  
  class Facebook < Base
    def path
      case @options[:size]
      when :small
        add_suffix_to_path(@user.remote_photo_url, "_q")
      when :normal
        add_suffix_to_path(@user.remote_photo_url, "_q")
      when :big
        add_suffix_to_path(@user.remote_photo_url, "_b")
      else
        raise "Invalid size option for photo_tag"
      end
    end
  end

  class Local < Base
    def path
      case @options[:size]
      when :small
        @user.photo.url(:thumb)
      when :normal
        @user.photo.url(:thumb)
      when :big
        @user.photo.url(:medium)
      else
        raise "Invalid size option for photo_url"
      end
    end
  end
end
  
