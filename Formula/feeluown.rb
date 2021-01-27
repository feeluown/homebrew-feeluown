class Feeluown < Formula
  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/d9/a7/a55bf889a1aaa64bfb585205c9c9822be24b641fb2f37fbc06012d259ab7/feeluown-3.7.2.tar.gz"
  sha256 "255244a307807eebdd9d22672570925e7d440413a84ee40866cd8027340a2e6b"

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
