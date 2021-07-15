class Feeluown < Formula
  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/0c/83/79911bfb32dc170eeec56e5c3b7ef73f059bbb7d4688073ff00e46d838ec/feeluown-3.7.10.tar.gz"
  sha256 "b7ded7932134a4c295d1f657089bbad9d27a4d8c0fde06c5eb68ade314ee277b"

  depends_on "python@3.9"
  depends_on "pyqt5"
  depends_on "mpv"

  option "with-battery", "feeluown battery"
  option "with-qqmusic", "feeluown qqmusic plugin"
  option "with-kuwo", "feeluown kuwo plugin"
  option "with-netease", "feeluown netease plugin"
  option "with-local", "feeluown local plugin"

  def install
    _plugins = []
    _netease = "fuo-netease"
    _qqmusic = "fuo-qqmusic"
    _kuwo = "fuo-kuwo"
    _local = "fuo-local"
    _battery = [_netease, _qqmusic, _kuwo, _local]

    if build.with? "battery"
      _plugins = _plugins + _battery
    else
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

    if _plugins
       # pip install fuo-xxx fuo-yyy ...
       system Formula["python@3.9"].opt_bin/"pip3", "install", *_plugins,
              "--prefix", libexec
    end

    bin.install Dir[libexec/"bin/feeluown"]
    bin.install Dir[libexec/"bin/fuo"]

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"fuo", "--help"
    system bin/"feeluown", "--help"
  end
end
