class Feeluown < Formula
  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/66/8a/9cdcbcf31c83659c80374124ff6efb9bd5ff6906187dfcae4c7681993c7e/feeluown-3.6.1.tar.gz"
  sha256 "757152007d82756909b22745ab0be77ed3c728570b0aaecc8d12230c6632fddb"

  depends_on "python@3.9"
  depends_on "pyqt5"
  depends_on "mpv"

  option "with-battery", "feeluown battery"
  option "with-qqmusic", "feeluown qqmusic plugin"
  option "with-kuwo", "feeluown kuwo plugin"
  option "with-xiami", "feeluown xiami plugin"
  option "with-netease", "feeluown netease plugin"
  option "with-local", "feeluown local plugin"

  def install
    _plugins = []
    _xiami = "fuo-xiami"
    _netease = "fuo-netease"
    _qqmusic = "fuo-qqmusic"
    _kuwo = "fuo-kuwo"
    _local = "fuo-local"
    _battery = [_xiami, _netease, _qqmusic, _kuwo, _local]

    if build.with? "battery"
      _plugins = _plugins + _battery
    else
      if build.with? "xiami"
        _plugins.push(_xiami)
      end
      if build.with? "netease"
        _plugins.push(_netease)
      end
      if build.with? "qqmusic"
        _plugins.push(_qqmusic)
      end
      if build.with? "local"
        _plugins.push(_local)
      end
      if build.with? "kuwo"
        _plugins.push(_kuwo)
      end
    end

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    # pip install feeluown[macos]
    system Formula["python@3.9"].opt_bin/"pip3", "install", buildpath/"[macos]",
           "--prefix", libexec

    # pip install fuo-xxx fuo-yyy ...
    system Formula["python@3.9"].opt_bin/"pip3", "install", *_plugins,
           "--prefix", libexec

    bin.install Dir[libexec/"bin/feeluown"]
    bin.install Dir[libexec/"bin/fuo"]

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"fuo", "--help"
    system bin/"feeluown", "--help"
  end
end
